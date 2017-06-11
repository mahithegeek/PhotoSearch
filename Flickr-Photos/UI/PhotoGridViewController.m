//
//  FirstViewController.m
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "FlickrImageService.h"
#import "PhotoCell.h"
#import "URLBuilder.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataStore.h"

@interface PhotoGridViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>{
    
}

@property(nonatomic)UIEdgeInsets sectionInsets;
@property(nonatomic)NSInteger itemsPerRow;
@property(nonatomic)PhotoSearchResult* searchResult;
@property(nonatomic,weak)IBOutlet UICollectionView* photoGridView;
@property(nonatomic,weak)IBOutlet UISearchBar* searchBar;
@property(nonatomic) UIActivityIndicatorView* loadingIndicator;
@property(nonatomic)BOOL isRequestInProgress;
@property(nonatomic)NSString* searchString;


@end


@implementation PhotoGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sectionInsets = UIEdgeInsetsMake(30, 10, 30, 10);
    self.itemsPerRow = 3;
    self.isRequestInProgress = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma search bar methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self addLoadingIndicator];
    self.searchString = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self performPhotoSearch:self.searchString];
}

-(void)addLoadingIndicator
{
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.loadingIndicator];
    [self.loadingIndicator hidesWhenStopped];
    [self.loadingIndicator startAnimating];
    
}

-(void)hideLoadingIndicator
{
    [self.loadingIndicator stopAnimating];
    [self.loadingIndicator removeFromSuperview];
}

-(void)performPhotoSearch : (NSString*)searchString
{
    if(searchString && searchString.length > 0)
    {
        [[DataStore sharedInstance] storeSearchString:searchString];
        self.isRequestInProgress = YES;
        FlickrImageService* dataProvider = [[FlickrImageService alloc] init];
        [dataProvider searchPhotosWithString:searchString completionHandler:^(PhotoSearchResult* searchResult,NSError* error){
            self.isRequestInProgress = NO;
            if(error != nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showError:error.localizedDescription];
                });
                
            }
            else{
                self.searchResult = searchResult;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoadingIndicator];
                    [self.photoGridView reloadData];
                });
            }
            
        }];
    }
    else{
        //throw error
        [self showError:@"Enter a valid search string"];
        
    }
    
}

-(void)showError:(NSString*)errorMessage
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"OOps Something Wrong!!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self hideLoadingIndicator];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark
#pragma collection view methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.searchResult){
        return self.searchResult.totalPhotos;
    }
    
    return 0;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if([self photosAvailableToShow:indexPath])
    {
        [cell.imageView sd_setImageWithURL:[[self.searchResult.photos objectAtIndex:indexPath.row] thumbNailURL] placeholderImage:[UIImage imageNamed:@"default_thumbnail"] options:SDWebImageProgressiveDownload];
    }
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:@"default_thumbnail.png"]];
    }
    
    return cell;
    
}

-(BOOL)photosAvailableToShow : (NSIndexPath*)indexPath
{
    return (self.searchResult.photos.count > indexPath.row);
}

 //fetch more photos depending on scrolling
/*-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    for (UICollectionViewCell *cell in [self.photoGridView visibleCells]) {
        NSIndexPath *indexPath = [self.photoGridView indexPathForCell:cell];
        NSLog(@"indexpath is %ld",(long)indexPath.row);
        if(self.searchResult.photos.count < indexPath.row && !self.isRequestInProgress)
        {
            //request for more photos
            NSLog(@"fetching more photos");
            [self addLoadingIndicator];
            NSLog(@"page fetched is %d",self.searchResult.currentPage);
            [self fetchPageForString:self.searchString pageToGet:self.searchResult.currentPage+1];
        }
    }
}*/

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchResult.photos.count < indexPath.row && !self.isRequestInProgress)
    {
        //request for more photos
        NSLog(@"indexpath is %ld",indexPath.row);
        NSLog(@"fetching more photos");
        [self addLoadingIndicator];
        NSLog(@"page fetched is %ld",self.searchResult.currentPage);
        [self fetchPageForString:self.searchString pageToGet:self.searchResult.currentPage+1];
       
        /*//for some weird reason page 2 returns null results for photos
        if(self.searchResult.currentPage == 1){
            [self fetchPageForString:self.searchString pageToGet:self.searchResult.currentPage+2];
        }
        else{
            [self fetchPageForString:self.searchString pageToGet:self.searchResult.currentPage+1];
        }*/
        
    }

}

-(void)fetchPageForString:(NSString*)searchString pageToGet:(NSInteger)page
{
    self.isRequestInProgress = YES;
    FlickrImageService* dataProvider = [[FlickrImageService alloc] init];
    [dataProvider getPhotosOfPage:searchString pageNumber:page completionHandler:^(PhotoSearchResult* searchResult,NSError* error){
        self.isRequestInProgress = NO;
        if(error != nil){
            [self showError:error.localizedDescription];
        }
        else{
            //[self.searchResult upda searchResult.photos];
            NSLog(@"photos received are %ld",searchResult.photos.count);
            [self.searchResult addMorePhotos:searchResult.photos];
            [self.searchResult updateCurrentPageNumber:searchResult.currentPage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoadingIndicator];
                [self.photoGridView reloadData];
            });
        }
    }];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat paddingSpace = self.sectionInsets.left * (self.itemsPerRow +1);
    CGFloat availableWidth = self.view.frame.size.width - paddingSpace;
    CGFloat widthPerItem = availableWidth / self.itemsPerRow;
    
    return CGSizeMake(widthPerItem, widthPerItem);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInsets;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.sectionInsets.left;
}



@end

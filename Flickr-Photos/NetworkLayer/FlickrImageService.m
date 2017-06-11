//
//  ImageDataProvider.m
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "FlickrImageService.h"
#import "AFNetworking.h"
#import "Photo.h"
#import "URLBuilder.h"

@interface FlickrImageService ()
{
    
}


@end

@implementation FlickrImageService

//API that searches the Flickr service
-(void)searchPhotosWithString:(NSString*)searchString completionHandler:(void (^)(PhotoSearchResult* searchResult,NSError* error))completionHandler
{
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&per_page=500&safe_search=1&text=",searchString];
    NSURL *url = [NSURL URLWithString:string];
    
    [self downloadDataFromURL:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        //NSLog(@"response is %@",response);
        if(response == nil){
            completionHandler(nil,error);
        }
        else{
            completionHandler([self parseResponseObject:responseObject],nil);
        }
        
    }];
    
}


-(void)getPhotosOfPage :(NSString*)searchString pageNumber:(NSInteger)pageToGet completionHandler:(void (^)(PhotoSearchResult* searchResult,NSError* error))completionHandler
{
    NSLog(@"page number is %ld",pageToGet);
    NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&per_page=500&page=",pageToGet,@"&format=json&nojsoncallback=1&safe_search=1&text=",searchString];
    NSLog(@"url is %@",string);
    NSURL *url = [NSURL URLWithString:string];
    
    [self downloadDataFromURL:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        //NSLog(@"response is %@",response);
        if(response == nil){
            completionHandler(nil,error);
        }
        else{
            completionHandler([self parseResponseObject:responseObject],nil);
        }
        
    }];
}

-(void)downloadDataFromURL :(NSURL*)url completionHandler:(void (^)(NSURLResponse *response,id responseObject, NSError* error))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        NSLog(@"received response from server is %@",response);
        completionHandler(response,responseObject,error);
        
    }];
    
    [downloadTask resume];
}

-(PhotoSearchResult*)parseResponseObject : (id)JSONResponse
{
    NSMutableArray* photosModel = [[NSMutableArray alloc] init];
    PhotoSearchResult* searchResult;
    @autoreleasepool {
        NSAssert([JSONResponse isKindOfClass:[NSDictionary class]],@"expected JSON dictionary");
        NSDictionary* photos = [JSONResponse valueForKey:@"photos"];
        NSAssert([photos isKindOfClass:[NSDictionary class]],@"expected JSON dictionary");
        NSArray* photosArray = photos[@"photo"];
        NSInteger pages = [photos[@"pages"] integerValue];
        NSInteger perPage = [photos[@"perpage"] integerValue];
        NSInteger total = [photos[@"total"] integerValue];
        NSInteger currentPage = [photos[@"page"] integerValue];
        
        for (NSString* photoJSON in photosArray) {
            Photo* newPhoto = [[Photo alloc] initWithJSON:photoJSON];
            [photosModel addObject:newPhoto];
        }
        searchResult = [[PhotoSearchResult alloc] initWithTotalPages:pages photosPerPage:perPage totalPhotos:total photosArray:photosModel currentPage:currentPage];
    }
    
    return searchResult;
}

@end

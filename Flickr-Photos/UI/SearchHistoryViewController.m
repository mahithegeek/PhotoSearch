//
//  SecondViewController.m
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "DataStore.h"

@interface SearchHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property(nonatomic)IBOutlet UITableView* searchHistoryView;
@property(nonatomic)NSArray* searchArray;

@end

@implementation SearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.searchArray = [DataStore getSearchHistory];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchArray = [[DataStore sharedInstance] getSearchHistory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma table view methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchArray)
    {
        return self.searchArray.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"historycell"];
    cell.textLabel.text = [self.searchArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end

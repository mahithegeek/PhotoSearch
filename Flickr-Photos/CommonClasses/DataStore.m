//
//  DataStore.m
//  Flickr-Photos
//
//  Created by Mahendra on 11/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "DataStore.h"

static DataStore* dataStore = nil;
@implementation DataStore


+(id)sharedInstance
{
    if(dataStore == nil){
        static dispatch_once_t gcdToken;
        dispatch_once(&gcdToken, ^{
            dataStore = [[DataStore alloc] init];
            
        });
    }
    
    return dataStore;
}

-(void)storeSearchString:(NSString*)searchString
{
    NSMutableArray* searchHistory = [[self getSearchHistory] mutableCopy];
    if(searchHistory){
        [searchHistory addObject:searchString];
    }
    else
    {
        searchHistory = [[NSMutableArray alloc] init];
        [searchHistory addObject:searchString];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchHistory forKey:@"searchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)getSearchHistory
{
    NSArray* searchHistory = [[NSUserDefaults standardUserDefaults] arrayForKey:@"searchHistory"];
    
    return searchHistory;
}

@end

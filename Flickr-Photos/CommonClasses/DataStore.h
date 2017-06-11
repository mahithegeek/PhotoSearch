//
//  DataStore.h
//  Flickr-Photos
//
//  Created by Mahendra on 11/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
{
    
}

+(id)sharedInstance;
-(void)storeSearchString:(NSString*)searchString;
-(NSArray*)getSearchHistory;

@end

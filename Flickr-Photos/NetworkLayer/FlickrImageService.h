//
//  ImageDataProvider.h
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoSearchResult.h"


@interface FlickrImageService : NSObject
{
    
}


-(void)searchPhotosWithString:(NSString*)searchString completionHandler:(void (^)(PhotoSearchResult* searchResult,NSError* error))completionHandler;

-(void)getPhotosOfPage :(NSString*)searchString pageNumber:(NSInteger)pageToGet completionHandler:(void (^)(PhotoSearchResult* searchResult,NSError* error))completionHandler;

@end

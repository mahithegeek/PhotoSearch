//
//  URLBuilder.h
//  Flickr-Photos
//
//  Created by Mahendra on 10/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface URLBuilder : NSObject
{
    
}

+(NSURL*)buildFlickrURLForPhoto:(Photo*)photo;

@end

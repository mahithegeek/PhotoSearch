//
//  URLBuilder.m
//  Flickr-Photos
//
//  Created by Mahendra on 10/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "URLBuilder.h"

@implementation URLBuilder

+(NSURL*)buildFlickrURLForPhoto:(Photo*)photo
{
    NSURL* photoURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"https://farm",photo.farm,@".staticflickr.com/",photo.server,@"/",photo.photoID,@"_",photo.secret,@".jpg"]];
    return photoURL;
}

@end

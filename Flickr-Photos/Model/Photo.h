//
//  Photo.h
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject{
    
}

-(instancetype)initWithJSON:(NSString*)modelJSON;
@property(nonatomic,readonly)NSString* photoID;
@property(nonatomic,readonly)NSString* server;
@property(nonatomic,readonly)NSString* farm;
@property(nonatomic,readonly)NSString* secret;
@property(nonatomic,readonly)NSURL* thumbNailURL;

@end

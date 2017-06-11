//
//  Photo.m
//  Flickr-Photos
//
//  Created by Mahendra on 09/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "Photo.h"
#import "URLBuilder.h"

@interface Photo(){
    
}

@property(nonatomic)NSString* photoID;
@property(nonatomic)NSString* server;
@property(nonatomic)NSString* farm;
@property(nonatomic)NSString* secret;
@property(nonatomic)NSURL* thumbNailURL;

@end
@implementation Photo
//TO-DO : refactor to remove if else...may be use a dictionary
-(instancetype)initWithJSON:(NSDictionary*)modelJSON{
    if(self = [super init]){
        if ( modelJSON) {
            for (NSString* key in modelJSON) {
                if([key isEqualToString:@"id"]){
                    _photoID = [modelJSON valueForKey:@"id"];
                }
                else if([key isEqualToString:@"server"]){
                    _server = [modelJSON valueForKey:@"server"];
                }
                else if([key isEqualToString:@"farm"]){
                    _farm = [modelJSON valueForKey:@"farm"];
                }
                else if([key isEqualToString:@"secret"]){
                    _secret = [modelJSON valueForKey:@"secret"];
                }
                [self buildThumbNailURL];
            }
        }
    }
    
    return self;
}

-(void)buildThumbNailURL
{
    self.thumbNailURL =  [URLBuilder buildFlickrURLForPhoto:self];
}

@end

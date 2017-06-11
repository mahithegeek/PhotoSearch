//
//  PhotoSearchResult.h
//  Flickr-Photos
//
//  Created by Mahendra on 11/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSearchResult : NSObject
{
    
}


@property(nonatomic,readonly)NSInteger totalPages;
@property(nonatomic,readonly)NSInteger photosPerPage;
@property(nonatomic,readonly)NSInteger totalPhotos;
@property(nonatomic,readonly)NSInteger currentPage;
@property(nonatomic,readonly)NSMutableArray* photos;


-(instancetype)initWithTotalPages:(NSInteger)totalPages photosPerPage:(NSInteger)photosPerPage totalPhotos:(NSInteger)totalPhotos photosArray:(NSMutableArray*)photos currentPage:(NSInteger)currentPage;

-(void)addMorePhotos:(NSMutableArray*)photos;
-(void)updateCurrentPageNumber : (NSInteger)pageNumber;
@end

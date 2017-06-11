//
//  PhotoSearchResult.m
//  Flickr-Photos
//
//  Created by Mahendra on 11/06/17.
//  Copyright © 2017 Kofax. All rights reserved.
//

#import "PhotoSearchResult.h"

@interface PhotoSearchResult ()
{
    
}

@property(nonatomic)NSInteger totalPages;
@property(nonatomic)NSInteger photosPerPage;
@property(nonatomic)NSInteger totalPhotos;
@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSMutableArray* photos;

@end

@implementation PhotoSearchResult

-(instancetype)initWithTotalPages:(NSInteger)totalPages photosPerPage:(NSInteger)photosPerPage totalPhotos:(NSInteger)totalPhotos photosArray:(NSMutableArray*)photos currentPage:(NSInteger)currentPage
{
    if(self = [super init])
    {
        _totalPages = totalPages;
        _photosPerPage = photosPerPage;
        _totalPhotos = totalPhotos;
        _photos = photos;
        _currentPage = currentPage;
    }
    
    return self;
}

-(void)addMorePhotos:(NSMutableArray*)photos
{
    [_photos addObjectsFromArray:photos];
}

-(void)updateCurrentPageNumber : (NSInteger)pageNumber
{
    _currentPage = pageNumber;
}

@end

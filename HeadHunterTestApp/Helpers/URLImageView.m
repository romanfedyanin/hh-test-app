//
//  URLImageView.m
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "URLImageView.h"

@implementation URLImageView

#pragma mark - Lifecycle

-(void)dealloc {
    [self cancelImageOperation];
}

#pragma mark - Setters

- (void)setImageURL:(NSString *)imageURL {
    
    if ([_imageURL isEqualToString:imageURL] && self.image)
        return;
    if(!imageURL.length)
        return;
    
    _imageURL = imageURL;
    [self reloadImage];
}

#pragma mark - Private methods

-(void)cancelImageOperation {
    self.image = nil;
    [_imageOperation cancel];
}

- (void)reloadImage {
    SDWebImageManager *sharedManager = SDWebImageManager.sharedManager;
    _imageOperation = [sharedManager downloadWithURL:[NSURL URLWithString:_imageURL]
                                             options:SDWebImageRetryFailed
                                            progress:nil
                                           completed:^(UIImage *image, NSError *error,
                                                       SDImageCacheType cacheType, BOOL finished) {
                                               if (image && finished) {
                                                   self.image = image;;
                                               }
                                           }];
}

#pragma mark - Public Methods

-(void)prepareForReuse {
    [self cancelImageOperation];
}

@end

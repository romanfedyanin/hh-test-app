//
//  URLImageView.h
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface URLImageView : UIImageView {
    id<SDWebImageOperation> _imageOperation;
}

@property(nonatomic, strong) NSString *imageURL;

-(void)prepareForReuse;

@end


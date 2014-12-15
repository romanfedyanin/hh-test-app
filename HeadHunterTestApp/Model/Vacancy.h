//
//  Vacancy.h
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 11/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vacancy : NSObject

@property (nonatomic, strong) NSString *vacancyId;
@property (nonatomic, strong) NSString *vacancyName;
@property (nonatomic, strong) NSString *employerName;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *employerLogoImageURL;

@end

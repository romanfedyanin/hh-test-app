//
//  SalaryStringBuilder.h
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 14/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalaryStringBuilder : NSObject

typedef void (^LoadingCompletionBlock)(void);
typedef void (^LoadingErrorBlock)(void);

+(SalaryStringBuilder*)sharedInstance;

-(void)loadCurrenciesDictionaryWithCompletionBlock:(LoadingCompletionBlock)completionBlock errorBlock:(LoadingErrorBlock)errorBlock;
-(NSString*)getStringFromSalaryDictionary:(NSDictionary*)dictionary;

@end

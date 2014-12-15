//
//  SalaryStringBuilder.m
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 14/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "SalaryStringBuilder.h"
#import "AFHTTPRequestOperation.h"
#import "Currency.h"

@implementation SalaryStringBuilder {
    NSArray *_currencies;
}

#pragma mark - Singleton

+(SalaryStringBuilder*)sharedInstance {
    static SalaryStringBuilder *salaryStringBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        salaryStringBuilder = [[self alloc] init];
    });
    return salaryStringBuilder;
}

#pragma mark - Public methods

//В идеале этот метод надо выносить в сетевую часть
-(void)loadCurrenciesDictionaryWithCompletionBlock:(LoadingCompletionBlock)completionBlock errorBlock:(LoadingErrorBlock)errorBlock {
    NSString *dictRequestURLString = [NSString stringWithFormat:@"https://api.hh.ru/dictionaries"];
    NSURL *dictRequestURL = [NSURL URLWithString:dictRequestURLString];
    NSURLRequest *dictRequest = [NSURLRequest requestWithURL:dictRequestURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:dictRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]])
            return;
        NSArray *currenciesArray = ((NSDictionary*)responseObject)[@"currency"];
        NSMutableArray *currenciesObjectsArray = [NSMutableArray array];
        for (NSDictionary *currencyDict in currenciesArray) {
            Currency *newCurrency = [[Currency alloc] init];
            newCurrency.abbr = NULL_TO_NIL(currencyDict[@"abbr"]);
            newCurrency.name = NULL_TO_NIL(currencyDict[@"name"]);
            newCurrency.code = NULL_TO_NIL(currencyDict[@"code"]);
            [currenciesObjectsArray addObject:newCurrency];
        }
        _currencies = currenciesObjectsArray;
        if (completionBlock)
            completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error && errorBlock)
            errorBlock();
    }];
    [operation start];
}

-(NSString*)getStringFromSalaryDictionary:(NSDictionary*)dictionary {
    NSMutableString *salaryString = [NSMutableString string];
    if (NULL_TO_NIL(dictionary[@"from"])) {
        [salaryString appendFormat:@"от %@ ", dictionary[@"from"]];
    }
    if (NULL_TO_NIL(dictionary[@"to"])) {
        [salaryString appendFormat:@"до %@ ", dictionary[@"to"]];
    }
    if (NULL_TO_NIL(dictionary[@"currency"])) {
        NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"code == %@", dictionary[@"currency"]];
        NSArray *filteredArray = [_currencies filteredArrayUsingPredicate:currencyPredicate];
        if (filteredArray.count != 1)
            return @"";
        Currency *currency = (Currency*)filteredArray[0];
        [salaryString appendString:currency.abbr];
    }
    return salaryString;
}

@end

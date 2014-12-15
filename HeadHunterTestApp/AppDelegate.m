//
//  AppDelegate.m
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}

@end

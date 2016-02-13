//
//  Web_API.m
//  FWWeatherApp
//
//  Created by hzkmn on 16/1/28.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "Web_API.h"

static Web_API *instance = nil;
static NSString * const kWeatherBaseURL = @"";

@implementation Web_API

+ (Web_API *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (NSString *)getRootURL
{
    return nil;
}

@end

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
    return @"http://so.gushiwen.org";
}

- (void)htmlDataWithURLString:(NSString*)urlString completionHandler:(void (^)(NSData * __nullable data,NSError * __nullable error))completionHandler
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (completionHandler) {
            completionHandler(data,error);
        }
    }];
    [dataTask resume];
}

@end

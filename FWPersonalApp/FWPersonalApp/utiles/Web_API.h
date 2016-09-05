//
//  Web_API.h
//  FWWeatherApp
//
//  Created by hzkmn on 16/1/28.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//
#import <Foundation/Foundation.h>

#define kDefaultKey @"book"
@interface Web_API : NSObject

NS_ASSUME_NONNULL_BEGIN
+ (Web_API *)sharedInstance;

- (NSString *)getRootURLForBook;

- (void)htmlDataWithURLString:(NSString*)urlString completionHandler:(void (^)(NSData * __nullable data,NSError * __nullable error))completionHandler;

NS_ASSUME_NONNULL_END
@end

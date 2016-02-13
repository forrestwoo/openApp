//
//  Web_API.h
//  FWWeatherApp
//
//  Created by hzkmn on 16/1/28.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Web_API : NSObject

+ (Web_API *)sharedInstance;

- (NSString *)getRootURL;

@end

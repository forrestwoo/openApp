//
//  NSString+ArrayForImage.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ArrayForImage)

NS_ASSUME_NONNULL_BEGIN

//搜索以begainString开头，endString结尾的中间字符串。
- (NSArray *)imageUrlsWithBeginString:(NSString *)begainString endString:(NSString *)endString;

//返回HTML中包含的json数据
- (NSData *) jsonDataWithBeginString:(NSString *)begainString;

NS_ASSUME_NONNULL_END

@end

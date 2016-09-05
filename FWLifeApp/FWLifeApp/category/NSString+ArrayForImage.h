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

- (NSArray *)imageUrlsWithBeginString:(NSString *)begainString endString:(NSString *)endString;

NS_ASSUME_NONNULL_END

@end

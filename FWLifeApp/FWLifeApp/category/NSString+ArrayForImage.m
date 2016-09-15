//
//  NSString+ArrayForImage.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "NSString+ArrayForImage.h"

@implementation NSString (ArrayForImage)

- (NSMutableArray *)imageUrlsWithBeginString:(NSString *)begainString endString:(NSString *)endString
{
    NSArray *arr = [self componentsSeparatedByString:begainString];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i < [arr count]; i++) {
        NSRange range = [[arr objectAtIndex:i] rangeOfString:endString];
        if(range.location == NSNotFound)
        {
            break;
        }
        NSString *tempString = [[arr objectAtIndex:i] substringWithRange:NSMakeRange(0, range.location+range.length)];
        [tempArr addObject:tempString];
    }
    
    return tempArr;
}

@end

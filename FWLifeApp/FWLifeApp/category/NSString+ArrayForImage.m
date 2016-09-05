//
//  NSString+ArrayForImage.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "NSString+ArrayForImage.h"

@implementation NSString (ArrayForImage)

- (NSArray *)imageUrlsWithBeginString:(NSString *)begainString endString:(NSString *)endString
{
    NSArray *arr = [self componentsSeparatedByString:begainString];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i < [arr count]; i++) {
        NSRange range = [[arr objectAtIndex:i] rangeOfString:endString];
        NSString *tempString = [[arr objectAtIndex:i] substringWithRange:NSMakeRange(0, range.location+range.length)];
        NSString *urlString = [tempString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"0.0.0.0.0.0.0%@",urlString);
        [tempArr addObject:tempString];
    }
    
    return [NSArray arrayWithArray:tempArr];
}
@end

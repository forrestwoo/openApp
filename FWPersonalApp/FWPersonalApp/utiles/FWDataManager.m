//
//  FWDataManager.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/18.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWDataManager.h"

@implementation FWDataManager

+ (NSDictionary *)getDataForPoetry
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict;
}

@end

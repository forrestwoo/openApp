//
//  FWDataManager.m
//  FWMeituApp
//
//  Created by hzkmn on 16/1/6.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "FWDataManager.h"

@implementation FWDataManager

+ (NSDictionary *)getDataSourceFromPlist
{
    NSString *plistPathString = [[NSBundle mainBundle] pathForResource:@"effectViewInfo" ofType:@"plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile:plistPathString];
}

@end

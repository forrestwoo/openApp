//
//  FWDataManager.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/18.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWDataManager.h"

@implementation FWDataManager

+ (NSDictionary *)getDataSourceFromPlist
{
    NSString *plistPathString = [[NSBundle mainBundle] pathForResource:@"effectViewInfo" ofType:@"plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile:plistPathString];
}


@end

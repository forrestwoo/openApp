//
//  RootDataModel.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/13.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "RootDataModel.h"

#import <objc/runtime.h>

@implementation RootDataModel

- (NSArray *)PropertyKeys
{
    unsigned int outCount,i;
    objc_property_t *pp = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
   
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = pp[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    
    return keys;
}

@end

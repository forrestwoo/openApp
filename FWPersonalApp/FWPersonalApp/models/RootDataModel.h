//
//  RootDataModel.h
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/13.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootDataModel : NSObject

//获取类的属性名称，以通过反射对对象的属性赋值。
- (NSArray *)PropertyKeys;

@end

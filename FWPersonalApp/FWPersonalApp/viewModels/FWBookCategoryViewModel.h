//
//  FWBookCategoryViewModel.h
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/25.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWBookCategoryViewModel : NSObject

- (instancetype)initWithUrlString:(NSString *)urlString;

@property (nonatomic, strong) NSDictionary *poetryDict;
@property (nonatomic, strong) NSArray *poetryType;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSArray *bookContents;


@end

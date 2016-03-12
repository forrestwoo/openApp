//
//  FWBookCategoryViewModel.m
//  FWPersonalApp
//
//  Created by hzkmn on 16/2/25.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWBookCategoryViewModel.h"
#import "TFHpple.h"

@implementation FWBookCategoryViewModel

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init])
    {
        self.urlString = urlString;
        self.poetryDict = [[NSDictionary alloc] init];
        self.poetryType = [[NSArray alloc] init];
        [self getDataFromUrl];
    }
    
    return self;
}

- (void)getDataFromUrl
{
    [[Web_API sharedInstance] htmlDataWithURLString:self.urlString completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
        TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
        NSArray *temp1 = [htmlParser searchWithXPathQuery:@"//div[@class='leftlei']/div[@class='son2']"];
        NSArray *temp2 = [htmlParser searchWithXPathQuery:@"//div[@class='shileft']/div[@class='bookcont']"];
        
        NSArray *elements = nil;
        [temp1 count] ? (elements = temp1) : (elements = temp2);
        
        if ([elements count])
        {
            NSMutableDictionary *poetryCategory = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSMutableArray *pt = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < [elements count]; i++)
            {
                TFHppleElement *element = [elements objectAtIndex:i];
                NSString *content = [element content];
                NSLog(@"content is ==========%@",content);
                NSLog(@"raw is ==========%@",[element raw]);
                NSLog(@"content is ==========%@",content);
                NSLog(@"raw is ==========%@",[element raw]);
                NSString *trimString = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *ttt = [trimString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"￥"];
//                NSLog(@"trimString is ==========%@",trimString);
//                NSLog(@"ttt is ==========%@",ttt);
                
                NSArray *arr = [trimString componentsSeparatedByString:@"："];
                //                NSLog(@"key is ==========%@",[arr objectAtIndex:0]);
                
                
                NSMutableArray *values = nil;
                NSString *ps = nil;
                NSString *theKey = nil;
                if ([arr count] > 1)
                {
                    theKey = [arr objectAtIndex:0];
                    [pt addObject:theKey];
                    ps = [arr objectAtIndex:1];
                }
                else
                {
                    ps = [arr objectAtIndex:0];
                    theKey = kDefaultKey;
                }
                
                values = [NSMutableArray arrayWithArray:[ps componentsSeparatedByString:@"\r\n"]];
                
                for (int m = 0; m < [values count]; m++) {
                    NSString *temps = [values objectAtIndex:m];
                    if ([temps isEqualToString:@""]) {
                        [values removeObjectAtIndex:m];
                    }
                }
                [poetryCategory setObject:values forKey:theKey];
            }
            self.poetryDict = [[NSDictionary alloc] initWithDictionary:poetryCategory];
            if ([pt count])
            {
                self.poetryType = [[NSArray alloc] initWithArray:pt];
            }
        }
    }];
}



@end

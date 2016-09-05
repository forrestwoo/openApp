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
        
        //获取典籍作者
        NSArray *elementsForAuthor = [htmlParser searchWithXPathQuery:@"//div[@class = 'son2']/p"];
        if ([elementsForAuthor count])
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < [elementsForAuthor count]; i++)
            {
                TFHppleElement *element = [elementsForAuthor objectAtIndex:i];
                
                NSString *key = [element content];
                NSString *obj = [element raw];
                NSLog(@"elementsForAuthor text is ==========%@",obj);
                NSLog(@"elementsForAuthor author is ==========%@",key);
                NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:key];
                [arr addObject:dict];
            }
//            self.bookContents = [[NSArray alloc] initWithArray:arr];
        }
        //获取典籍简介
        NSArray *elementsForIntroduce = [htmlParser searchWithXPathQuery:@"//div[@class = 'son2']"];
        if ([elementsForAuthor count])
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
           
                TFHppleElement *element = [elementsForIntroduce lastObject];
                
                NSString *key = [element content];
                NSString *obj = [element raw];
                NSLog(@"elementsForIntroduce is ==========%@",obj);
                NSLog(@"elementsForIntroduce introduction is ==========%@",key);
                NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:key];
                [arr addObject:dict];
            
            //            self.bookContents = [[NSArray alloc] initWithArray:arr];
        }
        //@"//div[@class='leftlei']/div[@class='son2']"
        //获取典籍目录
        NSArray *elementsForContent = [htmlParser searchWithXPathQuery:@"//span/a[@href]"];
        
        if ([elementsForContent count])
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < [elementsForContent count]; i++)
            {
                TFHppleElement *element = [elementsForContent objectAtIndex:i];
                
                NSString *key = [element content];
                NSString *obj = [element objectForKey:@"href"];
                NSLog(@"text is ==========%@",[element objectForKey:@"href"]);
                NSLog(@"content is ==========%@",[element content]);
                NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:key];
                [arr addObject:dict];
            }
            self.bookContents = [[NSArray alloc] initWithArray:arr];
        }
    }];
}



@end

//
//  FWImageCell.m
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/4.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import "FWImageCell.h"

@implementation FWImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGRect frame = self.bounds;
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,  frame.size.width, frame.size.height)];
        
        [self.contentView addSubview:self.myImageView];
    }
    
    return self;
}


@end

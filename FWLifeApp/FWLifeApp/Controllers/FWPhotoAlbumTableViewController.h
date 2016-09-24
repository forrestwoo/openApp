//
//  FWPhotoAblumTableViewController.h
//  FWLifeApp
//
//  Created by Forrest Woo on 16/9/23.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface FWPhotoAlbumTableViewController : UITableViewController
//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isCanSelectMorePhotos;
//当前已经选择的图片
//@property (nonatomic, strong) NSMutableArray<ZLSelectPhotoModel *> *arraySelectPhotos;

//选则完成后回调
//@property (nonatomic, copy) void (^DoneBlock)(NSArray<ZLSelectPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);
//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)();


@end

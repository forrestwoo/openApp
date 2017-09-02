//
//  AppDelegate.h
//  FWRestoAPP
//
//  Created by forrest on 2017/4/24.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <XMPPFramework/XMPPFramework.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, strong) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


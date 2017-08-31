//
//  LoginViewController.h
//  FWRestoAPP
//
//  Created by forrest on 2017/8/27.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;

@interface LoginViewController : UIViewController

@property (nonatomic, strong)  UIImageView *ivAvatar;
@property (nonatomic, strong)  UITextField *txUsername;
@property (nonatomic, strong)  UITextField *txPassword;
@property (nonatomic, strong)  UILabel *lbInfo;
@property (nonatomic, strong)  UIButton *btnLogin;
@property (nonatomic, strong)  UIButton *btnForgetPassword;
@property (nonatomic, strong)  UIButton *btnSignUp;
@end

//
//  LoginViewController.m
//  FWRestoAPP
//
//  Created by forrest on 2017/8/27.
//  Copyright © 2017年 forrest. All rights reserved.
//

#import "LoginViewController.h"

#import <XMPPFramework/XMPPFramework.h>

#import "XMPPManager.h"

@interface LoginViewController ()<XMPPManagerDelegate>
{
    XMPPManager *xmpp;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_default_view_mt-736.jpg"]];
    
    xmpp =[XMPPManager sharedManager];
    xmpp.delegate = self;
    
    self.txUsername = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    self.txUsername.placeholder = @"用户名";
    self.txUsername.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.txUsername];
    
    self.txPassword = [[UITextField alloc] initWithFrame:CGRectMake(100, 140, 200, 30)];
    self.txPassword.placeholder = @"密码";
    self.txPassword.secureTextEntry = YES;
    self.txPassword.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.txPassword];
    
    [self.txUsername becomeFirstResponder];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    self.btnLogin.frame = CGRectMake(100, 180, 200, 30);
    self.btnLogin.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.btnLogin];
    
    self.lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(100, 290, 260, 20)];
    self.lbInfo.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.lbInfo];
    
    self.btnForgetPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnForgetPassword addTarget:self action:@selector(forget:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnForgetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    self.btnForgetPassword.frame = CGRectMake(100, 220, 80, 30);
    self.btnForgetPassword.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.btnForgetPassword];
    
    self.btnSignUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnSignUp addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSignUp setTitle:@"新用户注册" forState:UIControlStateNormal];
    self.btnSignUp.frame = CGRectMake(235, 220, 80, 30);
    self.btnSignUp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.btnSignUp];
    
    NSString *un = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    NSString *ps = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyPassword];
    if (un.length != 0 || ps.length != 0) {
        [xmpp xmppLoginWithUserName:un password:ps];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.txUsername.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    self.txPassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
}

- (void)Field:(UITextField*)field forKey:(NSString *)key
{
    if (field != nil) {
        [[NSUserDefaults standardUserDefaults]setObject:field.text forKey:key];
    }
}

- (void)login:(id)sender
{
    if (self.txUsername.text.length != 0 && self.txPassword.text.length != 0) {
        
        [xmpp xmppLoginWithUserName:self.txUsername.text password:self.txPassword.text];
    }else{
        self.lbInfo.text = @"用户名或密码不能为空";
        double delayInSecond = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecond * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            self.lbInfo.text = nil;
        });
    }
}

- (void)ErrorString:(NSString *)errorString
{
    self.txPassword.text = @"";
    self.txUsername.text = @"";
    self.lbInfo.text = errorString;
}

- (void)forget:(id)sender
{
    
}

- (void)signUp:(id)sender
{
    if (self.txUsername.text.length != 0 && self.txPassword.text.length != 0) {
        
        [xmpp xmppRegisterWithUserName:self.txUsername.text password:self.txPassword.text];
    }else{
        self.lbInfo.text = @"用户名或密码不能为空";
        double delayInSecond = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecond * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            self.lbInfo.text = nil;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

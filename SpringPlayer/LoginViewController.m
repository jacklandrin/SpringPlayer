//
//  LoginViewController.m
//  SpringPlayer
//
//  Created by jack on 15/5/4.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController(){
    UIButton *_loginButton;
}

@end

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    [cancelBarButtonItem setTintColor:UI_COLOR_FROM_RGBA(0xccc437, 0.8)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    self.navigationItem.title = @"登录";
    
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, WINDOW_WIDTH - 20, 40)];
    [_usernameTextField setPlaceholder:@"请输入豆瓣用户名"];
    [_usernameTextField setTextColor:XDGRAY];
    [_usernameTextField setFont:[UIFont systemFontOfSize:12.5]];
    //[_usernameTextField setBackgroundColor:UI_COLOR_FROM_RGBA(0xccc437, 0.2)];
    _usernameTextField.layer.borderWidth = 1.0;
    _usernameTextField.layer.borderColor = UI_COLOR_FROM_RGBA(0xccc437, 0.2).CGColor;
    [_usernameTextField.layer setMasksToBounds:YES];
    [self.view addSubview:_usernameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 128, WINDOW_WIDTH - 20, 40)];
    [_passwordTextField setPlaceholder:@"请输入密码"];
    [_passwordTextField setSecureTextEntry:YES];
    [_passwordTextField setTextColor:XDGRAY];
    [_passwordTextField setFont:[UIFont systemFontOfSize:12.5]];
    //[_passwordTextField setBackgroundColor:UI_COLOR_FROM_RGBA(0xccc437, 0.2)];
    _passwordTextField.layer.borderWidth = 1.0;
    _passwordTextField.layer.borderColor =  UI_COLOR_FROM_RGBA(0xccc437, 0.2).CGColor;
    [_passwordTextField.layer setMasksToBounds:YES];
    [self.view addSubview:_passwordTextField];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 192, WINDOW_WIDTH, 44)];
    [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:UI_COLOR_FROM_RGBA(0xccc437, 0.4)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

-(void)cancelAction:(id)sender{
    [self.delegate loginViewControllerDidCancel:self];
}

-(void)loginAction:(UIButton*)button{
    [self.delegate loginViewControllerDidSave:self];
}

@end

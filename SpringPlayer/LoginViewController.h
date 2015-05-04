//
//  LoginViewController.h
//  SpringPlayer
//
//  Created by jack on 15/5/4.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

-(void)loginViewControllerDidCancel:(LoginViewController *)controller;
-(void)loginViewControllerDidSave:(LoginViewController *)controller;

@end

@interface LoginViewController : UIViewController

@property(nonatomic,strong) id <LoginViewControllerDelegate> delegate;
@property(nonatomic,strong) UITextField *usernameTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@end

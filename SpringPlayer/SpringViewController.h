//
//  ViewController.h
//  SpringPlayer
//
//  Created by jack on 15/5/2.
//  Copyright (c) 2015年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface SpringViewController : UIViewController<UIScrollViewDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    LoginViewControllerDelegate>


@end


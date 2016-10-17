//
//  LoginViewController.h
//  LUDE
//
//  Created by JHR on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic ,assign) BOOL initialInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnTitleRegister;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (nonatomic ,strong)NSDictionary *info;

@end

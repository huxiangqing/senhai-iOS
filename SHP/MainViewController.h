//
//  MainViewController.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//
/**
 *	@brief	主体逻辑框架
 */
#import <UIKit/UIKit.h>
#import "JKSideSlipView.h"
@interface MainViewController : UITabBarController
@property (strong ,nonatomic) JKSideSlipView *sideSlipView;
@end

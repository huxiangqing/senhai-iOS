//
//  TimeReminderViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//定时提醒
#import <UIKit/UIKit.h>

@interface TimeReminderViewController : UIViewController
/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender;
/**
 *	@brief	两个view数组
 */
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *TwoViewArr;


@end

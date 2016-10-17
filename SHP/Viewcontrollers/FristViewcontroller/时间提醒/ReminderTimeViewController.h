//
//  ReminderTimeViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderTimeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender;
/**
 *	@brief	添加
 */
- (IBAction)AddbtnClick:(UIButton *)sender;
/**
 *	@brief	表格
 */
@property (weak, nonatomic) IBOutlet UITableView *reminderTableView;

//吃药提醒，测量提醒
@property (strong ,nonatomic)NSString *remindTypeStr;
@end

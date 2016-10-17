//
//  NewRemindViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//新建提醒时间
#import <UIKit/UIKit.h>

@interface NewRemindViewController : UIViewController


/**
 *	@brief	标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *	@brief	区分是编辑还是添加
 */
@property (assign ,nonatomic)BOOL EditOrNOBOOL;

@property (strong ,nonatomic)NSString *remindTypeStr;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

//编辑时间
@property (strong ,nonatomic)NSMutableDictionary *dict;

@end

//
//  ReminderTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderTableViewCell : UITableViewCell
/**
 *	@brief	短线
 */
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
/**
 *	@brief	时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *	@brief	开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;

@end

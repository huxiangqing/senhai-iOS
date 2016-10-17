//
//  messageCell.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageCell : UITableViewCell

/**
 *	@brief	背景view
 */

@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 *	@brief	消息类型
 */

@property (nonatomic ,assign)MessageType type;

@property (weak, nonatomic) IBOutlet UIImageView *signBar;
/**
 *	@brief	消息的时间栏
 */

@property (weak, nonatomic) IBOutlet UILabel *messageDate;
/**
 *	@brief	消息内容栏
 */

@property (weak, nonatomic) IBOutlet UILabel *contentLable;
/**
 *	@brief	同意按钮
 */

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

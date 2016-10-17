//
//  MessageCenterTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterTableViewCell : UITableViewCell
/**
 *	@brief	消息标志
 */

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/**
 *	@brief	消息名称
 */

@property (weak, nonatomic) IBOutlet UILabel *titleName;
/**
 *	@brief	背景view
 */
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 *	@brief	红色圆点
 */
@property (weak, nonatomic) IBOutlet UIImageView *redOriginImageView;
@end

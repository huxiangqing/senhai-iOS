//
//  ScreeningTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningTableViewCell : UITableViewCell
/**
 *	@brief	背景
 */
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
/**
 *	@brief	时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *	@brief	对号
 */
@property (weak, nonatomic) IBOutlet UIImageView *okImageView;

@end

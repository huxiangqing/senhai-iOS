//
//  DataDetailCell.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/19.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataDetailCell : UITableViewCell
/**
 *	@brief	背景view
 */
@property (weak, nonatomic) IBOutlet UIView *backview;
/**
 *	@brief	时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *	@brief	空腹
 */
@property (weak, nonatomic) IBOutlet UILabel *fastingLabel;
/**
 *	@brief	非空腹
 */
@property (weak, nonatomic) IBOutlet UILabel *noFastingLabel;
/**
 *	@brief	血压
 */
@property (weak, nonatomic) IBOutlet UILabel *bloodPressureLabel;
/**
 *	@brief	脉搏
 */
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;

-(void)createMarr:(NSMutableArray *)marr index:(long)index;
@end

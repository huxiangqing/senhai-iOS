//
//  EquipmentCell.h
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentCell : UITableViewCell

/**
 *	@brief	背景view
 */

@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 *	@brief	设备标志图
 */

@property (weak, nonatomic) IBOutlet UIImageView *equipmentIcon;
/**
 *	@brief	设备名称
 */

@property (weak, nonatomic) IBOutlet UILabel *equipmentName;
/**
 *	@brief	设备上删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**
 *	@brief	cell上的竖条
 */
@property (weak, nonatomic) IBOutlet UIImageView *signBar;


//方法
-(void)CreateMarr:(NSMutableArray *)marr index:(long)index;
@end

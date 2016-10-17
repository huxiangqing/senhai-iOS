//
//  ThirdTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/12/2.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdTableViewCell : UITableViewCell
//背景
@property (weak, nonatomic) IBOutlet UIView *backView;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

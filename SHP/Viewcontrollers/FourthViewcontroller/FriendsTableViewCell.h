//
//  FriendsTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCView.h"
@interface FriendsTableViewCell : UITableViewCell
//圆环
@property (weak, nonatomic) IBOutlet UIView *ringBackView;
//圆环
@property (strong, nonatomic) IBOutlet UIView *ringView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//背景
@property (weak, nonatomic) IBOutlet UIView *backView;
//血压
@property (weak, nonatomic) IBOutlet UILabel *bloodPressureLabel;
//心跳
@property (weak, nonatomic) IBOutlet UILabel *heartbeatLabel;
//脉压差
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblBlood;
@property (strong, nonatomic) IBOutlet UILabel *lblHart;
@property (strong, nonatomic) IBOutlet UILabel *lblMaiYa;
@property (strong, nonatomic) IBOutlet UILabel *lblHealth;

-(void)friendMarr:(NSMutableArray *)marr index:(long)index;

@end

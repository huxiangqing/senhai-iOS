//
//  SecondTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/12/5.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *roundBackView;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *dataBackVIew;
@property (weak, nonatomic) IBOutlet UILabel *SDLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;

@end

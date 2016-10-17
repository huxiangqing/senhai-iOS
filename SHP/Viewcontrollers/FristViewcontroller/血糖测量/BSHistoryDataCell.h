//
//  BSHistoryDataCell.h
//  LUDE
//
//  Created by lord on 16/6/7.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSHistoryDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *roundBackView;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIView *dataBackVIew;
@property (weak, nonatomic) IBOutlet UILabel *BSmmolLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeQuantumLabel;

@end

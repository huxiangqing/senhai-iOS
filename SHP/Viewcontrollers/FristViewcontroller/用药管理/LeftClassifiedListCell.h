//
//  LeftClassifiedListCell.h
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftClassifiedListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftbarImage;
@property (weak, nonatomic) IBOutlet UILabel *classfieldNameLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

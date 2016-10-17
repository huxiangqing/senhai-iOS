//
//  BSHistoryDataCell.m
//  LUDE
//
//  Created by lord on 16/6/7.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "BSHistoryDataCell.h"

@implementation BSHistoryDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    UIViewSetRadius(self.roundBackView, 12.0, 1.0, [UIColor clearColor]);
}

@end

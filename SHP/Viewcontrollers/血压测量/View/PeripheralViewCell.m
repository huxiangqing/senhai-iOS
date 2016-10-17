//
//  PeripheralViewCell.m
//  LUDE
//
//  Created by JHR on 15/10/22.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "PeripheralViewCell.h"

@implementation PeripheralViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIViewSetRadius(self.peripheralLabel, 6.0, 1.0, [UIColor clearColor]);
}

@end

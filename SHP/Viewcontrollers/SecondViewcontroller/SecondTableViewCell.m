//
//  SecondTableViewCell.m
//  LUDE
//
//  Created by bluemobi on 15/12/5.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "SecondTableViewCell.h"

@implementation SecondTableViewCell

- (void)awakeFromNib {
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

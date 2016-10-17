//
//  MessageCenterTableViewCell.m
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell

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
    
    self.backView.layer.cornerRadius = 8.0;
    self.backView.clipsToBounds      = YES;
}
@end

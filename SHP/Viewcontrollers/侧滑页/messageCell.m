//
//  messageCell.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "messageCell.h"

@implementation messageCell

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
    UIViewSetRadius(_okButton, 8.0, 1.0, [UIColor clearColor]);
    
    if (self.type == SystemM)
    {
        [self.signBar setImage:[UIImage imageNamed:@"shuhong"]];
    }
    if (self.type == FriendsM)
    {
        [self.signBar setImage:[UIImage imageNamed:@"HDIcon"]];
        _okButton.hidden =NO;
//        _contentLable.text =@"老爸请求添加你为好友";
//        _messageDate.text = @"2015-08-13";
        for (UIView *subView in self.subviews)
        {
            if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                ((UIView *)[subView.subviews firstObject]).backgroundColor = RGBCOLOR(27.0, 203.0, 142.0);
            }
        }
    }
}

@end

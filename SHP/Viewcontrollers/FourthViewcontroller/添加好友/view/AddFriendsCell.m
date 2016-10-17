//
//  AddFriendsCell.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AddFriendsCell.h"

@implementation AddFriendsCell

- (void)awakeFromNib {
    // Initialization code
    [_addFriendButton setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [_reasonLabel setText:NSLocalizedString(@"Request Add Friend", nil)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *	@brief	添加按钮点击事件
 */

- (IBAction)operationBtnSelected:(UIButton *)sender {
    
    self.acceptBtnSelected(self.itemIndex);
    
}
@end

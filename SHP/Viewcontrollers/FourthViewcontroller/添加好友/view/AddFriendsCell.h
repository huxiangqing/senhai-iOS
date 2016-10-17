//
//  AddFriendsCell.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsCell : UITableViewCell

/**
 *	@brief	好友头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
/**
 *	@brief	好友名字
 */
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
/**
 *	@brief	请求添加好友文字
 */
@property (strong, nonatomic) IBOutlet UILabel *reasonLabel;
/**
 *	@brief	添加好友block
 */
@property (nonatomic, copy) void (^acceptBtnSelected)(NSInteger itemIndex);
/**
 *	@brief	好友的index
 */
@property (nonatomic ,assign) NSInteger itemIndex;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

/**
 *	@brief	添加按钮点击事件
 */
- (IBAction)operationBtnSelected:(UIButton *)sender;
@end

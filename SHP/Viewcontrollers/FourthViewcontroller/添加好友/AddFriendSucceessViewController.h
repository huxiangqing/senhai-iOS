//
//  AddFriendSucceessViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/19.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//添加好友成功或者失败
#import <UIKit/UIKit.h>

@interface AddFriendSucceessViewController : UIViewController
/**
 *	@brief	是否成功文本
 */
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
/**
 *	@brief	是否成功图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (assign ,nonatomic)BOOL YesOrNoBOOL;

@property (nonatomic ,copy)NSString *msg;
@end

//
//  FriendsMessageViewController.h
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//消息列表页

#import <UIKit/UIKit.h>

@interface FriendsMessageViewController : UIViewController
/**
 *	@brief	消息列表试图
 */

@property (weak, nonatomic) IBOutlet UITableView *addFriendsTable;
/**
 *	@brief	标题栏
 */

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**
 *	@brief	消息类型
 */

@property (nonatomic ,assign)MessageType type;

/**
 *	@brief	标题名称
 */

@property (nonatomic ,copy)NSString *titleText;

//区分 系统消息，留言消息，好友请求
@property (strong ,nonatomic)NSString *typeStr;
@end

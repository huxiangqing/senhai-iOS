//
//  MessageCenterViewController.h
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//消息中心
#import <UIKit/UIKit.h>

@interface MessageCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
/**
 *	@brief	消息列表试图
 */
@property (weak, nonatomic) IBOutlet UITableView *messageTable_UITableView;
@end

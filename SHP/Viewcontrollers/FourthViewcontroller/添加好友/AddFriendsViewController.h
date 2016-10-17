//
//  AddFriendsViewController.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *	@brief	搜索好友输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/**
 *	@brief	显示搜出结果的列表
 */
@property (weak, nonatomic) IBOutlet UITableView *friendsTable;

/**
 *	@brief  扫一扫点击事件
 */
- (IBAction)scanCodes:(UIButton *)sender;

@end

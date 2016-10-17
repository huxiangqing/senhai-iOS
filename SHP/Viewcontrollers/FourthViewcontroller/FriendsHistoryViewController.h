//
//  FriendsHistoryViewController.h
//  LUDE
//
//  Created by bluemobi on 15/12/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//朋友历史界面
#import <UIKit/UIKit.h>

@interface FriendsHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy) NSString *friendId;
@end

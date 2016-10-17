//
//  FriendsDetailsViewController.h
//  LUDE
//
//  Created by bluemobi on 15/12/4.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//好友详情
#import <UIKit/UIKit.h>

@interface FriendsDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

//好友ID
@property (strong ,nonatomic)NSString *friendsId;
@property (strong ,nonatomic)NSDictionary *friendsDetailsDict;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

//
//  FourthViewcontroller.h
//  LUDE
//
//  Created by bluemobi on 15/12/1.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthViewcontroller : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *friends_TableView;

@end

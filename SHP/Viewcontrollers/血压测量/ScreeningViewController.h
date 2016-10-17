//
//  ScreeningViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//筛选数据
#import <UIKit/UIKit.h>

@interface ScreeningViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender;
/**
 *	@brief	表格
 */
@property (weak, nonatomic) IBOutlet UITableView *screenTableView;
/**
 *	@brief	确定
 */
- (IBAction)SureBtnClick:(UIButton *)sender;
/**
 *	@brief	区分血糖／血压
 */
@property (assign ,nonatomic) BOOL BloodBlucoseBOOL;

@end

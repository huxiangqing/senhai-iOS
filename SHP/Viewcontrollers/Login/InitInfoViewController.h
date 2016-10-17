//
//  InitInfoViewController.h
//  LUDE
//
//  Created by JHR on 15/10/15.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitInfoViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
/**
 *	@brief	名字TF
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**
 *	@brief	大滚动背景
 */
@property (weak, nonatomic) IBOutlet UIScrollView *myInfoScrollView;
/**
 *	@brief	生日
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *	@brief	身高View
 */
@property (weak, nonatomic) IBOutlet UIView *heightView;
/**
 *	@brief	身高
 */
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
/**
 *	@brief	体重View
 */
@property (weak, nonatomic) IBOutlet UIView *weightView;
/**
 *	@brief	体重label
 */
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

/**
 *	@brief	电话号码
 */
@property (strong ,nonatomic)NSString *phoneNum;
/**
 *	@brief	第三方登录的标识
 */
@property (nonatomic ,copy)NSString *thirdPartUID;
@property (nonatomic ,copy)NSString *weiChatOrWeiBO;
@property (nonatomic ,strong)NSDictionary *info;

@end

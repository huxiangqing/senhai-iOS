//
//  EditInfoViewController.h
//  LUDE
//
//  Created by JHR on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//个人资料
#import <UIKit/UIKit.h>

@interface EditInfoViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
/**
 *	@brief	大背景滚动视图
 */
@property (weak, nonatomic) IBOutlet UIScrollView *myInfoScrollView;
/**
 *	@brief	姓名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**
 *	@brief	生日
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *	@brief	性别
 */
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
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
 *	@brief	体重
 */
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;



@end

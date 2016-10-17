//
//  ManualBloodPressureViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//手动添加血压
#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface ManualBloodPressureViewController : UIViewController<UITextFieldDelegate>
/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender;
/**
 *	@brief  保存
 */
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)PreservationBtnClick:(UIButton *)sender;

/**
 *	@brief  输入框集合
 */
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldArr;
/**
 *	@brief	时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
/**
 *	@brief	时间按钮点击事件
 */
- (IBAction)TimeBtnClick:(UIButton *)sender;


@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic ,copy)NSString *SerialNo ;

@end

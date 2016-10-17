//
//  MyQRCodeViewController.h
//  LUDE
//
//  Created by JHR on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQRCodeViewController : UIViewController
/**
 *	@brief	标题栏
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**
 *	@brief	标题名称
 */
@property (nonatomic ,copy) NSString *titleName;
/**
 *	@brief	生成二维码的账户信息
 */
@property (nonatomic ,copy) NSString *accountToken;

@end

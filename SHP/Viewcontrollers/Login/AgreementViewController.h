//
//  AgreementViewController.h
//  LUDE
//
//  Created by JHR on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UIViewController

/**
 *	@brief	是否同意协议内容
 */

@property (nonatomic, copy) void (^agreeOrDisagree )(BOOL agree);


@end

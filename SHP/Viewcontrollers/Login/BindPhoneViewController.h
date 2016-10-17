//
//  BindPhoneViewController.h
//  LUDE
//
//  Created by JHR on 15/10/28.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindPhoneViewController : UIViewController

/**
 *	@brief	第三方登录的标识
 */
@property (nonatomic ,copy)NSString *thirdPartUID;
@property (nonatomic ,copy)NSString *weiChatOrWeiBO;

@property (nonatomic ,strong)NSDictionary *info;


@end

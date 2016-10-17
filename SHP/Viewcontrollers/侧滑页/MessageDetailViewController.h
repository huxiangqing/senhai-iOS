//
//  MessageDetailViewController.h
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController

/**
 *	@brief	消息类型
 */
@property (weak, nonatomic) IBOutlet UIWebView *MessageDetailWebView;
/**
 *	@brief	消息类型
 */
@property (nonatomic ,assign) MessageType typeMessage;

@property (strong,nonatomic)NSString *messageIdStr;
@end

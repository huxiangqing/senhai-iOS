//
//  WebViewController.h
//  LUDE
//
//  Created by JHR on 15/11/19.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
/**
 *	@brief UIWebView
 */
@property (weak, nonatomic) IBOutlet WKWebView *webView;
/**
 *	@brief 链接地址
 */
@property (nonatomic, strong) NSURL *Linkurl;
@property (nonatomic ,copy) NSString *TitleName;


@end

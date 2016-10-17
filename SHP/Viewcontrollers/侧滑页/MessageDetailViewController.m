//
//  MessageDetailViewController.m
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblMessageDetail;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblMessageDetail setText:NSLocalizedString(@"Message Detail", nil)];
    NSString *str=[NSString stringWithFormat:@"%@app/sysMessage/getSysMessageById.htm?messageId=%@",SERVER_DEMAIN,_messageIdStr];
    [_MessageDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

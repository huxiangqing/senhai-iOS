//
//  AboutLudeViewController.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AboutLudeViewController.h"

@interface AboutLudeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblAboutLude;

@end

@implementation AboutLudeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblAboutLude setText:NSLocalizedString(@"About HONSUN", nil)];
    NSString *str=[NSString stringWithFormat:@"%@app/aboutUs/showAboutUs.htm",SERVER_DEMAIN];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    [request setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    [_aboutLudeWebView loadRequest:request];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

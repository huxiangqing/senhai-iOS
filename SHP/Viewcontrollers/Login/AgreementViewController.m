//
//  AgreementViewController.m
//  LUDE
//
//  Created by JHR on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblRegisterProtocol;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UIButton *btnNotAgree;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_lblRegisterProtocol setText:NSLocalizedString(@"Service and Privacy Policy", @"注册协议")];
    [_btnAgree setTitle:NSLocalizedString(@"Agree", @"同意") forState:UIControlStateNormal];
    [_btnNotAgree setTitle:NSLocalizedString(@"Disagree", @"不同意") forState:UIControlStateNormal];
   
//    使用NSSearchPathForDirectoriesInDomains获取指定路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"privatepolicy" ofType:@"txt"];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _textview.text =contents;
    
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
/**
 *	@brief	同意按钮 点击事件
 */
- (IBAction)agreeBtnSelected:(id)sender
{
    self.agreeOrDisagree(YES);
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	不同意按钮 点击事件
 */
- (IBAction)disagreeBtnSelected:(id)sender
{
    self.agreeOrDisagree(NO);
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

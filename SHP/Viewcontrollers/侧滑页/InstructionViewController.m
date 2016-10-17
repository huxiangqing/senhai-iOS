//
//  InstructionViewController.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblInstruction;

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblInstruction setText:NSLocalizedString(@"Instruction", nil)];
    NSString *str=[NSString stringWithFormat:@"%@app/useInstructions/showUseInstructions.htm",SERVER_DEMAIN];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    [request setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    
    [_instructionWebView loadRequest:request];
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

//
//  ThirdDetailsViewController.m
//  LUDE
//
//  Created by bluemobi on 15/12/5.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "ThirdDetailsViewController.h"

@interface ThirdDetailsViewController ()<UINavigationControllerDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *detailsWebView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;

@end

@implementation ThirdDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"Expert Advices-Info", nil)];
    self.navigationController.delegate = self;
    NSString *str=[NSString stringWithFormat:@"%@app/articleInfo/showContent.htm?articleId=%@",SERVER_DEMAIN,_articleIdStr];
    [_detailsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    [Tools dismiss];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Tools show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Tools dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Tools dismiss];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

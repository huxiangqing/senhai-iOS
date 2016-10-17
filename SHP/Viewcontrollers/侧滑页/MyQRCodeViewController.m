//
//  MyQRCodeViewController.m
//  LUDE
//
//  Created by JHR on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "QRCodeGenerator.h"

@interface MyQRCodeViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>
//二维码
@property (weak, nonatomic) IBOutlet UIImageView *codeImage_UIImageView;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;


@end

@implementation MyQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_titleLable setText:NSLocalizedString(@"My QR", nil)];
    [_scanLabel setText:NSLocalizedString(@"Scan the QR Code to add Friend", nil)];
    self.navigationController.delegate =self;
    _codeImage_UIImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_codeImage_UIImageView setUserInteractionEnabled:YES];
    UIImage *image = [QRCodeGenerator qrImageForString:self.accountToken imageSize:117.0];
    [_codeImage_UIImageView setImage:image];
}
-(void)viewDidLayoutSubviews
{

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
}

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

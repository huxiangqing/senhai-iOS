//
//  AddFriendSucceessViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/19.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AddFriendSucceessViewController.h"
#import "MainViewController.h"

@interface AddFriendSucceessViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;

@end

@implementation AddFriendSucceessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"Discover Friend", nil)];
    [_btnOk setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    [_textLabel setText:NSLocalizedString(@"Discover Friend Succeed", nil)];
    
    [self createUI];
}
-(void)createUI
{
     _textLabel.text = self.msg;
    if (_YesOrNoBOOL == YES)
    {//失败
        _ImageView.image =[UIImage imageNamed:@"check-off"];
    }
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *	@brief	确定按钮 点击事件
 */
- (IBAction)OKBtnClick:(UIButton *)sender
{
    [self gotoMainView];
}

@end

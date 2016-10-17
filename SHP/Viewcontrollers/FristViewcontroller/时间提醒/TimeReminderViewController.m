//
//  TimeReminderViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "TimeReminderViewController.h"
#import "ReminderTimeViewController.h"
@interface TimeReminderViewController ()<UINavigationControllerDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *lblTimeReminder;

@end

@implementation TimeReminderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTimeReminder setText:NSLocalizedString(@"ALARM", nil)];
    self.navigationController.delegate =self;

    //处理视图
    [self createTwoView];
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
-(void)createTwoView
{
    for (int i = 0; i < [_TwoViewArr count]; i++)
    {
        UIView *view =_TwoViewArr[i];
        view.layer.masksToBounds =YES;
        view.layer.cornerRadius =10;
        //手势点击
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TwoTapGestureRecognizer:)];
        [view addGestureRecognizer:tap];
    }
}

-(void)TwoTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    ReminderTimeViewController *Start=[[ReminderTimeViewController alloc]initWithStoryboardID:@"ReminderTimeViewController"];
    if (tap.view.tag==1)
    {//吃药提醒
        Start.remindTypeStr = @"1";
    }else
    {//测量提醒
        Start.remindTypeStr = @"2";
    }
    [self.navigationController pushViewController:Start animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

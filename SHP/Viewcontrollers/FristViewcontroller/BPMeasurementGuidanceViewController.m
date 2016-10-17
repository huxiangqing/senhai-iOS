//
//  BPMeasurementGuidanceViewController.m
//  LUDE
//
//  Created by bluemobi on 15/12/4.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "BPMeasurementGuidanceViewController.h"
#import "BloodRressureMonitoringViewController.h"
#import "ManualBloodPressureViewController.h"

@interface BPMeasurementGuidanceViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UIButton *btnStarMeasure;

@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation BPMeasurementGuidanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NTAccount shareAccount] setFirstGuide:@"NotFirstGuide"];
//    血压测量指导；

    [_btnStarMeasure setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [self createUI];
    
    if (_titleStr.length>0)
    {
        self.titleLabel.text =_titleStr;
    }
    
}


/**
 *	@brief	 界面测量指导页创建
 */
-(void)createUI
{
    NSArray *arr =[NSArray arrayWithObjects:@"xin-zhidao1",@"xin-zhidao2",@"xin-zhidao3",@"xin-zhidao4",@"xin-zhidao5", nil];
    for (int i =0; i < [arr count]; i++)
    {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.widthValue, 0, self.view.widthValue, self.view.heightValue-150)];
        imageView.image =[UIImage imageNamed:arr[i]];
        [_backView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	 开始测量按钮点击事件
 */
- (IBAction)startBPMeasure:(UIButton *)sender {
    BloodRressureMonitoringViewController *Blood= [[BloodRressureMonitoringViewController alloc] initWithSecondStoryboardID:@"BloodRressureMonitoringViewController"];
    Blood.isFromMianView = YES;
    [self.navigationController pushViewController:Blood animated:YES];
}

@end

//
//  RiskGuideVC.m
//  LUDE
//
//  Created by lord on 16/4/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "RiskGuideVC.h"

@interface RiskGuideVC ()
{
    __weak IBOutlet UILabel *issueLabel;
    __weak IBOutlet UILabel *doTitleLabel;
    __weak IBOutlet UILabel *summaryLabel;
    __weak IBOutlet UIButton *startBtn;
}
@end

@implementation RiskGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillLayoutSubviews
{
    [self createUI];
}
-(void)createUI
{
    [summaryLabel setFont:[Tools expectedLabelSizeFromString:summaryLabel.text maxSize:CGSizeMake(startBtn.widthValue, startBtn.topValue - doTitleLabel.bottomValue - 30.0)]];
    // [summaryLabel setAdjustsFontSizeToFitWidth:YES];
    [doTitleLabel setFont:[Tools expectedLabelSizeFromString:doTitleLabel.text maxSize:CGSizeMake(startBtn.widthValue,doTitleLabel.heightValue)]];
    [issueLabel setFont:[Tools expectedLabelSizeFromString:issueLabel.text maxSize:CGSizeMake(startBtn.widthValue, issueLabel.heightValue)]];
}
- (IBAction)startTestTheRisk:(UIButton *)sender {
    
    self.testTheRisk();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

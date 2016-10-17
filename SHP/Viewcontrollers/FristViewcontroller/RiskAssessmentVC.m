//
//  RiskAssessmentVC.m
//  LUDE
//
//  Created by lord on 16/4/26.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "RiskAssessmentVC.h"
#import "RiskGuideVC.h"
#import "RiskFillInformationVC.h"

@interface RiskAssessmentVC ()

@property (nonatomic ,strong) RiskGuideVC *GuideVC;
@property (nonatomic ,strong) RiskFillInformationVC *FillInformationVC;

@property (nonatomic ,assign) NSInteger currentPage;

@end

@implementation RiskAssessmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect viewFrame = CGRectMake(0, 64.0, SCREENWIDTH, SCREENHEIGHT - 64.0);
    WeakObject(self);
    
//    self.GuideVC = [[RiskGuideVC alloc] initWithStoryboardID:@"RiskGuideVC"];
//    self.GuideVC.testTheRisk = ^(){
//        [__weakObject startTest];
//    };
//    [self.GuideVC.view setFrame:viewFrame];
//    [self addChildViewController:self.GuideVC];
//    [self.view addSubview:self.GuideVC.view];
    
    self.FillInformationVC = [[RiskFillInformationVC alloc] initWithStoryboardID:@"RiskFillInformationVC"];
    self.FillInformationVC.returnRiskPage = ^(NSInteger page){
        __weakObject.currentPage = page;
    };
    self.FillInformationVC.defaultData = self.firstData;
    self.FillInformationVC.doneRiskPage = ^(){
        [__weakObject.navigationController popViewControllerAnimated:YES];
    };
    [self.FillInformationVC.view setFrame:viewFrame];
    [self addChildViewController:self.FillInformationVC];
    [self.view addSubview:self.FillInformationVC.view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"风险评估页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"风险评估页"];
}
/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    if (self.currentPage == 0 | self.currentPage == 5) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.FillInformationVC->infoScrollView setContentOffset:CGPointMake(SCREENWIDTH*(self.currentPage-1), 0) animated:YES];
        self.currentPage -= 1;
    }
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

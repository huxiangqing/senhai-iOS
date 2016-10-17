//
//  BloodDataDeneralizationViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/13.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "BloodDataDeneralizationViewController.h"
#import "MJExtension.h"
#import "PressureDataModel.h"
#import "MainViewController.h"
#import "ChartLineView.h"
#import "WebViewController.h"
#import "BloodRressureMonitoringViewController.h"
#import "ZTypewriteEffectLabel.h"
#import "ChartLineView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "BPMeasurementGuidanceViewController.h"

@interface BloodDataDeneralizationViewController ()<UINavigationControllerDelegate,ChartDataSource>
{
    UIImageView *bang;
    UIView *popView;
    UIImageView *tips;
    ZTypewriteEffectLabel *myLbl;
    
    UIImageView  *rightTips;
    UIImageView *RightBang;
    UIView *rightPopView;
    ZTypewriteEffectLabel *leftLbl;
    
    UIImageView *degreeShowChartBackImage;
    UIScrollView *myScrollView_UIScrollView;
    UIScrollView *chartScrollView_UIScrollView;
    UIView *chartContainer_UIView;
    UIView *container_UIView;
    UIView *animateContainerView;
    UIImageView *degreeChart;
    
    UIView *bpTrendView;
    ChartLineView *chartLine;
    ChartLineView *chartHeartLine;
    
    UIView *chartContainer;
    NSTimer  *showTimer;
    ///欢迎界面持续时间
    int showCountDown;
    
    int showVlueOne;
    int showVlueTwo;
    int showVlueThree;
}

@property (weak, nonatomic) IBOutlet UIView *showWhichBtnSelectedView;

@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *resultLable;
@property (weak, nonatomic) IBOutlet UILabel *heartBreaksCountLable;

@property (weak, nonatomic) IBOutlet UIView *resultAnalysisView;

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) IBOutlet UIButton *btnData;
@property (strong, nonatomic) IBOutlet UIButton *btnChart;
@property (strong, nonatomic) IBOutlet UIButton *btnTrend;

@property (strong ,nonatomic)UIImageView *xImageView;
@property (strong ,nonatomic)UIImageView *yImageView;
@property (nonatomic ,strong) UIImageView *redDot;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;

@property (weak, nonatomic) IBOutlet UIButton *retryBtn;

@property (nonatomic ,strong)PressureDataModel *dataModel;

@end

@implementation BloodDataDeneralizationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"RESULTS", nil)];
    [_btnData setTitle:NSLocalizedString(@"Data", nil) forState:UIControlStateNormal];
    [_btnChart setTitle:NSLocalizedString(@"Charts", nil) forState:UIControlStateNormal];
    [_btnTrend setTitle:NSLocalizedString(@"Trends", nil) forState:UIControlStateNormal];
    [_retryBtn setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];

    self.resultLable.text = [NSString stringWithFormat:@"%@/%@",@"-",@"-"];
    self.heartBreaksCountLable.text = [NSString stringWithFormat:@"%@",@"-"];
    [self loadDataWithUserid:self.userId];
    
    self.navigationController.delegate =self;
    
}
#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (IBAction)celliangBntClick:(UIButton *)sender {
    BloodRressureMonitoringViewController *Blood= [[BloodRressureMonitoringViewController alloc] initWithSecondStoryboardID:@"BloodRressureMonitoringViewController"];
    
    [self.navigationController pushViewController:Blood animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [MobClick beginLogPageView:@"血压数据趋势页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"血压数据趋势页"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 请求数据源
-(void)loadDataWithUserid:(NSString *)userid
{
    WeakObject(self);
    AJServerApis *apis =[[AJServerApis alloc] init];
    [apis GetBloodPressureRequestWithUserId:userid bloodPressureId:self.bloodPressureId andCompletion:^(id objectRet, NSError *errorRes)
     {
         if(objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 __weakObject.dataModel  = [PressureDataModel objectWithKeyValues:objectRet[@"data"]];
                 [__weakObject fillFormDataView];
             }
             else if ([statusStr isEqualToString:@"0"])
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 alertView.tag = 101;
                 [alertView show];
             }
         }
     }];
}
/**
 *	@brief	 血压测量结果页动画显示
 */
-(void) fillFormDataView
{
    if (!bang) {
        bang =   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipsHead"]];
        [bang setUserInteractionEnabled:YES];
        [bang sizeToFit];
        [self.dataView addSubview:bang];
        
        bang.originValue = ccp(-bang.widthValue, self.dataView.heightValue - self.retryBtn.heightValue - 20.0 - bang.heightValue);
        [UIView transitionWithView:bang duration:1.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            bang.originValue = ccp(10.0, self.dataView.heightValue - self.retryBtn.heightValue - 20.0 - bang.heightValue);
        } completion:^(BOOL finished) {
            //finished判断动画是否完成
            if (finished) {
              [self popViewAnimate];
            }
        }];

        if (self.dataModel.bloodPressure)
        {
            showCountDown = 80;
            showVlueOne = 25;
            showVlueTwo = 12;
            showVlueThree = 34;
            //时间间隔
            //定时器
            showTimer =[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(handleMaxShowTimer) userInfo:nil repeats:YES];
         
        }
    }
}
-(void)handleMaxShowTimer
{
    showCountDown --;
    showVlueOne =showVlueOne +1;
    showVlueTwo = showVlueTwo +1;
    showVlueThree = showVlueThree +1;
    self.resultLable.text = [NSString stringWithFormat:@"%d/%d",showVlueOne,showVlueTwo];
    self.heartBreaksCountLable.text = [NSString stringWithFormat:@"%d",showVlueThree];
    if (showCountDown==0)
    {
         [showTimer invalidate];
        self.resultLable.text = [NSString stringWithFormat:@"%lld/%lld",self.dataModel.bloodPressure.bloodPressureClose.longLongValue,self.dataModel.bloodPressure.bloodPressureOpen.longLongValue];
        self.heartBreaksCountLable.text = [NSString stringWithFormat:@"%lld",self.dataModel.bloodPressure.pulse.longLongValue];
    }
}

-(void)createPopView
{
    if (!tips) {
        tips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPopImage"]];
        [tips setUserInteractionEnabled:YES];
        
        myLbl = [[ZTypewriteEffectLabel alloc] initWithFrame:CGRectMake(20.0,10.0, self.dataView.widthValue - (bang.rightValue+50.0),0)];
        myLbl.tag = 100;
        myLbl.backgroundColor = [UIColor clearColor];
        myLbl.numberOfLines = 0;
        myLbl.text = self.dataModel.bloodPressure.measureResultDesc;
        myLbl.textColor = [UIColor clearColor];
        myLbl.font = [UIFont systemFontOfSize:16.0];
        myLbl.typewriteEffectColor = [UIColor whiteColor];
        myLbl.hasSound = YES;
        myLbl.typewriteTimeInterval = 0.1;
        myLbl.typewriteEffectBlock = ^{
        };
        [myLbl sizeToFit];
        
        [self.dataView bringSubviewToFront:bang];
    }
    
    if (!popView) {
        popView = [[UIView alloc] initWithFrame:CGRectMake(bang.rightValue,bang.topValue, myLbl.frame.size.width + 40.0,myLbl.frame.size.height + 20.0)];
        [popView setBackgroundColor:[UIColor clearColor]];
        
        [self.dataView addSubview:popView];
        
        [tips setFrame:CGRectMake(0,0, popView.widthValue,popView.heightValue)];
         popView.centerYValue = bang.centerYValue;
        [popView addSubview:tips];
        [popView addSubview:myLbl];
    }
}
-(void)popViewAnimate
{
    [UIView transitionWithView:popView duration:1.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
         [self createPopView];
    } completion:^(BOOL finished) {
        
    }];
    
    [self performSelector:@selector(startOutPut:) withObject:myLbl afterDelay:0.7];
}

-(void)startOutPut:(ZTypewriteEffectLabel *)lable
{
    [lable startTypewrite];
}
/**
 *	@brief	 数据页专家头像创建
 */
-(void)createRightPopView
{
    if (!rightTips) {
        rightTips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightPopImage"]];
        [rightTips setUserInteractionEnabled:YES];
        [rightPopView addSubview:rightTips];
    }
    
    if (!leftLbl) {
        leftLbl = [[ZTypewriteEffectLabel alloc] initWithFrame:CGRectMake(20.0,10.0, (RightBang.leftValue - 40.0),0)];
        leftLbl.tag = 100;
        leftLbl.backgroundColor = [UIColor clearColor];
        leftLbl.numberOfLines = 0;
        leftLbl.text = self.dataModel.bloodPressure.worldRessultDesc;
        leftLbl.textColor = [UIColor clearColor];
        leftLbl.font = [UIFont systemFontOfSize:16.0];
        leftLbl.typewriteEffectColor = [UIColor whiteColor];
        leftLbl.hasSound = YES;
        leftLbl.typewriteTimeInterval = 0.1;
        leftLbl.typewriteEffectBlock = ^{
        };
        [leftLbl sizeToFit];
    }
    
    if (!rightPopView) {
        rightPopView = [[UIView alloc] initWithFrame:CGRectMake(10.0,20.0, leftLbl.frame.size.width + 40.0,leftLbl.frame.size.height + 20.0)];
        [rightPopView setBackgroundColor:[UIColor clearColor]];
        
        [container_UIView addSubview:rightPopView];
        
        [rightTips setFrame:CGRectMake(0,0, rightPopView.widthValue,rightPopView.heightValue)];
        
        rightPopView.centerYValue = RightBang.centerYValue;
        [rightPopView addSubview:rightTips];
        [rightPopView addSubview:leftLbl];
        
         [container_UIView bringSubviewToFront:RightBang];
    }
}
/**
 *	@brief	 数据页分析文字结果动画显示
 */
-(void)popLeftViewAnimate
{
    [UIView transitionWithView:rightPopView duration:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self createRightPopView];
    } completion:^(BOOL finished) {
        if (finished) {
            if (!degreeShowChartBackImage) {
                animateContainerView = [[UIView alloc] initWithFrame:CGRectMake(10.0,rightPopView.bottomValue + 20.0 , container_UIView.widthValue - 2*10.0, container_UIView.heightValue - (rightTips.bottomValue + 20.0) - 20.0)];
                [container_UIView addSubview:animateContainerView];
                [animateContainerView setBackgroundColor:[UIColor clearColor]];
                
                degreeShowChartBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"analyzeBackImage"]];
                [degreeShowChartBackImage setUserInteractionEnabled:YES];
                [degreeShowChartBackImage setFrame:CGRectMake(0, 0, animateContainerView.widthValue, animateContainerView.heightValue)];
                [animateContainerView addSubview:degreeShowChartBackImage];
                
                UILabel *chartNameLale = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, animateContainerView.widthValue - 20.0, 0)];
                [chartNameLale setText:NSLocalizedString(@"Arterial blood pressure classification by World Health Organization(WHO)", nil)];
                [chartNameLale setTextColor:[UIColor whiteColor]];
                [chartNameLale setFont:[UIFont systemFontOfSize:14.0]];
                [chartNameLale setNumberOfLines:0];
                [chartNameLale sizeToFit];
                [animateContainerView addSubview:chartNameLale];
                
                UILabel *highLable = [[UILabel alloc] initWithFrame:CGRectMake(15.0, chartNameLale.bottomValue + 10.0, 0, 0)];
                [highLable setText:NSLocalizedString(@"SYS", nil)];
                [highLable setTextColor:[UIColor whiteColor]];
                [highLable setFont:[UIFont systemFontOfSize:10.0]];
                [highLable sizeToFit];
                [animateContainerView addSubview:highLable];
                
                degreeChart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"biaoshitu", nil)]];
                [degreeChart setUserInteractionEnabled:YES];
                [degreeChart setOriginValue:CGPointMake(highLable.leftValue, highLable.bottomValue)];
                [animateContainerView addSubview:degreeChart];
                
                UILabel *lowLable = [[UILabel alloc] initWithFrame:CGRectMake(degreeChart.rightValue, degreeChart.bottomValue - 10.0, 0, 0)];
                [lowLable setText:NSLocalizedString(@"DIA", nil)];
                [lowLable setTextColor:[UIColor whiteColor]];
                [lowLable setFont:[UIFont systemFontOfSize:10.0]];
                [lowLable sizeToFit];
                [animateContainerView addSubview:lowLable];
                
                animateContainerView.heightValue = lowLable.bottomValue + 20.0;
                degreeShowChartBackImage .heightValue = animateContainerView.heightValue;
                container_UIView.heightValue = animateContainerView.bottomValue + 20.0;
                
                [myScrollView_UIScrollView setContentSize:CGSizeMake(myScrollView_UIScrollView.widthValue, container_UIView.heightValue)];
                [myScrollView_UIScrollView addSubview:container_UIView];
            }
            
            [self animationWithBloodOpenAndCloseValue];
        }
    }];

    [self performSelector:@selector(startOutPut:) withObject:leftLbl afterDelay:0.7];
}
/**
 *	@brief	 数据结果分析页显示
 */
-(void) fillFormResultAnalysisView
{
    if (!myScrollView_UIScrollView) {
        myScrollView_UIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.resultAnalysisView.widthValue, self.resultAnalysisView.heightValue)];
        [myScrollView_UIScrollView setBackgroundColor:[UIColor clearColor]];
        [myScrollView_UIScrollView setUserInteractionEnabled:YES];
        [myScrollView_UIScrollView setShowsHorizontalScrollIndicator:NO];
        [myScrollView_UIScrollView setShowsVerticalScrollIndicator:NO];
        [myScrollView_UIScrollView setScrollEnabled:YES];
        [myScrollView_UIScrollView setBounces:NO];
        [myScrollView_UIScrollView setDelegate:self];
        [self.resultAnalysisView addSubview:myScrollView_UIScrollView];
    }
    
    if (!container_UIView) {
        container_UIView = [[UIView alloc] initWithFrame:myScrollView_UIScrollView.frame];
        [container_UIView setBackgroundColor:[UIColor clearColor]];
        [myScrollView_UIScrollView addSubview:container_UIView ];
    }
    
    if (!RightBang) {
        RightBang =   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TIPSRightNormal"]];
        [RightBang setUserInteractionEnabled:YES];
        [RightBang sizeToFit];
        [container_UIView addSubview:RightBang];
        
        RightBang.originValue = ccp( self.resultAnalysisView.widthValue + RightBang.widthValue, 20.0);
        [UIView transitionWithView:RightBang duration:1.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            RightBang.originValue = ccp(self.resultAnalysisView.widthValue - RightBang.widthValue - 10.0, 20.0);
        } completion:^(BOOL finished) {
            //finished判断动画是否完成
            if (finished) {
               [self  popLeftViewAnimate];
            }
        }];
    }
}
/**
 *	@brief	 数据健康走势动画
 */
-(void)animationWithBloodOpenAndCloseValue
{
    double x= self.dataModel.bloodPressure.bloodPressureOpen.longLongValue;
    double scr_X = 0.0;
    
    double y = self.dataModel.bloodPressure.bloodPressureClose.longLongValue;
    double scr_Y = 0.0;
    
    double firstRatio = 104.0/498.0;
    double secondRatio = 79.0/498.0;
    
    if (x <= 80.0) {
        scr_X = (firstRatio/80.0)*(degreeChart.widthValue)*x;
    }
    if (x > 80.0 && x <= 85.0) {
        scr_X = (firstRatio/80.0)*(degreeChart.widthValue)*80.0 + (secondRatio/5.0)*(degreeChart.widthValue)*(x- 80.0);
    }
    if (x > 85.0 && x <= 90.0) {
        scr_X = (firstRatio/80.0)*(degreeChart.widthValue)*80.0 + (secondRatio/5.0)*(degreeChart.widthValue)*(5.0) + (secondRatio/5.0)*(degreeChart.widthValue)*(x- 85.0);
    }
    if (x > 90.0 && x <= 100.0) {
        scr_X = (firstRatio/80.0)*(degreeChart.widthValue)*80.0 + (secondRatio/5.0)*(degreeChart.widthValue)*(5.0) + (secondRatio/5.0)*(degreeChart.widthValue)*(5.0)+ (secondRatio/10.0)*(degreeChart.widthValue)*(x- 90.0);
    }
    if (x > 100.0 && x <= 110.0) {
        scr_X = (firstRatio/80.0)*(degreeChart.widthValue)*80.0 + (secondRatio/5.0)*(degreeChart.widthValue)*(5.0) + (secondRatio/5.0)*(degreeChart.widthValue)*(5.0)+ (secondRatio/10.0)*(degreeChart.widthValue)*(10.0)+(secondRatio/10.0)*(degreeChart.widthValue)*(x- 100.0);
    }
    if (x > 110.0) {
        scr_X = degreeChart.widthValue  - (secondRatio/10.0)*(degreeChart.widthValue)*(x- 110.0);
    }
    
    scr_X += degreeChart.leftValue;
    
    if (y <= 120.0) {
        scr_Y = (firstRatio/120.0)*(degreeChart.heightValue)*y;
    }
    if (y > 120.0 && y <= 130.0) {
        scr_Y = (firstRatio/120.0)*(degreeChart.heightValue)*120.0 + (secondRatio/10.0)*(degreeChart.heightValue)*(y- 120.0);
    }
    if (y > 130.0 && y <= 140.0) {
        scr_Y = (firstRatio/120.0)*(degreeChart.heightValue)*120.0 + (secondRatio/10.0)*(degreeChart.heightValue)*(10.0) + (secondRatio/10.0)*(degreeChart.heightValue)*(y- 130.0);
    }
    if (y > 140.0 && y <= 160.0) {
        scr_Y = (firstRatio/120.0)*(degreeChart.heightValue)*120.0 + (secondRatio/10.0)*(degreeChart.heightValue)*(10.0) + (secondRatio/10.0)*(degreeChart.heightValue)*(10.0)+ (secondRatio/20.0)*(degreeChart.heightValue)*(y- 140.0);
    }
    if (y > 160.0 && y <= 180.0) {
        scr_Y = (firstRatio/120.0)*(degreeChart.heightValue)*120.0 + (secondRatio/10.0)*(degreeChart.heightValue)*(10.0) + (secondRatio/10.0)*(degreeChart.heightValue)*(10.0)+ (secondRatio/20.0)*(degreeChart.heightValue)*(20.0)+(secondRatio/20.0)*(degreeChart.heightValue)*(y- 160.0);
    }
    if (y > 180.0) {
        scr_Y = degreeChart.heightValue - (secondRatio/20.0)*(degreeChart.heightValue)*(y- 180.0);
    }
    
    scr_Y = degreeChart.bottomValue - scr_Y;
    
    if (_xImageView == nil) {
        _xImageView =[[UIImageView alloc]initWithFrame:CGRectMake(degreeChart.leftValue, degreeChart.bottomValue, 10, 10)];
        _xImageView.image =[UIImage imageNamed:@"XArrow"];
        [animateContainerView addSubview:_xImageView];
        [UIView animateWithDuration:2 animations:^
         {
             _xImageView.leftValue = scr_X - 5.0;
         }];
    }
    if (_yImageView == nil) {
        _yImageView =[[UIImageView alloc]initWithFrame:CGRectMake(degreeChart.leftValue-10.0, degreeChart.bottomValue, 10, 10)];
        _yImageView.image =[UIImage imageNamed:@"YArrow"];
        [animateContainerView addSubview:_yImageView];
        [UIView animateWithDuration:2 animations:^{
            _yImageView.topValue = scr_Y - 5.0;
        }];
    }
    
    if (_redDot == nil) {
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        [_redDot sizeToFit];
        
        _redDot.center = ccp(degreeChart.leftValue, degreeChart.topValue+degreeChart.heightValue);
        [animateContainerView addSubview:_redDot];
        
        [UIView animateWithDuration:2 animations:^
         {
             _redDot.center = ccp(_xImageView.centerXValue, _yImageView.centerYValue - _redDot.heightValue/2.0);
         }];
    }
}
/**
 *	@brief	 趋势图界面
 */
-(void) fillFormChartView
{
    if (!chartScrollView_UIScrollView) {
        chartScrollView_UIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.chartView.widthValue, self.chartView.heightValue)];
        [chartScrollView_UIScrollView setBackgroundColor:[UIColor clearColor]];
        [chartScrollView_UIScrollView setUserInteractionEnabled:YES];
        [chartScrollView_UIScrollView setShowsHorizontalScrollIndicator:NO];
        [chartScrollView_UIScrollView setShowsVerticalScrollIndicator:NO];
        [chartScrollView_UIScrollView setScrollEnabled:YES];
        [chartScrollView_UIScrollView setBounces:NO];
        [chartScrollView_UIScrollView setDelegate:self];
        [self.chartView addSubview:chartScrollView_UIScrollView];
    }
    
    if (!chartContainer_UIView) {
        chartContainer_UIView = [[UIView alloc] initWithFrame:chartScrollView_UIScrollView.frame];
        [chartContainer_UIView setBackgroundColor:[UIColor clearColor]];
    }
    
    if (!chartLine) {
        bpTrendView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, self.chartView.widthValue - 20.0, 400.0)];
        UIViewSetRadius(bpTrendView, 6.0, 1.0, [UIColor clearColor]);
        [bpTrendView setBackgroundColor:[UIColor whiteColor]];
        [chartContainer_UIView addSubview:bpTrendView];
        
        UILabel *chartTrendName  = [[UILabel alloc] init];
        [chartTrendName setText:NSLocalizedString(@"Blood Pressure Trends", nil)];
        [chartTrendName setTextColor:[UIColor grayColor]];
        [chartTrendName setFont:[UIFont systemFontOfSize:16.0]];
         [chartTrendName sizeToFit];
        chartTrendName.originValue = ccp(10.0, 10.0);
        [bpTrendView addSubview:chartTrendName];
        
        UILabel *chartLineDSP  = [[UILabel alloc] init];
        [chartLineDSP setText:NSLocalizedString(@"DIA", nil)];
        [chartLineDSP setFont:[UIFont systemFontOfSize:14.0]];
        [chartLineDSP setTextColor:[UIColor lightGrayColor]];
        [chartLineDSP sizeToFit];
        chartLineDSP.originValue = ccp(bpTrendView.widthValue - 10.0 -chartLineDSP.widthValue, 0.0);
        [bpTrendView addSubview:chartLineDSP];
        
        
        UIView *DSPColorView = [[UIView alloc] initWithFrame:CGRectMake(chartLineDSP.leftValue - 15.0 ,0, 8.0, 8.0)];
        UIViewSetRadius(DSPColorView, 4.0, 1.0, [UIColor clearColor]);
        [DSPColorView setBackgroundColor:[Tools colorWithHexString:@"#01BCA8"]];
        [bpTrendView addSubview:DSPColorView];
        
        UILabel *chartLineSP  = [[UILabel alloc] init];
        [chartLineSP setText:NSLocalizedString(@"SYS", nil)];
        [chartLineSP setFont:[UIFont systemFontOfSize:14.0]];
        [chartLineSP setTextColor:[UIColor lightGrayColor]];
        [chartLineSP sizeToFit];
        chartLineSP.originValue = ccp(DSPColorView.leftValue - 10.0 -chartLineSP.widthValue, 0.0);
        [bpTrendView addSubview:chartLineSP];
        
        UIView *SPColorView = [[UIView alloc] initWithFrame:CGRectMake(chartLineSP.leftValue - 15.0 ,0, 8.0, 8.0)];
        UIViewSetRadius(SPColorView, 4.0, 1.0, [UIColor clearColor]);
        [SPColorView setBackgroundColor:[Tools colorWithHexString:@"#3387DB"]];
        [bpTrendView addSubview:SPColorView];
        
        SPColorView.centerYValue = chartLineSP.centerYValue = chartLineDSP.centerYValue = DSPColorView.centerYValue = chartTrendName.centerYValue;
        
        chartLine =  [[ChartLineView alloc] initWithChartDataFrame:CGRectMake(0, 30.0, bpTrendView.widthValue, bpTrendView.heightValue - 30.0) withSource:self withDashName:@"blueDash"];
        [chartLine showInView:bpTrendView];
    }
    
    if (!chartHeartLine) {
        UIView *heartTrendView = [[UIView alloc] initWithFrame:CGRectMake(10.0, bpTrendView.bottomValue + 10.0, bpTrendView.widthValue, 300.0 )];
        UIViewSetRadius(heartTrendView, 6.0, 1.0, [UIColor clearColor]);
        [heartTrendView setBackgroundColor:[UIColor whiteColor]];
        [chartContainer_UIView addSubview:heartTrendView];
        
        UILabel *chartTrendName  = [[UILabel alloc] init];
        [chartTrendName setText:NSLocalizedString(@"Pulse Pressure", nil)];
        [chartTrendName setFont:[UIFont systemFontOfSize:16.0]];
        chartTrendName.originValue = ccp(10.0, 10.0);
        [chartTrendName setTextColor:[UIColor grayColor]];
        [chartTrendName sizeToFit];
        [heartTrendView addSubview:chartTrendName];
        
        UILabel *chartLineSub  = [[UILabel alloc] init];
        [chartLineSub setText:NSLocalizedString(@"PP", nil)];
        [chartLineSub setFont:[UIFont systemFontOfSize:14.0]];
        [chartLineSub setTextColor:[UIColor lightGrayColor]];
        [chartLineSub sizeToFit];
        chartLineSub.originValue = ccp(heartTrendView.widthValue - 10.0 -chartLineSub.widthValue, 0.0);
        [heartTrendView addSubview:chartLineSub];
        
        UIView *subColorView = [[UIView alloc] initWithFrame:CGRectMake(chartLineSub.leftValue - 15.0 ,0, 8.0, 8.0)];
        UIViewSetRadius(subColorView, 4.0, 1.0, [UIColor clearColor]);
        [subColorView setBackgroundColor:[Tools colorWithHexString:@"#F6C660"]];
        [heartTrendView addSubview:subColorView];
        
        chartLineSub.centerYValue  = subColorView.centerYValue = chartTrendName.centerYValue;
        
        chartHeartLine =  [[ChartLineView alloc] initWithChartDataFrame:CGRectMake(0, 30.0, heartTrendView.widthValue, heartTrendView.heightValue - 30.0) withSource:self withDashName:@"yellowDash"];
        [chartHeartLine showInView:heartTrendView];
        
        chartContainer_UIView.heightValue = heartTrendView.bottomValue + 20.0;
    }
    
    [chartScrollView_UIScrollView setContentSize:CGSizeMake(chartScrollView_UIScrollView.widthValue, chartContainer_UIView.heightValue)];
    [chartScrollView_UIScrollView addSubview:chartContainer_UIView];
}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"%@",@"12.10 18:35"];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)Chart_xLableArray:(ChartLineView *)chart
{
    return self.dataModel.dateTimeList;
}
- (CGFloat)Chart_yValueCount:(ChartLineView  *)chart
{
    if ([chart isEqual:chartLine]) {
        return 9.0;
    }
    else  if ([chart isEqual:chartHeartLine])
    {
        return 4.0;
    }
    
    return 6.0;
}
//数值多重数组
- (NSArray *)Chart_yValueArray:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
        return @[self.dataModel.pressureCloseList,self.dataModel.pressureOpenList];
    }
    else
    {
        return @[self.dataModel.differList];
    }
}
#pragma mark - @optional

-(NSArray *)Chart_PointBackGroundImageArray:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
         return @[@"SPSubImage",@"DSPPopImage"];
    }
    else
    {
         return @[@"DSPSubImage"];
    }
   
}
//颜色数组
- (NSArray *)Chart_ColorArray:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
         return @[[Tools colorWithHexString:@"#3387DB"],[Tools colorWithHexString:@"#01BCA8"]];
    }
    else
    {
        return @[[Tools colorWithHexString:@"#F6C660"]];
    }
}
- (NSArray *)Chart_FillColorArray:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
           return @[[Tools colorWithHexString:@"#3387DB" alpha:0.1],[Tools colorWithHexString:@"#01BCA8" alpha:0.1]];
    }
    else
    {
        return @[[Tools colorWithHexString:@"#F6C660" alpha:0.1]];
    }
 
}
-(NSArray *)showPopViewArray:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
        
        NSMutableArray *open = [[NSMutableArray alloc] init];
        NSMutableArray *close = [[NSMutableArray alloc] init];
        
        if (self.dataModel.maxOpenValue) {
            [open addObject:self.dataModel.maxOpenValue];
        }
        else
        {
            [open addObject:[NSNumber numberWithInteger:0]];
        }
        
        if (self.dataModel.minCloseValue) {
            [close addObject:self.dataModel.minCloseValue];
        }
        else
        {
            [close addObject:[NSNumber numberWithInteger:0]];
        }
        
        if (self.dataModel.minOpenValue) {
            [open addObject:self.dataModel.minOpenValue];
        }
        else
        {
            [open addObject:[NSNumber numberWithInteger:0]];
        }
        
        if (self.dataModel.maxCloseValue) {
            [close addObject:self.dataModel.maxCloseValue];
        }
        else
        {
            [close addObject:[NSNumber numberWithInteger:0]];
        }
        
        NSArray *valueArray = @[close,open];
        
        return valueArray;
    }
    
    return nil;

}
//显示数值范围
- (CGRange)ChartChooseRangeInLineChart:(ChartLineView *)chart
{
    if ([chart isEqual:chartLine]) {
        return CGRangeMake(200, 20);
    }
    else
    {
         return CGRangeMake(120, 0);
    }
}
-(NSArray *)animationDurationForLineArray:(ChartLineView *)chart
{
    return @[@0.8, @1.4, @2.8, @1.4];
}

- (IBAction)seekDoctor:(UIButton *)sender {
    NSString *identify = @"";
    Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *phone =item.phone;
    NSString *pressureId = self.dataModel.bloodPressure.bloodPressureId;
    WeakObject(self);
    AJServerApis *apis =[[AJServerApis alloc] init];
    [apis GetSeekDoctorWithPressureId:pressureId phone:phone UUIDString:identify andCompletion:^(id objectRet, NSError *errorRes)
     {
         if(objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 WebViewController *H5WebViewController = [[WebViewController alloc] initWithSecondStoryboardID:@"WebViewController"];
                 H5WebViewController.Linkurl = [NSURL URLWithString:[objectRet objectForKey:@"msg"]];
                 [__weakObject.navigationController pushViewController:H5WebViewController animated:YES];
                 
             }
             else if ([statusStr isEqualToString:@"0"])
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 alertView.tag = 101;
                 [alertView show];
             }
         }
     }];
}

#pragma mark - getter
//界面元素的getter方法初始化

- (IBAction)btnClick:(UIButton *)sender {
    [self.showWhichBtnSelectedView setCenterXValue:sender.centerXValue];
    
    UIView *selectedView = [self.view viewWithTag:(sender.tag+1)*10];
    [self.view bringSubviewToFront:selectedView];
    
    switch (sender.tag) {
        case 0:
            [self.dataView setHidden:NO];
            [self.resultAnalysisView setHidden:YES];
            [self.chartView setHidden:YES];
            if (self.dataModel.bloodPressure) {
                 [self fillFormDataView];
            }
            break;
        case 1:
            [self.dataView setHidden:YES];
            [self.resultAnalysisView setHidden:NO];
            [self.chartView setHidden:YES];
            if (self.dataModel.bloodPressure) {
                [self fillFormResultAnalysisView];
            }
            break;
        case 2:
            [self.dataView setHidden:YES];
            [self.resultAnalysisView setHidden:YES];
            [self.chartView setHidden:NO];
            if (self.dataModel.pressureOpenList.count > 0) {
                  [self fillFormChartView]; 
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击方法
/**
 *	@brief	返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    if(self.fromMainview)
    {
        [self gotoMainView];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *	@brief	分享按钮 点击事件
 */
- (IBAction)ShareBtnClick:(UIButton *)sender
{
    UIImage *picture;
    
    picture = [Tools createImageWithView:self.view];
    
    //创建分享参数
    NSArray* imageArray = @[picture,];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:sender
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Share Succeed", nil)
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:NSLocalizedString(@"Confirm", nil)
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Share Failed", nil)
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }
}

@end

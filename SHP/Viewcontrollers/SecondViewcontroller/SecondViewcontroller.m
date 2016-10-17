//
//  SecondViewcontroller.m
//  LUDE
//
//  Created by bluemobi on 15/12/1.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "SecondViewcontroller.h"
#import "SecondTableViewCell.h"
#import "ScreeningViewController.h"
#import "BloodDataDeneralizationViewController.h"
#import "PressureDataModel.h"
#import "MJExtension.h"
#import "ChartLineView.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

@interface SecondViewcontroller ()<UIScrollViewDelegate,ChartDataSource,UINavigationControllerDelegate>
{
     NSString *yearStr;
     NSString *typeStr;
    
    UIView *bpTrendView;
    ChartLineView *chartLine;
    ChartLineView *chartHeartLine;
    
    UIScrollView *chartScrollView_UIScrollView;
    UIView *chartContainer_UIView;
    
    UIView *chartContainer;
}

@property (strong, nonatomic) IBOutlet UILabel *lblTitleHistory;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UITableView *second_tableVIew;
@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (strong, nonatomic) IBOutlet UIView *linesView;
@property (strong, nonatomic)UIView *blueLinesView;

@property (strong ,nonatomic)NSMutableArray *secondMarr;

@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *trendBtn;

@property (nonatomic ,strong) UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIView *trendView;
@property (nonatomic ,strong)PressureDataModel *dataModel;

@end

@implementation SecondViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor yellowColor];
    [self MJView];
    [_lblTitleHistory setText:NSLocalizedString(@"History", nil)];
    [_historyBtn setTitle:NSLocalizedString(@"History", nil) forState:UIControlStateNormal];
    [_trendBtn setTitle:NSLocalizedString(@"Charts", nil) forState:UIControlStateNormal];
    _linesView.hidden = YES;
    _blueLinesView =[[UIView alloc]initWithFrame:CGRectMake(_linesView.frame.origin.x, _linesView.frame.origin.y, self.view.widthValue/2.0-40, _linesView.frame.size.height)];
    _blueLinesView.backgroundColor =RGBCOLOR(111, 187, 230);
    [_btnBackView addSubview:_blueLinesView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [MobClick beginLogPageView:@"血压历史页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"血压历史页"];
}
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
-(void)createdataTwo
{
     //趋势图数据请求
    WeakObject(self);
    Userinfo *user = [NTAccount shareAccount].userinfo;
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetBloodPressureHistoryTendencyChartRequestWithUserId:user.userId type:typeStr andCompletion:^(id objectRet, NSError *errorRes)
    {
        if(objectRet)
        {
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                PressureDataModel  *dataModelChart  = [PressureDataModel objectWithKeyValues:objectRet[@"data"]];
                
                if (dataModelChart) {
                    __weakObject.dataModel = dataModelChart;
                    
                    if (chartLine) {
                        [chartLine strokeChartReDraw];
                        [chartHeartLine strokeChartReDraw];
                    }
                    else
                    {
                        [__weakObject fillFormChartView];
                    }
                }
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
    self.navigationController.delegate =self;
}

-(void)refreshData
{
    if (! [[NTAccount shareAccount] ScreenType]) {
        typeStr = @"1";
        [[NTAccount shareAccount] setScreenType:typeStr];
    }
    
    typeStr =    [[NTAccount shareAccount] ScreenType]  ;
    
    self.selectedBtn  = self.selectedBtn ? self.selectedBtn: self.historyBtn;
    [self TwoBtnClick:self.selectedBtn];
}

-(void)MJView
{
    _second_tableVIew.header = [MJDIYHeader headerWithRefreshingBlock:^
                               {
                                   [self createheader];
                               }];
  
    _second_tableVIew.footer = [MJDIYBackFooter footerWithRefreshingBlock:^
                               {
                                   [self createfooter];
                               }];
}
-(void)createheader
{
    [self createData];
    // 马上进入刷新状态
    [_second_tableVIew.header endRefreshing];
}

-(void)createfooter
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(self.view.widthValue/2.0-60, self.view.heightValue-100, 120, 30)];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
    UILabel *lastlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.widthValue, view.heightValue)];
    lastlabel.text=NSLocalizedString(@"No more records", nil);
    lastlabel.textAlignment = NSTextAlignmentCenter;
    lastlabel.textColor =[UIColor whiteColor];
    lastlabel.font =[UIFont systemFontOfSize:13];
    [view addSubview:lastlabel];
    [self.view addSubview:view];

    [UIView animateWithDuration:2.f animations:^
     {
         view.alpha = 0.f;
     }];
    
    [_second_tableVIew.footer endRefreshing];
}
-(void) fillFormChartView
{
    if (!chartScrollView_UIScrollView) {
        chartScrollView_UIScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.trendView.widthValue,self.trendView.heightValue)];
        [chartScrollView_UIScrollView setBackgroundColor:[UIColor clearColor]];
        [chartScrollView_UIScrollView setUserInteractionEnabled:YES];
        [chartScrollView_UIScrollView setShowsHorizontalScrollIndicator:NO];
        [chartScrollView_UIScrollView setShowsVerticalScrollIndicator:NO];
        [chartScrollView_UIScrollView setScrollEnabled:YES];
        [chartScrollView_UIScrollView setBounces:NO];
        [chartScrollView_UIScrollView setDelegate:self];
        [self.trendView addSubview:chartScrollView_UIScrollView];
    }
    
    if (!chartContainer_UIView) {
        chartContainer_UIView = [[UIView alloc] initWithFrame:chartScrollView_UIScrollView.frame];
        [chartContainer_UIView setBackgroundColor:[UIColor clearColor]];
    }

    if (!chartLine) {
        bpTrendView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, self.trendView.widthValue - 20.0, 400.0)];
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
        UIView *heartTrendView = [[UIView alloc] initWithFrame:CGRectMake(10.0, bpTrendView.bottomValue + 10.0, bpTrendView.widthValue, 300.0)];
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


#pragma mark - @required
//横坐标标题数组
- (NSArray *)Chart_xLableArray:(ChartLineView *)chart
{
    if (self.dataModel.dateTimeList) {
        return self.dataModel.dateTimeList;
    }
    
    return nil;
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
        if (self.dataModel.pressureCloseList) {
           return @[self.dataModel.pressureCloseList,self.dataModel.pressureOpenList];
        }
        return nil;
    }
    else
    {
        if (self.dataModel.differList) {
            return @[self.dataModel.differList];
        }
        return nil;
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
        return @[[Tools colorWithHexString:@"#3387DB" alpha:0.2],[Tools colorWithHexString:@"#01BCA8" alpha:0.2]];
    }
    else
    {
        return @[[Tools colorWithHexString:@"#F6C660" alpha:0.2]];
    }
    
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

-(void)createData
{
    Userinfo *user = [NTAccount shareAccount].userinfo;
    AJServerApis *apis =[[AJServerApis alloc]init];

    [apis GetBloodPressureHistoryRequestWithUserId:user.userId type:typeStr pageNo:@"" pageSize:@"" andCompletion:^(id objectRet, NSError *errorRes) {
        if (objectRet)
        {
            NSString *statusStr = [NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                _secondMarr =[NSMutableArray arrayWithArray:[objectRet objectForKey:@"data"]];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }
            [_second_tableVIew reloadData];
        }
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_secondMarr count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  [[_secondMarr[section] objectForKey:@"bloodPressureList"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SecondTableViewCell"];
    if (cell == nil)
    {
        cell =[[SecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondTableViewCell"];
    }
    cell.roundBackView.layer.masksToBounds =YES;
    cell.roundBackView.layer.cornerRadius =10;
    
    cell.dataBackVIew.layer.masksToBounds =YES;
    cell.dataBackVIew.layer.cornerRadius =5;
    
    
    cell.timeLabel.text =[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"measureTime"];
    
    cell.SDLabel.text =[NSString stringWithFormat:@"%@/%@",[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"bloodPressureClose"],[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"bloodPressureOpen"]];
   
     cell.SDLabel.textColor = [Tools colorFromSPValue:[[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"bloodPressureClose"] integerValue] DSPValue:[[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"bloodPressureOpen"]integerValue]];
    
    cell.heartRateLabel.text =[NSString stringWithFormat:@"%@",[[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"pulse"]];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSString *yearTimeStr=[_secondMarr[section] objectForKey:@"yearTime"];
    if (section == 0)
    { NSString *yearTimeStr=[_secondMarr[section] objectForKey:@"yearTime"];
        if ([yearTimeStr isEqualToString:yearStr])
        {
            return nil;
        }
    }
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.widthValue, 65)];
    UILabel *timelabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 25, 55, 45)];
    view.backgroundColor =[UIColor clearColor];
    timelabel.font=[UIFont boldSystemFontOfSize:20];
    timelabel.textColor =[UIColor whiteColor];
    timelabel.text=yearTimeStr;
    [view addSubview:timelabel];
    
    UIImageView *linesImageView =[[UIImageView alloc]initWithFrame:CGRectMake(78, 0, 2, 65)];
    linesImageView.image =[UIImage imageNamed:@"xin-lishishuxian"];
    [view addSubview:linesImageView];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSString *yearTimeStr=[_secondMarr[section] objectForKey:@"yearTime"];
        //获取当前时间
         NSDate *now = [NSDate date];
         NSCalendar *calendar = [NSCalendar currentCalendar];
         NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        yearStr =[NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
  
        if ( [yearTimeStr isEqualToString:yearStr])
        {
            return 0.0000001;
        }
        return 65;
    }
    else
    {
        return 65;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bloodPressureId = [[[[_secondMarr objectAtIndex:indexPath.section]objectForKey:@"bloodPressureList"]objectAtIndex:indexPath.row]objectForKey:@"bloodPressureId"];
    
    BloodDataDeneralizationViewController *data =[[BloodDataDeneralizationViewController alloc] initWithSecondStoryboardID:@"BloodDataDeneralizationViewController"];
    data.bloodPressureId = bloodPressureId;
    Userinfo *user = [NTAccount shareAccount].userinfo;
    data.userId = user.userId;
    [self.navigationController pushViewController:data animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/self.view.widthValue;
  
        if (index == 0)
        {
            _linesView.leftValue = 20;
        }
        else if (index==1)
        {
            _linesView.leftValue =  60+_linesView.widthValue;
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 按钮点击事件
//筛选
- (IBAction)SaiXunBtnClick:(UIButton *)sender
{
    ScreeningViewController *screen =[[ScreeningViewController alloc]initWithSecondStoryboardID:@"ScreeningViewController"];
    [self.navigationController pushViewController:screen animated:YES];
    
}

- (IBAction)TwoBtnClick:(UIButton *)sender
{
    self.selectedBtn = sender;
    if (sender.tag == 101)
    {//
        
        [UIView animateWithDuration:0.4 animations:^{
            _backScrollView.contentOffset =CGPointMake(0, 0) ;
            _blueLinesView.leftValue = 20;
            [_second_tableVIew.header beginRefreshing];
        }];
        
    }
    else if (sender.tag == 102)
    {//
        //趋势图数据请求
        [self createdataTwo];
        [UIView animateWithDuration:0.4 animations:^{
            _backScrollView.contentOffset =CGPointMake(self.view.widthValue, 0);
             _blueLinesView.leftValue = 20+self.view.widthValue/2.0;
        }];
    }
}


@end

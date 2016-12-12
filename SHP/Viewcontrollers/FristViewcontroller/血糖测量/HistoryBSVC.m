//
//  HistoryBSVC.m
//  LUDE
//
//  Created by lord on 16/6/7.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "HistoryBSVC.h"
#import "BSHistoryDataCell.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"
#import "BSDataModel.h"
#import "CalendarVC.h"

@interface HistoryBSVC ()<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    NSString *yearStr;
    
    NSString *startTimeString;
    NSString *endTimeString;
}


@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleNme;
@property (weak, nonatomic) IBOutlet UITableView *second_tableVIew;
@property (weak, nonatomic) IBOutlet UIView *btnBackView;
@property (strong, nonatomic) IBOutlet UIView *linesView;

@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *trendBtn;

@property (weak, nonatomic) IBOutlet UIView *trendView;

@property (nonatomic ,strong) UIButton *selectedBtn;
@property (strong, nonatomic)UIView *blueLinesView;

@property (strong ,nonatomic)NSMutableArray *historyDataArray;


@property (weak, nonatomic) IBOutlet WKWebView *pieChartWebView;
@property (weak, nonatomic) IBOutlet WKWebView *lineChartWebView;

@property (strong ,nonatomic)NSString *pageNoStr;
@property (strong ,nonatomic)NSString *pageCountStr;

@property (nonatomic ,copy)NSString *timeInterval;

@end

@implementation HistoryBSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _linesView.hidden = YES;
    //    CGRect frame =_linesView.frame;
    _blueLinesView =[[UIView alloc]initWithFrame:CGRectMake(20.0, 46.0, self.view.widthValue/2.0-40, 4.0)];
    _blueLinesView.backgroundColor =RGBCOLOR(111, 187, 230);
    [_btnBackView addSubview:_blueLinesView];
    
    self.pieChartWebView.opaque = NO;
    self.lineChartWebView.opaque = NO;
    
    [self MJView];
    
    startTimeString = [[NSString alloc] init];
    endTimeString = [[NSString alloc] init];
    _pageNoStr = [[NSString alloc] init];
    
    self.historyDataArray = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [MobClick beginLogPageView:@"血糖历史页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"血糖历史页"];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void) requestWebView
{
     Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *piestr=[NSString stringWithFormat:@"%@highchartsApp/bloodGlucose/bloodGlucosePieCharts.jsp?userId=%@&startTime=%@&endTime=%@&startNo=%@&pageSize=%@",SERVER_DEMAIN,item.userId,startTimeString,endTimeString,@"0",[NSString stringWithFormat:@"%ld",10*([_pageNoStr integerValue] + 1)]];
    NSString *linestr=[NSString stringWithFormat:@"%@highchartsApp/bloodGlucose/bloodGlucoseResult.jsp?userId=%@&startTime=%@&endTime=%@&startNo=%@&pageSize=%@",SERVER_DEMAIN,item.userId,startTimeString,endTimeString,@"0",[NSString stringWithFormat:@"%ld",10*([_pageNoStr integerValue] + 1)]];

    NSMutableURLRequest *pieRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:piestr]];
    [pieRequest setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    NSMutableURLRequest *lineRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:linestr]];
    [lineRequest setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    
    [self.pieChartWebView loadRequest:pieRequest];
    [self.lineChartWebView loadRequest:lineRequest];
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
    _pageNoStr = @"1";
   
    [self requestWebView];
    [self createDataWithStartTime:startTimeString  endTime:endTimeString];
    
    // 马上进入刷新状态
    [_second_tableVIew.header endRefreshing];
}

-(void)createfooter
{
    if ([_pageNoStr isEqualToString:_pageCountStr])
    {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(self.view.widthValue/2.0-60, self.view.widthValue-100, 120, 30)];
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
    }
    else
    {
        //加1
        _pageNoStr = [NSString stringWithFormat:@"%d",[_pageNoStr intValue]+1];
        
        [self requestWebView];
        //刷新数据
        [self createDataWithStartTime:startTimeString  endTime:endTimeString];
    }
   
    [_second_tableVIew.footer endRefreshing];
}

-(void)createDataWithStartTime:(NSString *)startTime  endTime:(NSString *)endTime
{
    AJServerApis *apis =[[AJServerApis alloc]init];
    WeakObject(self)
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    [apis GetBSHistoryDataRequestWithUserId:item.userId startTime:startTime endTime:endTime startNo:_pageNoStr pageSize:10 andCompletion:^(id objectRet, NSError *errorRes) {
        if (objectRet)
        {
            if ([_pageNoStr isEqualToString:@"1"])
            {
                [__weakObject.historyDataArray removeAllObjects];
            }
            NSString *statusStr = [NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                NSArray *arr =[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];

                if(arr.count == 0)
                {
                    [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                }
                else
                {
                    for (int i = 0; i < [arr count]; i++)
                    {
                        NSDictionary *moreYearBSDic = arr[i];
                        
                        if (!__weakObject.timeInterval) {
                            __weakObject.timeInterval = moreYearBSDic[@"min"] ;
                        }
        
                        if (__weakObject.historyDataArray.count > 0) {
                            NSMutableDictionary *yearBSDic =  [NSMutableDictionary dictionaryWithDictionary: __weakObject.historyDataArray.lastObject];
                            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:yearBSDic[@"bloodGlucoseList"]];
                            if ([yearBSDic[@"yearTime"] isEqualToString:moreYearBSDic[@"yearTime"]]) {
                                for (NSDictionary *dic in moreYearBSDic[@"bloodGlucoseList"] ) {
                                    [tempArray addObject:dic];
                                }
                                [yearBSDic setValue:tempArray forKey:@"bloodGlucoseList"];
                                
                                [__weakObject.historyDataArray replaceObjectAtIndex:__weakObject.historyDataArray.count - 1 withObject:yearBSDic];
                            }
                            else
                            {
                                [__weakObject.historyDataArray addObject:arr[i]];
                            }
                        }
                        else
                        {
                            [__weakObject.historyDataArray addObject:arr[i]];
                        }
                        
                    }
                    
                    _pageCountStr = [NSString stringWithFormat:@"%d",[_pageNoStr intValue]+1];;
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
            }
            
            [__weakObject.second_tableVIew reloadData];
            
            if ([_pageNoStr isEqualToString:@"0"])
            {
                [__weakObject.second_tableVIew.header endRefreshing];
            }
        }
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.selectedBtn  = self.selectedBtn ? self.selectedBtn: self.historyBtn;
    [self TwoBtnClick:self.selectedBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.historyDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self.historyDataArray[section] objectForKey:@"bloodGlucoseList"] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSHistoryDataCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BSHistoryDataCell"];
    if (cell == nil)
    {
        cell =[[BSHistoryDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondTableViewCell"];
    }
    cell.roundBackView.layer.masksToBounds =YES;
    cell.roundBackView.layer.cornerRadius =10;
    
    cell.dataBackVIew.layer.masksToBounds =YES;
    cell.dataBackVIew.layer.cornerRadius =5;
    
    BSDataModel *bsDataModel = [BSDataModel objectWithKeyValues:[[[self.historyDataArray objectAtIndex:indexPath.section]objectForKey:@"bloodGlucoseList"]objectAtIndex:indexPath.row]];
    
    cell.timeLabel.text = bsDataModel.measureTime;
    cell.BSmmolLabel.text = bsDataModel.bloodGlucoseValue;
    cell.BSmmolLabel.textColor = [Tools colorFromBSValue:bsDataModel.bloodGlucoseValue];
    cell.timeQuantumLabel.text = [Tools timeQuantumStringFromMeasureState:bsDataModel.state];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *yearTimeStr=[_historyDataArray[section] objectForKey:@"yearTime"];
    if (section == 0)
    {
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
        NSString *yearTimeStr=[_historyDataArray[section] objectForKey:@"yearTime"];
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
        return 65.0;
    }
    else
    {
        return 65.0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
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
        _linesView.leftValue = 60+_linesView.widthValue;
    }
}
#pragma mark - 按钮点击事件
//筛选
- (IBAction)ScreenBtnClick:(UIButton *)sender
{
    CalendarVC *calendar = [[CalendarVC alloc] initWithSecondStoryboardID:@"CalendarVC"];
    calendar.timeInterval = self.timeInterval;
    
    calendar.screenStartTimeAndEndTime=^(NSString *startT,NSString *endT){
        
        startTimeString = startT;
        endTimeString = endT;
        
        [[NTAccount shareAccount] setBSStartDateString:startTimeString];
        [[NTAccount shareAccount] setBSEndDateString:endTimeString];
        
        [self requestWebView];
        [self createDataWithStartTime:startT  endTime:endT];
        // 马上进入刷新状态
        [_second_tableVIew.header endRefreshing];
        
        
        
    };
    
    [self.navigationController pushViewController:calendar animated:YES];
    
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
        [UIView animateWithDuration:0.4 animations:^{
            _backScrollView.contentOffset =CGPointMake(self.view.widthValue, 0);
            _blueLinesView.leftValue = 20+self.view.widthValue/2.0;
        }];
    }
}
//返回
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    if (self.isFromMeasureView) {
        [self gotoMainView];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

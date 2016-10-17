//
//  FristViewController.m
//  LUDE
//
//  Created by bluemobi on 15/12/1.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "FristViewController.h"
#import "TimeReminderViewController.h"
#import "PressureDataModel.h"
#import "FirstTopViewTableViewCell.h"
#import "FirstItemTableViewCell.h"
#import "JPUSHService.h"
#import "ThirdDetailsViewController.h"
#import "WebViewController.h"

#import "RiskAssessmentVC.h"
#import "BSMeasureVC.h"

#import "BloodRressureMonitoringViewController.h"
#import "BPMeasurementGuidanceViewController.h"
#import "MedicationAdministrationVC.h"

#define sectionHeight 50.0

@interface FristViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{

    __weak IBOutlet UITableView *myTable;
    __weak IBOutlet UIView *ADDefaultView;
    SDCycleScrollView *cycleScrollView;
    
    Tools *BlueTooth;
}

@property (nonatomic ,assign) CGFloat firstTableViewHeight;
//红点
@property (weak, nonatomic) IBOutlet UIImageView *hasNewNoti;
@property (nonatomic ,strong)NSMutableArray *messageArray;
@property (strong ,nonatomic)NSMutableDictionary *fristDict;
@property (nonatomic ,strong) NSArray *unReadMessageArray;

@property (nonatomic ,strong) UIView *sectionView;

@property (nonatomic ,strong) FirstDataModel *FirstPageData;

@property (nonatomic ,strong)NSArray *ADArray;
@property (nonatomic ,strong)NSArray *NewsArray;

@property (nonatomic ,strong) HealthManager *healthManager;
@property (weak, nonatomic) IBOutlet UIButton *stepBtn;
@property (weak, nonatomic) IBOutlet UIButton *calorieBtn;

@end

@implementation FristViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasNewNoti.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedApns:) name:@"apns" object:nil];
    //监听通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redOriginHidden:)
                                                 name:@"redOriginHidden"
                                               object:nil];
    if ([[NTAccount shareAccount] Messages])
    {
        self.messageArray = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
    }
    else
    {
        self.messageArray = [[NSMutableArray alloc] init];
    }
    
    [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
        if (Mess.integerValue != 2 )
        {
            self.hasNewNoti.hidden = NO;
        }
    }];
    
    ADDefaultView.heightValue = (((446.0/2248.0)*SCREENHEIGHT + 50.0) > 165.0)?((446.0/2248.0)*SCREENHEIGHT + 50.0):165.0;

    NSString *steps = [[NTAccount shareAccount] healthSteps];
    if (steps) {
        [self.stepBtn setTitle:[NSString stringWithFormat:@" %@步",steps] forState:UIControlStateNormal];
        
        [self.calorieBtn setTitle:[NSString stringWithFormat:@" %.2lf卡路里",[steps doubleValue]/20.0] forState:UIControlStateNormal];
    }
   
    
    UIImage *tempImage = [UIImage imageNamed:@"HealthIndex"];
    self.firstTableViewHeight = 20.0+2*(tempImage.size.height);
    
    WeakObject(self);
    self.healthManager = [HealthManager shareHealthManager];
    
    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
        if (isAuthorizateSuccess) {
        
            [__weakObject.healthManager readStepCount:^(NSString *stepCount){
                
                if (stepCount) {
                    [[NTAccount shareAccount] setHealthSteps:stepCount];
                }
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                [__weakObject.stepBtn setTitle:[NSString stringWithFormat:@" %@步",stepCount] forState:UIControlStateNormal];
                     
                [__weakObject.calorieBtn setTitle:[NSString stringWithFormat:@" %.2lf卡路里",[stepCount doubleValue]/20.0] forState:UIControlStateNormal];
               
                 });
                
            }];
        }
    }];
    
//    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
//        if (isAuthorizateSuccess) {
//            [__weakObject.healthManager getKilocalorieUnitCompletionHandler:^(double value, NSError *error){
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                [__weakObject.calorieBtn setTitle:[NSString stringWithFormat:@" %.2lf卡路里",value] forState:UIControlStateNormal];
//                 })  ;
//            }];
//        }
//    }];
    

}
//极光接收到数据时候调用的方法
-(void)DidReceiveMessage:(NSNotification *)info
{
    self.hasNewNoti.hidden = NO;
}
-(void)redOriginHidden:(NSNotification *)info
{
    self.hasNewNoti.hidden = YES;
}
-(void)didReceivedApns:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    NSString *str = [userInfo valueForKey:@"pushType"]; //推送显示的内容
    if (![str isEqualToString:@"2"])
    {
        self.hasNewNoti.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self createData];
    [self requsetForADData];
    [self requsetForNewsData];
    
    [MobClick beginLogPageView:@"首页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"首页"];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)createData
{
    WeakObject(self)
    Userinfo *item = [NTAccount shareAccount].userinfo;
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetBloodPressureUserId:item.userId andCompletion:^(id objectRet, NSError *errorRes)
    {
        if (objectRet)
        {
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                _fristDict = [NSMutableDictionary dictionaryWithDictionary:[objectRet objectForKey:@"data"]];
                __weakObject.FirstPageData = [FirstDataModel objectWithKeyValues:_fristDict];
                [__weakObject createUI];
            }
        }
        
    }];
    
}

-(void)createUI
{
    if (_fristDict) {
        self.unReadMessageArray = self.FirstPageData.pushType;
        NSMutableArray *tempSaveArray ;
        if (self.unReadMessageArray.count > 0) {
            self.hasNewNoti.hidden = NO;
            [[NSNotificationCenter defaultCenter]   postNotificationName:@"redOriginalAppear" object:nil];
            for (int i = 0; i < self.unReadMessageArray.count; i++) {
                NSString *pushType = [NSString stringWithFormat:@"%@",self.unReadMessageArray[i]];
                if ([[NTAccount shareAccount] Messages]) {
                    tempSaveArray = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
                }
                else
                {
                    tempSaveArray = [[NSMutableArray alloc] init];
                }
                
                if(![tempSaveArray containsObject:pushType])
                {
                    [tempSaveArray addObject:pushType];
                }
            }
            [[NTAccount shareAccount] setMessages:tempSaveArray];
        }
        
        [myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)requsetForADData
{
    WeakObject(self);
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetBannerInfoListCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 NSArray *dataArray = [ADModel objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                 __weakObject.ADArray = [NSArray arrayWithArray:dataArray];
                // [myTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                 
                 [__weakObject creatADUI];
             }

         }
    }];
}

-(void)creatADUI
{
    if (self.ADArray.count > 0) {
        
        NSMutableArray *adSourceArray = [[NSMutableArray alloc] init];
        
        for (ADModel *ad in self.ADArray) {
            [adSourceArray addObject:ad.bannerPic];
        }
        // 网络加载图片的轮播器
        if (cycleScrollView == nil) {
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, ADDefaultView.heightValue - 50.0) delegate:self placeholderImage:[UIImage imageNamed:@"firstADDefault"]] ;
            
            [cycleScrollView setTag:1000];
            
            [ADDefaultView addSubview:cycleScrollView];
        }
        cycleScrollView.imageURLStringsGroup = adSourceArray;
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ADModel *ad = self.ADArray[index];
    [self ADViewDidSelectedWith:ad.linkUrl];
}

-(void)requsetForNewsData
{
    WeakObject(self);
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetArticleInfoByListPageNo:@"0" pageSize:@"5" type:@"" andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 NSArray *dataArray = [SuggestModel objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                 __weakObject.NewsArray = [NSArray arrayWithArray:dataArray];
                 [myTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
             }

         }
         
     }];
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.NewsArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.0 : (self.NewsArray.count > 0?sectionHeight:0.0);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FirstTopViewTableViewCell *cell = [FirstTopViewTableViewCell cellWithTableView:tableView];
        
       // [cell cellConfigData:self.ADArray];
        if (_fristDict) {
            [cell cellConfigHealthIndexData:self.FirstPageData.healthNumber];
        }
//        cell.oneADSelected = ^(NSString *linkUrl)
//        {
//            [self ADViewDidSelectedWith:linkUrl];
//        };
        cell.whichBtnBeSelected = ^(NSInteger btnFlag)
        {
            [self normalBtnSelected:btnFlag];
        };
        return cell;
    }
    else
    {
        FirstItemTableViewCell *cell = [FirstItemTableViewCell cellWithTableView:tableView];
        [cell cellConfigData:self.NewsArray[indexPath.row]];
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? self.firstTableViewHeight : 100.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThirdDetailsViewController *details =[[ThirdDetailsViewController alloc]initWithStoryboardID:@"ThirdDetailsViewController"];
    SuggestModel *suggest = [self.NewsArray objectAtIndex:indexPath.row];
    details.articleIdStr = suggest.articleId;
    [self.navigationController pushViewController:details animated:YES];
}

-(void)ADViewDidSelectedWith:(NSString *)linkUrl
{
    if (linkUrl.length > 0) {
        
        [MobClick event:@"firstPageADClicked"];
        WebViewController *H5WebViewController = [[WebViewController alloc] initWithSecondStoryboardID:@"WebViewController"];
        H5WebViewController.Linkurl = [NSURL URLWithString:linkUrl];
        [H5WebViewController setTitleName:@"详情"];
        [self.navigationController pushViewController:H5WebViewController animated:YES];
    }
}

-(void)normalBtnSelected:(NSInteger)flag
{
    //血压
    if (flag == 12) {
        
        [MobClick event:@"firstPageBPBtnClicked"];
        
        if ([[NTAccount shareAccount] FirstGuide]) {
            BloodRressureMonitoringViewController *Blood= [[BloodRressureMonitoringViewController alloc] initWithSecondStoryboardID:@"BloodRressureMonitoringViewController"];
            Blood.isFromMianView = YES;
            [self.navigationController pushViewController:Blood animated:YES];
        }
        else
        {
            BPMeasurementGuidanceViewController *BPMeasurementGuidance=[[BPMeasurementGuidanceViewController alloc]initWithStoryboardID:@"BPMeasurementGuidanceViewController"];
            BPMeasurementGuidance.titleStr =NSLocalizedString(@"Blood pressure measurement guide", nil);
            
            [self.navigationController pushViewController:BPMeasurementGuidance animated:YES];
        }
    }
    //血糖
    if (flag == 13)
    {
        
        [MobClick event:@"firstPageBSBtnClicked"];
        BSMeasureVC *BSMeasure = [[BSMeasureVC alloc] initWithSecondStoryboardID:@"BSMeasureVC"];
        BSMeasure.connectFailed = YES;
        [self.navigationController pushViewController:BSMeasure animated:YES];
    }
    //风险评估
    if (flag == 23)
    {
        [MobClick event:@"firstPageRiskBtnClicked"];
        RiskAssessmentVC *riskVC = [[RiskAssessmentVC alloc] initWithStoryboardID:@"RiskAssessmentVC"];
        riskVC.firstData = self.FirstPageData;
        [self.navigationController pushViewController:riskVC animated:YES];
    }
    //饮食管理
    if (flag == 22)
    {
        MedicationAdministrationVC *MedicationAdministration = [[MedicationAdministrationVC alloc] initWithSecondStoryboardID:@"MedicationAdministrationVC"];
        
        [self.navigationController pushViewController:MedicationAdministration animated:YES];
    }
    //专家咨询
    if (flag == 21)
    {
        [self seekDoctor];
    }
}
- (void)seekDoctor {
    NSString *identify = @"";
    Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *phone =item.phone;
    NSString *pressureId = @"";
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIView *)sectionView
{
    if (_sectionView == nil) {
        
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, sectionHeight)];
        [_sectionView setBackgroundColor:RGBCOLOR(245.0, 245.0, 245.0)];
        
        UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 10.0, SCREENWIDTH, sectionHeight - 10.0)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        //底线
        UIView *blueLinesView =[[UIView alloc]initWithFrame:CGRectMake(0, backView.heightValue - 1.0, SCREENWIDTH, 1.0)];
        blueLinesView.backgroundColor = RGBCOLOR(245.0, 245.0, 245.0);
        [backView addSubview:blueLinesView];
        //图片
        UIView *spImage=[[UIView alloc]initWithFrame:CGRectMake(10.0, 10.0, 3.0, 20.0)];
        [spImage setBackgroundColor:[Tools colorWithHexString:@"01d19e"]];
        [backView addSubview:spImage];
        //信息标签
        UILabel *allLabel =[[UILabel alloc]initWithFrame:CGRectMake(20.0, 10.0,  SCREENWIDTH - 30.0 ,20.0)];
        allLabel.font =[UIFont systemFontOfSize:16];
        allLabel.textColor = RGBCOLOR(51.0, 51.0, 51.0);
        [allLabel setTextAlignment:NSTextAlignmentLeft];
        allLabel.text = NSLocalizedString(@"Health-Info", nil);
        
        [backView addSubview:allLabel];
        
        [_sectionView addSubview:backView];
    }
    
    return _sectionView;
}
#pragma mark  - 按钮点击方法
/**
 *	@brief  三横按钮点击
 */
- (IBAction)ThreeBtnClick:(id)sender
{
    //注册通知事件
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JKSideSlipShow" object:nil userInfo:nil];
}
/**
 *	@brief	提醒
 */
- (IBAction)alertBtnSelected:(id)sender
{
    TimeReminderViewController *Start=[[TimeReminderViewController alloc]initWithStoryboardID:@"TimeReminderViewController"];
    [self.navigationController pushViewController:Start animated:YES];
}



@end

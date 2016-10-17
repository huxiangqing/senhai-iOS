//
//  BSManualInputVC.m
//  LUDE
//
//  Created by lord on 16/6/6.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "BSManualInputVC.h"
#import "PickerView.h"
#import "XDPopoverListView.h"
#import "HistoryBSVC.h"

@interface BSManualInputVC ()<UITextFieldDelegate,pickViewHideAndShow,XDPopoverListDatasource,XDPopoverListDelegate,UINavigationControllerDelegate>
{
    XDPopoverListView   *listView;
    NSString         *showXDPopoverListViewType;//弹框显示的类型
    NSInteger        showXDPopverCount;
    
}
@property (weak, nonatomic) IBOutlet UITextField *BSResultTextField;
@property (weak, nonatomic) IBOutlet UIButton *measureResultButton;
@property (weak, nonatomic) IBOutlet UIButton *measureTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *measureTimeQuantumButton;

@property (strong ,nonatomic)PickerView *pick;
@property (copy, nonatomic) NSString *timeString;
@property (copy ,nonatomic) NSString *measureStateQuantumString;

@property (nonatomic ,retain)NSArray *timeQuantumStatesArray;

@property (nonatomic ,strong) HealthManager *healthManager;

@end

@implementation BSManualInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate =self;
    self.timeQuantumStatesArray = @[@"凌晨",@"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后"];
    
    self.timeString = [Tools stringFromDate:[NSDate date]];
    [self.measureTimeButton setTitle:self.timeString forState:UIControlStateNormal];
    
    BSTimeQuantumType quantumType  = [Tools bsTimeQuantumTypeFromDate:[NSDate date]];
    
    self.measureStateQuantumString = [NSString stringWithFormat:@"%d",quantumType];
    [self.measureTimeQuantumButton setTitle:self.timeQuantumStatesArray[quantumType] forState:UIControlStateNormal];
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.BSResultTextField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    
    const NSInteger limited = 1;//小数点后需要限制的个数
    
    if ([Tools isPureInt:futureString]) {
        if (futureString.length > 2) {
            textField.text = [futureString substringToIndex:2];
            return NO;
        }
    }
    
    NSArray *arr = [futureString componentsSeparatedByString:@"."];
    
    if (arr.count > 2) {
        return NO;
    }
    
    for (NSInteger i = futureString.length - 1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        
        
        flag++;
    }
    return YES;
}
/**
 *	@brief	 测量时间点击事件
 */
- (IBAction)selectTimeButtonClicked:(UIButton *)sender {
    self.pick = [[PickerView alloc] initWithFrame:CGRectMake(0,SCREENHEIGHT - 220 , SCREENWIDTH, 220) PickerStyle:MonthDayHourMinute];
    self.pick.delagate =self;
    [self.view addSubview:self.pick];
}
-(void)PickerViewWillclose
{
    [self.pick removeFromSuperview];
}
-(void)DatePickViewValues:(NSString *)Values
{
    self.timeString = Values;
    [self.measureTimeButton setTitle:Values forState:UIControlStateNormal];
}
/**
 *	@brief	 餐前餐后点击事件
 */
- (IBAction)selectedTimeQuantum:(UIButton *)sender {
    
    [sender setSelected:YES];
    showXDPopoverListViewType=nil;
    showXDPopverCount=self.timeQuantumStatesArray.count;
    
    NSInteger   popverHeight=showXDPopverCount*45;
    if (showXDPopverCount>7) {
        popverHeight=7*45+50;
    }
    
    CGRect frame = CGRectMake(sender.leftValue, sender.bottomValue-sender.heightValue - popverHeight, sender.widthValue,popverHeight);
    
    [self showXDPopoverListViewWithRect:frame];
    
}
#pragma mark -选择
-(void)showXDPopoverListViewWithRect:(CGRect)frame{
    listView=[[XDPopoverListView alloc] initWithFrame:frame titleStr:showXDPopoverListViewType];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}
#pragma arguments
#pragma mark -popoverListViewDelegate
-(CGFloat)popoverListView:(XDPopoverListView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)popoverListView:(XDPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showXDPopverCount;
}

- (UITableViewCell *)popoverListView:(XDPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString    *value=@"";
    
    value=self.timeQuantumStatesArray[indexPath.row];
   
    cell.textLabel.text =value;
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)popoverListView:(XDPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)popoverListView:(XDPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[Tools colorWithHexString:@"01bca8"]];
    
    self.measureStateQuantumString = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.measureTimeQuantumButton setTitle:self.timeQuantumStatesArray[indexPath.row] forState:UIControlStateNormal];
     [self.measureTimeQuantumButton setSelected:NO];
}
/**
 *	@brief	 查看历史数据点击事件
 */
- (IBAction)gotoHistoricalData:(UIButton *)sender {
    if ([self.measureResultButton.currentTitle isEqualToString:@"查看历史血糖"]) {
        HistoryBSVC *historyBSVC = [[HistoryBSVC alloc] initWithSecondStoryboardID:@"HistoryBSVC"];
        historyBSVC.isFromMeasureView = YES;
        [self.navigationController pushViewController:historyBSVC animated:YES];
    }
    else if ([self.measureResultButton.currentTitle isEqualToString:@"完成"])
    {
        if (self.BSResultTextField.text.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入血糖值"];
            return;
        }
        if ([Tools isPureFloat:self.BSResultTextField.text] || [Tools isPureDouble:self.BSResultTextField.text] || [Tools isPureInt:self.BSResultTextField.text]) {
            
            if ([self.BSResultTextField.text doubleValue] > 33.0 || [self.BSResultTextField.text doubleValue] < 1.0) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的血糖值"];
                return;
            }
            else
            {
                [self saveBSValue];
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的血糖值"];
        }
    }
    
}

-(void)saveBSValue
{
    WeakObject(self)
    
    self.healthManager = [HealthManager shareHealthManager];
    
    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
        if (isAuthorizateSuccess) {
            BloodDataModel *dataModel = [[BloodDataModel alloc] init];
            dataModel.BloodGlucose = [__weakObject.BSResultTextField.text doubleValue];
            dataModel.date = [Tools dateFromString:self.timeString];
            [self.healthManager saveBloodDataToHealthstoreWithData:dataModel];
        }
    }];
    
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    [apis PostAddBloodGlucoseWithUserId:item.userId bloodGlucoseValue:self.BSResultTextField.text measureTime:self.timeString measureState:self.measureStateQuantumString equipmentNo:@"" saveType:@"2" andCompletion:^(id objectRet, NSError *errorRes) {
        if (objectRet)
        {
            NSString *statusStr = [NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                [__weakObject.measureResultButton setTitle:@"查看历史血糖" forState:UIControlStateNormal];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }
        }
        
    }];
}
/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

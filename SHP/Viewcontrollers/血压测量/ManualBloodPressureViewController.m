//
//  ManualBloodPressureViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "ManualBloodPressureViewController.h"
#import "PickerView.h"
#import "MainViewController.h"
#import "BloodDataDeneralizationViewController.h"

@interface ManualBloodPressureViewController ()<pickViewHideAndShow>

@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UILabel *lblSYS;
@property (strong, nonatomic) IBOutlet UILabel *lblDIA;
@property (strong, nonatomic) IBOutlet UILabel *lblPulse;
@property (strong ,nonatomic)UILabel *timeLabel;
@property (strong ,nonatomic) UIImageView *arrowImage;
@property (copy, nonatomic) NSString *timeString;
@property (strong, nonatomic) IBOutlet UILabel *lblData;
@property (strong ,nonatomic)PickerView *pick;

@property (nonatomic ,strong) HealthManager *healthManager;
@end

@implementation ManualBloodPressureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"Manual Input", nil)];
    [_lblSYS setText:NSLocalizedString(@"SYS", nil)];
    [_lblDIA setText:NSLocalizedString(@"DIA", nil)];
    [_lblPulse setText:NSLocalizedString(@"Pulse", nil)];
    [_lblData setText:NSLocalizedString(@"Time", nil)];
    [_btnSave setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [self createUI];
}

//创建主界面
-(void)createUI
{
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _timeButton.widthValue -15, _timeButton.heightValue)];
    _timeLabel.font =[UIFont systemFontOfSize:14];
    //_timeLabel.text = @"1235435";
    _timeLabel.textColor =[UIColor colorWithRed:0 green:0.6581647 blue:0.940235294 alpha:1];
    [_timeButton addSubview:_timeLabel];
    
    _arrowImage =[[UIImageView alloc]initWithFrame:CGRectMake(_timeButton.widthValue-15, 9, 10, 10)];
    _arrowImage.image =[UIImage imageNamed:@"xiajiantou"];
    [_timeButton addSubview:_arrowImage];
    
    for (UITextField *TF in self.textFieldArr) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 30.0)];
        TF.leftViewMode = UITextFieldViewModeAlways;
        TF.leftView = leftView;
    }
    
    self.timeString = [Tools stringFromDate:[NSDate date]];
    _timeLabel.text = [NSString stringWithFormat:@"   %@",self.timeString];
}

-(void)viewWillLayoutSubviews
{
    _timeLabel.frame = CGRectMake(0, 0, _timeButton.widthValue-15, _timeButton.heightValue);
    _arrowImage.frame =CGRectMake(_timeButton.widthValue-15, 9, 10, 10);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [Tools dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.pick removeFromSuperview];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 按钮点击事件
/**
 *	@brief  时间按钮点击
 */
- (IBAction)TimeBtnClick:(UIButton *)sender
{
    for (UITextField *textfield in self.textFieldArr) {
        [textfield resignFirstResponder];
    }
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
    _timeLabel.text = [NSString stringWithFormat:@"   %@",Values];
}
/**
 *	@brief  返回
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief  保存
 */
- (IBAction)PreservationBtnClick:(UIButton *)sender
{
    UITextField *spTF = self.textFieldArr[0];
    NSString *sp = spTF.text;
    UITextField *dspTF = self.textFieldArr[1];
    NSString *dsp = dspTF.text;
    UITextField *hpTF = self.textFieldArr[2];
    NSString *hp = hpTF.text;
    
    for (UITextField *textfield in self.textFieldArr)
    {
        [textfield resignFirstResponder];
    }
    
    if (sp.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"You do not fill in the systolic pressure", nil)];
        return;
    }
    if (dsp.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"You have not filled in diastolic pressure", nil)];
        return;
    }
    if (hp.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"You haven't filled in the pulse", nil)];
        return;
    }
    if (self.timeString.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"You have not completed the measurement time", nil)];
        return;
    }
  
    if ((sp.length > 0) && (dsp.length > 0) && (hp.length > 0) && (self.timeString.length > 0)){
        if (sp.integerValue > 200||sp.integerValue <10) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please enter the correct values within the 10~200", nil)];
            return;
        }
        if (dsp.integerValue > 200||dsp.integerValue <10) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please enter the correct values within the 10~200", nil)];
            return;
        }
        if (hp.integerValue > 200||hp.integerValue <10) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please enter the correct values within the 10~200", nil)];
            return;
        }
        
        if (dsp.integerValue > sp.integerValue)
        {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Systolic blood pressure should not be less than diastolic blood pressure", nil)];
            return;
        }
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        WeakObject(self);
        
        self.healthManager = [HealthManager shareHealthManager];
        
        [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
            if (isAuthorizateSuccess) {
                BloodDataModel *dataModel = [[BloodDataModel alloc] init];
                dataModel.BloodPressureDiastolic = [dsp integerValue];
                dataModel.BloodPressureSystolic = [sp integerValue];
                dataModel.HeartRate = [hp integerValue];
                dataModel.date = [Tools dateFromString:__weakObject.timeString];
                [self.healthManager saveBloodDataToHealthstoreWithData:dataModel];
            }
        }];
        
        Userinfo *user = [NTAccount shareAccount].userinfo;
        
        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        [apis SaveBloodPressureDataRequestWithUserId:user.userId equipmentNo:self.SerialNo  bloodPressureOpen:dsp bloodPressureClose:sp pulse:hp measureTime:self.timeString type:@"2" andCompletion:^(id objectRet, NSError *errorRes)
         {
             if(objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",objectRet[@"msg"]] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                {
                                                    if ([statusStr isEqualToString:@"1"]) {
                                                        BloodDataDeneralizationViewController *data =[[BloodDataDeneralizationViewController alloc] initWithSecondStoryboardID:@"BloodDataDeneralizationViewController"];
                                                        Userinfo *user = [NTAccount shareAccount].userinfo;
                                                        data.userId = user.userId;
                                                        [__weakObject.navigationController pushViewController:data animated:YES];
                                                    }
                                                }];
                 [alertController addAction:otherAction];
                 [self presentViewController:alertController animated:YES completion:nil];
             }
            
         }];
    }
}
@end

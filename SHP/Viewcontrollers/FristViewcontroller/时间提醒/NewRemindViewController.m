//
//  NewRemindViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "NewRemindViewController.h"
#import "UUDatePicker.h"
@interface NewRemindViewController ()<UUDatePickerDelegate>

@property (strong ,nonatomic)NSString *hour;
@property (strong ,nonatomic)NSString *minute;
@end

@implementation NewRemindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createUI];
}
-(void)createUI
{
    if (_EditOrNOBOOL == NO)
    {
        _titleLabel.text = NSLocalizedString(@"Add Alert", nil);
    }
    else
    {
        _titleLabel.text = NSLocalizedString(@"Edit Alert", nil);
    }
    
    [_saveBtn setTitle:NSLocalizedString(@"Save", @"保存") forState:UIControlStateNormal];
       //获取当前时间
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        int hour = [dateComponent hour];
        int minute = [dateComponent minute];
        _hour =[NSString stringWithFormat:@"%d",hour];
        _minute =[NSString stringWithFormat:@"%d",minute];
    
    
   
        UUDatePicker *datePicker =[[UUDatePicker alloc]initWithframe:CGRectMake(0, 74, self.view.widthValue, 200) Delegate:self PickerStyle:UUDateStyle_HourMinute];
        [self.view addSubview:datePicker];

       if ( [[[UIDevice currentDevice] systemVersion] floatValue]>=9)
       {
           UIView *blueView =[[UIView alloc]initWithFrame:CGRectMake(0, datePicker.topValue+80, 6, 40)];
           blueView.backgroundColor=RGBCOLOR(0, 168, 240);
           [self.view addSubview:blueView];
           
           
           UIView *linesView =[[UIView alloc]initWithFrame:CGRectMake(self.view.widthValue/2, datePicker.topValue+86, 1, 27)];
           linesView.backgroundColor=[UIColor lightGrayColor];
           [self.view addSubview:linesView];
       }
       else
       {
           UIView *blueView =[[UIView alloc]initWithFrame:CGRectMake(0, datePicker.topValue+70, 6, 40)];
           blueView.backgroundColor=RGBCOLOR(0, 168, 240);
           [self.view addSubview:blueView];
           
           
           UIView *linesView =[[UIView alloc]initWithFrame:CGRectMake(self.view.widthValue/2, datePicker.topValue+76, 1, 27)];
           linesView.backgroundColor=[UIColor lightGrayColor];
           [self.view addSubview:linesView];
        
       }
    
    
}

-(void)uuDatePicker:(UUDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay
{
    _hour =hour;
    _minute=minute;
}

-(void)createTimeHour:(NSString *)Hour minute:(NSString *)minute
{
    Userinfo *user = [NTAccount shareAccount].userinfo;
    
    if (_EditOrNOBOOL == YES)
    {//编辑
         NSString *IdStr =[NSString stringWithFormat:@"%@",[_dict objectForKey:@"id"]];
         NSString *remindTypeStr =[NSString stringWithFormat:@"%@",[_dict objectForKey:@"remindType"]];
         NSString *stateStr =[NSString stringWithFormat:@"%@",[_dict objectForKey:@"state"]];
        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        [apis PostUpdateRemindInfoId:IdStr remindHour:Hour remindMinute:minute remindType:remindTypeStr state:stateStr userId:user.userId andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     //[SVProgressHUD showWithStatus:[objectRet objectForKey:@"msg"]];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
                 }
           }
        
        }];
    }
    else
    {
      
        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        [apis PostaddRemindHour:Hour remindMinute:minute remindType:_remindTypeStr state:@"1" userId:user.userId andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     //[SVProgressHUD showWithStatus:[objectRet objectForKey:@"msg"]];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
                 }
           }
           
         }];
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
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	保存
 */
- (IBAction)Preservation:(UIButton *)sender
{
    
    //
    if (_EditOrNOBOOL == YES)
    {//编辑
         [self createTimeHour:_hour minute:_minute];
    }
    else
    {//新增
        [self createTimeHour:_hour minute:_minute];
    }

   
}

@end

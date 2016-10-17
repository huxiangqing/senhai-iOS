//
//  CalendarVC.m
//  LUDE
//
//  Created by lord on 16/6/8.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "CalendarVC.h"
#import "CalendarHomeViewController.h"
@interface CalendarVC ()
{
    CalendarHomeViewController *chvc;
    
    NSString *startTimeString;
    NSString *endTimeString;
    
    UIView * mainView;
}

@property (nonatomic ,retain) NSMutableArray * dataArray;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray=[[NSMutableArray alloc] init];
    
    chvc = [[CalendarHomeViewController alloc]init];
    chvc.timeInterval = self.timeInterval;  
    chvc.view.frame=CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height - 64.0 - 50.0);
    [self.view addSubview:chvc.view];
    
    [chvc setPassedToDay:9000 ToDateforString:nil];

    [self mainViewClass:0];
    
    WeakObject(self);
    chvc.calendarblock = ^(CalendarDayModel *model){
        
        if(model.style==CellDayTypeClick)
        {
            [__weakObject.dataArray addObject:model.toString];
            
            NSSet *set = [NSSet setWithArray:__weakObject.dataArray];
            __weakObject.dataArray=[[set allObjects] mutableCopy];
            
            [__weakObject.dataArray sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                return [obj1 compare:obj2];
            }];
            
        }
        else
        {
            [__weakObject.dataArray removeObject:model.toString];
            
        }
        
        [__weakObject mainViewClass:__weakObject.dataArray.count];
        
    };

}
-(void)mainViewClass:(NSInteger)num
{
    
    [mainView removeFromSuperview];
    
    mainView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50,self.view.frame.size.width,50)];
    mainView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:mainView];
    
    
    UILabel * lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    lable.font=[UIFont systemFontOfSize:14.0f];
    lable.textColor=[UIColor whiteColor];
    lable.textAlignment=NSTextAlignmentCenter;
    [mainView addSubview:lable];
    
    
    
    if(num==0)
    {
        lable.text=@"请选择开始时间";
    }
    if(num==1)
    {
        lable.text=[NSString stringWithFormat:@"%@ 共1天",[self.dataArray objectAtIndex:0]];
        
        startTimeString = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:0]];
        endTimeString = startTimeString;
    }
    if(num==2)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate* date1 = [formatter dateFromString:[self.dataArray objectAtIndex:0]];
        NSDate* date2 = [formatter dateFromString:[self.dataArray objectAtIndex:1]];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:date1 toDate:date2  options:0];
        
        int days = [comps day];
        
        lable.text=[NSString stringWithFormat:@"%@开始---%@结束 共%d天",[self.dataArray objectAtIndex:0],[self.dataArray objectAtIndex:1],days];
        
        startTimeString = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:0]];
        endTimeString = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:1]];
        
    }
    
    
}

- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startAndEndTime:(UIButton *)sender {
    
    if (self.dataArray.count > 0) {
        
        self.screenStartTimeAndEndTime(startTimeString,endTimeString);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
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

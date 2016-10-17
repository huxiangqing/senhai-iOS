//
//  CityPickerView.m
//  MudderRun
//
//  Created by 曹巍 on 15/5/7.
//  Copyright (c) 2015年 com.hongfu. All rights reserved.
//

#import "PickerView.h"

@interface PickerView()<UUDatePickerDelegate>
@property (nonatomic,strong) NSString *strPickDate;

@end

@implementation PickerView

-(instancetype)initWithFrame:(CGRect)frame PickerStyle:(PickTYPE) style
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:frame];
    [self.closeButton$UIButton setFrame:CGRectMake(0, 10, 80.0, 30.0)];
    [self.doneButton$UIButton setFrame:CGRectMake(frame.size.width - 80.0, 10.0, 80.0, 30.0)];
    [self.line$UIView setFrame:CGRectMake(0.0, self.closeButton$UIButton.bottomValue  + 5.0, frame.size.width, 1.0)];
    
    
    [self addSubview:self.closeButton$UIButton];
    [self addSubview:self.doneButton$UIButton];
    [self addSubview:self.line$UIView];
    
    self.line$UIView.bottomValue = self.closeButton$UIButton.bottomValue + 5.0;
    
    NSDate *now = [NSDate date];
    self.datePicker= [[UUDatePicker alloc] initWithframe:CGRectMake(0.0, self.line$UIView.bottomValue, frame.size.width, self.heightValue - self.line$UIView.bottomValue) Delegate:self PickerStyle:(DateStyle)style];
        self.datePicker.ScrollToDate = now;
        self.datePicker.maxLimitDate = now;
        NSString *minDate = @"1900-01-01 00:00:00";
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [inputFormatter dateFromString:minDate];
        self.datePicker.minLimitDate = date;
        self.datePicker.backgroundColor = [UIColor clearColor];
        [self addSubview:self.datePicker];
    
        self.strPickDate = [self stringFromDate:[NSDate date]];

    self.pickstyle = style;
    
    return self;
}
-(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    self.strPickDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
}
-(void)pickerDone
{
    [self setHidden:YES];
    NSString *time = self.strPickDate;
    [self.delagate DatePickViewValues:time];
}
-(void)pickerHide
{
    [self.delagate PickerViewWillclose];
    [self setHidden:YES];
}
-(UIButton *)closeButton$UIButton
{
    if(_closeButton$UIButton == nil)
    {
        _closeButton$UIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton$UIButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_closeButton$UIButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [_closeButton$UIButton setBackgroundColor:RGBCOLOR(113, 113, 113)];
        [_closeButton$UIButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE14]];
        [_closeButton$UIButton addTarget:self action:@selector(pickerHide) forControlEvents:UIControlEventTouchUpInside];
        _closeButton$UIButton.titleLabel.textColor = [UIColor whiteColor];
    }
    return _closeButton$UIButton;
}
-(UIButton *)doneButton$UIButton
{
    if(_doneButton$UIButton == nil)
    {
        _doneButton$UIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton$UIButton setTitle:@"完成" forState:UIControlStateNormal];
       // [_doneButton$UIButton setBackgroundColor:RGBCOLOR(113, 113, 113)];
        [_doneButton$UIButton setTitleColor:RGBCOLOR(0, 161.0, 244.0) forState:UIControlStateNormal];
        [_doneButton$UIButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE14]];
        [_doneButton$UIButton addTarget:self action:@selector(pickerDone) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneButton$UIButton;
}
-(UIView *)line$UIView
{
    if(_line$UIView == nil)
    {
        _line$UIView = [[UIView alloc] init];
        [_line$UIView setBackgroundColor:[UIColor blackColor]];
    }
    return _line$UIView;
}

#pragma mark - UUDatePicker's delegate


//hide keyboard
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}


@end

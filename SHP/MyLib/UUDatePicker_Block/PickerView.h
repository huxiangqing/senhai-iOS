//
//  CityPickerView.h
//  MudderRun
//
//  Created by 曹巍 on 15/5/7.
//  Copyright (c) 2015年 com.hongfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUDatePicker.h"

typedef enum PickType{
YearMonthDayHourMinute ,
    YearMonthDay,
    MonthDayHourMinute,
    HourMinute,
}PickTYPE;

@protocol pickViewHideAndShow <NSObject>

-(void)PickerViewWillclose;
-(void)DatePickViewValues:(NSString *)Values;


@end

@interface PickerView : UIView<UUDatePickerDelegate>

@property (nonatomic,strong) UUDatePicker *datePicker;
@property (nonatomic ,strong)UIButton *closeButton$UIButton;
@property (nonatomic ,strong)UIButton *doneButton$UIButton;
@property (nonatomic ,retain)UIView *line$UIView;
@property (nonatomic,assign) PickTYPE pickstyle;

@property (nonatomic ,assign)id<pickViewHideAndShow>delagate;

-(instancetype)initWithFrame:(CGRect)frame PickerStyle:(PickTYPE) style;

@end

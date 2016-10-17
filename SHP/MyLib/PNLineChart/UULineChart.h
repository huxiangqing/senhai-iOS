//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define chartLeftMargin  10.0
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     30
#define UUTagLabelwidth     80
#define UUTopHeight    40
#define UUbottomHeight    40

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic, strong) NSArray * fillColors;

@property (nonatomic, strong) NSArray * pointBackGroundImages;

@property (nonatomic, assign) CGFloat yValueCount;

@property (nonatomic, copy) NSString *dashLineName;

@property (nonatomic ,assign) NSInteger maxOpenValue;
@property (nonatomic ,assign) NSInteger minOpenValue;
@property (nonatomic ,assign) NSInteger maxCloseValue;
@property (nonatomic ,assign) NSInteger minCloseValue;

@property ( nonatomic ,retain) NSArray *PopViewArray;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSArray *animationDurationArray;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

-(void)strokeChart;

- (NSArray *)chartLabelsForX;

@end

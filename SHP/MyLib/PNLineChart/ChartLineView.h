//
//  ChartLineView.h
//  inputView
//
//  Created by JHR on 15/11/13.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UULineChart.h"
#import "UUColor.h"
#import "ChartLineView.h"
#import "UUChartLabel.h"

@class ChartLineView ;

@protocol ChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)Chart_xLableArray:(ChartLineView  *)chart;
//数值多重数组
- (NSArray *)Chart_yValueArray:(ChartLineView  *)chart;
//y轴分段个数
- (CGFloat)Chart_yValueCount:(ChartLineView  *)chart;

@optional
//颜色数组
- (NSArray *)Chart_ColorArray:(ChartLineView *)chart;
- (NSArray *)Chart_FillColorArray:(ChartLineView *)chart;
//气泡数组
- (NSArray *)Chart_PointBackGroundImageArray:(ChartLineView *)chart;
//显示数值范围
- (CGRange)ChartChooseRangeInLineChart:(ChartLineView *)chart;
- (NSArray *)animationDurationForLineArray:(ChartLineView *)chart;
//显示最大值最小值
- (NSInteger)Chart_maxOpenValue:(ChartLineView  *)chart;
- (NSInteger)Chart_maxCloseValue:(ChartLineView  *)chart;
- (NSInteger)Chart_minCloseValue:(ChartLineView  *)chart;
- (NSInteger)Chart_minOpenValue:(ChartLineView  *)chart;
- (NSArray *)showPopViewArray:(ChartLineView *)chart;
//- (NSArray *)Chart_CloseValueArray:(ChartLineView  *)chart;
//- (NSArray *)Chart_OpenValueArray:(ChartLineView  *)chart;
#pragma mark 折线图专享功能

@end

@interface ChartLineView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UULineChart * lineChart;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (assign, nonatomic) id<ChartDataSource> dataSource;
@property (nonatomic ,strong)UIView *lableView;
@property (nonatomic ,copy) NSString *dashLine;

-(id)initWithChartDataFrame:(CGRect)rect withSource:(id<ChartDataSource>)dataSource withDashName:(NSString *)dashName;

- (void)showInView:(UIView *)view;
-(void)strokeChart;
-(void)strokeChartReDraw;

@end

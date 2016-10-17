//
//  ChartLineView.m
//  inputView
//
//  Created by JHR on 15/11/13.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import "ChartLineView.h"

@implementation ChartLineView

-(id)initWithChartDataFrame:(CGRect)rect withSource:(id<ChartDataSource>)dataSource withDashName:(NSString *)dashName
{
    self.dataSource = dataSource;
    self.dashLine = dashName;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}
-(void)setUpChart{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 30.0, self.frame.size.height)];
        _scrollView.contentMode = UIViewContentModeLeft;
        _scrollView.contentSize = CGSizeMake( CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    
    if ([self.dataSource Chart_xLableArray:self].count > 4)
    {
        _scrollView.contentSize = CGSizeMake(((self.scrollView.frame.size.width/4)*([self.dataSource Chart_xLableArray:self].count - 1) + chartLeftMargin), CGRectGetHeight(self.scrollView.frame));
    }
    else
    {
        [_scrollView setScrollEnabled:NO];
    }
    
    if(!_lineChart){
        _lineChart = [[UULineChart alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.frame.size.height)];
        [_lineChart setDashLineName:self.dashLine];
        [_scrollView addSubview:_lineChart];
    }

       //选择显示范围
    if ([self.dataSource respondsToSelector:@selector(ChartChooseRangeInLineChart:)]) {
        [_lineChart setChooseRange:[self.dataSource ChartChooseRangeInLineChart:self]];
    }
    //显示颜色
    if ([self.dataSource respondsToSelector:@selector(Chart_ColorArray:)]) {
        [_lineChart setColors:[self.dataSource Chart_ColorArray:self]];
        [_lineChart setFillColors:[self.dataSource Chart_FillColorArray:self]];
        [_lineChart setYValueCount:[self.dataSource Chart_yValueCount:self]];
        [_lineChart setPointBackGroundImages:[self.dataSource Chart_PointBackGroundImageArray:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(animationDurationForLineArray:)]) {
        [_lineChart setAnimationDurationArray:[self.dataSource animationDurationForLineArray:self]];
    }
     if ([self.dataSource respondsToSelector:@selector(Chart_maxOpenValue:)]) {
         [_lineChart setMaxOpenValue:[self.dataSource Chart_maxOpenValue:self]];
     }
    if ([self.dataSource respondsToSelector:@selector(Chart_maxCloseValue:)]) {
         [_lineChart setMaxCloseValue:[self.dataSource Chart_maxCloseValue:self]];
    }
    if ([self.dataSource respondsToSelector:@selector(Chart_minCloseValue:)]) {
          [_lineChart setMinCloseValue:[self.dataSource Chart_minCloseValue:self]];
    }
    if ([self.dataSource respondsToSelector:@selector(Chart_minOpenValue:)]) {
          [_lineChart setMinOpenValue:[self.dataSource Chart_minOpenValue:self]];
    }
    if ([self.dataSource respondsToSelector:@selector(showPopViewArray:)]) {
        [_lineChart setPopViewArray:[self.dataSource showPopViewArray:self]];
    }
    
    [_lineChart setYValues:[self.dataSource Chart_yValueArray:self]];
    [_lineChart setXLabels:[self.dataSource Chart_xLableArray:self]];
    
    CGRange valueRange = [self.dataSource ChartChooseRangeInLineChart:self];
    float level = (valueRange.max - valueRange.min) / [self.dataSource Chart_yValueCount:self];
    CGFloat chartCavanHeight = self.frame.size.height - (UUbottomHeight+UUTopHeight);
    CGFloat levelHeight = chartCavanHeight / [self.dataSource Chart_yValueCount:self];
    
    [_lineChart setYValueMax:valueRange.max];
    [_lineChart setYValueMin:valueRange.min];
    
    if (!self.lableView) {
        self.lableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UUYLabelwidth, UULabelHeight)];
        for (int i=0; i<([self.dataSource Chart_yValueCount:self] + 1); i++) {
            UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight + UUTopHeight - 5.0, UUYLabelwidth, UULabelHeight)];
            label.text = [NSString stringWithFormat:@"%d",(int)(level * i+0 + valueRange.min)];
            [self.lableView addSubview:label];
        }
        
        [self addSubview:self.lableView];
    }
    
    [_lineChart strokeChart];
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}
-(void)strokeChart
{
    [self setUpChart];
}
-(void)strokeChartReDraw
{
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _lineChart  = nil;
    
    [self setUpChart];
}
@end

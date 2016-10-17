//
//  baseChartView.m
//  inputView
//
//  Created by JHR on 15/12/3.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import "baseChartView.h"

#define BASEYLableHeight  18.0
#define BASEYLableWidth  40.0
#define BASENormalLineWidth  10.0
#define BASEShortLineWidth  5.0

@implementation baseChartView
{
    NSHashTable *_chartLabelsForX;
    UIColor *COLOR;
}

-(void)drawWithTheDataArray:(NSArray *)dataArray
{
        
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    [self setBackgroundColor:[UIColor clearColor]];
    
    COLOR = [Tools colorWithHexString:@"#ffffff" alpha:0.4];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(BASEYLableWidth+BASENormalLineWidth,0)];
    [path addLineToPoint:CGPointMake(BASEYLableWidth+BASENormalLineWidth,self.frame.size.height)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor =  [COLOR CGColor];
    shapeLayer.fillColor = [COLOR CGColor];
    shapeLayer.lineWidth = 1;
    [self.layer addSublayer:shapeLayer];
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortArray;
    if (dataArray.count > 0) {
        sortArray= [dataArray sortedArrayUsingComparator:cmptr];
    }
    
    NSInteger theMaxValue ,theMinValue;
    theMaxValue = 0;
    theMinValue = 0;
    
    if (sortArray.count >0) {
        theMaxValue = [[sortArray lastObject] integerValue];
        theMinValue = [[sortArray firstObject] integerValue];
    }
    
    CGFloat YMargin = (self.frame.size.height - 2*8.0)/4.0;
    
    for (int i = 1; i < 6; i ++) {
        //画长线
        if ((i%2) == 1) {
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            [pathLine moveToPoint:CGPointMake(BASEYLableWidth,8.0 +(i - 1)*YMargin)];
            [pathLine addLineToPoint:CGPointMake(BASEYLableWidth+BASENormalLineWidth,8.0+(i - 1)*YMargin)];
            [pathLine closePath];
            lineLayer.path = pathLine.CGPath;
            lineLayer.strokeColor =  [COLOR  CGColor];
            lineLayer.fillColor = [COLOR CGColor];
            lineLayer.lineWidth = 1;
            [self.layer addSublayer:lineLayer];
        }
        else
        {
             //画短线
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            UIBezierPath *pathLine = [UIBezierPath bezierPath];
            [pathLine moveToPoint:CGPointMake(BASEYLableWidth+BASEShortLineWidth,8.0 +(i - 1)*YMargin)];
            [pathLine addLineToPoint:CGPointMake(BASEYLableWidth+BASENormalLineWidth,8.0+(i - 1)*YMargin)];
            [pathLine closePath];
            lineLayer.path = pathLine.CGPath;
            lineLayer.strokeColor =  [COLOR  CGColor];
            lineLayer.fillColor = [COLOR CGColor];
            lineLayer.lineWidth = 1;
            [self.layer addSublayer:lineLayer];
        }
    }
    
    NSMutableArray *YValues = [[NSMutableArray alloc] init];

    theMaxValue = theMaxValue % 10 ? (theMaxValue/10 + 1)*10 : theMaxValue;
    theMinValue = theMinValue % 10 ? (theMinValue/10 )*10 : theMinValue;
    
    CGFloat levelValue = (theMaxValue - theMinValue) / 2.0;
    
    //NSInteger multiMinValue =  ( theMinValue/50) > 0 ? 50 *(theMinValue/50):50;
    
    theMinValue = (theMinValue == 0) ? 50 : theMinValue;
    levelValue = (levelValue > 0.0) ? levelValue : 50;
    
    for (int i = 0; i < 3; i ++) {
        [ YValues addObject:[NSNumber numberWithInteger: theMinValue + levelValue*(i)]];
    }
    for (int i = 0; i < YValues.count; i ++) {
        NSNumber *data = YValues[YValues.count - i - 1 ];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*i*YMargin, BASEYLableWidth, BASEYLableHeight)];
        lable.text = [NSString stringWithFormat:@"%d",data.integerValue];
        [lable setFont:[UIFont systemFontOfSize:13.0]];
        [lable setTextAlignment:NSTextAlignmentCenter];
        [lable setTextColor:[Tools colorWithHexString:@"#ffffff" alpha:(1 - 0.3*i)]];
        [self addSubview:lable];
    }
    
    CGFloat XMargin = (self.frame.size.width - 3.0*BASEYLableWidth/2.0)/2.0;
    CGFloat Level =   (self.frame.size.height - 2*8.0)/([[YValues lastObject] integerValue]  -   [[YValues firstObject] integerValue]);
    
    [self addLineAndPoint:dataArray XMargin:XMargin Level:Level theMinValue:[[YValues firstObject] integerValue]];
    
}

-(void)addLineAndPoint:(NSArray *)pointArray XMargin:(CGFloat)XMargin Level:(CGFloat)Level theMinValue:(NSInteger)theMinValue
{
    if (pointArray.count == 0) {
        return;
    }
    
    CGFloat xPosition = BASEYLableWidth+BASENormalLineWidth;
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    NSInteger firstValue = [[pointArray objectAtIndex:0] integerValue];
    
    [self addPoint:CGPointMake(xPosition, self.frame.size.height -  (firstValue - theMinValue)*Level - 8.0)
             index:0
             value:firstValue ];
    
    [progressline moveToPoint:CGPointMake(xPosition,self.frame.size.height -(firstValue - theMinValue)*Level - 8.0)];
    [progressline setLineWidth:2.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    
    NSInteger index = 0;
    for (NSNumber * value in pointArray) {
        if (index != 0) {
            CGPoint point = CGPointMake(xPosition+index*XMargin, self.frame.size.height -(([value integerValue]- theMinValue)*Level + 8.0));
            [progressline addLineToPoint:point];
            [progressline moveToPoint:point];
            
            [self addPoint:point
                     index:index
                     value:[value integerValue]];
        }
        index += 1;
    }
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = progressline.CGPath;
    lineLayer.strokeColor =  [COLOR  CGColor];
    lineLayer.lineWidth = 1;
    [self.layer addSublayer:lineLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.6;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    lineLayer.strokeEnd = 1.0;
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index  value:(NSInteger)value
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view setFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGBCOLOR(102, 180, 230).CGColor;

    view.backgroundColor = RGBCOLOR(102, 180, 230);
    [self addSubview:view];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}
@end

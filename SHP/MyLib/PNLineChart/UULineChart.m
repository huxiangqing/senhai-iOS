//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import <objc/runtime.h>
#import "UUPointValue.h"

#define AssociatedObject @"AssociatedObject"

@interface UULineChart ( )


@property (nonatomic ,retain) UUPointValue *selectedUUPointValue;
@property (nonatomic ,retain) UUPointValue *tempUUPointValue;

@property (nonatomic , strong)  UIImageView *currentPosView;
@property (nonatomic ,strong) NSMutableArray *selectViewArray;
@property (nonatomic ,strong) NSMutableArray *selectBtnArray;
@property (nonatomic , retain)UIButton *tempBtn;

@end

@implementation UULineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.currentPosView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftMargin, UULabelHeight, 1 / self.contentScaleFactor, frame.size.height -  UUbottomHeight - UULabelHeight)];
        self.currentPosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.currentPosView.alpha = 0.0;
        [self addSubview:self.currentPosView];
        self.userInteractionEnabled = YES;
        self.selectViewArray = [[NSMutableArray alloc] init];
        self.selectBtnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setDashLineName:(NSString *)dashLineName
{
     [self.currentPosView setImage:[UIImage imageNamed:dashLineName]];
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }


    CGFloat chartCavanHeight = self.frame.size.height  - (UUTopHeight+UUbottomHeight);//
    CGFloat levelHeight = chartCavanHeight /_yValueCount;
    
    //画横线
    for (int i=0; i<([NSNumber numberWithFloat:_yValueCount].intValue + 1); i++) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
           [path moveToPoint:CGPointMake(0,UUTopHeight+i*levelHeight)];
          [path addLineToPoint:CGPointMake(self.frame.size.width,UUTopHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    CGFloat num = 0;
   if (xLabels.count == 0){
        num=1.0;
    }else if (xLabels.count<=4){
        num= 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - 3*chartLeftMargin)/(num - 1);
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth, self.frame.size.height  - UUbottomHeight+ UULabelHeight, 50.0, UUbottomHeight - 10.0)];
        label.text = labelText;
        [label setNumberOfLines:2];
        //label.adjustsFontSizeToFitWidth = YES;
        [label sizeToFit];
        [self addSubview:label];
        
        [_chartLabelsForX addObject:label];
    }
}

-(void)setPopViewArray:(NSArray *)PopViewArray
{
    _PopViewArray = PopViewArray;
}
-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
-(void)setFillColors:(NSArray *)fillColors
{
    _fillColors = fillColors;
}
-(void)setPointBackGroundImages:(NSArray *)pointBackGroundImages
{
    _pointBackGroundImages = pointBackGroundImages;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i;
        NSInteger min_i;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath* fill = [UIBezierPath bezierPath];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        NSInteger firstValue = [[childAry objectAtIndex:0] integerValue];
        CGFloat xPosition = (chartLeftMargin);
        CGFloat chartCavanHeight = self.frame.size.height - (UUTopHeight + UUbottomHeight);
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + UUTopHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue valueIndex:0];
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + UUTopHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
    
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            
            
            if (index != 0) {
                NSNumber* last = childAry[index - 1];
                NSNumber* number = childAry[index];
                CGPoint p1 = CGPointMake(xPosition+(index - 1)*_xLabelWidth, chartCavanHeight - ([last floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin) * chartCavanHeight + UUTopHeight);
                
                CGPoint p2 = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - ([number floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin) * chartCavanHeight + UUTopHeight);
                
                [fill moveToPoint:p1];
                [fill addLineToPoint:p2];
                [fill addLineToPoint:CGPointMake(p2.x, chartCavanHeight + UUTopHeight)];
                [fill addLineToPoint:CGPointMake(p1.x, chartCavanHeight + UUTopHeight)];
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight + UUTopHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString integerValue] valueIndex:index];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [UUGreen CGColor];
        }
    
        UIColor *fillColor = [_fillColors objectAtIndex:i];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        fillLayer.bounds = self.bounds;
        fillLayer.path = fill.CGPath;
        fillLayer.strokeColor = nil;
        if (_fillColors.count > 1) {
            if(i == 0)
            {
                fillLayer.fillColor = [UIColor clearColor].CGColor;
            }
            else
            {
                fillLayer.fillColor = fillColor.CGColor;
            }
        }
        else
        {
             fillLayer.fillColor = fillColor.CGColor;
        }
        fillLayer.lineWidth = 0;
        fillLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:fillLayer];
        
//        fillLayer.zPosition = 0;
//        _chartLine.zPosition = 1;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = ([[self.animationDurationArray objectAtIndex:i] doubleValue] / 4.0) * childAry.count;//childAry.count*0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
    
}

- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(NSInteger)value valueIndex:(NSInteger)valueIndex
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view setFrame:CGRectMake(5, 5, 10, 10)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
    [view addTarget:self action:@selector(pointBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
    [view setTag:(value + 1000*index  + 100*valueIndex)];
    [self addSubview:view];
    
    CGRect rect;
     rect =CGRectMake(view.center.x-30.0, view.frame.origin.y-UULabelHeight*4, 60.0, UULabelHeight*3);
    
    if (self.PopViewArray) {
        NSArray *valueArray = self.PopViewArray[index];
        if ([valueArray containsObject:[NSNumber numberWithInteger:value]])
        {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + UULabelHeight*(2.5), rect.size.width, rect.size.height- 20.0)];
            [lable setBackgroundColor:[UIColor clearColor]];
            [lable setText:[NSString stringWithFormat:@"%ld",value]];
            [lable setFont:[UIFont systemFontOfSize:14.0]];
            [lable setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:lable];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:valueArray];
            [tempArray removeObject:[NSNumber numberWithInteger:value]];
            [tempArray addObject:[NSNumber numberWithInteger:0]];
            NSMutableArray *changeArray = [[NSMutableArray alloc] initWithArray:self.PopViewArray];
            [changeArray replaceObjectAtIndex:index withObject:tempArray];
            self.PopViewArray = nil;
            self.PopViewArray = changeArray;
        }
    }

    if ((view.centerXValue - 30.0) < 0) {
        rect =CGRectMake(0, view.frame.origin.y-UULabelHeight*4, 60.0, UULabelHeight*3);
    }
    else if ((view.centerXValue + 30.0) > self.widthValue)
    {
        rect =CGRectMake(self.widthValue - 60.0, view.frame.origin.y-UULabelHeight*4, 60.0, UULabelHeight*3);
    }
    
    NSString *popImageName = _pointBackGroundImages[index];
    
    UUPointValue *pointImageView = [[UUPointValue alloc] initWithChartValueSHowFrame:rect withBackgroundImageViewNameString:popImageName withPointValueString: [NSString stringWithFormat:@"%ld",value]];
    objc_setAssociatedObject(view,AssociatedObject,pointImageView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)pointBtnSelected:(UIButton *)btn
{
    if (self.selectViewArray.count > 0) {
        for (UUPointValue *pointImageView  in self.selectViewArray) {
            [pointImageView removeFromSuperview];
        }
        
        [self.selectViewArray removeAllObjects];
        [self.selectBtnArray removeAllObjects];
    }
    if (self.selectedUUPointValue) {
        [self.selectedUUPointValue removeFromSuperview];
        [self smaller:self.tempBtn];
    }
    UUPointValue *pointImageView = objc_getAssociatedObject(btn, AssociatedObject);
    
    [self addSubview:pointImageView];
    self.selectedUUPointValue = pointImageView;
    [self bringSubviewToFront:self.selectedUUPointValue];
    self.tempBtn = btn;
    [self bigger:self.tempBtn];
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}
- (void)showIndicatorForTouch:(UITouch *)touch {
    
    CGPoint pos = [touch locationInView:self];
    if (pos.x < (self.frame.size.width - _xLabelWidth*(2.0/3))) {
        if(self.currentPosView.alpha == 0.0) {
            CGRect r = self.currentPosView.frame;
            r.origin.x = pos.x ;
            self.currentPosView.frame = r;
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            self.currentPosView.alpha = 1.0;
            CGRect r = self.currentPosView.frame;
            r.origin.x = pos.x ;
            self.currentPosView.frame = r;
        }];
    }
    
    CGFloat num = 0;
    if (_xLabels.count == 0){
        num=1.0;
    }else if (_xLabels.count<=7){
        num=7;
    }else{
        num = _xLabels.count;
    }
    
    if (self.selectBtnArray.count > 0) {
        for (UIButton *btn in self.selectBtnArray) {
            [self smaller:btn];
        }
    }
    
    NSInteger indexPoint = (NSInteger)((pos.x - chartLeftMargin)/(_xLabelWidth));
    CGFloat moreX = (pos.x - chartLeftMargin) - (indexPoint)*(_xLabelWidth);
    
    if (fabs(moreX) <= 10 || fabs(moreX - (NSInteger)(_xLabelWidth)) <= 10) {
        NSMutableArray *pointValueArray = [[NSMutableArray alloc] init];
        
        if (fabs(moreX - (NSInteger)(_xLabelWidth)) <= 10) {
            indexPoint += 1;
        }

        if (self.selectViewArray.count > 0) {
            for (UUPointValue *pointImageView  in self.selectViewArray) {
                [pointImageView removeFromSuperview];
            }
            
            [self.selectViewArray removeAllObjects];
            [self.selectBtnArray removeAllObjects];
        }
        if (self.selectedUUPointValue) {
            [self.selectedUUPointValue removeFromSuperview];
            [self smaller:self.tempBtn];
        }
        for (int i=0; i<_yValues.count; i++) {
            NSArray *childAry = _yValues[i];
            if (childAry.count==0) {
                return;
            }
            if (indexPoint < childAry.count ) {
                NSInteger Value = [[childAry objectAtIndex:indexPoint ] integerValue];
                UUPointValue *pointImageView = objc_getAssociatedObject([self viewWithTag:(Value + 1000*i +100*indexPoint)], AssociatedObject);;
                 [self.selectViewArray addObject:pointImageView];
                [pointValueArray addObject:[NSNumber numberWithInteger:Value]];
                [self.selectBtnArray addObject:[self viewWithTag:(Value + 1000*i +100*indexPoint)]];
            }
        }
        
        if (self.selectViewArray.count > 1) {
            self.tempUUPointValue = self.selectViewArray[0];
            for (int i =1; i < self.selectViewArray.count; i++) {
                UUPointValue *pointImageView = self.selectViewArray[i];
                if (self.tempUUPointValue.frame.origin.y < pointImageView.frame.origin.y) {
                    self.tempUUPointValue = pointImageView;
                }
            }

            if (pointValueArray.count > 1) {
                NSMutableString *resultString = [NSMutableString stringWithFormat:@"%ld", [pointValueArray[0] integerValue]];
                for (int i =1; i < pointValueArray.count; i++) {
                    [resultString appendString:[NSString stringWithFormat:@"/%ld",[pointValueArray[i] integerValue]]];
                    
                }
                  self.selectedUUPointValue = [[UUPointValue alloc] initWithChartValueSHowFrame:self.tempUUPointValue.frame withBackgroundImageViewNameString:self.tempUUPointValue.pointValueBackgroundImageViewNameString withPointValueString:resultString ];
                [self addSubview:self.selectedUUPointValue];
                [self bringSubviewToFront:self.selectedUUPointValue];
            }
        }
        else
        {
            for (UUPointValue *label  in self.selectViewArray) {
                [self addSubview:label];
                [self bringSubviewToFront:label];
            }
        }
    }
    
    if (self.selectBtnArray.count > 0) {
        for (UIButton *btn in self.selectBtnArray) {
            [self bigger:btn];
        }
    }
}

- (void)hideIndicator {
    [UIView animateWithDuration:0.1 animations:^{
        self.currentPosView.alpha = 0.0;
    }];
    
    if (self.selectBtnArray.count > 0) {
        for (UIButton *btn in self.selectBtnArray) {
            [self smaller:btn];
        }
    }
    if (self.selectViewArray.count > 0) {
        for (UUPointValue *label  in self.selectViewArray) {
            [label removeFromSuperview];
        }
        [self.selectBtnArray removeAllObjects];
        [self.selectViewArray removeAllObjects];
    }

    if (self.selectedUUPointValue) {
        [self.selectedUUPointValue removeFromSuperview];
    }
}

-(void)smaller:(UIButton *)btn
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, 1);
    btn.transform = scaleTransform;
}

-(void)bigger:(UIButton *)btn
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.5, 1.5);
    btn.transform = scaleTransform;
}


@end

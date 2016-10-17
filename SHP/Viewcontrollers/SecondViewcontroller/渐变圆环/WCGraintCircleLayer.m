//
//  WCGraintCircleLayer.m
//  WCGraintCircleView
//
//  Created by huangwenchen on 15/4/24.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "WCGraintCircleLayer.h"

@implementation WCGraintCircleLayer
-(instancetype)initGraintCircleWithBounds:(CGRect)bounds Position:(CGPoint)position FromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor LineWidth:(CGFloat) linewidth withPercent:(id)percent{
    if (self = [super init]) {
        self.bounds = bounds;
        self.position = position;
            CAShapeLayer * shape = [CAShapeLayer layer];
            CGRect rect = CGRectMake(0,0,CGRectGetWidth(self.bounds) - 2 * linewidth, CGRectGetHeight(self.bounds) - 2 * linewidth);
            shape.bounds = rect;
            shape.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            shape.strokeColor =  [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.2].CGColor;
            shape.fillColor = [UIColor clearColor].CGColor;
            shape.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
            shape.lineWidth = linewidth+2.0;
            shape.lineCap = kCALineCapRound;
            shape.strokeStart = 0.001;
            shape.strokeEnd = 0.999;
            [self addSublayer:shape];
        
            CAShapeLayer * shapelayer = [CAShapeLayer layer];
            shapelayer.bounds = CGRectMake(5,5,CGRectGetWidth(self.bounds) - 2 * linewidth - 10.0, CGRectGetHeight(self.bounds) - 2 * linewidth - 10.0);
            shapelayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            shapelayer.strokeColor = fromColor.CGColor;
            shapelayer.fillColor = [UIColor clearColor].CGColor;
            shapelayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
            shapelayer.lineWidth = linewidth;
            shapelayer.lineCap = kCALineCapRound;
            shapelayer.strokeStart = 0.001;
            shapelayer.strokeEnd = [percent floatValue] / 100.0;
            [self addSublayer:shapelayer];
        
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 1.0;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:[percent floatValue] / 100.0];
            pathAnimation.autoreverses = NO;
            [shapelayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    return self;
}

@end

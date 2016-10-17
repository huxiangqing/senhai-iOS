//
//  CircleProgressView.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "CircleProgressView.h"
#import "CircleShapeLayer.h"
#import <math.h>

#define toRadians(x) ((x)*M_PI / 180.0)

@interface CircleProgressView()

@property (nonatomic, strong) CircleShapeLayer *progressLayer;
@property (nonatomic ,retain) UIImageView *CirclePointImage;

@end

@implementation CircleProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
    [self.progressLabel sizeToFit];
    self.progressLabel.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y- self.frame.origin.y);
    
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _progressLabel.numberOfLines = 2;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_progressLabel];
    }
    
    return _progressLabel;
}

- (double)percent {
    return self.progressLayer.percent;
}
- (void)setProgress:(float)progress
{
    _progress = progress;
    self.progressLayer.progress = _progress;
    CGFloat circleX ,circleY;

    if (progress <= 0.25)
    {
        CGFloat delta = toRadians(360 * progress);
        if (progress > 0.0) {
            circleX = self.frame.size.width/2.0 + sin(delta)*(self.frame.size.width/2 - 10.0)-2.0 ;
        }
        else
        {
            circleX = self.widthValue/2.0;
        }
        circleY = self.frame.size.width/2.0  -  cos(delta)*(self.frame.size.width/2 + 10.0)-1.0;
    }
    else if (progress > 0.25 && progress <= 0.5)
    {
        CGFloat delta = toRadians(360 * (progress - 0.25));
        circleX = self.frame.size.width/2 + cos(delta)*(self.frame.size.width/2  - 10.0) - 4.0;
        circleY = self.frame.size.height/2 + sin(delta)*(self.frame.size.height/2  - 10.0) - 2.0;
        if (progress>0.40)
        {
            CGFloat delta = toRadians(360 * (progress - 0.25));
            circleX = self.frame.size.width/2 + cos(delta)*(self.frame.size.width/2  - 10.0) - 5.0;
            circleY = self.frame.size.height/2 + sin(delta)*(self.frame.size.height/2  - 10.0) - 2.0;
        }
        
        if (progress>0.47)
        {
            CGFloat delta = toRadians(360 * (progress - 0.25));
            circleX = self.frame.size.width/2 + cos(delta)*(self.frame.size.width/2  - 10.0) - 9.0;
            circleY = self.frame.size.height/2 + sin(delta)*(self.frame.size.height/2  - 10.0) ;
        }
    }
    else if (progress > 0.5 && progress <= 0.75)
    {
        CGFloat delta = toRadians(360 * (progress - 0.5));
        circleX = self.frame.size.width/2 - sin(delta)*(self.frame.size.width/2 + 10.0)-9.0;
        circleY = self.frame.size.height/2  +  cos(delta)*(self.frame.size.height/2 - 10.0)-2.0;
        if (progress>0.6)
        {
            CGFloat delta = toRadians(360 * (progress - 0.5));
            circleX = self.frame.size.width/2 - sin(delta)*(self.frame.size.width/2 + 10.0)-6.0;
            circleY = self.frame.size.height/2  +  cos(delta)*(self.frame.size.height/2 - 10.0)-4.0;
        }
        if (progress>0.63)
        {
            CGFloat delta = toRadians(360 * (progress - 0.5));
            circleX = self.frame.size.width/2 - sin(delta)*(self.frame.size.width/2 + 10.0)-4.0;
            circleY = self.frame.size.height/2  +  cos(delta)*(self.frame.size.height/2 - 10.0)-6.0;
        }
        if (progress>0.65)
        {
            CGFloat delta = toRadians(360 * (progress - 0.5));
            circleX = self.frame.size.width/2 - sin(delta)*(self.frame.size.width/2 + 10.0)-2.0;
            circleY = self.frame.size.height/2  +  cos(delta)*(self.frame.size.height/2 - 10.0)-8.5;
        }
        
    }
    else
    {
        CGFloat delta = toRadians(360 * progress);
        circleX = self.frame.size.width/2 + sin(delta)*(self.frame.size.width/2 + 10.0) ;
        circleY = self.frame.size.width/2  -  cos(delta)*(self.frame.size.width/2 + 10.0)-8.0;
    }
    
    [self.CirclePointImage setFrame:CGRectMake(circleX, circleY, self.CirclePointImage.frame.size.width,  self.CirclePointImage.frame.size.height)];
}
#pragma mark - Private Methods

- (void)setupViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = false;
    
    //add Progress layer
    self.progressLayer = [[CircleShapeLayer alloc] init];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.progressLayer];
    
    self.CirclePointImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultCirclePoint"]] ;
    [self.CirclePointImage sizeToFit];
    [self.CirclePointImage setFrame:CGRectMake(self.widthValue/2.0 - 10.0, - 10.0, 20.0, 20.0)];
    self.CirclePointImage.centerXValue = self.widthValue/2.0;
    [self addSubview:self.CirclePointImage];
}

- (void)setTintColor:(UIColor *)tintColor {
    self.progressLayer.progressColor = tintColor;
    self.progressLabel.textColor = tintColor;
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

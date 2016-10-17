//
//  GCView.h
//  WCGradientLayerExample
//
//  Created by JHR on 15/12/4.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCGraintCircleLayer.h"

@interface GCView : UIView

-(instancetype)initGCViewWithBounds:(CGRect)bounds FromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor LineWidth:(CGFloat) linewidth withPercent:(id)percent adjustFont:(BOOL)adjust;

@property (strong ,nonatomic) UILabel *percentLable;
@property (strong ,nonatomic)WCGraintCircleLayer * sub1;

@end

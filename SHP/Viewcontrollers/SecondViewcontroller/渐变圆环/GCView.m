

//
//  GCView.m
//  WCGradientLayerExample
//
//  Created by JHR on 15/12/4.
//  Copyright © 2015年 huangwenchen. All rights reserved.
//

#import "GCView.h"

@implementation GCView

-(instancetype)initGCViewWithBounds:(CGRect)bounds FromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor LineWidth:(CGFloat) linewidth withPercent:(id)percent  adjustFont:(BOOL)adjust
{
    if (self = [super init])
    {
        [self setFrame:bounds];
        if (!_sub1) {
            _sub1 = [[WCGraintCircleLayer alloc] initGraintCircleWithBounds:bounds Position:self.center FromColor:fromColor ToColor:toColor LineWidth:linewidth withPercent:percent];
            [self.layer addSublayer:_sub1];
        }
        
        if (_percentLable==nil)
        {
            _percentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
            [self addSubview:_percentLable];
        }
        [_percentLable setBackgroundColor:[UIColor clearColor]];
        [_percentLable setTextColor:fromColor];
        
        __block NSInteger timeout = 0; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),(1.0/([percent integerValue]))*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout >= [percent integerValue]){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSMutableString *percentString = [NSMutableString stringWithFormat:@"%ld",timeout];
                    [percentString appendString:@"%"];
                    
                    if (adjust) {
                        [_percentLable setFont:[Tools fontFromHeightFloatValue:16.0]];
                    }
                    else
                    {
                        [_percentLable setFont:[UIFont systemFontOfSize:13.0]];
                    }
                    
                    [_percentLable setText:[NSString stringWithFormat:@"%@",percentString]];
                    [_percentLable setTextAlignment:NSTextAlignmentCenter];
                    [_percentLable setAdjustsFontSizeToFitWidth:YES];

                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSMutableString *percentString = [NSMutableString stringWithFormat:@"%ld",timeout];
                    [percentString appendString:@"%"];
                    
                    if (adjust) {
                        [_percentLable setFont:[Tools fontFromHeightFloatValue:16.0]];
                    }
                    else
                    {
                        [_percentLable setFont:[UIFont systemFontOfSize:13.0]];
                    }
                    
                    [_percentLable setText:[NSString stringWithFormat:@"%@",percentString]];
                    [_percentLable setTextAlignment:NSTextAlignmentCenter];
                    [_percentLable setAdjustsFontSizeToFitWidth:YES];
                    
                });
                timeout++;
            }
        });
        
        dispatch_resume(_timer);
    }
    
    return self;
}

@end

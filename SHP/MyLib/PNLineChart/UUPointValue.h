//
//  UUPointValue.h
//  inputView
//
//  Created by JHR on 15/12/3.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUPointValue : UIView

@property (nonatomic ,copy) NSString *pointValueBackgroundImageViewNameString;
@property (nonatomic ,copy) UILabel *pointValueText;


-(id)initWithChartValueSHowFrame:(CGRect)rect withBackgroundImageViewNameString:(NSString *)pointValueBackgroundImageViewNameString withPointValueString:(NSString *)PointValueString;

@end

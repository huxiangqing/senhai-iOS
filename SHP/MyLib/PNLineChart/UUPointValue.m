//
//  UUPointValue.m
//  inputView
//
//  Created by JHR on 15/12/3.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import "UUPointValue.h"

@implementation UUPointValue

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithChartValueSHowFrame:(CGRect)rect withBackgroundImageViewNameString:(NSString *)pointValueBackgroundImageViewNameString withPointValueString:(NSString *)PointValueString
{
    self = [self initWithFrame:rect];
    
    UIImageView *pointValueBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pointValueBackgroundImageViewNameString]];
    [pointValueBackgroundImageView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [pointValueBackgroundImageView setUserInteractionEnabled:YES];
    [self addSubview:pointValueBackgroundImageView];
    
    UILabel *pointValueTextLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [pointValueTextLable setText:PointValueString];
    [pointValueTextLable setTextAlignment:NSTextAlignmentCenter];
    [pointValueTextLable setFont:[UIFont systemFontOfSize:20.0]];
    [pointValueTextLable setTextColor:[UIColor whiteColor]];
    pointValueTextLable.adjustsFontSizeToFitWidth = YES;
    [self addSubview:pointValueTextLable];
    
    self.pointValueBackgroundImageViewNameString = pointValueBackgroundImageViewNameString;
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    return self;
}



@end

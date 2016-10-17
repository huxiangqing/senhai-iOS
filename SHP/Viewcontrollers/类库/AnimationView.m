//
//  AnimationView.m
//  Cupid
//
//  Created by liuhengyu on 15/7/30.
//  Copyright (c) 2015年 liuhengyu. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
    UILabel *lastlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.widthValue, self.heightValue)];
    lastlabel.text=NSLocalizedString(@"No more records", nil);;
    lastlabel.textAlignment = NSTextAlignmentCenter;
    lastlabel.textColor =[UIColor whiteColor];
    lastlabel.font =[UIFont systemFontOfSize:13];
    [self addSubview:lastlabel];

    [UIView animateWithDuration:2.f animations:^
    {
        self.alpha = 0.f;
    }];

}


@end

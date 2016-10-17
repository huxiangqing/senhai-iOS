//
//  JKSideSlipView.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface JKSideSlipView : UIView
{
    BOOL isOpen;
}
- (instancetype)initWithSender:(UIViewController*)sender;
-(void)show;
-(void)hide;
-(void)switchMenu;
-(void)setContentView:(UIView*)contentView;
@property (strong ,nonatomic)UIViewController *sender;
@property (strong ,nonatomic)UIImageView *blurImageView;
@property (strong ,nonatomic)UIView *contentView;

@property (strong ,nonatomic)UITapGestureRecognizer *tap;
@property (strong ,nonatomic)UISwipeGestureRecognizer *leftSwipe;
@property (strong ,nonatomic)UISwipeGestureRecognizer *rightSwipe;


@end

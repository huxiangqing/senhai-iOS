//
//  CommonViewInit.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "CommonViewInit.h"

#pragma mark - UILabel
UILabel * LabelInitZeroFrm(UIFont *font, UIColor *textColor, UIView *addBy)
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:font];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:textColor];
    [addBy addSubview:label];
    
    return label;
}

UILabel * LabelInitZeroFrmAlignNum(NSInteger numberlines,NSTextAlignment textAlign, UIFont *font, UIColor *textColor, UIView *addBy){
    UILabel *label = LabelInitZeroFrm(font, textColor, addBy);
    label.numberOfLines = numberlines;
    label.textAlignment = textAlign  ;
    return label;
}


UILabel * LabelinitWithFtnClrFrm(int x, int y , int width , int height, UIFont *font, UIColor *textColor, UIView *addBy)
{
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    newLabel.font = font;
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.textColor = textColor;
    [addBy addSubview:newLabel];
    return newLabel;
}


#pragma mark - UIButton

UIButton *UIButtonInitFrmPrt(CGRect frame, UIView *addBy)
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setBackgroundColor:[UIColor clearColor]];
    newButton.frame = frame;
    if (addBy) {
        [addBy addSubview:newButton];
    }
    return newButton;
    
}
UIButton *UIButtonInitFrm(CGRect frame, NSString *normalImageName, NSString *highlightImageName, UIView *addBy){
    UIButton *newButton = UIButtonInitFrmPrt(frame, addBy);
    if(normalImageName != nil){
        [newButton setBackgroundImage: [UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    }
    if(highlightImageName != nil){
        [newButton setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    return newButton;
}

void ButtonSetTitle(UIButton * tagetButton, NSString * titleName, UIColor * titleColor,UIFont * titleFont)
{
    [tagetButton setTitle:titleName forState:UIControlStateNormal];
    [tagetButton setTitleColor:titleColor forState:UIControlStateNormal];
    tagetButton.titleLabel.font = titleFont;
    tagetButton.titleLabel.textColor = titleColor;
}

#pragma mark - UIImageView
UIImageView *ImageViewInitWithImg(int x, int y,int width , int height,NSString *imageName , UIView *parentView){
    return ImageViewInitWithFrmImg(CGRectMake(x, y, width, height), imageName, parentView);
}

UIImageView *ImageViewInitWithFrmImg(CGRect frame, NSString *imageName, UIView *parentView){
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    [parentView addSubview:imageView];
    [imageView setBackgroundColor:[UIColor clearColor]];
    return imageView;
}


#pragma UIView
id UIViewRadiusWithFrmImg(Class classOfView,int x, int y,int width , int height,int cornerRadius, UIView *parentView){
    return UIViewRadiusWithRect(classOfView, CGRectMake(x, y, width, height), cornerRadius, parentView);
}

id UIViewRadiusWithRect(Class classOfView,CGRect frame,int cornerRadius, UIView *parentView){
    UIView *uiview       = [[classOfView alloc] initWithFrame:frame];
    uiview.layer.cornerRadius = cornerRadius;
    uiview.clipsToBounds      = YES;
    uiview.backgroundColor    = [UIColor clearColor];
    [parentView addSubview:uiview];
    return uiview;
}



void UIViewSetRadius(UIView *targetView, CGFloat radius, CGFloat borderWidth, UIColor *borderColor){
    targetView.layer.cornerRadius = radius;
    if (borderWidth > 0) {
        (targetView.layer.borderWidth  = borderWidth);
    }
    if (borderColor) {
        targetView.layer.borderColor  = borderColor.CGColor;
    }
    targetView.clipsToBounds      = YES;
}






#pragma mark - animation

CAKeyframeAnimation * KeyFrameAnimationBounce(id delegate){
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.01), @(1.05), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.5;
    animation.delegate = delegate;
//    [self.alertView.layer addAnimation:animation forKey:@"bouce"];
    return animation;
}

CAKeyframeAnimation * KeyFrameAnimationAlertDismiss(id delegate){
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1.0), @(0.01)];
    animation.keyTimes = @[@(0), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.2;
//    animation.delegate = delegate;
    return animation;
}




#pragma mark - NSNotificatonCenter

void NSNotificationPost(NSString *notificationName, id postObject){
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:postObject];
}

void NSNotificationAdd(id observer, SEL selector , NSString *name ,  id POSTObject){
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:POSTObject];
}

void NSNotificationRemove(id observer){
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    
}


#pragma mark - NSUserDefaults
id NSUserDefaultsValueForKey(NSString *key){
   return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

void NSUserDefaultsSetValueForKey(NSString *key, id value){
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

void NSUserDefaultsSynchronize(){
    [[NSUserDefaults standardUserDefaults] synchronize];
}

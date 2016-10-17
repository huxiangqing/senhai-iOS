//
//  CommonViewInit.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UILabel

/**
 *  c   label初始化 .frame = CGRectZero
 *  @param addBy     初始化后所加视图parentView
 */
UILabel * LabelInitZeroFrm(UIFont *font, UIColor *textColor, UIView *addBy);

/**
 *  可设置文本行数和对齐方式
 */
UILabel * LabelInitZeroFrmAlignNum(NSInteger numberlines,NSTextAlignment textAlign, UIFont *font, UIColor *textColor, UIView *addBy);
/**
 *  c   label初始化
 *  @param addBy     初始化后所加视图parentView
 */
UILabel * LabelinitWithFtnClrFrm(int x, int y,int width , int height, UIFont *font, UIColor *textColor, UIView *addBy);



#pragma mark - UIButton  

/**
 *   c   UIButton初始化 UIButtonTypeCustom
 *  @param normalImageName    正常图片
 *  @param highlightImageName 点击图片
 *  @param addBy              父视图
 */
UIButton *UIButtonInitFrmPrt(CGRect frame, UIView *addBy);
UIButton *UIButtonInitFrm(CGRect frame, NSString *normalImageName, NSString *highlightImageName, UIView *addBy);
void ButtonSetTitle(UIButton * tagetButton, NSString * titleName, UIColor * titleColor,UIFont * titleFont);



#pragma mark - UIImageView

/**
 *  c   UIImageView初始化
 *
 *  @param parentView 父视图
 */
UIImageView *ImageViewInitWithImg(int x, int y,int width , int height, NSString *imageName, UIView *parentView);

UIImageView *ImageViewInitWithFrmImg(CGRect frame, NSString *imageName, UIView *parentView);

void ImageViewConstraitInSize(UIImageView *imageView, CGSize size);

/**
 *  c   圆角UIImageView初始化
 *
 *  @param parentView 父视图
 */
id UIViewRadiusWithFrmImg(Class classOfView,int x, int y,int width , int height,int cornerRadius, UIView *parentView);
id UIViewRadiusWithRect(Class classOfView,CGRect frame,int cornerRadius, UIView *parentView);



#pragma mark - UIView
/**
 *  设置targetView的圆角 ＋ 边线宽 ＋ 边线颜色
 */
void UIViewSetRadius(UIView *targetView ,CGFloat radius, CGFloat borderWidth, UIColor *borderColor);




#pragma mark - Key frame animation Bounce
/**
 *  弹跳动画
 *  @param delegate 动画的delegate
 */
CAKeyframeAnimation * KeyFrameAnimationBounce(id delegate);

/**
 *  弹出框消失的动画
 *  @param delegate 动画的delegate *
 */
CAKeyframeAnimation * KeyFrameAnimationAlertDismiss(id delegate);


#pragma mark - NSNotificatonCenter

void NSNotificationPost(NSString *notificationName, id postObject);
void NSNotificationAdd(id observer,SEL selector, NSString *notificationName,id POSTObject);
void NSNotificationRemove(id observer);


#pragma mark - NSUserDefaults
id   NSUserDefaultsValueForKey(NSString *key);
void NSUserDefaultsSetValueForKey(NSString *key, id value);
void NSUserDefaultsSynchronize();


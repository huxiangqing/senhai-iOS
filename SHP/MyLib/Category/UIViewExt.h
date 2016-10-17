//
//  UIViewExt.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

/**
 * @brief  UIView经常使用的属性,可快速地得到
*/
#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint originValue;
@property CGSize sizeValue;

@property CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat heightValue;
@property CGFloat widthValue;

@property CGFloat topValue;
@property CGFloat leftValue;

@property CGFloat bottomValue;
@property CGFloat rightValue;

@property CGFloat centerXValue;
@property CGFloat centerYValue;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end

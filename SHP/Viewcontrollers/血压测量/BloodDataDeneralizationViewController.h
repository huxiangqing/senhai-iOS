//
//  BloodDataDeneralizationViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/13.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

/*
 @brief 血压历史
 */
#import <UIKit/UIKit.h>

@interface BloodDataDeneralizationViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,assign)BOOL fromMainview;
/**
 *	@brief	 血压id
 */
@property (nonatomic ,copy) NSString *bloodPressureId;
/**
 *	@brief	 用户id
 */
@property (nonatomic ,copy) NSString *userId;

@property (nonatomic ,assign) BOOL isReMeasure;

@end

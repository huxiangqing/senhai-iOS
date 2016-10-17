//
//  CalendarVC.h
//  LUDE
//
//  Created by lord on 16/6/8.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarHomeViewController.h"

@interface CalendarVC : UIViewController

/**
 *	@brief	筛选出来的开始和结束时间
 */

@property (nonatomic, copy) void (^screenStartTimeAndEndTime)(NSString * startT,NSString *endT);

@property (nonatomic, copy) NSString *startDateString;
@property (nonatomic, copy) NSString *endDateString;


@property (nonatomic ,copy)NSString *timeInterval;

@end

//
//  BloodDataModel.h
//  HealthKitStudy
//
//  Created by lord on 16/3/30.
//  Copyright © 2016年 wlll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodDataModel : NSObject

@property (nonatomic ,assign) NSInteger  HeartRate;
@property (nonatomic ,assign) NSInteger  BloodPressureDiastolic;
@property (nonatomic ,assign) NSInteger  BloodPressureSystolic;

@property (nonatomic ,assign) double BloodGlucose;

@property (nonatomic ,strong) NSDate *date;

@end

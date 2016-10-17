//
//  HealthManager.h
//  HealthKitStudy
//
//  Created by lord on 16/3/30.
//  Copyright © 2016年 wlll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloodDataModel.h"

@interface HealthManager : NSObject

+ (instancetype) shareHealthManager;
/**
 *  判断设备是否支持健康应用
 *
 *  @return YES 支持  NO 不支持
 */
+ (BOOL)isHealthDataAvailable;
/**
 *  应用授权
 */
- (void)authorizateHealthKit:(void (^)(BOOL isAuthorizateSuccess))resultBlock;

/**
 *  保存数据
 */
-(void)saveBloodDataToHealthstoreWithData:(BloodDataModel *)dataModel;

- (void)readStepCount:(void (^)(NSString *stepCount))LatestStepCountResultBlock;

- (void)getKilocalorieUnitCompletionHandler:(void(^)(double value, NSError *error))handler;

@end

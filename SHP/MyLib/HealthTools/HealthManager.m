//
//  HealthManager.m
//  HealthKitStudy
//
//  Created by lord on 16/3/30.
//  Copyright © 2016年 wlll. All rights reserved.
//

#import "HealthManager.h"
#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "HealthModel.h"

@interface HealthManager ()
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

static HealthManager *_share_HealthManager = nil;

@implementation HealthManager

+ (instancetype) shareHealthManager
{
    if (_share_HealthManager == nil) {
        _share_HealthManager = [[HealthManager alloc] init];
    }
    return _share_HealthManager;

}
#pragma mark - getter
- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

+ (BOOL)isHealthDataAvailable {
    return [HKHealthStore isHealthDataAvailable];
}

- (void)authorizateHealthKit:(void (^)(BOOL isAuthorizateSuccess))resultBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //读操作
        NSSet *readObjectTypes = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] ,nil];
        //写操作
        /*心率，血糖，舒张压 ，收缩压*/
        NSSet *writeObjectTypes = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic], nil];
        [self.healthStore requestAuthorizationToShareTypes:writeObjectTypes readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (resultBlock) {
                resultBlock(success);
            }

        }];
    });
}

/*!
 *
 *
 *  @brief  获取卡路里
 */
- (void)getKilocalorieUnitCompletionHandler:(void(^)(double value, NSError *error))handler
{
//    查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标
//    查询采样信息
        HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nil endDate:nil options:HKQueryOptionStrictStartDate];
        //NSSortDescriptors用来告诉healthStore
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
        HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            
            if(!error && results) {
                
                HKQuantitySample *samples = results.firstObject;
                HKQuantity *energyBurned = samples.quantity;
                
                double value = [energyBurned doubleValueForUnit:[HKUnit kilocalorieUnit]];
                
                if(handler)
                {
                    handler(value,error);
                }
            }
            else
            {
                if(handler)
                {
                    double value = 0.0;
                    handler(value,error);
                }
            }
    
        }];
        //执行查询
        [self.healthStore executeQuery:sampleQuery];
    
    
    
//    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//    
//        HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
//            HKQuantity *sum = [result sumQuantity];
//            
//            
//            
//            
//            double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
//        
//            if(handler)
//            {
//                handler(value,error);
//            }
//        }];
//    
//    [self.healthStore executeQuery:query];
}

- (void)readStepCount:(void (^)(NSString *stepCount))LatestStepCountResultBlock
{
    
    /**********************************
     
     查询全部时间段的步数
     
     **********************************/
    
    //查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标
    //查询采样信息
    //    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nil endDate:nil options:HKQueryOptionStrictStartDate];
    //    //NSSortDescriptors用来告诉healthStore
    //    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    //    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
    //        if(!error && results) {
    //            for(HKQuantitySample *samples in results) {
    //                NSLog(@"%@ 至 %@ : %@", samples.startDate, samples.endDate, samples.quantity);
    //            }
    //        }
    //        else
    //        {
    //
    //        }
    //
    //    }];
    //    //执行查询
    //    [self.healthStore executeQuery:sampleQuery];
    
    /**********************************
     
     查询按天查询的步数
     
     **********************************/
    
    [self fetchAllHealthDataByDay:^(NSArray *modelArray)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (modelArray.count > 0) {
                 HealthModel *healthModel = (HealthModel *)modelArray.firstObject;
                 
                 //NSString *result = [NSString stringWithFormat:@"%@,%ld",[NSString stringWithFormat:@"%zd年%zd月%zd日",healthModel.startDateComponents.year,healthModel.startDateComponents.month,healthModel.startDateComponents.day],(long)healthModel.stepCount];
                 
                 NSString *result = [NSString stringWithFormat:@"%ld",(long)healthModel.stepCount];
                 LatestStepCountResultBlock(result);
                 
             }
             else
             {
                 NSString *result = @" 0";
                 LatestStepCountResultBlock(result);
             }
             
         });
         
         //         for ( HealthModel *healthModel in modelArray) {
         //
         //             self.stepLabel.text = F(@"%@,%ld",F(@"%zd年%zd月%zd日", healthModel.startDateComponents.year, healthModel.startDateComponents.month, healthModel.startDateComponents.day),healthModel.stepCount);
         //         }
         
     }];
}

- (void)fetchAllHealthDataByDay:(void (^)(NSArray *modelArray))queryResultBlock {
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.day = 1;
    
    __block NSCalendar *calendar;
    
#ifdef IOS8
    calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
#endif
    
    NSDateComponents *currentComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: - (currentComponents.hour * 3600 + currentComponents.minute * 60 + currentComponents.second)];
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                     fromDate:endDate];
    
    [self executeQueryForQuantityType:quantityType
                            predicate:nil
                           anchorDate:[calendar dateFromComponents:anchorComponents]
                   intervalComponents:intervalComponents
                       callBackResult:^(HKStatisticsCollection * _Nullable result, NSError *error) {
                           if (error) {
                               NSLog(@"an error occurred while calculating the statistics %@",error.localizedDescription);
                           } else {
                               
                               __block NSMutableArray *tempArray = @[].mutableCopy;
                               
                               [result.statistics enumerateObjectsUsingBlock:^(HKStatistics * _Nonnull statistics, NSUInteger idx, BOOL * _Nonnull statisticsStop) {
                                   [statistics.sources enumerateObjectsUsingBlock:^(HKSource * _Nonnull source, NSUInteger idx, BOOL * _Nonnull sourceStop) {
                                       if ([source.name isEqualToString:[UIDevice currentDevice].name]) {//只取设备的步数，过滤其他第三方应用的
                                           double stepCount = [[statistics sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]];
                                           
                                           @autoreleasepool {
                                               //数据封装
                                               HealthModel *healthModel = [[HealthModel alloc] init];
                                               healthModel.startDateComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                                             fromDate:statistics.startDate];
                                               healthModel.endDateComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                                           fromDate:statistics.endDate];
                                               healthModel.stepCount = stepCount;
                                               [tempArray insertObject:healthModel atIndex:0];//倒序
                                           }
                                           *sourceStop = YES;
                                       }
                                   }];
                               }];
                               
                               if (queryResultBlock) {
                                   queryResultBlock(tempArray);
                               }
                           }
                       }];
}

//查询
- (void)executeQueryForQuantityType:(HKQuantityType *)quantityType
                          predicate:(nullable NSPredicate *)quantitySamplePredicate
                         anchorDate:(NSDate *)anchorDate
                 intervalComponents:(NSDateComponents *)intervalComponents
                     callBackResult:(void (^)(HKStatisticsCollection * __nullable result, NSError *error))queryResult {
    
    HKStatisticsCollectionQuery *collectionQuery =
    [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                      quantitySamplePredicate:quantitySamplePredicate
                                                      options:HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource
                                                   anchorDate:anchorDate
                                           intervalComponents:intervalComponents];
    
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error){
        if (queryResult) {
            queryResult(result, error);
        }
    };
    [self.healthStore executeQuery:collectionQuery];
}

-(void)saveBloodDataToHealthstoreWithData:(BloodDataModel *)dataModel
{
    HKQuantitySample *HeartRateSample,*BloodGlucoseSample,*BloodPressureDiastolicSample,*BloodPressureSystolicSample;
    HKCorrelation  *BloodPressureCorrelation;
    
    NSMutableArray *saveTypesArray = [[NSMutableArray alloc] init];
    
    if (dataModel.HeartRate) {
        
        HKUnit *HeartRate = [HKUnit unitFromString:@"count/min"];
        HeartRateSample = [HKQuantitySample quantitySampleWithType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate] quantity:[HKQuantity quantityWithUnit:HeartRate doubleValue:[NSNumber numberWithInteger:dataModel.HeartRate].doubleValue] startDate:dataModel.date endDate:dataModel.date];
        
        [saveTypesArray addObject:HeartRateSample];
    }
    if (dataModel.BloodGlucose) {
        
        BloodGlucoseSample = [HKQuantitySample quantitySampleWithType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose] quantity:[HKQuantity quantityWithUnit:[HKUnit unitFromString:@"mg/dL"]doubleValue:dataModel.BloodGlucose*18.0] startDate:dataModel.date endDate:dataModel.date];
        
        [saveTypesArray addObject:BloodGlucoseSample];
    }
    
    if (dataModel.BloodPressureDiastolic && dataModel.BloodPressureSystolic) {
        
        BloodPressureDiastolicSample = [HKQuantitySample quantitySampleWithType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic] quantity:[HKQuantity quantityWithUnit:[HKUnit millimeterOfMercuryUnit] doubleValue:dataModel.BloodPressureDiastolic] startDate:dataModel.date endDate:dataModel.date];
        BloodPressureSystolicSample = [HKQuantitySample quantitySampleWithType:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic] quantity:[HKQuantity quantityWithUnit:[HKUnit millimeterOfMercuryUnit] doubleValue:dataModel.BloodPressureSystolic] startDate:dataModel.date endDate:dataModel.date];
        BloodPressureCorrelation = [HKCorrelation correlationWithType:[HKCorrelationType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure] startDate:dataModel.date endDate:dataModel.date objects:[NSSet setWithObjects:BloodPressureDiastolicSample,BloodPressureSystolicSample, nil]];
        
        [saveTypesArray addObject:BloodPressureCorrelation];
    }
    
    [self.healthStore saveObjects:saveTypesArray withCompletion:^(BOOL success,NSError * _Nullable error)
    {
        if (error!= nil) {
            NSLog(@"Error saving sample:%@",error.localizedDescription);
        }
        else
        {
            NSLog(@"Sample saved successfully!");
        }
    }];
}




@end

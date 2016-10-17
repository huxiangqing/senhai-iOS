//
//  PressureDataModel.h
//  LUDE
//
//  Created by JHR on 15/10/29.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  PDataItemModel : NSObject

@property (nonatomic,copy) NSNumber *bloodPressureClose;
@property (nonatomic,copy) NSNumber *bloodPressureOpen;
@property (copy, nonatomic)  NSString *measureTime;

@end

@interface  BloodPressureModel : NSObject

@property (nonatomic,copy) NSNumber *bloodPressureClose;
@property (nonatomic,copy) NSNumber *bloodPressureOpen;
@property (copy, nonatomic)  NSString *bloodPressureId;
@property (copy, nonatomic)  NSString *measureResultDesc;
@property (copy, nonatomic)  NSString *measureTime;
@property (copy, nonatomic)  NSNumber *pulse;
@property (copy, nonatomic)  NSString *worldRessultDesc;

@end

@interface  HistoryBPDataModel : NSObject

@property (nonatomic,copy) NSNumber *bloodPressureClose;
@property (nonatomic,copy) NSNumber *bloodPressureOpen;
@property (copy, nonatomic)  NSNumber *bloodPressureId;
@property (copy, nonatomic)  NSString *measureTime;
@property (copy, nonatomic)  NSNumber *pulse;

@end

@interface  PageModel : NSObject

@property (nonatomic,copy) NSNumber *pageCount;
@property (nonatomic,copy) NSNumber *pageNo;
@property (copy, nonatomic)  NSNumber *pageSize;

@end

@interface PressureDataModel : NSObject

@property(nonatomic,copy) NSString *startTime;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSNumber *maxOpenValue;
@property(nonatomic,copy) NSNumber *minOpenValue;
@property(nonatomic,copy) NSNumber *maxCloseValue;
@property(nonatomic,copy) NSNumber *minCloseValue;
@property(nonatomic,strong) NSArray *differList;
@property(nonatomic,strong) NSArray *pressureCloseList;
@property(nonatomic,strong) NSArray *pressureOpenList;
@property(nonatomic,strong) NSArray *dateTimeList;
@property(nonatomic,strong) BloodPressureModel *bloodPressure;

@end

@interface LUDEMessage : NSObject<NSCoding>
@property (nonatomic,assign) NSNumber *read;
@property (copy, nonatomic)  NSString *PushType;
@end

//
//  HealthModel.h
//  HealthKitStudy
//
//  Created by lord on 16/3/16.
//  Copyright © 2016年 wlll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthModel : NSObject

@property (nonatomic, strong) NSDateComponents *startDateComponents;
@property (nonatomic, strong) NSDateComponents *endDateComponents;
@property (nonatomic, assign) NSInteger stepCount;

@end

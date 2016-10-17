//
//  PressureDataModel.m
//  LUDE
//
//  Created by JHR on 15/10/29.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "PressureDataModel.h"

@implementation PressureDataModel

@end
@implementation PDataItemModel 

@end
@implementation BloodPressureModel

@end
@implementation PageModel

@end

@implementation HistoryBPDataModel

@end

@implementation LUDEMessage

#pragma mark - NSCoding Delegate

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.read   forKey:@"read"];
    [aCoder encodeObject: self.PushType forKey:@"PushType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init])) {
        self.read = [aDecoder decodeObjectForKey:@"read"];
        self.PushType = [aDecoder decodeObjectForKey:@"PushType"];
    }
    return self;
}

@end
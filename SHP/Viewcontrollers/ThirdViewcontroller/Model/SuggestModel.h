//
//  SuggestModel.h
//  LUDE
//
//  Created by lord on 16/4/20.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestModel : NSObject

@property (nonatomic ,copy)NSString *picUrl ;
@property (nonatomic ,copy)NSString *title ;
@property (nonatomic ,copy)NSString *createTime ;
@property (nonatomic ,copy)NSString *summary ;
@property (nonatomic ,copy)NSString *articleId ;
@property (nonatomic ,copy)NSString *type ;
@end

@interface ADModel : NSObject

@property (nonatomic ,copy)NSString *bannerPic ;
@property (nonatomic ,copy)NSString *linkUrl ;

@end

@interface FirstDataModel : NSObject

@property (nonatomic ,copy)NSString *bloodPressureClose ;
@property (nonatomic ,copy)NSString *bloodPressureCloseAvg ;
@property (nonatomic ,copy)NSArray *bloodPressureCloseList ;
@property (nonatomic ,copy)NSString *bloodPressureCloseMax ;
@property (nonatomic ,copy)NSString *bloodPressureOpen ;
@property (nonatomic ,copy)NSString * bloodPressureOpenAvg ;
@property (nonatomic ,copy)NSArray *bloodPressureOpenList ;
@property (nonatomic ,copy)NSString *bloodPressureOpenMax ;
@property (nonatomic ,copy)NSString *healthNumber ;
@property (nonatomic ,copy)NSString *measureTime ;
@property (nonatomic ,copy)NSString *pulse ;
@property (nonatomic ,copy)NSArray *pushType ;

@end

@interface RiskFillInfoDataModel : NSObject

@property (nonatomic ,copy)NSString *name ;
@property (nonatomic ,copy)NSString *sex ;
@property (nonatomic ,copy)NSString *age ;
@property (nonatomic ,copy)NSString *height ;
@property (nonatomic ,copy)NSString *weight ;
@property (nonatomic ,assign)BOOL smoking ;
@property (nonatomic ,assign)BOOL DM ;
@property (nonatomic ,copy)NSString *CHOL ;
@property (nonatomic ,copy)NSString *SBP ;
@property (nonatomic ,copy)NSString *DBP ;
@property (nonatomic ,copy)NSString *BMP ;
@property (nonatomic ,copy)NSString *insertPerson;

@end

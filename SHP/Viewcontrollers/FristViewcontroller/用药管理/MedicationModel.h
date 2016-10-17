//
//  MedicationModel.h
//  LUDE
//
//  Created by lord on 16/6/28.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicationModel : NSObject

@end


@interface MedicationCatalog : NSObject
@property (nonatomic ,copy)NSString *catalog_id ;
@property (nonatomic ,copy)NSString *catalog_level ;
@property (nonatomic ,copy)NSString *catalog_name ;
@property (nonatomic ,copy)NSString *image_url ;
@property (nonatomic ,copy)NSString *count ;

@end

@interface DrugDetailModel : NSObject

@property (nonatomic ,copy)NSString *company ;
@property (nonatomic ,copy)NSString *content ;
@property (nonatomic ,copy)NSString *image_url ;
@property (nonatomic ,copy)NSString *medication_id ;
@property (nonatomic ,copy)NSString *medication_name ;
@property (nonatomic ,copy)NSString *price ;
@property (nonatomic ,copy)NSString *summary ;

@end

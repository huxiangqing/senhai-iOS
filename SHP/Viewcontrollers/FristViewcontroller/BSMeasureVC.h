//
//  BSMeasureVC.h
//  LUDE
//
//  Created by lord on 16/6/6.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSMeasureVC : UIViewController
{
@public
    BabyBluetooth *baby;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
}

@property (nonatomic ,assign)BOOL connectFailed;

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *readCharacteristic;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;


@end

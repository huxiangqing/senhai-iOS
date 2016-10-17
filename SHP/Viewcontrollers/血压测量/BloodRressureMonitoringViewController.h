//
//  BloodRressureMonitoringViewController.h
//  LUDE
//
//  Created by bluemobi on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

//血压监测
#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"

@interface BloodRressureMonitoringViewController : UIViewController
{
    @public
    BabyBluetooth *baby;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
}
/**
 *	@brief	上半部分背景
 */
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 *	@brief	停止测量按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *stopAndCkeckBtn;

/**
 *	@brief	 与蓝牙通讯的相关特性
 */
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *readCharacteristic;
/**
 *	@brief	 与蓝牙连接的当前设备
 */
@property(strong,nonatomic)CBPeripheral *currPeripheral;
/**
 *	@brief	 当前连接设备的序列号
 */
@property (nonatomic ,copy)NSString *SerialNo ;

@property (nonatomic ,assign)BOOL connectFailed;

@property __block NSMutableArray *services;


@property (nonatomic,assign)BOOL isFromMianView;

/**
 *	@brief	 停止按钮点击方法
 */
- (IBAction)StopMeasure:(UIButton *)sender;

@end

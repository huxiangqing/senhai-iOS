//
//  BSInstructionSet.h
//  BSBluetoothDemo
//
//  Created by JHR on 16/1/11.
//  Copyright © 2016年 huxq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BSInstructionSet : NSObject

/**
 仪器状态和测量结果 读
 */
+(void)perialpheralStateAndResultActionRead:(CBPeripheral *)currPeripheral actionCharacteristic:(CBCharacteristic *)actionCharacteristic;
/**
 仪器状态和测量结果 写回应
 */
+(void)perialpheralStateAndResultActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;
/**
历史数据导出 读
*/
+(void)historicalDataExportActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

/**
 历史数据导出 写回应
 */
+(void)historicalDataExportActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

/**
S/N号读写读
*/
+(void)readAndWriteSNActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

/**
 S/N号读写 写回应
 */
+(void)readAndWriteSNActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;
/**
 客户端读取历史 读
 */
+(void)clientReadHistoryActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

/**
 客户端读取历史 写回应
 */
+(void)clientReadHistoryActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;
/**
 浓度单位 读
 */
+(void)clientReadConcentrationUnitActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

/**
 浓度单位 写回应
 */
+(void)clientReadConcentrationUnitActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic;

@end

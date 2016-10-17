//
//  BSInstructionSet.m
//  BSBluetoothDemo
//
//  Created by JHR on 16/1/11.
//  Copyright © 2016年 huxq. All rights reserved.
//

#import "BSInstructionSet.h"

@implementation BSInstructionSet
//-------------------------  仪器状态和测量结果 perialpheralStateAndResult
+(void)perialpheralStateAndResultActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic 
{
   // Byte byte[] = {0x7B,0x01,0x10,0x01,0x20,0x11,0x55,0x00,0x00,0x00,0x05,0x03,0x0C,0x7D};
    Byte byte[] = {0x7B,0x01,0x10,0x01,0x20,0x12,0x55,0x00,0x00,0x00,0x05,0x07,0x08,0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
//-------------------------  仪器状态和测量结果写回应 perialpheralStateAndResult
+(void)perialpheralStateAndResultActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    // Byte byte[] = {0x7B,0x01,0x10,0x01,0x20,0x11,0x55,0x00,0x00,0x00,0x05,0x03,0x0C,0x7D};
    Byte byte[] = {0x7B, 0x01, 0x10 ,0x01 ,0x20 ,0x11, 0x99, 0x00, 0x01, 0x00, 0x04, 0x0C, 0x03, 0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


//------------------------- 历史数据导出 historicalDataExport
+(void)historicalDataExportActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0x7B,0x01,0x10,0x01,0x20, 0x22,0x55,0x00,0x00,0x00,0x0A,0x07,0x08,0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
//------------------------- 历史数据导出写回应 historicalDataExport
+(void)historicalDataExportActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0x7B, 0x01, 0x10, 0x01, 0x20, 0x22, 0x99, 0x00, 0x01, 0x00, 0x0B, 0x08, 0x07, 0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//------------------------- S/N号读写 timeSettingAndReading
+(void)readAndWriteSNActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0x7B,0x01,0x10,0x01,0x20, 0x77, 0x55 ,0x00 ,0x00 ,0x01 ,0x0B ,0x0B ,0x04,0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
//------------------------- S/N号读写写回应 timeSettingAndReading
+(void)readAndWriteSNActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = { 0x7B, 0x01, 0x10, 0x01, 0x20, 0x55, 0x99, 0x00, 0x01, 0x01, 0x00, 0x03, 0x03, 0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
//------------------------- 客户端读取历史 deleteHistory
+(void)clientReadHistoryActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0x7B,0x01,0x10,0x01,0x20, 0XDD ,0X55 ,0X00 ,0X00 ,0X03 ,0X0A ,0X06 ,0X0C,0x7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
//------------------------- 客户端读取历史写回应 deleteHistory
+(void)clientReadHistoryActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0X7B, 0X01 ,0X10 ,0X01 ,0X20 , 0XDD,0X99 ,0X00 ,0X01 ,0X03 ,0X0B ,0X09 ,0X03 ,0X7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
/**
 浓度单位 读
 */
+(void)clientReadConcentrationUnitActionRead:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0X7B, 0X01 ,0X10 ,0X01 ,0X20 ,0XAA ,0X55 ,0X00 ,0X00 ,0X02 ,0X01 ,0X0D ,0X08 ,0X7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
/**
 浓度单位 写回应
 */
+(void)clientReadConcentrationUnitActionWriteResponse:(CBPeripheral *)currPeripheral  actionCharacteristic:(CBCharacteristic *)actionCharacteristic
{
    Byte byte[] = {0X7B, 0X01 ,0X10 ,0X01 ,0X20 , 0XAA,0X99 ,0X00 ,0X00 ,0X0E ,0X01 ,0X0E ,0X07 ,0X7D};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [currPeripheral writeValue:data forCharacteristic:actionCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
@end

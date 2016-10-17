//
//  Tools.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "PeripheralInfo.h"
//导入.h文件和系统蓝牙库的头文件
#import "BabyBluetooth.h"

#define MsgBox(msg) [self MsgBox:msg]

@protocol AutoConnectSucceed <NSObject>

-(void)AutoConnectSucceedWith:(CBPeripheral *)currPeripheral writeCharacteristi:(CBCharacteristic *)writeCharacteristic readCharacteristic:(CBCharacteristic *)readCharacteristic SerialNo:(NSString *)SerialNo BabyBlue:(BabyBluetooth *)baby;
-(void)AutoConnectFailed;
@end

@interface Tools : NSObject
{
@public
    BOOL succeeBOOL;
    BabyBluetooth *baby;
}

@property (nonatomic ,assign)BOOL hasSearched;
@property __block NSMutableArray *services;
@property (strong ,nonatomic)NSMutableArray *peripherals;
@property (strong ,nonatomic)NSMutableArray *peripheralsAD;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property (nonatomic,strong)CBCharacteristic *readCharacteristic;
@property (nonatomic ,copy)NSString *SerialNo ;

//血糖
@property(strong,nonatomic)CBPeripheral *currBSPeripheral;
@property (nonatomic,strong)CBCharacteristic *BSWriteCharacteristic;
@property (nonatomic,strong)CBCharacteristic *BSReadCharacteristic;

@property (nonatomic ,assign) __block int countNumber;

@property (nonatomic ,weak)id<AutoConnectSucceed>delegate;

+ (instancetype)shareTools;

id objectFromJSONData(NSData *data, NSError **error);

NSString * JSONStringFromObject(id object, NSError ** error);

BOOL StringIsValid(NSString *string);
NSString * CompareCurrentTime(NSDate *compareDate);

+ (CGFloat)getAdapterHeight;
+ (void)MsgBox:(NSString *)msg;
+ (void)show ;
+(void)dismiss ;

+ (void) OpenUrl:(NSString *)inUrl;
+ (UIImage *)createImageWithColor:(UIColor *)color;

+(BOOL) isTextViewNotEmpty:(NSString *) text isCue:(BOOL) isCue;

+(BOOL)isPureInt:(NSString*)string;
+(BOOL)isPureFloat:(NSString*)string;
+(BOOL)isPureDouble:(NSString*)string;

+(BOOL) isValidateMobile:(NSString *)mobile;
//验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email;

+(NSInteger) ageFromDate:(NSString *) dateStr;
+(NSDate *) dateFromString:(NSString *) dateStr;
+(NSString *) stringFromDate:(NSDate *) date;
//+(ErrorCode) errorCodeWithKey:(NSString *) errorCodeKey;

/**
 *	@brief	=====横向、纵向移动===========
 */
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x;
-(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)Y;

/**
 *@brief 把当前页转成Image
 */
+ (UIImage *)createImageWithView:(UIView *)view;
/**
 *@brief 可以直接使用十六进制设置控件的颜色，而不必通过除以255.0进行转换
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *@brief 根据收缩压和舒张压设置颜色
 */
+ (UIColor *)colorFromSPValue:(NSInteger )SPValue DSPValue:(NSInteger )DSPValue;
/**
 *@brief 根据健康指数设置颜色
 */
+ (UIColor *)colorFromHealthIndex:(id)healthIndex;
/**
 *@brief 打开蓝牙搜索设备，若有连过的则直接连
 */
-(void)babyDelegateBlueTooth:(id)object;

/**
 *@brief 根据不同屏幕显示字体
 */
+ (NSString*)deviceString;
+(UIFont *)fontFromFloatValue:(CGFloat)number;
+(UIFont *)fontFromHeightFloatValue:(CGFloat)number;
+(UIFont *)expectedLabelSizeFromString:(NSString *)str maxSize:(CGSize)maxSize;
/**
 *@brief 当前的语言环境
 */
+(NSString *)currentLanguage;
/**
 *@brief 中英文混合字符串长度
 */
+(NSInteger)stringLengthWithENandCH:(NSString *)targetString;

/**
 *	@brief	 全局血糖测量指令
 */
typedef enum BSInstructionType
{
    /***  客户端读取历史*/
    BSInstructionType_ReadHistory  =   0,
    /***  历史数据导出*/
    BSInstructionType_HistoricalDataExport,
    /***  S/N号读出*/
    BSInstructionType_ReadAndWriteSN,
    /***  仪器状态和测量结果*/
    BSInstructionType_PerialpheralStateAndResult,
    /***  单位*/
    BSInstructionType_PerialpheralConcentrationUnit
}BSInstructionType;

/**
 *	@brief	 全局血糖测量餐前餐后类型
 */
typedef enum BSTimeQuantumType
{
    /***  凌晨*/
    BSTimeQuantumType_AM  =   0,
    /***  早餐前*/
    BPValueType_BeforeBreakfast,
    /***  早餐后*/
    BPValueType_AfterBreakfast,
    /***  午餐前*/
    BPValueType_BeforeLunch,
    /***  午餐后*/
    BPValueType_AfterLunch,
    /***  晚餐前*/
    BPValueType_BeforeDinner,
    /***  晚餐后*/
    BPValueType_AfterDinner
    
}BSTimeQuantumType;

/**
 *	@brief	 从时间上得到餐前餐后类型
 */

+(BSTimeQuantumType)bsTimeQuantumTypeFromDate:(NSDate *)date;


/**
 *	@brief	 全局血糖测量餐前餐后类型
 */
typedef enum BSMeasureBtnState
{
    /***  正常*/
    BSMeasureBtnState_Normal  =   0,
    /***  保存血糖数据*/
    BSMeasureBtnState_Save,
    /***  查看历史血糖数据*/
    BSMeasureBtnState_CheckHistory
    
}BSMeasureBtnState;
/**
 *@brief 根据血糖测量餐前餐后类型血糖状态
 */
+ (NSString *)timeQuantumStringFromMeasureState:(NSString *)MeasureState;
/**
 *@brief 根据血糖测量值返回颜色值
 */
+ (UIColor *)colorFromBSValue:(id)bsValue;
@end

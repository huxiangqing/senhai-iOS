//
//  Tools.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "Tools.h"
#import "sys/utsname.h"

static Tools *_share_Tools = nil;

@implementation Tools

+ (instancetype)shareTools{
    if (_share_Tools == nil) {
        _share_Tools = [[Tools alloc] init];
    }
    return _share_Tools;
}

id objectFromJSONData(NSData *data, NSError **error) {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

NSString * JSONStringFromObject(id object, NSError ** error) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

BOOL StringIsValid(NSString *string)
{
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (!string || [string isEqual:[NSNull null]]) {
        return NO;
    }
    if ([string length] == 0) {
        return NO;
    }
    return YES;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
NSString * CompareCurrentTime(NSDate *compareDate)
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 30) {
        
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if(timeInterval <60){
        temp = timeInterval;
        result = [NSString stringWithFormat:@"%d秒前",temp];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}
+ (CGFloat)getAdapterHeight {
    CGFloat adapterHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}
//提示窗口
+ (void)MsgBox:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
                                                   delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}
+ (void)show {
    [SVProgressHUD show];
}
+ (void)dismiss {
    [SVProgressHUD dismiss];
}
//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

//纯色Image
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


//判断输入内容不为空
+(BOOL) isTextViewNotEmpty:(NSString *) text isCue:(BOOL) isCue
{
    BOOL isNotEmpty = YES;
    if (!text)
    {
        isNotEmpty = NO;
        //return isNotEmpty;
    }
    if (text.length == 0)
    {
        isNotEmpty = NO;
    }
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length == 0)
    {
        isNotEmpty = NO;
    }
    if (!isNotEmpty)
    {
        if (isCue)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"内容为空。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    return isNotEmpty;
}
//判断输入内容不含空格

//判断是否为整形：

+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
+(BOOL)isPureDouble:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    double val;
    return[scan scanDouble:&val] && [scan isAtEnd];
}


/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if(mobile.length == 11 && ([mobile hasPrefix:@"1"]) && ([self isPureInt:mobile]) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSInteger) ageFromDate:(NSString *) dateStr
{
    //将传入的时间转化成为相应的格式
    NSDateFormatter *formeatter=[[NSDateFormatter alloc] init];
    [formeatter  setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[formeatter  dateFromString:dateStr];
    NSTimeZone *fromzome=[NSTimeZone  systemTimeZone];
    NSInteger   frominterval=[fromzome secondsFromGMTForDate:fromdate];
    NSDate *fromDate=[fromdate dateByAddingTimeInterval:frominterval];
    //NSLog(@"fromDate is %@",fromDate);
    
    //获取系统当前时间
    NSDate *Newdate=[NSDate  date];
    NSTimeZone *zone=[NSTimeZone  systemTimeZone];
    NSInteger  interval=[zone secondsFromGMTForDate:Newdate];
    NSDate *localeDate=[Newdate  dateByAddingTimeInterval:interval];
    
    //NSLog(@"localeDate is %@",localeDate);
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate] ;
    
    long lTime=(long)intervalTime;
    //NSLog(@"lTime is %ld",lTime);
    
    //    NSInteger iSeconds = lTime % 60;
    //    NSInteger iMinutes = (lTime / 60) % 60;
    //    NSInteger iHours = (lTime / 3600);
    //    NSInteger iDays = lTime/60/60/24;
    //    NSInteger iMonth = lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/365;
    
    //NSLog(@"相差%d年%d月 或者 %d日%d时%d分%d秒 ", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    //NSLog(@" years  is %d:",iYears);
    return iYears;
}
+(NSDate *) dateFromString:(NSString *) dateStr
{
    //将传入的时间转化成为相应的格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *fromdate=[formatter  dateFromString:dateStr];
    return fromdate;
}
+(NSString *) stringFromDate:(NSDate *) date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [formatter stringFromDate:date];
}
//+(ErrorCode) errorCodeWithKey:(NSString *) errorCodeKey
//{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"plist"];
//    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    ErrorCode errorCode = [[dictionary valueForKey:errorCodeKey] intValue];
//    return errorCode;
//}
#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 0;//MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
-(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)Y
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];//
    animation.toValue = Y;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 0;//MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 *@brief 把当前页转成Image
 */
+ (UIImage *)createImageWithView:(UIView *)view
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    //UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}
/**
 *@brief 可以直接使用十六进制设置控件的颜色，而不必通过除以255.0进行转换
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

/**
 *	@brief	 全局血压配置类型
 */
typedef enum BPValueType
{
    /***  green 很正常*/
    BPValueType_Good     =      1,
    /***  正常*/
    BPValueType_Normal   = 1 << 1,
    /***  正常偏高*/
    BPValueType_NormalHigh = 1 << 2,
    /***  轻度高血压*/
    BPValueType_MildHypertension  = 1 << 3,
    /***  中度高血压*/
    BPValueType_ModerateHypertension = 1 << 4,
    /***  重度高血压*/
    BPValueType_SevereHypertension = 1 << 5
}BPValueType;
/**
 *	@brief	 收缩压类型
 */
+(BPValueType)BPValueTypeFromSPValue:(NSInteger )SPValue
{
     if (SPValue >= 180)
     {
         return BPValueType_SevereHypertension;
     }
    else if (( SPValue >= 160) && (SPValue <180) )
    {
        return BPValueType_ModerateHypertension;
    }
    else if (( SPValue >= 140) && (SPValue <160) )
    {
        return BPValueType_MildHypertension;
    }
    else if (( SPValue >= 130) && (SPValue <140) )
    {
        return BPValueType_NormalHigh;
    }
    else if (( SPValue >= 120) && (SPValue <130) )
    {
        return BPValueType_Normal;
    }
    else
    {
        return BPValueType_Good;
    }
}
/**
 *	@brief	 舒张压类型
 */
+(BPValueType)BPValueTypeFromDSPValue:(NSInteger )DSPValue
{
    if (DSPValue >= 110)
    {
        return BPValueType_SevereHypertension;
    }
    else if (( DSPValue >= 100) && (DSPValue <110) )
    {
        return BPValueType_ModerateHypertension;
    }
    else if (( DSPValue >= 90) && (DSPValue <100) )
    {
        return BPValueType_MildHypertension;
    }
    else if (( DSPValue >= 85) && (DSPValue <90) )
    {
        return BPValueType_NormalHigh;
    }
    else if (( DSPValue >= 80) && (DSPValue <85) )
    {
        return BPValueType_Normal;
    }
    else
    {
        return BPValueType_Good;
    }
}

/**
 *@brief 根据舒张压收缩压显示血压颜色
 */
+ (UIColor *)colorFromSPValue:(NSInteger )SPValue DSPValue:(NSInteger )DSPValue
{
    BPValueType SPValueType = [self BPValueTypeFromSPValue:SPValue];
    BPValueType DSPValueType = [self BPValueTypeFromDSPValue:DSPValue];
    
    BPValueType BPDataType = ( SPValueType < DSPValueType)?DSPValueType:SPValueType;
    
    UIColor *COLOR;
    
    switch (BPDataType) {
        case BPValueType_Good:
            COLOR = [self colorWithHexString:@"#5C9876"];
            break;
        case BPValueType_Normal:
            COLOR = [self colorWithHexString:@"#95CB6F"];
            break;
        case BPValueType_NormalHigh:
            COLOR = [self colorWithHexString:@"#D1DC7D"];
            break;
        case BPValueType_MildHypertension:
            COLOR = [self colorWithHexString:@"#F6C660"];
            break;
        case BPValueType_ModerateHypertension:
            COLOR = [self colorWithHexString:@"#EF9056"];
            break;
        case BPValueType_SevereHypertension:
           COLOR = [self colorWithHexString:@"#E45A58"];
            break;
            
        default:
            break;
    }
    
    return COLOR;
}

+ (UIColor *)colorFromHealthIndex:(id)healthIndex
{
    UIColor *COLOR;
    
    if ([healthIndex integerValue] >= 80)
    {
        COLOR = [self colorWithHexString:@"#5C9876"];
    }
    else if (( [healthIndex integerValue] >= 73) && ([healthIndex integerValue] < 80) )
    {
        COLOR = [self colorWithHexString:@"#95CB6F"];
    }
    else if (( [healthIndex integerValue] >= 65) && ([healthIndex integerValue] < 73) )
    {
        COLOR = [self colorWithHexString:@"#D1DC7D"];
    }
    else if (( [healthIndex integerValue] >= 50) && ([healthIndex integerValue] < 65) )
    {
        COLOR = [self colorWithHexString:@"#F6C660"];
    }
    else if (( [healthIndex integerValue] >= 35) && ([healthIndex integerValue] < 50) )
    {
        COLOR = [self colorWithHexString:@"#EF9056"];
    }
    else
    {
        COLOR = [self colorWithHexString:@"#E45A58"];
    }
    
    return COLOR;
}


/**
 *@brief 打开蓝牙搜索设备，若有连过的则直接连
 */
-(void)connectEquipment:(CBPeripheral *)peripheral
{
    //停止扫描
    [baby cancelScan];
    self.currPeripheral = peripheral;
    // [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Start connect device", nil)];
    baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}
//保存设备
-(void)saveEquipmentToServer:(CBCharacteristic *)SerialNoCharacteristic withObject:(id)object
{
    if (SerialNoCharacteristic) {
        NSString *SerialNo = [[NSString alloc] initWithData:SerialNoCharacteristic.value encoding:NSUTF8StringEncoding];
        self.SerialNo = SerialNo;
        succeeBOOL =YES;
        [self startWorkingWithObject:object];
    }
}

-(void)startWorkingWithObject:(id)object
{
    if (succeeBOOL == YES)
        {//成功
            if (!(self.writeCharacteristic && self.readCharacteristic)) {
                CBCharacteristic *writeCBCharacteristic = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFF2"];
                self.writeCharacteristic = writeCBCharacteristic;
                CBCharacteristic *readCBCharacteristic = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFF1"];
                self.readCharacteristic = readCBCharacteristic;
            }
            
            [SVProgressHUD dismiss];
            if (self.writeCharacteristic && self.readCharacteristic) {
                
                [self.delegate AutoConnectSucceedWith:self.currPeripheral writeCharacteristi:self.writeCharacteristic readCharacteristic:self.readCharacteristic SerialNo:self.SerialNo BabyBlue:(self->baby)];
            }
        }
        else
        {
            
        }
}

-(void)NoStoreageWithEquipments
{
    if (!self.hasSearched) {
        [SVProgressHUD dismiss];
//        [baby cancelAllPeripheralsConnection];
//        [baby cancelScan];
        [self.delegate AutoConnectFailed];
    }
}

-(void)babyDelegateBlueTooth:(id)object
{
    //[SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Ready to open the device", nil)];
    //初始化其他数据 init other
    self.peripherals = [[NSMutableArray alloc]init];
    self.peripheralsAD = [[NSMutableArray alloc]init];
    //初始化
    self.services = [[NSMutableArray alloc]init];
    self.hasSearched = NO;
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    
    __weak typeof(self) weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    if (self.currPeripheral.state != CBPeripheralStateConnected) {
        self.hasSearched = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
       // [baby cancelAllPeripheralsConnection];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby.scanForPeripherals().begin();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf NoStoreageWithEquipments];
        });
        [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
            if (central.state == CBCentralManagerStatePoweredOn) {
                // [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Starts scanning device", nil)];
            }
            else //if (central.state == CBCentralManagerStatePoweredOff)
            {
                // [SVProgressHUD showInfoWithStatus:@"设备打开失败，请打开蓝牙开关"];
            }
        }];
        //设置扫描到设备的委托
        [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
            NSArray *historyEquipmentArray = [[NTAccount shareAccount] BPEquipments];
            NSMutableArray *EquipmentArray = [[NSMutableArray alloc] initWithArray:historyEquipmentArray];
            
            if ([EquipmentArray containsObject:peripheral.identifier.UUIDString]) {
                [weakSelf connectEquipment:peripheral];
                [weakSelf setHasSearched:YES];
            }
          
        }];
        
        //设置设备连接成功的委托
        [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
            NSLog(@"设备：%@--连接成功",peripheral.name);
            
            //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            //保存设备
            weakSelf.currPeripheral = peripheral;
        }];
        //设置设备连接失败的委托
        [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
            NSLog(@"设备：%@--连接失败",peripheral.name);
            succeeBOOL = NO;
        }];
        //设置设备断开连接的委托
        [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
            NSLog(@"设备：%@--断开连接",peripheral.name);
            [weakSelf setHasSearched:NO];
            // [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
        }];
        //设置发现设备的Services的委托
        [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
            for (CBService *service in peripheral.services) {
                NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
                PeripheralInfo *info = [[PeripheralInfo alloc]init];
                [info setServiceUUID:service.UUID];
                info.characteristics = [[NSMutableArray alloc] initWithArray:service.characteristics];
                [weakSelf.services addObject:info];
            }
            [rhythm beats];
        }];
        //设置发现设service的Characteristics的委托
        [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
            NSLog(@"===service name:%@",service.UUID);
            int sect = -1;
            for (int i=0;i<self.services.count;i++) {
                PeripheralInfo *info = [weakSelf.services objectAtIndex:i];
                if (info.serviceUUID == service.UUID) {
                    sect = i;
                }
            }
            if (sect != -1) {
                PeripheralInfo *info =[weakSelf.services objectAtIndex:sect];
                for (int row=0;row<service.characteristics.count;row++) {
                    CBCharacteristic *c = service.characteristics[row];
                    [info.characteristics addObject:c];
                }
            }
        }];
        //设置读取characteristics的委托
        [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
            NSString *name = [NSString stringWithFormat:@"%@",characteristics.UUID];
            
            if ([name isEqualToString:@"Serial Number String"]) {
                
                NSArray *historyEquipmentArray = [[NTAccount shareAccount] BPEquipments];
                NSMutableArray *EquipmentArray = [[NSMutableArray alloc] initWithArray:historyEquipmentArray];
                if (![EquipmentArray containsObject:peripheral.identifier.UUIDString]) {
                    [EquipmentArray addObject:peripheral.identifier.UUIDString];
                }
                [[NTAccount shareAccount] setBPEquipments:EquipmentArray];
                
                [weakSelf saveEquipmentToServer:characteristics withObject:object];
            }
          
            
            NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,  characteristics.value);
        }];
        //设置发现characteristics的descriptors的委托
        [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
            NSLog(@"===characteristic name:%@",characteristic.service.UUID);
            for (CBDescriptor *d in characteristic.descriptors) {
                NSLog(@"CBDescriptor name is :%@",d.UUID);
            }
        }];
        //设置读取Descriptor的委托
        [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
            NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        }];
        
        //设置beats break委托
        [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
            NSLog(@"setBlockOnBeatsBreak call");
        }];
        
        //设置beats over委托
        [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
            NSLog(@"setBlockOnBeatsOver call");
        }];
        //设置查找设备的过滤器
        [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
                if(peripheralName.length > 0)
                {
                    if (weakSelf.countNumber == 0) {
                        weakSelf.countNumber  = 1;
                    }
                    
                    return YES;
                }
                else
                {
                    weakSelf.countNumber ++;
                    if (weakSelf.countNumber == 800) {
                        [weakSelf performSelector:@selector(NoStoreageWithEquipments) withObject:nil afterDelay:1];
                    }
                    return NO;
                }
        }];
        [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
            NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
        }];
        [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
            NSLog(@"setBlockOnCancelScanBlock");
        }];
        /*设置babyOptions
         
         参数分别使用在下面这几个地方，若不使用参数则传nil
         - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
         - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
         - [peripheral discoverServices:discoverWithServices];
         - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
         
         该方法支持channel版本:
         [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
         */
        //示例:
        //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
        NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
        /*连接选项->
         CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
         CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
         CBConnectPeripheralOptionNotifyOnNotificationKey:
         当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
         */
        NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                         CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                         CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
        //连接设备->
        [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf equipmentUnOpen];
        });
    }
    else
    {
        succeeBOOL =YES;
        [self startWorkingWithObject:object];
    }
    
}

-(void)equipmentUnOpen
{
    if (self.countNumber == 0) {
        if (!succeeBOOL) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"设备打开失败，请打开蓝牙开关"];
        }
    }
}


/**
 *@brief 根据不同屏幕显示字体
 */
+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}


+(UIFont *)fontFromFloatValue:(CGFloat)number
{
    UIFont *font = [UIFont systemFontOfSize:(number*MutiValue)];
    return font;
}

+(UIFont *)fontFromHeightFloatValue:(CGFloat)number
{
    CGFloat height =  iPad ? 480.0 : SCREENHEIGHT;
    
    UIFont *font = [UIFont systemFontOfSize:(number*(height/480.0))];
    
    return font;
}

+(UIFont *)expectedLabelSizeFromString:(NSString *)str maxSize:(CGSize)maxSize
{
    int currentFontSize= 16;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics;
    
    CGSize requiredSize = [str boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    
    if(requiredSize.height<=maxSize.height)
    {
        while (requiredSize.height<=maxSize.height) {
            ++currentFontSize;
            requiredSize=[str boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
    }else
    {
        while (requiredSize.height>maxSize.height) {
            --currentFontSize;
            requiredSize=[str boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
        }
        requiredSize=[str boundingRectWithSize:maxSize options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:currentFontSize]} context:nil].size;
    }

    UIFont *font = [UIFont systemFontOfSize:currentFontSize];
    return font;
}

/**
 *@brief 当前的语言环境
 */
+(NSString *)currentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return ([currentLanguage hasPrefix:@"zh"] ? @"Chinese" : @"English" );
}

/**
 *@brief 中英文混合字符串长度
 */
+(NSInteger)stringLengthWithENandCH:(NSString *)targetString
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [targetString dataUsingEncoding:enc];
    return [da length];
}
/**
 *	@brief	 从时间上得到餐前餐后类型
 */

+(BSTimeQuantumType)bsTimeQuantumTypeFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:date];
    
    NSInteger nowHour = components.hour;
    
    if(nowHour > 5 && nowHour < 7)
    {
        return BPValueType_BeforeBreakfast;
    }
    else if (nowHour >= 7 && nowHour < 10)
    {
        return BPValueType_AfterBreakfast;
    }
    else if (nowHour >= 10 && nowHour < 12)
    {
        return BPValueType_BeforeLunch;
    }
    else if (nowHour >= 12 && nowHour < 16)
    {
        return BPValueType_AfterLunch;
    }
    else if (nowHour >= 16 && nowHour < 18)
    {
        return BPValueType_BeforeDinner;
    }
    else if (nowHour >= 18 && nowHour < 22)
    {
        return BPValueType_AfterDinner;
    }
    else
    {
        return BSTimeQuantumType_AM;
    }
}
/**
 *@brief 根据血糖测量餐前餐后类型血糖状态
 */
+ (NSString *)timeQuantumStringFromMeasureState:(NSString *)MeasureState
{
    BSTimeQuantumType timeQuantumType = [MeasureState intValue];

    NSString *timeQuantumString;
    
    switch (timeQuantumType) {
        case BSTimeQuantumType_AM:
            timeQuantumString = @"凌晨";
            break;
        case BPValueType_BeforeBreakfast:
            timeQuantumString = @"早餐前";
            break;
        case BPValueType_AfterBreakfast:
            timeQuantumString = @"早餐后";
            break;
        case BPValueType_BeforeLunch:
            timeQuantumString = @"午餐前";
            break;
        case BPValueType_AfterLunch:
            timeQuantumString = @"午餐后";
            break;
        case BPValueType_BeforeDinner:
            timeQuantumString = @"晚餐前";
            break;
        case BPValueType_AfterDinner:
            timeQuantumString = @"晚餐后";
            break;
        default:
            break;
    }
    
    return timeQuantumString;
}
/**
 *@brief 根据血糖测量值返回颜色值
 */
+ (UIColor *)colorFromBSValue:(id)bsValue
{
    UIColor *COLOR;
    
    if ([bsValue doubleValue] >= 6.11)
    {
        COLOR = [self colorWithHexString:@"#E45A58"];
    }
    else if (( [bsValue doubleValue] >= 3.61) && ([bsValue doubleValue] < 6.11) )
    {
        COLOR = [self colorWithHexString:@"#5C9876"];
    }
    else
    {
        COLOR = [self colorWithHexString:@"#F6C660"];
    }
    
    return COLOR;
}

@end

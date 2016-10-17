//
//  BSMeasureVC.m
//  LUDE
//
//  Created by lord on 16/6/6.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "BSMeasureVC.h"
#import "BSManualInputVC.h"
#import "PickerView.h"
#import "XDPopoverListView.h"
#import "HistoryBSVC.h"
#import "findEquipmentViewC.h"
#import "BSInstructionSet.h"

#define channelOnPeropheralView @"BSMeasureVC"

@interface BSMeasureVC ()<pickViewHideAndShow,XDPopoverListDatasource,XDPopoverListDelegate,UINavigationControllerDelegate>
{
    XDPopoverListView   *listView;
    NSString         *showXDPopoverListViewType;//弹框显示的类型
    NSInteger        showXDPopverCount;
    
    BOOL succeeBOOL;
    
    NSString  *showResult ;
    NSString *perialpheralState;
    
}

@property (strong ,nonatomic)__block findEquipmentViewC *findEquipmentvc;

@property (weak, nonatomic) IBOutlet UIButton *measureBtn;
@property (weak, nonatomic) IBOutlet UILabel *BSUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *BSResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *measureResultButton;
@property (weak, nonatomic) IBOutlet UIButton *measureTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *measureTimeQuantumButton;

@property (strong ,nonatomic)PickerView *pick;
@property (copy, nonatomic) NSString *timeString;
@property (copy ,nonatomic) NSString *measureStateQuantumString;

@property (nonatomic ,retain)NSArray *timeQuantumStatesArray;

@property (strong ,nonatomic)NSMutableArray *peripherals;
@property (strong ,nonatomic)NSMutableArray *peripheralsAD;

@property (nonatomic ,copy)NSString *SerialNo ;

@property (weak, nonatomic) UILabel *titleLabel_UILabel;
@property (weak, nonatomic) UILabel *resultLabel_UILabel;
@property (nonatomic ,copy) NSString *resultValueString;
@property (nonatomic ,strong) NSMutableArray *tempValueArray;
@property (nonatomic ,copy) NSString *tempValueString;

@property (nonatomic, strong) NSMutableData *resultData;
@property (nonatomic, assign) NSInteger flag;

@property (nonatomic ,assign) BSMeasureBtnState measureBtnState;
@property (nonatomic ,copy) NSString *SNNumberString;
@property (nonatomic, weak) UILabel *BSPerialpheralStateResultLabel;

@property (nonatomic ,strong) HealthManager *healthManager;

@property (nonatomic ,copy) NSString *unitString;

@end

@implementation BSMeasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate =self;
    self.timeQuantumStatesArray = @[@"凌晨",@"早餐前",@"早餐后",@"午餐前",@"午餐后",@"晚餐前",@"晚餐后"];
    
    self.timeString = [Tools stringFromDate:[NSDate date]];
    [self.measureTimeButton setTitle:self.timeString forState:UIControlStateNormal];
    
    BSTimeQuantumType quantumType  = [Tools bsTimeQuantumTypeFromDate:[NSDate date]];
    
    self.measureStateQuantumString = [NSString stringWithFormat:@"%d",quantumType];
    [self.measureTimeQuantumButton setTitle:self.timeQuantumStatesArray[quantumType] forState:UIControlStateNormal];
    
    //初始化其他数据 init other
    self.peripherals = [[NSMutableArray alloc]init];
    self.peripheralsAD = [[NSMutableArray alloc]init];
    //初始化
    self.services = [[NSMutableArray alloc]init];
    
    //蓝牙模块
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    
    self.tempValueArray = [[NSMutableArray alloc] init];
    
    self.BSPerialpheralStateResultLabel = LabelInitZeroFrmAlignNum(2,NSTextAlignmentCenter, [UIFont systemFontOfSize:30], [UIColor whiteColor], self.view);
    [self.BSPerialpheralStateResultLabel setAdjustsFontSizeToFitWidth:YES];
    
    //self.resultData = [[NSMutableData alloc] init];
    
    self.resultValueString = @"";
    self.tempValueString = @"";
    self.SNNumberString = @"";
    self.measureBtnState = BSMeasureBtnState_Normal;
    
    if (!baby) {
        //初始化BabyBluetooth 蓝牙库
        baby = [BabyBluetooth shareBabyBluetooth];
    }
    
    Tools *tool = [Tools shareTools];
    
    if (tool.currBSPeripheral && (tool.currBSPeripheral.state == CBPeripheralStateConnected)) {
        
        self.currPeripheral = tool.currBSPeripheral;
        self.readCharacteristic = tool.BSReadCharacteristic;
        self.writeCharacteristic = tool.BSWriteCharacteristic;
        
        [self.measureResultButton setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
        
        [self babyReadDelegate];
        baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.readCharacteristic);
        [self setNotifiy];
        [self sendOperationBtnClicked:BSInstructionType_ReadAndWriteSN];
    }
    else
    {
        
        //设置蓝牙委托 自动连接失败的代理
        [self babyDelegate];
        [self babyReadDelegate];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby.scanForPeripherals().begin();
        
        [self.measureResultButton setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
        
        [self NoEquipments];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [MobClick beginLogPageView:@"血糖测量页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"血糖测量页"];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)NoEquipments
{
    WeakObject(self);
   
    [self.measureBtn setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.peripherals.count == 0)
        {
            if ([__weakObject.view.subviews containsObject:__weakObject.findEquipmentvc.view]) {
                [__weakObject.findEquipmentvc.view removeFromSuperview];
            }
            [__weakObject.measureBtn setEnabled:YES];
            [__weakObject popSearchEquipmentView];
        }
    });
}

-(void)popSearchEquipmentView
{
    WeakObject(self);
    _findEquipmentvc = [[findEquipmentViewC alloc] initWithSecondStoryboardID:@"findEquipmentViewC"];
    _findEquipmentvc.isBSType = YES;
    _findEquipmentvc.view.frame=CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height - 64.0);
    _findEquipmentvc.peripherals = self.peripherals;
    _findEquipmentvc.selectedPeripheral = ^(CBPeripheral *peripheral){
        [__weakObject connectEquipment:peripheral];
    };
    
    if (_findEquipmentvc) {
        
        [self.BSResultLabel setText:@""];
        [self.BSUnitLabel setHidden:YES];
        [self.BSPerialpheralStateResultLabel setText:@"请连接西恩血糖仪"];
        
        [_findEquipmentvc reloadTableView:self.peripherals.count];
        [self.view addSubview:_findEquipmentvc.view];
    }
}

-(void)viewDidLayoutSubviews
{
    self.BSPerialpheralStateResultLabel.widthValue = self.measureBtn.widthValue- 70.0;
    self.BSPerialpheralStateResultLabel.heightValue = self.measureBtn.heightValue - 80.0;
    self.BSPerialpheralStateResultLabel.centerYValue = self.view.centerYValue - 50.0;
    self.BSPerialpheralStateResultLabel.centerXValue = self.view.centerXValue;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
#pragma mark -蓝牙配置和操作
-(void)connectEquipment:(CBPeripheral *)peripheral
{
    //停止扫描
    [baby cancelScan];
    self.currPeripheral = peripheral;
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Start connect device", nil)];
    baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}
//订阅一个值
-(void)setNotifiy{
    if(self.currPeripheral.state != CBPeripheralStateConnected){
        [SVProgressHUD showErrorWithStatus:@"设备已经断开连接，请重新连接"];
        return;
    }
    if (self.readCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.readCharacteristic.properties & CBCharacteristicPropertyIndicate){
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
        [baby notify:self.currPeripheral
      characteristic:self.readCharacteristic
               block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                   [self insertReadValues:characteristics];
               }];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
}
//插入描述
-(void)insertDescriptor:(CBDescriptor *)descriptor{
    [self->descriptors addObject:descriptor];
}
//插入读取的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    NSString *valueString = [NSString stringWithFormat:@"%@",characteristics.value];
    [self.resultData appendData:characteristics.value];
    // NSLog(@"\n\n\n\n：插入读取的值\n%@",valueString);
    [self dealDataWithFlag:self.flag];
    
    NSString *hexstring = [[valueString substringWithRange:NSMakeRange(1, valueString.length - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    hexstring = [[hexstring substringWithRange:NSMakeRange(0, hexstring.length)] stringByReplacingOccurrencesOfString:@"null" withString:@""];
    if (hexstring.length > 2) {
        //[self->readValueArray addObject:hexstring];
        self.tempValueString = [self.tempValueString stringByAppendingString:hexstring];
        self.resultValueString = [self.resultValueString stringByAppendingString:hexstring];
    }
}

-(void)analysisDataResult:(NSString *)resultValueString
{
    
    NSString *str = [resultValueString substringWithRange:NSMakeRange(18, resultValueString.length - 18 - 10)];
    /*00000030303031343135303030313232*/ /*0001415000122*/
    NSString *dataString = @"";
    
    if ([resultValueString containsString:@"77aa"]) {
        for (int i = 0; i < str.length ; i += 2) {
            NSString *sub = [str substringWithRange:NSMakeRange(i, 2)];
            NSString *result = [self intValueToASCLLValue:[self resultVlueWithHexstringToIntValue:sub]];
            dataString = [dataString stringByAppendingString:result];
        }
    }
    else
    {
        dataString = str;
    }
    
    self.SNNumberString = dataString;
    
    [self sendOperationBtnClicked:BSInstructionType_PerialpheralConcentrationUnit];
    //[self sendOperationBtnClicked:BSInstructionType_PerialpheralStateAndResult];
}

-(void)dealDataWithFlag:(NSInteger)flag
{
    NSString *dataString= [NSString stringWithFormat:@"%@",self.resultData];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"null" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    
    NSString *endFlag = @"7b01200110d16600000b0903047d";
    
    if (flag == 0) //客户端读取历史7b01200110d16600000b0903047d
    {
        if ([dataString hasSuffix:endFlag]) {
            [BSInstructionSet clientReadHistoryActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            [self clientReadHistory:[dataString substringToIndex:(dataString.length - endFlag.length)]];
            [SVProgressHUD dismiss];
            NSLog(@"结束标志");
        }
    }
    else if (flag == 1)//历史数据导出7b01200110d16600000b0903047d
    {
        if ([dataString hasSuffix:endFlag]) {
           // [BSInstructionSet historicalDataExportActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            [self exportHistoryData:[dataString substringToIndex:(dataString.length - endFlag.length)]];
            [SVProgressHUD dismiss];
            NSLog(@"结束标志");
        }
    }
    else if (flag == 2)//S/N号读出
    {
        if ([dataString hasSuffix:@"7d"] &&  [dataString containsString:@"77aa"] ) {
            //[BSInstructionSet readAndWriteSNActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            [self analysisDataResult:dataString];
            [SVProgressHUD dismiss];
            NSLog(@"结束标志");
        }
    }
    else if (flag == 3)//仪器状态和测量结果
    {
        if ([dataString hasSuffix:@"7d"] &&  [dataString containsString:@"12aa"]  && ![dataString containsString:@"10d266"]) {
            //[BSInstructionSet perialpheralStateAndResultActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            [self perialpheralStateAndResult:dataString];
            [SVProgressHUD dismiss];
            NSLog(@"结束标志");
        }
    }
    else if (flag == 4)//仪器单位
    {
        if ([dataString hasSuffix:@"7d"] &&  [dataString containsString:@"aaaa"] ) {
            //[BSInstructionSet clientReadConcentrationUnitActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            [self clientReadConcentrationUnit:dataString];
            [SVProgressHUD dismiss];
            NSLog(@"结束标志");
        }
    }

    
}
//仪器单位
-(void)clientReadConcentrationUnit:(NSString *)result
{
    NSString *str = [result substringWithRange:NSMakeRange(result.length - 12, 2)];
    
    if ([str isEqualToString:@"11"]) {
        self.unitString = @"mg/dL";
    }
    else if([str isEqualToString:@"22"])
    {
        self.unitString = @"mmol/L";
    }
    
    [self.BSUnitLabel setText:[NSString stringWithFormat:@"(%@)",self.unitString]];
    
    [self sendOperationBtnClicked:BSInstructionType_PerialpheralStateAndResult];
}

//客户端读取历史
-(void)clientReadHistory:(NSString *)result
{
    NSString *showString = @"";
    
    NSArray *historyArray = [result componentsSeparatedByString:@"7d"];/*7b01200110ddaa000910010100000000001105030002*/
    for (NSString *resultStr in historyArray) {//100101000000000011
        if (resultStr.length > 0) {
            NSString *dataString;
            dataString  = [resultStr substringWithRange:NSMakeRange(resultStr.length - 18 - 8,18)];
            NSString *historyTime = [NSString stringWithFormat:@"测量时间为%d.%d.%d %d::%d",(2000+[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(0, 2)]]),[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(2, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(4, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(6, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(8, 2)]]];
            NSString *measureReault = [NSString stringWithFormat:@"测量结果为:%.1f",[self BSResultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(10, 4)]]];
            
            showString = [showString stringByAppendingString:[NSString stringWithFormat:@"%@ %@mg/dl ,",historyTime,measureReault]];
        }
    }
     NSLog(@"\n\n\n\n结果：\n%@",showString);
    
}
//历史数据导出
-(void)exportHistoryData:(NSString *)result
{
    NSString *showString = @"";
    NSArray *historyArray = [result componentsSeparatedByString:@"7d"];/*7b0120011022aa002f000000303030303131393156434930320e07170d0102052211285f041c0458152f0132143f0963011f011e011f011f0a020f0f*/
    for (NSString *resultStr in historyArray) {
        if (resultStr.length > 0) {
            NSString *dataString;
            dataString  = [resultStr substringWithRange:NSMakeRange(resultStr.length - 94 - 8,94)];
            NSString *historyTime = [NSString stringWithFormat:@" 测量时间为%d.%d.%d %d::%d",(2000+[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(32, 2)]]),[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(34, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(36, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(38, 2)]],[self resultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(40, 2)]]];
            NSString *measureReault = [NSString stringWithFormat:@"测量结果为:%.1f",[self BSResultVlueWithHexstringToIntValue:[dataString substringWithRange:NSMakeRange(42, 4)]]];
            
            showString = [showString stringByAppendingString:[NSString stringWithFormat:@"%@ %@mg/dl ,",historyTime,measureReault]];
        }
    }
    
    NSLog(@"\n\n\n\n结果：\n%@",showString);
}
//-------------------------  仪器状态和测量结果
-(void)perialpheralStateAndResult:(NSString *)string
{
    NSString  *str = [string substringWithRange:NSMakeRange(string.length - 20, 10)];
    /*1100001100*/
    
    perialpheralState = [str substringToIndex:2];
    NSString *measureResult = [str substringWithRange:NSMakeRange(2, 4)];
    NSString *sampleState = [str substringWithRange:NSMakeRange(6, 2)];
    NSString *errorCode = [str substringFromIndex:8];
    
    
    NSLog(@"\n\n\n%@\n仪器状态和测量结果：\n%@",string,perialpheralState);
    
    
    if ([perialpheralState isEqualToString:@"11"]) {
        showResult = @"已插条";
    }else  if ([perialpheralState isEqualToString:@"22"]) {
        showResult = @"自检完成可以加血";
    }else  if ([perialpheralState isEqualToString:@"33"]) {
        showResult = @"已经加血进入倒计时";
    }else  if ([perialpheralState isEqualToString:@"44"] || [perialpheralState isEqualToString:@"10"]) {
        showResult = [NSString stringWithFormat:@"%.1f",[self BSResultVlueWithHexstringToIntValue:measureResult]];
    }else  if ([perialpheralState isEqualToString:@"55"]) {
        showResult = [NSString stringWithFormat:@"%@:%@",@"仪器出现报警码，报警码为",errorCode];
    }
    else
    {
        showResult = @"";
    }
    
    if ([perialpheralState isEqualToString:@"44"] || [perialpheralState isEqualToString:@"10"]) {
        
        self.measureBtnState = BSMeasureBtnState_Save;
        [self.BSUnitLabel setHidden:NO];
        [self.BSResultLabel setText:showResult];
        [self.BSPerialpheralStateResultLabel setText:@""];
        
        [self.measureResultButton setTitle:@"保存" forState:UIControlStateNormal];
        
    }
    else if ([perialpheralState isEqualToString:@"33"])
    {
        self.measureBtnState = BSMeasureBtnState_Normal;
        
        [self.BSResultLabel setText:@""];
        [self.BSUnitLabel setHidden:YES];
        [self.BSPerialpheralStateResultLabel setText:showResult];
        
       // [self.measureResultButton setTitle:showResult forState:UIControlStateNormal];
        WeakObject(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__weakObject startWithTime:5];
        });
    }
    else
    {
        self.measureBtnState = BSMeasureBtnState_Normal;
        
        [self.BSResultLabel setText:@""];
        [self.BSUnitLabel setHidden:YES];
        [self.BSPerialpheralStateResultLabel setText:showResult];
        
      //  [self.measureResultButton setTitle:showResult forState:UIControlStateNormal];
    }
    
    [BSInstructionSet perialpheralStateAndResultActionWriteResponse:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
}
/**
 *	@brief 开启显示
 */
- (void)startWithTime:(NSInteger)timeLine {
    
    [self.BSPerialpheralStateResultLabel setText:@""];
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([perialpheralState isEqualToString:@"44"])
                {
                    if (showResult) {
                        [self.BSResultLabel setText:showResult];
                    }
                }
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
               [self.BSResultLabel setText:timeStr];
                
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *	@brief 得到的血压值10进制的字符串转换成ASCLL码值
 */
-(NSString *)intValueToASCLLValue:(int)result
{
    NSString *string =[NSString stringWithFormat:@"%c",result];
    return string;
}
/**
 *	@brief 得到的血压值16进制的字符串根据血糖协议 （高位乘以100 + 低位）转换成10进制数值
 */
-(CGFloat)BSResultVlueWithHexstringToIntValue:(NSString *)hexstring
{
    CGFloat result = 0;
    if (hexstring.length == 4) {
        NSString *subStringHigh = [hexstring substringWithRange:NSMakeRange( 0, 2)];
        NSString *subStringLow = [hexstring substringWithRange:NSMakeRange( 2, 2)];
        result += 100*([self resultVlueWithHexstringToIntValue:subStringHigh]);
        result += [self resultVlueWithHexstringToIntValue:subStringLow];
    }
    
    if([self.unitString isEqualToString:@"mmol/L"])
    {
        return result/10.0;
    }
    
    return result;
}

/**
 *	@brief 得到的血压值16进制的字符串转换成10进制数值
 */
-(int)resultVlueWithHexstringToIntValue:(NSString *)hexstring
{
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    unsigned long hex = strtoul([hexstring UTF8String],0,16);
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
    // unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    // NSLog(@"转换完的16进制的数字为：%lx",hex);
    NSData *data = [[NSData alloc] initWithBytes:&hex length:sizeof(hex)];
    int resultValue;
    [data getBytes:&resultValue length:sizeof(resultValue)];
    // NSLog(@"转换完的10进制的数字为：%d",resultValue);
    return resultValue;
}

/**
 *	@brief 不同指令下的操作点
 */
- (void)sendOperationBtnClicked:(BSInstructionType)BSInstructionAction {
    self.resultData = nil;
    self.resultData = [[NSMutableData alloc] init];
    self.resultValueString = @"";
    switch (BSInstructionAction) {
        case BSInstructionType_ReadHistory:
            [BSInstructionSet clientReadHistoryActionRead:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            /*7b01200110ddaa0009100101000c0054001100020d037d*/
         
            self.flag = 0;
            break;
        case BSInstructionType_HistoricalDataExport:
            [BSInstructionSet historicalDataExportActionRead:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            /*7b01200110ddaa0009100101000c0054001100020d037d*/
          
            self.flag = 1;
            break;
        case BSInstructionType_ReadAndWriteSN:
            [BSInstructionSet readAndWriteSNActionRead:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            
            self.flag = 2;
            break;
        case BSInstructionType_PerialpheralStateAndResult:
            [BSInstructionSet perialpheralStateAndResultActionRead:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
           
            /*7b0120011012aa00051100001100020b010d7d*/
            self.flag = 3;
            break;
        case BSInstructionType_PerialpheralConcentrationUnit:
            [BSInstructionSet clientReadConcentrationUnitActionRead:self.currPeripheral actionCharacteristic:self.writeCharacteristic];
            
            self.flag = 4;
            break;
            
        default:
            break;
    }
}


//蓝牙委托设置

-(void)babyReadDelegate{
    
    __weak typeof(self)weakSelf = self;
    
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        if ([weakSelf.peripherals containsObject:peripheral]) {
            [weakSelf.peripherals removeObject:peripheral];
        }
        [central cancelPeripheralConnection:peripheral];
        [weakSelf.measureBtn setEnabled:YES];
        
        [SVProgressHUD showErrorWithStatus:@"设备已经断开连接，请重新连接"];
        
        [weakSelf.BSResultLabel setText:@""];
        [weakSelf.BSUnitLabel setHidden:YES];
        [weakSelf.BSPerialpheralStateResultLabel setText:@"请连接西恩血糖仪"];
        
        [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [weakSelf insertReadValues:characteristics];
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            [weakSelf insertDescriptor:d];
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                // NSLog(@"------------\n%@-----------",descriptor.value);
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];

}
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Starts scanning device", nil)];
        }
        
        [weakSelf NoEquipments];
    }];
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@\n",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData];
    }];
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
        
        if ([weakSelf.view.subviews containsObject:weakSelf.findEquipmentvc.view]) {
            [weakSelf.findEquipmentvc.view removeFromSuperview];
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        //保存设备
        weakSelf.currPeripheral = peripheral;
    }];
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        
        [SVProgressHUD showErrorWithStatus:@"连接失败"];
        
        succeeBOOL = NO;
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        if ([weakSelf.peripherals containsObject:peripheral]) {
            [weakSelf.peripherals removeObject:peripheral];
        }
        
        [central cancelPeripheralConnection:peripheral];
        [weakSelf.measureBtn setEnabled:YES];
        
        [SVProgressHUD showErrorWithStatus:@"设备已经断开连接，请重新连接"];
        
        [weakSelf.BSResultLabel setText:@""];
        [weakSelf.BSUnitLabel setHidden:YES];
        [weakSelf.BSPerialpheralStateResultLabel setText:@"请连接西恩血糖仪"];
        [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"%@:%@",NSLocalizedString(@"Search Service", nil),service.UUID.UUIDString);
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
        [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:0.2];
        
        [weakSelf saveEquipmentToServer:peripheral];
        
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
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
   
        if([peripheralName hasPrefix:@"B"])
        {
            return YES;
        }
        return NO;
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
}
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![self.peripherals containsObject:peripheral]){
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [self.peripherals addObject:peripheral];
        
        [self.peripheralsAD addObject:advertisementData];
       // [listView.mainPopoverListView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        _findEquipmentvc.peripherals = self.peripherals;
        [_findEquipmentvc.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [_findEquipmentvc reloadTableView:self.peripherals.count];
        [_findEquipmentvc.tableView reloadData];
        
        [self.BSResultLabel setText:@"-"];
        [self.BSUnitLabel setHidden:NO];
        [self.BSPerialpheralStateResultLabel setText:@""];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *historyEquipmentArray = [[NTAccount shareAccount] BSEquipments];
            NSMutableArray *EquipmentArray = [[NSMutableArray alloc] initWithArray:historyEquipmentArray];
            if ([EquipmentArray containsObject:peripheral.identifier.UUIDString]) {
                [self connectEquipment:peripheral];
                
                if ([self.view.subviews containsObject:self.findEquipmentvc.view]) {
                    [self.findEquipmentvc.view removeFromSuperview];
                }
            }
            else
            {
                WeakObject(self);
        
                [self.measureBtn setEnabled:YES];
                if ([self.view.subviews containsObject:self.findEquipmentvc.view]) {
                    [self.findEquipmentvc.view removeFromSuperview];
                }
                [__weakObject popSearchEquipmentView];
            
            }
        });
    }
    
}
//保存设备
-(void)saveEquipmentToServer:(CBPeripheral *)peripheral
{
    succeeBOOL =YES;
    [self startWorking];
    
    NSArray *historyEquipmentArray = [[NTAccount shareAccount] BSEquipments];
    NSMutableArray *EquipmentArray = [[NSMutableArray alloc] initWithArray:historyEquipmentArray];
    if (![EquipmentArray containsObject:peripheral.identifier.UUIDString]) {
        [EquipmentArray addObject:peripheral.identifier.UUIDString];
    }
    [[NTAccount shareAccount] setBSEquipments:EquipmentArray];

}

/**
 *	@brief	 开始扫描特性，并连接
 */
-(void)startWorking
{
    if (succeeBOOL == YES)
    {//成功
        /* 遍历找出该设备的读，写特性*/
        for (CBService *s in self.services) {
            for (CBCharacteristic *c in s.characteristics) {
                if (c.properties == CBCharacteristicPropertyWriteWithoutResponse) {
                    self.writeCharacteristic = c;
                }
                else if (c.properties == CBCharacteristicPropertyNotify)
                {
                    self.readCharacteristic = c;
                }
            }
        }
        /* 找到该设备的读，写特性，进入发送指令页*/
        if (self.writeCharacteristic && self.readCharacteristic) {
            
            Tools *tool = [Tools shareTools];
            tool.currBSPeripheral = self.currPeripheral;
            tool.BSWriteCharacteristic = self.writeCharacteristic;
            tool.BSReadCharacteristic = self.readCharacteristic;
            
            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.readCharacteristic);
            [self setNotifiy];
            
            //[self sendOperationBtnClicked:BSInstructionType_PerialpheralConcentrationUnit];
            [self sendOperationBtnClicked:BSInstructionType_ReadAndWriteSN];
        }
    }
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	 手动输入点击事件
 */
- (IBAction)manualInputButtonClicked:(UIButton *)sender {
    
    BSManualInputVC *BSMeasureInput = [[BSManualInputVC alloc] initWithSecondStoryboardID:@"BSManualInputVC"];
    [self.navigationController pushViewController:BSMeasureInput animated:YES];
}
/**
 *	@brief	 测量时间点击事件
 */
- (IBAction)selectTimeButtonClicked:(UIButton *)sender {
    self.pick = [[PickerView alloc] initWithFrame:CGRectMake(0,SCREENHEIGHT - 220 , SCREENWIDTH, 220) PickerStyle:MonthDayHourMinute];
    self.pick.delagate =self;
    [self.view addSubview:self.pick];
}
-(void)PickerViewWillclose
{
    [self.pick removeFromSuperview];
}
-(void)DatePickViewValues:(NSString *)Values
{
    self.timeString = Values;
    [self.measureTimeButton setTitle:Values forState:UIControlStateNormal];
}
/**
 *	@brief	 餐前餐后点击事件
 */
- (IBAction)selectedTimeQuantum:(UIButton *)sender {
    
    [sender setSelected:YES];
    
  showXDPopoverListViewType=nil;
  showXDPopverCount=self.timeQuantumStatesArray.count;
    
    NSInteger   popverHeight=showXDPopverCount*45;
    if (showXDPopverCount>7) {
        popverHeight=7*45+50;
    }
    
    CGRect frame = CGRectMake(sender.leftValue, sender.bottomValue-sender.heightValue - popverHeight, sender.widthValue,popverHeight);
    
    [self showXDPopoverListViewWithRect:frame];
    
}
#pragma mark -选择
-(void)showXDPopoverListViewWithRect:(CGRect)frame{
    listView=[[XDPopoverListView alloc] initWithFrame:frame titleStr:showXDPopoverListViewType];
    listView.datasource = self;
    listView.delegate = self;
    [listView show];
}
#pragma arguments
#pragma mark -popoverListViewDelegate
-(CGFloat)popoverListView:(XDPopoverListView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)popoverListView:(XDPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showXDPopverCount;
}

- (UITableViewCell *)popoverListView:(XDPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString    *value=@"";
    if ([showXDPopoverListViewType isEqualToString:@"设备列表"]) {
     CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
     value = peripheral.name;
        
    }else{
        value=self.timeQuantumStatesArray[indexPath.row];
    }
    cell.textLabel.text =value;
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)popoverListView:(XDPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)popoverListView:(XDPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[Tools colorWithHexString:@"01bca8"]];
    
    self.measureStateQuantumString = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.measureTimeQuantumButton setTitle:self.timeQuantumStatesArray[indexPath.row] forState:UIControlStateNormal];
    [self.measureTimeQuantumButton setSelected:NO];
  
}

/**
 *	@brief	 点击去扫描设备事件
 */
- (IBAction)gotoScanEquipments:(UIButton *)sender {
    
    if (self.currPeripheral.state == CBPeripheralStateDisconnected) {
        
        if ([self.peripherals containsObject:self.currPeripheral]) {
            [self.peripherals removeObject:self.currPeripheral];
        }
        [self popSearchEquipmentView];
        baby.scanForPeripherals().begin();
        [self.measureResultButton setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
    }
    else if (self.currPeripheral.state == CBPeripheralStateConnected) {
      
    }
    else
    {
        if (_findEquipmentvc) {
            [_findEquipmentvc reloadTableView:self.peripherals.count];
            [self.view addSubview:_findEquipmentvc.view];
            
            [self.BSResultLabel setText:@""];
            [self.BSUnitLabel setHidden:YES];
            [self.BSPerialpheralStateResultLabel setText:@"请连接西恩血糖仪"];
        }
    }
}

/**
 *	@brief	 查看历史数据点击事件
 */
- (IBAction)gotoHistoricalData:(UIButton *)sender {
    
    if ( self.measureBtnState == BSMeasureBtnState_Save) {
        [self saveBSValue];
    }
    else if (self.measureBtnState == BSMeasureBtnState_CheckHistory)
    {
        HistoryBSVC *historyBSVC = [[HistoryBSVC alloc] initWithSecondStoryboardID:@"HistoryBSVC"];
        historyBSVC.isFromMeasureView = YES;
        [self.navigationController pushViewController:historyBSVC animated:YES];
    }
}
/**
 *	@brief	 向服务器保存血糖数据
 */
-(void)saveBSValue
{
    WeakObject(self)
    
    self.healthManager = [HealthManager shareHealthManager];
    
    double bloodGlucose = [__weakObject.BSResultLabel.text doubleValue];
    
    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
        if (isAuthorizateSuccess) {
            BloodDataModel *dataModel = [[BloodDataModel alloc] init];
            if([self.unitString isEqualToString:@"mmol/L"])
            {
                dataModel.BloodGlucose = bloodGlucose*18;
            }
            else
            {
                dataModel.BloodGlucose = bloodGlucose;
            }
            dataModel.date = [NSDate date];
            [self.healthManager saveBloodDataToHealthstoreWithData:dataModel];
        }
    }];
    
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    if([self.unitString isEqualToString:@"mg/dL"])
    {
        bloodGlucose = bloodGlucose/18.0;
    }
    
    [apis PostAddBloodGlucoseWithUserId:item.userId bloodGlucoseValue:[NSString stringWithFormat:@"%f",bloodGlucose] measureTime:self.timeString measureState:self.measureStateQuantumString equipmentNo:self.SNNumberString saveType:@"1" andCompletion:^(id objectRet, NSError *errorRes) {
        if (objectRet)
        {
            NSString *statusStr = [NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                self.measureBtnState = BSMeasureBtnState_CheckHistory;
                [__weakObject.measureResultButton setTitle:@"查看历史血糖" forState:UIControlStateNormal];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
            }
        }
        
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

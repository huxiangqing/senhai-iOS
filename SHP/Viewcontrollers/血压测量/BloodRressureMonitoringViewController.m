//
//  BloodRressureMonitoringViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "BloodRressureMonitoringViewController.h"
#import "CircleProgressView.h"
#import "BloodDataDeneralizationViewController.h"
#import "MainViewController.h"
#import "ZTypewriteEffectLabel.h"
#import "findEquipmentViewC.h"
#import "ManualBloodPressureViewController.h"

@interface BloodRressureMonitoringViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *bang;
    UIView *popView;
    UIImageView *tips;
    ZTypewriteEffectLabel *tipsLable;
    
    BOOL succeeBOOL;
}

@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet CircleProgressView *circleProgressView;
@property (weak, nonatomic) IBOutlet UIButton *measureBtn;
@property (weak, nonatomic) IBOutlet UILabel *BPUnitLabel;

@property (weak, nonatomic) IBOutlet UIButton *manualBtn;

@property (nonatomic) float   value;
@property (nonatomic, assign) int   index;
@property (nonatomic, assign) int lastThreeCount;
//收缩压 实际值
@property (nonatomic, assign) int   SPValue;
//舒张压 实际值
@property (nonatomic, assign) int DSPValue;
//心率 实际值
@property (nonatomic, assign) int HRValue;

@property (weak, nonatomic) IBOutlet UILabel *resultLable;

@property (nonatomic ,assign)BOOL DONE;

@property (nonatomic ,retain) NSTimer *timeT;

@property (nonatomic ,assign) BOOL manualStop;

@property (nonatomic ,strong) HealthManager *healthManager;


@property (strong ,nonatomic)__block findEquipmentViewC *findEquipmentvc;
@property (strong ,nonatomic)NSMutableArray *peripherals;
@property (strong ,nonatomic)NSMutableArray *peripheralsAD;

@property (nonatomic ,assign) BSMeasureBtnState measureBtnState;
@property (nonatomic, weak) UILabel *BPPerialpheralStateResultLabel;

@end

@implementation BloodRressureMonitoringViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [_lblTitleName setText:NSLocalizedString(@"Measurement", nil)];
    [_stopAndCkeckBtn setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    self.manualStop = NO;
    self.circleProgressView.progress = 0.00;
    //蓝牙模块
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    
    [self createTipsAnimate];
    
    [self.manualBtn setEnabled:NO];
    
    //初始化其他数据 init other
    self.peripherals = [[NSMutableArray alloc]init];
    self.peripheralsAD = [[NSMutableArray alloc]init];
    //初始化
    self.services = [[NSMutableArray alloc]init];
    
    //蓝牙模块
    readValueArray = [[NSMutableArray alloc]init];
    descriptors = [[NSMutableArray alloc]init];
    
    self.BPPerialpheralStateResultLabel = LabelInitZeroFrmAlignNum(2,NSTextAlignmentCenter, [UIFont systemFontOfSize:30], [UIColor whiteColor], self.view);
    [self.BPPerialpheralStateResultLabel setAdjustsFontSizeToFitWidth:YES];
    
    self.measureBtnState = BSMeasureBtnState_Normal;
    
    if (!baby) {
        //初始化BabyBluetooth 蓝牙库
        baby = [BabyBluetooth shareBabyBluetooth];
    }
    
    Tools *tool = [Tools shareTools];
    
    
    if (tool.currPeripheral && (tool.currPeripheral.state == CBPeripheralStateConnected)) {
        self.currPeripheral = tool.currPeripheral;
        self.readCharacteristic = tool.readCharacteristic;
        self.writeCharacteristic = tool.writeCharacteristic;
        self.SerialNo = tool.SerialNo;
        
        [self babyReadDelegate];
        
        [self.stopAndCkeckBtn setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
        
        self.index = 0;
        self.lastThreeCount = 0;
        //读取服务
        baby.channel(channelOnReadCharacteristicView).characteristicDetails(self.currPeripheral,self.readCharacteristic);
        [self setNotifiy:nil];
        
        [self performSelector:@selector(startWriteValue) withObject:nil afterDelay:5];
    }
    else
    {
        //设置蓝牙委托 自动连接失败的代理
        [self babyDelegate];
        [self babyReadDelegate];
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby.scanForPeripherals().begin();
        
        [self.stopAndCkeckBtn setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
        
        [self NoEquipments];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [MobClick beginLogPageView:@"血压测量页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"血压测量页"];
    if (self.readCharacteristic) {
        [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
   // [baby cancelAllPeripheralsConnection];
}
-(void)NoEquipments
{
    WeakObject(self);
    [self.manualBtn setEnabled:YES];
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
    
    _findEquipmentvc.view.frame=CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height - 64.0);
    _findEquipmentvc.peripherals = self.peripherals;
    _findEquipmentvc.selectedPeripheral = ^(CBPeripheral *peripheral){
        [__weakObject connectEquipment:peripheral];
    };
    
    if (_findEquipmentvc) {
        
        [self.resultLable setText:@""];
        [self.BPUnitLabel setHidden:YES];
        [self.BPPerialpheralStateResultLabel setText:@"请连接西恩血压仪"];
        
        [_findEquipmentvc reloadTableView:self.peripherals.count];
        [self.view addSubview:_findEquipmentvc.view];
    }
}
-(void)viewDidLayoutSubviews
{
    self.BPPerialpheralStateResultLabel.widthValue = self.measureBtn.widthValue- 70.0;
    self.BPPerialpheralStateResultLabel.heightValue = self.measureBtn.heightValue - 80.0;
    self.BPPerialpheralStateResultLabel.centerYValue = self.view.centerYValue - 50.0;
    self.BPPerialpheralStateResultLabel.centerXValue = self.view.centerXValue;
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
//蓝牙委托设置

-(void)babyReadDelegate{
    
    __weak typeof(self)weakSelf = self;
    
    [baby setBlockOnDisconnectAtChannel:channelOnReadCharacteristicView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        if ([weakSelf.peripherals containsObject:peripheral]) {
            [weakSelf.peripherals removeObject:peripheral];
        }
        [central cancelPeripheralConnection:peripheral];
        [weakSelf.measureBtn setEnabled:YES];
        
        [SVProgressHUD showErrorWithStatus:@"设备已经断开连接，请重新连接"];
        [weakSelf.resultLable setText:@""];
        [weakSelf.BPUnitLabel setHidden:YES];
        [weakSelf.BPPerialpheralStateResultLabel setText:@"请连接西恩血压仪"];
        
        [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:1];
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnReadCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
        [weakSelf insertReadValues:characteristics];
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnReadCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            [weakSelf insertDescriptor:d];
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnReadCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
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
        succeeBOOL = NO;
    }];
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        
        [weakSelf.manualBtn setEnabled:YES];
        
        if ([weakSelf.peripherals containsObject:peripheral]) {
            [weakSelf.peripherals removeObject:peripheral];
        }
        
        [central cancelPeripheralConnection:peripheral];

        [SVProgressHUD showErrorWithStatus:@"设备已经断开连接，请重新连接"];
        [weakSelf.resultLable setText:@""];
        [weakSelf.BPUnitLabel setHidden:YES];
        [weakSelf.BPPerialpheralStateResultLabel setText:@"请连接西恩血压仪"];
        
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
        NSString *name = [NSString stringWithFormat:@"%@",characteristics.UUID];
       
            if ([name isEqualToString:@"Serial Number String"]) {
                [weakSelf performSelector:@selector(dismiss:) withObject:nil afterDelay:0.2];
                NSArray *historyEquipmentArray = [[NTAccount shareAccount] BPEquipments];
                NSMutableArray *EquipmentArray = [[NSMutableArray alloc] initWithArray:historyEquipmentArray];
                if (![EquipmentArray containsObject:peripheral.identifier.UUIDString]) {
                    [EquipmentArray addObject:peripheral.identifier.UUIDString];
                }
                [[NTAccount shareAccount] setBPEquipments:EquipmentArray];
                
                [weakSelf saveEquipmentToServer:characteristics];
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
     
            if([peripheralName hasPrefix:@"D"])
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
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
//保存设备
-(void)saveEquipmentToServer:(CBCharacteristic *)SerialNoCharacteristic
{
        if (SerialNoCharacteristic) {
            NSString *SerialNo = [[NSString alloc] initWithData:SerialNoCharacteristic.value encoding:NSUTF8StringEncoding];
            self.SerialNo = SerialNo;
            
            succeeBOOL =YES;
            [self startWorking];
            
            
            [self.resultLable setText:@"-"];
            [self.BPUnitLabel setHidden:NO];
            [self.BPPerialpheralStateResultLabel setText:@""];

        }
 
}

-(void)startWorking
{
        //血压
        if (succeeBOOL == YES)
        {//成功
            CBCharacteristic *writeCBCharacteristic = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFF2"];
            self.writeCharacteristic = writeCBCharacteristic;
            CBCharacteristic *readCBCharacteristic = [BabyToy findCharacteristicFormServices:self.services UUIDString:@"FFF1"];
            self.readCharacteristic = readCBCharacteristic;
            
            if (self.writeCharacteristic && self.readCharacteristic) {
                
                Tools *tool = [Tools shareTools];
                tool.currPeripheral = self.currPeripheral;
                tool.writeCharacteristic = self.writeCharacteristic;
                tool.readCharacteristic = self.readCharacteristic;
                tool.SerialNo = self.SerialNo;
                
                self.index = 0;
                self.lastThreeCount = 0;
                //读取服务
                baby.channel(channelOnReadCharacteristicView).characteristicDetails(self.currPeripheral,self.readCharacteristic);
                [self setNotifiy:nil];
                
                [self performSelector:@selector(startWriteValue) withObject:nil afterDelay:5];
            }
        }
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
        [self.stopAndCkeckBtn setTitle:@"请耐心等待..." forState:UIControlStateNormal];
        [self.measureBtn.titleLabel sizeToFit];
    }
    else if (self.currPeripheral.state == CBPeripheralStateConnected) {
        
    }
    else
    {
        if (_findEquipmentvc) {
            [_findEquipmentvc reloadTableView:self.peripherals.count];
            [self.view addSubview:_findEquipmentvc.view];
            
            [self.resultLable setText:@""];
            [self.BPUnitLabel setHidden:YES];
            [self.BPPerialpheralStateResultLabel setText:@"请连接西恩血压仪"];
        }
    }
}


#pragma mark -UIViewController 方法
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
        
        [self.resultLable setText:@"-"];
        [self.BPUnitLabel setHidden:NO];
        [self.BPPerialpheralStateResultLabel setText:@""];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *historyEquipmentArray = [[NTAccount shareAccount] BPEquipments];
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
      
                if ([self.view.subviews containsObject:self.findEquipmentvc.view]) {
                    [self.findEquipmentvc.view removeFromSuperview];
                }
                [__weakObject popSearchEquipmentView];
                
            }
        });
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
// 专家头像动画
-(void)createTipsAnimate
{
    if (!bang) {
        bang =   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipsHeadImageNormal"]];
        [bang setUserInteractionEnabled:YES];
        [bang sizeToFit];
        [self.view addSubview:bang];
        
        bang.originValue = ccp(-bang.widthValue, self.view.heightValue - self.stopAndCkeckBtn.heightValue - 20.0 - bang.heightValue);
        [UIView transitionWithView:bang duration:1.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
            bang.originValue = ccp(10.0, self.view.heightValue - self.stopAndCkeckBtn.heightValue - 20.0 - bang.heightValue);
        } completion:^(BOOL finished) {
            //finished判断动画是否完成
            if (finished) {
                [self popViewAnimate];
            }
        }];
    }
}

// 文字出现动画
-(void)createPopView
{
    if (!tips) {
        tips = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPopImage"]];
        [tips setUserInteractionEnabled:YES];
        
        tipsLable = [[ZTypewriteEffectLabel alloc] initWithFrame:CGRectMake(20.0,10.0, self.view.widthValue - (bang.rightValue+50.0),0)];
        tipsLable.tag = 100;
        tipsLable.backgroundColor = [UIColor clearColor];
        tipsLable.numberOfLines = 0;
        tipsLable.text = NSLocalizedString(@"Blood pressure gauge is being measured", nil);
        tipsLable.textColor = [UIColor clearColor];
        tipsLable.font = [UIFont systemFontOfSize:16.0];
        tipsLable.typewriteEffectColor = [UIColor whiteColor];
        tipsLable.hasSound = YES;
        tipsLable.typewriteTimeInterval = 0.1;
        tipsLable.typewriteEffectBlock = ^{
        };
        [tipsLable sizeToFit];
        
        [self.view bringSubviewToFront:bang];
    }
    
    if (!popView) {
        popView = [[UIView alloc] initWithFrame:CGRectMake(bang.rightValue,bang.topValue, tipsLable.frame.size.width + 40.0,tipsLable.frame.size.height + 20.0)];
        [popView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:popView];
        
        [tips setFrame:CGRectMake(0,0, popView.widthValue,popView.heightValue)];
        popView.centerYValue = bang.centerYValue;
        [popView addSubview:tips];
        [popView addSubview:tipsLable];
    }
}

-(void)popViewAnimate
{
    [UIView transitionWithView:popView duration:1.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        [self createPopView];
    } completion:^(BOOL finished) {
        
    }];
    
    [self performSelector:@selector(startOutPut:) withObject:tipsLable afterDelay:0.7];
}

-(void)startOutPut:(ZTypewriteEffectLabel *)lable
{
    [lable startTypewrite];
}

//插入描述
-(void)insertDescriptor:(CBDescriptor *)descriptor{
    [self->descriptors addObject:descriptor];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:self->descriptors.count-1 inSection:2];
    [indexPahts addObject:indexPaht];
}
//插入读取的值测试中563测试结果为566
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    
    [self->readValueArray addObject:[NSString stringWithFormat:@"%@",characteristics.value]];
    NSString *valueString = [NSString stringWithFormat:@"%@",characteristics.value];
    //<ffff0a02 00760041 003d>
    NSString *hexstring = [[valueString substringWithRange:NSMakeRange(1, valueString.length - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (hexstring.length == 10)
    {
        if ([hexstring hasPrefix:@"ffff05"])
        {
            NSString *CMD = [hexstring substringWithRange:NSMakeRange(6, 2)];
            
            if ([CMD isEqualToString:@"05"]) {
               
            }
            else if([CMD isEqualToString:@"04"] && self.index > 5)
            {
                if (!self.manualStop) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"You have canceled the measurement", nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"I know", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                   {
                                                    
                                                           [self gotoMainView];
                                         
                                                   }];
                    [alertController addAction:otherAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
        
        self.index++;
    }
    else if(hexstring.length > 10)
    {
        if ([hexstring hasPrefix:@"ffff0a02"])
        {
            self.index++;
            if (self.index != 1) {
                self.circleProgressView.progress = [self resultVlueWithHexstringToIntValue:[NSString stringWithFormat:@"%@%@",[hexstring substringWithRange:NSMakeRange(12, 2)],[hexstring substringWithRange:NSMakeRange(10, 2)]]]/300.0;
                //心跳0或1
                // NSString *HB = [hexstring substringWithRange:NSMakeRange(8, 2)];
                self.resultLable.text = [NSString stringWithFormat:@"%d",[self resultVlueWithHexstringToIntValue:[NSString stringWithFormat:@"%@%@",[hexstring substringWithRange:NSMakeRange(12, 2)],[hexstring substringWithRange:NSMakeRange(10, 2)]]]];
            }
        }
        else if ([hexstring hasPrefix:@"ffff4903"] && self.index > 0)
         {
             self.lastThreeCount ++;
             //心率
             NSString *HR = [hexstring substringWithRange:NSMakeRange(8, 2)];
             self.HRValue =  [self resultVlueWithHexstringToIntValue:HR];
             //收缩压 低8位 (实际值-30)
             NSString *SP = [hexstring substringWithRange:NSMakeRange(10, 2)];
             self.SPValue = [self resultVlueWithHexstringToIntValue:SP]+30;
             //舒张压 (实际值-30）
             NSString *DSP = [hexstring substringWithRange:NSMakeRange(12, 2)];
             self.DSPValue = [self resultVlueWithHexstringToIntValue:DSP]+30;
             //self.circleProgressView.progress = self.SPValue/300.0;
             if (self.lastThreeCount%3 == 0) {
                 self.resultLable.text = [NSString stringWithFormat:@"%d/%d",self.SPValue,self.DSPValue];
                 [self showProgress];
                  [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
             }
         }
        else if ([hexstring hasPrefix:@"ffff0607"] && self.index > 0)
        {
            self.lastThreeCount ++;
            //ERR信息分类为 00(充不上气);01(测量中发生错误);02(血压计低电量)
            NSString *wrong = [hexstring substringWithRange:NSMakeRange(8, 2)];
            if (self.lastThreeCount%3 == 0) {
                if ([wrong isEqualToString:@"00"])
                {
                    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message: NSLocalizedString(@"Cannot be filled with gas", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I know", nil), nil];
                    alertView.tag = 100;
                    [alertView show];
                }
                else if ([wrong isEqualToString:@"01"])
                {
                    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message: NSLocalizedString(@"Error in measurement", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I know", nil), nil];
                    alertView.tag = 101;
                    [alertView show];
                }
                else if ([wrong isEqualToString:@"02"])
                {
                    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message: NSLocalizedString(@"Blood pressure meter low power", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I know", nil), nil];
                    alertView.tag = 102;
                    [alertView show];
                }
            }
        }
        else if ([hexstring hasPrefix:@"ffff0609"])
        {
            //机型
            NSString *systemInfo_JX = [hexstring substringWithRange:NSMakeRange(8, 2)];
            NSLog(@"设备信息机型%@",systemInfo_JX);
            //版本号
            NSString *systemInfo_VT = [hexstring substringWithRange:NSMakeRange(10, 2)];
            NSLog(@"设备信息版本号%@",systemInfo_VT);
        }
        else if ([hexstring hasPrefix:@"ffff0708"])
        {
            NSString *powerInfo = [hexstring substringWithRange:NSMakeRange(8, 2)];
            NSLog(@"电量信息\n%@",powerInfo);
        }
    }
}
//写一个值   开始测量
-(void)startWriteValue{
    
    [self.manualBtn setEnabled:NO];
    
    if (self.index < 5) {
        Byte byte[] = {0XFF,0XFF,0X05,0X01,0XFA};
        NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
        
        self.measureBtnState = BSMeasureBtnState_Save;
        [self.stopAndCkeckBtn setTitle:@"停止" forState:UIControlStateNormal];
        
        [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}
//写一个值   开始测量回馈正常
-(void)writeStartingFeedbackNormalValue{
    Byte byte[] = {0XFF,0XFF,0X05,0X02,0XF9};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
//写一个值   开始测量回馈异常
-(void)writeStartingFeedbackFailedValue{
    Byte byte[] = {0XFF,0XFF,0X05,0X03,0XF8};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
//写一个值   取消测量
-(void)writeCancelOperationValue{
    Byte byte[] = {0XFF,0XFF,0X05,0X04,0XF7};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
//写一个值   获取设备信息
-(void)writeSystemInformationValue{
    Byte byte[] = {0XFF,0XFF,0X05,0X05,0XF6};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}
//写一个值   获取电量信息
-(void)writePowerInformationValue{
    Byte byte[] = {0XFF,0XFF,0X05,0X06,0XF5};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [self.currPeripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

//订阅一个值
-(void)setNotifiy:(id)sender{
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Peripheral has been disconnected. Please reconnect", nil)];
        return;
    }
    if (self.readCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.readCharacteristic.properties & CBCharacteristicPropertyIndicate){
//        if(self.readCharacteristic.isNotifying){
//            [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
//        }else{
           // [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
            [baby notify:self.currPeripheral
          characteristic:self.readCharacteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       [weakSelf insertReadValues:characteristics];
                   }];
       // }
    }
    else{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"This characteristic does not have the rights to nofity", nil)];
        return;
    }
}

// 测量结果中显示进度，圆环的走势
- (void)showProgress
{
    WeakObject(self);
    
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    self.healthManager = [HealthManager shareHealthManager];
    
    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
        if (isAuthorizateSuccess) {
            BloodDataModel *dataModel = [[BloodDataModel alloc] init];
            dataModel.BloodPressureDiastolic = __weakObject.DSPValue;
            dataModel.BloodPressureSystolic = __weakObject.SPValue;
            dataModel.HeartRate = __weakObject.HRValue;
            dataModel.date = [NSDate date];
            [self.healthManager saveBloodDataToHealthstoreWithData:dataModel];
        }
    }];
    
     LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis SaveBloodPressureDataRequestWithUserId:item.userId equipmentNo:self.SerialNo bloodPressureOpen:[NSString stringWithFormat:@"%d",self.DSPValue] bloodPressureClose:[NSString stringWithFormat:@"%d",self.SPValue] pulse:[NSString stringWithFormat:@"%d",self.HRValue] measureTime:destDateString type:@"1" andCompletion:^(id objectRet, NSError *errorRes)
     {
         if(objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 __weakObject.DONE = YES;
                 [self.stopAndCkeckBtn setSelected:__weakObject.DONE];
                 [self.stopAndCkeckBtn setTitle:NSLocalizedString(@"Click to view", nil) forState:UIControlStateNormal];
                 
                 //                 [self writeCancelOperationValue];
                 //                 [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
                 //                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 //                     [baby cancelAllPeripheralsConnection];
                 //                 });
                 
                 
                 BloodDataDeneralizationViewController *data =[[BloodDataDeneralizationViewController alloc] initWithSecondStoryboardID:@"BloodDataDeneralizationViewController"];
                 Userinfo *item = [NTAccount shareAccount].userinfo;
                 data.userId = item.userId;
                 data.fromMainview = YES;
                 data.isReMeasure = YES;
                 [__weakObject.navigationController pushViewController:data animated:YES];
                 
             }
             else if ([statusStr isEqualToString:@"0"])
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 alertView.tag = 101;
                 [alertView show];
             }

         }
     
     }];
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [self gotoBack];
    }
    else if (alertView.tag == 101)
    {
        [self gotoBack];
    }
    else if (alertView.tag == 102)
    {
        [self gotoBack];
    }
    else
    {
        BloodDataDeneralizationViewController *data =[[BloodDataDeneralizationViewController alloc] initWithSecondStoryboardID:@"BloodDataDeneralizationViewController"];
        Userinfo *item = [NTAccount shareAccount].userinfo;
        data.userId = item.userId;
        data.fromMainview = YES;
        data.isReMeasure = YES;
        [self.navigationController pushViewController:data animated:YES];
    }
}

/**
 *	@brief	 点击返回按钮单击事件
 */
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    self.manualStop = YES;
    [self writeCancelOperationValue];
//    [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [baby cancelAllPeripheralsConnection];
//    });
    
    [self gotoBack];
   
}

-(void)gotoBack
{
    if (self.isFromMianView) {
        [self gotoMainView];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
 *	@brief 取消操作
 */
- (IBAction)StopMeasure:(UIButton *)sender {
    
    
    if ( self.measureBtnState == BSMeasureBtnState_Save) {
        self.manualStop = YES;
        [self writeCancelOperationValue];
        //    [baby cancelNotify:self.currPeripheral characteristic:self.readCharacteristic];
        //
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //         [baby cancelAllPeripheralsConnection];
        //    });
        
        if (self.DONE) {
            BloodDataDeneralizationViewController *data =[[BloodDataDeneralizationViewController alloc] initWithSecondStoryboardID:@"BloodDataDeneralizationViewController"];
            Userinfo *item = [NTAccount shareAccount].userinfo;
            data.userId = item.userId;
            data.fromMainview = YES;
            data.isReMeasure = YES;
            [self.navigationController pushViewController:data animated:YES];
        }
        else
        {
            [self gotoBack];
        }
    }
    
}

/**
 *	@brief 手动输入点击事件
 */
- (IBAction)mannueInputDataBtnSelected:(UIButton *)sender {
    if (baby) {
        [baby cancelScan];
        [baby cancelAllPeripheralsConnection];
    }
    ManualBloodPressureViewController *Start=[[ManualBloodPressureViewController alloc] initWithSecondStoryboardID:@"ManualBloodPressureViewController"];
    [self.navigationController pushViewController:Start animated:YES];
 
}


@end

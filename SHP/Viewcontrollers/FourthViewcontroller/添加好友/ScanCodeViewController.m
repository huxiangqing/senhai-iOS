//
//  ScanCodeViewController.m
//  LUDE
//
//  Created by JHR on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "AddFriendSucceessViewController.h"

@interface ScanCodeViewController()
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;

@end

@implementation ScanCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"Scan", nil)];
    self.navigationController.navigationBarHidden = YES;
    [self setScanView];
    _readerView= [[ZBarReaderView alloc]init];
    _readerView.tracksSymbols=NO;
    _readerView.readerDelegate =self;
    [_readerView addSubview:_scanView];
    //关闭闪光灯
    _readerView.torchMode =0;
    [self.view addSubview:_readerView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    [_readerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64.0,0,0,0));
    }];
    //扫描区域
    [_readerView start];
    [self createTimer];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_readerView.torchMode ==1) {
        _readerView.torchMode =0;
    }
    [self stopTimer];
    [_readerView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can bje recreated.
}


/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- ZBarReaderViewDelegate

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol * symbol in symbols)
    {
        if (symbol.type == ZBAR_QRCODE)
        {
            str = [NSString stringWithCString:[symbol.data UTF8String] encoding:NSUTF8StringEncoding];
        
            if (str.length==0)
            {
                return;
            }
            
            Userinfo *user = [NTAccount shareAccount].userinfo;
            LLNetApiBase *apis =[[LLNetApiBase alloc]init];
            [apis PostSaveVerificationMessageSweepAppUserId:user.userId friendsId:str andCompletion:^(id objectRet, NSError *errorRes)
             {
                 if (objectRet)
                 {
                     NSString *statusStr=[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                     if ([statusStr isEqualToString:@"1"])
                     {
                         
                         //扫描结果并且发送成功与失败跳转
                         AddFriendSucceessViewController *AddFriendSucceess = [[AddFriendSucceessViewController alloc] initWithStoryboardID:@"AddFriendSucceessViewController"];
                         AddFriendSucceess.msg = objectRet[@"msg"];
                         [self.navigationController pushViewController:AddFriendSucceess animated:YES];
                     }
                     else
                     {
                         //扫描结果并且发送成功与失败跳转
                         AddFriendSucceessViewController *AddFriendSucceess = [[AddFriendSucceessViewController alloc] initWithStoryboardID:@"AddFriendSucceessViewController"];
                         AddFriendSucceess.YesOrNoBOOL = YES;
                         AddFriendSucceess.msg = objectRet[@"msg"];
                         [self.navigationController pushViewController:AddFriendSucceess animated:YES];
                     }
                }
                
            }];
            
           
        }
        break;
    }
}
//二维码的扫描区域
- (void)setScanView
{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH,SCREENHEIGHT-64.0)];
    _scanView.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREENWIDTH,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,SCREENWIDTH-2*SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCREENWIDTH-2*SCANVIEW_EdgeLeft,SCREENWIDTH-2*SCANVIEW_EdgeLeft)];
    scanCropView.image=[UIImage imageNamed:@"qrcodeScan.png"];
    scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:scanCropView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,SCREENWIDTH-2*SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    //底部view
    UIView *downView = [[UIView alloc] init]; //WithFrame:CGRectMake(0,ApplicationWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,ApplicationWidth, ApplicationHeight-(ApplicationWidth-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop)-64)];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scanCropView.bottom).with.offset(@0.0);
        make.left.equalTo(_scanView.left);
        make.size.equalTo(CGSizeMake(SCREENWIDTH, SCREENHEIGHT-(SCREENWIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop)-64));
    }];
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,5, SCREENWIDTH,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:12.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"正在扫描";
    [downView addSubview:labIntroudction];
    //画中间的基准线
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft+4.0,SCANVIEW_EdgeTop,SCREENWIDTH-2*SCANVIEW_EdgeLeft - 8.0,2)];
    _QrCodeline.backgroundColor = [UIColor whiteColor];
    
    [_scanView addSubview:_QrCodeline];
}

- (void)openLight
{
    if (_readerView.torchMode ==0) {
        _readerView.torchMode =1;
    }else
    {
        _readerView.torchMode =0;
    }
}

//二维码的横线移动

- (void)moveUpAndDownLine
{
    CGFloat Y=_QrCodeline.frame.origin.y;
    
    if (SCREENWIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        
        [UIView beginAnimations:@"automic" context:nil];
        
        [UIView setAnimationDuration:1];
        
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft+4.0, SCANVIEW_EdgeTop,SCREENWIDTH-2*SCANVIEW_EdgeLeft - 8.0,1);
        
        [UIView commitAnimations];
        
    }else if(SCANVIEW_EdgeTop==Y){
        
        [UIView beginAnimations:@"automic" context:nil];
        
        [UIView setAnimationDuration:1];
        
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft+4.0, SCREENWIDTH-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,SCREENWIDTH-2*SCANVIEW_EdgeLeft - 8.0,1);
        
        [UIView commitAnimations];
    }
}


- (void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    if ([_timer isValid] == YES)
    {
        [_timer invalidate];
        _timer =nil;
    }
}

@end

//
//  MainViewController.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MainViewController.h"
#import "JPUSHService.h"
#import "MenuView.h"
#import "FristViewController.h"
#import "ThirdViewcontroller.h"
#import "FourthViewcontroller.h"
#import "PressureDataModel.h"
#import "EditInfoViewController.h"
#import "MessageCenterViewController.h"
#import "MyEquipmentViewController.h"
#import "MyQRCodeViewController.h"
#import "SetViewController.h"
#import "HistoryVC.h"

@interface MainViewController ()<UITabBarControllerDelegate>
{
    MenuView *menu;
}
@property (assign ,nonatomic)BOOL ShowOrHieBOOL;
@property (nonatomic ,strong)UIImageView *hasNewNoti;
@property (nonatomic ,strong)NSMutableArray *messageArray;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self createViewControllers];
    
    [self createTabBarItems];
    _sideSlipView = [[JKSideSlipView alloc] initWithSender:self.viewControllers[0]];
    
    menu = [MenuView menuView];
    
    if ([[NTAccount shareAccount] Messages])
    {
        self.messageArray = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
    }
    else
    {
        self.messageArray = [[NSMutableArray alloc] init];
    }
    [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
        if (Mess.integerValue != 2 )
        {
            menu.hasNew = YES;
        }
    }];
    
    WeakObject(self);
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath)
     {
         [_sideSlipView hide];
         if (indexPath.row == 0)
         {//个人中心
             EditInfoViewController *editInfo = [[EditInfoViewController alloc]initWithStoryboardID:@"EditInfoViewController"];
             [__weakObject.navigationController pushViewController:editInfo animated:YES];
         }
         else if (indexPath.row == 1)
         {//消息中心
             MessageCenterViewController *messageCenter =[[MessageCenterViewController alloc]initWithStoryboardID:@"MessageCenterViewController"];
             [__weakObject.navigationController pushViewController:messageCenter animated:YES];
             
         }
         else if (indexPath.row == 2)
         {//我的设备
             MyEquipmentViewController *myEquipment =[[MyEquipmentViewController alloc]initWithStoryboardID:@"MyEquipmentViewController"];
             [__weakObject.navigationController pushViewController:myEquipment animated:YES];
         }
         else if (indexPath.row == 3)
         {//二维码
             MyQRCodeViewController * myQRCode =[[MyQRCodeViewController alloc]initWithStoryboardID:@"MyQRCodeViewController"];
             Userinfo *user = [NTAccount shareAccount].userinfo;
             myQRCode.accountToken = user.userId;
             [__weakObject.navigationController pushViewController: myQRCode animated:YES];
         }
         else
         {//设置
             SetViewController *setView =[[SetViewController alloc]initWithStoryboardID:@"SetViewController"];
             [__weakObject.navigationController pushViewController:setView animated:YES];
         }
         
     }];
    menu.items = @[@{@"title": NSLocalizedString(@"My Profile", @"个人资料"),@"imagename":@"xin-gerenziliao"},@{@"title":NSLocalizedString(@"Message Center", @"消息中心"),@"imagename":@"xin-xiaoxinzhongxin"},@{@"title":NSLocalizedString(@"My Equipment", nil),@"imagename":@"xin-wodeshebei"},@{@"title":NSLocalizedString(@"My QR Code", nil),@"imagename":@"xin-erweima"},@{@"title":NSLocalizedString(@"Settings", nil),@"imagename":@"xin-shezhi"}];
    if (menu) {
       [_sideSlipView setContentView:menu]; 
    }
    [self.view addSubview:_sideSlipView];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
    
    //极光推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedApns:) name:@"apns" object:nil];
    
    //监听红点通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redOriginHidden:)
                                                 name:@"redOriginHidden"
                                               object:nil];
    //监听侧滑通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(JKSideSlipShow:)
                                                 name:@"JKSideSlipShow"
                                               object:nil];
    
    //监听侧滑展开与否是否通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StarBtnDefaultShow)
                                                 name:@"StarBtnDefaultShow"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StarBtnDefaultHide)
                                                 name:@"StarBtnDefaultHide"
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Userinfo *user = [NTAccount shareAccount].userinfo;
    [menu.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.userPic] placeholderImage:[UIImage imageNamed:@"xin-morentouxiang"]];
    menu.headerImageView.layer.masksToBounds = YES;
    menu.headerImageView.layer.cornerRadius = 33;
    [menu.nameLabel setText:user.realName];
    [menu.phoneNumLabel setText:user.phone];
}
-(void)StarBtnDefaultShow
{
    _ShowOrHieBOOL = YES;
}
-(void)StarBtnDefaultHide
{
    _ShowOrHieBOOL = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (_ShowOrHieBOOL==NO)
    {
        return YES;
    }
    else
    {
        [_sideSlipView hide];
        return NO;
    }
    
}
-(void)JKSideSlipShow:(NSNotification *)info
{
    [_sideSlipView show];
    
}
/**
 *  创建5个Item视图控制器
 */
-(void)createViewControllers
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FristViewController *homePageView = [storyboard instantiateViewControllerWithIdentifier:@"FristViewController"];
    HistoryVC *BiddingView = [storyboard instantiateViewControllerWithIdentifier:@"HistoryVC"];
    ThirdViewcontroller *NewGoodsView = [storyboard instantiateViewControllerWithIdentifier:@"ThirdViewcontroller"];
    FourthViewcontroller *CompanyView = [storyboard instantiateViewControllerWithIdentifier:@"FourthViewcontroller"];
    
    self.viewControllers = [NSArray arrayWithObjects:homePageView,BiddingView,NewGoodsView,CompanyView,nil];
    
}

/**
 *  设置Item选项
 */
-(void)createTabBarItems
{
    NSArray *selectAray = @[@"firstSelected.png",@"secondSelected.png",@"thridSelected.png",@"fourthSelected.png"];
    NSArray *unSelectArray = @[@"firstNormal.png",@"secondNormal.png",@"thridNormal.png",@"fourthNormal.png"];
    NSArray *titltArray = @[@"首页",@"历史数据",NSLocalizedString(@"Health-Info", nil),NSLocalizedString(@"Family", nil)];
    NSArray *allItems = self.tabBar.items;
    for (int i = 0; i<allItems.count; i++)
    {
        //设置每个item的属性
        UITabBarItem *item = allItems[i];
        UIImage *selectImage = [self loadImageName:selectAray[i]];
        UIImage *unSelectImage = [self loadImageName:unSelectArray[i]];
        item = [item initWithTitle:titltArray[i] image:unSelectImage selectedImage:selectImage];
        
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.tabBar.heightValue)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    
    //设置文字的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[Tools colorWithHexString:@"999999"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 121, 202)} forState:UIControlStateSelected];
}

//封装方法
-(UIImage *)loadImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",name]];
    //在ios7下需要对图片进行处理，否则会是阴影，不是远图像
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

//极光接收到数据时候调用的方法
-(void)DidReceiveMessage:(NSNotification *)info
{
    self.hasNewNoti.hidden = NO;
}
-(void)redOriginHidden:(NSNotification *)info
{
    self.hasNewNoti.hidden = YES;
}
-(void)didReceivedApns:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    NSString *str = [userInfo valueForKey:@"pushType"]; //推送显示的内容
    if (![str isEqualToString:@"2"])
    {
        self.hasNewNoti.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

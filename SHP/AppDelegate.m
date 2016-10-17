//
//  AppDelegate.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PressureDataModel.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#define SHARESDKAPPKEY @"17bd2b38f0200"
#define WXAPPID @"wxe5f0388ff5ae4602"
#define WXAPPSECRET @"d4624c36b6795d1d99dcf0547af5443d"
#define WBAPPID @"35451006"
#define WBAPPSECRET @"74d9dbaa39092daf37989  afb18e1ca8e"
#define UMAppKey @"5694771fe0f55a251b001d4f"

#define REDIRECTURL @"http://www.sharesdk.cn"
#import "NavRootViewController.h"
#import "FriendsDetailsViewController.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic ,strong) HealthManager *healthManager;

@end

static AppDelegate *_appDelegate;

@implementation AppDelegate

+ (AppDelegate *) app
{
    return _appDelegate;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _appDelegate = self;
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appModel      = @"Prod"/*产品模式*/;
    [HttpNetWorking cacheGetRequest:YES shoulCachePost:YES];
    [HttpNetWorking configCommonHttpHeaders:@{//应用端标示
                                              @"lord-app": @"IPhone",
                                              
                                              //版本号
                                              @"lord-app-v":bundleVersion,
                                              
                                              //产品渠道
                                              @"lord-app-c":@"AppStore:https://itunes.apple.com/us/app/xi-en-jian-kang-jia-ting-jian/id1052965802?l=zh&ls=1&mt=8",
                                              //设置是开发版还是产品版
                                              @"lord-app-m":appModel,
                                              //设置语言
                                              @"lord-app-language":[Tools currentLanguage]}];
    
    
    
    [HttpNetWorking updateBaseUrl:SERVER_DEMAIN];
    [HttpNetWorking enableInterfaceDebug:YES];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"isFirst"])
    {//第一次登陆
        GuideViewController *guideView = [[GuideViewController alloc] initWithStoryboardID:@"GuideViewController"];
        self.window.rootViewController = [[NavRootViewController alloc]initWithRootViewController:guideView];
    }
    else
    {//不是第一次登陆
        Userinfo *item = [NTAccount shareAccount].userinfo;
        
        if (item.userId) {
            MainViewController *MainView = [[MainViewController alloc] initWithStoryboardID:@"MainViewController"];
            self.window.rootViewController = [[NavRootViewController alloc]initWithRootViewController:MainView];
            
        }
        else
        {
            /**
             *	@brief	弹出登陆界面
             */
            LoginViewController *loginView = [[LoginViewController alloc] initWithStoryboardID:@"LoginViewController"];
            UINavigationController *loginNav = [[NavRootViewController alloc]initWithRootViewController:loginView];
            self.window.rootViewController = loginNav;
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"second" forKey:@"isFirst"];
 
    //ShareSDK
    [self registerShareSDK];
    //监听通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(obtainUserId:)
                                                 name:@"obtainUserId"
                                               object:nil];
    //JPush
    [self registerJPushWithOptions:launchOptions];
    //友盟
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    
    [self authorizateHealthKit];
    
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[FriendsDetailsViewController class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[FriendsDetailsViewController class]];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
   
    
     NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    return YES;
}

-(void)saveMessageContend:(NSDictionary *)userInfo
{
    NSString *pushType = [userInfo valueForKey:@"pushType"];
    
    if(pushType)
    {
        if (![pushType isEqualToString:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"apns" object:userInfo];
            NSMutableArray  *messages;
            if ([[NTAccount shareAccount] Messages]) {
                messages = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
            }
            else
            {
                messages = [[NSMutableArray alloc] init];
            }
            if(![messages containsObject:pushType])
            {
                [messages addObject:pushType];
            }
            
            [[NTAccount shareAccount] setMessages:messages];
        }
    }
}

-(void)authorizateHealthKit
{
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    
    if (![HealthManager isHealthDataAvailable]) {
        NSLog(@"\n%@\n",@"设备不支持healthKit");
    }
    
    self.healthManager = [HealthManager shareHealthManager];
    
    [self.healthManager authorizateHealthKit:^(BOOL isAuthorizateSuccess){
    
    }];

}

//为用户设置通知的tag值
-(void)obtainUserId:(NSNotification *)info
{
    NSDictionary *_dic = [info userInfo];
    [JPUSHService setTags:[NSSet setWithObject:@"sysMessage"] alias:[_dic objectForKey:@"userId"] callbackSelector:nil object:nil];
}

///apns
-(void)registerJPushWithOptions:(NSDictionary *)launchOptions
{
    // Required
    //可以添加自定义categories
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [self saveMessageContend:remoteNotification];
    }
    
}

//shareSDK
-(void)registerShareSDK
{
    [ShareSDK registerApp:SHARESDKAPPKEY
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:WBAPPID appSecret:WBAPPSECRET redirectUri:REDIRECTURL authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:WXAPPID
                                            appSecret:WXAPPSECRET];
                      break;
                  default:
                      break;
              }
          }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
     [self saveMessageContend:userInfo];
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        [self saveMessageContend:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
        [self saveMessageContend:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {

}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
     [self saveMessageContend:userInfo];
}
#endif
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
     [self saveMessageContend:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}



@end

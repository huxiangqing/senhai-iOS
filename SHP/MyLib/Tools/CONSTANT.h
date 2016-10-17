//
//  CONSTANT.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#ifndef IOS_CONSTANT_h
#define IOS_CONSTANT_h

/**
 *  Debug模式和Release模式不同的宏定义
 */

//-------------------打印--------------------
#ifdef DEBUG
#define NEED_OUTPUT_LOG             1
#else
#define NEED_OUTPUT_LOG             0
#endif

#if NEED_OUTPUT_LOG
#define DDLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLog(xx, ...)
#endif

#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
//Format
#define F(string, args...)                  [NSString stringWithFormat:string, args]
//-------------------本地化--------------------
//在所有显示在界面上的字符串进行本地化处理
#define _(x)                                NSLocalizedString(x,@"")

#define MAINSTORYBOARD @"MainStoryboard"
#define MutiValue (([[Tools deviceString] containsString:@"iPad"]) ?1.0:([UIScreen mainScreen].currentMode.size.width / 640.0))
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPad ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.f]
#define IOS_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define UUGreen        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
#define UUBlue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]

#define TOPSTATUSHEIGHT 20
#define KEYBOARDHEIGHT 216
#define TITLEKEYBOARDHEIGHT 245
#define KEYBOARDMAXHEIGHT 252
#define KEYBOARDMARGINHEIGHT 46
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define ccp(x,y) CGPointMake(x,y);

#define MAXSAVECOUNT 30

#define TIMESNEWROMAN @"Times New Roman"
#define TRBOLT @"Trebuchet-BoldItalic"
#define ARIALBOLD @"Arial-Bold"
#define HELVETICABOLD @"Helvetica-Bold"
#define HELVETICA @"Helvetica"

#define ALPHAMY @"ABCDEFGHIJKLMNOPQRSTUVWXYZ-"
#define ALLALPHA @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_#@."
#define NUMBERS @"0123456789"
#define SPECHARACTERS @"_#"

#define CODELENGTH 4

#define FONTSIZE8 8
#define FONTSIZE9 9
#define FONTSIZE10 10
#define FONTSIZE11 11
#define FONTSIZE12 12
#define FONTSIZE13 13
#define FONTSIZE14 14
#define FONTSIZE15 15
#define FONTSIZE16 16
#define FONTSIZE17 17
#define FONTSIZE18 18
#define FONTSIZE19 19
#define FONTSIZE20 20
#define FONTSIZE21 21
#define FONTSIZE22 22
#define FONTSIZE23 23
#define FONTSIZE24 24
#define FONTSIZE25 25
#define FONTSIZE26 26
#define FONTSIZE27 27
#define FONTSIZE28 28

#define WeakObject(object)  __weak typeof(object) __weakObject = object;

#define ISRETAIN  ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640,960),[[UIScreen mainScreen]currentMode].size):NO)
#define ACTIONTIME 0.3f

#define ACTIONTIME020 0.20f


#define TIMEOUT NSLocalizedString(@"Connection Timeout", nil)
#define CONNECTERROR NSLocalizedString(@"Connection Error", nil)
#define SUCCESSFUL NSLocalizedString(@"Successful Operation", nil)
#define INVALIDPHONENUMBER NSLocalizedString(@"The phone number is not in conformity with the specification", nil)
#define CONNECTSUCCUSS @"success"
#define CONNECTTIMEOUTKEY @"connect.timeout"
#define CONNECTERRORKEY @"connect.error"
#define CONNECTNULLKEY @"connect.null"
//错误提示  //  NSLocalizedString(@"", nil)
#define USER_NAME_EXIST_STR  NSLocalizedString(@"User already exists", nil)
#define LOGIN_ERROR_STR   NSLocalizedString(@"User name or password wrong", nil)
#define VERIFICATION_CODE_SEND_OUT_OF_TIMES_STR NSLocalizedString(@"Verification code sent timeout", nil)
#define VERIFICATION_CODE_USED_STR              NSLocalizedString(@"Verification code has been used", nil)
#define VERIFICATION_CODE_TIMEOUT_STR           NSLocalizedString(@"Verification code has expired", nil)
#define INVALID_VERIFICATION_CODE_STR           NSLocalizedString(@"Illegal verification code", nil)
#define VERIFICATION_CODE_SEND_FAST_STR         NSLocalizedString(@"Verification code sent too fast", nil)
#define AVATAR_IS_EMPTY_STR                     NSLocalizedString(@"Upload avatar to empty", nil)
#define PASSWORD_SAME_STR                       NSLocalizedString(@"The new password must be different from the old one", nil)
#define OLD_PASSWORD_WRONG_STR                  NSLocalizedString(@"The old password is incorrect", nil)
#define PHONE_IS_EMPTY_STR                      NSLocalizedString(@"Enter the phone number is empty", nil)
#define INVALID_PHONE_STR                       NSLocalizedString(@"The phone number is incorrect. Please re-enter it", nil)
#define PHONE_IS_ALERADY_EXIST_STR              NSLocalizedString(@"Cell phone number already exists", nil)
#define PHONE_IS_ALREADY_BINDING_STR            NSLocalizedString(@"Mobile phone number has been bound", nil)
#define NOT_BINDING_PHONE_STR                   NSLocalizedString(@"Not bound phone number", nil)
#define PHONE_NOT_SAME_STR                      NSLocalizedString(@"Wrong cell phone number", nil)


//typedef enum{
//    //全局资源文件配置
//  }ErrorCode;
//
typedef enum
{
    oneWeek = 1,
    twoWeek,
    threeWeek,
    fourWeek,
}weekScreen;

typedef enum{
    ImageType_NONE,
    ImageType_HD,
    ImageType_MD,
    ImageType_ND,
}ImageType;

typedef enum MessageStyle{
    FriendsM,
    LeaveM,
    SystemM,
}MessageType;

#define channelOnCharacteristicView @"WriteCharacteristicView"
#define channelOnReadCharacteristicView @"ReadCharacteristicView"

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//持久化
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#import "LLNetApiBase.h"
#import "AJServerApis.h"

#endif



//
//  NTAccount.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//
//用户基本信息
#define USERBASICINFO @"USERBASICINFO"
//是否是登陆过
#define EVERLOGIN @"EVERLOGIN"

@interface NTAccount : NSObject

@property(nonatomic, retain) NSString *baseLocalPath;
@property (nonatomic, strong)Userinfo  *userinfo;

+ (instancetype) shareAccount;

-(void)setHealthSteps:(NSString *)healthSteps;
-(NSString *)healthSteps;

-(void)setMessages:(NSArray *)Messages;
-(NSArray *)Messages;

-(void)setBPEquipments:(NSArray *)BPEquipments;
-(NSArray *)BPEquipments;

-(void)setBSEquipments:(NSArray *)BSEquipments;
-(NSArray *)BSEquipments;

-(void)setScreenType:(NSString *)ScreenType;
-(NSString *)ScreenType;

-(void)setFirstGuide:(NSString *)FirstGuide;
-(NSString *)FirstGuide;

-(void)setUserinfo:(Userinfo *)userinfo;
-(Userinfo *)userinfo;

-(void)exitLogin;


-(void)setBSStartDateString:(NSString *)userinfo;
-(NSString *)BSStartDateString;

-(void)setBSEndDateString:(NSString *)userinfo;
-(NSString *)BSEndDateString;

@end

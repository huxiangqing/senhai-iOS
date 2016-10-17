//
//  NTAccount.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "NTAccount.h"

static NTAccount *_share_account = nil;

@implementation NTAccount

+ (instancetype)shareAccount{
    if (_share_account == nil) {
        _share_account = [[NTAccount alloc] init];
    }
    return _share_account;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _baseLocalPath = paths[0];
    }
    return self;
}

-(void)setHealthSteps:(NSString *)healthSteps{
    if ([healthSteps isKindOfClass:[NSString class]] && healthSteps != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:healthSteps forKey:@"healthSteps"];
        [defaults synchronize];
    }
}
-(NSString *)healthSteps{
    NSString *healthSteps = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    healthSteps = [defaults objectForKey:@"healthSteps"];
    
    return healthSteps;
}


-(void)setFirstGuide:(NSString *)FirstGuide
{
    if ([FirstGuide isKindOfClass:[NSString class]] && FirstGuide != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:FirstGuide forKey:@"FirstGuide"];
        [defaults synchronize];
    }
}
-(NSString *)FirstGuide
{
    NSString *FirstGuide = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    FirstGuide = [defaults objectForKey:@"FirstGuide"];
    
    return FirstGuide;
}

-(void)setMessages:(NSArray *)Messages
{
    if ([Messages isKindOfClass:[NSArray class]] && Messages != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:Messages];
        [defaults setObject:data forKey:@"Messages"];
        [defaults synchronize];
    }
}
-(NSArray *)Messages
{
    NSArray *Messages = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"Messages"];
    if (data)
    {
        Messages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return Messages;
}

-(void)setBPEquipments:(NSArray *)BPEquipments
{
    if ([BPEquipments isKindOfClass:[NSArray class]] && BPEquipments != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:BPEquipments];
        [defaults setObject:data forKey:@"BPEquipments"];
        [defaults synchronize];
    }
}
-(NSArray *)BPEquipments
{
    NSArray *BPEquipments = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"BPEquipments"];
    if (data)
    {
        BPEquipments = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return BPEquipments;
}
-(void)setBSEquipments:(NSArray *)BSEquipments
{
    if ([BSEquipments isKindOfClass:[NSArray class]] && BSEquipments != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:BSEquipments];
        [defaults setObject:data forKey:@"BSEquipments"];
        [defaults synchronize];
    }
}
-(NSArray *)BSEquipments
{
    NSArray *BSEquipments = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"BSEquipments"];
    if (data)
    {
        BSEquipments = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return BSEquipments;
}

-(void)setScreenType:(NSString *)ScreenType
{
    if ([ScreenType isKindOfClass:[NSString class]] && ScreenType != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ScreenType forKey:@"ScreenType"];
        [defaults synchronize];
    }
}
-(NSString *)ScreenType
{
    NSString *ScreenType = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ScreenType = [defaults objectForKey:@"ScreenType"];
    return ScreenType;
}

-(void)setUserinfo:(Userinfo *)userinfo
{
    if ([userinfo isKindOfClass:[Userinfo class]] && userinfo != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[userinfo keyValues]];
        [defaults setObject:data forKey:USERBASICINFO];
        [defaults synchronize];
    }
}

-(Userinfo *)userinfo
{
    NSDictionary *mdictionary = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:USERBASICINFO];
    if (data)
    {
        mdictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    Userinfo *item = [Userinfo objectWithKeyValues:mdictionary];
    
    return item;
}

-(void)exitLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USERBASICINFO];
    
    [defaults synchronize];
}


-(void)setBSStartDateString:(NSString *)startDateString
{
    if ([startDateString isKindOfClass:[NSString class]] && startDateString != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:startDateString forKey:@"startDateString"];
        [defaults synchronize];
    }
}
-(NSString *)BSStartDateString
{
    NSString *startDateString = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    startDateString = [defaults objectForKey:@"startDateString"];
    return startDateString;
}

-(void)setBSEndDateString:(NSString *)endDateString
{
    if ([endDateString isKindOfClass:[NSString class]] && endDateString != nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:endDateString forKey:@"endDateString"];
        [defaults synchronize];
    }
}
-(NSString *)BSEndDateString
{
    NSString *endDateString = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    endDateString = [defaults objectForKey:@"endDateString"];
    return endDateString;
}

@end


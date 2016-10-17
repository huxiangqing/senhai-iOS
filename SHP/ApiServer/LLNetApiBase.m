//
//  ViewController.h
//  phoneDrugSieve
//
//  Created by bluemobi on 15/4/28.
//  Copyright (c) 2015年 liuhengyu. All rights reserved.
//


#import "LLNetApiBase.h"
#import "AFHTTPSessionManager.h"
#define MAX_TIME_LIMIT 20
 

//static NSTimeInterval  lastRequestFailureTime,currentTime;

@implementation LLNetApiBase

-(void)cleanUserStore
{
 
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];

    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}
//校验验证码是否过期(2015-10-15  何小慧)///app/messageVerificationCode/checkVerificationCode.htm
-(void)POSTCheckVerificationCodeTelephone:(NSString *)telephone verificationCode:(NSString *)verificationCode sendTime:(NSString *)sendTime andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/messageVerificationCode/checkVerificationCode.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"telephone":telephone,@"verificationCode":verificationCode,@"sendTime":sendTime};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//注册(2015-10-15  何小慧) / app/userInfo/userInfoRegister.htm
-(void)PostUserInfoRegisterUserName:(NSString *)userName phone:(NSString *)phone userType:(NSString *)userType realName:(NSString *)realName sex:(NSString *)sex birthday:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight weiChatOrWeiBO:(NSString *)weiChatOrWeiBO info:(NSDictionary *)info andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/userInfoRegister.htm",SERVER_DEMAIN];
    NSDictionary *param ;
    
    if ([weiChatOrWeiBO isEqualToString:@"weibo"]) {
        param = @{@"sinaBlogId":userName,@"phone":phone,@"userType":userType,@"realName":realName,@"sex":sex,@"birthday":birthday,@"height":height,@"weight":weight};
    }
    else if ([weiChatOrWeiBO isEqualToString:@"weiChat"])
    {
        if (info) {
            
            NSMutableDictionary *weChatInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
            
            [weChatInfo setValue:userName forKey:@"weChatUnionId"];
            [weChatInfo setValue:@"5" forKey:@"registration_type"];
            [weChatInfo setValue:phone forKey:@"phone"];
            [weChatInfo setValue:userType forKey:@"userType"];
            [weChatInfo setValue:realName forKey:@"realName"];
            [weChatInfo setValue:sex forKey:@"sex"];
            [weChatInfo setValue:birthday forKey:@"birthday"];
            [weChatInfo setValue:height forKey:@"height"];
            [weChatInfo setValue:weight forKey:@"weight"];
            
            param = [NSDictionary dictionaryWithDictionary:weChatInfo];
        }
    }
    else
    {
        param = @{@"phone":phone,@"userType":userType,@"realName":realName,@"sex":sex,@"birthday":birthday,@"height":height,@"weight":weight};
    }
    
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}


//登录(2015-10-15  何小慧)
-(void)PostSignWithPhoneNum:(NSString *)phone andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/userInfoLogin.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"phone":phone};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//发布提醒设置(2015-10-16   何小慧) app/remindInfo/addRemindInfo.htm
-(void)PostaddRemindHour:(NSString *)remindHour remindMinute:(NSString *)remindMinute remindType:(NSString *)remindType state:(NSString *)state userId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/remindInfo/addRemindInfo.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"userId":userId,@"remindHour":remindHour,@"remindMinute":remindMinute,@"remindType":remindType,@"state":state};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//修改提醒设置(2015-10-16   何小慧) app/remindInfo/ updateRemindInfo.htm
-(void)PostUpdateRemindInfoId:(NSString *)Id remindHour:(NSString *)remindHour remindMinute:(NSString *)remindMinute remindType:(NSString *)remindType state:(NSString *)state userId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/remindInfo/updateRemindInfo.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"id":Id,@"remindHour":remindHour,@"remindMinute":remindMinute,@"remindType":remindType,@"state":state,@"userId":userId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
  }

//设置提醒状态(2015-10-16   何小慧) app/remindInfo/updateRemindInfoState.htm
-(void)PostupdateRemindInfoStateId:(NSString *)Id state:(NSString *)state andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/remindInfo/updateRemindInfoState.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"id":Id,@"state":state};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//上传图片接口 （2015-10-16  何小慧）app/uploadFile/uploadSWFImage.htm
-(void)PostuploadSWFImage:(UIImage *)image andCompletion:(LLDPResponseBlock)completion progress:(APIUploadProgress)uploadProgressBlock
{
    NSString *urls = [NSString stringWithFormat:@"%@app/uploadFile/uploadSWFImage.htm",SERVER_DEMAIN];
    [HttpNetWorking uploadWithImage:image url:urls filename:@"0.png" name:@"files['0'].file" mimeType:@"image/png" parameters:nil progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        uploadProgressBlock(bytesRead,totalBytesRead);
    } success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);}];
}

//修改用户资料 （2015-10-16  何小慧）app/userInfo/updateUserInfo.htm
-(void)PostupdateUserInfoUserId:(NSString *)userId realName:(NSString *)realName userPic:(NSString *)userPic sex:(NSString *)sex age:(NSString *)age birthday:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/updateUserInfo.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"userId":userId,@"userPic":userPic,@"realName":realName,@"sex":sex,@"birthday":birthday,@"height":height,@"weight":weight,@"age":age};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}
//推送 （2015-10-16  何小慧）app/userInfo/updateUserInfo.htm
-(void)PostUpdateUserInfoPishUserId:(NSString *)userId isPush:(NSString *)isPush andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/updateUserInfo.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"isPush":isPush,@"userId":userId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//退出登录 （2015-10-16  何小慧）app/userInfo/userInfoLogout.htm
-(void)PostUserInfoLogoutUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/userInfoLogout.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"userId":userId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//发送好友验证（郭乐）  app/verificationMessage/saveVerificationMessageApp.htm
-(void)PostSaveVerificationMessageAppUserId:(NSString *)userId friendsId:(NSString *)friendsId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/verificationMessage/saveVerificationMessageApp.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"friendsId":friendsId,@"userId":userId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//同意添加好友（郭乐）app/verificationMessage/saveVerificationMessageAgreeApp.htm
-(void)PostSaveVerificationMessageAgreeAppMessageId:(NSString *)messageId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/verificationMessage/saveVerificationMessageAgreeApp.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"messageId":messageId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}


//扫一扫加好友（郭乐）app/verificationMessage/saveVerificationMessageSweepApp.htm
-(void)PostSaveVerificationMessageSweepAppUserId:(NSString *)userId friendsId:(NSString *)friendsId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/verificationMessage/saveVerificationMessageSweepApp.htm",SERVER_DEMAIN];
    NSDictionary *param = @{@"friendsId":friendsId,@"userId":userId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:param success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//血压测量数据存储数据（郭乐） app/bloodPressure/saveBloodPressureApp.htm
-(void)SaveBloodPressureDataRequestWithUserId:(NSString *)userId  equipmentNo:(NSString *)equipmentNo bloodPressureOpen:(NSString *)bloodPressureOpen  bloodPressureClose:(NSString *)bloodPressureClose  pulse:(NSString *)pulse measureTime:(NSString *)measureTime type:(NSString *)type andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/bloodPressure/saveBloodPressureApp.htm",SERVER_DEMAIN];
    NSDictionary *paramDic;
    
    if ([type isEqualToString:@"2"])
    {
        paramDic = @{@"userId":userId,@"bloodPressureOpen":bloodPressureOpen,@"bloodPressureClose":bloodPressureClose,@"pulse":pulse,@"measureTime":measureTime,@"type":type};
    }
    else
    {
        paramDic = @{@"userId":userId, @"equipmentNo":equipmentNo,@"bloodPressureOpen":bloodPressureOpen,@"bloodPressureClose":bloodPressureClose,@"pulse":pulse,@"type":type};
    }
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:paramDic success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//第三方登录(2015-10-15  何小慧) app/userInfo/thirdPartyLogin
-(void)LoginWithWeiXinAndWeiBoRequestWithUserId:(NSString *)userName info:(NSDictionary *)info  andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/userInfo/thirdPartyLogin.htm",SERVER_DEMAIN];
    
    NSDictionary *paramDic;
    
    if (info) {
        NSMutableDictionary *weChatInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
        
        [weChatInfo setValue:userName forKey:@"weChatUnionId"];
        paramDic = [NSDictionary dictionaryWithDictionary:weChatInfo];
    }
    else
    {
        NSMutableDictionary *weChatInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
        
        [weChatInfo setValue:userName forKey:@"sinaBlogId"];
        paramDic = [NSDictionary dictionaryWithDictionary:weChatInfo];
    }
    
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:paramDic success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

//好友留言（郭乐）app/friendsMessage/saveFriendsMessageApp.htm
-(void)PostSaveFriendsMessageAppUserId:(NSString *)userId messageContent:(NSString *)messageContent myFriendsId:(NSString *)myFriendsId andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/friendsMessage/saveFriendsMessageApp.htm",SERVER_DEMAIN];
    
    NSDictionary * paramDic = @{@"userId":userId,@"messageContent":messageContent,@"myFriendsId":myFriendsId};
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:paramDic success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}


//风险预测 （2016-4-19  罗丹）app/riskEval/insertRiskEvalUserInfo.htm
-(void)PostRiskAssessmentWithInfo:(RiskFillInfoDataModel *)fillInfoDataModel andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/riskEval/insertRiskEvalUserInfo.htm",SERVER_DEMAIN];
    
    NSDictionary * paramDic = fillInfoDataModel.keyValues;
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:paramDic success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

#pragma mark - 血糖接口

//新增血糖记录接口   app/bloodGlucose/saveBloodGlucoseApp.htm
-(void)PostAddBloodGlucoseWithUserId:(NSString *)userId bloodGlucoseValue:(NSString *)bloodGlucoseValue measureTime:(NSString *)measureTime measureState:(NSString *)measureState equipmentNo:(NSString *)equipmentNo saveType:(NSString *)saveType andCompletion:(LLDPResponseBlock)completion
{
    NSString *urls = [NSString stringWithFormat:@"%@app/bloodGlucose/saveBloodGlucoseApp.htm",SERVER_DEMAIN];
    
    NSDictionary * paramDic = @{@"userId":userId,@"bloodGlucoseValue":bloodGlucoseValue,@"measureTime":measureTime,@"state":measureState,@"saveType":saveType,@"equipmentNo":equipmentNo};
    
    [HttpNetWorking postWithUrl:urls refreshCache:YES params:paramDic success:^(id response)
     {
         completion(response,nil);
     }fail:^(NSError *error)
     {
         completion(nil,error);
     }];
}

@end

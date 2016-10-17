//
//  ViewController.h
//  phoneDrugSieve
//
//  Created by bluemobi on 15/4/28.
//  Copyright (c) 2015年 liuhengyu. All rights reserved.
//
/**
 *	@brief	自定义网络请求
 */
#import <Foundation/Foundation.h>
#import "LLNetApiBaseDefines.h"


@interface LLNetApiBase : NSObject

//校验验证码是否过期(2015-10-15  何小慧)///app/messageVerificationCode/checkVerificationCode.htm
-(void)POSTCheckVerificationCodeTelephone:(NSString *)telephone verificationCode:(NSString *)verificationCode sendTime:(NSString *)sendTime andCompletion:(LLDPResponseBlock)completion;

//注册(2015-10-15  何小慧) / app/userInfo/userInfoRegister.htm
-(void)PostUserInfoRegisterUserName:(NSString *)userName phone:(NSString *)phone userType:(NSString *)userType realName:(NSString *)realName sex:(NSString *)sex birthday:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight weiChatOrWeiBO:(NSString *)weiChatOrWeiBO info:(NSDictionary *)info andCompletion:(LLDPResponseBlock)completion;

//登录(2015-10-15  何小慧)  app/userInfo/userInfoLogin.htm
-(void)PostSignWithPhoneNum:(NSString *)phone andCompletion:(LLDPResponseBlock)completion;

//发布提醒设置(2015-10-16   何小慧) app/remindInfo/addRemindInfo.htm
-(void)PostaddRemindHour:(NSString *)remindHour remindMinute:(NSString *)remindMinute remindType:(NSString *)remindType state:(NSString *)state userId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;

//修改提醒设置(2015-10-16   何小慧) app/remindInfo/ updateRemindInfo.htm
-(void)PostUpdateRemindInfoId:(NSString *)Id remindHour:(NSString *)remindHour remindMinute:(NSString *)remindMinute remindType:(NSString *)remindType state:(NSString *)state userId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;

//设置提醒状态(2015-10-16   何小慧) app/remindInfo/updateRemindInfoState.htm
-(void)PostupdateRemindInfoStateId:(NSString *)Id state:(NSString *)state andCompletion:(LLDPResponseBlock)completion;

//上传图片接口 （2015-10-16  何小慧）app/uploadFile/uploadSWFImage.htm
-(void)PostuploadSWFImage:(UIImage *)image andCompletion:(LLDPResponseBlock)completion progress:(APIUploadProgress)uploadProgressBlock;

//修改用户资料 （2015-10-16  何小慧）app/userInfo/updateUserInfo.htm
-(void)PostupdateUserInfoUserId:(NSString *)userId realName:(NSString *)realName userPic:(NSString *)userPic sex:(NSString *)sex age:(NSString *)age birthday:(NSString *)birthday height:(NSString *)height weight:(NSString *)weight andCompletion:(LLDPResponseBlock)completion;

//退出登录 （2015-10-16  何小慧）app/userInfo/userInfoLogout.htm
-(void)PostUserInfoLogoutUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;

//发送好友验证（郭乐）app/verificationMessage/saveVerificationMessageApp.htm
-(void)PostSaveVerificationMessageAppUserId:(NSString *)userId friendsId:(NSString *)friendsId andCompletion:(LLDPResponseBlock)completion;

//同意添加好友（郭乐）app/verificationMessage/saveVerificationMessageAgreeApp.htm
-(void)PostSaveVerificationMessageAgreeAppMessageId:(NSString *)messageId andCompletion:(LLDPResponseBlock)completion;

//扫一扫加好友（郭乐）app/verificationMessage/saveVerificationMessageSweepApp.htm
-(void)PostSaveVerificationMessageSweepAppUserId:(NSString *)userId friendsId:(NSString *)friendsId andCompletion:(LLDPResponseBlock)completion;

//血压测量数据存储数据（郭乐） app/bloodPressure/saveBloodPressureApp.htm
-(void)SaveBloodPressureDataRequestWithUserId:(NSString *)userId  equipmentNo:(NSString *)equipmentNo bloodPressureOpen:(NSString *)bloodPressureOpen  bloodPressureClose:(NSString *)bloodPressureClose  pulse:(NSString *)pulse measureTime:(NSString *)measureTime type:(NSString *)type andCompletion:(LLDPResponseBlock)completion;

//第三方登录(2015-10-15  何小慧) app/userInfo/thirdPartyLogin
-(void)LoginWithWeiXinAndWeiBoRequestWithUserId:(NSString *)userName info:(NSDictionary *)info andCompletion:(LLDPResponseBlock)completion;

//好友留言（郭乐）app/friendsMessage/saveFriendsMessageApp.htm
-(void)PostSaveFriendsMessageAppUserId:(NSString *)userId messageContent:(NSString *)messageContent myFriendsId:(NSString *)myFriendsId andCompletion:(LLDPResponseBlock)completion;

//推送 （2015-10-16  何小慧）app/userInfo/updateUserInfo.htm
-(void)PostUpdateUserInfoPishUserId:(NSString *)userId isPush:(NSString *)isPush andCompletion:(LLDPResponseBlock)completion;

//风险预测 （2016-4-19  罗丹）app/riskEval/insertRiskEvalUserInfo.htm
-(void)PostRiskAssessmentWithInfo:(RiskFillInfoDataModel *)fillInfoDataModel andCompletion:(LLDPResponseBlock)completion;

#pragma mark - 血糖接口

//新增血糖记录接口   app/bloodGlucose/saveBloodGlucoseApp.htm
-(void)PostAddBloodGlucoseWithUserId:(NSString *)userId bloodGlucoseValue:(NSString *)bloodGlucoseValue measureTime:(NSString *)measureTime measureState:(NSString *)measureState equipmentNo:(NSString *)equipmentNo saveType:(NSString *)saveType andCompletion:(LLDPResponseBlock)completion;

@end


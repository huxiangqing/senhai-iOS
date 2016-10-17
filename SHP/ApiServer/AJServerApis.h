//
//  ViewController.h
//  phoneDrugSieve
//
//  Created by bluemobi on 15/4/28.
//  Copyright (c) 2015年 liuhengyu. All rights reserved.
//
/**
 *	@brief	自定义接口类
 */
#import "LLNetApiBase.h"

@interface AJServerApis : NSObject

//发送短信验证码(2015-10-15  何小慧)  /app/messageVerificationCode/sendMessage.htm
-(void)GetSendMessagePhoneNum:(NSString *)phone type:(NSString *)type Completion:(LLDPResponseBlock)completion;

//banner图列表(2015-10-15   何小慧) app/bannerInfo/getBannerInfoList.htm
-(void)GetBannerInfoListCompletion:(LLDPResponseBlock)completion;

//提醒设置列表(2015-10-15   何小慧)   app/remindInfo/getRemindInfoByList.htm
-(void)GetRemindInfoPageNo:(NSString *)pageNo pageSize:(NSString *)pageSize userId:(NSString *)userId remindType:(NSString *)remindType Completion:(LLDPResponseBlock)completion;

//提醒设置详细(2015-10-15   何小慧)   app/remindInfo/getRemindInfoById.htm
-(void)GetgetRemindInfoById:(NSString *)Id Completion:(LLDPResponseBlock)completion;

//删除提醒设置(2015-10-16   何小慧)   app/remindInfo/deleteRemindInfoById.htm
-(void)GetdeleteRemindInfoById:(NSString *)Id Completion:(LLDPResponseBlock)completion;

//用户详情 （2015-10-22  何小慧）app/userInfo/getUserInfoById.htm
-(void)GetUserInfoByUserId:(NSString *)userId Completion:(LLDPResponseBlock)completion;

//根据用户手机号搜索好友 （2015-10-22  何小慧）app/userInfo/getUserInfoByPhone.htm
-(void)getUserInfoByPhone:(NSString *)phone userId:(NSString *)userId  Completion:(LLDPResponseBlock)completion;

//专家建议列表 （2015-10-16  何小慧）app/articleInfo/getArticleInfoByList.htm
-(void)GetArticleInfoByListPageNo:(NSString *)pageNo pageSize:(NSString *)pageSize type:(NSString *)type andCompletion:(LLDPResponseBlock)completion;

//系统消息列表 （2015-10-22  何小慧）app/sysMessage/getSysMessageByList.htm
-(void)GetSysMessageByListPageNo:(NSString *)pageNo userId:(NSString *)userId pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//我的设备列表（郭乐）app/userEquipment/getUserEquipmentForPageApp.htm
-(void)GetUserEquipmentForPageAppUserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//删除我的设备（郭乐）app/userEquipment/ deleteUserEquipmentApp.htm
-(void)GetDeleteUserEquipmentAppUserEquipmentId:(NSString *)userEquipmentId andCompletion:(LLDPResponseBlock)completion;

//好友验证消息列表（郭乐）app/verificationMessage/getVerificationMessageListApp.htm
-(void)GetVerificationMessageListAppUserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//好友留言列表（郭乐）app/friendsMessage/getFriendsMessageListApp.htm
-(void)GetFriendsMessageListAppUserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//首页（血压、专家建议、我的数据）app/homeIndex/getBloodPressureByNewApp.htm
-(void)GetBloodPressureByNewAppUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;

//我的好友列表（郭乐）app/myFriends/getMyFriendsListApp.htm
-(void)GetMyFriendsListAppUserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//删除添加好友（郭乐）app/myFriends/updateState.htm
-(void)GetUpdateStateUserId:(NSString *)userId friendsId:(NSString *)friendsId myFriendsId:(NSString *)myFriendsId andCompletion:(LLDPResponseBlock)completion;

//血压测量结果（郭乐）app/bloodPressure/ getBloodPressureByNewApp.htm
-(void)GetBloodPressureRequestWithUserId:(NSString *)userId bloodPressureId:(NSString *)bloodPressureId andCompletion:(LLDPResponseBlock)completion;

//历史血压数据（郭乐）app/bloodPressure/ getBloodPressureHisApp.htm
-(void)GetBloodPressureHistoryRequestWithUserId:(NSString *)userId type:(NSString *)type pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize  andCompletion:(LLDPResponseBlock)completion;

//好友历史数据 app/bloodPressure/ getFriendsBloodPressureApp.htm
-(void)GetFriendsBloodPressureAppUserId:(NSString *)userId pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize andCompletion:(LLDPResponseBlock)completion;

//好友历史折现图 app/bloodPressure/ getFriendsBloodPressureByPicApp.htm
-(void)GetFriendsBloodPressureByPicAppUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;

//寻医 app/seekDoctor/getSeekDoctorLoginOrReg.htm
-(void)GetSeekDoctorWithPressureId:(NSString *)pressureId phone:(NSString *)phone UUIDString:(NSString *)UUIDString andCompletion:(LLDPResponseBlock)completion;

#pragma mark - 新接口
//首页 app/homeIndex/getBloodPressureIndexApp.htm
-(void)GetBloodPressureUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;
//我的好友详情 app/myFriends/getMyFriendsInfoApp.htm
-(void)GetMyFriendsWithFriendId:(NSString *)friendId userId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;
//历史血压数据-趋势图（郭乐） app/bloodPressure/ getBloodPressureByNewApp.htm
-(void)GetBloodPressureHistoryTendencyChartRequestWithUserId:(NSString *)userId type:(NSString *)type andCompletion:(LLDPResponseBlock)completion;
#pragma mark - 血糖接口

//血糖记录历史查询接口   /lude/app/bloodGlucose/getBloodGlucoseHisLineChart.htm

-(void)GetBSHistoryDataRequestWithUserId:(NSString *)userId startTime:(NSString *)startTime endTime:(NSString *)endTime startNo:(NSString *)startNo pageSize:(NSInteger)pageSize andCompletion:(LLDPResponseBlock)completion;

//一级目录查询接口接口   /lude/app/medication/getMedicationCatalogByIdOrLevel.htm

+(void)GetMedicationCatalogByIdOrLevelWithUserId:(NSString *)userId andCompletion:(LLDPResponseBlock)completion;
//二级目录查询接口接口   /lude/app/medication/getMedicationCatalogByIdOrLevel.htm

+(void)GetMedicationCatalogByIdOrLevelWithUserId:(NSString *)userId catalogId:(NSString *)catalogId andCompletion:(LLDPResponseBlock)completion;

//药品查询接口    /lude/app/medication/getMedicationInfoByCatalogId.htm

+(void)GetMedicationInfoByCatalogIdWithUserId:(NSString *)userId catalogId:(NSString *)catalogId andCompletion:(LLDPResponseBlock)completion;

//药品搜索,相 关药品 /lude/app/medication/getMedicationInfoSearch.htm

+(void)GetMedicationInfoSearchWithUserId:(NSString *)userId medicationName:(NSString *)medicationName andCompletion:(LLDPResponseBlock)completion;


@end

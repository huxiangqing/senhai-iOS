//
//  ViewController.h
//
//  Created by bluemobi on 15/4/28.
//  Copyright (c) 2015年 liuhengyu. All rights reserved.
//
/**
 *	@brief	自定义网络请求基本信息
 */
#ifndef NetWorkDefines_H
#define NetWorkDefines_H
//正式服务器
#define SERVER_DEMAIN @"http://139.196.106.123/lude/"
//测试服务器
//#define SERVER_DEMAIN @"http://47.88.34.121/lude/"
//罗丹
//#define SERVER_DEMAIN @"http://192.168.2.222:8080/lude/"

typedef void (^LLDPNetBaseBlock)(void);
typedef void (^LLDPResponseBlock)(id objectRet, NSError *errorRes);

#endif

//
//  ScanCodeViewController.h
//  LUDE
//
//  Created by JHR on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

#define SCANVIEW_EdgeTop 40.0 //扫描视图距顶部
#define SCANVIEW_EdgeLeft  50.0 //扫描视图距左边
#define TINTCOLOR_ALPHA 0.3 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度

@interface ScanCodeViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderViewDelegate,UIAlertViewDelegate>
{
    UIView *_QrCodeline;//扫描线
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    NSString  *str;
}

@end

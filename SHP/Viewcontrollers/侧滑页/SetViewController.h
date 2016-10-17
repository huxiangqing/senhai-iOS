//
//  SetViewController.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic ,strong)UIScrollView *myScrollView_UIScrollView;
@property (nonatomic ,strong)UIView *container_UIView;
/**
 *	@brief	是否接受推送消息栏
 */
@property (strong, nonatomic)  UIView *messageView;
/**
 *	@brief	使用说明
 */
@property (strong, nonatomic)  UIView *describleView;
/**
 *	@brief	清除缓存
 */
@property (strong, nonatomic)  UIView *clearCacheView;
/**
 *	@brief	关于鹿得
 */
@property (strong, nonatomic)  UIView *aboutLudeView;

/**
 *	@brief	退出登录
 */
//@property (strong, nonatomic)  UIView *exitLudeView;
/**
 *	@brief	退出按钮
 */
@property(nonatomic ,strong)UIButton *exit_UIButton;

@end

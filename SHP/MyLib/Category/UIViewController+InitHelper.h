//
//  UIViewController+InitHelper.h
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//
/**
 * @brief  UIViewController initHelper
 */
#import <UIKit/UIKit.h>


@interface UIViewController (InitHelper)

-(id)initWithDefaultNibName;
-(id) initWithStoryboardID:(NSString *)storyboardID;
-(id) initWithDefaultStoryboardID;
-(void) popButtonPressed;
- (void)dismissViewController;
- (void)setupBackgroundImage:(UIImage *)backgroundImage;
-(id)initWithSecondStoryboardID:(NSString *)storyboardID;

-(void)gotoMainView;
@end


//
//  TrendsTextView.h
//  TrendsTextView
//
//  Created by Mac on 15/10/9.
//  Copyright © 2015年 djj. All rights reserved.
//

//输入框
#import <UIKit/UIKit.h>

@interface TrendsTextView : UITextView  

+ (instancetype) getTrendsTextView;

- (void) upward; //向上弹
- (void) down; //向下弹
- (void) changeSelfSizeWithStringSize:(CGSize) size;
@end

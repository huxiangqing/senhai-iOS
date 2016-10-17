//
//  BMInputView.h
//  inputView
//
//  Created by JHR on 15/9/29.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "UIViewExt.h"

@protocol BMInputViewDelegate <NSObject>

- (void)BMInputViewSendButtonClick:(NSString *)message;

@end

@interface BMInputView : UIView<HPGrowingTextViewDelegate>

@property (nonatomic,  strong) UIButton *sendBtn;
@property (nonatomic,  strong) HPGrowingTextView *mTextView;

@property (nonatomic) BOOL isTop;//用来判断评论按钮的位置

@property (nonatomic, assign) id<BMInputViewDelegate>delegate;

+ (instancetype)defaultInputView;



@end

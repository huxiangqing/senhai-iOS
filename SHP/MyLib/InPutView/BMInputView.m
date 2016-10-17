//
//  BMInputView.m
//  inputView
//
//  Created by JHR on 15/9/29.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import "BMInputView.h"

@implementation BMInputView

//初始化
+(instancetype)defaultInputView
{
    BMInputView *InputView = [[BMInputView alloc] initWithFrame:CGRectMake(0,SCREENHEIGHT, SCREENWIDTH, 40.f)];
    [InputView setBackgroundColor:[UIColor whiteColor]];
    
    [InputView addHPGrowingTextView];
    [InputView addSendBtn];
    
   // UIViewSetRadius(InputView, 0, 1.0, [UIColor grayColor]);
    
    UIImageView *phoneline = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"blueline"]];
    [phoneline setTag:11];
    [InputView addSubview:phoneline];
    [phoneline setUserInteractionEnabled:YES];
    [phoneline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(InputView);
        make.right.equalTo(InputView);
        make.height.equalTo(1.0);
        make.bottom.equalTo(InputView).with.offset(-2.0);
    }];

    
    [InputView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:InputView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:InputView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return InputView;
}
//添加自生长编辑视图
- (void)addHPGrowingTextView{
    
    self.mTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3,SCREENWIDTH - 70.0, 40.0)];
    self.mTextView.isScrollable = NO;
    self.mTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.mTextView.minNumberOfLines = 1;
    self.mTextView.maxNumberOfLines = 4;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    self.mTextView.returnKeyType = UIReturnKeyGo; //just as an example
    self.mTextView.font = [UIFont systemFontOfSize:15.0f];
    self.mTextView.delegate = self;
    self.mTextView.returnKeyType = UIReturnKeyDone;
    self.mTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.mTextView.backgroundColor = [UIColor whiteColor];
    self.mTextView.placeholder = @"@二二，留几句话吧......";
    self.mTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.mTextView];
}
//添加发送按钮
- (void)addSendBtn{
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60.0, 10.0, 50.0, 20.0)];
    self.sendBtn.backgroundColor = RGBCOLOR(0, 161, 244.0);
    [self.sendBtn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE13]];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   // self.sendBtn.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.f);
    //[self.sendBtn sizeToFit];
    [self.sendBtn setEnabled:NO];
    [self addSubview:self.sendBtn];
}
//发送按钮点击方法
-(void)sendBtnClick:(UIButton *)sender
{
    [self.delegate BMInputViewSendButtonClick:self.mTextView.text];
}
#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.frame = r;
}

-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    [self.sendBtn setEnabled:YES];
    
     self.sendBtn.centerYValue = growingTextView.centerYValue;
    
    if (growingTextView.text.length > 0) {
         [self.sendBtn setEnabled:YES];
         self.sendBtn.backgroundColor = [UIColor redColor];;
    }
    else
    {
         [self.sendBtn setEnabled:NO];
         self.sendBtn.backgroundColor = [UIColor greenColor];;
    }
}
-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
   // [growingTextView resignFirstResponder];
    return YES;
}
#pragma mark - keyboardOBS
- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    self.isTop =YES;
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =CGRectMake(0, SCREENHEIGHT -_keyboardRect.size.height-40.0, SCREENWIDTH, 40.0);
    } completion:^(BOOL finished) {
        [self setHidden:NO];
    }];
}
- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    self.isTop =NO;
    [self.mTextView setText:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, SCREENHEIGHT - 40.0, SCREENWIDTH, 40.0);
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

@end

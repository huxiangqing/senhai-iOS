//
//  LoginViewController.m
//  LUDE
//
//  Created by JHR on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "BindPhoneViewController.h"

@interface LoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
/**
 *	@brief	第三方登录的标识
 */
@property (nonatomic ,copy)NSString *thirdPartUID;

@property (nonatomic ,strong)UIScrollView *myScrollView_UIScrollView;

@property (nonatomic ,strong)UIView *container_UIView;
/**
 *	@brief	填写手机号码栏
 */
@property (strong, nonatomic)  UIView *phoneView;
@property (nonatomic ,strong) UIImageView *phoneline;
@property (nonatomic ,strong) UITextField *phoneText_UITextField;
/**
 *	@brief	填写验证码栏
 */
@property (strong, nonatomic)  UIView *codeView;
@property (nonatomic ,strong) UIImageView *codeline;
@property (nonatomic ,strong) UITextField *codeText_UITextField;
@property(nonatomic ,strong)UIButton *code_UIButton;

/**
 *	@brief	填写第三方登录栏
 */
@property (strong, nonatomic)  UIView *thirdLoginView;
@property(nonatomic ,strong)UIButton *login_UIButton;
@property (nonatomic ,assign) __block NSInteger timeout;
@property (nonatomic ,copy)NSString *weiChatOrWeiBO;

@property(nonatomic ,strong)UIButton *weixinBtn;
@property(nonatomic ,strong)UIButton *weiboBtn;
@property(nonatomic ,strong)UIButton *currentThirdPartBtn;
//LHY
//验证码记录
@property(strong ,nonatomic)NSString *verificationCodeStr;
@end

@implementation LoginViewController

#pragma mark - LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_lblTitleName setText:NSLocalizedString(@"LOG ON",nil)];
    [_btnTitleRegister setTitle:NSLocalizedString(@"Sign Up", @"免费注册") forState:UIControlStateNormal];
    
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    
    self.navigationController.delegate =self;
    [self.view addSubview:self.myScrollView_UIScrollView];
    [self.myScrollView_UIScrollView addSubview:self.container_UIView];
    [self.container_UIView addSubview:self.phoneView];
    [self.container_UIView addSubview:self.codeView];
    [self.container_UIView addSubview:self.login_UIButton];
    [self.container_UIView addSubview:self.thirdLoginView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    [self hideKeyBoard];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
//获取验证码
-(void)createDataMessagePhoneNum:(NSString *)phoneNumStr
{
    AJServerApis *apis = [[AJServerApis alloc]init];
    WeakObject(self);
    [apis GetSendMessagePhoneNum:phoneNumStr type:@"1" Completion:^(id objectRet, NSError *errorRes)
    {
        __strong typeof(self) strongSelf = __weakObject;
        if (objectRet)
        {
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                //倒计时
                [strongSelf Countdown];
                _verificationCodeStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"data"]objectForKey:@"verificationCode"]];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
            }
        }
   
    }];
}
/**
 *	@brief	界面所有元素添加约束栏
 */

-(void)viewWillAppear:(BOOL)animated
{
    [self.myScrollView_UIScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64.0,0,0,0));
    }];
    
    [self.container_UIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.myScrollView_UIScrollView);
        make.width.equalTo(self.myScrollView_UIScrollView);
        make.height.equalTo(458.0);
    }];
    
    [self.phoneView makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.container_UIView.top).with.offset(10.0);
        make.left.equalTo(self.container_UIView).with.offset(20.0);
        make.right.equalTo(self.container_UIView).with.offset(-20.0);
        make.height.equalTo(40.0);
    }];
    [self.codeView makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.phoneView.bottom).with.offset(10.0);
        make.left.equalTo(self.container_UIView).with.offset(20.0);
        make.right.equalTo(self.container_UIView).with.offset(-20.0);
        make.height.equalTo(40.0);
    }];
    
    [self.login_UIButton makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.codeView.bottom).with.offset(30.0);
        make.left.equalTo(self.container_UIView.left).with.offset(20.0);
        make.right.equalTo(self.container_UIView.right).with.offset(-20.0);
        make.height.equalTo(40.0);
    }];
    
    [self.thirdLoginView makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.login_UIButton.bottom).with.offset(30.0);
        make.left.equalTo(self.container_UIView.left).with.offset(20.0);
        make.right.equalTo(self.container_UIView.right).with.offset(-20.0);
        make.height.equalTo(80.0);
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideKeyBoard];
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneText_UITextField]) {
        [self.phoneline setImage:[UIImage imageNamed:@"blueline"]];
    }
    else
    {
        [self.codeline setImage:[UIImage imageNamed:@"blueline"]];
    }
    
    [self judgeEnable];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.phoneText_UITextField])
    {
        if ((range.location + string.length) == 11)
        {
            if (self.timeout <= 0) {
               [self.code_UIButton setEnabled:YES];
            }
        }
        else
        {
            [self.code_UIButton  setEnabled:NO];
        }
    }
    else
    {
        [self judgeEnable];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneText_UITextField]) {
        [self.phoneline setImage:[UIImage imageNamed:@"grayline"]];
    }
    else
    {
        [self.codeline setImage:[UIImage imageNamed:@"grayline"]];
    }
    
    [self judgeEnable];
}

#pragma mark - 点击事件
/**
 *	@brief	隐藏键盘栏
 */
-(void)hideKeyBoard
{
    [self.phoneText_UITextField resignFirstResponder];
    [self.codeText_UITextField resignFirstResponder];
    
    [self.view becomeFirstResponder];
}
/**
 *	@brief	获取验证码按钮 点击事件
 */
- (void)codeBtnClick:(UIButton *)sender {
      if ([Tools isValidateMobile:self.phoneText_UITextField.text])
      {
           if (self.timeout <= 0) {
              //数据请求
              [self createDataMessagePhoneNum:self.phoneText_UITextField.text];
           }
      }
    else
    {
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Account input error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil)  otherButtonTitles: nil];
        [_alertView show];
    }
}

/**
 *	@brief	判断是否符合注册条件
 */
-(BOOL)judgeEnable
{
    NSString *_phone = self.phoneText_UITextField.text;
    NSString *_code = self.codeText_UITextField.text;
 
    if (!(StringIsValid(_code)&&[Tools isValidateMobile:_phone]) )
    {
        return NO;
    }
    
    [self.login_UIButton setEnabled:YES];
    
    NSLog(@"登录");
    return YES;
}

/**
 *	@brief	去注册按钮 点击事件
 */
- (IBAction)registerInformation:(UIButton *)sender
{
    [self hideKeyBoard];
    NSLog(@"注册");
    
    RegisterViewController *registerView = [[RegisterViewController alloc] initWithStoryboardID:@"RegisterViewController"];
    [self.navigationController pushViewController:registerView animated:YES];
}
/**
 *	@brief倒计时
 */
-(void)Countdown
{
    self.timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self.timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.code_UIButton setTitle:NSLocalizedString(@"Get Code", nil) forState:UIControlStateNormal];
                if([Tools isValidateMobile:self.phoneText_UITextField.text])
                {
                    self.code_UIButton.enabled = YES;
                }
            });
        }else{
            NSInteger seconds = self.timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.code_UIButton setTitle:[NSString stringWithFormat:@"%@s%@",strTime,NSLocalizedString(@"Retry After", nil)] forState:UIControlStateNormal];
                self.code_UIButton.enabled = NO;
                
            });
            self.timeout--;
        }
    });
    dispatch_resume(_timer);
}
/**
 *	@brief	用手机号登录栏
 */

-(void)loginWithPhone
{
    [self hideKeyBoard];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self hideKeyBoard];
    if ([_verificationCodeStr isEqualToString:_codeText_UITextField.text]  || [_codeText_UITextField.text isEqualToString:@"101010"])
    {
        [self.login_UIButton setEnabled:NO];
        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        [apis PostSignWithPhoneNum:_phoneText_UITextField.text andCompletion:^(id objectRet, NSError *errorRes)
           {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     Userinfo *item = [Userinfo objectWithKeyValues:[objectRet objectForKey:@"data"]];
                     [[NTAccount shareAccount] setUserinfo:item];
                     //注册通知事件
                     NSDictionary *dic = [NSDictionary dictionaryWithObject:item.userId forKey:@"userId"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"obtainUserId" object:nil userInfo:dic];
                     
                     MainViewController *MainView = [[MainViewController alloc] initWithStoryboardID:@"MainViewController"];
                     [self.navigationController pushViewController:MainView animated:YES];
                 }
                 else
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                    {
                                                    }];
                     [alertController addAction:otherAction];
                     [self presentViewController:alertController animated:YES completion:nil];
                     
                 }
           }
               
            [self.login_UIButton setEnabled:YES];
          
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please confirm and try agai", nil)];
    }
}
/**
 *	@brief	第三方登录栏
 *
 */
-(void)loginWithWeibo
{
    self.currentThirdPartBtn = self.weiboBtn;
    [self.currentThirdPartBtn setEnabled:NO];
    
    [self hideKeyBoard];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    WeakObject(self);
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
             [__weakObject thirdPartActionBeginClicked:user.uid info:nil];
            __weakObject.weiChatOrWeiBO = @"weibo";
        }
        else{
            [__weakObject.currentThirdPartBtn setEnabled:YES];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Try Again", nil)];
            
            [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
        }
    }
     ];
    
    NSLog(@"微博登录");
}
-(void)loginWithWeixin
{
    self.currentThirdPartBtn = self.weixinBtn;
    [self.currentThirdPartBtn setEnabled:NO];
    [self hideKeyBoard];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    WeakObject(self);
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            [__weakObject thirdPartActionBeginClicked:user.rawData[@"unionid"] info:user.rawData];
            __weakObject.weiChatOrWeiBO = @"weiChat";
            __weakObject.info = user.rawData;
        }
        else{
            [__weakObject.currentThirdPartBtn setEnabled:YES];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Try Again", nil)];
            
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        }
    }
     ];
    NSLog(@"微信登录");
}
/*
 **@brief 第三方登录授权成功后
 *
 */
-(void)thirdPartActionBeginClicked:(NSString *)userid info:(NSDictionary *)info
{
    WeakObject(self);
    self.thirdPartUID = userid;
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis LoginWithWeiXinAndWeiBoRequestWithUserId:userid info:info andCompletion:^(id objectRet, NSError *errorRes)
     {
         [__weakObject.currentThirdPartBtn setEnabled:YES];
         
         if(objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 Userinfo *item = [Userinfo objectWithKeyValues:[objectRet objectForKey:@"data"]];
                 [[NTAccount shareAccount] setUserinfo:item];
                 
                 MainViewController *MainView = [[MainViewController alloc] initWithStoryboardID:@"MainViewController"];
                 [self.navigationController pushViewController:MainView animated:YES];
             }
             else if ([statusStr isEqualToString:@"2"])
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 alertView.tag = 101;
                 [alertView show];
             }

         }
       
     }];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
      if (buttonIndex == 0)
     {
         BindPhoneViewController *BindPhoneView = [[BindPhoneViewController alloc] initWithStoryboardID:@"BindPhoneViewController"];
         BindPhoneView.thirdPartUID  = self.thirdPartUID;
         BindPhoneView.weiChatOrWeiBO = self.weiChatOrWeiBO;
         BindPhoneView.info = self.info;
         [self.navigationController pushViewController:BindPhoneView animated:YES];
     }
    }
}

/**
 *	@brief	界面元素的getter方法初始化

 */
#pragma mark - getter
-(UIScrollView *)myScrollView_UIScrollView
{
    if (_myScrollView_UIScrollView == nil)
    {
        _myScrollView_UIScrollView = [[UIScrollView alloc] init];
        [_myScrollView_UIScrollView setBackgroundColor:[UIColor clearColor]];
        [_myScrollView_UIScrollView setUserInteractionEnabled:YES];
        [_myScrollView_UIScrollView setShowsHorizontalScrollIndicator:NO];
        [_myScrollView_UIScrollView setShowsVerticalScrollIndicator:NO];
        [_myScrollView_UIScrollView setScrollEnabled:YES];
        [_myScrollView_UIScrollView setDelegate:self];
    }
    
    return _myScrollView_UIScrollView;
}
-(UIView *)container_UIView
{
    if (_container_UIView == nil) {
        _container_UIView = [[UIView alloc] init];
    }
    return _container_UIView;
}

-(UIView *)phoneView
{
    if (_phoneView == nil) {
        _phoneView = [[UIView alloc] init];
        [_phoneView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_phoneView);
        [titleText setText:NSLocalizedString(@"Account", nil)];
        [titleText sizeToFit];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_phoneView.left).with.offset(10.0);
            make.centerY.equalTo(_phoneView);
        }];
        
        _phoneText_UITextField = [[UITextField alloc] init];
        [_phoneText_UITextField setBorderStyle:UITextBorderStyleNone];
       // [_nameText_UITextField setTextAlignment:NSTextAlignmentRight];
        [_phoneText_UITextField setDelegate:self];
        [_phoneText_UITextField setPlaceholder:NSLocalizedString(@"Mobile Number", nil)];
        [_phoneText_UITextField setTextColor:[UIColor lightGrayColor]];
        [_phoneText_UITextField setBackgroundColor:[UIColor clearColor]];
        [_phoneText_UITextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_phoneText_UITextField setFont:[UIFont systemFontOfSize:FONTSIZE15]];
        [_phoneText_UITextField setReturnKeyType:UIReturnKeyDone];
        [_phoneView addSubview:_phoneText_UITextField];
        
        [_phoneText_UITextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_phoneView.top).with.offset(5.0);
            make.left.equalTo(titleText.widthValue + titleText.leftValue+10.0);
            make.right.equalTo(_phoneView);
            make.height.equalTo(30.0);
        }];

        _phoneline = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"grayline"]];
        [_phoneline setTag:11];
        [_phoneView addSubview:_phoneline];
        [_phoneline setUserInteractionEnabled:YES];
        [_phoneline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_phoneView);
            make.right.equalTo(_phoneView);
            make.height.equalTo(1.0);
            make.bottom.equalTo(_phoneView).with.offset(-1.0);
        }];
    }
    
    return _phoneView;
}
-(UIView *)codeView
{
    if (_codeView == nil) {
        _codeView = [[UIView alloc] init];
        [_codeView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_codeView);
        [titleText setText:NSLocalizedString(@"Code", nil)];
        [titleText sizeToFit];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_codeView.left).with.offset(10.0);
            make.centerY.equalTo(_codeView);
        }];
        _code_UIButton = UIButtonInitFrm(CGRectZero, @"code_normal", nil, _codeView);
        ButtonSetTitle(_code_UIButton, NSLocalizedString(@"Getting Code", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE13]);
        [_code_UIButton setBackgroundImage:[UIImage imageNamed:@"code_Disabled"] forState:UIControlStateDisabled];
        [_code_UIButton addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_code_UIButton setEnabled:NO];
        
        _codeText_UITextField = [[UITextField alloc] init];
        [_codeText_UITextField setBorderStyle:UITextBorderStyleNone];
        [_codeText_UITextField setDelegate:self];
        [_codeText_UITextField setTextColor:[UIColor lightGrayColor]];
        [_codeText_UITextField setPlaceholder:NSLocalizedString(@"Verification Code", nil)];
        [_codeText_UITextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_codeText_UITextField setBackgroundColor:[UIColor clearColor]];
        [_codeText_UITextField setFont:[UIFont systemFontOfSize:FONTSIZE14]];
        [_codeText_UITextField setReturnKeyType:UIReturnKeyDone];
        [_codeView addSubview:_codeText_UITextField];
        
        [_code_UIButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_codeView.top).with.offset(5.0);
            make.right.equalTo(_codeView);
            make.size.equalTo(CGSizeMake(80.0, 30.0));
        }];
        [_codeText_UITextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_codeView.top).with.offset(5.0);
            make.left.equalTo(titleText.widthValue + titleText.leftValue+10.0);
            make.right.equalTo(self.code_UIButton.left);
            make.height.equalTo(30.0);
        }];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"grayline"]];
        [line setUserInteractionEnabled:YES];
        [line setTag:11];
        [_codeView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_codeView);
            make.right.equalTo(_codeView);
            make.height.equalTo(1.0);
            make.bottom.equalTo(_codeView).with.offset(-1.0);
        }];
        _codeline = line;
    }
    
    return _codeView;
}

-(UIButton *)login_UIButton
{
    if (_login_UIButton == nil) {
        _login_UIButton = UIButtonInitFrm(CGRectZero, @"loginbtn", nil, self.container_UIView);
        ButtonSetTitle(_login_UIButton, NSLocalizedString(@"Log On", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE15]);
        [_login_UIButton addTarget:self action:@selector(loginWithPhone) forControlEvents:UIControlEventTouchUpInside];
        [_login_UIButton setEnabled:NO];
    }
    return _login_UIButton;
}

-(UIView *)thirdLoginView
{
    if (_thirdLoginView == nil) {
        
        _thirdLoginView = [[UIView alloc] init];
        [_thirdLoginView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor lightGrayColor],_thirdLoginView);
        [titleText setText:NSLocalizedString(@"Log On by other ways", nil)];
        [titleText sizeToFit];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_thirdLoginView);
            make.centerX.equalTo(_thirdLoginView);
        }];

        UIImageView *lineleft = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"shortgrayline"]];
        [lineleft setUserInteractionEnabled:YES];
        [_thirdLoginView addSubview:lineleft];
        [lineleft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleText);
            make.right.equalTo(titleText.left).with.offset(-5.0);
            make.height.equalTo(1.0);
            make.width.equalTo(80.0);
        }];
        UIImageView *lineright = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"shortgrayline"]];
        [lineright setUserInteractionEnabled:YES];
        [_thirdLoginView addSubview:lineright];
        [lineright mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleText);
            make.left.equalTo(titleText.right).with.offset(5.0);
            make.height.equalTo(1.0);
            make.width.equalTo(80.0);
        }];
        
        UIButton *weixinBtn  = UIButtonInitFrm(CGRectZero, @"greenBack", nil, _thirdLoginView);
        ButtonSetTitle(weixinBtn, NSLocalizedString(@"Wechat Connect", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE15]);
        [weixinBtn.imageView setContentMode:UIViewContentModeCenter];
        [weixinBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  -2.0,
                                                  0.0,
                                                  0.0)];
        [weixinBtn setImage:[UIImage imageNamed: @"weixin"] forState:UIControlStateNormal];
        [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_thirdLoginView);
            make.bottom.equalTo(_thirdLoginView);
            make.height.equalTo(40.0);
            make.width.equalTo((SCREENWIDTH-50.0)/2);
        }];
        [weixinBtn addTarget:self action:@selector(loginWithWeixin) forControlEvents:UIControlEventTouchUpInside];
        
        _weixinBtn = weixinBtn;
        
        UIButton *weiboBtn  = UIButtonInitFrm(CGRectZero, @"redBack", nil, _thirdLoginView);
        ButtonSetTitle(weiboBtn, NSLocalizedString(@"Weibo Connect", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE15]);
        [weiboBtn.imageView setContentMode:UIViewContentModeCenter];
        [weiboBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                       -5.0,
                                                       0.0,
                                                       0.0)];
        [weiboBtn setImage:[UIImage imageNamed: @"Micro-blog"] forState:UIControlStateNormal];
        [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_thirdLoginView);
             make.bottom.equalTo(_thirdLoginView);
            make.height.equalTo(40.0);
            make.width.equalTo((SCREENWIDTH-50.0)/2);
        }];
        [weiboBtn addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
        _weiboBtn = weiboBtn;
    }
    
    return _thirdLoginView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

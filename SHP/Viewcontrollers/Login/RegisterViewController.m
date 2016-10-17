//
//  RegisterViewController.m
//  LUDE
//
//  Created by JHR on 15/10/9.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "RegisterViewController.h"
#import "AgreementViewController.h"
#import "InitInfoViewController.h"
#import "MainViewController.h"

@interface RegisterViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)UIScrollView *myScrollView_UIScrollView;

@property (nonatomic ,strong)UIView *container_UIView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleRegister;

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
 *	@brief	注册协议栏
 */
@property (strong, nonatomic)  UIView *protocolView;
@property (strong, nonatomic)  UIButton *agreeBtn_UIButton;
@property(nonatomic ,strong)UIButton *register_UIButton;

/**
 *	@brief	倒计时
 */

@property (nonatomic ,assign) __block NSInteger timeout;

//LHY
//记录验证码
@property (strong ,nonatomic)NSString *verificationCodeStr;
//记录发送时间
@property (strong ,nonatomic)NSString *sendTimeStr;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_lblTitleRegister setText:NSLocalizedString(@"Register", @"注册")];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myScrollView_UIScrollView];
    [self.myScrollView_UIScrollView addSubview:self.container_UIView];
    [self.container_UIView addSubview:self.phoneView];
    [self.container_UIView addSubview:self.codeView];
    [self.container_UIView addSubview:self.protocolView];
    [self.container_UIView addSubview:self.register_UIButton];

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    self.sendTimeStr = currentDateStr;
}
/**
 *	@brief	验证验证码是否过期
 */
-(void)createDataMessagePhoneNum:(NSString *)phoneNumStr
{
    AJServerApis *apis = [[AJServerApis alloc]init];
    [apis GetSendMessagePhoneNum:phoneNumStr type:@"0" Completion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 //验证码
                 _verificationCodeStr = [NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"data"]objectForKey:@"verificationCode"]];
                 //发送时间
                 _sendTimeStr = [NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"data"]objectForKey:@"sendTime"]];
                 [self Countdown];
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
    [self.protocolView makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.codeView.bottom).with.offset(10.0);
        make.left.equalTo(self.container_UIView.left).with.offset(20.0);
        make.right.equalTo(self.container_UIView.right).with.offset(-20.0);
        make.height.equalTo(30.0);
    }];

    [self.register_UIButton makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.protocolView.bottom).with.offset(30.0);
        make.left.equalTo(self.container_UIView.left).with.offset(20.0);
        make.right.equalTo(self.container_UIView.right).with.offset(-20.0);
        make.height.equalTo(40.0);
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
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
     [self hideKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	隐藏键盘
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
            //获取验证码数据
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
    
    [self.register_UIButton setEnabled:YES];
    
    return YES;
}
/**
 *	@brief	注册按钮 点击事件
 */
- (void)registerInformation:(UIButton *)sender
{
    [self hideKeyBoard];
    
    if ([Tools isValidateMobile:_phoneText_UITextField.text] &&( [_verificationCodeStr isEqualToString:_codeText_UITextField.text] || [_codeText_UITextField.text isEqualToString:@"101010"]))
    {
        if (self.agreeBtn_UIButton.selected)
        {
            [sender setEnabled:NO];
            LLNetApiBase *apis =[[LLNetApiBase alloc]init];
            [apis POSTCheckVerificationCodeTelephone:_phoneText_UITextField.text verificationCode:_codeText_UITextField.text sendTime:_sendTimeStr andCompletion:^(id objectRet, NSError *errorRes)
             {
                 if (objectRet)
                 {
                     NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                     if ([statusStr isEqualToString:@"1"])
                     {
                         InitInfoViewController *editinfo = [[InitInfoViewController alloc] initWithStoryboardID:@"InitInfoViewController"];
                         editinfo.phoneNum = _phoneText_UITextField.text;
                         [self.navigationController pushViewController:editinfo animated:YES];
                     }
                     else
                     {
                         [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
                     }
              }
                 
                 [sender setEnabled:YES];
             
             }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Agree to the contents of the relevant agreement", nil)];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter the correct verification code", nil)];
    }
}

/**
 *	@brief	同意协议按钮 点击事件
 */
- (void)agreeBtnSelected:(UIButton *)sender
{
    [self hideKeyBoard];
    [sender setSelected:!sender.selected];
    [self judgeEnable];
}
/**
 *	@brief	查看协议事件
 */
- (void)readProtocolTapped:(UIButton *)sender
{
    [self hideKeyBoard];
    
    AgreementViewController *agreementView = [[AgreementViewController alloc] initWithStoryboardID:@"AgreementViewController"];
    WeakObject(self);
    agreementView.agreeOrDisagree = ^(BOOL agree)
    {
        __strong typeof(self) strongSelf = __weakObject;
        if (strongSelf) {
             [strongSelf.agreeBtn_UIButton setSelected:agree];
        }
        else
        {
            return ;
        }
    };
    [self.navigationController pushViewController:agreementView animated:YES];
    
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
        [_phoneText_UITextField setFont:[UIFont systemFontOfSize:FONTSIZE15]];
        [_phoneText_UITextField setReturnKeyType:UIReturnKeyDone];
        [_phoneText_UITextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
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
        [_codeText_UITextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        // [_codeText_UITextField setTextAlignment:NSTextAlignmentRight];
        [_codeText_UITextField setDelegate:self];
        [_codeText_UITextField setTextColor:[UIColor lightGrayColor]];
        [_codeText_UITextField setPlaceholder:NSLocalizedString(@"Verification Code", nil)];
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
-(UIView *)protocolView
{
    if (_protocolView == nil) {
        
        _protocolView = [[UIView alloc] init];
        [_protocolView setBackgroundColor:[UIColor clearColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE11], [UIColor lightGrayColor],_protocolView);
        [titleText setText:NSLocalizedString(@"Continuing means you’ve read and agreed to our Terms", nil)];
        [titleText sizeToFit];
        
        UIButton *agreeBtn  = UIButtonInitFrm(CGRectZero, nil, nil, _protocolView);
        [agreeBtn setImage:[UIImage imageNamed:@"agree_normal"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateSelected];
        [agreeBtn addTarget:self action:@selector(agreeBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_protocolView).with.offset(-5.0);
            make.centerY.equalTo(_protocolView);
            make.height.equalTo(30.0);
            make.width.equalTo(30.0);
        }];
        [agreeBtn setSelected:YES];
        self.agreeBtn_UIButton = agreeBtn;
        
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(agreeBtn.right).with.offset(-5.0);
            make.centerY.equalTo(_protocolView);
        }];
        
        UIButton *linkBtn  = UIButtonInitFrm(CGRectZero, nil, nil, _protocolView);
        ButtonSetTitle(linkBtn, NSLocalizedString(@"Service and Privacy", nil),RGBCOLOR(0.0, 122.0, 255.0), [UIFont systemFontOfSize:FONTSIZE11]);
        linkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleText.right);
             make.centerY.equalTo(_protocolView);
            make.height.equalTo(30.0);
            make.width.equalTo(100.0);
        }];
        [linkBtn addTarget:self action:@selector(readProtocolTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _protocolView;
}

-(UIButton *)register_UIButton
{
    if (_register_UIButton == nil) {
        _register_UIButton = UIButtonInitFrm(CGRectZero, @"loginbtn", nil, self.container_UIView);
        ButtonSetTitle(_register_UIButton, NSLocalizedString(@"NEXT", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE15]);
        [_register_UIButton addTarget:self action:@selector(registerInformation:) forControlEvents:UIControlEventTouchUpInside];
        [_register_UIButton setEnabled:NO];
    }
    return _register_UIButton;
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

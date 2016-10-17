//
//  InitInfoViewController.m
//  LUDE
//
//  Created by JHR on 15/10/15.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "InitInfoViewController.h"
#import "MainViewController.h"

static CGFloat const rulerMultiple=10;
@interface InitInfoViewController ()<UITextFieldDelegate,pickViewHideAndShow,ZHRulerViewDelegate>
{
    //男女按钮记录
    UIButton *sexButton;
}
@property (strong, nonatomic) IBOutlet UILabel *lblBrithday;
@property (strong, nonatomic) IBOutlet UILabel *lblUserSex;
@property (strong, nonatomic) IBOutlet UILabel *lblUserInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblUserKG;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveInfo;
@property (strong ,nonatomic)PickerView *pick;
/**
 *	@brief	体重
 */
@property(nonatomic,strong)ZHRulerView *rulerview;
/**
 *	@brief	身高
 */
@property(nonatomic,strong)ZHRulerView *heightRulerview;
@end

@implementation InitInfoViewController

- (void)viewDidLoad
{
    [_lblBrithday setText:NSLocalizedString(@"Birthday", nil)];
    [_lblUserHeight setText:NSLocalizedString(@"Height", nil)];
    [_lblUserInfo setText:NSLocalizedString(@"MY PROFILE", nil)];
    [_lblUserKG setText:NSLocalizedString(@"Weight", nil)];
    [_lblUserName setText:NSLocalizedString(@"Name", nil)];
    [_lblUserSex setText:NSLocalizedString(@"Male/Female", nil)];
    [_btnSaveInfo setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [_nameTextField setPlaceholder:NSLocalizedString(@"Input Name", nil)];
    [_timeLabel setText:NSLocalizedString(@"Select Brithday", nil)];
    
    [super viewDidLoad];
    [self createUI];
}
-(void)viewWillLayoutSubviews
{
    CGRect rect1=CGRectMake(116, 5,  _weightView.widthValue-120, 45);
    _rulerview.frame=rect1;
    _heightRulerview.frame=rect1;
}

-(void)createUI
{
    _rulerview=[[ZHRulerView alloc]initWithMixNuber:10 maxNuber:200 showType: rulerViewshowHorizontalType rulerMultiple:rulerMultiple];
    _rulerview.delegate=self;
    _rulerview.defaultVaule = 80;
    [self.weightView  addSubview:_rulerview];
        
    _heightRulerview=[[ZHRulerView alloc]initWithMixNuber:10 maxNuber:300 showType:rulerViewshowHorizontalType rulerMultiple:rulerMultiple];
    _heightRulerview.delegate=self;
    _heightRulerview.defaultVaule = 160;
    [self.heightView  addSubview:_heightRulerview];
}
#pragma mark rulerviewDelagete
-(void)getRulerValue:(CGFloat)rulerValue withScrollRulerView:(ZHRulerView *)rulerView
{
    if (_rulerview == rulerView)
    {
        _weightLabel.text=[NSString stringWithFormat:@"%.1f",rulerValue];
        
    }
    else
    {
        _heightLabel.text=[NSString stringWithFormat:@"%.1f",rulerValue];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark Responding touch
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
}

#pragma mark Responding to keyboard events
/**
 *	@brief键盘事件
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    float keyHeight = keyboardRect.size.height/4;
    [self moveInputBarWithKeyboardHeight:keyHeight withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void) moveInputBarWithKeyboardHeight:(float) _height withDuration:(float) _animationDuration
{
    [UIView animateWithDuration:0.10f
                     animations:^
    {
        self.myInfoScrollView.contentOffset = CGPointMake(0, _height);
    
    } completion:^(BOOL finished)
     {
         
     }];
}
#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.view.subviews containsObject:self.pick]) {
        [self.pick removeFromSuperview];
    }
//    //监听键盘弹起和收起
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    //注销监听
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	男孩女孩选择
 */
- (IBAction)BoyAndGirlBtnClick:(UIButton *)sender
{
    sexButton = sender;
    if (sender.selected == YES)
    {
        sender.selected = NO;
    }
    else
    {
        sender.selected = YES;
    }
}
/**
 *	@brief	生日选择
 */
- (IBAction)brithdayBtnClick:(UIButton *)sender
{
    [self.nameTextField resignFirstResponder];
    self.pick = [[PickerView alloc] initWithFrame:CGRectMake(0,SCREENHEIGHT - 220 , SCREENWIDTH, 220) PickerStyle:YearMonthDay];
    self.pick.delagate =self;
    [self.view addSubview:self.pick];
}
-(void)PickerViewWillclose
{
    [self.pick removeFromSuperview];
}

-(void)DatePickViewValues:(NSString *)Values
{
    _timeLabel.text = [Values substringWithRange:NSMakeRange(0, 10) ];
}

/**
 *	@brief	保存
 */
- (IBAction)PreservationBtnClick:(UIButton *)sender
{
    
    if ( _nameTextField.text.length>0)
    {
        if ([_timeLabel.text isEqualToString:NSLocalizedString(@"Select Brithday", nil)])
        {
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Date of birth is not completed", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alertView show];
            return;
        }
        NSString *sexStr;
        if (sexButton.selected ==NO)
        {
            sexStr =@"1";
        }
        else
        {
            sexStr =@"2";
        }
        
        if(_nameTextField.text.length > 10) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please enter the name of 10 words or less", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                           }];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }

        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        
        [apis PostUserInfoRegisterUserName:self.thirdPartUID phone:_phoneNum userType:@"1" realName:_nameTextField.text sex:sexStr birthday:_timeLabel.text height:_heightLabel.text weight:_weightLabel.text weiChatOrWeiBO:self.weiChatOrWeiBO info:self.info andCompletion:^(id objectRet, NSError *errorRes)
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
                    
                    MainViewController *main =[[MainViewController alloc]  initWithStoryboardID:@"MainViewController"];
                    [self.navigationController pushViewController:main animated:YES];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
                }
            }
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please complete the personal information", nil)];
        return;
    }
}


@end

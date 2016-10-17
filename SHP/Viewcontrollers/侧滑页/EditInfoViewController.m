//
//  EditInfoViewController.m
//  LUDE
//
//  Created by JHR on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "EditInfoViewController.h"
#import "MainViewController.h"

static CGFloat const rulerMultiple=10;
@interface EditInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,pickViewHideAndShow,ZHRulerViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    UITextField *recordTextfield;
}
/**
 *	@brief	选中的图片
 */
@property (strong, nonatomic) IBOutlet UILabel *lblUserImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UILabel *lblUserInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserSex;
@property (strong, nonatomic) IBOutlet UILabel *lblUserBri;
@property (strong, nonatomic) IBOutlet UILabel *lblHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblUserKG;
@property(strong , nonatomic)PickerView *pick;
/**
 *	@brief	按钮点击
 */
@property (weak, nonatomic) IBOutlet UIButton *headButton;
/**
 *	@brief	选中的图片
 */
@property (nonatomic ,retain) UIImage *selectedImage;
/**
 *	@brief	体重
 */
@property(nonatomic,strong)ZHRulerView *rulerview;
/**
 *	@brief	身高
 */
@property(nonatomic,strong)ZHRulerView *heightRulerview;
@end

@implementation EditInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"MY PROFILE", nil)];
    [_lblHeight setText:NSLocalizedString(@"Height", nil)];
    [_lblUserKG setText:NSLocalizedString(@"Weight", nil)];
    [_lblUserBri setText:NSLocalizedString(@"Birthday", nil)];
    [_lblUserImage setText:NSLocalizedString(@"Profile Photo", nil)];
    [_lblUserInfo setText:NSLocalizedString(@"Profile", nil)];
    [_lblUserName setText:NSLocalizedString(@"Name", nil)];
    [_lblUserSex setText:NSLocalizedString(@"Male/Female", nil)];
    [_btnSave setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [_nameTextField setPlaceholder:NSLocalizedString(@"Input Name", nil)];
    [_timeLabel setText:NSLocalizedString(@"Select Brithday", nil)];
    self.navigationController.delegate =self;
    //请求数据
    [self createEditInfo];
    [self createUI];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)createEditInfo
{
     Userinfo *item = [NTAccount shareAccount].userinfo;
    WeakObject(self);
     AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetUserInfoByUserId:item.userId Completion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet) {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 Userinfo *item = [Userinfo objectWithKeyValues:[objectRet valueForKey:@"data"]];
                 [[NTAccount shareAccount] setUserinfo:item];
                 
                 [__weakObject createUIData];
                 
             }
             else
             {
                 [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
             }

         }
    }];
}
-(void)viewWillLayoutSubviews
{
    CGRect rect1=CGRectMake(116, 5,  _weightView.widthValue-120, 45);
    _rulerview.frame=rect1;
    _heightRulerview.frame=rect1;
    
   // UIViewSetRadius(_headButton, 20.0, 1.0, [UIColor clearColor]);
}

-(void)createUI
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    [_headButton sd_setImageWithURL:[NSURL URLWithString:item.userPic]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xin-morentouxiang"]];
    _nameTextField.placeholder=[NSString stringWithFormat:@"%@",item.realName];
    NSString *sexStr =[NSString stringWithFormat:@"%@",item.sex];
    if ([sexStr isEqualToString:@"2"])
    {
        _sexButton.selected = YES;
    }
    _timeLabel.text =[NSString stringWithFormat:@"%@",item.birthday];
    _headButton.layer.masksToBounds = YES;
    _headButton.layer.cornerRadius = 20;
    _rulerview=[[ZHRulerView alloc]initWithMixNuber:10 maxNuber:200 showType:rulerViewshowHorizontalType rulerMultiple:rulerMultiple];
    _rulerview.delegate=self;
    [self.weightView  addSubview:_rulerview];
    
    _heightRulerview=[[ZHRulerView alloc]initWithMixNuber:10 maxNuber:300 showType:rulerViewshowHorizontalType rulerMultiple:rulerMultiple];
    _heightRulerview.delegate=self;
    [self.heightView  addSubview:_heightRulerview];
}

-(void)createUIData
{
    Userinfo *item = [NTAccount shareAccount].userinfo;

    if (item)
    {
    
        [_headButton sd_setImageWithURL:[NSURL URLWithString:item.userPic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"xin-morentouxiang"]];
        _nameTextField.text =[NSString stringWithFormat:@"%@",item.realName];
        NSString *sexStr =[NSString stringWithFormat:@"%@",item.sex];
        if ([sexStr isEqualToString:@"1"])
        {//男
            
        }
        else
        {//女
            _sexButton.selected = YES;
        }
        
        _timeLabel.text =[NSString stringWithFormat:@"%@",item.birthday];
        NSString *heightStr =[NSString stringWithFormat:@"%@",item.height];
         heightStr =[NSString stringWithFormat:@"%.1f",[heightStr floatValue]];
        _heightLabel.text = heightStr;
        _heightRulerview.defaultVaule =[heightStr integerValue];
        
        NSString *weightStr =[NSString stringWithFormat:@"%@",item.weight];
        weightStr =[NSString stringWithFormat:@"%.1f",[weightStr floatValue]];
        _weightLabel.text =weightStr;
        _rulerview.defaultVaule=[weightStr intValue];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Responding touch
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
}
#pragma mark Responding to keyboard events
/**
 *	@brief键盘事件
 */
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    float keyHeight = keyboardRect.size.height/4;
    [self moveInputBarWithKeyboardHeight:keyHeight withDuration:animationDuration];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void) moveInputBarWithKeyboardHeight:(float) _height withDuration:(float) _animationDuration
{
    [UIView animateWithDuration:0.10f
                     animations:^{
                         self.myInfoScrollView.contentOffset = CGPointMake(0, _height);
                     } completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.pick removeFromSuperview];
    recordTextfield = textField;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //监听键盘弹起和收起
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    //注销监听
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _selectedImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateUserAvatar:_selectedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self SourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self showPhotoLibrary];
    }
}


#pragma mark - private methods
-(void)SourceTypeCamera
{
    BOOL cameraAvailableFlag = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (cameraAvailableFlag)
        [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
    else
        NSLog(@"不支持相机功能");
}
-(void)showcamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    imagePicker.showsCameraControls = YES;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}
-(void)showPhotoLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{}];
    
}
-(void)updateUserAvatar:(UIImage *)image
{
    [self.headButton setImage:image forState:UIControlStateNormal];
}
#pragma mark - 点击事件

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *	@brief	保存按钮 点击事件
 */
- (IBAction)saveInformation:(UIButton *)sender
{
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis PostuploadSWFImage:_headButton.imageView.image andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (errorRes)
         {
         }
         else
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 [self createData:[objectRet objectForKey:@"picture"]];
             }
             else
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"]delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 [alertView show];
             }
         }
     } progress:^(int64_t bytesRead, int64_t totalBytesRead) {
         
         NSLog(@"progress: %f, cur: %lld, total: %lld",
               (bytesRead * 1.0) / totalBytesRead,
               bytesRead,
               totalBytesRead);
     }];
}

-(void)createData:(NSString *)picture
{
    
    [recordTextfield resignFirstResponder];
    Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *userIdStr=[NSString stringWithFormat:@"%@",item.userId];
    NSString *sexStr;
    if (_sexButton.selected)
    {
        sexStr = @"2";
    }
    else
    {
        sexStr = @"1";
    }
    
    NSString *tempString =[NSString stringWithFormat:@"%@",_nameTextField.text];
    
    if (tempString.length > 10) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please enter the name of 10 words or less", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                       }];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    tempString = [[tempString componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    NSString *tempStr = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *_timeLabelStr =[_timeLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
     LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis PostupdateUserInfoUserId:userIdStr realName:tempStr userPic:picture sex:sexStr age:@"" birthday:_timeLabelStr height: _heightLabel.text weight:_weightLabel.text andCompletion:^(id objectRet, NSError *errorRes)
     {
        if (errorRes)
        {
            NSLog(@"errorRes = %@",errorRes);
        }
        else
        {
            NSLog(@"objectRet =%@",objectRet);
            
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                Userinfo *item = [Userinfo objectWithKeyValues:[objectRet objectForKey:@"data"]];
                [[NTAccount shareAccount] setUserinfo:item];
                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"]delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"]delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                [alertView show];
            }
        }
         [SVProgressHUD dismiss];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
     [self.navigationController popViewControllerAnimated:YES];
}

/**
 *	@brief	编辑头像 点击事件
 */
- (IBAction)headBtnClick:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Photograph", nil),NSLocalizedString(@"Select From Album", nil),nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

/**
 *	@brief	选择性别点击事件
 */
- (IBAction)selectSex:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}
/**
 *	@brief	生日选择
 */
- (IBAction)brithdayBtnClick:(UIButton *)sender
{
    [recordTextfield  resignFirstResponder];
    
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
    _timeLabel.text = [NSString stringWithFormat:@"  %@",[Values substringToIndex:10]];
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


@end

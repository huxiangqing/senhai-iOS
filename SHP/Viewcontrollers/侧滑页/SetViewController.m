//
//  SetViewController.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/8.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "SetViewController.h"
#import "InstructionViewController.h"
#import "AboutLudeViewController.h"
#import "JPUSHService.h"
#import "LoginViewController.h"

@interface SetViewController ()<UINavigationControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblSetTitle;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblSetTitle setText:NSLocalizedString(@"SETTING", nil)];
    self.navigationController.delegate =self;
    [self.view addSubview:self.myScrollView_UIScrollView];
    [self.myScrollView_UIScrollView addSubview:self.container_UIView];
    [self.container_UIView addSubview:self.messageView];
    [self.container_UIView addSubview:self.describleView];
    [self.container_UIView addSubview:self.clearCacheView];
    [self.container_UIView addSubview:self.aboutLudeView];
 //   [self.container_UIView addSubview:self.exitLudeView];
    [self.container_UIView addSubview:self.exit_UIButton];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myScrollView_UIScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64.0,0,0,0));
    }];
    [self.container_UIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.myScrollView_UIScrollView);
        make.width.equalTo(self.myScrollView_UIScrollView);
        make.height.equalTo(SCREENHEIGHT- 64.0);
    }];
     
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.container_UIView);
        make.left.equalTo(self.container_UIView);
        make.right.equalTo(self.container_UIView);
        make.height.equalTo(40.0);
    }];
    [self.describleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.messageView.bottom).with.offset(10.0);
        make.left.equalTo(self.container_UIView);
        make.right.equalTo(self.container_UIView);
        make.height.equalTo(50.0);
    }];
    [self.clearCacheView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.describleView.bottom);
        make.left.equalTo(self.container_UIView);
        make.right.equalTo(self.container_UIView);
        make.height.equalTo(50.0);
    }];
    [self.aboutLudeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.clearCacheView.bottom);
        make.left.equalTo(self.container_UIView);
        make.right.equalTo(self.container_UIView);
        make.height.equalTo(50.0);
    }];
//    [self.exitLudeView  mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.aboutLudeView.bottom);
//        make.left.equalTo(self.container_UIView);
//        make.right.equalTo(self.container_UIView);
//        make.height.equalTo(50.0);
//    }];
    
    [self.exit_UIButton makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.aboutLudeView.bottom).with.offset(26.0);
        make.left.equalTo(self.container_UIView.left).with.offset(15.0);
        make.right.equalTo(self.container_UIView.right).with.offset(-15.0);
        make.height.equalTo(40.0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *	@brief	是否接受推送 点击事件
 */
- (void)receiveOrNot:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    
    Userinfo *user = [NTAccount shareAccount].userinfo;
    NSString *userId = user.userId;
    NSString *isPushStr = user.isPush;
 
    if ([isPushStr isEqualToString:@"1"])
    {
        isPushStr =@"2";
    }
    else
    {
        isPushStr = @"1";
    }
    
    
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    
    [apis PostUpdateUserInfoPishUserId:userId isPush:isPushStr andCompletion:^(id objectRet, NSError *errorRes)
     {
        if (objectRet)
        {
            NSString *statusStr =[NSString stringWithFormat:@"%@", [objectRet objectForKey:@"status"]];
            if ( [statusStr isEqualToString:@"1"])
            {
                
                NSString *isPushStr =[NSString stringWithFormat:@"%@", [[objectRet objectForKey:@"data"] objectForKey:@"isPush"]];
                
                if ([isPushStr isEqualToString:@"1"])
                {
                
                    
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"You have closed the system to receive messages", nil)];
                }
                
                Userinfo *item = [Userinfo objectWithKeyValues:[objectRet objectForKey:@"data"]];
                [[NTAccount shareAccount] setUserinfo:item];
                
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }

        }
    }];    
}
/**
 *	@brief	使用说明 点击事件
 */
-(void)useTips
{
    InstructionViewController *instruction = [[InstructionViewController alloc] initWithStoryboardID:@"InstructionViewController"];
    [self.navigationController pushViewController:instruction animated:YES];
}
/**
 *	@brief	清除缓存 点击事件
 */
-(void)clearCacheClicked
{
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil/*NSLocalizedString(@"Alert", nil)*/ message:NSLocalizedString(@"Clear Data", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    alertView.tag = 101;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0)
        {//取消
            
        }
        else
        {//确定
            [SVProgressHUD show];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            
        }

    }
    else
    {
        if (buttonIndex ==1)
        {
            Userinfo *user = [NTAccount shareAccount].userinfo;
            
            LLNetApiBase *apis =[[LLNetApiBase alloc]init];
            [apis PostUserInfoLogoutUserId:user.userId andCompletion:^(id objectRet, NSError *errorRes)
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
                         [[NTAccount shareAccount] exitLogin];
                         
                         NSMutableArray  *messages;
                         messages = [[NSMutableArray alloc] init];
                         [[NTAccount shareAccount] setMessages:messages];
                         
                         LoginViewController *loginView = [[LoginViewController alloc] initWithStoryboardID:@"LoginViewController"];
                         loginView.initialInfo = NO;
                         [self.navigationController pushViewController:loginView animated:YES ];
                     }
                     else
                     {
                        [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                     }
                 }
             }];
        }

    }
}
-(void)delayMethod
{
  [SVProgressHUD dismiss];
  UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Reminder", nil) message:NSLocalizedString(@"Cache has been cleared", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alertView show];
}

/**
 *	@brief	关于鹿得 点击事件
 */
-(void)aboutLudeClicked
{
    NSLog(@"关于鹿得");
    AboutLudeViewController *about = [[AboutLudeViewController alloc] initWithStoryboardID:@"AboutLudeViewController"];
    [self.navigationController pushViewController:about animated:YES];
}


/**
 *	@brief	关于鹿得 点击事件
 */
-(void)exitLudeClicked
{
    NSLog(@"退出登录");
//    AboutLudeViewController *about = [[AboutLudeViewController alloc] initWithStoryboardID:@"AboutLudeViewController"];
//    [self.navigationController pushViewController:about animated:YES];
    
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Are you sure you want to log out", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alertView show];
    
}


#pragma mark - getter
//界面元素的getter方法初始化

-(UIScrollView *)myScrollView_UIScrollView
{
    if (_myScrollView_UIScrollView == nil)
    {
        _myScrollView_UIScrollView = [[UIScrollView alloc] init];
        [_myScrollView_UIScrollView setBackgroundColor:RGBCOLOR(236.0, 237.0, 237.0)];
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
        [_container_UIView setBackgroundColor:[UIColor clearColor]];
    }
    return _container_UIView;
}

-(UIView *)messageView
{
    if (_messageView == nil) {
        _messageView = [[UIView alloc] init];
        [_messageView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE13], [UIColor blackColor],_messageView);
        [titleText setText:NSLocalizedString(@"New message Alert", nil)];
        [titleText sizeToFit];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView.left).with.offset(23.0);
            make.centerY.equalTo(_messageView);
        }];
        UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"blueBar"]];
        [_messageView addSubview:bar];
        [bar setUserInteractionEnabled:YES];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView.left);
            make.top.equalTo(_messageView).with.offset(5.0);
            make.size.equalTo(CGSizeMake(4.0, 30.0));
        }];
        
        UIButton *setBtn = UIButtonInitFrmPrt(CGRectZero, _messageView);
        [setBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [setBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateSelected];
        Userinfo *user = [NTAccount shareAccount].userinfo;
        NSString *isPushStr = user.isPush;
        if ([isPushStr isEqualToString:@"1"])
        {//推
            setBtn.selected = NO;
        }
        else
        {
             setBtn.selected = YES;
        }
        
        [setBtn addTarget:self action:@selector(receiveOrNot:) forControlEvents:UIControlEventTouchUpInside];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_messageView).with.offset(-10.0);
            make.size.equalTo(CGSizeMake(50.0, 30.0));
            make.centerY.equalTo(_messageView);
        }];

    }
    
    return _messageView;
}

-(UIView *)describleView
{
    if (_describleView == nil) {
        _describleView = [[UIView alloc] init];
        [_describleView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_describleView);
        [titleText setText:NSLocalizedString(@"Instruction", nil)];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_describleView.left).with.offset(23.0);
            make.centerY.equalTo(_describleView);
            make.size.equalTo(CGSizeMake(100.0, 21.0));
        }];
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"messageline"]];
        [_describleView addSubview:line];
        [line setUserInteractionEnabled:YES];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_describleView);
            make.right.equalTo(_describleView);
            make.height.equalTo(1.0);
            make.bottom.equalTo(_describleView).with.offset(-1.0);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"rightArrow"]];
        [_describleView addSubview:arrow];
        [arrow setUserInteractionEnabled:YES];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_describleView.right).with.offset(-15.0);
            make.centerY.equalTo(_describleView);
            make.size.equalTo(CGSizeMake(8.0, 13.0));
        }];
        
        UIButton *describleBtn = UIButtonInitFrmPrt(CGRectZero, _describleView);
        [describleBtn addTarget:self action:@selector(useTips) forControlEvents:UIControlEventTouchUpInside];
        [describleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_describleView);
        }];

    }
    return _describleView;
}

-(UIView *)clearCacheView
{
    if (_clearCacheView == nil) {
        _clearCacheView = [[UIView alloc] init];
        [_clearCacheView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_clearCacheView);
        [titleText setText:NSLocalizedString(@"Clear Data", nil)];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_clearCacheView.left).with.offset(23.0);
            make.centerY.equalTo(_clearCacheView);
            make.size.equalTo(CGSizeMake(100.0, 21.0));
        }];
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"messageline"]];
        [_clearCacheView addSubview:line];
        [line setUserInteractionEnabled:YES];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_clearCacheView);
            make.right.equalTo(_clearCacheView);
            make.height.equalTo(1.0);
            make.bottom.equalTo(_clearCacheView).with.offset(-1.0);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"rightArrow"]];
        [_clearCacheView addSubview:arrow];
        [arrow setUserInteractionEnabled:YES];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_clearCacheView.right).with.offset(-15.0);
            make.centerY.equalTo(_clearCacheView);
            make.size.equalTo(CGSizeMake(8.0, 13.0));
        }];
        
        UIButton *clearCacheBtn = UIButtonInitFrmPrt(CGRectZero, _clearCacheView);
        [clearCacheBtn addTarget:self action:@selector(clearCacheClicked) forControlEvents:UIControlEventTouchUpInside];
        [clearCacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_clearCacheView);
        }];
    }
    return _clearCacheView;
}
-(UIView *)aboutLudeView
{
    if (_aboutLudeView == nil) {
        _aboutLudeView = [[UIView alloc] init];
        [_aboutLudeView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_aboutLudeView);
        [titleText setText:NSLocalizedString(@"About HONSUN", nil)];
        [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_aboutLudeView.left).with.offset(23.0);
            make.centerY.equalTo(_aboutLudeView);
            make.size.equalTo(CGSizeMake(100.0, 21.0));
        }];
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"messageline"]];
        [_aboutLudeView addSubview:line];
        [line setUserInteractionEnabled:YES];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_aboutLudeView);
            make.right.equalTo(_aboutLudeView);
            make.height.equalTo(1.0);
            make.bottom.equalTo(_aboutLudeView).with.offset(-1.0);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"rightArrow"]];
        [_aboutLudeView addSubview:arrow];
        [arrow setUserInteractionEnabled:YES];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_aboutLudeView.right).with.offset(-15.0);
            make.centerY.equalTo(_aboutLudeView);
            make.size.equalTo(CGSizeMake(8.0, 13.0));
        }];
        
        UIButton *aboutBtn = UIButtonInitFrmPrt(CGRectZero, _aboutLudeView);
        [aboutBtn addTarget:self action:@selector(aboutLudeClicked) forControlEvents:UIControlEventTouchUpInside];
        [aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_aboutLudeView);
        }];
    }
    return _aboutLudeView;
}

//-(UIView *)exitLudeView
//{
//     if (_exitLudeView == nil) {
//         _exitLudeView = [[UIView alloc] init];
//         [_exitLudeView setBackgroundColor:[UIColor whiteColor]];
//         UILabel *titleText = LabelInitZeroFrm([UIFont systemFontOfSize:FONTSIZE15], [UIColor blackColor],_exitLudeView);
//         [titleText setText:@"退出登录"];
//         [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.left.equalTo(_exitLudeView.left).with.offset(23.0);
//             make.centerY.equalTo(_exitLudeView);
//             make.size.equalTo(CGSizeMake(100.0, 21.0));
//         }];
//         UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"messageline"]];
//         [_exitLudeView addSubview:line];
//         [line setUserInteractionEnabled:YES];
//         [line mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.left.equalTo(_exitLudeView);
//             make.right.equalTo(_exitLudeView);
//             make.height.equalTo(1.0);
//             make.bottom.equalTo(_exitLudeView).with.offset(-1.0);
//         }];
//         
//         UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"rightArrow"]];
//         [_exitLudeView addSubview:arrow];
//         [arrow setUserInteractionEnabled:YES];
//         [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.right.equalTo(_exitLudeView.right).with.offset(-15.0);
//             make.centerY.equalTo(_exitLudeView);
//             make.size.equalTo(CGSizeMake(8.0, 13.0));
//         }];
//         
//         UIButton *exitBtn = UIButtonInitFrmPrt(CGRectZero, _exitLudeView);
//         [exitBtn addTarget:self action:@selector(exitLudeClicked) forControlEvents:UIControlEventTouchUpInside];
//         [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//             make.edges.equalTo(_exitLudeView);
//         }];
//     }
//    return _exitLudeView;
//}

-(UIButton *)exit_UIButton
{
    if (_exit_UIButton == nil) {
        _exit_UIButton = UIButtonInitFrm(CGRectZero, @"exitBtnBack", nil, self.container_UIView);
        ButtonSetTitle(_exit_UIButton, NSLocalizedString(@"LOG OUT", nil), [UIColor whiteColor], [UIFont systemFontOfSize:FONTSIZE18]);
        [_exit_UIButton addTarget:self action:@selector(exitLudeClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exit_UIButton;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    //注册通知事件
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"JKSideSlipShow" object:nil userInfo:nil];
//}

@end

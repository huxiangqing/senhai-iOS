//
//  AddFriendsViewController.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/12.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "ScanCodeViewController.h"
#import "AddFriendsCell.h"
#import "AddFriendSucceessViewController.h"

@interface AddFriendsViewController ()<UINavigationControllerDelegate>
{
    BOOL fristBOOL;
    BOOL secondBOOL;
}
//记录查找出来的好友
@property (strong, nonatomic) IBOutlet UILabel *lblAddFriend;
@property (strong, nonatomic) IBOutlet UILabel *lblScan;
@property (strong ,nonatomic)NSDictionary *dict;
@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblAddFriend setText:NSLocalizedString(@"Discover Friend", nil)];
    [_phoneTF setPlaceholder:NSLocalizedString(@"Mobile Contacts", nil)];
    [_lblScan setText:NSLocalizedString(@"Scan", nil)];
    
    // Do any additional setup after loading the view.
    self.navigationController.delegate =self;

    [self.phoneTF addDoneOnKeyboardWithTarget:self action:@selector(keyboardWillHide:)];
    
    //监听键盘收起
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTF resignFirstResponder];
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)keyboardWillHide:(NSNotification*)notification
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    NSString *userIdStr =[NSString stringWithFormat:@"%@",item.userId];
    
    if ([Tools isValidateMobile:self.phoneTF.text])
    {
        AJServerApis *apis =[[AJServerApis alloc]init];
        [apis getUserInfoByPhone:self.phoneTF.text userId:userIdStr Completion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"3"])
                 {
                     fristBOOL = YES;
                     _dict =[NSDictionary dictionaryWithDictionary:[objectRet objectForKey:@"data"]];
                     
                     [_friendsTable reloadData];
                 }
                 else
                 {
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:otherAction];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
 
             }
        }];
    }
    else
    {
         [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please enter the correct cell phone number", nil)];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dict count]>0)
    {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"AddFriendsCell";
    
    AddFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[AddFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    
    if ([_dict count]>0)
    {
      [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[_dict objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"morentouxiang-67"]];
      cell.nameLable.text =[NSString stringWithFormat:@"%@",[_dict objectForKey:@"realName"]];
    }
   
   
    

    WeakObject(self);
    cell.acceptBtnSelected = ^(NSInteger itemIndex)
    {
        __strong typeof(self) strongSelf = __weakObject;
     
        if (strongSelf)
        {
            //添加好友点击事件
            [strongSelf createAddFriend];
        }
        else
        {
            return ;
        }
    };
    
    if (fristBOOL == YES)
    {
        fristBOOL = NO;
    }
    else
    {
        secondBOOL = YES;
        [cell.addFriendButton setBackgroundImage:[UIImage imageNamed:@"code_Disabled"] forState:UIControlStateNormal];
    }
    
    
    return cell;

}

-(void)createAddFriend
{
    if (secondBOOL == YES)
    {
        return;
    }
    
    Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *friendIdStr =[NSString stringWithFormat:@"%@",[_dict objectForKey:@"userId"]];
    
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis PostSaveVerificationMessageAppUserId:item.userId friendsId:friendIdStr andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *otherAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:otherAction];
             [self presentViewController:alertController animated:YES completion:nil];
             
             [_friendsTable reloadData];
         }
    }];
}

/**
 *	@brief	返回按钮 点击事件
 */
- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *	@brief	扫一扫 点击事件
 */
- (IBAction)scanCodes:(UIButton *)sender
{
    ScanCodeViewController *scan = [[ScanCodeViewController alloc] initWithStoryboardID:@"ScanCodeViewController"];
    [self.navigationController pushViewController:scan animated:YES];
}
@end

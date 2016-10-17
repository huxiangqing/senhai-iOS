//
//  FriendsDetailsViewController.m
//  LUDE
//
//  Created by bluemobi on 15/12/4.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "FriendsDetailsViewController.h"
#import "FriendsDetailsTableViewCell.h"
#import "TrendsTextView.h"
#import "FriendsHistoryViewController.h"

@interface FriendsDetailsViewController ()<UITextViewDelegate,UINavigationControllerDelegate>
{
    float height;
    BOOL _wasKeyboardManagerEnabled;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
//表格
@property (weak, nonatomic) IBOutlet UITableView *FD_TableView;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//父亲
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
//圆环
@property (strong, nonatomic) IBOutlet UIView *ringView;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//血压
@property (weak, nonatomic) IBOutlet UILabel *BPLabel;
//心跳
@property (weak, nonatomic) IBOutlet UILabel *heartbeatLabel;
//脉压差
@property (weak, nonatomic) IBOutlet UILabel *poorLabel;

@property (strong ,nonatomic)NSMutableArray *friendDetailsMarr;
@property (strong, nonatomic) IBOutlet UILabel *lblHart;
@property (strong, nonatomic) IBOutlet UILabel *lblPulse;
@property (strong, nonatomic) IBOutlet UILabel *lblAllMessage;

@property (strong, nonatomic) IBOutlet UILabel *lblBlood;
//输入框背景
@property (strong ,nonatomic)UIView *trendsView;
//输入框背景
@property (strong ,nonatomic)TrendsTextView *textView ;
@end

@implementation FriendsDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_titleLable setText:NSLocalizedString(@"My Friend", nil)];
     [_lblBlood setText:NSLocalizedString(@"BP", nil)];
     [_lblHart setText:NSLocalizedString(@"PUL", nil)];
     [_lblPulse setText:NSLocalizedString(@"PP", nil)];
     [_lblAllMessage setText:NSLocalizedString(@"Message All", nil)];
    self.navigationController.delegate =self;
    _FD_TableView.rowHeight = UITableViewAutomaticDimension;
    _FD_TableView.layer.masksToBounds =YES;
    _FD_TableView.layer.cornerRadius =10;
    height=0;
    
    [self createData];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.titleLable.text =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"realName"]];
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
-(void)createUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    _trendsView =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.heightValue-40, self.view.widthValue, 40)];
    _trendsView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_trendsView];
    [self.view insertSubview:_FD_TableView belowSubview:_trendsView];
    
    _textView = [TrendsTextView getTrendsTextView];
    _textView.delegate =self;
    [_trendsView addSubview:_textView];
    [_textView upward]; //选择向上弹
    _textView.frame = CGRectMake(20, 5, _trendsView.widthValue-60, 30);
    //设置边框
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIButton *sendOutBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sendOutBtn.frame =CGRectMake(_textView.leftValue+_textView.widthValue, 0, 40, 40);

    [sendOutBtn setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [sendOutBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    sendOutBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [sendOutBtn addTarget:self action:@selector(SendOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_trendsView addSubview:sendOutBtn];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[_friendsDetailsDict objectForKey:@"userPic"]] placeholderImage:[UIImage imageNamed:@"xin-morentouxiang"]];
    _nameLabel.text =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"realName"]];
    _phoneNumLabel.text =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"phone"]];
    
    if ([self.ringView viewWithTag:1000]) {
        [[self.ringView viewWithTag:1000]  removeFromSuperview];
    }
    UIView *gcView =  [[GCView alloc] initGCViewWithBounds:CGRectMake(0, 0,_ringView.widthValue, _ringView.heightValue) FromColor:[Tools colorFromHealthIndex:[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"healthNumber"]]] ToColor:[UIColor whiteColor] LineWidth:4.0 withPercent:[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"healthNumber"]] adjustFont:NO];
    gcView.tag = 1000;
    [self.ringView addSubview:gcView];
    
    _timeLabel.text =[NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"Date_C",nil),[_friendsDetailsDict objectForKey:@"measureTime"]];
    _BPLabel.text =[NSString stringWithFormat:@"%@/%@",[_friendsDetailsDict objectForKey:@"bloodPressureClose"],[_friendsDetailsDict objectForKey:@"bloodPressureOpen"]];
    _BPLabel.textColor = [Tools colorFromSPValue:[[_friendsDetailsDict objectForKey:@"bloodPressureClose"] integerValue] DSPValue:[[_friendsDetailsDict objectForKey:@"bloodPressureOpen"] integerValue]];
    _heartbeatLabel.text =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"pulse"]];
    _poorLabel.text =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"bloodPressureDiffer"]];
}


#define mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//键盘展示
-(void)keyboardShow:(NSNotification *)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _trendsView.topValue = self.view.heightValue -40-kbSize.height;
    

}
//键盘收起
-(void)keyboardHide:(NSNotification *)aNotification
{
    _trendsView.topValue = self.view.heightValue - 40;
}

//发送
-(void)SendOutBtnClick:(UIButton *)sender
{
    [_textView resignFirstResponder];
     _trendsView.topValue = self.view.heightValue-40;
    Userinfo *item = [NTAccount shareAccount].userinfo;
    NSString *contentStr =_textView.text;
    _textView.text = @"";
    
    if (contentStr.length <= 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"The contents you sent can not be empty", nil)];
    }
    else
    {
        LLNetApiBase *apis =[[LLNetApiBase alloc]init];
        [apis PostSaveFriendsMessageAppUserId:item.userId messageContent:contentStr myFriendsId:_friendsId andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 
                 if ([statusStr isEqualToString:@"1"])
                 {
                     [self createData];
                 }
                 else
                 {
                     [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                 }

             }
        }];
    }
}

-(void)createData
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    AJServerApis *apsi =[[AJServerApis alloc]init];
    [apsi GetMyFriendsWithFriendId:_friendsId  userId:item.userId andCompletion:^(id objectRet, NSError *errorRes)
    {
        if (objectRet)
        {
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                _friendDetailsMarr =[NSMutableArray arrayWithArray:[objectRet objectForKey:@"data"]];
                [_FD_TableView reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }

        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendDetailsMarr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsDetailsTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"FriendsDetailsTableViewCell"];
    if (cell == nil)
    {
        cell =[[FriendsDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendsDetailsTableViewCell"];
    }
    cell.speakLabel.text =[NSString stringWithFormat:@"%@%@%@%@：", [[_friendDetailsMarr objectAtIndex:indexPath.row]objectForKey:@"friendsRealName"], NSLocalizedString(@"IN", nil) ,[[_friendDetailsMarr objectAtIndex:indexPath.row]objectForKey:@"messageTime"],NSLocalizedString(@"Message from",  nil)];
    cell.contentLabel.text =[NSString stringWithFormat:@"%@", [[_friendDetailsMarr objectAtIndex:indexPath.row]objectForKey:@"messageContent"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 按钮点击事件
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//打电话
- (IBAction)PhoneBtnClick:(id)sender
{
    NSString *_startPhone =[NSString stringWithFormat:@"%@",[_friendsDetailsDict objectForKey:@"phone"]];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_startPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
  
}
- (IBAction)FriendsHistoryBtnClick:(id)sender
{
    FriendsHistoryViewController *friends=[[FriendsHistoryViewController alloc]initWithStoryboardID:@"FriendsHistoryViewController"];
    friends.friendId = _friendsId;
    [self.navigationController pushViewController:friends animated:YES];
    
}


@end

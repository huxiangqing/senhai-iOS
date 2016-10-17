//
//  FriendsMessageViewController.m
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "FriendsMessageViewController.h"
#import "messageCell.h"
#import "MessageDetailViewController.h"
#import "MessageTableViewCell.h"
#import "AnimationView.h"
#import "PressureDataModel.h"
#import "MJDIYHeader.h"
#import "MJDIYBackFooter.h"

@interface FriendsMessageViewController ()<UINavigationControllerDelegate>
{
    BOOL addFriendBOOL;
}
@property (strong ,nonatomic)NSMutableArray *friendsMarr;
@property (strong ,nonatomic)NSString *pageNoStr;
@property (strong ,nonatomic)NSString *pageCountStr;

@property (nonatomic ,strong)NSMutableArray *messageArray;

@end

@implementation FriendsMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_titleLable setText:NSLocalizedString(@"New Friend", nil)];
    self.navigationController.delegate =self;
    [self Initialization];

    //上拉刷新下拉加载
    [self MJView];
    
    if ([[NTAccount shareAccount] Messages]) {
        self.messageArray = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
    }
    else
    {
        self.messageArray = [[NSMutableArray alloc] init];
    }

    if (self.messageArray.count > 0) {
        if (self.type == SystemM)
        {
//            for (LUDEMessage *Mess in self.messageArray) {
//                if ([Mess.PushType isEqualToString:@"3"]) {
//                    [self.messageArray removeObject:Mess];
//                }
//            }
            for (NSString *Mess in self.messageArray) {
                if ([Mess isEqualToString:@"3"]) {
                    [self.messageArray removeObject:Mess];
                }
            }

        }
        else if (self.type == FriendsM)
        {
//            for (LUDEMessage *Mess in self.messageArray) {
//                if ([Mess.PushType isEqualToString:@"4"]) {
//                    [self.messageArray removeObject:Mess];
//                }
//            }
            for (NSString *Mess in self.messageArray) {
                if ([Mess isEqualToString:@"4"]) {
                    [self.messageArray removeObject:Mess];
                }
            }
        }
        else
        {
//            for (LUDEMessage *Mess in self.messageArray) {
//                if ([Mess.PushType isEqualToString:@"1"]) {
//                    [self.messageArray removeObject:Mess];
//                }
//            }
            for (NSString *Mess in self.messageArray) {
                if ([Mess isEqualToString:@"1"]) {
                    [self.messageArray removeObject:Mess];
                }
            }
        }
    }
    [[NTAccount shareAccount] setMessages:self.messageArray];
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
    [_addFriendsTable.header beginRefreshing];
}

-(void)MJView
{
    _addFriendsTable.header = [MJDIYHeader headerWithRefreshingBlock:^
                        {
                            [self createheader];
                        }];
    
    
    _addFriendsTable.footer = [MJDIYBackFooter footerWithRefreshingBlock:^
                        {
                            [self createfooter];
                        }];
    
    
    
}
-(void)createheader
{
    _pageNoStr = @"1";
    if ([_typeStr isEqualToString:@"0"])
    {//好友请求
        [self createAddFriend];
    }
    else if ([_typeStr isEqualToString:@"1"])
    {//留言消息
        [self createSee];
    }
    else
    {//系统消息
        [self createData];
    }
    // 马上进入刷新状态
    [_addFriendsTable.header endRefreshing];
    
}

-(void)createfooter
{
    
    if ([_pageNoStr isEqualToString:_pageCountStr])
    {
        
        AnimationView *view = [[AnimationView alloc]initWithFrame:CGRectMake(self.view.widthValue/2.0-60, self.view.heightValue-100, 120, 30)];
        [self.view addSubview:view];
        
    }
    else
    {
        //加1
        _pageNoStr = [NSString stringWithFormat:@"%d",[_pageNoStr intValue]+1];
        //刷新数据
        if ([_typeStr isEqualToString:@"0"])
        {//好友请求
            [self createAddFriend];
        }
        else if ([_typeStr isEqualToString:@"1"])
        {//留言消息
            [self createSee];
        }
        else
        {//系统消息
            [self createData];
        }
    }
 
    [_addFriendsTable.footer endRefreshing];
}
-(void)createSee
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetFriendsMessageListAppUserId:item.userId pageNo:_pageNoStr pageSize:@"20" andCompletion:^(id objectRet, NSError *errorRes)
    {
        if (objectRet)
        {
            if ([_pageNoStr isEqualToString:@"1"])
            {
                [_friendsMarr removeAllObjects];
            }
            
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                NSArray *arr=[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                for (int i = 0; i < [arr count]; i++)
                {
                    [_friendsMarr addObject:arr[i]];
                }
                
                _pageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
                
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }
            
            [ _addFriendsTable reloadData];
        }
      
    }];
    
}

-(void)createAddFriend
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetVerificationMessageListAppUserId:item.userId pageNo:_pageNoStr pageSize:@"20" andCompletion:^(id objectRet, NSError *errorRes)
    {
        if (objectRet)
        {
            if ([_pageNoStr isEqualToString:@"1"])
            {
                [_friendsMarr removeAllObjects];
            }
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                addFriendBOOL = YES;
                NSArray *arr=[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                for (int i = 0; i < [arr count]; i++)
                {
                    [_friendsMarr addObject:arr[i]];
                }
                
                _pageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
            }
            else
            {
                if (addFriendBOOL == YES)
                {
                    
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                }
                
            }
            
            [ _addFriendsTable reloadData];
         }
       
    }];
}

-(void)Initialization
{
    // 设置标题名称
    self.titleLable.text = self.titleText;
    _pageNoStr =@"1";
    _friendsMarr =[[NSMutableArray alloc]init];
}

-(void)createData
{
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetSysMessageByListPageNo:_pageNoStr userId:item.userId pageSize:@"20" andCompletion:^(id objectRet, NSError *errorRes)
    {
        
        if (objectRet)
        {
            if ([_pageNoStr isEqualToString:@"1"])
            {
                [_friendsMarr removeAllObjects];
            }
            
            NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
            if ([statusStr isEqualToString:@"1"])
            {
                NSArray *arr=[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                for (int i = 0; i < [arr count]; i++)
                {
                    [_friendsMarr addObject:arr[i]];
                }
                
                _pageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
                
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
            }
            
            [ _addFriendsTable reloadData];
        }
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return [_friendsMarr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == SystemM)
    {
        static NSString *identifier = @"messageCell";
        messageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[messageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                    ];
        }
        cell.type = self.type;

        cell.messageDate.text =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"createTime"]];
        cell.contentLable.text =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageName"]];
        
        return cell;
    }
    else if (self.type == FriendsM)
    {
        static NSString *identifier = @"messageCell";
        messageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[messageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                    ];
        }
        cell.type = self.type;

    
        cell.messageDate.text =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"createTime"]];
        cell.contentLable.text =[NSString stringWithFormat:@"%@%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"realName"],NSLocalizedString(@"Ask to add you as a friend", nil)];
        [cell.contentLable setAdjustsFontSizeToFitWidth:YES];
        [cell.okButton setTitle:NSLocalizedString(@"Agree", @"同意") forState:UIControlStateNormal];
        cell.okButton.tag = 100+indexPath.row;
         [cell.okButton addTarget:self action:@selector(OKBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
        if (cell == nil)
        {
            cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageTableViewCell"];
        }
        //取消
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
      cell.nameToseeLabel.text =[NSString stringWithFormat:@"%@%@%@%@：",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"friendsRealName"], NSLocalizedString(@"IN", nil),[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageTime"], NSLocalizedString(@"Message from", nil)];
        CGRect txtFrame = cell.nameToseeLabel.frame;
        cell.nameToseeLabel.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,txtFrame.size.height =[cell.nameToseeLabel.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                                                                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.nameToseeLabel.font,NSFontAttributeName, nil] context:nil].size.height);
        
       cell.linesImgeView.topValue = cell.nameToseeLabel.topValue+cell.nameToseeLabel.heightValue+10;

       cell.messageLabel.topValue = cell.linesImgeView.topValue + cell.linesImgeView.heightValue+6;
   
       cell.messageLabel.text =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageContent"]];
        //药品名
        txtFrame =  cell.messageLabel.frame;
        cell.messageLabel.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
                                         txtFrame.size.height =[ cell.messageLabel.text boundingRectWithSize:
                                                                CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                              attributes:[NSDictionary dictionaryWithObjectsAndKeys: cell.messageLabel.font,NSFontAttributeName, nil] context:nil].size.height);
        
        cell.backView.heightValue = cell.messageLabel.topValue + cell.messageLabel.heightValue+20;
        
        
       
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != SystemM&&self.type != FriendsM)
    {
        
        UILabel *nameToSeeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-60, 0)];
        nameToSeeLabel.font =[UIFont systemFontOfSize:14];
        nameToSeeLabel.numberOfLines=3;
        nameToSeeLabel.text =[NSString stringWithFormat:@"%@%@%@%@：",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"friendsRealName"],NSLocalizedString(@"IN", nil),[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageTime"],NSLocalizedString(@"Message from", nil)];
      
        //药品名
        CGRect txtFrame = nameToSeeLabel.frame;
        nameToSeeLabel.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,txtFrame.size.height =[nameToSeeLabel.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                                                                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:nameToSeeLabel.font,NSFontAttributeName, nil] context:nil].size.height);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,  SCREENWIDTH - 70, 0)];
        label.font =[UIFont systemFontOfSize:15];
        label.text =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageContent"]];
        //药品名
        txtFrame = label.frame;
        label.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
                                        txtFrame.size.height =[label.text boundingRectWithSize:
                                                               CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil].size.height);
        label.numberOfLines=3;
       
        return 62+label.heightValue+nameToSeeLabel.heightValue;
        
    }
    else
    {
        return 100;
    }
 
}

-(void)OKBtnClick:(UIButton *)sender
{
    

   NSString *messageIdStr =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:sender.tag-100]objectForKey:@"messageId"]];
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    [apis PostSaveVerificationMessageAgreeAppMessageId:messageIdStr andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Alert", nil) message:[objectRet objectForKey:@"msg"]delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                 [alertView show];
                 
                 [self createAddFriend];
             }
             else
             {
                 [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
             }
         }
       
        }
     ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.type == SystemM)
    {
        MessageDetailViewController *Detail = [[MessageDetailViewController alloc] initWithStoryboardID:@"MessageDetailViewController"];
        Detail.typeMessage = self.type;
        Detail.messageIdStr =[NSString stringWithFormat:@"%@",[[_friendsMarr objectAtIndex:indexPath.row]objectForKey:@"messageId"]];
        [self.navigationController pushViewController:Detail animated:YES];
    }
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

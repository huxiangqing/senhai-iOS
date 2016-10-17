//
//  MessageCenterViewController.m
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MessageCenterViewController.h"

#import "MessageCenterTableViewCell.h"
#import "FriendsMessageViewController.h"
#import "JPUSHService.h"
#import "PressureDataModel.h"

@interface MessageCenterViewController ()<UINavigationControllerDelegate>
{
    NSArray *imageName;
    NSArray *titleName;
}
@property (nonatomic ,strong)NSMutableArray *messageArray;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleInfo;
@property (nonatomic ,assign)BOOL cellforOneBOOL;
@property (nonatomic ,assign)BOOL cellforTwoBOOL;
@property (nonatomic ,assign)BOOL cellforThreeBOOL;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [_lblTitleInfo setText:NSLocalizedString(@"MESSAGE CENTER", nil)];
    self.navigationController.delegate =self;
    self.cellforOneBOOL = self.cellforTwoBOOL = self.cellforThreeBOOL = NO;
    
    imageName = @[@"addMe",@"messageMe",@"systemMe"];
    titleName = @[NSLocalizedString(@"New Friend", nil),NSLocalizedString(@"Message", nil),NSLocalizedString(@"Notification", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedApns:) name:@"apns" object:nil];
    if ([[NTAccount shareAccount] Messages]) {
        self.messageArray = [[NSMutableArray alloc] initWithArray:[[NTAccount shareAccount] Messages]];
    }
    else
    {
        self.messageArray = [[NSMutableArray alloc] init];
    }
    [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
        //        *stop = YES;
        //        if (*stop == YES) {
        
        if ([Mess isEqualToString:@"4"]) {
            self.cellforOneBOOL = YES;
        }
        else if ([Mess isEqualToString:@"1"])
        {
            self.cellforTwoBOOL = YES;
        }
        else if ([Mess isEqualToString:@"3"])
        {
            self.cellforThreeBOOL = YES;
        }
        // }
        [self.messageTable_UITableView reloadData];
    }];

//    [self.messageArray enumerateObjectsUsingBlock:^(LUDEMessage *Mess, NSUInteger idx, BOOL *stop) {
//        //        *stop = YES;
//        //        if (*stop == YES) {
//
//        if ([Mess.PushType isEqualToString:@"4"]) {
//            self.cellforOneBOOL = !Mess.read.boolValue;
//        }
//        else if ([Mess.PushType isEqualToString:@"1"])
//        {
//            self.cellforTwoBOOL = !Mess.read.boolValue;
//        }
//        else if ([Mess.PushType isEqualToString:@"3"])
//        {
//            self.cellforThreeBOOL = !Mess.read.boolValue;
//        }
//        // }
//        [self.messageTable_UITableView reloadData];
//    }];
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
-(void)didReceivedApns:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    NSString *str = [userInfo valueForKey:@"pushType"]; //推送显示的内容
    
    if ([str isEqualToString:@"4"])
    {
        self.cellforOneBOOL = YES;
    }
    else if ([str isEqualToString:@"1"])
    {
        self.cellforTwoBOOL = YES;
    }
    else if ([str isEqualToString:@"3"])
    {
        self.cellforThreeBOOL = YES;
    }
    
    [self.messageTable_UITableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MessageCenterTableViewCell";
    
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MessageCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    [cell.iconImage setImage:[UIImage imageNamed:imageName[indexPath.row]]];
    [cell.titleName setText:titleName[indexPath.row]];
    
    if (indexPath.row == 0)
    {
        cell.redOriginImageView.hidden = !self.cellforOneBOOL;
    }
    else if (indexPath.row == 1)
    {
        cell.redOriginImageView.hidden = !self.cellforTwoBOOL;
    }
    else
    {
        cell.redOriginImageView.hidden = !self.cellforThreeBOOL;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsMessageViewController *friendsM = [[FriendsMessageViewController alloc] initWithStoryboardID:@"FriendsMessageViewController"];
    
    WeakObject(self);
    if (indexPath.row == 0)
    {
        friendsM.type = FriendsM;
        friendsM.typeStr = @"0";
        friendsM.titleText = NSLocalizedString(@"New Friend", nil);
        self.cellforOneBOOL = NO;
        
//        [self.messageArray enumerateObjectsUsingBlock:^(LUDEMessage *Mess, NSUInteger idx, BOOL *stop) {
//            if ([Mess.PushType isEqualToString:@"4"]) {
//                //                *stop = YES;
//                //                if (*stop == YES) {
//                [__weakObject.messageArray removeObject:Mess];
//                //  }
//            }
//        }];
        [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
            if ([Mess isEqualToString:@"4"]) {
                //                *stop = YES;
                //                if (*stop == YES) {
                [__weakObject.messageArray removeObject:Mess];
                //  }
            }
        }];

    }
    else if (indexPath.row == 1)
    {
        friendsM.type = LeaveM;
        friendsM.typeStr = @"1";
        friendsM.titleText = NSLocalizedString(@"Message", nil);
        self.cellforTwoBOOL = NO;
//        [self.messageArray enumerateObjectsUsingBlock:^(LUDEMessage *Mess, NSUInteger idx, BOOL *stop) {
//            if ([Mess.PushType isEqualToString:@"1"]) {
//                //                *stop = YES;
//                //                if (*stop == YES) {
//                [__weakObject.messageArray removeObject:Mess];
//                //    }
//            }
//        }];
        [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
            if ([Mess isEqualToString:@"1"]) {
                //                *stop = YES;
                //                if (*stop == YES) {
                [__weakObject.messageArray removeObject:Mess];
                //  }
            }
        }];
    }
    else
    {
        friendsM.type = SystemM;
        friendsM.typeStr = @"2";
        friendsM.titleText = NSLocalizedString(@"Notification", nil);
        self.cellforThreeBOOL = NO;
//        [self.messageArray enumerateObjectsUsingBlock:^(LUDEMessage *Mess, NSUInteger idx, BOOL *stop) {
//            if ([Mess.PushType isEqualToString:@"3"]) {
//                //                *stop = YES;
//                //                if (*stop == YES) {
//                [__weakObject.messageArray removeObject:Mess];
//                //     }
//            }
//        }];
        [self.messageArray enumerateObjectsUsingBlock:^(NSString *Mess, NSUInteger idx, BOOL *stop) {
            if ([Mess isEqualToString:@"3"]) {
                //                *stop = YES;
                //                if (*stop == YES) {
                [__weakObject.messageArray removeObject:Mess];
                //  }
            }
        }];
    }
    
    [[NTAccount shareAccount] setMessages:self.messageArray];
    
    [self.messageTable_UITableView reloadData];
    
    if ((!self.cellforOneBOOL)&&(!self.cellforTwoBOOL)&&(!self.cellforThreeBOOL))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redOriginHidden" object:nil];
    }
    
    [self.navigationController pushViewController:friendsM animated:YES];
}

//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.messageTable_UITableView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}
- (IBAction)returnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//     [super viewWillDisappear:animated];
//    //注册通知事件
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"JKSideSlipShow" object:nil userInfo:nil];
//}

@end

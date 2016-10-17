//
//  ScreeningViewController.m
//  LUDE
//
//  Created by bluemobi on 15/10/10.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "ScreeningViewController.h"
#import "ScreeningTableViewCell.h"

@interface ScreeningViewController ()<UINavigationControllerDelegate>
//筛选条件数组
@property (strong ,nonatomic) NSArray *timeArr;
//筛选条件
@property (nonatomic ,copy)NSString *screenType;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleName;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;

@end

@implementation ScreeningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_lblTitleName setText:NSLocalizedString(@"SELECT DATA", nil)];
    [_lblSelectTime setText:NSLocalizedString(@"Time Interval", nil)];
    [_btnOk setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    self.navigationController.delegate =self;
    //初始化
    [self Initialization];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}
#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
//界面内容初始化
-(void)Initialization
{
    _timeArr =[NSArray arrayWithObjects:NSLocalizedString(@"Week", nil),NSLocalizedString(@"Two Weeks", nil),NSLocalizedString(@"A Month", nil),NSLocalizedString(@"Two Months", nil), nil];
    
    self.screenType = [[NTAccount shareAccount ] ScreenType];
    
    NSIndexPath *selected = [NSIndexPath
                          indexPathForRow:(self.screenType.integerValue -1) inSection:0];
    [self.screenTableView selectRowAtIndexPath:selected
                           animated:YES
                     scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark  UITabeViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreeningTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ScreeningTableViewCell"];
    if (cell == nil)
    {
        cell =[[ScreeningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScreeningTableViewCell"];
    }
    
    cell.timeLabel.font =[UIFont systemFontOfSize:15];
    cell.timeLabel.textColor =[UIColor blackColor];
    cell.timeLabel.text=_timeArr[indexPath.row];
    cell.okImageView.hidden = YES;
    cell.backImageView.image =[UIImage imageNamed:@"cellhui"];

    if (indexPath.row == (self.screenType.integerValue - 1))
    {
        cell.timeLabel.textColor =[UIColor colorWithRed:0 green:0.6581647 blue:0.940235294 alpha:1];
        cell.timeLabel.font =[UIFont systemFontOfSize:17];
        cell.backImageView.image =[UIImage imageNamed:@"cellbai"];
        cell.okImageView.hidden = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScreeningTableViewCell *cell =(ScreeningTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.timeLabel.textColor =[UIColor colorWithRed:0 green:0.6581647 blue:0.940235294 alpha:1];
    cell.timeLabel.font =[UIFont systemFontOfSize:17];
    cell.backImageView.image =[UIImage imageNamed:@"cellbai"];
    cell.okImageView.hidden = NO;
    self.screenType = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    [_screenTableView reloadData];
    
}
#pragma mark - 按钮点击事件
- (IBAction)ReturnBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SureBtnClick:(UIButton *)sender
{
    [[NTAccount shareAccount] setScreenType:self.screenType];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

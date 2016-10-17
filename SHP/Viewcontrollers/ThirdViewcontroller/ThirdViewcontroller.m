//
//  ThirdViewcontroller.m
//  LUDE
//
//  Created by bluemobi on 15/12/1.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "ThirdViewcontroller.h"
#import "ThirdTableViewCell.h"
#import "ThirdDetailsViewController.h"
#import "MJDIYBackFooter.h"
#import "MJDIYHeader.h"

@interface ThirdViewcontroller ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnSuggestion;
@property (strong, nonatomic) IBOutlet UIButton *btnPressure;
@property (strong, nonatomic) IBOutlet UIButton *btnGlucose;

//按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *informationArr;
//选择线
@property (weak, nonatomic) IBOutlet UIView *linesView;
//滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
//滚动视图
@property (weak, nonatomic) IBOutlet UIView *backView;
//日常建议
@property (strong ,nonatomic)UITableView *fristTableView;
//血压建议
@property (strong ,nonatomic)UITableView *secondTableView;
//血糖建议
@property (strong ,nonatomic)UITableView *thridTableView;

@property (strong ,nonatomic)NSString *fristPageNoStr;
@property (strong ,nonatomic)NSString *fristpageCountStr;
@property (strong ,nonatomic)NSMutableArray *firstMarr;

@property (strong ,nonatomic)NSString *secondPageNoStr;
@property (strong ,nonatomic)NSString *secondpageCountStr;
@property (strong ,nonatomic)NSMutableArray *secondMarr;

@property (strong ,nonatomic)NSString *thirdPageNoStr;
@property (strong ,nonatomic)NSString *thirdpageCountStr;
@property (strong ,nonatomic)NSMutableArray *thirdMarr;

@property (strong ,nonatomic)NSString *typeStr;

@end

@implementation ThirdViewcontroller

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [_btnSuggestion setTitle:NSLocalizedString(@"Daily Advices", nil) forState:UIControlStateNormal];
    [_btnPressure setTitle:NSLocalizedString(@"Blood Pressure Advices", nil) forState:UIControlStateNormal];
    [_btnGlucose setTitle:NSLocalizedString(@"Blood Glucose Advices", nil) forState:UIControlStateNormal];
    
     [self InitializationUI];

    [self MJView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate =self;
    
    [MobClick beginLogPageView:@"健康资讯"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"健康资讯"];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)MJView
{
    _fristTableView.header = [MJDIYHeader headerWithRefreshingBlock:^
                                 {
                                     [self createheader];
                                 }];
    
    
    _fristTableView.footer = [MJDIYBackFooter footerWithRefreshingBlock:^
                                 {
                                     [self createfooter];
                                 }];
    [_fristTableView.header beginRefreshing];
    //
    _secondTableView.header = [MJDIYHeader headerWithRefreshingBlock:^
                              {
                                  [self createheader];
                              }];
    
    _secondTableView.footer = [MJDIYBackFooter footerWithRefreshingBlock:^
                              {
                                  [self createfooter];
                              }];

    _thridTableView.header = [MJDIYHeader headerWithRefreshingBlock:^
                              {
                                  [self createheader];
                              }];
    
    _thridTableView.footer = [MJDIYBackFooter footerWithRefreshingBlock:^
                              {
                                  [self createfooter];
                              }];

}

-(void)createheader
{
     _fristPageNoStr = @"1";
    
    [self createDataPageNo:@"1" type:_typeStr];
    
    if ([_typeStr isEqualToString:@"1"])
    {
        _fristPageNoStr = @"1";
        // 马上进入刷新状态
        [_fristTableView.header endRefreshing];
    }
    else if ([_typeStr isEqualToString:@"2"])
    {
        _secondPageNoStr = @"1";
        [_secondTableView.header endRefreshing];
    }
    else
    {
        _thirdPageNoStr =@"1";
        [_thridTableView.header endRefreshing];
    }
    
}

-(void)createfooter
{
    if ([_typeStr isEqualToString:@"1"])
    {
        if ([_fristPageNoStr isEqualToString:_fristpageCountStr])
        {
            AnimationView *view = [[AnimationView alloc]initWithFrame:CGRectMake(self.view.widthValue/2-60, self.view.heightValue-100, 120, 30)];
            [self.view addSubview:view];
        }
        else
        {
            //加1
            _fristPageNoStr = [NSString stringWithFormat:@"%d",[_fristPageNoStr intValue]+1];
            //刷新数据
            [self createDataPageNo:_fristpageCountStr type:@"1"];
        }

        // 马上进入刷新状态
        [_fristTableView.footer endRefreshing];
    }
    else if ([_typeStr isEqualToString:@"2"])
    {
        if ([_secondPageNoStr isEqualToString:_secondpageCountStr])
        {
            AnimationView *view = [[AnimationView alloc]initWithFrame:CGRectMake(self.view.widthValue/2-60, self.view.heightValue-100, 120, 30)];
            [self.view addSubview:view];
        }
        else
        {
            //加1
            _secondPageNoStr = [NSString stringWithFormat:@"%d",[_secondPageNoStr intValue]+1];
            //刷新数据
            [self createDataPageNo:_secondPageNoStr type:@"2"];
        }
        
        // 马上进入刷新状态
        [_secondTableView.footer endRefreshing];
    }
    else
    {
        
        if ([_thirdPageNoStr isEqualToString:_thirdpageCountStr])
        {
            AnimationView *view = [[AnimationView alloc]initWithFrame:CGRectMake(self.view.widthValue/2-60, self.view.heightValue-100, 120, 30)];
            [self.view addSubview:view];
        }
        else
        {
            //加1
            _thirdPageNoStr = [NSString stringWithFormat:@"%d",[_thirdPageNoStr intValue]+1];
            //刷新数据
            [self createDataPageNo:_thirdPageNoStr type:@"3"];
        }
        
        [_thridTableView.footer endRefreshing];
    }
    
    
    
   
}
-(void)createDataPageNo:(NSString *)pageNoStr type:(NSString *)type
{
    AJServerApis *apis =[[AJServerApis alloc]init];
    [apis GetArticleInfoByListPageNo:pageNoStr pageSize:@"20" type:type andCompletion:^(id objectRet, NSError *errorRes)
    {
        if (objectRet)
        {
            if ([type isEqualToString:@"1"])
            {//日常建议
                
                if ([pageNoStr isEqualToString:@"1"])
                {
                    [_firstMarr removeAllObjects];
                }
                
                NSString *status =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                if ([status isEqualToString:@"1"])
                {
                    NSArray *arr =[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                    for (int i = 0; i < [arr count]; i++)
                    {
                        [_firstMarr addObject:arr[i]];
                    }
                    _fristpageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                }
                
                [_fristTableView reloadData];
                
            }
            else if ([type isEqualToString:@"2"])
            {//血压建议
                if ([pageNoStr isEqualToString:@"1"])
                {
                    [_secondMarr removeAllObjects];
                }
                NSString *status =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                if ([status isEqualToString:@"1"])
                {
                    NSArray *arr =[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                    for (int i = 0; i < [arr count]; i++)
                    {
                        [_secondMarr addObject:arr[i]];
                    }
                    _secondpageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                }
                
                [_secondTableView reloadData];
            }
            else
            {//血糖建议
                if ([pageNoStr isEqualToString:@"1"])
                {
                    [_thirdMarr removeAllObjects];
                }
                
                NSString *status =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                if ([status isEqualToString:@"1"])
                {
                    
                    NSArray *arr =[NSArray arrayWithArray:[objectRet objectForKey:@"data"]];
                    for (int i = 0; i < [arr count]; i++)
                    {
                        [_thirdMarr addObject:arr[i]];
                    }
                    _thirdpageCountStr =[NSString stringWithFormat:@"%@",[[objectRet objectForKey:@"page"]objectForKey:@"pageCount"]];
                    
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[objectRet objectForKey:@"msg"]];
                }
                
                [_thridTableView reloadData];
            }
        }
    }];
}

-(void)InitializationUI
{
    
    _typeStr = @"1";
    _firstMarr=[[NSMutableArray alloc]init];
    _secondMarr =[[NSMutableArray alloc]init];
    _thirdMarr =[[NSMutableArray alloc]init];
    
    
    
    _fristTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.widthValue, self.view.heightValue-64-49-50) style:UITableViewStylePlain];
    _fristTableView.delegate =self;
    _fristTableView.dataSource =self;
    _fristTableView.backgroundColor =[UIColor clearColor];
    _fristTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_fristTableView];
    
    _secondTableView =[[UITableView alloc]initWithFrame:CGRectMake(self.view.widthValue, 0, self.view.widthValue, self.view.heightValue-64-49-50) style:UITableViewStylePlain];
    _secondTableView.delegate =self;
    _secondTableView.dataSource =self;
    _secondTableView.backgroundColor =[UIColor clearColor];
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_secondTableView];
    
    _thridTableView =[[UITableView alloc]initWithFrame:CGRectMake(2*self.view.widthValue,0, self.view.widthValue,self.view.heightValue-64-49-50) style:UITableViewStylePlain];
    _thridTableView.delegate =self;
    _thridTableView.dataSource =self;
    _thridTableView.backgroundColor =[UIColor clearColor];
    _thridTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backView addSubview:_thridTableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fristTableView == tableView)
    {
        return [_firstMarr count];
    }
    else if (_secondTableView == tableView)
    {
         return [_secondMarr count];
    }
    else
    {
         return [_thirdMarr count];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdTableViewCell"];
    if (!cell)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil];
        cell = [array lastObject];
    }
    cell.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_fristTableView == tableView)
    {
        
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[[_firstMarr objectAtIndex:indexPath.row]objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"xin-morenjiazaitu"]];
        cell.titleLabel.text =[NSString stringWithFormat:@"%@",[[_firstMarr objectAtIndex:indexPath.row]objectForKey:@"title"]];
        cell.timeLabel.text =[NSString stringWithFormat:@"%@",[[_firstMarr objectAtIndex:indexPath.row]objectForKey:@"createTime"]];
        cell.contentLabel.text=[NSString stringWithFormat:@"%@",[[_firstMarr objectAtIndex:indexPath.row]objectForKey:@"summary"]];
        
       
    }
    else if (_secondTableView == tableView)
    {
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[[_secondMarr objectAtIndex:indexPath.row]objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"xin-morenjiazaitu"]];
        cell.titleLabel.text =[NSString stringWithFormat:@"%@",[[_secondMarr objectAtIndex:indexPath.row]objectForKey:@"title"]];
        cell.timeLabel.text =[NSString stringWithFormat:@"%@",[[_secondMarr objectAtIndex:indexPath.row]objectForKey:@"createTime"]];
        cell.contentLabel.text=[NSString stringWithFormat:@"%@",[[_secondMarr objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    }
    else
    {
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[[_thirdMarr objectAtIndex:indexPath.row]objectForKey:@"picUrl"]] placeholderImage:[UIImage imageNamed:@"xin-morenjiazaitu"]];
        cell.titleLabel.text =[NSString stringWithFormat:@"%@",[[_thirdMarr objectAtIndex:indexPath.row]objectForKey:@"title"]];
        cell.timeLabel.text =[NSString stringWithFormat:@"%@",[[_thirdMarr objectAtIndex:indexPath.row]objectForKey:@"createTime"]];
        cell.contentLabel.text=[NSString stringWithFormat:@"%@",[[_thirdMarr objectAtIndex:indexPath.row]objectForKey:@"summary"]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    ThirdDetailsViewController *details =[[ThirdDetailsViewController alloc]initWithStoryboardID:@"ThirdDetailsViewController"];
    if (tableView == _fristTableView)
    {
        details.articleIdStr = [NSString stringWithFormat:@"%@",[[_firstMarr objectAtIndex:indexPath.row]objectForKey:@"articleId"]];
    }
    else if (tableView == _secondTableView)
    {
         details.articleIdStr = [NSString stringWithFormat:@"%@",[[_secondMarr objectAtIndex:indexPath.row]objectForKey:@"articleId"]];
    }
    else
    {
         details.articleIdStr = [NSString stringWithFormat:@"%@",[[_thirdMarr objectAtIndex:indexPath.row]objectForKey:@"articleId"]];
    }
    [self.navigationController pushViewController:details animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.0;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int index = scrollView.contentOffset.x/self.view.widthValue;
//    
//    if ([scrollView isKindOfClass:[UITableView class]] )
//    {
//        return;
//    }
//    else
//    {
//        if (index == 1)
//       {   _typeStr = @"2";
//           SET_FRAME_X(_linesView, 15+FRAME_W(_linesView));
//            [_secondTableView.header beginRefreshing];
//        
//           
//       }
//       else if (index==2)
//       {   _typeStr = @"3";
//           SET_FRAME_X(_linesView, 25+2*FRAME_W(_linesView));
//            [_thridTableView.header beginRefreshing];
//         
//           
//       }
//       else
//       {   _typeStr = @"1";
//           SET_FRAME_X(_linesView, 5);
//            [_fristTableView.header beginRefreshing];
//       
//       }
//    }
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 按钮点击事件
- (IBAction)InformationBtnClick:(UIButton *)sender
{
    _linesView.centerXValue = sender.centerXValue;
    
    if (sender.tag == 101)
    {//日常
        _typeStr = @"1";
        
        [UIView animateWithDuration:0.4 animations:^{
             _backScrollView.contentOffset =CGPointMake(0, 0) ;
        }];
        if ([_firstMarr count]==0)
        {
             [_fristTableView.header beginRefreshing];
        }
       
        
    }
    else if (sender.tag == 102)
    {//血压
         _typeStr = @"2";
     
        [UIView animateWithDuration:0.4 animations:^{
             _backScrollView.contentOffset =CGPointMake(self.view.widthValue, 0);
        }];
        if ([_secondMarr count]==0)
        {
            [_secondTableView.header beginRefreshing];
        }
        
        
        
    }
    else
    {//血糖
         _typeStr = @"3";
        
        [UIView animateWithDuration:0.4 animations:^
        {
            _backScrollView.contentOffset =CGPointMake(2*self.view.widthValue, 0);

        }];
       
        if ([_thirdMarr count]==0)
        {
             [_thridTableView.header beginRefreshing];
        }
        
        
    }
}



@end

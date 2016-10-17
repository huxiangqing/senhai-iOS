//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import "InitInfoViewController.h"
#import "PressureDataModel.h"

@implementation MenuView
{
    BOOL selectBOOL;
}

+(instancetype)menuView
{
    MenuView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in nibView)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
        
    }
    //极光推送
    [[NSNotificationCenter defaultCenter] addObserver:result selector:@selector(didReceivedApns:) name:@"apns" object:nil];
    //监听通知事件
    [[NSNotificationCenter defaultCenter] addObserver:result
                                             selector:@selector(redOriginHidden:)
                                                 name:@"redOriginHidden" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:result
                                             selector:@selector(redOriginalAppear)
                                                 name:@"redOriginalAppear" object:nil];
    return result;
}


-(void)redOriginalAppear
{
    self.hasNew = YES;
    [self.myTableView reloadData];
}

//极光接收到数据时候调用的方法

-(void)redOriginHidden:(NSNotification *)info
{
    self.hasNew = NO;
    [self.myTableView reloadData];
}
-(void)didReceivedApns:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    NSString *str = [userInfo valueForKey:@"pushType"]; //推送显示的内容
    if (![str isEqualToString:@"2"])
    {
        self.hasNew = YES;
        [self.myTableView reloadData];
    }
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath
{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}
-(void)setItems:(NSArray *)items
{
    _items = items;
}


#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectBOOL = YES;
    [tableView reloadData];
    
    MenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_didSelectRowAtIndexPath)
    {
        _didSelectRowAtIndexPath(cell,indexPath);
    }
//    cell.backImageView.hidden = NO;
//    cell.greenLinesImageView.hidden = NO;
    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.myTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    cell.backImageView.hidden = YES;
    cell.greenLinesImageView.hidden = YES;
    cell.hasNewNoti.hidden = YES;
    cell.lable.text = [self.items[indexPath.row] objectForKey:@"title"];
    [cell.lable sizeToFit];
    //[cell.lable setAdjustsFontSizeToFitWidth:YES];
    cell.icon.image = [UIImage imageNamed:[self.items[indexPath.row] objectForKey:@"imagename"]];
    [cell.hasNewNoti setHidden:YES];
    
    if (indexPath.row == 1)
    {
        [cell.hasNewNoti setHidden:!self.hasNew];
    }
    
    return cell;
}


@end

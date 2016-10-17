//
//  XDPopoverListView.h
//  CMBCLoanReview
//
//  Created by xdforp on 14-11-26.
//  Copyright (c) 2014年 com.homelife.manager.mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XDPopoverListViewButtonBlock)();

@class XDPopoverListView;
@protocol XDPopoverListDatasource <NSObject>

- (NSInteger)popoverListView:(XDPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)popoverListView:(XDPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
-(CGFloat)popoverListView:(XDPopoverListView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XDPopoverListDelegate <NSObject>

@optional
- (void)popoverListView:(XDPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListView:(XDPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
@end


@interface XDPopoverListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id <XDPopoverListDelegate>delegate;
@property (nonatomic, retain) id <XDPopoverListDatasource>datasource;
@property (nonatomic, retain) UILabel *titleName;
@property (nonatomic, retain) NSString    *titleString;
@property (nonatomic, retain) UITableView *mainPopoverListView;    //主的选择列表视图

//展示界面
- (void)show;

//消失界面
- (void)dismiss;

//列表cell的重用
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath;            // returns nil if cell is not visible or index path is out of

//设置确定按钮的标题，如果不设置的话，不显示确定按钮
- (void)setDoneButtonWithTitle:(NSString *)aTitle block:(XDPopoverListViewButtonBlock)block;

//设置取消按钮的标题，不设置，按钮不显示
- (void)setCancelButtonTitle:(NSString *)aTitle block:(XDPopoverListViewButtonBlock)block;

//选中的列表元素
- (NSIndexPath *)indexPathForSelectedRow;

- (void)initTheInterface;

//
-(void)reloadTableView:(float)height;

- (id)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr;
@end

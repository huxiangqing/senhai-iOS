//
//  NewsItemsScrollView.h
//  Summary
//
//  Created by JHR on 15/12/23.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTHorizontalSelectionListDataSource;
@protocol HTHorizontalSelectionListDelegate;

@interface NewsItemsScrollView : UIView

@property (nonatomic) NSInteger selectedButtonIndex;

@property (nonatomic, weak) id<HTHorizontalSelectionListDataSource> dataSource;
@property (nonatomic, weak) id<HTHorizontalSelectionListDelegate> delegate;

@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, strong) UIColor *bottomTrimColor;

- (void)reloadData;

@end

@protocol HTHorizontalSelectionListDataSource <NSObject>

- (NSInteger)numberOfItemsInSelectionList:(NewsItemsScrollView *)selectionList;
- (NSString *)selectionList:(NewsItemsScrollView *)selectionList titleForItemWithIndex:(NSInteger)index;

@end

@protocol HTHorizontalSelectionListDelegate <NSObject>

- (void)selectionList:(NewsItemsScrollView *)selectionList didSelectButtonWithIndex:(NSInteger)index;

@end


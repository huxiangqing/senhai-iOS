//
//  NewsItemsScrollView.m
//  Summary
//
//  Created by JHR on 15/12/23.
//  Copyright © 2015年 huxq. All rights reserved.
//

#import "NewsItemsScrollView.h"

@interface NewsItemsScrollView ()<UIScrollViewDelegate>
{
    float btnFloat;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *selectionIndicatorBar;
@property (nonatomic, strong) UIView *bottomTrim;

@end


@implementation NewsItemsScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[Tools colorWithHexString:@"eee5d9" ]];
        [_scrollView addSubview:_contentView];
        
        _bottomTrim = [[UIView alloc] init];
        _bottomTrim.backgroundColor = [Tools colorWithHexString:@"b68f54"];
        [_contentView addSubview:_bottomTrim];
        
        _buttons = [NSMutableArray array];
        _selectionIndicatorBar = [[UIView alloc] init];
        _selectionIndicatorBar.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)reloadData {
    for (UIButton *button in self.buttons)
    {
        [button removeFromSuperview];
    }
    
    [self.selectionIndicatorBar removeFromSuperview];
    [self.buttons removeAllObjects];
    
    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];
    
    if (totalButtons < 1)
    {
        return;
    }
    
    NSString *str =[NSString stringWithFormat:@"%ld",totalButtons];
    
//    NSLog(@"[str floatValue] = %.1f",[str floatValue]);
    btnFloat =[str floatValue];
    
    if (totalButtons>=4)
    {
        btnFloat =4.0;
    }
    else
    {
        btnFloat =[str floatValue];
    }
    [self.contentView setFrame:CGRectMake(0, 0, (self.frame.size.width/btnFloat)*totalButtons, self.frame.size.height)];
    [self.scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    [self.bottomTrim setFrame:CGRectMake(0.0, self.frame.size.height-4.0, (self.frame.size.width/btnFloat), 2.0)];
    
    for (NSInteger index = 0; index < totalButtons; index++)
    {
        NSString *buttonTitle = [self.dataSource selectionList:self titleForItemWithIndex:index];
        UIButton *button = [self selectionListButtonWithTitle:buttonTitle WithIndex:index];
        if (index == 0) {
            [button setSelected:YES];
        }
         [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
    [self sendSubviewToBack:self.bottomTrim];
}


- (void)layoutSubviews {
    if (!self.buttons.count) {
        [self reloadData];
    }
    
    [super layoutSubviews];
}
#pragma mark - Private Methods

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle  WithIndex:(NSInteger)index
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[Tools colorWithHexString:@"b68f54"] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setFrame:CGRectMake((self.frame.size.width/btnFloat) * index,  0,self.frame.size.width/btnFloat , self.frame.size.height)];
    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setupSelectedButton:(UIButton *)selectedButton oldSelectedButton:(UIButton *)oldSelectedButton {

    
}

- (void)alignSelectionIndicatorWithButton:(UIButton *)button {
  
    
}

#pragma mark - Action Handlers

- (void)buttonWasTapped:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if (index != NSNotFound) {
        if (index == self.selectedButtonIndex) {
            return;
        }
        UIButton *oldSelectedButton = self.buttons[self.selectedButtonIndex];
        oldSelectedButton.selected = NO;
        self.selectedButtonIndex = index;
        UIButton *tappedButton = (UIButton *)sender;
        self.bottomTrim.frame = CGRectMake(tappedButton.frame.origin.x , self.bottomTrim.frame.origin.y, self.bottomTrim.frame.size.width, self.bottomTrim.frame.size.height);
        tappedButton.selected = YES;
        [self layoutIfNeeded];
        if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
            [self.delegate selectionList:self didSelectButtonWithIndex:index];
        }
    }
}

@end

//
//  HistoryVC.m
//  LUDE
//
//  Created by lord on 16/6/8.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "HistoryVC.h"
#import "SecondViewcontroller.h"
#import "HistoryBSVC.h"

@interface HistoryVC ()<UINavigationControllerDelegate>
{
    __weak IBOutlet UILabel *historyContentTitleLab;
    __weak IBOutlet UILabel *historyContentSubTitleLab;
    
    __weak IBOutlet UIButton *bpHisBtn;
}
@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    UIFont *font = [UIFont boldSystemFontOfSize:26.0];
    UIFontDescriptor *ctfFont = font. fontDescriptor ;
    NSNumber *fontString = [ctfFont objectForKey : @"NSFontSizeAttribute"];
    
    CGFloat calculateFontSize = [fontString doubleValue] * (bpHisBtn.widthValue/112.0);
    
    CGFloat fitFontSize = (calculateFontSize > [fontString doubleValue]) ? [fontString doubleValue] : calculateFontSize;
    
    historyContentTitleLab.font = [UIFont boldSystemFontOfSize:fitFontSize];
    [historyContentTitleLab sizeToFit];
    historyContentSubTitleLab.font = historyContentTitleLab.font;
    [historyContentSubTitleLab sizeToFit];
    
    
    [MobClick beginLogPageView:@"历史数据页"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    
    [MobClick endLogPageView:@"历史数据页"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate =self;
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoHIstoryDataView:(UIButton *)sender {
    
    if (sender.tag == 101) {
        
        [MobClick event:@"BPHistory"];
        SecondViewcontroller *bpHis = [[SecondViewcontroller alloc] initWithStoryboardID:@"SecondViewcontroller"];
        [self.navigationController pushViewController:bpHis animated:YES];
    }
    else
    {
        [MobClick event:@"BSHistory"];
        HistoryBSVC *bsHis = [[HistoryBSVC alloc] initWithSecondStoryboardID:@"HistoryBSVC"];
        [self.navigationController pushViewController:bsHis animated:YES];
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

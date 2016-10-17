//
//  FirstTopViewTableViewCell.h
//  LUDE
//
//  Created by lord on 16/5/23.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface FirstTopViewTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
{
    __weak IBOutlet UIImageView *ADDefaultView;
    __weak IBOutlet UIView *indexView;
    
    SDCycleScrollView *cycleScrollView;
    
    NSArray *adArray;
}

@property (nonatomic, copy) void (^oneADSelected)(NSString *linkUrl);
@property (nonatomic, copy) void (^whichBtnBeSelected)(NSInteger btnFlag);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)cellConfigData:(NSArray *)data;
-(void)cellConfigHealthIndexData:(NSString *)healthNumber;

@end

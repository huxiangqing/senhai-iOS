//
//  FirstTopViewTableViewCell.m
//  LUDE
//
//  Created by lord on 16/5/23.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "FirstTopViewTableViewCell.h"

@implementation FirstTopViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"FirstTopViewTableViewCell";
    FirstTopViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FirstTopViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    
    return cell;
}

-(void)cellConfigData:(NSArray *)data{
    if (data.count > 0) {
        adArray = data;
        NSMutableArray *adSourceArray = [[NSMutableArray alloc] init];
        
        for (ADModel *ad in adArray) {
            [adSourceArray addObject:ad.bannerPic];
        }
        // 网络加载图片的轮播器
        if (cycleScrollView == nil) {
            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150.0) delegate:self placeholderImage:[UIImage imageNamed:@"firstADDefault"]] ;
            
            [cycleScrollView setTag:1000];
            
            [self.contentView addSubview:cycleScrollView];
        }
        cycleScrollView.imageURLStringsGroup = adSourceArray;
    }
}

-(void)cellConfigHealthIndexData:(NSString *)healthNumber
{
    UIImage *tempImage = [UIImage imageNamed:@"HealthIndex"];
    CGFloat gcWidth  = (SCREENWIDTH - 3*10.0)/2.0 - indexView.leftValue*2;
    CGFloat gcHeight = tempImage.size.height - indexView.topValue - 3.0;
    
    GCView *existGCView = [indexView viewWithTag:1000];
    
    if (existGCView)
    {
        NSMutableString *percentString = [NSMutableString stringWithString:healthNumber];
        [percentString appendString:@"%"];
        
        if (![existGCView.percentLable.text isEqualToString:percentString])
        {
            [existGCView removeFromSuperview];
            
            GCView *gcView =  [[GCView alloc] initGCViewWithBounds:CGRectMake(0.0, 0.0, MIN(gcWidth, gcHeight),MIN(gcWidth, gcHeight) ) FromColor:[UIColor whiteColor] ToColor:[UIColor whiteColor] LineWidth:8.0 withPercent:healthNumber adjustFont:YES];
            gcView.tag = 1000;
            [indexView addSubview:gcView];
            
            gcView.centerXValue = gcWidth/2.0;
        }
    }
    else
    {
        GCView *gcView =  [[GCView alloc] initGCViewWithBounds:CGRectMake(0.0, 0.0, MIN(gcWidth, gcHeight),MIN(gcWidth, gcHeight) ) FromColor:[UIColor whiteColor] ToColor:[UIColor whiteColor] LineWidth:8.0 withPercent:healthNumber adjustFont:YES];
        gcView.tag = 1000;
        [indexView addSubview:gcView];
        
        gcView.centerXValue = gcWidth/2.0;
    }
}
- (IBAction)firstPageBtnBeSelected:(UIButton *)sender {
    self.whichBtnBeSelected(sender.tag);
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ADModel *ad = adArray[index];
    self.oneADSelected(ad.linkUrl);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

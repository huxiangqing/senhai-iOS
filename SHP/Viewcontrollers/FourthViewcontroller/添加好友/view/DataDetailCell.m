//
//  DataDetailCell.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/19.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "DataDetailCell.h"

@implementation DataDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backview.layer.cornerRadius = 8.0;
    self.backview.clipsToBounds      = YES;
}
-(void)createMarr:(NSMutableArray *)marr index:(long)index
{
    _timeLabel.text = [[marr objectAtIndex:index]objectForKey:@"measureTime"];
    NSString *bloodGlucoseValueStr =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"bloodGlucoseValue"]];
    if ([bloodGlucoseValueStr isEqualToString:@"0"])
    {
        _fastingLabel.text =@"-";
    }
    else
    {
      _fastingLabel.text =bloodGlucoseValueStr;
    }
    
    NSString *bloodGlucoseValueNoStr =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"bloodGlucoseValueNo"]];
    if ([bloodGlucoseValueNoStr isEqualToString:@"0"])
    {
         _noFastingLabel.text =@"-";
    }
    else
    {
//        _noFastingLabel.text =bloodGlucoseValueNoStr;
          _noFastingLabel.text =@"-";
    }
    
    NSString *bloodPressureOpenStr =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"bloodPressureOpen"]];
    if ([bloodPressureOpenStr isEqualToString:@"0"])
    {
        _bloodPressureLabel.text =@"-/-";
    }
    else
    {
        _bloodPressureLabel.text =[NSString stringWithFormat:@"%@/%@",[[marr objectAtIndex:index]objectForKey:@"bloodPressureClose"],[[marr objectAtIndex:index]objectForKey:@"bloodPressureOpen"]];
    }
      NSString *pulseStr =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"pulse"]];
    if ([pulseStr isEqualToString:@"0"])
    {
        _pulseLabel.text =@"-";
    }
    else
    {
         _pulseLabel.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"pulse"]];
    }
}

@end

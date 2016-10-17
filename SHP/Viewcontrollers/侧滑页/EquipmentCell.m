//
//  EquipmentCell.m
//  LUDE
//
//  Created by JHR on 15/10/14.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "EquipmentCell.h"

@implementation EquipmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)CreateMarr:(NSMutableArray *)marr index:(long)index
{
    //    if (indexPath.row == 1) {
    //
    
   NSString *equipmentTypeStr=[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"equipmentType"]];
    if ([equipmentTypeStr isEqualToString:@"1"])
    {//血压
        [_signBar setImage:[UIImage imageNamed:@"pressureBar"]];
        [_equipmentIcon setImage:[UIImage imageNamed:@"pressureIcon"]];
    }
    else
    {//血糖
        [_signBar setImage:[UIImage imageNamed:@"sugarBar"]];
        [_equipmentIcon setImage:[UIImage imageNamed:@"sugarIcon"]];
    }
    _equipmentName.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"equipmentNo"]];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_deleteBtn setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    self.backView.layer.cornerRadius = 8.0;
    self.backView.clipsToBounds      = YES;
}

@end

//
//  DrugCell.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "DrugCell.h"

@implementation DrugCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"DrugCell";
    DrugCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DrugCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }

    return cell;
}

-(void)cellWithData:(DrugDetailModel *)dataModel
{
    [self.drugImageIcon sd_setImageWithURL:[NSURL URLWithString:dataModel.image_url] placeholderImage:[UIImage imageNamed:@"firstItemDefault"]];
    [self.drugCompanyLabel setAdjustsFontSizeToFitWidth:YES];
    [self.drugCompanyLabel setText:dataModel.company];
    [self.durgNameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.durgNameLabel setText:dataModel.medication_name];
    [self.unitPriceLabel setAdjustsFontSizeToFitWidth:YES];
    [self.unitPriceLabel setText:[NSString stringWithFormat:@"¥：%@",dataModel.price]];
}


@end

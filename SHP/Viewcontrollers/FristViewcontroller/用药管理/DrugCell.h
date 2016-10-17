//
//  DrugCell.h
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationModel.h"

@interface DrugCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *drugImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *durgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *drugCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;


-(void)cellWithData:(DrugDetailModel *)dataModel;


@end

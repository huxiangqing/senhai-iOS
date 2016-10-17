//
//  ListOfCategoriesCell.h
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicationModel.h"

@interface ListOfCategoriesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *catagoryImage;
@property (weak, nonatomic) IBOutlet UILabel *catagoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *catagoryNumberLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)cellWithData:(MedicationCatalog *)dataModel;

@end

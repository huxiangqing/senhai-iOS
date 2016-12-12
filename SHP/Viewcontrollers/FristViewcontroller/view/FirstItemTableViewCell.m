//
//  FirstItemTableViewCell.m
//  LUDE
//
//  Created by lord on 16/4/11.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "FirstItemTableViewCell.h"

@implementation FirstItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView layoutIfNeeded];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"FirstItemTableViewCell";
    FirstItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FirstItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    
    return cell;
}

-(void)cellConfigData:(SuggestModel *)data
{
    if (data) {
        [newsIcon sd_setImageWithURL:[NSURL URLWithString:data.picUrl] placeholderImage:[UIImage imageNamed:@"firstItemDefault"]];
        [newsTitle setText:data.title];
        [newsContent setText:data.summary];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

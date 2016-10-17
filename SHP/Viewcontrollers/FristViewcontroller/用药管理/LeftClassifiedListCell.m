//
//  LeftClassifiedListCell.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "LeftClassifiedListCell.h"

@implementation LeftClassifiedListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"LeftClassifiedListCell";
    LeftClassifiedListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LeftClassifiedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.leftbarImage.hidden = !selected;
    self.classfieldNameLabel.textColor = selected ? [UIColor blueColor] : [UIColor darkTextColor];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
}

@end

//
//  PeripheralCell.m
//  BSBluetoothDemo
//
//  Created by JHR on 16/1/11.
//  Copyright © 2016年 huxq. All rights reserved.
//

#import "PeripheralCell.h"

@implementation PeripheralCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PeripheralCell";
    PeripheralCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PeripheralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  PeripheralCell.h
//  BSBluetoothDemo
//
//  Created by JHR on 16/1/11.
//  Copyright © 2016年 huxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeripheralCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *peripheralName_Label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

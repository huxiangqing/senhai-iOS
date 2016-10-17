//
//  FirstItemTableViewCell.h
//  LUDE
//
//  Created by lord on 16/4/11.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstItemTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *newsIcon;
    __weak IBOutlet UILabel *newsTitle;
    __weak IBOutlet UILabel *newsContent;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)cellConfigData:(SuggestModel *)data;

@end

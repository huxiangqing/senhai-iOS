//
//  ListOfCategoriesCell.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "ListOfCategoriesCell.h"

@implementation ListOfCategoriesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView layoutIfNeeded];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"ListOfCategoriesCell";
    ListOfCategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ListOfCategoriesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    
    return cell;
}
-(void)cellWithData:(MedicationCatalog *)dataModel
{
    NSString *firstLetter = [self transformCharacter:dataModel.catalog_name];
    //[self.catagoryImage setImage:[UIImage imageNamed:firstLetter]];
    [self.catagoryImage sd_setImageWithURL:[NSURL URLWithString:dataModel.image_url] placeholderImage:[UIImage imageNamed:@"firstItemDefault"]];
    [self.catagoryNameLabel setText:dataModel.catalog_name];
    [self.catagoryNumberLabel setText:[NSString stringWithFormat:@"共%@种",dataModel.count]];
}

//汉字转拼音之后，截取首字母，并大写
-(NSString *)transformCharacter:(NSString*)sourceStr
{
    //先将原字符串转换为可变字符串
    NSMutableString *ms = [NSMutableString stringWithString:sourceStr];
    
    if (ms.length) {
        //将汉字转换为拼音
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformToLatin, NO);
        //将拼音的声调去掉
        CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics,NO);
        //将字符串所有字母小写
        NSString *upStr = [ms lowercaseString];
        //截取首字母
        NSString *firstStr = [upStr substringToIndex:1];
        return firstStr;
    }
    return @"#";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

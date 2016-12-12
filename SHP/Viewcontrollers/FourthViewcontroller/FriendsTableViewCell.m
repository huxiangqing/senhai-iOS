//
//  FriendsTableViewCell.m
//  LUDE
//
//  Created by bluemobi on 15/12/3.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.contentView layoutIfNeeded];
    
    [_lblHealth setText:NSLocalizedString(@"Health Index",nil)];
    [_lblHart setText:NSLocalizedString(@"PUL",nil)];
    [_lblBlood setText:NSLocalizedString(@"BP",nil)];
    [_lblMaiYa setText:NSLocalizedString(@"PP",nil)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)friendMarr:(NSMutableArray *)marr index:(long)index
{
    if ([self.ringBackView viewWithTag:1000]) {
        [[self.ringBackView viewWithTag:1000]  removeFromSuperview];
    }
    UIView *gcView =  [[GCView alloc] initGCViewWithBounds:CGRectMake(0.0, 15.0, _ringView.widthValue, _ringView.heightValue) FromColor: [Tools colorFromHealthIndex:[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"healthNumber"]]] ToColor:[UIColor whiteColor] LineWidth:8.0 withPercent:[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"healthNumber"]] adjustFont:NO];
    gcView.tag = 1000;
    [self.ringBackView addSubview:gcView];
    
    [gcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ringBackView).with.offset(15.0);
        make.height.equalTo(70.0);
        make.width.equalTo(70.0);
        make.centerX.equalTo(self.ringBackView.centerX);
    }];
 
    [_headImageView sd_setImageWithURL:[[marr objectAtIndex:index] objectForKey:@"userPic"] placeholderImage:[UIImage imageNamed:@"xin-morentouxiang"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"realName"]];
    _bloodPressureLabel.text =[NSString stringWithFormat:@"%@/%@",[[marr objectAtIndex:index] objectForKey:@"bloodPressureClose"],[[marr objectAtIndex:index] objectForKey:@"bloodPressureOpen"]];
    
   _bloodPressureLabel.textColor = [Tools colorFromSPValue:[[[marr objectAtIndex:index] objectForKey:@"bloodPressureClose"]integerValue] DSPValue:[[[marr objectAtIndex:index] objectForKey:@"bloodPressureOpen"]integerValue]];
    
    _heartbeatLabel.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"pulse"]];
    
    _pulseLabel.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"bloodPressureDiffer"]];
    _timeLabel.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index] objectForKey:@"measureTime"]];
}

@end

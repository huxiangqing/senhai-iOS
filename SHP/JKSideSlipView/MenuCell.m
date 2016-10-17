//
//  MenuCell.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
  
    if (highlighted==YES)
    {
        _backImageView.hidden = NO;
        _greenLinesImageView.hidden = NO;
    }
    else {
        _backImageView.hidden = YES;
        _greenLinesImageView.hidden = YES;
    }

}

@end

//
//  MessageTableViewCell.h
//  LUDE
//
//  Created by bluemobi on 15/11/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIView *backView;
@property (strong ,nonatomic)UIImageView *yellowImgeView;
@property (strong ,nonatomic)UILabel *nameToseeLabel;
@property (strong ,nonatomic)UIImageView *linesImgeView;
@property (strong ,nonatomic)UILabel *messageLabel;

@end

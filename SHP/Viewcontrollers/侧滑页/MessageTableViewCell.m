//
//  MessageTableViewCell.m
//  LUDE
//
//  Created by bluemobi on 15/11/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self CreatViews];
    }
    return self;
}

-(void)CreatViews
{
    if (!_backView)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backView =[[UIView alloc]initWithFrame:CGRectMake(15, 15, SCREENWIDTH-30, 100)];
        _backView.backgroundColor =[UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
        [self.contentView addSubview:_backView];
        
        _yellowImgeView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 4, 20)];
        _yellowImgeView.image =[UIImage imageNamed:@"yellowBar"];
        [_backView addSubview:_yellowImgeView];
        
        _nameToseeLabel =[[UILabel alloc]initWithFrame:CGRectMake(22, 10, _backView.widthValue-30, 20)];
        _nameToseeLabel.font =[UIFont systemFontOfSize:14];
        _nameToseeLabel.textColor =[UIColor darkGrayColor];
        _nameToseeLabel.numberOfLines = 3;
        [_backView addSubview:_nameToseeLabel];
        
        _linesImgeView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 40, _backView.widthValue-40, 1)];
        _linesImgeView.image =[UIImage imageNamed:@"messageline"];
        [_backView addSubview:_linesImgeView];
        
        _messageLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,_linesImgeView.topValue + _linesImgeView.heightValue+6, SCREENWIDTH - 70, 0)];
        _messageLabel.font =[UIFont systemFontOfSize:15];
        _messageLabel.textColor =[UIColor blackColor];
        _messageLabel.numberOfLines = 3;
        [_backView addSubview:_messageLabel];

    }
}

//-(void)messageMarr:(NSMutableArray *)marr index:(long)index
//{
//   
//    _nameToseeLabel.text =[NSString stringWithFormat:@"%@在%@的留言：",[[marr objectAtIndex:index]objectForKey:@"friendsRealName"],[[marr objectAtIndex:index]objectForKey:@"messageTime"]];
//    //        cell.messageDate.font =[UIFont systemFontOfSize:14];
//    _messageLabel.text =[NSString stringWithFormat:@"%@",[[marr objectAtIndex:index]objectForKey:@"messageContent"]];
//    //药品名
//    CGRect txtFrame =  _messageLabel.frame;
//    _messageLabel.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
//                                         txtFrame.size.height =[ _messageLabel.text boundingRectWithSize:
//                                                                CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
//                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                                                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys: _messageLabel.font,NSFontAttributeName, nil] context:nil].size.height);
//
//    SET_FRAME_W(_backView, FRAME_MAX_Y(_messageLabel)+50);
//
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

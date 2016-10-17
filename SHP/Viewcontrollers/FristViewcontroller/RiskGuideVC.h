//
//  RiskGuideVC.h
//  LUDE
//
//  Created by lord on 16/4/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^startTestTheRisk)();

@interface RiskGuideVC : UIViewController

@property (nonatomic ,copy) startTestTheRisk testTheRisk ;

@end

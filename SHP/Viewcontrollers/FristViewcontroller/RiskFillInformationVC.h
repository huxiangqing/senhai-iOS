//
//  RiskFillInformationVC.h
//  LUDE
//
//  Created by lord on 16/4/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnTestTheRiskPage)(NSInteger page);
typedef void (^doneTestTheRiskPage)();

@interface RiskFillInformationVC : UIViewController
{
    @public
    __weak IBOutlet UIScrollView *infoScrollView;
}

@property (nonatomic ,copy) returnTestTheRiskPage returnRiskPage ;
@property (nonatomic ,copy) doneTestTheRiskPage doneRiskPage ;
@property (nonatomic ,strong) FirstDataModel *defaultData;

@end

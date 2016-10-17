//
//  DrugListVC.h
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrugListVC : UIViewController

@property (nonatomic ,copy) NSString *drugIdOrSearchString;
@property (nonatomic ,assign) BOOL isSearch;

@end

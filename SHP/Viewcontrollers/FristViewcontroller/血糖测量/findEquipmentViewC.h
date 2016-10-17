//
//  findEquipmentViewC.h
//  LUDE
//
//  Created by lord on 16/6/14.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findEquipmentViewC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *	@brief	区分血糖/血压
 */
@property (assign, nonatomic) BOOL isBSType;

@property (strong ,nonatomic)NSMutableArray *peripherals;

-(void)reloadTableView:(NSInteger)equipmentCoun;


@property (nonatomic, copy) void (^selectedPeripheral)(CBPeripheral *peripheral);


@end

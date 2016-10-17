//
//  findEquipmentViewC.m
//  LUDE
//
//  Created by lord on 16/6/14.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "findEquipmentViewC.h"
#import "MJDIYHeader.h"
#import "PeripheralInfo.h"
#import "PeripheralViewCell.h"

@interface findEquipmentViewC ()
{
    __weak IBOutlet UIButton *sureButton;
    
    __weak IBOutlet UIView *seachView;
    
    
}

@end

@implementation findEquipmentViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewSetRadius(seachView, 6.0, 1.0, [UIColor clearColor]);
//    UIViewSetRadius(sureButton, 6.0, 1.0, [UIColor clearColor]);
}
- (IBAction)iKonwnBtnClicked:(UIButton *)sender {
    
    [self.view removeFromSuperview];
    
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripherals.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.peripherals.count  == 0 ? 110.0:50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self groupTopView:tableView];
}

-(UIView *)groupTopView:(UITableView *)tableView
{
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH- 40.0, 0.0)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    //底线
    UIView *blueLinesView =[[UIView alloc]initWithFrame:CGRectMake(10, 49.0, backView.widthValue - 20.0, 1.0)];
    blueLinesView.backgroundColor =[Tools colorWithHexString:@"00D1A2"];
    
    //设备信息
    UILabel *allLabel =[[UILabel alloc]initWithFrame:CGRectMake(0.0, 10.0,  backView.widthValue ,40.0)];
    allLabel.font =[UIFont systemFontOfSize:18];
    allLabel.textColor =[UIColor blackColor];
    allLabel.text = @"设备列表";
    [allLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel *detailLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(0.0, allLabel.bottomValue+5.0,  backView.widthValue ,20.0)];
    detailLabel1.font =[UIFont systemFontOfSize:16];
    detailLabel1.textColor =[UIColor blackColor];
    [detailLabel1 setTextAlignment:NSTextAlignmentCenter];
    detailLabel1.text = @"未找到可用设备";
    UILabel *detailLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(0.0, detailLabel1.bottomValue+5.0,  backView.widthValue ,20.0)];
    detailLabel2.font =[UIFont systemFontOfSize:16];
    detailLabel2.textColor =[UIColor blackColor];
    [detailLabel2 setTextAlignment:NSTextAlignmentCenter];
    
    if(self.isBSType)
    {
        detailLabel2.text = @"请打开西恩血糖仪";
    }
    else
    {
        detailLabel2.text = @"请打开西恩血压仪";
    }
    
    if (self.peripherals.count  == 0) {
        [backView addSubview:detailLabel1];
        [backView addSubview:detailLabel2];
        
        backView.heightValue = 110.0;
        [sureButton setHidden:NO];
        
        [tableView setScrollEnabled:NO];
    }
    else
    {
        [backView addSubview:blueLinesView];
        
        backView.heightValue = 50.0;
        
        [sureButton setHidden:YES];
        
        [tableView setScrollEnabled:YES];
    }
    [backView addSubview:allLabel];
    
    blueLinesView.centerXValue = allLabel.centerXValue = detailLabel1.centerXValue = detailLabel2.centerXValue = tableView.centerXValue;
    
    return backView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PeripheralViewCell";
    PeripheralViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PeripheralViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier
                ];
    }
    CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
    [cell.peripheralLabel setText:peripheral.name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
    self.selectedPeripheral(peripheral);
    
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadTableView:(NSInteger)equipmentCount{
    NSInteger   popverHeight=equipmentCount*56+(self.peripherals.count  == 0 ? 110.0:50.0);
    NSInteger maxCount = (NSInteger)(self.view.heightValue - 50)/56;
    if (equipmentCount> maxCount) {
        popverHeight=maxCount*56+50;
    }
    
    if (equipmentCount == 0) {
        [self.tableView updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(popverHeight);
        }];
        popverHeight += 41.0;
    }
    else
    {
        [self.tableView updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(popverHeight);
        }];
    }
    
    [seachView updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(popverHeight);
    }];
    
    
    [self.tableView reloadData];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

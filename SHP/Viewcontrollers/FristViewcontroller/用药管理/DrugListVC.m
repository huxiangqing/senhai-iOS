//
//  DrugListVC.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "DrugListVC.h"
#import "DrugCell.h"
#import "DrugDetailVC.h"

#import "MedicationModel.h"

@interface DrugListVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *drugListTableView;

@property (nonatomic ,strong) NSArray *drugsArray;

@end

@implementation DrugListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.drugListTableView registerNib:[UINib nibWithNibName:@"DrugCell" bundle:nil] forCellReuseIdentifier:@"DrugCell"];
    self.navigationController.delegate = self;
    if (self.drugIdOrSearchString) {
        [self requestDrugsWith:self.drugIdOrSearchString];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)requestDrugsWith:(NSString *)drugString
{
    WeakObject(self);
    Userinfo *item = [NTAccount shareAccount].userinfo;
    
    if (!self.isSearch) {
        [AJServerApis GetMedicationInfoByCatalogIdWithUserId:item.userId catalogId:drugString andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     NSArray *dataArray = [DrugDetailModel objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                     __weakObject.drugsArray = [NSArray arrayWithArray:dataArray];
                     
                     [__weakObject.drugListTableView reloadData];
                 }
             }
         }];

    }
    else
    {
        [AJServerApis GetMedicationInfoSearchWithUserId:item.userId medicationName:drugString andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     NSArray *dataArray = [DrugDetailModel objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                     __weakObject.drugsArray = [NSArray arrayWithArray:dataArray];
                     
                     [__weakObject.drugListTableView reloadData];
                 }
             }
         }];
    }
}

/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.drugsArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DrugCell  *cell = [DrugCell cellWithTableView:tableView];
    [cell cellWithData:self.drugsArray[indexPath.row]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrugDetailVC *drugDetail = [[DrugDetailVC alloc] initWithSecondStoryboardID:@"DrugDetailVC"];
    DrugDetailModel *drugModel = self.drugsArray[indexPath.row];
    drugDetail.drugModel = drugModel;
    [self.navigationController pushViewController:drugDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

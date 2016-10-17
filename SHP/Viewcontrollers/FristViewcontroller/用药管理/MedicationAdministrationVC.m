//
//  MedicationAdministrationVC.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "MedicationAdministrationVC.h"
#import "LeftClassifiedListCell.h"
#import "ListOfCategoriesCell.h"
#import "DrugListVC.h"

#import "MedicationModel.h"

@interface MedicationAdministrationVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftCalssfieldTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightCatagoryTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *drugSearchBar;

@property (nonatomic ,strong) NSArray *firstLevelArray;
@property (nonatomic ,strong) NSArray *secondLevelArray;

@end

@implementation MedicationAdministrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.firstLevelArray = [[NSMutableArray alloc] init];
//    self.secondLevelArray = [[NSMutableArray alloc] init];
    self.navigationController.delegate = self;
    [self requsetForFirstList];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.drugSearchBar.text = @"";
}
-(void)requsetForFirstList
{
    WeakObject(self);
    Userinfo *item = [NTAccount shareAccount].userinfo;
    [AJServerApis GetMedicationCatalogByIdOrLevelWithUserId:item.userId andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 NSArray *dataArray = [MedicationCatalog objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                 __weakObject.firstLevelArray = [NSArray arrayWithArray:dataArray];
                 
                 [__weakObject.leftCalssfieldTableView reloadData];
                 
                 if (__weakObject.firstLevelArray.count > 0) {
                     NSIndexPath *selected = [NSIndexPath
                                              indexPathForRow:0 inSection:0];
                     [__weakObject.leftCalssfieldTableView selectRowAtIndexPath:selected animated:YES scrollPosition:UITableViewScrollPositionTop];
                     MedicationCatalog *firstCatalog = [__weakObject.firstLevelArray firstObject];
                     [__weakObject requsetForSecondList:firstCatalog.catalog_id];
                 }
             }
             
         }
     }];
}
-(void)requsetForSecondList:(NSString *)catalogId
{
    WeakObject(self);
    Userinfo *item = [NTAccount shareAccount].userinfo;
    [AJServerApis GetMedicationCatalogByIdOrLevelWithUserId:item.userId catalogId:catalogId andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet)
         {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             if ([statusStr isEqualToString:@"1"])
             {
                 NSArray *dataArray = [MedicationCatalog objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                 __weakObject.secondLevelArray = [NSArray arrayWithArray:dataArray];
                 
                 [__weakObject.rightCatagoryTableView reloadData];
             }
         }
     }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    
    [self searchDrugsWith:searchBar.text];
}

-(void)searchDrugsWith:(NSString *)searchString
{
    DrugListVC *drugList = [[DrugListVC alloc] initWithSecondStoryboardID:@"DrugListVC"];
    drugList.drugIdOrSearchString = searchString;
    drugList.isSearch = YES;
    [self.navigationController pushViewController:drugList animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableView isEqual:self.leftCalssfieldTableView] ? self.firstLevelArray.count : self.secondLevelArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.leftCalssfieldTableView]) {
       LeftClassifiedListCell  *cell = [LeftClassifiedListCell cellWithTableView:tableView];
        MedicationCatalog *firstCatalog = [self.firstLevelArray objectAtIndex:indexPath.row];
        cell.classfieldNameLabel.text = firstCatalog.catalog_name;
        
        return cell;
    }
    else
    {
        ListOfCategoriesCell *cell = [ListOfCategoriesCell cellWithTableView:tableView];
       
        [cell cellWithData:self.secondLevelArray[indexPath.row]];
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView isEqual:self.leftCalssfieldTableView] ? 55.0 : 75.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftCalssfieldTableView]) {
       MedicationCatalog *firstCatalog = [self.firstLevelArray objectAtIndex:indexPath.row];
        [self requsetForSecondList:firstCatalog.catalog_id];
    }
    else
    {
        MedicationCatalog *secondCatalog = [self.secondLevelArray objectAtIndex:indexPath.row];
        DrugListVC *drugList = [[DrugListVC alloc] initWithSecondStoryboardID:@"DrugListVC"];
        drugList.drugIdOrSearchString = secondCatalog.catalog_id;
        [self.navigationController pushViewController:drugList animated:YES];
    }
}




/**
 *	@brief	 返回按钮点击事件
 */
- (IBAction)ReturnBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

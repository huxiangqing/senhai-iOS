//
//  DrugDetailVC.m
//  LUDE
//
//  Created by lord on 16/6/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "DrugDetailVC.h"
#import "DrugCell.h"

@interface DrugDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *showWhichBtnSelectedView;

@property (weak, nonatomic) IBOutlet UIView *drugProfileView;

@property (weak, nonatomic) IBOutlet UIView *drugDetailsView;

@property (weak, nonatomic) IBOutlet UIView *relatedDrugsView;



@property (weak, nonatomic) IBOutlet UIWebView *drugDetailWeb;
@property (weak, nonatomic) IBOutlet UIWebView *drugProfileWeb;
@property (weak, nonatomic) IBOutlet UITableView *drugsTabelView;

@property (nonatomic ,strong) NSArray *drugsArray;

@end

@implementation DrugDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate =self;
    
    [self.drugsTabelView registerNib:[UINib nibWithNibName:@"DrugCell" bundle:nil] forCellReuseIdentifier:@"DrugCell"];
    
    [self requestDrugProfile];
    [self requestDrugDetail];
    [self requestDrugsWith:self.drugModel.medication_name];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}
-(void)requestDrugProfile
{
    NSString *profilestr=[NSString stringWithFormat:@"%@app/medication/showMedicationInfoSummary.htm?medication_id=%@",SERVER_DEMAIN,self.drugModel.medication_id];
    
    NSMutableURLRequest *profileRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:profilestr]];
    [profileRequest setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    
    [self.drugProfileWeb loadRequest:profileRequest];
}
-(void)requestDrugDetail
{
    NSString *detailstr=[NSString stringWithFormat:@"%@app/medication/showMedicationInfoContent.htm?medication_id=%@",SERVER_DEMAIN,self.drugModel.medication_id];
    
    NSMutableURLRequest *detailRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:detailstr]];
    [detailRequest setValue:[Tools currentLanguage] forHTTPHeaderField:@"lord-app-language"];
    
    [self.drugDetailWeb loadRequest:detailRequest];
}

-(void)requestDrugsWith:(NSString *)drugString
{
    WeakObject(self);
    Userinfo *item = [NTAccount shareAccount].userinfo;
   
        [AJServerApis GetMedicationInfoSearchWithUserId:item.userId medicationName:drugString andCompletion:^(id objectRet, NSError *errorRes)
         {
             if (objectRet)
             {
                 NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
                 if ([statusStr isEqualToString:@"1"])
                 {
                     NSArray *dataArray = [DrugDetailModel objectArrayWithKeyValuesArray:[objectRet objectForKey:@"data"]];
                     __weakObject.drugsArray = [NSArray arrayWithArray:dataArray];
                     
                     [__weakObject.drugsTabelView reloadData];
                 }
             }
         }];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
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

#pragma mark - getter
//界面元素的getter方法初始化

- (IBAction)btnClick:(UIButton *)sender {
    [self.showWhichBtnSelectedView setCenterXValue:sender.centerXValue];
    
    UIView *selectedView = [self.view viewWithTag:(sender.tag+1)*10];
    [self.view bringSubviewToFront:selectedView];
    
    switch (sender.tag) {
        case 0:
            [self.drugProfileView setHidden:NO];
            [self.drugDetailsView setHidden:YES];
            [self.relatedDrugsView setHidden:YES];
          
            break;
        case 1:
            [self.drugProfileView setHidden:YES];
            [self.drugDetailsView setHidden:NO];
            [self.relatedDrugsView setHidden:YES];
           
            break;
        case 2:
            [self.drugProfileView setHidden:YES];
            [self.drugDetailsView setHidden:YES];
            [self.relatedDrugsView setHidden:NO];
            break;
            
        default:
            break;
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

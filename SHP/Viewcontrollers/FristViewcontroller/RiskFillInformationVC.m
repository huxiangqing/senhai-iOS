//
//  RiskFillInformationVC.m
//  LUDE
//
//  Created by lord on 16/4/27.
//  Copyright © 2016年 胡祥清. All rights reserved.
//

#import "RiskFillInformationVC.h"

@interface RiskFillInformationVC ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UIPageControl *infoPageControl;
    
    __weak IBOutlet UILabel *issueLabel;
    __weak IBOutlet UILabel *doTitleLabel;
    __weak IBOutlet UILabel *summaryLabel;
    __weak IBOutlet UIButton *startBtn;
    
    __weak IBOutlet UITextField *nameTF;
    __weak IBOutlet UIButton *boyBTN;
    __weak IBOutlet UIButton *girlBTN;
    
    __weak IBOutlet UIImageView *sexAvatarFlag;
    __weak IBOutlet UITextField *ageTF;
    __weak IBOutlet UITextField *heightTF;
    __weak IBOutlet UITextField *weightTF;
    
    __weak IBOutlet UIImageView *thirdSexAvatar;
    __weak IBOutlet UIButton *smokeYES;
    __weak IBOutlet UIButton *smokeNO;
    __weak IBOutlet UIButton *DMyes;
    __weak IBOutlet UIButton *DMno;
    __weak IBOutlet UITextField *CHOLTF;
    
    __weak IBOutlet UITextField *SBPTF;
    __weak IBOutlet UITextField *DBPTF;
    __weak IBOutlet UITextField *BMPTF;
    
    __weak IBOutlet UILabel *scoreLabel;
    __weak IBOutlet UILabel *resultLabel;
    
    NSString *sex;
    BOOL smoke;
    BOOL DM;
}

@property (nonatomic ,strong)RiskFillInfoDataModel *fillInfoDataModel;
@property (nonatomic ,strong)Userinfo *userData;

@end

@implementation RiskFillInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fillInfoDataModel = [[RiskFillInfoDataModel alloc] init];
    self.userData = [NTAccount shareAccount].userinfo;
    [infoPageControl setHidden:YES];
    
    if ([self.userData.sex isEqualToString:@"2"]) {
       [self sexBTNDone:girlBTN];
    }
    else
    {
       [self sexBTNDone:boyBTN];
    }
    
    nameTF.text = self.userData.realName;
    ageTF.text =[NSString stringWithFormat:@"%ld",[Tools ageFromDate:self.userData.birthday]];
    weightTF.text = self.userData.weight;
    heightTF.text = self.userData.height;
    
    if (self.defaultData.bloodPressureCloseList.count > 0) {
        SBPTF.text = [NSString stringWithFormat:@"%@",self.defaultData.bloodPressureCloseList.lastObject];
    }
    if (self.defaultData.bloodPressureOpenList.count > 0) {
        DBPTF.text = [NSString stringWithFormat:@"%@",self.defaultData.bloodPressureOpenList.lastObject];
    }
    if (self.defaultData.pulse.length > 0) {
        BMPTF.text = self.defaultData.pulse;
    }
    
    [self smokeBtnSelected:smokeNO];
    [self DMyesORno:DMno];
    
    
//    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyNext;
    
}
-(void)viewWillLayoutSubviews
{
    [self createUI];
}
-(void)createUI
{
    NSString *introText = @"心血管病（包括冠心病和脑卒中）严重危害着国人健康，ICVD模型通过年龄、性别、收缩压、血清胆固醇、体质指数等7个危险因素来进行综合评估个体今后10年内发生ICVD的综合危险。";
    [summaryLabel setText:introText];
    [summaryLabel sizeToFit];
    [summaryLabel setAdjustsFontSizeToFitWidth:YES];

    
    [scoreLabel sizeToFit];
    
}

- (IBAction)sexBTNDone:(UIButton *)sender {
    
    if ([sender isEqual:boyBTN]) {
        if (!boyBTN.selected) {
            [girlBTN setSelected:NO];
            [boyBTN setSelected:YES];
        }
        
        sex = @"男";
    }
    else
    {
        if (!girlBTN.selected) {
            [boyBTN setSelected:NO];
            [girlBTN setSelected:YES];
        }
        
        sex = @"女";
    }
    
}
- (IBAction)smokeBtnSelected:(UIButton *)sender {
    
    if ([sender isEqual:smokeYES]) {
        if (!smokeYES.selected) {
            [smokeNO setSelected:NO];
            [smokeYES setSelected:YES];
        }
        
        smoke = YES;
    }
    else
    {
        if (!smokeNO.selected) {
            [smokeYES setSelected:NO];
            [smokeNO setSelected:YES];
        }
        
        smoke = NO;
    }

}
- (IBAction)DMyesORno:(UIButton *)sender {
    if ([sender isEqual:DMyes]) {
        if (!DMyes.selected) {
            [DMno setSelected:NO];
            [DMyes setSelected:YES];
        }
        
        DM = YES;
    }
    else
    {
        if (!DMno.selected) {
            [DMyes setSelected:NO];
            [DMno setSelected:YES];
        }
        
        DM = NO;
    }

}


- (IBAction)nextBtnDone:(UIButton *)sender {
    
    self.returnRiskPage(sender.tag+1);
    
    if (sender.tag == 0) {
        [infoPageControl setHidden:NO];
    }
    if (sender.tag == 1) {
        
        NSInteger nameLength = [Tools stringLengthWithENandCH:nameTF.text];
        
        if (nameLength > 0 ) {
            if(nameLength > 16 | nameLength < 2)
            {
                [SVProgressHUD showErrorWithStatus:@"请输入2~16长度的姓名"];
                return;
            }
            else
            {
                [self fillInfoFirstStep];
            }
        }
        else
        {
            return;
        }
        
        if ([sex isEqualToString:@"女"]) {
            UIImage *girl = [UIImage imageNamed:@"girlAvatarSelected"];
            
            [sexAvatarFlag setImage:girl];
            [thirdSexAvatar setImage:girl];
        }
        else
        {
            UIImage *boy = [UIImage imageNamed:@"boyAvatarSelected"];
            
            [sexAvatarFlag setImage:boy];
            [thirdSexAvatar setImage:boy];
        }
    }
    if (sender.tag == 2) {
        
        NSInteger age = ageTF.text.integerValue;
        NSInteger height = heightTF.text.integerValue;
        CGFloat weight = weightTF.text.floatValue;
        
        if (age < 3 | age > 130) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的年龄"];
            return;
        }
        if (height < 60 | height > 300) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身高"];
            return;
        }
        if (weight < 20 | weight > 300) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的体重"];
            return;
        }
        
        [self fillInfoSecondStep];
    }
    if (sender.tag == 3) {
        
        double chol = CHOLTF.text.doubleValue;
        if (chol < 0.0 | chol > 10.0) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的总胆固醇"];
            return;
        }
        [self fillInfoThirdStep];
    }
    if (sender.tag == 4) {
        
        NSInteger sbp = SBPTF.text.integerValue;
        NSInteger dbp = DBPTF.text.integerValue;
        CGFloat bmp = BMPTF.text.floatValue;
        if (sbp < 10 | sbp > 200) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的收缩压"];
            return;
        }
        if (dbp < 10 | dbp > 200) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的舒张压"];
            return;
        }
        if (bmp < 10 | bmp > 200) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的心率"];
            return;
        }
       
        [self fillInfoFourthStep];
    }
    
    infoPageControl.currentPage = sender.tag;
    if (sender.tag == 5) {
        [self fillInfoDone];
    }
    
    if (sender.tag != 4 && sender.tag != 5) {
        [infoScrollView setContentOffset:CGPointMake(SCREENWIDTH*(sender.tag+1), 0) animated:YES];
    }
}

-(void)fillInfoFirstStep
{
    _fillInfoDataModel.name = nameTF.text;
    _fillInfoDataModel.sex = sex;

}
-(void)fillInfoSecondStep
{
    _fillInfoDataModel.age = ageTF.text;
    _fillInfoDataModel.height = heightTF.text;
    _fillInfoDataModel.weight = weightTF.text;
}

-(void)fillInfoThirdStep
{
    _fillInfoDataModel.smoking = smoke;
    _fillInfoDataModel.DM = DM;
    _fillInfoDataModel.CHOL = CHOLTF.text;
}
-(void)fillInfoFourthStep
{
    _fillInfoDataModel.SBP = SBPTF.text;
    _fillInfoDataModel.DBP = DBPTF.text;
    _fillInfoDataModel.BMP = BMPTF.text;
    
    LLNetApiBase *apis =[[LLNetApiBase alloc]init];
    self.fillInfoDataModel.insertPerson = self.userData.userId;
    WeakObject(self);
    [apis PostRiskAssessmentWithInfo:self.fillInfoDataModel andCompletion:^(id objectRet, NSError *errorRes)
     {
         if (objectRet) {
             NSString *statusStr =[NSString stringWithFormat:@"%@",[objectRet objectForKey:@"status"]];
             
             if ([statusStr isEqualToString:@"1"])
             {
                 [infoPageControl setHidden:YES];
                 [infoScrollView setContentOffset:CGPointMake(SCREENWIDTH*(4+1), 0) animated:YES];
                 NSString *introText = objectRet[@"data"][@"result"];
                 [__weakObject showDonePage:introText score:objectRet[@"data"][@"count"]];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:[objectRet objectForKey:@"msg"]];
                 __weakObject.returnRiskPage(4);
             }
         }
         else
         {
             __weakObject.returnRiskPage(4);
         }
     }];
}

-(void)showDonePage:(NSString *)info score:(NSString *)score
{
    [resultLabel setText:info];
    [resultLabel sizeToFit];
    [resultLabel setAdjustsFontSizeToFitWidth:YES];
    
    [scoreLabel setText:score];
    [scoreLabel sizeToFit];
    
}

-(void)fillInfoDone
{
    self.doneRiskPage();
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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

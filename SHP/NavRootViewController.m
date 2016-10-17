//
//  NavRootViewController.m
//  LUDE
//
//  Created by bluemobi on 15/11/13.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "NavRootViewController.h"


@implementation NavRootViewController

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    NavRootViewController* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate =(id<UIGestureRecognizerDelegate>) self;
    nvc.delegate =(id) self;
    return nvc;
   
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{

    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

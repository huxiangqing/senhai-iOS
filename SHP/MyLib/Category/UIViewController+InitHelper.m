//
//  UIViewController+InitHelper.m
//  LUDE
//
//  Created by 胡祥清 on 15/10/7.
//  Copyright © 2015年 胡祥清. All rights reserved.
//

#import "UIViewController+InitHelper.h"
#import "MainViewController.h"

@implementation UIViewController (InitHelper)

-(void) popButtonPressed
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(id) initWithDefaultNibName
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

-(id) initWithStoryboardID:(NSString *)storyboardID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:storyboardID];
    return [storyboard instantiateViewControllerWithIdentifier:storyboardID];
}

-(id)initWithSecondStoryboardID:(NSString *)storyboardID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:storyboardID];
}

-(id) initWithDefaultStoryboardID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(void)gotoMainView
{
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[MainViewController class]]){
            MainViewController *mainView = (MainViewController *)controller;
            [self.navigationController popToViewController:mainView animated:YES];
        }
    }
}

@end

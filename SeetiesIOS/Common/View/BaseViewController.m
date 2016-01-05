//
//  BaseViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/7/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.leveyTabBarController.tabBar.hidden = NO;
    
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.leveyTabBarController.tabBar setY:self.view.frame.size.height - self.leveyTabBarController.tabBar.frame.size.height];
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.leveyTabBarController.tabBar.hidden = YES;

}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//        [self.leveyTabBarController.tabBar setY:self.view.frame.size.height];
//    }];
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)init{

    if (self = [super init]) {
        self.navController = [[UINavigationController alloc]initWithRootViewController:self];
        [[self navController] setNavigationBarHidden:YES animated:NO];

    }
    
    return self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navController pushViewController:viewController animated:animated];
}
//-(void)pushViewController:(UIViewController*)viewController
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFromLeft;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//   
//    [self.navigationController pushViewController:viewController animated:YES];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

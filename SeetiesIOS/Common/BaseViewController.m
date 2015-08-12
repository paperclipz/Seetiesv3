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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithTabController:(LeveyTabBarController*)controller
{
    if (self = [super init]) {
        self.leveyTabBarController = controller;
    }
    
    return self;

}

-(id)init{

    if (self = [super init]) {
        self.navController = [[UINavigationController alloc]initWithRootViewController:self];
        [[self navController] setNavigationBarHidden:YES animated:NO];
    }
    
    return self;
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

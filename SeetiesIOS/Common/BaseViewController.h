//
//  BaseViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/7/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "LeveyTabBarController.h"
@interface BaseViewController : GAITrackedViewController


@property(nonatomic,strong)LeveyTabBarController* leveyTabBarController;
-(void)changeTransition:(UINavigationController*)nav;
-(void)pushViewController:(UIViewController*)viewController;
@property(nonatomic,strong)UINavigationController* navController;
@end

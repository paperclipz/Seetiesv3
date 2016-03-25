//
//  NewLandingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"

#import "LeveyTabBarController.h"
#import "ProfileViewController.h"
#import "Explore2ViewController.h"
#import "CT3_NewsFeedViewController.h"
#import "CT3_LoginViewController.h"
#import "CT3_MoreViewController.h"
#import "CT3_MeViewController.h"

@interface NewLandingViewController : UIViewController<LeveyTabBarControllerDelegate>

@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)Explore2ViewController* explore2ViewController;
@property(nonatomic,strong)CT3_NewsFeedViewController* newsFeedViewController;
@property(nonatomic,strong)LeveyTabBarController* leveyTabBarController;
@property(nonatomic,strong)CT3_LoginViewController* loginViewController;
@property(nonatomic,strong)CT3_MoreViewController* ct3_MoreViewController;
@property(nonatomic, strong)CT3_MeViewController *ct3MeViewController;

-(void)showLoginView;
-(void)reloadData;
-(void)showIntroView;

@end

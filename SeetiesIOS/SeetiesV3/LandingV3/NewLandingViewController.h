//
//  NewLandingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"

#import "ProfileViewController.h"
#import "CT3_NewsFeedViewController.h"
#import "CT3_LoginViewController.h"
#import "CT3_MoreViewController.h"
#import "CT3_MeViewController.h"

@interface NewLandingViewController : UIViewController

@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CT3_NewsFeedViewController* newsFeedViewController;
@property(nonatomic,strong)CT3_LoginViewController* loginViewController;
@property(nonatomic,strong)CT3_MoreViewController* ct3_MoreViewController;
@property(nonatomic, strong)CT3_MeViewController *ct3MeViewController;
@property (nonatomic, strong)UINavigationController* navLoginViewController;

-(void)showLoginView;
-(void)showLoginViewWithCompletion:(VoidBlock)completionBlock;

-(void)reloadData;
-(void)showIntroView;

-(void)reloadTabbar;

-(void)showPushNotificationView:(NSString*)pushNotificationCode;

@end

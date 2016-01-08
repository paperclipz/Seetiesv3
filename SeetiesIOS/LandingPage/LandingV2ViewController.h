//
//  LandingV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//


#import "AppDelegate.h"
#import "CustomPickerViewController.h"
#import "ExpertLoginViewController.h"
#import "Explore2ViewController.h"
#import "FeedViewController.h"
#import "GAITrackedViewController.h"
#import "InstagramLoginWebViewController.h"
#import "LeveyTabBarController.h"
#import "Locale.h"
#import "NotificationViewController.h"
#import "OpenWebViewController.h"
#import "PFollowTheExpertsViewController.h"
#import "PInterestV2ViewController.h"
#import "PSelectYourInterestViewController.h"
#import "PTellUsYourCityViewController.h"
#import "PTnCViewController.h"
#import "ProfileViewController.h"
#import "PublishMainViewController.h"
#import "RecommendationViewController.h"
#import "SignupViewController.h"
#import "UserProfilePageViewController.h"
#import "WhyWeUseFBViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface LandingV2ViewController : GAITrackedViewController <UITabBarControllerDelegate,LeveyTabBarControllerDelegate>


-(void)UploadInformationToServer;
-(void)GetAlllanguages;


//=========================================== Revamp Changes =======================================//

@property(nonatomic,strong)UITabBarController* tabBarController;

@property(nonatomic,strong)FeedViewController* feedViewController;

@property(nonatomic,strong)Explore2ViewController* explore2ViewController;

@property(nonatomic,strong)RecommendationViewController* recommendationViewController;

@property(nonatomic,strong)NotificationViewController* notificationViewController;

@property(nonatomic,strong)LeveyTabBarController *leveyTabBarController;

@property(nonatomic,strong)UILabel* ShowNotificationCount;

@property(nonatomic,strong)ProfileViewController* profileViewController;

@property(nonatomic,strong)ExpertLoginViewController* expertLoginViewController;


//=========================================== Revamp Changes =======================================//

@end

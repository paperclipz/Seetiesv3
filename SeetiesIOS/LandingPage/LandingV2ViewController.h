//
//  LandingV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "Explore2ViewController.h"
#import "FeedV2ViewController.h"
#import "SelectImageViewController.h"
#import "NotificationViewController.h"
#import "LeveyTabBarController.h"
#import "UserProfilePageViewController.h"
#import "RecommendationViewController.h"
#import "FeedViewController.h"
#import "NewProfileV2ViewController.h"
#import "NewsFeedViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ExpertLoginViewController.h"
#import "PTnCViewController.h"
#import "AsyncImageView.h"
#import "WhyWeUseFBViewController.h"
#import "SignupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PTellUsYourCityViewController.h"
#import "ExploreViewController.h"
#import "ProfileV2ViewController.h"
#import "PublishMainViewController.h"
#import "PSelectYourInterestViewController.h"
#import "PFollowTheExpertsViewController.h"
#import "Locale.h"
#import <Parse/Parse.h>
#import "InstagramLoginWebViewController.h"
#import "CRMotionView.h"
#import "PInterestV2ViewController.h"
#import "OpenWebViewController.h"
#import "CustomPickerViewController.h"


@interface LandingV2ViewController : GAITrackedViewController <UITabBarControllerDelegate,LeveyTabBarControllerDelegate>


-(void)UploadInformationToServer;
-(void)GetAlllanguages;


//=========================================== Revamp Changes =======================================//

@property(nonatomic,strong)UITabBarController* tabBarController;

@property(nonatomic,strong)FeedViewController* feedViewController;

@property(nonatomic,strong)Explore2ViewController* explore2ViewController;

@property(nonatomic,strong)SelectImageViewController* selectImageViewController;

@property(nonatomic,strong)RecommendationViewController* recommendationViewController;

@property(nonatomic,strong)NotificationViewController* notificationViewController;

@property(nonatomic,strong)LeveyTabBarController *leveyTabBarController;

@property(nonatomic,strong)NewProfileV2ViewController* userProfilePageViewController;

@property(nonatomic,strong)UILabel* ShowNotificationCount;

@property(nonatomic,strong)NewsFeedViewController* newsFeedViewController;

@property(nonatomic,strong)ProfileViewController* profileViewController;

//=========================================== Revamp Changes =======================================//

@end

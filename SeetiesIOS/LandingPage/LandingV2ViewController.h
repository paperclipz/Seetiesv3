//
//  LandingV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "Explore2ViewController.h"
#import "FeedV2ViewController.h"
#import "SelectImageViewController.h"
#import "NotificationViewController.h"
#import "LeveyTabBarController.h"
#import "UserProfilePageViewController.h"
#import "RecommendationViewController.h"
#import "FeedViewController.h"
#import "NewProfileV2ViewController.h"
@interface LandingV2ViewController : GAITrackedViewController <UITabBarControllerDelegate,LeveyTabBarControllerDelegate>{
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSString *UserEmail;
    NSString *UserName;
    NSString *GetFB_ID;
    NSString *GetFB_Token;
    NSString *Name;
    NSString *Userdob;
    NSString *UserGender;
    NSArray *animationImages;
    int count;
    NSURLConnection *theConnection_Facebook;
    NSURLConnection *theConnection_GetLanguages;
    NSURLConnection *theConnection_GetAllCategory;

    NSString *InstagramOnClickListen;
    NSString *GetInstagramToken;
    NSString *GetInstagramID;

}

//@property (nonatomic,strong)


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

//=========================================== Revamp Changes =======================================//

@end

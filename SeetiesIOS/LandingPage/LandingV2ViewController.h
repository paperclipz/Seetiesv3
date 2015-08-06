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
@class LeveyTabBarController;
@interface LandingV2ViewController : GAITrackedViewController{
    LeveyTabBarController *leveyTabBarController;
    

#import "Explore2ViewController.h"
#import "FeedV2ViewController.h"
#import "SelectImageViewController.h"
#import "NotificationViewController.h"
#import "ProfileV2ViewController.h"

@interface LandingV2ViewController : GAITrackedViewController <UITabBarControllerDelegate>{
IBOutlet UIButton *FBLoginButton;
IBOutlet UIButton *LogInButton;
IBOutlet UIButton *WhyWeUseFBButton;
IBOutlet UIButton *SignUpWithEmailButton;
IBOutlet UIImageView *ShowBackgroundImage;
IBOutlet UIView *BackgroundView;
IBOutlet UILabel *MainText;
IBOutlet UIImageView *MainLogo;
    
    IBOutlet UIButton *InstagramButton;
    IBOutlet UILabel *ShowTnCText;

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

IBOutlet UIActivityIndicatorView *ShowActivity;
}
@property (nonatomic, retain) IBOutlet LeveyTabBarController *leveyTabBarController;
-(IBAction)FbButton:(id)sender;
-(IBAction)ExpertLoginButton:(id)sender;
-(IBAction)WhyWeUseFBButton:(id)sender;
-(IBAction)SignUpWithEmailButton:(id)sender;
-(IBAction)InstagramButton:(id)sender;

//@property (nonatomic,strong)


-(void)UploadInformationToServer;
-(void)GetAlllanguages;


//=========================================== Revamp Changes =======================================//

@property(nonatomic,strong)UITabBarController* tabBarController;

@property(nonatomic,strong)FeedV2ViewController* feedV2ViewController;
@property(nonatomic,strong)UINavigationController* navFeedV2ViewController;

@property(nonatomic,strong)Explore2ViewController* explore2ViewController;
@property(nonatomic,strong)UINavigationController* navExplore2ViewController;

@property(nonatomic,strong)SelectImageViewController* selectImageViewController;
@property(nonatomic,strong)UINavigationController* navSelectImageViewController;

@property(nonatomic,strong)NotificationViewController* notificationViewController;
@property(nonatomic,strong)UINavigationController* navNotificationViewController;

@property(nonatomic,strong)ProfileV2ViewController* profileV2ViewController;
@property(nonatomic,strong)UINavigationController* navProfileV2ViewController;
//=========================================== Revamp Changes =======================================//

@end

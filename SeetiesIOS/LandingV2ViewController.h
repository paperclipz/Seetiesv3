//
//  LandingV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface LandingV2ViewController : GAITrackedViewController{
IBOutlet UIButton *FBLoginButton;
IBOutlet UIButton *LogInButton;
IBOutlet UIButton *WhyWeUseFBButton;
IBOutlet UIButton *SignUpWithEmailButton;
IBOutlet UIImageView *ShowBackgroundImage;
IBOutlet UIView *BackgroundView;
IBOutlet UILabel *MainText;
IBOutlet UIImageView *MainLogo;
    
    IBOutlet UIButton *InstagramButton;

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
-(IBAction)FbButton:(id)sender;
-(IBAction)ExpertLoginButton:(id)sender;
-(IBAction)WhyWeUseFBButton:(id)sender;
-(IBAction)SignUpWithEmailButton:(id)sender;
-(IBAction)InstagramButton:(id)sender;

-(void)UploadInformationToServer;
-(void)GetAlllanguages;
@end

//
//  LandingViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/14/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "LLARingSpinnerView.h"
@interface LandingViewController : GAITrackedViewController{
    
    IBOutlet UIButton *FBLoginButton;
    IBOutlet UIButton *LogInButton;
    IBOutlet UIButton *WhyWeUseFBButton;
    IBOutlet UIButton *SignUpWithEmailButton;
    IBOutlet UIImageView *ShowBackgroundImage;
    IBOutlet UIView *BackgroundView;
    IBOutlet UILabel *MainText;
    IBOutlet UIImageView *MainLogo;
    
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
    NSURLConnection *theConnection_GetIPAddress;
    NSURLConnection *theConnection_GetAllCategory;
    
    //LLARingSpinnerView *spinnerView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(IBAction)FbButton:(id)sender;
-(IBAction)ExpertLoginButton:(id)sender;
-(IBAction)WhyWeUseFBButton:(id)sender;
-(IBAction)SignUpWithEmailButton:(id)sender;

-(void)UploadInformationToServer;
-(void)GetAlllanguages;
@end

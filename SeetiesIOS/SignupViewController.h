//
//  SignupViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/19/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface SignupViewController : GAITrackedViewController<UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *Scrollview;
    IBOutlet UITextField *EmailField;
    IBOutlet UITextField *UsernameField;
    IBOutlet UITextField *PasswordField;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowTnC;
    IBOutlet UIButton *SignUpButton;
    IBOutlet UIImageView *RedIcon;
    IBOutlet UIImageView *ShowBackgroundImage;
    IBOutlet UIImageView *LoginBackgroundImg_1;
    IBOutlet UIImageView *LoginBackgroundImg_2;
    
    IBOutlet UIButton *Line01;
    IBOutlet UIButton *Line02;
    
    IBOutlet UIButton *TermsButton;
    IBOutlet UIButton *PrivacyButton;
    
    NSString *GetEmail;
    NSString *GetUsername;
    NSString *GetPassword;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *ExternalIPAddress;
    
    NSURLConnection *theConnection_Signup;
    NSURLConnection *theConnection_GetUserData;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)RegisterButton:(id)sender;

-(IBAction)TermsofUseButton:(id)sender;
-(IBAction)PrivacyPolicyButton:(id)sender;

-(void)SendLoginDataToServer;
@end

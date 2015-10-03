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
    IBOutlet UITextField *ConfirmPasswrodField;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SignUpButton;
    IBOutlet UIImageView *RedIcon;
    IBOutlet UIImageView *ShowBackgroundImage;
    IBOutlet UIButton *CancelButton;
    IBOutlet UIImageView *LogoImg;
    
    IBOutlet UIButton *btnBackground_1;
    IBOutlet UIButton *btnBackground_2;
    IBOutlet UIButton *btnBackground_3;
    IBOutlet UIButton *btnBackground_4;
    
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

-(void)SendLoginDataToServer;
@end
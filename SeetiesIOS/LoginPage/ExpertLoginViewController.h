//
//  ExpertLoginViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface ExpertLoginViewController : GAITrackedViewController<UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet UIImageView *ShowBackgroundImage;
    IBOutlet TPKeyboardAvoidingScrollView *Scrollview;
    IBOutlet UITextField *ShowLoginID;
    IBOutlet UITextField *ShowPassword;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIImageView *LoginBackgroundImg;
    
    IBOutlet UIButton *LoginButton;
    IBOutlet UIButton *NeedHelpButton;
    IBOutlet UIButton *ForgotPasswordButton;
    
    NSString *GetLoginID;
    NSString *GetPassword;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(void)GetSameEmailData:(NSString *)EmailData;
-(IBAction)BackButton:(id)sender;

-(IBAction)LoginButton:(id)sender;
-(IBAction)ForgotPasswordButton:(id)sender;
-(IBAction)FeedBackButton:(id)sender;
-(void)SendLoginDataToServer;
@end

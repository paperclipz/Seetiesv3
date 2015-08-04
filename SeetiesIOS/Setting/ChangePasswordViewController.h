//
//  ChangePasswordViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/5/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface ChangePasswordViewController : GAITrackedViewController<UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *Scrollview;
    IBOutlet UITextField *OldPasswordText;
    IBOutlet UITextField *NewPasswordText;
    IBOutlet UITextField *KeyinAgainText;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIButton *SubmitButton;
    IBOutlet UIImageView *BarImage;
    
    NSString *GetOldPassword;
    NSString *GetNewPassword;
    NSString *GetNewPasswordAgain;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *CheckFB;
    
    IBOutlet UIImageView *BackgroundImage001;
    IBOutlet UIImageView *BackgroundImage002;
    
    IBOutlet UIImageView *RedIcon1;
    IBOutlet UIImageView *RedIcon2;
    IBOutlet UIImageView *RedIcon3;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SubmitButton:(id)sender;
@end

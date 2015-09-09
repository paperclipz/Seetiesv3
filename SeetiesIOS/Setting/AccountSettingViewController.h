//
//  AccountSettingViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "LLARingSpinnerView.h"
@interface AccountSettingViewController : GAITrackedViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet UITextField *Emailfield;
   // IBOutlet UILabel *ShowEmail;
    IBOutlet UILabel *ShowPrimary;
    IBOutlet UILabel *ShowSecondary;
    IBOutlet UILabel *ShowSystemlanguage;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *EditBackImg;
    
    IBOutlet UIImageView *CaretPrimaryImg;
    IBOutlet UIImageView *CaretSecondaryImg;
    IBOutlet UIImageView *CaretAppLanguageImg;
    IBOutlet UIImageView *CaretChangePasswordImg;
    IBOutlet UIImageView *CaretDeleteAccountImg;
    
    UIToolbar *Toolbar;
    UIPickerView *Language_PickerView;
    
    NSMutableArray *LanguageArray;
    NSMutableArray *LanguageIDArray;
    
    NSMutableArray *Language2Array;
    NSMutableArray *LanguageID2Array;
    
    NSMutableArray *SystemLanguageNameArray;
    NSMutableArray *SystemLanguageIDArray;
    
    NSString *GetSystemLanguage;
    NSString *GetSystemLanguage_ID;
    NSString *GetLanguage1;
    NSString *GetLanguage1_ID;
    NSString *GetLanguage2;
    NSString *GetLanguage2_ID;
    
    int CheckSystemLanguage;
    int CheckLangauge1;
    int CheckLanguage2;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_UpdateUserData;
    NSURLConnection *theConnection_UserDeleteAccount;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
    IBOutlet UILabel *ShowSubTitle;
    IBOutlet UILabel *EmailText;
    IBOutlet UILabel *PrimaryText;
    IBOutlet UILabel *SecondaryText;
    IBOutlet UILabel *AppLanguageText;
    IBOutlet UILabel *ChangePasswordText;
    IBOutlet UIButton *DeleteButton;
    
    LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
    
    IBOutlet UISwitch *FacebookSwitch;
    IBOutlet UISwitch *InstagramSwitch;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SelectPrimaryButton:(id)sender;
-(IBAction)SelectSecondaryButton:(id)sender;
-(IBAction)SystemLanguageButton:(id)sender;
-(IBAction)SaveButton:(id)sender;
-(IBAction)ChangePasswordButton:(id)sender;
-(IBAction)DeleteAccountButton:(id)sender;
@end

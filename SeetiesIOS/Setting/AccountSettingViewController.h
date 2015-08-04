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
    IBOutlet UILabel *ShowGender;
    IBOutlet UILabel *ShowBirthday;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *EditBackImg;
    
    UIToolbar *Toolbar;
    UIPickerView *Language_PickerView;
    UIDatePicker *Birthday_Picker;
    
    NSMutableArray *LanguageArray;
    NSMutableArray *LanguageIDArray;
    NSMutableArray *GenderArray;
    
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
    NSString *Getdob;
    NSString *GetGender;
    
    int CheckSystemLanguage;
    int CheckLangauge1;
    int CheckLanguage2;
    int Checkdob;
    int CheckGender;
    
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
    IBOutlet UILabel *GenderText;
    IBOutlet UILabel *BirthdayText;
    IBOutlet UIButton *DeleteButton;
    
    LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SelectPrimaryButton:(id)sender;
-(IBAction)SelectSecondaryButton:(id)sender;
-(IBAction)SystemLanguageButton:(id)sender;
-(IBAction)GenderButton:(id)sender;
-(IBAction)BirthdayButton:(id)sender;
-(IBAction)SaveButton:(id)sender;
-(IBAction)ChangePasswordButton:(id)sender;
-(IBAction)DeleteAccountButton:(id)sender;
@end

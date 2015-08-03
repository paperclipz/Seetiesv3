//
//  SettingsViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface SettingsViewController : GAITrackedViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *Title_Account;
    IBOutlet UILabel *EditProfile;
    IBOutlet UILabel *EditInterests;
    IBOutlet UILabel *AccountSetting;
    IBOutlet UILabel *FindInviteFriends;
    
    IBOutlet UILabel *Title_Support;
    IBOutlet UILabel *AboutSeeties;
    IBOutlet UILabel *TermOfUse;
    IBOutlet UILabel *PrivacyPolicy;
    IBOutlet UILabel *Feedback;
    
    IBOutlet UIButton *CheckForUpdateButton;
    IBOutlet UIButton *LogoutButton;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIButton *EditProfileButton;
    IBOutlet UIButton *EditInterestsButton;
    IBOutlet UIButton *AccountSettingsButton;
    IBOutlet UIButton *AboutsButton;
    IBOutlet UIButton *TermOfUseButton;
    IBOutlet UIButton *PrivacyButton;
    IBOutlet UIButton *FeedBackButton;
    NSURLConnection *theConnection_logout;
    
    IBOutlet UIImageView *Table4Img;
    IBOutlet UIImageView *Table1Img_1;
    IBOutlet UIImageView *Table1Img_2;
    IBOutlet UIImageView *Table1Img_3;
    
    IBOutlet UIImageView *CaretImg_1;
    IBOutlet UIImageView *CaretImg_2;
    IBOutlet UIImageView *CaretImg_3;
    IBOutlet UIImageView *CaretImg_4;
    IBOutlet UIImageView *CaretImg_5;
    IBOutlet UIImageView *CaretImg_6;
    IBOutlet UIImageView *CaretImg_7;
    
    IBOutlet UILabel *CopyrightText;
    IBOutlet UILabel *VersionText;
}
-(IBAction)BackButton:(id)sender;

-(IBAction)EditProfileButton:(id)sender;
-(IBAction)AccountSettingButton:(id)sender;
-(IBAction)EditInterestButton:(id)sender;
-(IBAction)LogoutButton:(id)sender;

-(IBAction)AboutSeetiesButton:(id)sender;
-(IBAction)TermsofUseButton:(id)sender;
-(IBAction)PrivacyPolicyButton:(id)sender;
-(IBAction)FeedBackButton:(id)sender;

-(IBAction)CheckNewUpdateButton:(id)sender;
@end

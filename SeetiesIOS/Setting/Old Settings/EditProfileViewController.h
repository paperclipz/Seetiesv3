//
//  EditProfileViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "LLARingSpinnerView.h"
@interface EditProfileViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;

    IBOutlet UITextField *ShowName;
    IBOutlet UITextField *ShowUsername;
    IBOutlet UITextField *ShowWebsite;
    IBOutlet UITextView *ShowAbouts;
    IBOutlet UILabel *ShowLocation;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *EditBackImg;
    
    NSString *GetName;
    NSString *GetUserName;
    NSString *GetAbouts;
    NSString *GetWebsite;
    NSString *FullLocation;
    
    int CheckName;
    int CheckAbouts;
    int CheckWebsite;
    int CheckFUllLocation;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *SubTitle;
    IBOutlet UILabel *UsernameText;
    IBOutlet UILabel *FullnameText;
    IBOutlet UILabel *WebsiteText;
    IBOutlet UILabel *BioText;
    IBOutlet UILabel *LocationText;
    IBOutlet UIButton *SaveButton;
    
    LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)OpenLocationButton:(id)sender;
-(IBAction)SaveButton:(id)sender;
@end

//
//  TellaStoryViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/19/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
#import "LLARingSpinnerView.h"
@class TPKeyboardAvoidingScrollView;
@interface TellaStoryViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UITextField *TitleField;
    IBOutlet UITextView *ExperienceTextView;
    IBOutlet UIScrollView *ButtonScroll;
    IBOutlet UIView *OtherInformationView;
    IBOutlet UIView *ShowQualityRecommendationView;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveDraftButton;
    
    IBOutlet UIButton *LineExperience;
    LLARingSpinnerView *spinnerView;
    NSMutableArray *ButtonNameArray;
    NSMutableArray *SelectButtonArray;
    NSMutableArray *SelectButtonDataArray;
    
    int CheckOtherInformationViewHeight;
    
    IBOutlet UIView *ChineseView;
   IBOutlet UITextField *ChineseTextField;
   IBOutlet UITextView *ChineseExperienceTextView;
    
    IBOutlet UIImageView *ShowImageCover;

    IBOutlet UIView *PublishView;
    IBOutlet UIScrollView *SelectCategoryScrollView;
    IBOutlet UIButton *PublishButton;
    IBOutlet UIButton *CancelButton;
    IBOutlet UILabel *ShowMiniTitle;
    IBOutlet UILabel *ShowCategoryTitle;
    IBOutlet UIButton *MiniTagButton;
    
    NSMutableArray *CategorySelectIDArray;
    
    NSMutableArray *TagStringArray;
    NSMutableArray *TagStringDataArray;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSString *StatusString;
    NSString *TagString;
    NSString *CreateLocationJsonString;
    NSString *GetBlogString;
    NSMutableArray *SendCaptionDataArray;
    NSMutableArray *GetImageArray;
    
    NSMutableArray *LangArray;
    NSMutableArray *LangIDArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    
    NSString *GetAddress;
    NSString *GetPlaceName;
    NSString *GetPlaceLat;
    NSString *GetPlaceLng;
    NSString *GetFBWebsite;
    NSString *GetContactNumber;
    NSString *GetHour;
    NSString *GetPriceData;
    NSString *GetPriceNumCodeData;
    NSString *GetPriceShowData;
    NSString *GetBlogLinkData;
    
    NSMutableArray *GetCategoryIDArray;
    
    NSString *GetUpdatePost;
    NSString *GetPostID;
    
    NSString *GetUserLanguage_1;
    NSString *GetUserLanguage_2;
    
    IBOutlet UIButton *SkipAndDoneButton;
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID;
-(IBAction)BackButton:(id)sender;
-(IBAction)QualityRecommendationButton:(id)sender;

-(IBAction)DoneButton:(id)sender;

//Publish View Button
-(IBAction)CancelButton:(id)sender;
-(IBAction)PublishButton:(id)sender;

-(IBAction)SaveDaftButton:(id)sender;
@end

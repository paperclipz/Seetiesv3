//
//  RecommendV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/28/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLARingSpinnerView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@class TPKeyboardAvoidingScrollView;
@interface RecommendV2ViewController : GAITrackedViewController<UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *SaveDraftButton;
    IBOutlet UILabel *ShowTitle;
    //LLARingSpinnerView *spinnerView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIScrollView *ImageScroll;
    IBOutlet UIView *ShowDownView;
    IBOutlet UIButton *DownLineButton;
    IBOutlet UIImageView *ShowLineImg;
    IBOutlet UIButton *NextButton;

    IBOutlet UIButton *MainCancelButton;
    IBOutlet UIButton *OpenPhotoButton;
    IBOutlet UIButton *OpenEditPlaceButton;
    IBOutlet UIButton *OpenSubMenuButton;
    
    NSMutableArray *LangArray;
    NSMutableArray *LangIDArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;

    NSMutableArray *GetImageArray;
    NSMutableArray *GetPhotoPositionArray;
    
    IBOutlet UIButton *LineButton;
    
    IBOutlet UIView *ShowQualityView;
    
    IBOutlet UITextView *TitleTextView;
    IBOutlet UITextView *ExperienceTextView;
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *CategorySelectIDArray;
    
    IBOutlet UIView *PublishView;
    IBOutlet UIScrollView *SelectCategoryScrollView;
    IBOutlet UIButton *PublishButton;
    IBOutlet UIButton *CancelButton;
    IBOutlet UILabel *ShowMiniTitle;
    IBOutlet UILabel *ShowCategoryTitle;
    IBOutlet UIImageView *CategoryBackgroundImg;
    IBOutlet UIButton *CategoryLineButton;
    
    IBOutlet UIButton *BlackBackground;
    
    IBOutlet UILabel *ShowTitleCountText;
    IBOutlet UILabel *ShowExperienceCountText;
    
    NSString *GetUserLanguage_1;
    NSString *GetUserLanguage_2;
    
    NSString *CreateLocationJsonString;
    
    NSString *StatusString;
    NSString *GetBlogString;
    NSString *GetTagString;
    NSMutableArray *SendCaptionDataArray;
    
    NSString *GetUpdatePost;
    NSString *GetPostID;
    
    NSInteger CheckKeyboard;
    NSInteger CheckDraft;
    NSInteger CheckEdit;
    NSString *CheckEditPostData;
    
    IBOutlet UILabel *ShowQRText;
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID;
-(void)EditPost:(NSString *)CheckEditPost;
-(IBAction)QualityRecommendationButton:(id)sender;
-(IBAction)NextButton:(id)sender;
-(IBAction)EditLocationButton:(id)sender;
-(IBAction)EditPhotoButton:(id)sender;
-(IBAction)SubMenubutton:(id)sender;

-(IBAction)PublishButton:(id)sender;
-(IBAction)SaveDraftButton:(id)sender;
@end

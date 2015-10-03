//
//  FeedV2DetailViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
#import "EditPostViewController.h"

@interface FeedV2DetailViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *MImageScroll;
    IBOutlet UIPageControl *PageControlOn;
    IBOutlet UIView *ShowbarView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIView *ShowDownBarView;
    IBOutlet UIImageView *ShareIcon;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIButton *ShowBarImg;
    IBOutlet UIButton *LocationButton;
    
    IBOutlet UILabel *ShowTotalLikeCount;
    IBOutlet UILabel *ShowTotalCommentCount;
    
    AsyncImageView *ShowImage;
    UIScrollView *ImageScroll;
    BOOL pageControlBeingUsed;
    
    NSString *GetPostID;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetPostAllData;
    NSURLConnection *theConnection_GetAllUserlikes;
    NSURLConnection *theConnection_GetAllComment;
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_DeletePost;
    NSURLConnection *theConnection_NearbyPost;
    
    NSMutableArray *captionArray;
    NSMutableArray *UrlArray;
    NSMutableArray *PhotoIDArray;
    
    NSString *GetPlaceName;
    NSString *GetPlaceFormattedAddress;
    NSString *GetLink;
    
    //location inside data
    NSString *GetLat;
    NSString *GetLng;
    NSString *GetContactNo;
    NSString *GetExpense;
    NSString *GetPlaceLink;
    NSString *GetOpeningHourOpen;
    NSString *GetLikeCheck;
    NSString *GetCollectCheck;
    
    NSString *GetPeriods;
    NSString *GetOpenNow;
    
    NSString *TotalLikeCount;
    NSString *totalCommentCount;
    NSString *TotalCollectionCount;
    
    NSString *GetTags;
    
    NSString *GetTitle;
    NSString *GetMessage;
    
    NSString *EngTitle;
    NSString *ChineseTitle;
    NSString *ThaiTitle;
    NSString *IndonesianTitle;
    NSString *PhilippinesTitle;
    
    NSString *EndMessage;//530b0ab26424400c76000003
    NSString *ChineseMessage;//530b0aa16424400c76000002
    NSString *ThaiMessage;//544481503efa3ff1588b4567
    NSString *IndonesianMessage;//53672e863efa3f857f8b4ed2
    NSString *PhilippinesMessage;//539fbb273efa3fde3f8b4567
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *GetCategoryNameArray;
    NSMutableArray *GetCategoryBackgroundColorArray;
    
    NSString *GetPostName;
    NSString *GetPostUserName;
    NSString *GetUserUid;
    NSString *GetFollowing;
    NSString *GetUserProfileUrl;
    NSString *GetPostTime;
    
    NSString *GetlocationType;
    NSString *GetLocationRoute;
    NSString *GetLocationLocality;
    NSString *GetLocationAdministrative_Area_Level_1;
    NSString *GetLocationPostalCode;
    NSString *GetLocationCountry;
    NSString *GetLocationReference;
    NSString *GetLocationPlaceId;
    
    NSString *GetExpense_Show;
    NSString *GetExpense_Code;
    NSString *GetExpense_RealData;
    
    NSString *PhotoCount;
    
    NSMutableArray *Like_UseruidArray;
    NSMutableArray *Like_UserProfilePhotoArray;
    NSMutableArray *Like_UsernameArray;
    
    NSMutableArray *CommentIDArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *MessageArray;
    NSMutableArray *User_Comment_uidArray;
    NSMutableArray *User_Comment_nameArray;
    NSMutableArray *User_Comment_usernameArray;
    NSMutableArray *User_Comment_photoArray;
    
    IBOutlet UIButton *LikeButton;
    IBOutlet UIButton *CommentButton;
    IBOutlet UIButton *shareFBButton;
    IBOutlet UIButton *AllCollectButton;
    IBOutlet UIButton *QuickCollectButton;
    
    BOOL CheckLikeInitView;
    
    NSInteger CheckCommentData;
    
    UIButton *ShowFollowButton;
    
    IBOutlet UIButton *LanguageButton;
    NSString *GetLang;
    NSInteger CheckLanguage;
    int CountLanguage;
    int ClickCount;
    NSMutableArray *CountLanguageArray;
    
    UILabel *ShowTitle;
    UITextView *ShowMessage;
    
    NSURLConnection *theConnection_GetTranslate;
    
    IBOutlet UILabel *ShowGoogleTranslateText;
    BOOL TestingUse;
    IBOutlet UIView *ShowLanguageTranslationView;
    IBOutlet UIButton *NewLanguageButton;
    
    NSString *GetENMessageString;
    NSString *GetENTItleStirng;
    NSString *CheckENTranslation;
    
    IBOutlet UIButton *ShowTitleBarColor;
    IBOutlet UILabel *ShareText;
    
    BOOL CheckLoadDone;
    
    UIColor *color;
    
    BOOL ShowGoogleTranslate;

    
    IBOutlet UIButton *LineButton;
    
    IBOutlet UILabel *ShowPlaceNameTop;
    IBOutlet UILabel *ShowCategoryTop;
    
    IBOutlet UIImageView *DisplayButton;
    
    CGFloat difference1;
    CGFloat difference2;
    
    NSInteger CheckClickCount;
    
    int GetFinalHeight;
    
    //nearby data array
    NSMutableArray *TitleArray_Nearby;
    NSMutableArray *UserInfo_NameArray_Nearby;
    NSMutableArray *UserInfo_UrlArray_Nearby;
    NSMutableArray *PhotoArray_Nearby;
    NSMutableArray *PostIDArray_Nearby;
    NSMutableArray *PlaceNameArray_Nearby;
    NSMutableArray *MessageArray_Nearby;
    NSMutableArray *DistanceArray_Nearby;
    NSMutableArray *SearchDisplayNameArray_Nearby;
    NSMutableArray *TotalCommentArray_Nearby;
    NSMutableArray *TotalLikeArray_Nearby;
    NSMutableArray *SelfCheckLikeArray_Nearby;

    //LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    
    UIButton *SeeAllButton_Nearby;
    
    NSString *ViewCountString;
    
    NSURLConnection *theConnection_QuickCollect;
    
    int CheckLanguagedata;
}

@property(nonatomic,strong)EditPostViewController* editPostViewController;

-(void)GetPostID:(NSString *)PostID;

-(IBAction)ShareButton:(id)sender;
-(IBAction)SettingButton:(id)sender;
-(IBAction)LikeButton:(id)sender;
-(IBAction)CommentButton:(id)sender;
-(IBAction)FacebookButton:(id)sender;
-(IBAction)NewLanguageButton:(id)sender;
@end

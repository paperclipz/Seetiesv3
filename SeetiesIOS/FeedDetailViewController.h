//
//  FeedDetailViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/12/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface FeedDetailViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>{
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *MImageScroll;
    IBOutlet UIPageControl *PageControlOn;
    IBOutlet UIImageView *SettingBarImage;
    IBOutlet UIImageView *ImageShade;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    AsyncImageView *ShowImage;
    UIScrollView *ImageScroll;
    BOOL pageControlBeingUsed;
    
    NSMutableArray *ImageArray;
    NSString *GetImageData;
    NSString *GetTitle;
    NSString *GetUserName;
    NSString *GetUserProfilePhoto;
    NSString *GetMessage;
    NSString *GetUserAddress;
    NSString *GetCategory;
    NSString *GetTotalLikes;
    NSString *GetTotalComments;
    NSString *GetLang;
    NSString *GetLat;
    NSString *GetLong;
    NSString *GetLocation;
    NSString *GetPostID;
    NSString *GetUserUid;
    NSString *GetUserFollowing;
    NSString *GetLikes;
    NSString *GetLink;
    NSString *GetPlaceName;
    NSString *GetFormattedAddress;
    NSString *GetCategoryBackgroundColor;
    NSString *GetLanguages;
    
    IBOutlet UILabel *ShowCategory;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowUserNameby;
    
    IBOutlet UITextView *ShowDescription;
    IBOutlet UIButton *GoToSiteButton;
    IBOutlet AsyncImageView *UserImage;
    IBOutlet UILabel *ShowUserName;
    IBOutlet UILabel *ShowUserLocation;
    IBOutlet UIButton *FollowButton;
    IBOutlet UIButton *Line001;
    IBOutlet UILabel *LikesText;
    IBOutlet UIScrollView *ShowLikesUserImageScroll;
    IBOutlet UIButton *Line002;
    IBOutlet UILabel *CommentText;
    IBOutlet UIButton *AddCommentButton;
    IBOutlet UILabel *ShowTotalLikes;
    IBOutlet UILabel *ShowTotalComments;
    IBOutlet UIImageView *ShowLangImg;
    IBOutlet UILabel *ShowCommentCount;
    IBOutlet UILabel *ShowLikesCount;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *CommentIDArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *MessageArray;
    NSMutableArray *User_Comment_uidArray;
    NSMutableArray *User_Comment_nameArray;
    NSMutableArray *User_Comment_usernameArray;
    NSMutableArray *User_Comment_photoArray;
    
    NSString *GetCommentCount;
    
    NSURLConnection *theConnection_GetComment;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_GetAllUserlikes;
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_GetPostAllData;
    NSURLConnection *theConnection_GetTranslate;
    
    NSMutableArray *Like_UseruidArray;
    NSMutableArray *Like_UserProfilePhotoArray;
    NSMutableArray *Like_UsernameArray;
    
    IBOutlet UIButton *WhiteBackground;
    IBOutlet UIButton *LikeButton;
    IBOutlet UIButton *CommentButton;
    IBOutlet UIButton *ShareButton;
    IBOutlet UILabel *ShowDownText;
    
    NSInteger CheckCommentData;
    
    NSMutableArray *TagNameArray;
    
    IBOutlet UIButton *LanguageButton;
    NSInteger CheckLanguage;
    int CountLanguage;
    int ClickCount;
    NSMutableArray *CountLanguageArray;
    
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
    
    IBOutlet UILabel *ShowTopTitle;
    IBOutlet UIButton *ShowTitleBarColor;
    
    
    //Google Translate use
    IBOutlet UILabel *ShowGoogleTranslateText;
    BOOL TestingUse;
    IBOutlet UIView *ShowLanguageTranslationView;
    IBOutlet UIButton *NewLanguageButton;
    
    NSString *GetENMessageString;
    NSString *GetENTItleStirng;
    NSString *CheckENTranslation;
}
-(void)GetPostID:(NSString *)PostID;
-(void)GetImageArray:(NSString *)ImageData GetTitle:(NSString *)Title GetUserName:(NSString *)UserName GetUserProfilePhoto:(NSString *)UserProfilePhoto GetMessage:(NSString *)Message GetUserAddress:(NSString *)Address GetCategory:(NSString *)Category GetTotalLikes:(NSString *)Likes GetTotalComment:(NSString *)Comment;
-(void)GetLat:(NSString *)Lat GetLong:(NSString *)Long GetLocation:(NSString *)Location;
-(void)GetPostID:(NSString *)PostID GetUserUid:(NSString *)uid GetUserFollowing:(NSString *)Following GetCheckLike:(NSString *)like GetLink:(NSString *)link;
-(void)GetLang:(NSString *)Lang;
-(void)GetCommentData;
-(IBAction)BackButton:(id)sender;
-(IBAction)LocationButton:(id)sender;
-(IBAction)FollowingButton:(id)sender;
-(IBAction)CommentButton:(id)sender;
-(IBAction)GoToSiteButton:(id)sender;
-(IBAction)ShareButton:(id)sender;

-(IBAction)LanguageButton:(id)sender;

-(IBAction)DontShowAgainButton:(id)sender;
-(IBAction)SkipLanguageTranslationButton:(id)sender;
-(IBAction)NewLanguageButton:(id)sender;
@end

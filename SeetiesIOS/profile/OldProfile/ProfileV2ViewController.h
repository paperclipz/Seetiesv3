//
//  ProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "LLARingSpinnerView.h"
#import "GAITrackedViewController.h"
#import "DoImagePickerController.h"
@interface ProfileV2ViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate,DoImagePickerControllerDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BackgroundImage;
    IBOutlet UIImageView *ImageShade;
    IBOutlet AsyncImageView *ShowUserWallpaperImage;
    IBOutlet UILabel *ShowName;
    IBOutlet AsyncImageView *ShowUserProfile;
    IBOutlet UIImageView *SettingBarImage;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIButton *FullImageButton;
    IBOutlet UIView *KosongView;
    IBOutlet UIImageView *ImgShade;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIImageView *ShareIcon;
    
    IBOutlet UIView *TopBarView;
    
    int segmentActionCheck;
    
   // LLARingSpinnerView *spinnerView;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_GetPostsData;
    NSURLConnection *theConnection_GetLikesData;
    NSURLConnection *theConnection_GetDraftsData;
    NSURLConnection *theConnection_DeleteDraftData;
    NSURLConnection *theConnection_CheckLikeCountData;
    
    NSString *GetName;
    NSString *Getusername;
    NSString *GetEmail;
    NSString *GetLocation;
    NSString *GetAbouts;
    NSString *GetUrl;
    NSString *GetFollowersCount;
    NSString *GetFollowingCount;
    NSString *Getcategories;
    NSString *Getdob;
    NSString *GetGender;
    NSString *Getprofile_photo;
    NSString *Getrole;
    NSString *GetSystemLanguage;
    NSString *GetWallpaper;
    NSString *GetLanguage_1;
    NSString *GetLanguage_2;
    
    //post data
    NSString *GetPostsDataCount;
    NSMutableArray *PostsData_PhotoArray;
    NSMutableArray *PostsData_IDArray;
    NSMutableArray *PostsData_place_nameArray;
    NSMutableArray *PostsData_UserInfo_UrlArray;
    NSMutableArray *PostsData_UserInfo_NameArray;
    NSMutableArray *PostsData_TitleArray;
    NSMutableArray *PostsData_MessageArray;
    NSMutableArray *PostsData_DistanceArray;
    NSMutableArray *PostsData_SearchDisplayNameArray;
    NSMutableArray *PostsData_TotalCommentArray;
    NSMutableArray *PostsData_TotalLikeArray;
    NSMutableArray *PostsData_SelfCheckLikeArray;
    
    //like data
    NSString *GetLikesDataCount;
    NSMutableArray *LikesData_PhotoArray;
    NSMutableArray *LikesData_IDArray;
    //Drafts
    NSString *GetDraftsDataCount;
    NSMutableArray *DraftsData_PhotoArray;
    NSMutableArray *DraftData_PhotoIDArray;
    NSMutableArray *DraftsData_PhotoCountArray;
    NSMutableArray *DraftData_PlaceNameArray;
    NSMutableArray *DraftData_UpdateTimeArray;
    NSMutableArray *DraftData_TitleArray;
    NSMutableArray *DraftData_MessageArray;
    NSMutableArray *DraftData_TitleCodeArray;
    NSMutableArray *DraftData_MessageCodeArray;
    NSMutableArray *DraftData_CategoryArray;
    NSMutableArray *DraftData_IDArray;
    NSMutableArray *DraftData_PlaceFormattedAddress;
    NSMutableArray *DraftData_PhotoCaptionArray;
    NSMutableArray *DraftData_BlogLinkArray;
    NSMutableArray *DraftData_TagArray;
    NSMutableArray *DraftData_LatArray;
    NSMutableArray *DraftData_LngArray;
    NSMutableArray *DraftData_LocationContactArray;
    NSMutableArray *DraftData_LocationLinkArray;
    NSMutableArray *DraftData_LocationReferenceArray;
    NSMutableArray *DraftData_LocationPlaceIDArray;
    NSMutableArray *DraftData_ExpenseArray;
    NSMutableArray *DraftData_ExpenseCodeArray;
    //route,locality,administrative_area_level_1,postalCode,country,type
    NSMutableArray *DraftData_LocationRouteArray;
    NSMutableArray *DraftData_LocationLocalityArray;
    NSMutableArray *DraftData_LocationAdministrative_Area_Level_1Array;
    NSMutableArray *DraftData_LocationPostalCodeArray;
    NSMutableArray *DraftData_LocationCountryArray;
    NSMutableArray *DraftData_LocationTypeArray;
    
    NSMutableArray *DraftData_OpenNowArray;
    NSMutableArray *DraftData_PeriodsArray;
    
    NSString *GetDeletePostID;
    
    NSString *CheckGoWhere;
    
    IBOutlet UILabel *ShowKosongData_1;
    IBOutlet UILabel *ShowKosongData_2;
    IBOutlet UIButton *KosongViewButton;
    IBOutlet UIImageView *ArrowIcon;
    
    BOOL CheckLoadDone;
    
    int GetHeight;
    
    UIScrollView *PostsScroll;
    UIScrollView *LikesScroll;
    UIScrollView *DraftScroll;
    
    NSMutableArray *BadgesNameArray;
    NSMutableArray *BadgesImageArray;
    
    NSString *AwardCheck;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    NSInteger TotalPage_Post;
    NSInteger CurrentPage_Post;
    NSInteger DataCount_Post;
    NSInteger DataTotal_Post;
    
    BOOL CheckLoad_Likes;
    BOOL CheckLoad_Post;
    int CheckFirstTimeLoadLikes;
    int CheckFirstTimeLoadPost;
    
    CGFloat difference1;
    CGFloat difference2;
    
    UISegmentedControl *PostControl;
    
    UIActivityIndicatorView *ShowActivityLike;
    UIActivityIndicatorView *ShowActivityDraft;
}
-(IBAction)SettingsButton:(id)sender;
-(IBAction)ShareButton:(id)sender;
-(IBAction)ClickFullImageButton:(id)sender;

-(IBAction)KosongViewButton:(id)sender;
@end

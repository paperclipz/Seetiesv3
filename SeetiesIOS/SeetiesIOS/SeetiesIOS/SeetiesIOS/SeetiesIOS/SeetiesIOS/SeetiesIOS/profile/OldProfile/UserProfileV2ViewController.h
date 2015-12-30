//
//  UserProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface UserProfileV2ViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BackgroundImage;
    IBOutlet UIImageView *ImageShade;
    IBOutlet AsyncImageView *ShowUserWallpaperImage;
    IBOutlet UILabel *ShowName;
    IBOutlet AsyncImageView *ShowUserProfile;
    IBOutlet UIImageView *SettingBarImage;
    //IBOutlet UIView *SettingBarImage;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIButton *FullImageButton;
    IBOutlet UIImageView *ShareIcon;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIImageView *ImgShade;
    
    IBOutlet UIView *TopBarView;
    
    int segmentActionCheck;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_GetPostsData;
    NSURLConnection *theConnection_GetLikesData;
    NSURLConnection *theConnection_SendFollow;
    
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
    NSString *GetUID;
    NSString *GetUserFollowing;
    
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
    NSString *GetUserName;
    
    UIButton *FollowButton;
    
    int GetHeight;
    
    UIScrollView *PostsScroll;
    UIScrollView *LikesScroll;
    
    NSMutableArray *BadgesNameArray;
    NSMutableArray *BadgesImageArray;
    
    NSString *AwardCheck;
    
    BOOL CheckLoadDone;
    
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
}
-(void)GetUsername:(NSString *)username;
-(IBAction)ShareButton:(id)sender;
-(IBAction)ClickFullImageButton:(id)sender;
@end

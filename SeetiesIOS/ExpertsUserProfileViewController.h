//
//  ExpertsUserProfileViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/27/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface ExpertsUserProfileViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>{

    NSString *GetUsername;
    
    IBOutlet UILabel *ShowUsername;
    IBOutlet AsyncImageView *ShowUserProfileImage;
    IBOutlet AsyncImageView *ShowUserWallpaperImage;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *SettingBarImage;
    IBOutlet UIButton *FollowButton;
    IBOutlet UILabel *ShowExpertsLink;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetPost;
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_SendFollow;
    NSURLConnection *theConnection_MorePost;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *LPhotoArray;
    NSMutableArray *TitleArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_AddressArray;
    NSMutableArray *UserInfo_uidArray;
    NSMutableArray *UserInfo_FollowingArray;
    NSMutableArray *LocationArray;
    NSMutableArray *FullPhotoArray;
    NSMutableArray *MessageArray;
    NSMutableArray *LikesArray;
    NSMutableArray *CommentArray;
    NSMutableArray *LangArray;
    NSMutableArray *LatArray;
    NSMutableArray *LongArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *CheckLikeArray;
    NSMutableArray *Activities_profile_photoArray;
    NSMutableArray *Activities_typeArray;
    NSMutableArray *Activities_uidArray;
    NSMutableArray *Activities_usernameArray;
    NSMutableArray *LinkArray;
    
    IBOutlet UILabel *Showname;
   // IBOutlet UILabel *ShowLocation;
    IBOutlet UILabel *ShowAbout;
    IBOutlet UILabel *ShowUrl;
    IBOutlet UILabel *ShowFollowersCount;
    IBOutlet UILabel *ShowFollowingCount;
    
    NSString *GetUserProfilePhoto;
    NSString *Getuid;
    NSString *GetUserFollowing;
    IBOutlet UIImageView *ShowExpertsImg;
    IBOutlet UILabel *ShowFollowersText;
    IBOutlet UILabel *ShowFollowingText;
    IBOutlet UIButton *ShowFollowersButton;
    IBOutlet UIButton *ShowFollowingButton;
    IBOutlet UILabel *ShowDemo;
    IBOutlet UIButton *LineButton;
    IBOutlet UIButton *LinkButton;
    IBOutlet UIImageView *ShowMapPin;
    
    int TotalPage;
    int CurrentPage;
    int DataCount;
    int DataTotal;
    
    BOOL CheckLoad;
    
    NSString *Getrole;
    
    int ProfileHeight;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)FollowButton:(id)sender;
-(void)GetUsername:(NSString *)username;
-(void)GetUserWallpaper;
-(void)GetUserPost;
-(void)GetUserData;

-(IBAction)ShowAll_FollowerButton:(id)sender;
-(IBAction)ShowAll_FollowingButton:(id)sender;

-(IBAction)ClickFullImageButton:(id)sender;

-(IBAction)OpenUrlButton:(id)sender;

-(IBAction)ShareButton:(id)sender;
@end

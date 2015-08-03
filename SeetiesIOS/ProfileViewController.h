//
//  ProfileViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface ProfileViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>{

    IBOutlet UILabel *ShowUsername;
    IBOutlet AsyncImageView *ShowUserProfileImage;
    IBOutlet AsyncImageView *ShowUserWallpaperImage;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *SettingBarImage;
    
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetPost;
    NSURLConnection *theConnection_GetUserData;
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
  //  IBOutlet UILabel *ShowLocation;
    IBOutlet UILabel *ShowAbout;
    IBOutlet UILabel *ShowUrl;
    IBOutlet UILabel *ShowFollowersCount;
    IBOutlet UILabel *ShowFollowingCount;
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
    NSString *Getusername;
    
    int ProfileHeight;
    int CheckDataReload;
}
-(IBAction)SettingsButton:(id)sender;
-(IBAction)ShareButton:(id)sender;
-(void)GetUserWallpaper;
-(void)GetUserPost;
-(void)GetUserData;

-(IBAction)ShowAll_FollowerButton:(id)sender;
-(IBAction)ShowAll_FollowingButton:(id)sender;

-(IBAction)ClickFullImageButton:(id)sender;


-(IBAction)OpenUrlButton:(id)sender;
@end

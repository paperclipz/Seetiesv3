//
//  NewUserProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/8/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3ParallaxScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"
@interface NewUserProfileV2ViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>{
    
    IBOutlet A3ParallaxScrollView *MainScroll;
    IBOutlet AsyncImageView *BackgroundImage;
    IBOutlet UIView *AllContentView;
    IBOutlet UIImageView *ShowOverlayImg;
    
    IBOutlet UIButton *ShareButton;
    IBOutlet UIButton *MoreButton;
    
    IBOutlet UIImageView *backIcon;
    IBOutlet UIButton *BackButton;
    
    NSString *GetUserName;
    IBOutlet UIActivityIndicatorView *ShowLoadingActivity;

    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_GetPostsData;
    NSURLConnection *theConnection_GetLikesData;
    NSURLConnection *theConnection_GetCollectionData;
    NSURLConnection *theConnection_SendFollow;
    
    NSString *GetProfileImg;
    NSString *GetWallpaper;
    NSString *GetReturnUserName;
    NSString *GetName;
    NSString *GetLocation;
    NSString *GetDescription;
    NSString *GetLink;
    NSString *GetFollowersCount;
    NSString *GetFollowingCount;
    NSString *GetUid;
    NSString *GetUserFollowing;
    NSString *GetPersonalTags;
    NSMutableArray *ArrHashTag;
    
    //content data
    AsyncImageView *ShowUserProfileImage;
    
    int GetHeight;
    BOOL CheckExpand;
    
    UISegmentedControl *ProfileControl;
    
    UIView *PostView;
    UIView *CollectionView;
    UIView *LikeView;
    
    //like data
    NSString *GetLikesDataCount;
    NSMutableArray *LikesData_PhotoArray;
    NSMutableArray *LikesData_IDArray;
    
    //posts data
    NSString *GetPostsDataCount;
    NSMutableArray *PostsData_PhotoArray;
    NSMutableArray *PostsData_IDArray;
    NSMutableArray *PostsData_place_nameArray;
    NSMutableArray *PostsData_UserInfo_UrlArray;
    NSMutableArray *PostsData_TitleArray;
    NSMutableArray *PostsData_TotalCountArray;
    NSMutableArray *PostsData_DisplayCountryName;
    
    //collection data
    NSString *GetCollectionDataCount;
    NSMutableArray *CollectionData_IDArray;
    NSMutableArray *CollectionData_TitleArray;
    NSMutableArray *CollectionData_DescriptionArray;
    NSMutableArray *CollectionData_PhotoArray;
    
    UIActivityIndicatorView *ShowActivityLike;
    UIActivityIndicatorView *ShowActivityPosts;
    UIActivityIndicatorView *ShowActivityCollection;
    
    NSInteger TotalPage_Like;
    NSInteger CurrentPage_Like;
    NSInteger DataCount_Like;
    NSInteger DataTotal_Like;
    
    NSInteger TotalPage_Post;
    NSInteger CurrentPage_Post;
    NSInteger DataCount_Post;
    NSInteger DataTotal_Post;
    
    NSInteger TotalPage_Collection;
    NSInteger CurrentPage_Collection;
    NSInteger DataCount_Collection;
    NSInteger DataTotal_Collection;
    
    BOOL CheckLoad_Likes;
    BOOL CheckLoad_Post;
    BOOL CheckLoad_Collection;
    int CheckFirstTimeLoadLikes;
    int CheckFirstTimeLoadPost;
    int CheckFirstTimeLoadCollection;
    
    UIButton *FollowUserButton;
    
    int CheckClick_Posts;
    int CheckClick_Likes;
}
-(void)GetUserName:(NSString *)username;
-(void)GetUid:(NSString *)uid;
-(IBAction)BackButtonOnClick:(id)sender;
-(IBAction)ShareButton:(id)sender;
@end

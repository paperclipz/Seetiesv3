//
//  NewProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3ParallaxScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"

//https://github.com/freak4pc/SMTagField tag simple
@interface NewProfileV2ViewController : BaseViewController<UIScrollViewDelegate,UISearchBarDelegate>{

    IBOutlet A3ParallaxScrollView *MainScroll;
    IBOutlet AsyncImageView *BackgroundImage;
    IBOutlet UIView *AllContentView;
    
    int GetHeight;
    
    UISegmentedControl *ProfileControl;
    
    UIView *PostView;
    UIView *CollectionView;
    UIView *LikeView;
    
    IBOutlet UIButton *SettingsButton;
    IBOutlet UIButton *ShareButton;
    IBOutlet UISearchBar *SearchBarTemp;
    
    BOOL CheckExpand;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_GetPostsData;
    NSURLConnection *theConnection_GetLikesData;
    
    //content data
    AsyncImageView *ShowUserProfileImage;
    
    
    NSString *GetProfileImg;
    NSString *GetName;
    NSString *GetUserName;
    NSString *GetLocation;
    NSString *GetDescription;
    NSString *GetLink;
    NSString *GetFollowersCount;
    NSString *GetFollowingCount;
    NSString *GetCategories;
    
    
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
    
    UIActivityIndicatorView *ShowActivityLike;
    UIActivityIndicatorView *ShowActivityPosts;
    
    NSInteger TotalPage_Like;
    NSInteger CurrentPage_Like;
    NSInteger DataCount_Like;
    NSInteger DataTotal_Like;
    
    NSInteger TotalPage_Post;
    NSInteger CurrentPage_Post;
    NSInteger DataCount_Post;
    NSInteger DataTotal_Post;
    
    BOOL CheckLoad_Likes;
    BOOL CheckLoad_Post;
    int CheckFirstTimeLoadLikes;
    int CheckFirstTimeLoadPost;
    
    IBOutlet UIButton *SearchButton;
}
-(IBAction)SettingsButton:(id)sender;
-(IBAction)SearchButton:(id)sender;
@end

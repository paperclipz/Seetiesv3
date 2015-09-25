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

#import "EditCollectionViewController.h"
#import "EditCollectionDetailViewController.h"

//https://github.com/freak4pc/SMTagField tag simple
@interface NewProfileV2ViewController : BaseViewController<UIScrollViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>{

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
    NSURLConnection *theConnection_GetCollectionData;
    
    //content data
    AsyncImageView *ShowUserProfileImage;
    
    UILabel *ShowUserName;
    UILabel *ShowName_;
    UILabel *ShowAboutText;
    UILabel *ShowLink;
    
    NSString *GetProfileImg;
    NSString *GetName;
    NSString *GetUserName;
    NSString *GetLocation;
    NSString *GetDescription;
    NSString *GetLink;
    NSString *GetFollowersCount;
    NSString *GetFollowingCount;
    NSString *GetCategories;
    NSString *Getdob;
    NSString *GetGender;
    NSString *GetPersonalTags;
    NSMutableArray *ArrHashTag;
    NSString *GetEmail;
    NSString *GetSystemLanguage;
    NSString *GetPrimaryLanguage;
    NSString *GetSecondaryLanguage;
    
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
    
    IBOutlet UIButton *SearchButton;
}
-(IBAction)SettingsButton:(id)sender;
-(IBAction)SearchButton:(id)sender;




@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)EditCollectionDetailViewController* editCollectionDetailViewController;

@end

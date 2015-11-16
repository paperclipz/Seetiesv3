//
//  SearchDetailViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/3/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "ProfileViewController.h"
@class ProfileViewController;
@interface SearchDetailViewController : GAITrackedViewController<UIScrollViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *UserScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIImageView *BarImage;
    IBOutlet UITextField *SearchTextField;
    IBOutlet UITextField *SearchAddressField;
    NSString *GetKeywordText;
    NSString *GetLat;
    NSString *GetLong;
    NSString *GetCategoryText;
    NSString *GetLocationName;
    NSString *GetCurrentLat;
    NSString *GetCurrentLong;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetSearchKeyword;
    NSURLConnection *theConnection_GetSearchCategory;
    NSURLConnection *theConnection_GetExpertsSearch;
    NSURLConnection *theConnection_GetAllUserData;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_QuickCollect;
    NSURLConnection *theConnection_GetCollection;
    NSURLConnection *theConnection_FollowCollect;
    
    NSMutableArray *LPhotoArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *LocationArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    NSMutableArray *DistanceArray;
    NSMutableArray *SearchDisplayNameArray;
    NSMutableArray *TotalCommentArray;
    NSMutableArray *TotalLikeArray;
    NSMutableArray *SelfCheckLikeArray;
    NSMutableArray *UserInfo_FollowArray;
    NSMutableArray *UserInfo_IDArray;
    NSMutableArray *CollectArray;
    
    NSMutableArray *Experts_Username_Array;
    NSMutableArray *Experts_Name_Array;
    NSMutableArray *Experts_ProfilePhoto_Array;
    NSMutableArray *Experts_uid_Array;
    NSMutableArray *Experts_Followed_Array;
    
    NSMutableArray *Collection_arrID;
    NSMutableArray *Collection_arrTitle;
    NSMutableArray *Collection_arrTotalCount;
    NSMutableArray *Collection_arrImageData;
    NSMutableArray *Collection_arrFollowing;
    
    NSMutableArray *Collection_arrUsername;
    NSMutableArray *Collection_arrUserImage;
    NSMutableArray *Collection_arrUserID;
    
    NSInteger CheckInt;
    NSString *StringSortby;
    
    IBOutlet UITextField *SearchText;
    IBOutlet UIView *ShowNoDataView;
    
    IBOutlet UIView *ShowSearchUserView;
    
    IBOutlet UILabel *ShowNoText_1;
    IBOutlet UILabel *ShowNoText_2;
    
    IBOutlet UIButton *Background_Search;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    int CheckWhichOne;
    int heightcheck;
    
    IBOutlet UIButton *SortbyFullButton;
    
    UIView *PostsView;
    UIView *PeopleView;
    UIView *CollectionView;
    
    IBOutlet UIView *ShowSearchLocationView;
    IBOutlet UITableView *LocationTblView;
    
    NSMutableArray *SearchLocationNameArray;
    NSMutableArray *SearchPlaceIDArray;
    NSString *GetSearchPlaceID;
    
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GetSearchPlace;
    NSString *GetUserID;
    NSString *GetFollowString;
    
    NSString *GetPostsFollow;
    NSString *GetCollect;
    NSString *GetPostsUserID;
    
    NSInteger MainGetButtonIDN;
    NSInteger CheckFollowView;
    
    int SelfSearchCurrentLocation;
    NSInteger CheckUserInitView;
    NSInteger CheckPostsInitView;
    NSInteger CheckCollectionInitView;
    NSInteger SegmentedControlCheck;
    
    
    NSString *GetCollectionFollowing;
    NSString *GetCollectID;
    NSString *GetCollectUserID;
}
@property(nonatomic,strong)ProfileViewController* profileViewController;
-(void)GetSearchKeyword:(NSString *)Keyword Getlat:(NSString *)lat GetLong:(NSString *)Long GetLocationName:(NSString *)LocationName GetCurrentLat:(NSString *)CurrentLat GetCurrentLong:(NSString *)CurrentLong;
-(void)GetTitle:(NSString *)String;

-(IBAction)SortbyButton:(id)sender;
@end

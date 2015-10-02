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
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetSearchKeyword;
    NSURLConnection *theConnection_GetSearchCategory;
    NSURLConnection *theConnection_GetExpertsSearch;
    NSURLConnection *theConnection_GetAllUserData;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_QuickCollect;
    
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
    
    NSMutableArray *All_Experts_Username_Array;
    NSMutableArray *All_Experts_Name_Array;
    NSMutableArray *All_Experts_ProfilePhoto_Array;
    NSMutableArray *All_Experts_uid_Array;
    NSMutableArray *All_Experts_Followed_Array;
    
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
}
-(void)GetSearchKeyword:(NSString *)Keyword Getlat:(NSString *)lat GetLong:(NSString *)Long GetLocationName:(NSString *)LocationName;
-(void)GetTitle:(NSString *)String;

-(IBAction)SortbyButton:(id)sender;
@end

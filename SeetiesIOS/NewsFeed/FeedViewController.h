//
//  FeedViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/14/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
@interface FeedViewController : BaseViewController<UIScrollViewDelegate,CLLocationManagerDelegate>{
    
    //no connection view
    IBOutlet UIView *NoConnectionView;
    IBOutlet UILabel *ShowNoConnectionText;
    IBOutlet UIImageView *NoConnectionImg;
    IBOutlet UIButton *TryAgainButton;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *LocalScroll;
    UIRefreshControl *refreshControl;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UILabel *ShowFeedText;
    IBOutlet UIButton *SearchButton;
    IBOutlet UIButton *FilterButton;
    IBOutlet UIImageView *BarImage;
    
    int heightcheck;
    int TestCheck;
    int TotalCount;
    int CheckInitData;
    
    NSMutableArray *arrAddress;
    NSMutableArray *arrTitle;
    NSMutableArray *arrMessage;
    NSMutableArray *arrType;
    NSMutableArray *arrImage;
    NSMutableArray *arrUserImage;
    NSMutableArray *arrUserName;
    NSMutableArray *arrDistance;
    NSMutableArray *arrDisplayCountryName;
    NSMutableArray *arrPostID;
    NSMutableArray *arrImageWidth;
    NSMutableArray *arrImageHeight;
    NSMutableArray *arrlike;
    NSMutableArray *arrCollect;
    
    NSMutableArray *User_IDArray;
    NSMutableArray *User_ProfileImageArray;
    NSMutableArray *User_NameArray;
    NSMutableArray *User_LocationArray;
    NSMutableArray *User_FollowArray;
    NSMutableArray *User_UserNameArray;
    NSMutableArray *User_PhotoArray;
    
    NSMutableArray *arrType_Announcement;
    NSMutableArray *arrID_Announcement;
    
    NSMutableArray *arrAboadID;
    NSMutableArray *arrfeaturedUserName;
    NSMutableArray *arrFriendUserName;
    NSMutableArray *arrDealID;
    
    NSMutableArray *arrCollectionID;
    NSMutableArray *arrCollectionName;
    NSMutableArray *arrCollectionDescription;
    
    
    NSString *GetNextPaging;
    
    
    NSDate *methodStart;
    
    IBOutlet UILabel *ShowUpdateText;
    
    UIScrollView *SuggestedScrollview_Deal;
    UIPageControl *SuggestedpageControl_Deal;
    UILabel *ShowSuggestedCount_Deal;
    
    UIScrollView *SuggestedScrollview_Aboad;
    UIPageControl *SuggestedpageControl_Aboad;
    UILabel *ShowSuggestedCount_Aboad;
    
    UIScrollView *SUserScrollview_Friend;
    UIPageControl *SUserpageControl_Friend;
    UILabel *ShowSUserCount_Friend;
    
    UIScrollView *SUserScrollview_Featured;
    UIPageControl *SUserpageControl_Featured;
    UILabel *ShowSUserCount_Featured;
    
    UIScrollView *CollectionScrollview;
    
    UrlDataClass *DataUrl;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_QuickCollect;
    NSURLConnection *theConnection_TrackPromotedUserViews;
    
    NSString *latPoint;
    NSString *lonPoint;
    NSString *ExternalIPAddress;
    
    NSMutableData *webData;
    
   // NSInteger TotalPage;
   // NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger Offset;
    
    int CheckFirstTimeLoad;
    BOOL OnLoad;
    
    //send like data
    NSString *SendLikePostID;
    NSString *CheckLike;
    NSString *CheckCollect;
    NSString *GetPostID;
    
    UIButton *MainNearbyButton;
    
    //tracker url
    NSString *TrackerUrl;
    
    UIView *RateView;
}
-(IBAction)TryAgainButton:(id)sender;
-(IBAction)SearchButton:(id)sender;
-(IBAction)InviteFriendsButton:(id)sender;

-(IBAction)ScrollTotopButton:(id)sender;
@end

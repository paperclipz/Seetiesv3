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
    
    NSString *GetNextPaging;
    
    
    NSDate *methodStart;
    
    IBOutlet UILabel *ShowUpdateText;
    
    UIScrollView *SuggestedScrollview;
    UIPageControl *SuggestedpageControl;
    UILabel *ShowSuggestedCount;
    
    UIScrollView *SUserScrollview;
    UIPageControl *SUserpageControl;
    UILabel *ShowSUserCount;
    
    UrlDataClass *DataUrl;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_QuickCollect;
    
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
}
-(IBAction)TryAgainButton:(id)sender;
-(IBAction)SearchButton:(id)sender;
-(IBAction)InviteFriendsButton:(id)sender;
@end

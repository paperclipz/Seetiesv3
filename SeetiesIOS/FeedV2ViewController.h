//
//  FeedV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/7/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "AsyncImageView.h"
#import "LLARingSpinnerView.h"
#import "DoImagePickerController.h"

@interface FeedV2ViewController : GAITrackedViewController<UIScrollViewDelegate,DoImagePickerControllerDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIView *KosongView;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    //LLARingSpinnerView *spinnerView;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_MorePost;
    NSURLConnection *theConnection_UserSuggestions;
    NSURLConnection *theConnection_Following;
    //data array
    NSMutableArray *TitleArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *PhotoArray;
    NSMutableArray *PhotoCaptionArray;
    NSMutableArray *LocationDataArray;
    NSMutableArray *UpdatedTimeArray;
    NSMutableArray *SelfCheckLikeArray;
    NSMutableArray *TotalLikeArray;
    NSMutableArray *TotalCommentArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *PlaceNameArray;
    NSMutableArray *MessageArray;
    NSMutableArray *DistanceArray;
    NSMutableArray *SearchDisplayNameArray;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    BOOL CheckLoad;
    BOOL CheckSuggestions;
    BOOL CheckFirstTimeUser;
    NSInteger CountFollowFirstTime;
    
    //user suggestions data
    NSMutableArray *User_IDArray;
    NSMutableArray *User_NameArray;
    NSMutableArray *User_LocationArray;
    NSMutableArray *User_ProfilePhotoArray;
    NSMutableArray *User_PhotoArray;
    NSMutableArray *User_UserNameArray;
    
    NSString *GetUserID;
    
    UIScrollView *ShowUserSuggestionsView;
    
    NSInteger CheckFollow;
    NSInteger AddFollowCount;
    
   IBOutlet UILabel *ShowFeedText;
   IBOutlet UIButton *NearbyButton;
   IBOutlet UIImageView *BarImage;

    BOOL CheckLoadDone;
    NSInteger DontLoadAgain;
    
    NSString *latPoint;
    NSString *lonPoint;
    int heightcheck;
    UIActivityIndicatorView * activityindicator1;
    
    IBOutlet UIImageView *ArrowIcon;
    IBOutlet UILabel *KosongLabel_1;
    IBOutlet UILabel *KosongLabel_2;
    
    NSInteger CheckGoPost;
    
    IBOutlet UIButton *FilterButton;

    IBOutlet UIButton *ClickBackToTopButton;
    
    NSString *GetPromotionImage;
    NSString *GetPromotionUserName;
    
    BOOL CheckPromotion;
    
    NSString *ExternalIPAddress;
}
-(IBAction)NearbyButton:(id)sender;
-(IBAction)FiltersButton:(id)sender;
-(IBAction)ClickBackToTopButton:(id)sender;

@end

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
    
    IBOutlet UIScrollView *MainScroll;
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
    NSString *latPoint;
    NSString *lonPoint;
    NSString *ExternalIPAddress;
    
    NSMutableData *webData;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    int CheckFirstTimeLoad;
    BOOL OnLoad;
}
-(IBAction)SearchButton:(id)sender;

@end

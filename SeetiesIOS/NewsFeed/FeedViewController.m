//
//  FeedViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/14/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "FeedViewController.h"
#import "AsyncImageView.h"
#import "SearchViewV2Controller.h"
#import "Filter2ViewController.h"
#import "InviteFrenViewController.h"
#import "FeedV2DetailViewController.h"
#import "NewUserProfileV2ViewController.h"
#import "NearbyViewController.h"
#import "AddCollectionDataViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "EnbleLocationViewController.h"
#import "LandingV2ViewController.h"
#import "AnnounceViewController.h"
#import "SuggestedCollectionsViewController.h"
#import "OpenWebViewController.h"

@interface FeedViewController ()
{
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
    NSMutableArray *arrUserID;
    NSMutableArray *arrDistance;
    NSMutableArray *arrDisplayCountryName;
    NSMutableArray *arrPostID;
    NSMutableArray *arrImageWidth;
    NSMutableArray *arrImageHeight;
    NSMutableArray *arrlike;
    NSMutableArray *arrCollect;
    
    NSMutableArray *arrLocalAddress;
    NSMutableArray *arrLocalTitle;
    NSMutableArray *arrLocalMessage;
    NSMutableArray *arrLocalType;
    NSMutableArray *arrLocalImage;
    NSMutableArray *arrLocalUserImage;
    NSMutableArray *arrLocalUserName;
    NSMutableArray *arrLocalUserID;
    NSMutableArray *arrLocalDistance;
    NSMutableArray *arrLocalDisplayCountryName;
    NSMutableArray *arrLocalPostID;
    NSMutableArray *arrLocalImageWidth;
    NSMutableArray *arrLocalImageHeight;
    NSMutableArray *arrLocallike;
    NSMutableArray *arrLocalCollect;
    
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
    NSMutableArray *arrfeaturedUserID;
    NSMutableArray *arrFriendUserID;
    NSMutableArray *arrAboadUserID;
    NSMutableArray *arrDealUserID;
    
    NSMutableArray *arrCollectionID;
    NSMutableArray *arrCollectionName;
    NSMutableArray *arrCollectionDescription;
    NSMutableArray *arrCollectionFollowing;
    NSMutableArray *arrCollectionUserID;
    
    
    NSString *GetNextPaging;
    
    
    NSDate *methodStart;
    
    IBOutlet UILabel *ShowUpdateText;
    
    UIScrollView *SuggestedScrollview_Deal;
//    UIPageControl *SuggestedpageControl_Deal;
//    UILabel *ShowSuggestedCount_Deal;
    
    UIScrollView *SuggestedScrollview_Aboad;
//    UIPageControl *SuggestedpageControl_Aboad;
//    UILabel *ShowSuggestedCount_Aboad;
    
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
    NSURLConnection *theConnection_FollowCollect;

    
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
    
    NSString *GetCollectionFollowing;
    NSString *GetCollectID;
    NSString *GetCollectUserID;

    //follow_suggestion_friend Check
    int CheckFollowSuggestionFriend;
    int FollowSuggestionFriendCount;
    
    //follow_suggestion_featured
    int CheckFollowSuggestionFeatured;
    int FollowSuggestionFeaturedCount;
    
    NSMutableArray *SplitArray_Id_Friend;
    NSMutableArray *SplitArray_ProfileImg_Friend;
    NSMutableArray *SplitArray_Username_Friend;
    NSMutableArray *SplitArray_PostsImg_Friend;
    
    NSMutableArray *SplitArray_Id_Featured;
    NSMutableArray *SplitArray_ProfileImg_Featured;
    NSMutableArray *SplitArray_Username_Featured;
    NSMutableArray *SplitArray_PostsImg_Featured;
    
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation FeedViewController

#pragma mark - Declaration

-(SeetiesShopViewController*)seetiesShopViewController
{
    
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    return _seetiesShopViewController;
}
-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [[ShareV2ViewController alloc]initWithNibName:@"ShareV2ViewController" bundle:nil];
    }
    
    return _shareV2ViewController;
}

-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}
-(SuggestedCollectionPostsViewController*)followingCollectionPostsViewController
{
    if (!_followingCollectionPostsViewController) {
        _followingCollectionPostsViewController = [SuggestedCollectionPostsViewController new];
    }
    
    return _followingCollectionPostsViewController;
}

#pragma mark - IBAction
- (IBAction)btnTestClicked:(id)sender {
    
    _seetiesShopViewController = nil;
   // [self.seetiesShopViewController initDataWithSeetiesID:@"56397e301c4d5be92e8b4711" Latitude:1.934400 Longitude:103.358727];
    [self.seetiesShopViewController initDataPlaceID:@"56603c9af9df245c7b8b4572" postID:@"56603c9af9df245c7b8b4573" Latitude:1.934400 Longitude:103.358727];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self.seetiesShopViewController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger CheckInt = [defaults integerForKey:@"RateData"];
    NSLog(@"CheckInt is %li",(long)CheckInt);

    if (CheckInt == 5) {
        [self ShowRateView];
    }else if(CheckInt == 10){
    
    }else{
        CheckInt += 1;
        [defaults setInteger:CheckInt forKey:@"RateData"];
        [defaults synchronize];
    }
//    [self ShowRateView];
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //init no connection data
    NoConnectionView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 50);
    ShowNoConnectionText.frame = CGRectMake((screenWidth / 2) - 100, 215, 200, 60);
    TryAgainButton.frame = CGRectMake((screenWidth / 2) - 67, 288, 135, 40);
    TryAgainButton.layer.cornerRadius = 5;
    
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    MainScroll.delegate = self;
    MainScroll.alwaysBounceVertical = YES;
    
    LocalScroll.frame = CGRectMake(0, 44, screenWidth, screenHeight);
    LocalScroll.delegate = self;
    LocalScroll.alwaysBounceVertical = YES;
    LocalScroll.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    
    
    ShowFeedText.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowFeedText.text = CustomLocalisedString(@"Feed", nil);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SearchButton.frame = CGRectMake(screenWidth - 40, 20, 40, 44);
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    //    ShowFeedText.text = CustomLocalisedString(@"MainTab_Feed",nil);
    //    [NearbyButton setTitle:CustomLocalisedString(@"NearBy",nil) forState:UIControlStateNormal];
    //    [FilterButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    
    heightcheck = 0;
    CheckInitData = 0;
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height == 480 || result.height == 568) {
        refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x,
                                           0,
                                           refreshControl.bounds.size.width,
                                           refreshControl.bounds.size.height);
    }else{
        refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 25,
                                           0,
                                           refreshControl.bounds.size.width,
                                           refreshControl.bounds.size.height);
    }

     //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager startUpdatingLocation];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
                [self.locationManager startUpdatingLocation];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
    

    MainNearbyButton= [[UIButton alloc]init];
    MainNearbyButton.frame = CGRectMake((screenWidth / 2) - 60, 74, 120, 37);
    [MainNearbyButton setTitle:LocalisedString(@"Nearby_") forState:UIControlStateNormal];
    [MainNearbyButton setImage:[UIImage imageNamed:@"NearbyIcon.png"] forState:UIControlStateNormal];
    MainNearbyButton.backgroundColor = [UIColor clearColor];
    MainNearbyButton.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:190.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
    MainNearbyButton.layer.cornerRadius = 20;
    MainNearbyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    MainNearbyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    MainNearbyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [MainNearbyButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    [MainNearbyButton addTarget:self action:@selector(NearbyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: MainNearbyButton];
    MainNearbyButton.hidden = YES;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}
-(void)ShowRateView{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    RateView = [[UIView alloc]init];
    RateView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    RateView.backgroundColor = [UIColor clearColor];
    //RateView.alpha = 0.5f;
    [self.view addSubview:RateView];
    
    UIButton *BlackImg = [[UIButton alloc]init];
    [BlackImg setTitle:@"" forState:UIControlStateNormal];
    BlackImg.backgroundColor = [UIColor blackColor];
    BlackImg.alpha = 0.5f;
    BlackImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [RateView addSubview:BlackImg];
    
    UIImageView *RateImg = [[UIImageView alloc]init];
    RateImg.frame = CGRectMake((screenWidth / 2) - 135, 150, 270, 290);
    RateImg.image = [UIImage imageNamed:@"RateUs.png"];
    [RateView addSubview:RateImg];
    
    
    UILabel *ShowThxText = [[UILabel alloc]init];
    ShowThxText.text = LocalisedString(@"Do you like what we've done?");
    ShowThxText.frame = CGRectMake((screenWidth / 2) - 115, 260, 230, 60);
    ShowThxText.backgroundColor = [UIColor clearColor];
    ShowThxText.textColor = [UIColor whiteColor];
    ShowThxText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:20];
    ShowThxText.textAlignment = NSTextAlignmentCenter;
    ShowThxText.numberOfLines = 2;
    [RateView addSubview:ShowThxText];
    
    
    UIButton *CancelButton = [[UIButton alloc]init];
    [CancelButton setTitle:@"" forState:UIControlStateNormal];
    CancelButton.backgroundColor = [UIColor clearColor];
    CancelButton.frame = CGRectMake((screenWidth / 2) + 85, 150, 50, 50);
    [CancelButton addTarget:self action:@selector(Rate_CancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [RateView addSubview:CancelButton];
    
    UIButton *RateButton = [[UIButton alloc]init];
    [RateButton setTitle:LocalisedString(@"Rate us now") forState:UIControlStateNormal];
    RateButton.backgroundColor = [UIColor clearColor];
    RateButton.frame = CGRectMake((screenWidth / 2) - 135, 350, 270, 40);
    [RateButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16]];
    [RateButton addTarget:self action:@selector(Rate_RateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [RateView addSubview:RateButton];
    
    UIButton *NotNowButton = [[UIButton alloc]init];
    [NotNowButton setTitle:LocalisedString(@"Not now") forState:UIControlStateNormal];
    NotNowButton.backgroundColor = [UIColor clearColor];
    NotNowButton.frame = CGRectMake((screenWidth / 2) - 135, 390, 270, 40);
    [NotNowButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15]];
    [NotNowButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [NotNowButton addTarget:self action:@selector(Rate_NotNowButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [RateView addSubview:NotNowButton];

}
-(IBAction)Rate_CancelButtonOnClick:(id)sender{
    [RateView removeFromSuperview];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger CheckInt = 0;
    [defaults setInteger:CheckInt forKey:@"RateData"];
    [defaults synchronize];

}
-(IBAction)Rate_RateButtonOnClick:(id)sender{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=956400552&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    [RateView removeFromSuperview];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger CheckInt = 10;
    [defaults setInteger:CheckInt forKey:@"RateData"];
    [defaults synchronize];
}
-(IBAction)Rate_NotNowButtonOnClick:(id)sender{
    [RateView removeFromSuperview];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger CheckInt = 10;
    [defaults setInteger:CheckInt forKey:@"RateData"];
    [defaults synchronize];
}
-(IBAction)TryAgainButton:(id)sender{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager startUpdatingLocation];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
                [self.locationManager startUpdatingLocation];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}
-(IBAction)ScrollTotopButton:(id)sender{
    [MainScroll setContentOffset:CGPointZero animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {
        ShowUpdateText.frame = CGRectMake(0, 64, screenWidth, 20);
        [refreshControl beginRefreshing];
        MainScroll.hidden = YES;
        LocalScroll.hidden = NO;
        [self LoadDataView];
    }else{
        MainScroll.hidden = NO;
        LocalScroll.hidden = YES;
        [ShowActivity startAnimating];
        [self GetFeedDataFromServer];
    }

    

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
        
        NSLog(@"got location get feed data");

//        [self GetExternalIPAddress];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
//        if ([CheckString isEqualToString:@"Done"]) {
//        }else{
//            [self GetFeedDataFromServer];
//        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:latPoint forKey:@"UserCurrentLocation_lat"];
        [defaults setObject:lonPoint forKey:@"UserCurrentLocation_lng"];
        [defaults synchronize];
        
        if (CheckInitData == 1) {
            
        }else{
            [self initData];
            [self initSelfView];
        }
        
    }else{
        
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
    }
    NSLog(@"no location get feed data");
    [manager stopUpdatingLocation];

    [self GetExternalIPAddress];
    
    if (CheckInitData == 1) {
        
    }else{
        [self initData];
        [self initSelfView];
    }
    
}
-(void)initData
{

    CheckInitData = 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {

        // put data here
        NSMutableArray *arrImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalImg"]];
        arrLocalImage = [[NSMutableArray alloc]initWithArray:arrImageTemp];
        NSMutableArray *arrAddressTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrAddress"]];
        arrLocalAddress = [[NSMutableArray alloc]initWithArray:arrAddressTemp];
        NSMutableArray *arrTitleTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrTitle"]];
        arrLocalTitle = [[NSMutableArray alloc]initWithArray:arrTitleTemp];
        NSMutableArray *arrMessageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrMessage"]];
        arrLocalMessage = [[NSMutableArray alloc]initWithArray:arrMessageTemp];
        NSMutableArray *arrTypeTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrType"]];
        arrLocalType = [[NSMutableArray alloc]initWithArray:arrTypeTemp];
        NSMutableArray *arrDistanceTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDistance"]];
        arrLocalDistance = [[NSMutableArray alloc]initWithArray:arrDistanceTemp];
        NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserName"]];
        arrLocalUserName = [[NSMutableArray alloc]initWithArray:arrUserNameTemp];
        NSMutableArray *arrUserIDTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserID"]];
        arrLocalUserID = [[NSMutableArray alloc]initWithArray:arrUserIDTemp];
        NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserImage"]];
        arrLocalUserImage = [[NSMutableArray alloc]initWithArray:arrUserImageTemp];
        NSMutableArray *arrDisplayCountryNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDisplayCountryName"]];
        arrLocalDisplayCountryName = [[NSMutableArray alloc]initWithArray:arrDisplayCountryNameTemp];
        NSMutableArray *arrPostIDTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrPostID"]];
        arrLocalPostID = [[NSMutableArray alloc]initWithArray:arrPostIDTemp];
        NSMutableArray *arrImageHeightTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrImageHeight"]];
        arrLocalImageHeight = [[NSMutableArray alloc]initWithArray:arrImageHeightTemp];
        NSMutableArray *arrImageWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrImageWidth"]];
        arrLocalImageWidth = [[NSMutableArray alloc]initWithArray:arrImageWidthTemp];
        NSMutableArray *arrLikeWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrLike"]];
        arrLocallike = [[NSMutableArray alloc]initWithArray:arrLikeWidthTemp];
        NSMutableArray *arrCollectWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrCollect"]];
        arrLocalCollect = [[NSMutableArray alloc]initWithArray:arrCollectWidthTemp];
    }else{

    }
    
    arrAddress = [[NSMutableArray alloc]init];
    arrTitle = [[NSMutableArray alloc]init];
    arrMessage = [[NSMutableArray alloc]init];
    arrType = [[NSMutableArray alloc]init];
    arrImage = [[NSMutableArray alloc]init];//https://unsplash.it/375/400/?random
    arrDistance = [[NSMutableArray alloc]init];
    arrUserName = [[NSMutableArray alloc]init];
    arrUserID = [[NSMutableArray alloc]init];
    arrUserImage = [[NSMutableArray alloc]init];
    arrDisplayCountryName = [[NSMutableArray alloc]init];
    arrPostID = [[NSMutableArray alloc]init];
    arrImageWidth = [[NSMutableArray alloc]init];
    arrImageHeight = [[NSMutableArray alloc]init];
    arrlike = [[NSMutableArray alloc]init];
    arrCollect = [[NSMutableArray alloc]init];

    User_LocationArray = [[NSMutableArray alloc]init];
    User_IDArray = [[NSMutableArray alloc]init];
    User_NameArray = [[NSMutableArray alloc]init];
    User_ProfileImageArray = [[NSMutableArray alloc]init];
    User_FollowArray = [[NSMutableArray alloc]init];
    User_UserNameArray = [[NSMutableArray alloc]init];
    User_PhotoArray = [[NSMutableArray alloc]init];
    
    
    arrType_Announcement = [[NSMutableArray alloc]init];
    arrID_Announcement = [[NSMutableArray alloc]init];
    
    arrCollectionID = [[NSMutableArray alloc]init];
    arrCollectionName = [[NSMutableArray alloc]init];
    arrCollectionDescription = [[NSMutableArray alloc]init];
    arrCollectionFollowing = [[NSMutableArray alloc]init];
    arrCollectionUserID = [[NSMutableArray alloc]init];
    
   // TotalPage = 1;
    //CurrentPage = 0;
    DataCount = 0;
    Offset = 1;
    CheckFirstTimeLoad = 0;
    OnLoad = NO;
    
    
    
    CheckFollowSuggestionFriend = 0;
    FollowSuggestionFriendCount = 0;
    
    CheckFollowSuggestionFeatured = 0;
    FollowSuggestionFeaturedCount = 0;

}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   // NSLog(@"FeedViewController viewWillAppear");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckSelfDelete = [defaults objectForKey:@"SelfDeletePost"];
    if ([CheckSelfDelete isEqualToString:@"YES"]) {
        [self ReinitData];
        
        [User_LocationArray removeAllObjects];
        [User_IDArray removeAllObjects];
        [User_NameArray removeAllObjects];
        [User_ProfileImageArray removeAllObjects];
        [User_FollowArray removeAllObjects];
        [User_UserNameArray removeAllObjects];
        [User_PhotoArray removeAllObjects];
        
        [arrType_Announcement removeAllObjects];
        [arrID_Announcement removeAllObjects];
        
        [arrAboadID removeAllObjects];
        [arrfeaturedUserName removeAllObjects];
        [arrFriendUserName removeAllObjects];
        [arrfeaturedUserID removeAllObjects];
        [arrFriendUserID removeAllObjects];
        [arrDealID removeAllObjects];
        [arrDealUserID removeAllObjects];
        [arrAboadUserID removeAllObjects];
        
        [SplitArray_Id_Friend removeAllObjects];
        [SplitArray_ProfileImg_Friend removeAllObjects];
        [SplitArray_Username_Friend removeAllObjects];
        [SplitArray_PostsImg_Friend removeAllObjects];
        
        [SplitArray_Id_Featured removeAllObjects];
        [SplitArray_ProfileImg_Featured removeAllObjects];
        [SplitArray_Username_Featured removeAllObjects];
        [SplitArray_PostsImg_Featured removeAllObjects];
        
        
        arrType_Announcement = [[NSMutableArray alloc]init];
        arrID_Announcement = [[NSMutableArray alloc]init];
        
        DataCount = 0;
        Offset = 1;
        CheckFirstTimeLoad = 0;
        OnLoad = NO;
        
        
        CheckFollowSuggestionFriend = 0;
        FollowSuggestionFriendCount = 0;
        
        CheckFollowSuggestionFeatured = 0;
        FollowSuggestionFeaturedCount = 0;
        
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }

        [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
        [MainScroll addSubview:refreshControl];
        
        GetNextPaging = @"";
        [self GetFeedDataFromServer];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"SelfDeletePost"];
        [defaults synchronize];
    }
    
    NSString *CheckUpdateLike = [defaults objectForKey:@"PostToDetail_like"];
    NSString *CheckUpdateCollect = [defaults objectForKey:@"PostToDetail_Collect"];
    NSInteger CheckUpdateIDN = [defaults integerForKey:@"PostToDetail_IDN"];

    
    if ([CheckUpdateLike length] == 0 || [CheckUpdateLike isEqualToString:@""] || [CheckUpdateLike isEqualToString:@"(null)"] || [CheckUpdateLike isEqualToString:@"<null>"]) {
        
    }else{
        NSLog(@"return check like = %@",CheckUpdateLike);
        NSLog(@"return check IDN = %ld",(long)CheckUpdateIDN);
        
        if ([CheckUpdateLike isEqualToString:[arrlike objectAtIndex:CheckUpdateIDN - 6000]]) {
            
        }else{
            UIButton * btn = (UIButton*)[MainScroll viewWithTag:CheckUpdateIDN];
            
            
            if ([CheckUpdateLike isEqualToString:@"0"]) {
                [btn setSelected:NO];
                [arrlike replaceObjectAtIndex:CheckUpdateIDN - 6000 withObject:@"0"];
            }else{
                [arrlike replaceObjectAtIndex:CheckUpdateIDN - 6000 withObject:@"1"];
                [btn setSelected:YES];
            }
        }
    }
    if ([CheckUpdateCollect length] == 0 || [CheckUpdateCollect isEqualToString:@""] || [CheckUpdateCollect isEqualToString:@"(null)"] || [CheckUpdateCollect isEqualToString:@"<null>"]) {
        
    }else{
        NSLog(@"return check Collect = %@",CheckUpdateCollect);
        NSLog(@"return check IDN = %ld",(long)CheckUpdateIDN);
         CheckUpdateIDN -= 6000;
        if ([CheckUpdateCollect isEqualToString:[arrCollect objectAtIndex:CheckUpdateIDN]]) {
            
        }else{
            CheckUpdateIDN += 5000;
            UIButton * btn = (UIButton*)[MainScroll viewWithTag:CheckUpdateIDN];

            if ([CheckUpdateCollect isEqualToString:@"0"]) {
                [btn setSelected:NO];
                [arrCollect replaceObjectAtIndex:CheckUpdateIDN - 5000 withObject:@"0"];
            }else{
                [arrCollect replaceObjectAtIndex:CheckUpdateIDN - 5000 withObject:@"1"];
                [btn setSelected:YES];
            }
        }
    }
    

    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PostToDetail_like"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PostToDetail_Collect"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PostToDetail_IDN"];
}
-(void)testRefresh{
    
    NSLog(@"testRefresh");
    
    [self ReinitData];
    
    [User_LocationArray removeAllObjects];
    [User_IDArray removeAllObjects];
    [User_NameArray removeAllObjects];
    [User_ProfileImageArray removeAllObjects];
    [User_FollowArray removeAllObjects];
    [User_UserNameArray removeAllObjects];
    [User_PhotoArray removeAllObjects];
    
    [arrType_Announcement removeAllObjects];
    [arrID_Announcement removeAllObjects];
    
    [arrAboadID removeAllObjects];
    [arrfeaturedUserName removeAllObjects];
    [arrFriendUserName removeAllObjects];
    [arrDealID removeAllObjects];
    [arrfeaturedUserID removeAllObjects];
    [arrFriendUserID removeAllObjects];
    [arrDealUserID removeAllObjects];
    [arrAboadUserID removeAllObjects];
    
    [SplitArray_Id_Friend removeAllObjects];
    [SplitArray_ProfileImg_Friend removeAllObjects];
    [SplitArray_Username_Friend removeAllObjects];
    [SplitArray_PostsImg_Friend removeAllObjects];
    
    [SplitArray_Id_Featured removeAllObjects];
    [SplitArray_ProfileImg_Featured removeAllObjects];
    [SplitArray_Username_Featured removeAllObjects];
    [SplitArray_PostsImg_Featured removeAllObjects];
    
    arrType_Announcement = [[NSMutableArray alloc]init];
    arrID_Announcement = [[NSMutableArray alloc]init];
    
    DataCount = 0;
    Offset = 1;
    CheckFirstTimeLoad = 0;
    OnLoad = NO;
    
    
    CheckFollowSuggestionFriend = 0;
    FollowSuggestionFriendCount = 0;
    
    CheckFollowSuggestionFeatured = 0;
    FollowSuggestionFeaturedCount = 0;
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    
//    refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
//                                       0,
//                                       refreshControl.bounds.size.width,
//                                       refreshControl.bounds.size.height);
//    // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    GetNextPaging = @"";
    [self GetFeedDataFromServer];
    
    [refreshControl endRefreshing];
}
-(void)LoadDataView{
    NSLog(@"Load Local Data");
    
    UIRefreshControl *refreshControl_ = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    refreshControl_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    refreshControl_.bounds = CGRectMake(refreshControl_.bounds.origin.x - 20,
//                                       0,
//                                       refreshControl_.bounds.size.width,
//                                       refreshControl_.bounds.size.height);
    // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [refreshControl_ addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [LocalScroll addSubview:refreshControl_];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *NearbyImg = [[UIImageView alloc]init];
    NearbyImg.image = [UIImage imageNamed:@"NearbyBackground.png"];
    NearbyImg.frame = CGRectMake(0, 0, screenWidth, 120);
    NearbyImg.contentMode = UIViewContentModeScaleAspectFill;
    NearbyImg.layer.masksToBounds = YES;
    [LocalScroll addSubview:NearbyImg];
    
    
    
    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake((screenWidth / 2) - 60, 41, 120, 37);
    [TempButton setTitle:LocalisedString(@"Nearby_") forState:UIControlStateNormal];
    [TempButton setImage:[UIImage imageNamed:@"NearbyIcon.png"] forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor clearColor];
    TempButton.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:190.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
    TempButton.layer.cornerRadius = 20;
    TempButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    TempButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    TempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [TempButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    [TempButton addTarget:self action:@selector(NearbyButton:) forControlEvents:UIControlEventTouchUpInside];
    [LocalScroll addSubview: TempButton];
    
    
    heightcheck += 130;
    
//    NSLog(@"[arrImage count] is %lu",(unsigned long)[arrImage count]);
//    NSLog(@"[arrType count] is %lu",(unsigned long)[arrType count]);
//    NSLog(@"[arrTitle count] is %lu",(unsigned long)[arrTitle count]);
//    NSLog(@"[arrUserName count] is %lu",(unsigned long)[arrUserName count]);
//    NSLog(@"[arrDistance count] is %lu",(unsigned long)[arrDistance count]);
//    NSLog(@"[arrDisplayCountryName count] is %lu",(unsigned long)[arrDisplayCountryName count]);
//    NSLog(@"[arrAddress count] is %lu",(unsigned long)[arrAddress count]);
//    NSLog(@"[arrMessage count] is %lu",(unsigned long)[arrMessage count]);
//    NSLog(@"[arrlike count] is %lu",(unsigned long)[arrlike count]);
//    NSLog(@"[arrCollect count] is %lu",(unsigned long)[arrCollect count]);
//    NSLog(@"[arrUserImage count] is %lu",(unsigned long)[arrUserImage count]);

    
    if ([arrLocalImage count] == [arrLocalType count]) {
       // NSLog(@"load local data...");
        for (NSInteger i = 0; i < [arrLocalImage count]; i++) {
            
            NSString *GetType = [arrLocalType objectAtIndex:i];
            
            if ([GetType isEqualToString:@"following_post"]) {
                NSInteger TempHeight = heightcheck + i;
                int TempCountWhiteHeight = 0;
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 200);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                [LocalScroll addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.masksToBounds = YES;
                ShowImage.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                stringPath  = [stringPath stringByAppendingPathComponent:[arrLocalImage objectAtIndex:i]];
                // NSLog(@"stringpath %@",stringPath);
                UIImage *image_;
                UIImage *newImage;
                image_ = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath]];
                float oldWidth = image_.size.width;
                float scaleFactor = screenWidth / oldWidth;
                
                float newHeight = image_.size.height * scaleFactor;
                float newWidth = oldWidth * scaleFactor;
                
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
                [image_ drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                ShowImage.image = newImage;
                ShowImage.frame = CGRectMake(10, heightcheck  + i, screenWidth - 20, newImage.size.height);
                // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 200);
                [LocalScroll addSubview:ShowImage];
                
                
                UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
                ShowOverlayImg.frame = CGRectMake(10, heightcheck, screenWidth - 20, newImage.size.height);
                ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                ShowOverlayImg.layer.masksToBounds = YES;
                ShowOverlayImg.layer.cornerRadius = 5;
                [LocalScroll addSubview:ShowOverlayImg];
                
                
                UIButton *ClickToDetailButton = [[UIButton alloc]init];
                ClickToDetailButton.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, newImage.size.height);
                [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
                ClickToDetailButton.backgroundColor = [UIColor clearColor];
                ClickToDetailButton.tag = i;
                [ClickToDetailButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
                [LocalScroll addSubview:ClickToDetailButton];
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(25, heightcheck + 15, 40, 40);
                ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=1;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                NSString *stringPath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                stringPath1  = [stringPath1 stringByAppendingPathComponent:[arrLocalUserImage objectAtIndex:i]];
                ShowUserProfileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath1]];
                
                [LocalScroll addSubview:ShowUserProfileImage];
                
                UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
                ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 15, 40, 40);
                [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
                ClicktoOpenUserProfileButton.tag = i;
                //[ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [LocalScroll addSubview:ClicktoOpenUserProfileButton];
                
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(75, heightcheck + 15, 200, 40);
                ShowUserName.text = [arrLocalUserName objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor whiteColor];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [LocalScroll addSubview:ShowUserName];
                
                NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrLocalDistance objectAtIndex:i]];
                
                if ([TempDistanceString isEqualToString:@"-1"]) {
                    
                }else{
                    CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                    int x_Nearby = [TempDistanceString intValue] / 1000;
                   // NSLog(@"strFloat is %f",strFloat);
                   // NSLog(@"x_Nearby is %i",x_Nearby);
                    
                    UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                    NSString *FullShowLocatinString;
                    int Checkhide = 0;
                    if (x_Nearby <= 3) {
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else if(x_Nearby > 4 && x_Nearby < 300){
                        
                        if (x_Nearby < 15) {
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }else{
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrLocalDisplayCountryName objectAtIndex:i]];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }

                    }else if(x_Nearby > 301 && x_Nearby < 3000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrLocalDisplayCountryName objectAtIndex:i]];
                    }else if(x_Nearby > 3001 && x_Nearby < 15000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrLocalDisplayCountryName objectAtIndex:i]];
                    }else{
                        Checkhide = 1;
                       // ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrLocalDisplayCountryName objectAtIndex:i]];
                    }
                    
                    
                    if (Checkhide == 1) {
                        UILabel *ShowDistance = [[UILabel alloc]init];
                        ShowDistance.frame = CGRectMake(screenWidth - 125, heightcheck + 15, 100, 40);
                        // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                        ShowDistance.text = FullShowLocatinString;
                        ShowDistance.textColor = [UIColor whiteColor];
                        ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistance.textAlignment = NSTextAlignmentRight;
                        ShowDistance.backgroundColor = [UIColor clearColor];
                        [LocalScroll addSubview:ShowDistance];
                    }else{
                        ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 17, 40, 36);
                        [LocalScroll addSubview:ShowDistanceIcon];
                        
                        UILabel *ShowDistance = [[UILabel alloc]init];
                        ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 15, 100, 40);
                        // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                        ShowDistance.text = FullShowLocatinString;
                        ShowDistance.textColor = [UIColor whiteColor];
                        ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistance.textAlignment = NSTextAlignmentRight;
                        ShowDistance.backgroundColor = [UIColor clearColor];
                        [LocalScroll addSubview:ShowDistance];
                    }

                    
                    
                    
                    
                    
                }
                
                
                
                heightcheck += newImage.size.height + 20;
                TempCountWhiteHeight += newImage.size.height + 20;
                
                NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[arrLocalTitle objectAtIndex:i]];
                if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40 +5);
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TempGetStirng attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowTitle.attributedText = attributedString;
                   // ShowTitle.text = TempGetStirng;
                    ShowTitle.backgroundColor = [UIColor clearColor];
                    ShowTitle.numberOfLines = 2;
                    ShowTitle.textAlignment = NSTextAlignmentLeft;
                    ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
                    [LocalScroll addSubview:ShowTitle];
                    
                    if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                    {
                        ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40 +20);
                    }
                    heightcheck += ShowTitle.frame.size.height + 5;
                    
                    TempCountWhiteHeight += ShowTitle.frame.size.height + 5;
                }
                
                
                UIImageView *ShowPin = [[UIImageView alloc]init];
                ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                ShowPin.frame = CGRectMake(20, heightcheck, 18, 18);
                //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                [LocalScroll addSubview:ShowPin];
                
                UILabel *ShowAddress = [[UILabel alloc]init];
                ShowAddress.frame = CGRectMake(40, heightcheck , screenWidth - 80, 20);
                ShowAddress.text = [arrLocalAddress objectAtIndex:i];
                ShowAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                [LocalScroll addSubview:ShowAddress];
                
                heightcheck += 30;
                TempCountWhiteHeight += 30;
                
                NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[arrLocalMessage objectAtIndex:i]];
                //TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
                if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(25, heightcheck + i, screenWidth - 40, 40);
                    //  ShowMessage.text = TempGetMessage;
                    NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
                    TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                    UILabel *ShowCaptionText = [[UILabel alloc]init];
                    //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
                    ShowCaptionText.numberOfLines = 0;
                    ShowCaptionText.textColor = [UIColor whiteColor];
                    // ShowCaptionText.text = [captionArray objectAtIndex:i];
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
                    NSString *str = TempGetStirngMessage;
                    NSError *error = nil;
                    
                    //I Use regex to detect the pattern I want to change color
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
                    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange wordRange = [match rangeAtIndex:0];
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
                    }
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowMessage.attributedText = attributedString;
                   // [ShowMessage setAttributedText:string];
                    
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.numberOfLines = 3;
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [LocalScroll addSubview:ShowMessage];
                    
                    if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
                    {
                        ShowMessage.frame = CGRectMake(25, heightcheck + i, screenWidth - 50,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    heightcheck += ShowMessage.frame.size.height + 5;
                    TempCountWhiteHeight += ShowMessage.frame.size.height + 5;
                    //   heightcheck += 30;
                }
                UIButton *LikeButton = [[UIButton alloc]init];
                LikeButton.frame = CGRectMake(20, heightcheck + 4, 37, 37);
                CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrLocallike objectAtIndex:i]];
                if ([CheckLike isEqualToString:@"0"]) {
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
                }else{
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
                }
                LikeButton.backgroundColor = [UIColor clearColor];
                LikeButton.tag = 6000 + i;
               // [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [LocalScroll addSubview:LikeButton];
                
                
//                UIButton *CommentButton = [[UIButton alloc]init];
//                CommentButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);
//                [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
//                CommentButton.backgroundColor = [UIColor clearColor];
//                CommentButton.tag = i;
//                [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [LocalScroll addSubview:CommentButton];
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);//3 button size 122, heightcheck + 4 ,37, 37
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor clearColor];
                ShareButton.tag = i;
               // [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [LocalScroll addSubview:ShareButton];
                
                
                CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrLocalCollect objectAtIndex:i]];;
                UIButton *QuickCollectButton = [[UIButton alloc]init];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [QuickCollectButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
                    [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
                }else{
                    [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
                }
                // [QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
                [QuickCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [QuickCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                QuickCollectButton.backgroundColor = [UIColor clearColor];
                QuickCollectButton.frame = CGRectMake(screenWidth - 20 - 140, heightcheck -5, 140, 50);
               // [QuickCollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                QuickCollectButton.tag = i + 5000;
                QuickCollectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [LocalScroll addSubview:QuickCollectButton];
                
                UIButton *CollectButton = [[UIButton alloc]init];
                [CollectButton setTitle:@"" forState:UIControlStateNormal];
                CollectButton.backgroundColor = [UIColor clearColor];
                CollectButton.frame = CGRectMake(screenWidth - 20 - 60, heightcheck - 5, 60, 37);
                //[CollectButton addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                CollectButton.tag = i;
                [LocalScroll addSubview:CollectButton];
                
                
                heightcheck += 55;
                TempCountWhiteHeight += 55;
                
                
                TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
                
                heightcheck += 10;
                
            }
        }
        
        [LocalScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 169 + 50)];
        
        
        //    UIButton *NearbyButton = [[UIButton alloc]init];
        //    NearbyButton.frame = CGRectMake((screenWidth / 2) - 60, 105, 120, 37);
        //    [NearbyButton setImage:[UIImage imageNamed:@"nearby_btn.png"] forState:UIControlStateNormal];
        //    NearbyButton.backgroundColor = [UIColor clearColor];
        //    [NearbyButton addTarget:self action:@selector(NearbyButton:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview: NearbyButton];
        
        [self performSelectorOnMainThread:@selector(timerCalled) withObject:nil waitUntilDone:NO];
    }else{
    [self performSelectorOnMainThread:@selector(timerCalled) withObject:nil waitUntilDone:NO];
    }
    
    

}

-(void)StartInit1stView{
//    heightcheck = 0;
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
    MainScroll.hidden = NO;
    LocalScroll.hidden = YES;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *NearbyImg = [[UIImageView alloc]init];
    NearbyImg.image = [UIImage imageNamed:@"NearbyBackground.png"];
    NearbyImg.frame = CGRectMake(0, 0, screenWidth, 120);
    NearbyImg.contentMode = UIViewContentModeScaleAspectFill;
    NearbyImg.layer.masksToBounds = YES;
    [MainScroll addSubview:NearbyImg];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, 120, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line01];
    

    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake((screenWidth / 2) - 60, 41, 120, 37);
    [TempButton setTitle:LocalisedString(@"Nearby_")  forState:UIControlStateNormal];
    [TempButton setImage:[UIImage imageNamed:@"NearbyIcon.png"] forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor clearColor];
    TempButton.backgroundColor = [UIColor colorWithRed:114.0f/255.0f green:190.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
    TempButton.layer.cornerRadius = 20;
    TempButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    TempButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    TempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [TempButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    [TempButton addTarget:self action:@selector(NearbyButton:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview: TempButton];
    
    
    heightcheck += 130;
    
    [self InitContent];
    

    
    [ShowActivity stopAnimating];
}
-(void)InitContent{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSLog(@"Init Content");
    
//    FEED TYPES:
//    'following_post';
//    'local_quality_post';
//    'abroad_quality_post';
//    'announcement';
//    'announcement_welcome';
//    'announcement_campaign';
//    'follow_suggestion_featured';
//    'follow_suggestion_friend';
//    'deal';
//    'invite_friend';
//    'country_promotion';
//    'collect_suggestion';
//    'following_collection';
    
    for (NSInteger i = DataCount; i < [arrType count]; i++) {
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[arrType objectAtIndex:i]];
        
        NSArray *items = @[@"following_post", @"local_quality_post", @"abroad_quality_post", @"announcement", @"announcement_welcome", @"announcement_campaign", @"follow_suggestion_featured", @"follow_suggestion_friend", @"deal", @"invite_friend", @"country_promotion" , @"collect_suggestion", @"following_collection"];
        NSInteger item = [items indexOfObject:GetType];
        switch (item) {
            case 0:{
                NSLog(@"in following_post");
                NSInteger TempHeight = heightcheck;
                int TempCountWhiteHeight = 0;
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 200);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                [MainScroll addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                NSString *GetImageWidth = [[NSString alloc]initWithFormat:@"%@",[arrImageWidth objectAtIndex:i]];
                NSString *GetImageHeight = [[NSString alloc]initWithFormat:@"%@",[arrImageHeight objectAtIndex:i]];
                float oldWidth = [GetImageWidth floatValue];
                float scaleFactor = screenWidth / oldWidth;
                float newHeight_ = [GetImageHeight floatValue] * scaleFactor;
                int resultHeight = (int)newHeight_;
                ShowImage.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
                ShowImage.layer.masksToBounds = YES;
                ShowImage.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview: ShowImage];
                
                
                UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
                ShowOverlayImg.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
                ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                ShowOverlayImg.layer.masksToBounds = YES;
                ShowOverlayImg.layer.cornerRadius = 5;
                [MainScroll addSubview:ShowOverlayImg];
                
                UIButton *ClickToDetailButton = [[UIButton alloc]init];
                ClickToDetailButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeight);
                [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
                ClickToDetailButton.backgroundColor = [UIColor clearColor];
                ClickToDetailButton.tag = i;
                [ClickToDetailButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClickToDetailButton];
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(25, heightcheck + 15, 40, 40);
                // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=1;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                if ([FullImagesURL length] == 0) {
                    ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
                    ShowUserProfileImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview:ShowUserProfileImage];
                
                UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
                ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 15, 40, 40);
                [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
                ClicktoOpenUserProfileButton.tag = i;
                [ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClicktoOpenUserProfileButton];
                
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(75, heightcheck + 15, 200, 40);
                ShowUserName.text = [arrUserName objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor whiteColor];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];
                
                NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
                
                if ([TempDistanceString isEqualToString:@"-1"]) {
                    
                }else{
                    CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                    int x_Nearby = [TempDistanceString intValue] / 1000;
                    // NSLog(@"x_Nearby is %i",x_Nearby);
                    
                    UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                    NSString *FullShowLocatinString;
                    int Checkhide = 0;
                    if (x_Nearby <= 3) {
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else if(x_Nearby > 4 && x_Nearby < 300){
                        if (x_Nearby < 15) {
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }else{
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }
                    }else if(x_Nearby > 301 && x_Nearby < 3000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }else if(x_Nearby > 3001 && x_Nearby < 15000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }else{
                        Checkhide = 1;
                       // ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }
                    
                    if (Checkhide == 1) {
                        UILabel *ShowDistance = [[UILabel alloc]init];
                        ShowDistance.frame = CGRectMake(screenWidth - 125, heightcheck + 15, 100, 40);
                        ShowDistance.text = FullShowLocatinString;
                        ShowDistance.textColor = [UIColor whiteColor];
                        ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistance.textAlignment = NSTextAlignmentRight;
                        ShowDistance.backgroundColor = [UIColor clearColor];
                        [MainScroll addSubview:ShowDistance];
                    }else{
                        ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 17, 40, 36);
                        [MainScroll addSubview:ShowDistanceIcon];
                        
                        UILabel *ShowDistance = [[UILabel alloc]init];
                        ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 15, 100, 40);
                        ShowDistance.text = FullShowLocatinString;
                        ShowDistance.textColor = [UIColor whiteColor];
                        ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistance.textAlignment = NSTextAlignmentRight;
                        ShowDistance.backgroundColor = [UIColor clearColor];
                        [MainScroll addSubview:ShowDistance];
                    }
                    

                }
                
                
                heightcheck += resultHeight + 20;
                TempCountWhiteHeight += resultHeight + 20;
                
                NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    //ShowTitle.text = TempGetStirng;
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TempGetStirng attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowTitle.attributedText = attributedString;
                    ShowTitle.backgroundColor = [UIColor clearColor];
                    ShowTitle.numberOfLines = 2;
                    ShowTitle.textAlignment = NSTextAlignmentLeft;
                    ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
                    [MainScroll addSubview:ShowTitle];
                    
                    if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                    {
                        ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    heightcheck += ShowTitle.frame.size.height + 5;
                    
                    TempCountWhiteHeight += ShowTitle.frame.size.height + 5;
                }
                
                UIImageView *ShowPin = [[UIImageView alloc]init];
                ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                ShowPin.frame = CGRectMake(20, heightcheck, 18, 18);
                //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                [MainScroll addSubview:ShowPin];
                
                UILabel *ShowAddress = [[UILabel alloc]init];
                ShowAddress.frame = CGRectMake(40, heightcheck, screenWidth - 80, 20);
                ShowAddress.text = [arrAddress objectAtIndex:i];
                ShowAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                [MainScroll addSubview:ShowAddress];
                
                heightcheck += 30;
                TempCountWhiteHeight += 30;
                
                NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[arrMessage objectAtIndex:i]];
                //TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
                if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    //  ShowMessage.text = TempGetMessage;
                    NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
                    TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                    UILabel *ShowCaptionText = [[UILabel alloc]init];
                    //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
                    ShowCaptionText.numberOfLines = 0;
                    ShowCaptionText.textColor = [UIColor whiteColor];
                    // ShowCaptionText.text = [captionArray objectAtIndex:i];
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
                    NSString *str = TempGetStirngMessage;
                    NSError *error = nil;
                    
                    //I Use regex to detect the pattern I want to change color
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
                    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange wordRange = [match rangeAtIndex:0];
                        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
                    }
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowMessage.attributedText = attributedString;
                    //[ShowMessage setAttributedText:string];
                    
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.numberOfLines = 3;
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [MainScroll addSubview:ShowMessage];
                    
                    if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
                    {
                        ShowMessage.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    heightcheck += ShowMessage.frame.size.height + 5;
                    TempCountWhiteHeight += ShowMessage.frame.size.height + 5;
                    //   heightcheck += 30;
                }
                
                
                UIButton *LikeButton = [[UIButton alloc]init];
                LikeButton.frame = CGRectMake(20, heightcheck + 4, 37, 37);
                CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
                if ([CheckLike isEqualToString:@"0"]) {
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
                }else{
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
                }
                LikeButton.backgroundColor = [UIColor clearColor];
                LikeButton.tag = 6000 + i;
                [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:LikeButton];
                
                
//                UIButton *CommentButton = [[UIButton alloc]init];
//                CommentButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);
//                [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
//                CommentButton.backgroundColor = [UIColor clearColor];
//                CommentButton.tag = i;
//                [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:CommentButton];
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);//3 button size 122, heightcheck + 4 ,37, 37
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor clearColor];
                ShareButton.tag = i;
                [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ShareButton];
                
                CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
                UIButton *QuickCollectButton = [[UIButton alloc]init];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [QuickCollectButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
                    [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
                }else{
                    [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
                    //[QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateSelected];
                }
                [QuickCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [QuickCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                QuickCollectButton.backgroundColor = [UIColor clearColor];
                QuickCollectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                QuickCollectButton.frame = CGRectMake(screenWidth - 20 - 140, heightcheck - 5, 140, 50);
                [QuickCollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                QuickCollectButton.tag = i + 5000;
                [MainScroll addSubview:QuickCollectButton];
                
                UIButton *CollectButton = [[UIButton alloc]init];
                [CollectButton setTitle:@"" forState:UIControlStateNormal];
                CollectButton.backgroundColor = [UIColor clearColor];
                CollectButton.frame = CGRectMake(screenWidth - 20 - 60, heightcheck - 5, 60, 37);
                [CollectButton addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                CollectButton.tag = i;
                [MainScroll addSubview:CollectButton];
                
                
                heightcheck += 55;
                TempCountWhiteHeight += 55;
            
                TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
                
                heightcheck += 10;
            }

                break;
            case 1:{
                NSLog(@"in local_quality_post");
                NSInteger TempHeightLocalQR = heightcheck;
                int TempCountWhiteHeightLocalQR = 0;
                UIButton *TempButtonLocalQR = [[UIButton alloc]init];
                TempButtonLocalQR.frame = CGRectMake(10, heightcheck, screenWidth - 20, 200);
                [TempButtonLocalQR setTitle:@"" forState:UIControlStateNormal];
                TempButtonLocalQR.backgroundColor = [UIColor whiteColor];
                TempButtonLocalQR.layer.cornerRadius = 5;
                [MainScroll addSubview: TempButtonLocalQR];
                
                AsyncImageView *ShowImageLocalQR = [[AsyncImageView alloc]init];
                ShowImageLocalQR.contentMode = UIViewContentModeScaleAspectFill;
                NSString *GetImageWidthLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrImageWidth objectAtIndex:i]];
                NSString *GetImageHeightLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrImageHeight objectAtIndex:i]];
                float oldWidthLocalQR = [GetImageWidthLocalQR floatValue];
                float scaleFactorLocalQR = screenWidth / oldWidthLocalQR;
                float newHeight_LocalQR = [GetImageHeightLocalQR floatValue] * scaleFactorLocalQR;
                int resultHeightLocalQR = (int)newHeight_LocalQR;
                ShowImageLocalQR.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeightLocalQR);
                ShowImageLocalQR.layer.masksToBounds = YES;
                ShowImageLocalQR.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImageLocalQR];
                NSString *ImageDataLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageDataLocalQR length] == 0) {
                    ShowImageLocalQR.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmallLocalQR = [NSURL URLWithString:ImageDataLocalQR];
                    ShowImageLocalQR.imageURL = url_NearbySmallLocalQR;
                }
                [MainScroll addSubview: ShowImageLocalQR];
                
                UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
                ShowOverlayImg.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeightLocalQR);
                ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                ShowOverlayImg.layer.masksToBounds = YES;
                ShowOverlayImg.layer.cornerRadius = 5;
                [MainScroll addSubview:ShowOverlayImg];

                UIButton *ClickToDetailButtonLocalQR = [[UIButton alloc]init];
                ClickToDetailButtonLocalQR.frame = CGRectMake(10, heightcheck, screenWidth - 20, resultHeightLocalQR);
                [ClickToDetailButtonLocalQR setTitle:@"" forState:UIControlStateNormal];
                ClickToDetailButtonLocalQR.backgroundColor = [UIColor clearColor];
                ClickToDetailButtonLocalQR.tag = i;
                [ClickToDetailButtonLocalQR addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClickToDetailButtonLocalQR];
                
                AsyncImageView *ShowUserProfileImageLocalQR = [[AsyncImageView alloc]init];
                ShowUserProfileImageLocalQR.frame = CGRectMake(25, heightcheck + 15, 40, 40);
                // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImageLocalQR.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImageLocalQR.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImageLocalQR.layer.cornerRadius=20;
                ShowUserProfileImageLocalQR.layer.borderWidth=1;
                ShowUserProfileImageLocalQR.layer.masksToBounds = YES;
                ShowUserProfileImageLocalQR.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImageLocalQR];
                NSString *FullImagesURLLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                if ([FullImagesURLLocalQR length] == 0) {
                    ShowUserProfileImageLocalQR.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                }else{
                    NSURL *url_NearbySmallLocalQR = [NSURL URLWithString:FullImagesURLLocalQR];
                    ShowUserProfileImageLocalQR.imageURL = url_NearbySmallLocalQR;
                }
                [MainScroll addSubview:ShowUserProfileImageLocalQR];
                
                UIButton *ClicktoOpenUserProfileButtonLocalQR = [[UIButton alloc]init];
                ClicktoOpenUserProfileButtonLocalQR.frame = CGRectMake(20, heightcheck + 15, 40, 40);
                [ClicktoOpenUserProfileButtonLocalQR setTitle:@"" forState:UIControlStateNormal];
                ClicktoOpenUserProfileButtonLocalQR.backgroundColor = [UIColor clearColor];
                ClicktoOpenUserProfileButtonLocalQR.tag = i;
                [ClicktoOpenUserProfileButtonLocalQR addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClicktoOpenUserProfileButtonLocalQR];
                
                
                
                UILabel *ShowUserNameLocalQR = [[UILabel alloc]init];
                ShowUserNameLocalQR.frame = CGRectMake(75, heightcheck + 15, 200, 40);
                ShowUserNameLocalQR.text = [arrUserName objectAtIndex:i];
                ShowUserNameLocalQR.backgroundColor = [UIColor clearColor];
                ShowUserNameLocalQR.textColor = [UIColor whiteColor];
                ShowUserNameLocalQR.textAlignment = NSTextAlignmentLeft;
                ShowUserNameLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserNameLocalQR];
                
                NSString *TempDistanceStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
                
                if ([TempDistanceStringLocalQR isEqualToString:@"-1"]) {
                    
                }else{
                    CGFloat strFloatLocalQR = (CGFloat)[TempDistanceStringLocalQR floatValue] / 1000;
                    int x_NearbyLocalQR = [TempDistanceStringLocalQR intValue] / 1000;
                    // NSLog(@"x_Nearby is %i",x_Nearby);
                    
                    UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                    NSString *FullShowLocatinStringLocalQR;
                    int Checkhide = 0;
                    if (x_NearbyLocalQR <= 3) {
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else if(x_NearbyLocalQR > 4 && x_NearbyLocalQR < 300){
                        if (x_NearbyLocalQR < 15) {
                            FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%.fkm",strFloatLocalQR];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }else{
                            FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }

                    }else if(x_NearbyLocalQR > 301 && x_NearbyLocalQR < 3000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }else if(x_NearbyLocalQR > 3001 && x_NearbyLocalQR < 15000){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }else{
                        Checkhide = 1;
                      //  ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    }
                    
                    if (Checkhide == 1) {
                        UILabel *ShowDistanceLocalQR = [[UILabel alloc]init];
                        ShowDistanceLocalQR.frame = CGRectMake(screenWidth - 125, heightcheck + 15, 100, 40);
                        ShowDistanceLocalQR.text = FullShowLocatinStringLocalQR;
                        ShowDistanceLocalQR.textColor = [UIColor whiteColor];
                        ShowDistanceLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistanceLocalQR.textAlignment = NSTextAlignmentRight;
                        ShowDistanceLocalQR.backgroundColor = [UIColor clearColor];
                        [MainScroll addSubview:ShowDistanceLocalQR];
                    }else{
                        ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 17, 40, 36);
                        [MainScroll addSubview:ShowDistanceIcon];
                        
                        UILabel *ShowDistanceLocalQR = [[UILabel alloc]init];
                        ShowDistanceLocalQR.frame = CGRectMake(screenWidth - 165, heightcheck + 15, 100, 40);
                        ShowDistanceLocalQR.text = FullShowLocatinStringLocalQR;
                        ShowDistanceLocalQR.textColor = [UIColor whiteColor];
                        ShowDistanceLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        ShowDistanceLocalQR.textAlignment = NSTextAlignmentRight;
                        ShowDistanceLocalQR.backgroundColor = [UIColor clearColor];
                        [MainScroll addSubview:ShowDistanceLocalQR];
                    }
                    

                }
                
                
                
                heightcheck += resultHeightLocalQR + 20;
                TempCountWhiteHeightLocalQR += resultHeightLocalQR + 20;
                
                NSString *TempGetStirngLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                if ([TempGetStirngLocalQR length] == 0 || [TempGetStirngLocalQR isEqualToString:@""] || [TempGetStirngLocalQR isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitleLocalQR = [[UILabel alloc]init];
                    ShowTitleLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TempGetStirngLocalQR attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowTitleLocalQR.attributedText = attributedString;
                    //ShowTitleLocalQR.text = TempGetStirngLocalQR;
                    ShowTitleLocalQR.backgroundColor = [UIColor clearColor];
                    ShowTitleLocalQR.numberOfLines = 2;
                    ShowTitleLocalQR.textAlignment = NSTextAlignmentLeft;
                    ShowTitleLocalQR.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitleLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
                    [MainScroll addSubview:ShowTitleLocalQR];
                    
                    if([ShowTitleLocalQR sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowTitleLocalQR.frame.size.height)
                    {
                        ShowTitleLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowTitleLocalQR sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    heightcheck += ShowTitleLocalQR.frame.size.height + 5;
                    
                    TempCountWhiteHeightLocalQR += ShowTitleLocalQR.frame.size.height + 5;
                }
                
                UIImageView *ShowPinLocalQR = [[UIImageView alloc]init];
                ShowPinLocalQR.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                ShowPinLocalQR.frame = CGRectMake(20, heightcheck, 18, 18);
                //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                [MainScroll addSubview:ShowPinLocalQR];
                
                UILabel *ShowAddressLocalQR = [[UILabel alloc]init];
                ShowAddressLocalQR.frame = CGRectMake(40, heightcheck, screenWidth - 80, 20);
                ShowAddressLocalQR.text = [arrAddress objectAtIndex:i];
                ShowAddressLocalQR.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                [MainScroll addSubview:ShowAddressLocalQR];
                
                heightcheck += 30;
                TempCountWhiteHeightLocalQR += 30;
                
                NSString *TempGetMessageLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrMessage objectAtIndex:i]];
                //TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
                if ([TempGetMessageLocalQR length] == 0 || [TempGetMessageLocalQR isEqualToString:@""] || [TempGetMessageLocalQR isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowMessageLocalQR = [[UILabel alloc]init];
                    ShowMessageLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    //  ShowMessage.text = TempGetMessage;
                    NSString *TempGetStirngMessageLocalQR = [[NSString alloc]initWithFormat:@"%@",TempGetMessageLocalQR];
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
                    TempGetStirngMessageLocalQR = [[TempGetStirngMessageLocalQR componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                    UILabel *ShowCaptionTextLocalQR = [[UILabel alloc]init];
                    //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
                    ShowCaptionTextLocalQR.numberOfLines = 0;
                    ShowCaptionTextLocalQR.textColor = [UIColor whiteColor];
                    // ShowCaptionText.text = [captionArray objectAtIndex:i];
                    NSMutableAttributedString * stringLocalQR = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessageLocalQR];
                    NSString *strLocalQR = TempGetStirngMessageLocalQR;
                    NSError *error = nil;
                    
                    //I Use regex to detect the pattern I want to change color
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
                    NSArray *matches = [regex matchesInString:strLocalQR options:0 range:NSMakeRange(0, strLocalQR.length)];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange wordRange = [match rangeAtIndex:0];
                        [stringLocalQR addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
                    }
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:strLocalQR attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    ShowMessageLocalQR.attributedText = attributedString;
                   //[ShowMessageLocalQR setAttributedText:stringLocalQR];
                    
                    ShowMessageLocalQR.backgroundColor = [UIColor clearColor];
                    ShowMessageLocalQR.numberOfLines = 3;
                    ShowMessageLocalQR.textAlignment = NSTextAlignmentLeft;
                    ShowMessageLocalQR.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowMessageLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [MainScroll addSubview:ShowMessageLocalQR];
                    
                    if([ShowMessageLocalQR sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowMessageLocalQR.frame.size.height)
                    {
                        ShowMessageLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 50,[ShowMessageLocalQR sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    heightcheck += ShowMessageLocalQR.frame.size.height + 5;
                    TempCountWhiteHeightLocalQR += ShowMessageLocalQR.frame.size.height + 5;
                    //   heightcheck += 30;
                }
                
                
                UIButton *LikeButtonLocalQR = [[UIButton alloc]init];
                LikeButtonLocalQR.frame = CGRectMake(20, heightcheck + 4, 37, 37);
                CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
                if ([CheckLike isEqualToString:@"0"]) {
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
                }else{
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
                }
                LikeButtonLocalQR.backgroundColor = [UIColor clearColor];
                LikeButtonLocalQR.tag = 6000 + i;
                [LikeButtonLocalQR addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:LikeButtonLocalQR];
                
                
//                UIButton *CommentButton = [[UIButton alloc]init];
//                CommentButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);
//                [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
//                CommentButton.backgroundColor = [UIColor clearColor];
//                CommentButton.tag = i;
//                [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:CommentButton];
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(70, heightcheck + 4 ,37, 37);//3 button size 122, heightcheck + 4 ,37, 37
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor clearColor];
                ShareButton.tag = i;
                [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ShareButton];
                
                
                CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
                UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
                }else{
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
                }
                [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
                QuickCollectButtonLocalQR.frame = CGRectMake(screenWidth - 20 - 140, heightcheck - 5, 140, 50);
                [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                QuickCollectButtonLocalQR.tag = i + 5000;
                [MainScroll addSubview:QuickCollectButtonLocalQR];
                
                UIButton *CollectButtonLocalQR = [[UIButton alloc]init];
                [CollectButtonLocalQR setTitle:@"" forState:UIControlStateNormal];
                CollectButtonLocalQR.backgroundColor = [UIColor clearColor];
                CollectButtonLocalQR.frame = CGRectMake(screenWidth - 20 - 60, heightcheck - 5, 60, 37);
                [CollectButtonLocalQR addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                CollectButtonLocalQR.tag = i;
                [MainScroll addSubview:CollectButtonLocalQR];
                
                
                heightcheck += 55;
                TempCountWhiteHeightLocalQR += 55;
                
                UIButton *Line01 = [[UIButton alloc]init];
                Line01.frame = CGRectMake(10, heightcheck, screenWidth - 20, 1);
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                Line01.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
                [MainScroll addSubview:Line01];
                
                UILabel *ShowSuggestedLocalQR = [[UILabel alloc]init];
                ShowSuggestedLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 80, 50);
                ShowSuggestedLocalQR.text = LocalisedString(@"Suggested local recommendations");
                ShowSuggestedLocalQR.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedLocalQR];
                
                heightcheck += 50;
                TempCountWhiteHeightLocalQR += 50;
                
                
                
                TempButtonLocalQR.frame = CGRectMake(10, TempHeightLocalQR, screenWidth - 20, TempCountWhiteHeightLocalQR);
                
                heightcheck += 10;
                
            }
                break;
            case 2:{
                NSLog(@"in abroad");
//                NSInteger TempHeightAbroad = heightcheck;
//                int TempCountWhiteHeightAbroad = 0;
                
                NSString *TempUsername = [[NSString alloc]initWithFormat:@"%@",[arrUserName objectAtIndex:i]];
                NSArray *SplitArray_username = [TempUsername componentsSeparatedByString:@","];
                NSString *TempUserImage = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                NSArray *SplitArray_UserImage = [TempUserImage componentsSeparatedByString:@","];
                NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                NSArray *SplitArray_Image = [TempImage componentsSeparatedByString:@","];
                
                NSString *TempLocation = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                NSArray *SplitArray_Location = [TempLocation componentsSeparatedByString:@","];
                NSString *TempTitle = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                NSArray *SplitArray_Title = [TempTitle componentsSeparatedByString:@"|||||"];
                
                NSString *TempAddress = [[NSString alloc]initWithFormat:@"%@",[arrAddress objectAtIndex:i]];
                NSArray *SplitArray_Address = [TempAddress componentsSeparatedByString:@","];
                
                NSString *TempId = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:i]];
                NSArray *SplitArray_Id = [TempId componentsSeparatedByString:@","];
                arrAboadID = [[NSMutableArray alloc]initWithArray:SplitArray_Id];
                
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[arrUserID objectAtIndex:i]];
                NSArray *SplitArray_UserID = [TempUserID componentsSeparatedByString:@","];
                arrAboadUserID = [[NSMutableArray alloc]initWithArray:SplitArray_UserID];
                
               // NSLog(@"in abroad_quality_post");
                SuggestedScrollview_Aboad = [[UIScrollView alloc]init];
                SuggestedScrollview_Aboad.delegate = self;
                SuggestedScrollview_Aboad.frame = CGRectMake(0, heightcheck, screenWidth, 355);
                SuggestedScrollview_Aboad.backgroundColor = [UIColor whiteColor];
                //SuggestedScrollview_Aboad.pagingEnabled = YES;
                [SuggestedScrollview_Aboad setShowsHorizontalScrollIndicator:NO];
                [SuggestedScrollview_Aboad setShowsVerticalScrollIndicator:NO];
                SuggestedScrollview_Aboad.tag = 1000;
                [MainScroll addSubview:SuggestedScrollview_Aboad];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, screenWidth - 70, 50);
                ShowSuggestedText.text = LocalisedString(@"Suggested foreign recommendations");
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
//                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[arrAboadID count]];
//                
//                ShowSuggestedCount_Aboad = [[UILabel alloc]init];
//                ShowSuggestedCount_Aboad.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
//                ShowSuggestedCount_Aboad.text = TempCount;
//                ShowSuggestedCount_Aboad.backgroundColor = [UIColor clearColor];
//                ShowSuggestedCount_Aboad.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//                ShowSuggestedCount_Aboad.textAlignment = NSTextAlignmentRight;
//                ShowSuggestedCount_Aboad.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//                [MainScroll addSubview:ShowSuggestedCount_Aboad];
//                
//                SuggestedpageControl_Aboad = [[UIPageControl alloc] init];
//                SuggestedpageControl_Aboad.frame = CGRectMake(0,heightcheck + 340,screenWidth,30);
//                SuggestedpageControl_Aboad.numberOfPages = 3;
//                SuggestedpageControl_Aboad.currentPage = 0;
//                SuggestedpageControl_Aboad.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
//                SuggestedpageControl_Aboad.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
//                [MainScroll addSubview:SuggestedpageControl_Aboad];
                
                for (int i = 0; i < [SplitArray_username count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,290);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SuggestedScrollview_Aboad addSubview: TempButton];
                    
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,198);
                    ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage.layer.cornerRadius=5;
                    ShowImage.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Image objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage.imageURL = url_NearbySmall;
                    }
                    [SuggestedScrollview_Aboad addSubview:ShowImage];
                    
                    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                    ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
                    ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50, 198);
                    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                    ShowOverlayImg.layer.masksToBounds = YES;
                    ShowOverlayImg.layer.cornerRadius = 5;
                    [SuggestedScrollview_Aboad addSubview:ShowOverlayImg];
                    
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, 40, 40);
                   // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=1;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_UserImage objectAtIndex:i]];
                    if ([ImageData1 length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SuggestedScrollview_Aboad addSubview:ShowUserProfileImage];
                    
                    NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[SplitArray_username objectAtIndex:i]];
                    NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Location objectAtIndex:i]];
                    NSString *Address = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Address objectAtIndex:i]];
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(75 + i * (screenWidth - 40), 51 + 10, 180, 40);
                    ShowUserName.text = usernameTemp;
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor whiteColor];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Aboad addSubview:ShowUserName];
                    
                    UILabel *ShowDistance = [[UILabel alloc]init];
                    ShowDistance.frame = CGRectMake(screenWidth - 155 + i * (screenWidth - 40), 51 + 10, 100, 40);
                    // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                    ShowDistance.text = Distance;
                    ShowDistance.textColor = [UIColor whiteColor];
                    ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistance.textAlignment = NSTextAlignmentRight;
                    ShowDistance.backgroundColor = [UIColor clearColor];
                    [SuggestedScrollview_Aboad addSubview:ShowDistance];
                    
                    
                    UIImageView *ShowPinLocalQR = [[UIImageView alloc]init];
                    ShowPinLocalQR.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                    ShowPinLocalQR.frame = CGRectMake(20 + i * (screenWidth - 40), 51 + 198 + 10, 18, 18);
                    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                    [SuggestedScrollview_Aboad addSubview:ShowPinLocalQR];
                    
                    UILabel *ShowAddressLocalQR = [[UILabel alloc]init];
                    ShowAddressLocalQR.frame = CGRectMake(40 + i * (screenWidth - 40), 51 + 198 + 10, screenWidth - 80, 20);
                    ShowAddressLocalQR.text = Address;
                    ShowAddressLocalQR.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SuggestedScrollview_Aboad addSubview:ShowAddressLocalQR];
                    
                    //  int TempCountWhiteHeight = 51 + 198 + 10;
                    
                    NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Title objectAtIndex:i]];
                    if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                        
                    }else{
                        UILabel *ShowTitle = [[UILabel alloc]init];
                        ShowTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 198 + 10 + 30, screenWidth - 80, 40);
                       // ShowTitle.text = TempGetStirng;
                        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                        paragraph.minimumLineHeight = 21.0f;
                        paragraph.maximumLineHeight = 21.0f;
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TempGetStirng attributes:@{NSParagraphStyleAttributeName: paragraph}];
                        ShowTitle.attributedText = attributedString;
                        ShowTitle.backgroundColor = [UIColor clearColor];
                        ShowTitle.numberOfLines = 2;
                        ShowTitle.textAlignment = NSTextAlignmentLeft;
                        ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        [SuggestedScrollview_Aboad addSubview:ShowTitle];
                    }
                    
                    UIButton *OpenPostsButton = [[UIButton alloc]init];
                    [OpenPostsButton setTitle:@"" forState:UIControlStateNormal];
                    OpenPostsButton.backgroundColor = [UIColor clearColor];
                    OpenPostsButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 20 ,320);
                    [OpenPostsButton addTarget:self action:@selector(AboadOpenPostsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenPostsButton.tag = i;
                    [SuggestedScrollview_Aboad addSubview:OpenPostsButton];
                    
                    UIButton *OpenUserButton = [[UIButton alloc]init];
                    [OpenUserButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserButton.backgroundColor = [UIColor clearColor];
                    OpenUserButton.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
                    [OpenUserButton addTarget:self action:@selector(AboadUserOpenProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserButton.tag = i;
                    [SuggestedScrollview_Aboad addSubview:OpenUserButton];
                    
                    
                    SuggestedScrollview_Aboad.contentSize = CGSizeMake(10 + i * (screenWidth - 40) + (screenWidth - 40), 300);
                }
                
                
                
                heightcheck += 360;

                
            }
                break;
            case 3:{
                NSLog(@"in announcement");
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                [MainScroll addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 250);
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.masksToBounds = YES;
                ShowImage.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview: ShowImage];
                
                NSString *TempGetString = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                
                if ([TempGetString length] == 0 || [TempGetString isEqualToString:@""] || [TempGetString isEqualToString:@"(null)"] || [TempGetString isEqualToString:@"<null>"]) {
                    ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 300);
                }else{
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                    ShowUserName.text = [arrTitle objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [MainScroll addSubview:ShowUserName];
                }
                

                
                UIButton *AnnouncementButton = [[UIButton alloc]init];
                AnnouncementButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [AnnouncementButton setTitle:@"" forState:UIControlStateNormal];
                AnnouncementButton.backgroundColor = [UIColor clearColor];
                [AnnouncementButton addTarget:self action:@selector(AnnouncementButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                AnnouncementButton.tag = i;
                [MainScroll addSubview:AnnouncementButton];
                
                heightcheck += 310;
            }
                break;
            case 4:{
                NSLog(@"in announcement_welcome");
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                [MainScroll addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 250);
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.masksToBounds = YES;
                ShowImage.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview: ShowImage];
                
                NSString *TempGetString = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                
                if ([TempGetString length] == 0 || [TempGetString isEqualToString:@""] || [TempGetString isEqualToString:@"(null)"] || [TempGetString isEqualToString:@"<null>"]) {
                    ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 300);
                }else{
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                    ShowUserName.text = [arrTitle objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [MainScroll addSubview:ShowUserName];
                }
                
                UIButton *AnnouncementButton = [[UIButton alloc]init];
                AnnouncementButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [AnnouncementButton setTitle:@"" forState:UIControlStateNormal];
                AnnouncementButton.backgroundColor = [UIColor clearColor];
                [AnnouncementButton addTarget:self action:@selector(AnnouncementButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                AnnouncementButton.tag = i;
                [MainScroll addSubview:AnnouncementButton];
                
                heightcheck += 310;
            }
                break;
            case 5:{
                NSLog(@"in announcement_campaign");
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                [MainScroll addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 250);
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.masksToBounds = YES;
                ShowImage.layer.cornerRadius = 5;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    ShowImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview: ShowImage];
                
                NSString *TempGetString = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                
                if ([TempGetString length] == 0 || [TempGetString isEqualToString:@""] || [TempGetString isEqualToString:@"(null)"] || [TempGetString isEqualToString:@"<null>"]) {
                    ShowImage.frame = CGRectMake(10, heightcheck,screenWidth - 20 , 300);
                }else{
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                    ShowUserName.text = [arrTitle objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [MainScroll addSubview:ShowUserName];
                }
                
                UIButton *AnnouncementButton = [[UIButton alloc]init];
                AnnouncementButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 300);
                [AnnouncementButton setTitle:@"" forState:UIControlStateNormal];
                AnnouncementButton.backgroundColor = [UIColor clearColor];
                [AnnouncementButton addTarget:self action:@selector(AnnouncementButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                AnnouncementButton.tag = i;
                [MainScroll addSubview:AnnouncementButton];
                
                heightcheck += 310;
            }
                break;
            case 6:{
                NSLog(@"in follow_suggestion_featured");
                
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[User_IDArray objectAtIndex:i]];
                NSString *TempUserProfileImg = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
                NSString *TempUseName = [[NSString alloc]initWithFormat:@"%@",[User_UserNameArray objectAtIndex:i]];
                NSString *TempUserPhoto = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
                
                NSArray *TempSplitArray_Id = [TempUserID componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_ProfileImg = [TempUserProfileImg componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_Username = [TempUseName componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_PostsImg = [TempUserPhoto componentsSeparatedByString:@"$"];
                
                if ([TempSplitArray_PostsImg count] <= [TempSplitArray_Id  count]) {
                    //SplitArray_PostsImg = [[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
                    NSUInteger GetCount = [TempSplitArray_PostsImg count];
                    for (NSUInteger i = GetCount; i < [TempSplitArray_Id  count]; i++) {
                        TempSplitArray_PostsImg = [TempSplitArray_PostsImg arrayByAddingObject:@""];
                    }
                }else{
                    
                }
                
                

                if (CheckFollowSuggestionFeatured == 0) {
                    CheckFollowSuggestionFeatured = 1;
                    
                    SplitArray_Id_Featured = [[NSMutableArray alloc]initWithArray:TempSplitArray_Id];
                    SplitArray_ProfileImg_Featured = [[NSMutableArray alloc]initWithArray:TempSplitArray_ProfileImg];
                    SplitArray_Username_Featured = [[NSMutableArray alloc]initWithArray:TempSplitArray_Username];
                    SplitArray_PostsImg_Featured = [[NSMutableArray alloc]initWithArray:TempSplitArray_PostsImg];
                    
                    FollowSuggestionFeaturedCount = 0;
                    
                }else{
                    
                    [SplitArray_Id_Featured addObjectsFromArray:TempSplitArray_Id];
                    [SplitArray_ProfileImg_Featured addObjectsFromArray:TempSplitArray_ProfileImg];
                    [SplitArray_Username_Featured addObjectsFromArray:TempSplitArray_Username];
                    [SplitArray_PostsImg_Featured addObjectsFromArray:TempSplitArray_PostsImg];
                    
                    FollowSuggestionFeaturedCount += [TempSplitArray_Id count];
                }
                
//                NSLog(@"SplitArray_Id is %@",SplitArray_Id_Featured);
//                NSLog(@"SplitArray_ProfileImg is %@",SplitArray_ProfileImg_Featured);
//                NSLog(@"SplitArray_Username is %@",SplitArray_Username_Featured);
//                NSLog(@"SplitArray_PostsImg is %@",SplitArray_PostsImg_Featured);
//                NSLog(@"FollowSuggestionFeaturedCount is %d",FollowSuggestionFeaturedCount);
                
                arrfeaturedUserName = [[NSMutableArray alloc]initWithArray:SplitArray_Username_Featured];
                arrfeaturedUserID = [[NSMutableArray alloc]initWithArray:SplitArray_Id_Featured];
                int TestWidth = screenWidth - 70;
                //    NSLog(@"TestWidth is %i",TestWidth);
                int FinalWidth = TestWidth / 4;
                //    NSLog(@"FinalWidth is %i",FinalWidth);
                int SpaceWidth = FinalWidth + 4;
                
                SUserScrollview_Featured = [[UIScrollView alloc]init];
                SUserScrollview_Featured.delegate = self;
                SUserScrollview_Featured.frame = CGRectMake(0, heightcheck, screenWidth, FinalWidth + 10 + 70 + 50 + 10);
                SUserScrollview_Featured.backgroundColor = [UIColor whiteColor];
                //SUserScrollview_Featured.pagingEnabled = YES;
                [SUserScrollview_Featured setShowsHorizontalScrollIndicator:NO];
                [SUserScrollview_Featured setShowsVerticalScrollIndicator:NO];
                SUserScrollview_Featured.tag = 2000 + i;
                [MainScroll addSubview:SUserScrollview_Featured];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, screenWidth - 70, 50);
                ShowSuggestedText.text = LocalisedString(@"Meet & greet other Seetizens");
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
//                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[TempSplitArray_Id count]];
//                
//                ShowSUserCount_Featured = [[UILabel alloc]init];
//                ShowSUserCount_Featured.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
//                ShowSUserCount_Featured.text = TempCount;
//                ShowSUserCount_Featured.backgroundColor = [UIColor clearColor];
//                ShowSUserCount_Featured.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//                ShowSUserCount_Featured.textAlignment = NSTextAlignmentRight;
//                ShowSUserCount_Featured.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//                ShowSUserCount_Featured.tag = 2000 + i;
//                [MainScroll addSubview:ShowSUserCount_Featured];
//                
//                
//                SUserpageControl_Featured = [[UIPageControl alloc] init];
//                SUserpageControl_Featured.frame = CGRectMake(0,heightcheck + FinalWidth + 10 + 70 + 50,screenWidth,30);
//                SUserpageControl_Featured.numberOfPages = [TempSplitArray_Id count];
//                SUserpageControl_Featured.currentPage = 0;
//                SUserpageControl_Featured.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
//                SUserpageControl_Featured.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
//                SUserpageControl_Featured.tag = 2000 + i;
//                [MainScroll addSubview:SUserpageControl_Featured];
                
                
                for (int i = 0; i < [TempSplitArray_Id count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50, screenWidth - 50, FinalWidth + 10 + 70);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SUserScrollview_Featured addSubview: TempButton];
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(20 + i * (screenWidth - 40), 60, 40, 40);
                   // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=1;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[TempSplitArray_ProfileImg objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SUserScrollview_Featured addSubview:ShowUserProfileImage];
                    
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(70 + i * (screenWidth - 40), 50 + 10, 200, 20);
                    ShowUserName.text = [TempSplitArray_Username objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SUserScrollview_Featured addSubview:ShowUserName];
                    
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(70 + i * (screenWidth - 40), 50 + 30, screenWidth - 140 - 10, 20);
                    ShowMessage.text = LocalisedString(@"Follow this Seetizen for more");
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SUserScrollview_Featured addSubview:ShowMessage];
                    
                    UIButton *FollowButton = [[UIButton alloc]init];
                    FollowButton.frame = CGRectMake(screenWidth - 40 - 70 + i * (screenWidth - 40), 52,70, 48);
                    // [FollowButton setTitle:@"Icon" forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateSelected];
                    FollowButton.backgroundColor = [UIColor clearColor];
                    //[FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
                    [SUserScrollview_Featured addSubview: FollowButton];
                    
//                    UIButton *FollowButton = [[UIButton alloc]init];
//                    FollowButton.frame = CGRectMake(screenWidth - 20 - 100 + i * screenWidth, 60, 100, 40);
//                    [FollowButton setTitle:@"Follow" forState:UIControlStateNormal];
//                    FollowButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
//                    FollowButton.layer.cornerRadius = 20;
//                    [SUserScrollview addSubview: FollowButton];
                    
                    NSString *GetImg = [[NSString alloc]initWithFormat:@"%@",[TempSplitArray_PostsImg objectAtIndex:i]];
                    NSArray *PostsImg = [GetImg componentsSeparatedByString:@","];
                    
                    
                    for (int y = 0; y < 4; y++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * (screenWidth - 40) +(y % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                        // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        ShowImage.layer.borderWidth = 1;
                        ShowImage.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
                        
                        switch (y) {
                            case 0:
                                ShowImage.backgroundColor = [UIColor colorWithRed:122.0f/255.0f green:109.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
                                break;
                            case 1:
                                ShowImage.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:174.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
                                break;
                            case 2:
                                ShowImage.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:115.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
                                break;
                            case 3:
                                ShowImage.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:224.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
                                break;
                                
                            default:
                                break;
                        }
                        
                        [SUserScrollview_Featured addSubview:ShowImage];
                    }
                    
                    for (int z = 0; z < [PostsImg count]; z++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * (screenWidth - 40) +(z % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                        // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        ShowImage.layer.borderWidth = 1;
                        ShowImage.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[PostsImg objectAtIndex:z]];
                        if ([ImageData length] == 0) {
                          //  ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage.imageURL = url_NearbySmall;
                        }
                        [SUserScrollview_Featured addSubview:ShowImage];
                    }
                    
                    UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                    [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                    OpenUserProfileButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [OpenUserProfileButton addTarget:self action:@selector(FeaturedOpenUserProfile:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserProfileButton.tag = i + FollowSuggestionFeaturedCount;
                    [SUserScrollview_Featured addSubview:OpenUserProfileButton];
                    
                    
                    SUserScrollview_Featured.contentSize = CGSizeMake(10 + i * (screenWidth - 40) + (screenWidth - 40), 100);
                }
                
                heightcheck += FinalWidth + 10 + 70 + 50 + 10 + 10;

            }break;
            case 7:{
                NSLog(@"in follow_suggestion_friend");
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[User_IDArray objectAtIndex:i]];
                NSString *TempUserProfileImg = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
                NSString *TempUseName = [[NSString alloc]initWithFormat:@"%@",[User_UserNameArray objectAtIndex:i]];
                NSString *TempUserPhoto = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
                
                NSArray *TempSplitArray_Id = [TempUserID componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_ProfileImg = [TempUserProfileImg componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_Username = [TempUseName componentsSeparatedByString:@"$"];
                NSArray *TempSplitArray_PostsImg = [TempUserPhoto componentsSeparatedByString:@"$"];
                
                if ([TempSplitArray_PostsImg count] <= [TempSplitArray_Id  count]) {
                    //SplitArray_PostsImg = [[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
                    NSUInteger GetCount = [TempSplitArray_PostsImg count];
                    for (NSUInteger i = GetCount; i < [TempSplitArray_Id  count]; i++) {
                        TempSplitArray_PostsImg = [TempSplitArray_PostsImg arrayByAddingObject:@""];
                    }
                }else{
                    
                }
                if (CheckFollowSuggestionFriend == 0) {
                    CheckFollowSuggestionFriend = 1;
                    
                    SplitArray_Id_Friend = [[NSMutableArray alloc]initWithArray:TempSplitArray_Id];
                    SplitArray_ProfileImg_Friend = [[NSMutableArray alloc]initWithArray:TempSplitArray_ProfileImg];
                    SplitArray_Username_Friend = [[NSMutableArray alloc]initWithArray:TempSplitArray_Username];
                    SplitArray_PostsImg_Friend = [[NSMutableArray alloc]initWithArray:TempSplitArray_PostsImg];
                    
                    FollowSuggestionFriendCount = 0;
                 
                }else{
                
                    [SplitArray_Id_Friend addObjectsFromArray:TempSplitArray_Id];
                    [SplitArray_ProfileImg_Friend addObjectsFromArray:TempSplitArray_ProfileImg];
                    [SplitArray_Username_Friend addObjectsFromArray:TempSplitArray_Username];
                    [SplitArray_PostsImg_Friend addObjectsFromArray:TempSplitArray_PostsImg];
                    
                    FollowSuggestionFriendCount += [TempSplitArray_Id count];
                }
                
                NSLog(@"SplitArray_Id is %@",SplitArray_Id_Friend);
                NSLog(@"SplitArray_ProfileImg is %@",SplitArray_ProfileImg_Friend);
                NSLog(@"SplitArray_Username is %@",SplitArray_Username_Friend);
                NSLog(@"SplitArray_PostsImg is %@",SplitArray_PostsImg_Friend);
                
                arrFriendUserName = [[NSMutableArray alloc]initWithArray:SplitArray_Username_Friend];
                arrFriendUserID = [[NSMutableArray alloc]initWithArray:SplitArray_Id_Friend];
                int TestWidth = screenWidth - 70;
                //    NSLog(@"TestWidth is %i",TestWidth);
                int FinalWidth = TestWidth / 4;
                //    NSLog(@"FinalWidth is %i",FinalWidth);
                int SpaceWidth = FinalWidth + 4;
                
                SUserScrollview_Friend = [[UIScrollView alloc]init];
                SUserScrollview_Friend.delegate = self;
                SUserScrollview_Friend.frame = CGRectMake(0, heightcheck, screenWidth, FinalWidth + 10 + 70 + 50 + 10);
                SUserScrollview_Friend.backgroundColor = [UIColor whiteColor];
                //SUserScrollview_Friend.pagingEnabled = YES;
                [SUserScrollview_Friend setShowsHorizontalScrollIndicator:NO];
                [SUserScrollview_Friend setShowsVerticalScrollIndicator:NO];
                SUserScrollview_Friend.tag = 2100 + i;
                [MainScroll addSubview:SUserScrollview_Friend];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, screenWidth - 70, 50);
                ShowSuggestedText.text = LocalisedString(@"Your fellow Facebook Seetizen");
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
//                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[TempSplitArray_Id count]];
//                
//                ShowSUserCount_Friend = [[UILabel alloc]init];
//                ShowSUserCount_Friend.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
//                ShowSUserCount_Friend.text = TempCount;
//                ShowSUserCount_Friend.backgroundColor = [UIColor clearColor];
//                ShowSUserCount_Friend.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//                ShowSUserCount_Friend.textAlignment = NSTextAlignmentRight;
//                ShowSUserCount_Friend.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//                ShowSUserCount_Friend.tag = 2100 + i;
//                [MainScroll addSubview:ShowSUserCount_Friend];
//                
//                
//                SUserpageControl_Friend = [[UIPageControl alloc] init];
//                SUserpageControl_Friend.frame = CGRectMake(0,heightcheck + FinalWidth + 10 + 70 + 50,screenWidth,30);
//                SUserpageControl_Friend.numberOfPages = [TempSplitArray_Id count];
//                SUserpageControl_Friend.currentPage = 0;
//                SUserpageControl_Friend.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
//                SUserpageControl_Friend.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
//                SUserpageControl_Friend.tag = 2100 + i;
//                [MainScroll addSubview:SUserpageControl_Friend];
                
            
                for (int i = 0; i < [TempSplitArray_Id count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50, screenWidth - 50, FinalWidth + 10 + 70);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SUserScrollview_Friend addSubview: TempButton];
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(20 + i * (screenWidth - 40), 60, 40, 40);
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=1;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[TempSplitArray_ProfileImg objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SUserScrollview_Friend addSubview:ShowUserProfileImage];
                    
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(70 + i * (screenWidth - 40), 50 + 10, 200, 20);
                    ShowUserName.text = [TempSplitArray_Username objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SUserScrollview_Friend addSubview:ShowUserName];
                    
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(70 + i * (screenWidth - 40), 50 + 30, screenWidth - 140 - 10, 20);
                    ShowMessage.text = LocalisedString(@"Follow this Seetizen for more");
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SUserScrollview_Friend addSubview:ShowMessage];
                    
                    UIButton *FollowButton = [[UIButton alloc]init];
                    FollowButton.frame = CGRectMake(screenWidth - 40 - 70 + i * (screenWidth - 40), 52,70, 48);
                    // [FollowButton setTitle:@"Icon" forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateSelected];
                    FollowButton.backgroundColor = [UIColor clearColor];
                    //[FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
                    [SUserScrollview_Friend addSubview: FollowButton];
                    
                    NSString *GetImg = [[NSString alloc]initWithFormat:@"%@",[TempSplitArray_PostsImg objectAtIndex:i]];
                    NSArray *PostsImg = [GetImg componentsSeparatedByString:@","];
                    
                    
                    for (int y = 0; y < 4; y++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * (screenWidth - 40) +(y % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                        // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        ShowImage.layer.borderWidth = 1;
                        ShowImage.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
                        
                        switch (y) {
                            case 0:
                                ShowImage.backgroundColor = [UIColor colorWithRed:122.0f/255.0f green:109.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
                                break;
                            case 1:
                                ShowImage.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:174.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
                                break;
                            case 2:
                                ShowImage.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:115.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
                                break;
                            case 3:
                                ShowImage.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:224.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
                                break;
                                
                            default:
                                break;
                        }
                        
                        [SUserScrollview_Friend addSubview:ShowImage];
                    }
                    
                    for (int z = 0; z < [PostsImg count]; z++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * (screenWidth - 40) +(z % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                        // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        ShowImage.layer.borderWidth = 1;
                        ShowImage.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[PostsImg objectAtIndex:z]];
                        if ([ImageData length] == 0) {
                           // ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage.imageURL = url_NearbySmall;
                        }
                        [SUserScrollview_Friend addSubview:ShowImage];
                        
                    }
                    
                    UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                    [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                    OpenUserProfileButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [OpenUserProfileButton addTarget:self action:@selector(FriendsOpenUserProfile:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserProfileButton.tag = i + FollowSuggestionFriendCount;
                    [SUserScrollview_Friend addSubview:OpenUserProfileButton];
                    
                    SUserScrollview_Friend.contentSize = CGSizeMake(10 + i * (screenWidth - 40) + (screenWidth - 40), 100);
                }
                
                heightcheck += FinalWidth + 10 + 70 + 50 + 10 + 10;
            }break;
            case 8:{
                NSLog(@"in deal");
                SuggestedScrollview_Deal = [[UIScrollView alloc]init];
                SuggestedScrollview_Deal.delegate = self;
                SuggestedScrollview_Deal.frame = CGRectMake(0, heightcheck, screenWidth, 355);
                SuggestedScrollview_Deal.backgroundColor = [UIColor whiteColor];
                //SuggestedScrollview_Deal.pagingEnabled = YES;
                [SuggestedScrollview_Deal setShowsHorizontalScrollIndicator:NO];
                [SuggestedScrollview_Deal setShowsVerticalScrollIndicator:NO];
                SuggestedScrollview_Deal.tag = 1100;
                [MainScroll addSubview:SuggestedScrollview_Deal];
                
                
                NSString *TempUsername = [[NSString alloc]initWithFormat:@"%@",[arrUserName objectAtIndex:i]];
                NSArray *SplitArray_username = [TempUsername componentsSeparatedByString:@","];
                NSString *TempUserImage = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                NSArray *SplitArray_UserImage = [TempUserImage componentsSeparatedByString:@","];
                NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                NSArray *SplitArray_Image = [TempImage componentsSeparatedByString:@","];
                
                NSString *TempLocation = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                NSArray *SplitArray_Location = [TempLocation componentsSeparatedByString:@","];
                NSString *TempTitle = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                NSArray *SplitArray_Title = [TempTitle componentsSeparatedByString:@"|||||"];
//                NSLog(@"arrTitle is %@",arrTitle);
//                NSLog(@"TempTitle is %@",TempTitle);
//                NSLog(@"SplitArray_Title is %@",SplitArray_Title);
                
                NSString *TempAddress = [[NSString alloc]initWithFormat:@"%@",[arrAddress objectAtIndex:i]];
                NSArray *SplitArray_Address = [TempAddress componentsSeparatedByString:@","];
                
                NSString *TempId = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:i]];
                NSArray *SplitArray_Id = [TempId componentsSeparatedByString:@","];
                arrDealID = [[NSMutableArray alloc]initWithArray:SplitArray_Id];
                
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[arrUserID objectAtIndex:i]];
                NSArray *SplitArray_UserID = [TempUserID componentsSeparatedByString:@","];
                arrDealUserID = [[NSMutableArray alloc]initWithArray:SplitArray_UserID];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, screenWidth - 70, 50);
                ShowSuggestedText.text = LocalisedString(@"Deals near you");
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
//                NSString *TempString = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[SplitArray_Id count]];
//                
//                ShowSuggestedCount_Deal = [[UILabel alloc]init];
//                ShowSuggestedCount_Deal.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
//                ShowSuggestedCount_Deal.text = TempString;
//                ShowSuggestedCount_Deal.backgroundColor = [UIColor clearColor];
//                ShowSuggestedCount_Deal.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//                ShowSuggestedCount_Deal.textAlignment = NSTextAlignmentRight;
//                ShowSuggestedCount_Deal.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//                [MainScroll addSubview:ShowSuggestedCount_Deal];
//                
//                SuggestedpageControl_Deal = [[UIPageControl alloc] init];
//                SuggestedpageControl_Deal.frame = CGRectMake(0,heightcheck + 340,screenWidth,30);
//                SuggestedpageControl_Deal.numberOfPages = [SplitArray_Id count];
//                SuggestedpageControl_Deal.currentPage = 0;
//                SuggestedpageControl_Deal.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
//                SuggestedpageControl_Deal.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
//                [MainScroll addSubview:SuggestedpageControl_Deal];
                
                UIButton *SeeallButton = [[UIButton alloc]init];
                SeeallButton.frame = CGRectMake(screenWidth - 120, heightcheck, 120, 50);
                [SeeallButton setTitle:LocalisedString(@"See all")  forState:UIControlStateNormal];
                [SeeallButton setImage:[UIImage imageNamed:@"ArrowBtn.png"] forState:UIControlStateNormal];
                SeeallButton.backgroundColor = [UIColor clearColor];
                SeeallButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
                SeeallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [SeeallButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13]];
                [SeeallButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [SeeallButton addTarget:self action:@selector(DealSeeAllButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview: SeeallButton];

                
                for (int i = 0; i < [SplitArray_username count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,290);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SuggestedScrollview_Deal addSubview: TempButton];
                    
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,198);
                    ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage.layer.cornerRadius=5;
                    ShowImage.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Image objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage.imageURL = url_NearbySmall;
                    }
                    [SuggestedScrollview_Deal addSubview:ShowImage];
                    
                    
                    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                    ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
                    ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 50, screenWidth - 50, 198);
                    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                    ShowOverlayImg.layer.masksToBounds = YES;
                    ShowOverlayImg.layer.cornerRadius = 5;
                    [SuggestedScrollview_Deal addSubview:ShowOverlayImg];
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, 40, 40);
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=1;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_UserImage objectAtIndex:i]];
                    if ([ImageData1 length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SuggestedScrollview_Deal addSubview:ShowUserProfileImage];
                    
                    NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[SplitArray_username objectAtIndex:i]];
                    NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Location objectAtIndex:i]];
                    NSString *Address = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Address objectAtIndex:i]];
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(75 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
                    ShowUserName.text = usernameTemp;
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor whiteColor];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Deal addSubview:ShowUserName];
                    
                    UILabel *ShowDistance = [[UILabel alloc]init];
                    ShowDistance.frame = CGRectMake(screenWidth - 155 + i * (screenWidth - 40), 51 + 10, 100, 40);
                    // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                    ShowDistance.text = Distance;
                    ShowDistance.textColor = [UIColor whiteColor];
                    ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistance.textAlignment = NSTextAlignmentRight;
                    ShowDistance.backgroundColor = [UIColor clearColor];
                    [SuggestedScrollview_Deal addSubview:ShowDistance];
                    
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Title objectAtIndex:i]];
                    if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"] || [TempGetStirng isEqualToString:@"("]) {
                        
                    }else{
                        
                        ShowTitle.frame = CGRectMake(25 + i * screenWidth, 51 + 198 + 20, screenWidth - 50, 30);
                        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                        paragraph.minimumLineHeight = 21.0f;
                        paragraph.maximumLineHeight = 21.0f;
                        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TempGetStirng attributes:@{NSParagraphStyleAttributeName: paragraph}];
                        ShowTitle.attributedText = attributedString;
                        ShowTitle.backgroundColor = [UIColor clearColor];
                        ShowTitle.numberOfLines = 2;
                        ShowTitle.textAlignment = NSTextAlignmentLeft;
                        ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
                        [SuggestedScrollview_Deal addSubview:ShowTitle];
                        
                        if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 80, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                        {
                            ShowTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 198 + 20, screenWidth - 80,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 80, CGFLOAT_MAX)].height);
                        }
                    }
                    
                    UIImageView *ShowPinLocalQR = [[UIImageView alloc]init];
                    ShowPinLocalQR.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                    ShowPinLocalQR.frame = CGRectMake(20 + i * (screenWidth - 40), 51 + 198 + ShowTitle.frame.size.height + 25, 18, 18);
                    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                    [SuggestedScrollview_Deal addSubview:ShowPinLocalQR];
                    
                    UILabel *ShowAddressLocalQR = [[UILabel alloc]init];
                    ShowAddressLocalQR.frame = CGRectMake(40 + i * (screenWidth - 40), 51 + 198 + ShowTitle.frame.size.height + 25, screenWidth - 80, 20);
                    ShowAddressLocalQR.text = Address;
                    ShowAddressLocalQR.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SuggestedScrollview_Deal addSubview:ShowAddressLocalQR];
                    
                    //  int TempCountWhiteHeight = 51 + 198 + 10;
                    
                    UIButton *OpenPostsButton = [[UIButton alloc]init];
                    [OpenPostsButton setTitle:@"" forState:UIControlStateNormal];
                    OpenPostsButton.backgroundColor = [UIColor clearColor];
                    OpenPostsButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,280);
                    [OpenPostsButton addTarget:self action:@selector(DealOpenPostsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenPostsButton.tag = i;
                    [SuggestedScrollview_Deal addSubview:OpenPostsButton];
                    
                    UIButton *OpenUserButton = [[UIButton alloc]init];
                    [OpenUserButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserButton.backgroundColor = [UIColor clearColor];
                    OpenUserButton.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
                    [OpenUserButton addTarget:self action:@selector(DealUserOpenProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserButton.tag = i;
                    [SuggestedScrollview_Deal addSubview:OpenUserButton];
                    
                    
                    SuggestedScrollview_Deal.contentSize = CGSizeMake(10 + i * (screenWidth - 40) + (screenWidth - 45), 300);
                }
                heightcheck += 360;
            }break;
            case 9:{
                NSLog(@"in invite_friend");
                AsyncImageView *BannerImage = [[AsyncImageView alloc]init];
                BannerImage.frame = CGRectMake(0, heightcheck, screenWidth, 150);
                BannerImage.contentMode = UIViewContentModeScaleAspectFit;
                BannerImage.backgroundColor = [UIColor clearColor];
                BannerImage.layer.masksToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BannerImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    BannerImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    BannerImage.imageURL = url_NearbySmall;
                }
                
                [MainScroll addSubview:BannerImage];
                
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(0, heightcheck, screenWidth, 150);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor clearColor];
                [TempButton addTarget:self action:@selector(OpenInviteButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview: TempButton];
                
                heightcheck += 160;
}
                break;
            case 10:{
            NSLog(@"in country_promotion");
                AsyncImageView *BannerImage = [[AsyncImageView alloc]init];
                BannerImage.frame = CGRectMake(0, heightcheck, screenWidth, 150);
                BannerImage.contentMode = UIViewContentModeScaleAspectFit;
                BannerImage.backgroundColor = [UIColor clearColor];
                BannerImage.layer.masksToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BannerImage];
                NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                if ([ImageData length] == 0) {
                    BannerImage.image = [UIImage imageNamed:@"NoImage.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                    BannerImage.imageURL = url_NearbySmall;
                }
                
                [MainScroll addSubview:BannerImage];
                
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(0, heightcheck, screenWidth, 150);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor clearColor];
                TempButton.tag = i;
                [TempButton addTarget:self action:@selector(OpenPromotionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview: TempButton];
                
                heightcheck += 160;
            }
                break;
                
            case 11:{
                NSLog(@"in collect_suggestion");
                
//                NSLog(@"Show ID == %@",[arrPostID objectAtIndex:i]);
//                NSLog(@"Show Name == %@",[arrTitle objectAtIndex:i]);
//                NSLog(@"Show Description == %@",[arrMessage objectAtIndex:i]);
//                NSLog(@"Show username == %@",[arrUserName objectAtIndex:i]);
//                NSLog(@"Show userimage == %@",[arrUserImage objectAtIndex:i]);
//                NSLog(@"Show Posts Image == %@",[arrImage objectAtIndex:i]);
//                NSLog(@"Show Following == %@",[arrlike objectAtIndex:i]);
                
                CollectionScrollview = [[UIScrollView alloc]init];
                CollectionScrollview.delegate = self;
                CollectionScrollview.frame = CGRectMake(0, heightcheck, screenWidth, 260);
                CollectionScrollview.backgroundColor = [UIColor whiteColor];
                //CollectionScrollview.pagingEnabled = YES;
                [CollectionScrollview setShowsHorizontalScrollIndicator:NO];
                [CollectionScrollview setShowsVerticalScrollIndicator:NO];
                CollectionScrollview.tag = 10000;
                CollectionScrollview.layer.masksToBounds = YES;
                CollectionScrollview.layer.borderWidth = 1;
                CollectionScrollview.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
                [MainScroll addSubview:CollectionScrollview];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, screenWidth - 70, 50);
                ShowSuggestedText.text = LocalisedString(@"Suggested Collections");
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
                UIButton *SeeallButton = [[UIButton alloc]init];
                SeeallButton.frame = CGRectMake(screenWidth - 120, heightcheck, 120, 50);
                [SeeallButton setTitle:LocalisedString(@"See all")  forState:UIControlStateNormal];
                [SeeallButton setImage:[UIImage imageNamed:@"ArrowBtn.png"] forState:UIControlStateNormal];
                SeeallButton.backgroundColor = [UIColor clearColor];
                SeeallButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
                SeeallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [SeeallButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13]];
                [SeeallButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [SeeallButton addTarget:self action:@selector(SeeAllButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview: SeeallButton];
                
                
                NSString *TempUsername = [[NSString alloc]initWithFormat:@"%@",[arrUserName objectAtIndex:i]];
                NSArray *SplitArray_username = [TempUsername componentsSeparatedByString:@","];
                arrCollectionName = [[NSMutableArray alloc]initWithArray:SplitArray_username];
                
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[arrUserID objectAtIndex:i]];
                NSArray *SplitArray_userid = [TempUserID componentsSeparatedByString:@","];
                arrCollectionUserID = [[NSMutableArray alloc]initWithArray:SplitArray_userid];
                
                
                NSString *TempUserImage = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                NSArray *SplitArray_UserImage = [TempUserImage componentsSeparatedByString:@","];
                NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                NSArray *SplitArray_Image = [TempImage componentsSeparatedByString:@","];
                
                NSString *TempTitle = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                NSArray *SplitArray_Title = [TempTitle componentsSeparatedByString:@","];
                NSString *TempCount = [[NSString alloc]initWithFormat:@"%@",[arrMessage objectAtIndex:i]];
                NSArray *SplitArray_Count = [TempCount componentsSeparatedByString:@","];
                
                NSString *TempCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
                NSArray *SplitArray_Following = [TempCollectionFollowing componentsSeparatedByString:@","];
                arrCollectionFollowing = [[NSMutableArray alloc]initWithArray:SplitArray_Following];
                
                
                NSString *TempCollectionID = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:i]];
                NSArray *SplitArray_Id = [TempCollectionID componentsSeparatedByString:@","];
                arrCollectionID = [[NSMutableArray alloc]initWithArray:SplitArray_Id];
                
               // NSLog(@"SplitArray_Image is %@",SplitArray_Image);
                for (int i = 0; i < [SplitArray_username count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,190);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 10;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [CollectionScrollview addSubview: TempButton];
                    
                    
                    NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Image objectAtIndex:i]];
                    NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
                    
                    if ([SplitArray_TempImage count] == 1) {
                        AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                        ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,120);
                        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                        ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage1.layer.cornerRadius= 10;
                        ShowImage1.layer.masksToBounds = YES;
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
                        if ([ImageData length] == 0) {
                            ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage1.imageURL = url_NearbySmall;
                        }
                        [CollectionScrollview addSubview:ShowImage1];
                    }else{
                        AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                        ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , ((screenWidth - 55) / 2) ,120);
                        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                        ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage1.layer.cornerRadius= 10;
                        ShowImage1.layer.masksToBounds = YES;
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
                        if ([ImageData length] == 0) {
                            ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage1.imageURL = url_NearbySmall;
                        }
                        [CollectionScrollview addSubview:ShowImage1];
                        
                        AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
                        ShowImage2.frame = CGRectMake(10 + ((screenWidth - 40) / 2) + i * (screenWidth - 40), 50 , ((screenWidth - 60) / 2) ,120);
                        //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                        ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage2.layer.cornerRadius=10;
                        ShowImage2.layer.masksToBounds = YES;
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
                        NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:1]];
                        if ([ImageData100 length] == 0) {
                            ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
                            ShowImage2.imageURL = url_NearbySmall;
                        }
                        [CollectionScrollview addSubview:ShowImage2];
                    }
                    

                    
                    
                    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                    ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
                    ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,150);
                    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                    ShowOverlayImg.layer.masksToBounds = YES;
                     ShowOverlayImg.layer.cornerRadius = 10;
                    [CollectionScrollview addSubview:ShowOverlayImg];
                    
                    
                    
                    UIButton *OpenCollectionButton = [[UIButton alloc]init];
                    OpenCollectionButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,190);
                    [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
                    OpenCollectionButton.backgroundColor = [UIColor clearColor];
                    OpenCollectionButton.layer.cornerRadius = 10;
                    OpenCollectionButton.layer.borderWidth=1;
                    OpenCollectionButton.layer.masksToBounds = YES;
                    OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenCollectionButton.tag = i;
                    [CollectionScrollview addSubview: OpenCollectionButton];
                    
                     AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, 40, 40);
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=1;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_UserImage objectAtIndex:i]];
                    if ([ImageData1 length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [CollectionScrollview addSubview:ShowUserProfileImage];
                    
                    UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                    [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                    OpenUserProfileButton.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
                    [OpenUserProfileButton addTarget:self action:@selector(CollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserProfileButton.tag = i;
                    [CollectionScrollview addSubview:OpenUserProfileButton];
                    
                    NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[arrCollectionName objectAtIndex:i]];
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(75 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
                    ShowUserName.text = usernameTemp;
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor whiteColor];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [CollectionScrollview addSubview:ShowUserName];
                    
                    UILabel *ShowCollectionTitle = [[UILabel alloc]init];
                    ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 180, screenWidth - 190 , 20);
                    ShowCollectionTitle.text = [SplitArray_Title objectAtIndex:i];
                    ShowCollectionTitle.backgroundColor = [UIColor clearColor];
                    ShowCollectionTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
                    ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
                    [CollectionScrollview addSubview:ShowCollectionTitle];
                    
                    
                    NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ %@",[SplitArray_Count objectAtIndex:i],LocalisedString(@"recommendations")];
                    
                    UILabel *ShowCollectionCount = [[UILabel alloc]init];
                    ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 40), 200, screenWidth - 190, 25);
                    ShowCollectionCount.text = TempCount;
                    ShowCollectionCount.backgroundColor = [UIColor clearColor];
                    ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
                    ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
                    [CollectionScrollview addSubview:ShowCollectionCount];
                    
                    NSString *CheckCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrCollectionFollowing objectAtIndex:i]];
                   // NSLog(@"CheckCollectionFollowing is %@",CheckCollectionFollowing);
                    UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
                    if ([CheckCollectionFollowing isEqualToString:@"0"]) {
                        [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
                        [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
                    }else{
                        [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateNormal];
                        [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateSelected];
                    }
                    //[QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
                    [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                    QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
                    QuickCollectButtonLocalQR.frame = CGRectMake((screenWidth - 45 - 115) + i * (screenWidth - 40), 186, 115, 38);//115,38
                    [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectionFollowingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    QuickCollectButtonLocalQR.tag = i + 8000;
                    [CollectionScrollview addSubview:QuickCollectButtonLocalQR];
                    
                    
                    CollectionScrollview.contentSize = CGSizeMake(20 + i * (screenWidth - 40) + (screenWidth - 50), 200);
                }
                
                
                heightcheck += 270;
            }
                break;
            case 12:{
                NSLog(@"in following_collection");
                
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 400);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                TempButton.layer.borderWidth=1;
                TempButton.layer.masksToBounds = YES;
                TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                [MainScroll addSubview: TempButton];
                
                NSString *TempUsername = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
                NSArray *SplitArray_ImageData = [TempUsername componentsSeparatedByString:@","];
                
                
                UIImageView *ShowIcon = [[UIImageView alloc]init];
                ShowIcon.image = [UIImage imageNamed:@"YellowCollections.png"];
                ShowIcon.frame = CGRectMake(20, heightcheck + 8, 33, 33);
                [MainScroll addSubview:ShowIcon];
                
                NSString *TempString = [[NSString alloc]initWithFormat:@"%@ collected %lu posts in %@",[arrUserName objectAtIndex:i],(unsigned long)[SplitArray_ImageData count],[arrTitle objectAtIndex:i]];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(63, heightcheck, screenWidth - 73, 50);
                ShowSuggestedText.text = TempString;
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowSuggestedText.numberOfLines = 2;
                [MainScroll addSubview:ShowSuggestedText];
                
                
                if ([SplitArray_ImageData count] == 1) {
                    AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                    ShowImage1.frame = CGRectMake(10 , heightcheck + 50 , screenWidth - 20, 280);
                    //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                    ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    //ShowImage1.layer.cornerRadius= 10;
                    ShowImage1.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:0]];
                    if ([ImageData length] == 0) {
                        ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage1.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage1];
                    
                }else if([SplitArray_ImageData count] == 2){
                    
                    AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                    ShowImage1.frame = CGRectMake(10 , heightcheck + 50 , (screenWidth - 25) / 2, 280);
                    //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                    ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    //ShowImage1.layer.cornerRadius= 10;
                    ShowImage1.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:0]];
                    if ([ImageData length] == 0) {
                        ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage1.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage1];
                    
                    AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
                    ShowImage2.frame = CGRectMake(15 + (screenWidth - 20) / 2 , heightcheck + 50 , (screenWidth - 25) / 2, 280);
                    ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage2.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:1]];
                    if ([ImageData1 length] == 0) {
                        ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowImage2.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage2];
                    
                }else if([SplitArray_ImageData count] == 3){
                    AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                    ShowImage1.frame = CGRectMake(10 , heightcheck + 50 , screenWidth - 20 - 96 - 5, 280);
                    ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage1.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:0]];
                    if ([ImageData length] == 0) {
                        ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage1.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage1];
                    
                    AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
                    ShowImage2.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 50 , 96, 137);
                    ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage2.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:1]];
                    if ([ImageData1 length] == 0) {
                        ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowImage2.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage2];
                    
                    AsyncImageView *ShowImage3 = [[AsyncImageView alloc]init];
                    ShowImage3.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 55 + 137, 96, 137);
                    ShowImage3.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage3.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage3.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage3];
                    NSString *ImageData2 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:2]];
                    if ([ImageData2 length] == 0) {
                        ShowImage3.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData2];
                        ShowImage3.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage3];
                    
                }else{
                    AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                    ShowImage1.frame = CGRectMake(10 , heightcheck + 50 , screenWidth - 20 - 96 - 5, 280);
                    ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage1.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:0]];
                    if ([ImageData length] == 0) {
                        ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowImage1.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage1];
                    
                    AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
                    ShowImage2.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 50 , 96, 90);
                    ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage2.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
                    NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:1]];
                    if ([ImageData1 length] == 0) {
                        ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                        ShowImage2.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage2];
                    
                    AsyncImageView *ShowImage3 = [[AsyncImageView alloc]init];
                    ShowImage3.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 55 + 90, 96, 90);
                    ShowImage3.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage3.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage3.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage3];
                    NSString *ImageData2 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:2]];
                    if ([ImageData2 length] == 0) {
                        ShowImage3.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData2];
                        ShowImage3.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage3];
                    
                    AsyncImageView *ShowImage4 = [[AsyncImageView alloc]init];
                    ShowImage4.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 60 + 90 + 90, 96, 90);
                    ShowImage4.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage4.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage4.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage4];
                    NSString *ImageData3 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ImageData objectAtIndex:3]];
                    if ([ImageData3 length] == 0) {
                        ShowImage4.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData3];
                        ShowImage4.imageURL = url_NearbySmall;
                    }
                    [MainScroll addSubview:ShowImage4];
                    

                    
                    NSInteger GetImageTotalCount = [SplitArray_ImageData count];
                    NSInteger GetLastCount = GetImageTotalCount - 3;
                    
                    if (GetLastCount == 0) {
                        
                    }else{
                        UIButton *MiniOverlay = [[UIButton alloc]init];
                        [MiniOverlay setTitle:@"" forState:UIControlStateNormal];
                        MiniOverlay.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 60 + 90 + 90, 96, 90);
                        MiniOverlay.alpha = 0.8f;
                        MiniOverlay.backgroundColor = [UIColor blackColor];
                        [MainScroll addSubview:MiniOverlay];
                        
                        NSString *TempCountString = [[NSString alloc]initWithFormat:@"%li +",(long)GetLastCount];
                        
                        UILabel *ShowMoreText = [[UILabel alloc]init];
                        ShowMoreText.frame = CGRectMake(screenWidth - 10 - 96 , heightcheck + 60 + 90 + 90, 96, 90);
                        ShowMoreText.text = TempCountString;
                        ShowMoreText.backgroundColor = [UIColor clearColor];
                        ShowMoreText.textColor = [UIColor whiteColor];
                        ShowMoreText.textAlignment = NSTextAlignmentCenter;
                        ShowMoreText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:22];
                        [MainScroll addSubview:ShowMoreText];
                    }
                    

                    
                    //96 x 85
                }
                
                UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
                ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
                ShowOverlayImg.frame = CGRectMake(10, heightcheck + 50, screenWidth - 20, 280);
                ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
                ShowOverlayImg.layer.masksToBounds = YES;
               // ShowOverlayImg.layer.cornerRadius = 10;
                [MainScroll addSubview:ShowOverlayImg];
                
                
                UIButton *OpenFollowingCollectionButton = [[UIButton alloc]init];
                [OpenFollowingCollectionButton setTitle:@"" forState:UIControlStateNormal];
                OpenFollowingCollectionButton.backgroundColor = [UIColor clearColor];
                OpenFollowingCollectionButton.frame = CGRectMake(10, heightcheck + 50, screenWidth - 20, 280);
                [OpenFollowingCollectionButton addTarget:self action:@selector(FollowingCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                OpenFollowingCollectionButton.tag = i;
                [MainScroll addSubview:OpenFollowingCollectionButton];
                
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(25 , heightcheck + 51 + 10, 40, 40);
                // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=1;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
                if ([ImageData1 length] == 0) {
                    ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                }else{
                    NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                    ShowUserProfileImage.imageURL = url_NearbySmall;
                }
                [MainScroll addSubview:ShowUserProfileImage];
                
                UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                OpenUserProfileButton.frame = CGRectMake(25 , heightcheck + 51 + 10, screenWidth - 50, 40);
                [OpenUserProfileButton addTarget:self action:@selector(FollowingCollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                OpenUserProfileButton.tag = i;
                [MainScroll addSubview:OpenUserProfileButton];
                
                NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[arrUserName objectAtIndex:i]];
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(75, heightcheck + 51 + 10, screenWidth - 75 - 100, 40);
                ShowUserName.text = usernameTemp;
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor whiteColor];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];

                                
                UILabel *ShowCollectionTitle = [[UILabel alloc]init];
                ShowCollectionTitle.frame = CGRectMake(20, heightcheck + 340, screenWidth - 190 , 25);
                ShowCollectionTitle.text = [arrTitle objectAtIndex:i];
                ShowCollectionTitle.backgroundColor = [UIColor clearColor];
                ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
                ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
                [MainScroll addSubview:ShowCollectionTitle];
                
                
                NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ %@",[arrMessage objectAtIndex:i],LocalisedString(@"recommendations")];
                
                UILabel *ShowCollectionCount = [[UILabel alloc]init];
                ShowCollectionCount.frame = CGRectMake(20, heightcheck + 365, screenWidth - 190, 25);
                ShowCollectionCount.text = TempCount;
                ShowCollectionCount.backgroundColor = [UIColor clearColor];
                ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
                ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
                [MainScroll addSubview:ShowCollectionCount];
                
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(screenWidth - 120 - 20, heightcheck + 345, 120, 40);
                [ShareButton setTitle:LocalisedString(@"Share") forState:UIControlStateNormal];
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor whiteColor];
                ShareButton.layer.cornerRadius = 20;
                ShareButton.layer.borderWidth=1;
                ShareButton.layer.masksToBounds = YES;
                ShareButton.layer.borderColor=[[UIColor colorWithRed:231.0f/255.0f green:231.0f/255.0f blue:231.0f/255.0f alpha:1.0f] CGColor];
                ShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
                ShareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                ShareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [ShareButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                [ShareButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [ShareButton addTarget:self action:@selector(FollowCollectionShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                ShareButton.tag = i;
                [MainScroll addSubview: ShareButton];
                
                
                
//                NSLog(@"Show ID == %@",[arrPostID objectAtIndex:i]);
//                NSLog(@"Show Name == %@",[arrTitle objectAtIndex:i]);
//                NSLog(@"Show Description == %@",[arrMessage objectAtIndex:i]);
//                NSLog(@"Show username == %@",[arrUserName objectAtIndex:i]);
//                NSLog(@"Show userimage == %@",[arrUserImage objectAtIndex:i]);
//                NSLog(@"Show Posts Image == %@",[arrImage objectAtIndex:i]);

                
                
                heightcheck += 410;
            }
            
                break;
            default:
                break;
        }
    
    }

    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 169 + 50)];
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (CheckFirstTimeLoad == 0) {
        [self SaveDataInLocal];
        }
    });
    
    
//    UIButton *NearbyButton = [[UIButton alloc]init];
//    NearbyButton.frame = CGRectMake((screenWidth / 2) - 60, 105, 120, 37);
//    [NearbyButton setImage:[UIImage imageNamed:@"nearby_btn.png"] forState:UIControlStateNormal];
//    NearbyButton.backgroundColor = [UIColor clearColor];
//    [NearbyButton addTarget:self action:@selector(NearbyButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview: NearbyButton];
    
}

-(void)SaveDataInLocal{
    NSLog(@"Run Save Data in Local");
     if (CheckFirstTimeLoad == 0) {
        NSError *error = nil;
        NSMutableArray *TempArray_FeedImage = [[NSMutableArray alloc]init];
        NSMutableArray *TempArray_FeedUserImage = [[NSMutableArray alloc]init];
    for (NSInteger i = DataCount; i < [arrPostID count]; i++) {
        
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[arrType objectAtIndex:i]];
        if ([GetType isEqualToString:@"following_post"]) {
            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
            UIImage *newImage;
            if ([TempImage length] == 0) {
                newImage = [UIImage imageNamed:@"NoImage.png"];
                [TempArray_FeedImage addObject:@""];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:TempImage];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                newImage = [UIImage imageWithData:data];
                
                NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                // Content_ Folder is your folder name

                if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
                //This will create a new folder if content folder is not exist
                NSString *fileName = [stringPath stringByAppendingFormat:@"/FeedLocalimage_%li.jpg",(long)i];
                [imageData writeToFile:fileName atomically:YES];
                // NSLog(@"fileName is %@",fileName);
                NSString *SaveFileName = [[NSString alloc]initWithFormat:@"FeedLocalimage_%li.jpg",(long)i];
                [TempArray_FeedImage addObject:SaveFileName];
            }
            
            NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
            UIImage *UserImage;
            if ([FullImagesURL length] == 0) {
                UserImage = [UIImage imageNamed:@"DefaultProfilePic.png"];
                [TempArray_FeedUserImage addObject:@""];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                UserImage = [UIImage imageWithData:data];
                
                NSData *imageData_UserImage = UIImageJPEGRepresentation(UserImage, 1);
                NSString *stringPath_1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath_1])
                    [[NSFileManager defaultManager] createDirectoryAtPath:stringPath_1  withIntermediateDirectories:NO attributes:nil error:&error];
                //This will create a new folder if content folder is not exist
                NSString *fileName_1 = [stringPath_1 stringByAppendingFormat:@"/FeedLocalUserImg_%li.jpg",(long)i];
                [imageData_UserImage writeToFile:fileName_1 atomically:YES];
                NSString *SaveFileName_1 = [[NSString alloc]initWithFormat:@"FeedLocalUserImg_%li.jpg",(long)i];
                [TempArray_FeedUserImage addObject:SaveFileName_1];
            }
        }else{
            [TempArray_FeedImage addObject:@""];
            [TempArray_FeedUserImage addObject:@""];
        }
    }
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:TempArray_FeedImage forKey:@"FeedLocalImg"];// image data
         [defaults setObject:arrAddress forKey:@"FeedLocalarrAddress"];
         [defaults setObject:arrTitle forKey:@"FeedLocalarrTitle"];
         [defaults setObject:arrMessage forKey:@"FeedLocalarrMessage"];
         [defaults setObject:arrType forKey:@"FeedLocalarrType"];
         [defaults setObject:arrDistance forKey:@"FeedLocalarrDistance"];
         [defaults setObject:arrUserName forKey:@"FeedLocalarrUserName"];
         [defaults setObject:TempArray_FeedUserImage forKey:@"FeedLocalarrUserImage"];
         [defaults setObject:arrDisplayCountryName forKey:@"FeedLocalarrDisplayCountryName"];
         [defaults setObject:arrPostID forKey:@"FeedLocalarrPostID"];
         [defaults setObject:arrImageHeight forKey:@"FeedLocalarrImageHeight"];
         [defaults setObject:arrImageWidth forKey:@"FeedLocalarrImageWidth"];
         [defaults setObject:arrlike forKey:@"FeedLocalarrLike"];
         [defaults setObject:arrCollect forKey:@"FeedLocalarrCollect"];
         [defaults setObject:@"Done" forKey:@"TestLocalData"];
         [defaults synchronize];
    
}

    
    NSLog(@"Done Save Data in Local");
    CheckFirstTimeLoad = 1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView == SuggestedScrollview_Aboad) {
//        CGFloat pageWidth = SuggestedScrollview_Aboad.frame.size.width; // you need to have a **iVar** with getter for scrollView
//        float fractionalPage = SuggestedScrollview_Aboad.contentOffset.x / pageWidth;
//        NSInteger page = lround(fractionalPage);
//        SuggestedpageControl_Aboad.currentPage = page; // you need to have a **iVar** with getter for pageControl
//        
//        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrAboadID count]];
//        ShowSuggestedCount_Aboad.text = TempCount;
    }else if (scrollView == SuggestedScrollview_Deal){
//        CGFloat pageWidth = SuggestedScrollview_Deal.frame.size.width; // you need to have a **iVar** with getter for scrollView
//        float fractionalPage = SuggestedScrollview_Deal.contentOffset.x / pageWidth;
//        NSInteger page = lround(fractionalPage);
//        SuggestedpageControl_Deal.currentPage = page; // you need to have a **iVar** with getter for pageControl
//        
//        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrDealID count]];
//        ShowSuggestedCount_Deal.text = TempCount;
    }else if(scrollView == SUserScrollview_Friend){
        CGFloat pageWidth = SUserScrollview_Friend.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SUserScrollview_Friend.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SUserpageControl_Friend.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrFriendUserName count] - FollowSuggestionFriendCount];
        ShowSUserCount_Friend.text = TempCount;
    }else if(scrollView == SUserScrollview_Featured){
        //NSLog(@"SUserScrollview_Featured.tag === %li",(long)SUserScrollview_Featured.tag);
        
        CGFloat pageWidth = SUserScrollview_Featured.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SUserScrollview_Featured.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SUserpageControl_Featured.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrfeaturedUserName count] - FollowSuggestionFeaturedCount];
        ShowSUserCount_Featured.text = TempCount;

    }else if(scrollView == MainScroll){
        //NSLog(@"scrollview run here");
        
        float heightcheck_ = MainScroll.contentOffset.y;
        
        if (heightcheck_ > 111) {
            //NSLog(@"Show nearby button top");
            MainNearbyButton.hidden = NO;
        }else{
           // NSLog(@"hide nearby button");
            MainNearbyButton.hidden = YES;
        }
        
        
        
    }


    
    

}

-(IBAction)OpenInviteButton:(id)sender{
    InviteFrenViewController *InviteFrenView = [[InviteFrenViewController alloc]init];
    [self presentViewController:InviteFrenView animated:YES completion:nil];
}

-(void)timerCalled
{
    NSLog(@"Timer Called");
    //[self ReinitData];
    //[self GetFeedDataFromServer];

    
    [self performSelectorOnMainThread:@selector(ReinitData) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(GetFeedDataFromServer) withObject:nil waitUntilDone:NO];

 //   [self performSelectorOnMainThread:@selector(GetFeedDataFromServer) withObject:nil waitUntilDone:NO];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self GetFeedDataFromServer];
//    });

}

-(IBAction)SearchButton:(id)sender{
    SearchViewV2Controller *SearchView = [[SearchViewV2Controller alloc]initWithNibName:@"SearchViewV2Controller" bundle:nil];
    //[self presentViewController:SearchView animated:YES completion:nil];
    [self.navigationController pushViewController:SearchView animated:NO];
    //[self.view.window.rootViewController presentViewController:SearchView animated:YES completion:nil];
}
-(IBAction)FiltersButton:(id)sender{
    NSLog(@"Open Filters Button Click");
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    //[self presentViewController:FilterView animated:YES completion:nil];
    [self.view.window.rootViewController presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Feed"];
}
-(void)GetExternalIPAddress{
    NSURL *iPURL = [NSURL URLWithString:@"https://geoip.seeties.me/geoip/index.php"];
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSData *jsonData = [theIpHtml dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
            // NSLog(@"Feed Json = %@",res);
            ExternalIPAddress = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"ip"]];
            NSLog(@"ExternalIPAddress : %@",ExternalIPAddress);
            
        } else {
            ExternalIPAddress = @"";
            
            NSLog(@"Oops... g %ld, %@",
                  (long)[error code],
                  [error localizedDescription]);
        }
    }
}
-(void)GetFeedDataFromServer{
    OnLoad = YES;
    methodStart = [NSDate date];
    NSLog(@"methodStart is %@",methodStart);
    // [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *CheckNewUser = [defaults objectForKey:@"CheckNewUser"];
    
    if ([CheckNewUser isEqualToString:@"NewUser"]) {
        CheckNewUser = @"&welcome=1";
        NSString *CheckNewUser = @"NewUser";
        [defaults setObject:CheckNewUser forKey:@"CheckNewUser"];
        [defaults synchronize];
    }else{
        CheckNewUser = @"";
    }

   // NSString *GetSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
    //NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];'
    
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] || [ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }else{
        
    }

    NSString *FullString;
    
    if ([GetNextPaging isEqualToString:@""]|| [GetNextPaging length] == 0) {
        if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
            FullString = [[NSString alloc]initWithFormat:@"%@/v2?token=%@&ip_address=%@&offset=%ld&limit=10%@",DataUrl.Feed_Url,GetExpertToken,ExternalIPAddress,(long)Offset,CheckNewUser];
        }else{//ip_address=119.92.244.146
            
            FullString = [[NSString alloc]initWithFormat:@"%@/v2?token=%@&lat=%@&lng=%@&ip_address=%@&offset=%ld&limit=10%@",DataUrl.Feed_Url,GetExpertToken,latPoint,lonPoint,ExternalIPAddress,(long)Offset,CheckNewUser];
        }
    }else{
        Offset += 10;
        DataCount += 10;
        FullString = GetNextPaging;
    }
        
        

        
        
    
//        if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
//            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&ip_address=%@&list_size=9&page=%li",DataUrl.Feed_Url,GetExpertToken,ExternalIPAddress,CurrentPage];
//        }else{//ip_address=119.92.244.146
//            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&lat=%@&lng=%@&ip_address=%@&list_size=9&page=%li",DataUrl.Feed_Url,GetExpertToken,latPoint,lonPoint,ExternalIPAddress,CurrentPage];
//        }
        
        


        
//        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
//            
//        }else{
//            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
//        }
//        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
//            
//        }else{
//            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
//        }
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"MainView check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_All start];
        
        
        if( theConnection_All ){
            webData = [NSMutableData data];
        }
    
    
    

    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {
        ShowUpdateText.frame = CGRectMake(0, 64, screenWidth, 20);
        ShowUpdateText.text = @"Connection error, try again";
        [refreshControl beginRefreshing];
        [self LoadDataView];
    }else{
        [self.view addSubview:NoConnectionView];

    }

    [ShowActivity stopAnimating];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Feed GetData is %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        //SLog(@"GG : %@",res);
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
          //  [ShowAlert show];
        }else{
            NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            if ([StatusString isEqualToString:@"ok"]) {
                
//                FEED TYPES:
//                'following_post';
//                'local_quality_post';
//                'abroad_quality_post';
//                'announcement';
//                'announcement_welcome';
//                'announcement_campaign';
//                'follow_suggestion_featured';
//                'follow_suggestion_friend';
//                'deal';
//                'invite_friend';
                
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                NSDictionary *GetPaging = [GetAllData valueForKey:@"paging"];
                GetNextPaging = [[NSString alloc]initWithFormat:@"%@",[GetPaging objectForKey:@"next"]];
                NSLog(@"GetNextPaging is %@",GetNextPaging);

//                NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"limit"]];
//
//                CurrentPage = [Temppage intValue];
//                TotalPage = [Temptotal_page intValue];
//                
//                NSLog(@"CurrentPage is %li",(long)CurrentPage);
//                NSLog(@"TotalPage is %li",(long)TotalPage);


                 NSDictionary *PostsData = [GetAllData valueForKey:@"items"];
                 for (NSDictionary * dict in PostsData) {
                     NSString *posttype = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"type"]];
                     [arrType addObject:posttype];
                     
                      NSDictionary *GetItemsData = [dict valueForKey:@"data"];
                      NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"post_id"]];
                      NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"place_name"]];
                      NSString *Like = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"like"]];
                      NSString *Collect = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"collect"]];
                     if ([posttype isEqualToString:@"announcement"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"announcement_welcome"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"announcement_campaign"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_friend"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"country_promotion"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"collect_suggestion"]) {
                         NSMutableArray *TempArrayID = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"collection_id"]];
                             [TempArrayID addObject:PlaceID];
                         }
                         NSMutableArray *TempArrayFollowing = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"following"]];
                             [TempArrayFollowing addObject:following];
                         }
                         PlaceID = [TempArrayID componentsJoinedByString:@","];
                         PlaceName = @"";
                         Like = [TempArrayFollowing componentsJoinedByString:@","];
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"following_collection"]) {
                         PlaceID = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"collection_id"]];
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"deal"]) {
                         NSMutableArray *TempArrayID = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayPlaceName = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayLike = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayCollect = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"post_id"]];
                             [TempArrayID addObject:PlaceID];
                             NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"place_name"]];
                             [TempArrayPlaceName addObject:PlaceName];
                             NSString *Like = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"like"]];
                             [TempArrayLike addObject:Like];
                             NSString *collect = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"collect"]];
                             [TempArrayCollect addObject:collect];
                             
                         }
                         PlaceID = [TempArrayID componentsJoinedByString:@","];
                         PlaceName = [TempArrayPlaceName componentsJoinedByString:@","];
                         Like = [TempArrayLike componentsJoinedByString:@","];
                         Collect = [TempArrayCollect componentsJoinedByString:@","];
                     }else if ([posttype isEqualToString:@"invite_friend"]) {
                         PlaceID = @"";
                         PlaceName = @"";
                         Like = @"";
                         Collect = @"";
                     }else if ([posttype isEqualToString:@"abroad_quality_post"]) {
                         NSMutableArray *TempArrayID = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayPlaceName = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayLike = [[NSMutableArray alloc]init];
                         NSMutableArray *TempArrayCollect = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"post_id"]];
                             [TempArrayID addObject:PlaceID];
                             NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"place_name"]];
                             [TempArrayPlaceName addObject:PlaceName];
                             NSString *Like = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"like"]];
                             [TempArrayLike addObject:Like];
                             NSString *collect = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"collect"]];
                             [TempArrayCollect addObject:collect];


                         }
                         PlaceID = [TempArrayID componentsJoinedByString:@","];
                         PlaceName = [TempArrayPlaceName componentsJoinedByString:@","];
                         Like = [TempArrayLike componentsJoinedByString:@","];
                         Collect = [TempArrayCollect componentsJoinedByString:@","];
                     }else{
                     
                     }
                     
                     [arrPostID addObject:PlaceID];
                     [arrAddress addObject:PlaceName];
                     [arrlike addObject:Like];
                     [arrCollect addObject:Collect];
                     
                  //   NSLog(@"--------postid,placename,like,collect-----------");
                     
                     NSDictionary *titleData = [GetItemsData valueForKey:@"title"];
                     NSString *Title1;
                     NSString *Title2;
                     NSString *ThaiTitle;
                     NSString *IndonesianTitle;
                     NSString *PhilippinesTitle;
                     if ([titleData count] == 0) {
                         if([posttype isEqualToString:@"following_collection"]){
                             NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"name"]];
                             [arrTitle addObject:TempName];
                         }else{
                             Title1 = @"";
                             Title2 = @"";
                             ThaiTitle = @"";
                             IndonesianTitle = @"";
                             PhilippinesTitle = @"";
                             [arrTitle addObject:Title1];
                         }

                     }else{
                     
                         if ([posttype isEqualToString:@"deal"] || [posttype isEqualToString:@"abroad_quality_post"]) {
                             NSMutableArray *TempTitleArray = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict in titleData) {
                                 NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"530b0aa16424400c76000002"]];
                                 NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"530b0ab26424400c76000003"]];
                                 NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"544481503efa3ff1588b4567"]];
                                 NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"53672e863efa3f857f8b4ed2"]];
                                 NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"539fbb273efa3fde3f8b4567"]];
                                 if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"] || [Title1 isEqualToString:@"{}"]) {
                                     if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"] || [Title2 isEqualToString:@"{}"]) {
                                         if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle isEqualToString:@"{}"]) {
                                             if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle isEqualToString:@"{}"]) {
                                                 if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle isEqualToString:@"{}"]) {
                                                     [TempTitleArray addObject:@""];
                                                 }else{
                                                     [TempTitleArray addObject:PhilippinesTitle];
                                                     
                                                 }
                                             }else{
                                                 [TempTitleArray addObject:IndonesianTitle];
                                                 
                                             }
                                         }else{
                                             [TempTitleArray addObject:ThaiTitle];
                                         }
                                     }else{
                                         [TempTitleArray addObject:Title2];
                                     }
                                     
                                 }else{
                                     [TempTitleArray addObject:Title1];
                                     
                                 }
                                 
                             }
                             Title1 = [TempTitleArray componentsJoinedByString:@"|||||"];
                             [arrTitle addObject:Title1];
                         }else if([posttype isEqualToString:@"collect_suggestion"]){
                             NSMutableArray *TempTitleArray = [[NSMutableArray alloc]init];
                             NSString *TempName;
                             for (NSDictionary * dict in GetItemsData) {
                                 TempName = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                                 if ([TempName length] == 0 || TempName == nil || [TempName isEqualToString:@"(null)"] || [TempName isEqualToString:@"{}"]) {
                                     
                                 }else{
                                     [TempTitleArray addObject:TempName];
                                     
                                 }

                             }
                             TempName = [TempTitleArray componentsJoinedByString:@","];
                             [arrTitle addObject:TempName];
                         }else if([posttype isEqualToString:@"following_collection"]){
                             NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"name"]];
                             [arrTitle addObject:TempName];
                             NSLog(@"TempName == %@",TempName);
                             NSLog(@"arrTitle == %@",arrTitle);
                         }else{
                             Title2 = [[NSString alloc]initWithFormat:@"%@",[titleData valueForKey:@"530b0aa16424400c76000002"]];
                             Title1 = [[NSString alloc]initWithFormat:@"%@",[titleData valueForKey:@"530b0ab26424400c76000003"]];
                             ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[titleData valueForKey:@"544481503efa3ff1588b4567"]];
                             IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[titleData valueForKey:@"53672e863efa3f857f8b4ed2"]];
                             PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[titleData valueForKey:@"539fbb273efa3fde3f8b4567"]];

                             if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"] || [Title1 isEqualToString:@"{}"]) {
                                 if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"] || [Title2 isEqualToString:@"{}"]) {
                                     if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle isEqualToString:@"{}"]) {
                                         if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle isEqualToString:@"{}"]) {
                                             if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle isEqualToString:@"{}"]) {
                                                 [arrTitle addObject:@""];
                                             }else{
                                                 [arrTitle addObject:PhilippinesTitle];
                                                 
                                             }
                                         }else{
                                             [arrTitle addObject:IndonesianTitle];
                                             
                                         }
                                     }else{
                                         [arrTitle addObject:ThaiTitle];
                                     }
                                 }else{
                                     [arrTitle addObject:Title2];
                                 }
                                 
                             }else{
                                 [arrTitle addObject:Title1];
                                 
                             }
                         }
                     }
                    //  NSLog(@"--------title-----------");

                     
                     NSDictionary *messageData = [GetItemsData valueForKey:@"message"];
                     NSString *Title1_message;
                     NSString *Title2_message;
                     NSString *ThaiTitle_message;
                     NSString *IndonesianTitle_message;
                     NSString *PhilippinesTitle_message;
                     if ([messageData count] == 0) {

                         if([posttype isEqualToString:@"following_collection"]){
                             NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"collection_posts_count"]];
                             [arrMessage addObject:TempName];
                         }else{
                             Title1_message = @"";
                             Title2_message = @"";
                             ThaiTitle_message = @"";
                             IndonesianTitle_message = @"";
                             PhilippinesTitle_message = @"";
                             [arrMessage addObject:Title1_message];
                         }
                     }else{
                         
                         if ([posttype isEqualToString:@"deal"] || [posttype isEqualToString:@"abroad_quality_post"]) {
                             NSMutableArray *TempTitleArray = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict in titleData) {
                                 NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"530b0aa16424400c76000002"]];
                                 NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"530b0ab26424400c76000003"]];
                                 NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"544481503efa3ff1588b4567"]];
                                 NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"53672e863efa3f857f8b4ed2"]];
                                 NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"539fbb273efa3fde3f8b4567"]];
                                 if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"] || [Title1 isEqualToString:@"{}"]) {
                                     if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"] || [Title2 isEqualToString:@"{}"]) {
                                         if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle isEqualToString:@"{}"]) {
                                             if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle isEqualToString:@"{}"]) {
                                                 if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle isEqualToString:@"{}"]) {
                                                     [TempTitleArray addObject:@""];
                                                 }else{
                                                     [TempTitleArray addObject:PhilippinesTitle];
                                                     
                                                 }
                                             }else{
                                                 [TempTitleArray addObject:IndonesianTitle];
                                                 
                                             }
                                         }else{
                                             [TempTitleArray addObject:ThaiTitle];
                                         }
                                     }else{
                                         [TempTitleArray addObject:Title2];
                                     }
                                     
                                 }else{
                                     [TempTitleArray addObject:Title1];
                                     
                                 }
                                 
                             }
                             Title1_message = [TempTitleArray componentsJoinedByString:@","];
                             [arrMessage addObject:Title1_message];
                         }else if([posttype isEqualToString:@"collect_suggestion"]){
                             NSMutableArray *TempTitleArray = [[NSMutableArray alloc]init];
                             NSString *TempName;
                             for (NSDictionary * dict in GetItemsData) {
                                 TempName = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"collection_posts_count"]];
                                 if ([TempName length] == 0 || TempName == nil || [TempName isEqualToString:@"(null)"] || [TempName isEqualToString:@"{}"]) {
                                     
                                 }else{
                                     [TempTitleArray addObject:TempName];
                                     
                                 }
                                 
                             }
                             TempName = [TempTitleArray componentsJoinedByString:@","];
                             [arrMessage addObject:TempName];
                         }else if([posttype isEqualToString:@"following_collection"]){
                             NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"collection_posts_count"]];
                             [arrMessage addObject:TempName];
                         }else{
                             Title2_message = [[NSString alloc]initWithFormat:@"%@",[messageData valueForKey:@"530b0aa16424400c76000002"]];
                             Title1_message = [[NSString alloc]initWithFormat:@"%@",[messageData valueForKey:@"530b0ab26424400c76000003"]];
                             ThaiTitle_message = [[NSString alloc]initWithFormat:@"%@",[messageData valueForKey:@"544481503efa3ff1588b4567"]];
                             IndonesianTitle_message = [[NSString alloc]initWithFormat:@"%@",[messageData valueForKey:@"53672e863efa3f857f8b4ed2"]];
                             PhilippinesTitle_message = [[NSString alloc]initWithFormat:@"%@",[messageData valueForKey:@"539fbb273efa3fde3f8b4567"]];
                             
                             if ([Title1_message length] == 0 || Title1_message == nil || [Title1_message isEqualToString:@"(null)"] || [Title1_message isEqualToString:@"{}"]) {
                                 if ([Title2_message length] == 0 || Title2_message == nil || [Title2_message isEqualToString:@"(null)"] || [Title2_message isEqualToString:@"{}"]) {
                                     if ([ThaiTitle_message length] == 0 || ThaiTitle_message == nil || [ThaiTitle_message isEqualToString:@"(null)"] || [ThaiTitle_message isEqualToString:@"{}"]) {
                                         if ([IndonesianTitle_message length] == 0 || IndonesianTitle_message == nil || [IndonesianTitle_message isEqualToString:@"(null)"] || [IndonesianTitle_message isEqualToString:@"{}"]) {
                                             if ([PhilippinesTitle_message length] == 0 || PhilippinesTitle_message == nil || [PhilippinesTitle_message isEqualToString:@"(null)"] || [PhilippinesTitle_message isEqualToString:@"{}"]) {
                                                 [arrMessage addObject:@""];
                                             }else{
                                                 [arrMessage addObject:PhilippinesTitle_message];
                                                 
                                             }
                                         }else{
                                             [arrMessage addObject:IndonesianTitle_message];
                                             
                                         }
                                     }else{
                                         [arrMessage addObject:ThaiTitle_message];
                                     }
                                 }else{
                                     [arrMessage addObject:Title2_message];
                                 }
                                 
                             }else{
                                 [arrMessage addObject:Title1_message];
                                 
                             }
                     }
                     }
                     
                  //   NSLog(@"--------Message-----------");

                     NSDictionary *GetRelatedData = [GetItemsData valueForKey:@"related"];
                     if ([posttype isEqualToString:@"announcement"] || [posttype isEqualToString:@"announcement_welcome"] || [posttype isEqualToString:@"announcement_campaign"]) {
                         NSString *AId = [[NSString alloc]initWithFormat:@"%@",[GetRelatedData valueForKey:@"id"]];
                         NSString *AType = [[NSString alloc]initWithFormat:@"%@",[GetRelatedData valueForKey:@"type"]];
                         [arrID_Announcement addObject:AId];
                         [arrType_Announcement addObject:AType];
                     }else{
                         [arrID_Announcement addObject:@""];
                         [arrType_Announcement addObject:@""];
                     }
                     
                 //    NSLog(@"--------arrID_Announcement,arrType_Announcement-----------");
                     
                     
                     NSArray *PhotoData = [GetItemsData valueForKey:@"photos"];
                     

                     
                     if ([posttype isEqualToString:@"announcement"]) {
                         NSString *Photourl = [[NSString alloc]initWithFormat:@"%@",[GetRelatedData valueForKey:@"photo"]];
                         [arrImage addObject:Photourl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"announcement_welcome"]) {
                         NSString *Photourl = [[NSString alloc]initWithFormat:@"%@",[GetRelatedData valueForKey:@"photo"]];
                         [arrImage addObject:Photourl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"announcement_campaign"]) {
                         NSString *Photourl = [[NSString alloc]initWithFormat:@"%@",[GetRelatedData valueForKey:@"photo"]];
                         [arrImage addObject:Photourl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
                         [arrImage addObject:@""];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"follow_suggestion_friend"]) {
                         [arrImage addObject:@""];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"deal"]) {
                         NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                         NSMutableArray *ImageWidthArray = [[NSMutableArray alloc]init];
                         NSMutableArray *ImageHeightArray = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in PhotoData) {
                             
                             for (NSDictionary * dict_ in dict) {
                                 NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                                 NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                                 [UrlArray addObject:url];
                                 
                                 NSDictionary *ImageResolutionData = [UserInfoData valueForKey:@"resolution"];
                                 NSString *GetImageWidth = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"w"]];
                                 NSString *GetImageHeight = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"h"]];
                                 [ImageWidthArray addObject:GetImageWidth];
                                 [ImageHeightArray addObject:GetImageHeight];
                                 
                                 break;
                                 
                             }
                             
                             
                         }
                         NSString *resultImageUrl = [UrlArray componentsJoinedByString:@","];
                         NSString *resultImageHeight = [ImageHeightArray componentsJoinedByString:@","];
                         NSString *resultImageWidth = [ImageWidthArray componentsJoinedByString:@","];
                         [arrImage addObject:resultImageUrl];
                         [arrImageHeight addObject:resultImageHeight];
                         [arrImageWidth addObject:resultImageWidth];
                     }else if ([posttype isEqualToString:@"invite_friend"]) {
                         NSString *Photourl = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"image"]];
                         [arrImage addObject:Photourl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if([posttype isEqualToString:@"country_promotion"]){
                         NSString *Photourl = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"image"]];
                         [arrImage addObject:Photourl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                         TrackerUrl = [[NSString alloc]initWithFormat:@"%@",[GetItemsData valueForKey:@"tracker_url"]];
                     }else if ([posttype isEqualToString:@"collect_suggestion"]) {
                         NSDictionary *CollectionPhotoData = [GetItemsData valueForKey:@"collection_posts"];
                         
                         NSDictionary *PhotoData = [CollectionPhotoData valueForKey:@"posts"];
                         NSMutableArray *FullUrlArray = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in PhotoData) {
                             NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict_ in dict) {
                                 NSArray *TempPhotoData = [dict_ valueForKey:@"photos"];
                                 for (NSDictionary * dict_ in TempPhotoData) {
                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];

                                     [UrlArray addObject:url];
                                 }
                             }
                             NSString *resultImageUrl = [UrlArray componentsJoinedByString:@"^^^"];
                             [FullUrlArray addObject:resultImageUrl];
                         }
                         
                         NSString *resultImageUrl = [FullUrlArray componentsJoinedByString:@","];
                         [arrImage addObject:resultImageUrl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"following_collection"]) {
                         NSDictionary *CollectionPhotoData = [GetItemsData valueForKey:@"new_collection_posts"];
                         
                         NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                         NSArray *TempPhotoData = [CollectionPhotoData valueForKey:@"photos"];
                            for (NSDictionary * dict_ in TempPhotoData) {
                                NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                                NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                                     
                                [UrlArray addObject:url];
                            }

                         NSString *resultImageUrl = [UrlArray componentsJoinedByString:@","];
                         [arrImage addObject:resultImageUrl];
                         [arrImageHeight addObject:@""];
                         [arrImageWidth addObject:@""];
                     }else if ([posttype isEqualToString:@"abroad_quality_post"]) {
                         NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                         NSMutableArray *ImageWidthArray = [[NSMutableArray alloc]init];
                         NSMutableArray *ImageHeightArray = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in PhotoData) {

                             for (NSDictionary * dict_ in dict) {
                                 NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                                 NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                                 [UrlArray addObject:url];
                                 
                                 NSDictionary *ImageResolutionData = [UserInfoData valueForKey:@"resolution"];
                                 NSString *GetImageWidth = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"w"]];
                                 NSString *GetImageHeight = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"h"]];
                                 [ImageWidthArray addObject:GetImageWidth];
                                 [ImageHeightArray addObject:GetImageHeight];
                                 
                                 break;

                             }
                             

                         }
                         NSString *resultImageUrl = [UrlArray componentsJoinedByString:@","];
                         NSString *resultImageHeight = [ImageHeightArray componentsJoinedByString:@","];
                         NSString *resultImageWidth = [ImageWidthArray componentsJoinedByString:@","];
                         [arrImage addObject:resultImageUrl];
                         [arrImageHeight addObject:resultImageHeight];
                         [arrImageWidth addObject:resultImageWidth];
                     }else if([posttype isEqualToString:@"following_post"]){
                             for (NSDictionary * dict_ in PhotoData) {
                                 NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                                 NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                                 [arrImage addObject:url];
                                 
                                 NSDictionary *ImageResolutionData = [UserInfoData valueForKey:@"resolution"];
                                 NSString *GetImageWidth = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"w"]];
                                 NSString *GetImageHeight = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"h"]];
                                 
                                 [arrImageHeight addObject:GetImageHeight];
                                 [arrImageWidth addObject:GetImageWidth];
                                 
                                 break;
                         }

                     }else if([posttype isEqualToString:@"local_quality_post"]){
                         for (NSDictionary * dict_ in PhotoData) {
                             NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                             [arrImage addObject:url];
                             
                             NSDictionary *ImageResolutionData = [UserInfoData valueForKey:@"resolution"];
                             NSString *GetImageWidth = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"w"]];
                             NSString *GetImageHeight = [[NSString alloc]initWithFormat:@"%@",[ImageResolutionData valueForKey:@"h"]];
                             
                             [arrImageHeight addObject:GetImageHeight];
                             [arrImageWidth addObject:GetImageWidth];
                             
                             break;
                         }
                         
                     }
                    // NSLog(@"arrImage is %@",arrImage);
                     
                 //    NSLog(@"--------arrImage,arrImageHeight,arrImageWidth-----------");
                     
                     NSDictionary *locationData = [GetItemsData valueForKey:@"location"];
                     NSString *formatted_address;
                     NSString *SearchDisplayName;
                     if ([locationData count] == 0) {
                         formatted_address = @"";
                         SearchDisplayName = @"";
                     }else{
                         
                         
                         if ([posttype isEqualToString:@"follow_suggestion_featured"] || [posttype isEqualToString:@"follow_suggestion_friend"] || [posttype isEqualToString:@"announcement"] || [posttype isEqualToString:@"announcement_welcome"] || [posttype isEqualToString:@"announcement_campaign"] || [posttype isEqualToString:@"invite_friend"]) {
                             formatted_address = @"";
                             SearchDisplayName = @"";
                         }else if ([posttype isEqualToString:@"abroad_quality_post"] || [posttype isEqualToString:@"deal"]){
                             NSMutableArray *arrDistanceTemp = [[NSMutableArray alloc]init];
                             NSMutableArray *arrDisplayCountryNameTemp = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict in locationData) {
                                 NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"distance"]];
                                 [arrDistanceTemp addObject:formatted_address];
                                 NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"search_display_name"]];
                                 [arrDisplayCountryNameTemp addObject:SearchDisplayName];
                             }
                             
                             formatted_address = [arrDistanceTemp componentsJoinedByString:@","];
                             SearchDisplayName = [arrDisplayCountryNameTemp componentsJoinedByString:@","];
                         }else{
                             formatted_address = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"distance"]];
                             SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"search_display_name"]];

                         }
                     }
                     [arrDistance addObject:formatted_address];
                     [arrDisplayCountryName addObject:SearchDisplayName];
                     
                     
                  //   NSLog(@"--------arrDistance,arrDisplayCountryName-----------");
                     
                     NSDictionary *UserInfoData = [GetItemsData valueForKey:@"user_info"];
                   //  NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                     NSString *username = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"username"]];
                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"profile_photo"]];
                     NSString *userid = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"uid"]];
                     //NSLog(@"print all username is %@",username);
                     if ([posttype isEqualToString:@"announcement"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"announcement_welcome"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"announcement_campaign"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_friend"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"deal"]) {
                         NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserIDTemp = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in UserInfoData) {
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [arrUserNameTemp addObject:username];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [arrUserImageTemp addObject:url];
                             NSString *userid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                             [arrUserIDTemp addObject:userid];
                         }
                         username = [arrUserNameTemp componentsJoinedByString:@","];
                         url = [arrUserImageTemp componentsJoinedByString:@","];
                         userid = [arrUserIDTemp componentsJoinedByString:@","];
                     }else if ([posttype isEqualToString:@"invite_friend"]) {
                         username = @"";
                         url = @"";
                         userid = @"";
                     }else if ([posttype isEqualToString:@"country_promotion"]) {
                         username = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"username"]];
                         url = @"";
                         userid = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"uid"]];
                     }else if ([posttype isEqualToString:@"collect_suggestion"]) {
                         NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserIDTemp = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in UserInfoData) {
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [arrUserNameTemp addObject:username];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [arrUserImageTemp addObject:url];
                             NSString *userid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                             [arrUserIDTemp addObject:userid];
                         }
                         username = [arrUserNameTemp componentsJoinedByString:@","];
                         url = [arrUserImageTemp componentsJoinedByString:@","];
                         userid = [arrUserIDTemp componentsJoinedByString:@","];
                     }else if ([posttype isEqualToString:@"following_collection"]) {
                         
                         username = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"username"]];
                         url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"profile_photo"]];
                         userid = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"uid"]];
                     }else if ([posttype isEqualToString:@"abroad_quality_post"]) {
                         NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserIDTemp = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in UserInfoData) {
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [arrUserNameTemp addObject:username];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [arrUserImageTemp addObject:url];
                             NSString *userid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                             [arrUserIDTemp addObject:userid];
                         }
                         username = [arrUserNameTemp componentsJoinedByString:@","];
                         url = [arrUserImageTemp componentsJoinedByString:@","];
                         userid = [arrUserIDTemp componentsJoinedByString:@","];
                     }else{

                     }
                     
                     
                    [arrUserName addObject:username];
                    [arrUserImage addObject:url];
                    [arrUserID addObject:userid];
                   // NSLog(@"--------arrUserName,arrUserImage-----------");
                     
                     if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
                         NSMutableArray *User_LocationArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_IDArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_NameArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_ProfileImageArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_FollowArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_UserNameArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_UserNameArrayTempPostsImg = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"location"]];
                             [User_LocationArrayTemp addObject:location];
                             NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                             [User_IDArrayTemp addObject:uid];
                             NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                             [User_NameArrayTemp addObject:name];
                             NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [User_ProfileImageArrayTemp addObject:profile_photo];
                             NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"following"]];
                             [User_FollowArrayTemp addObject:followed];
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [User_UserNameArrayTemp addObject:username];
                             
//                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
//                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
//                             
//                             for (NSDictionary * dict in PhotoData) {
//                                  NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
//                                 for (NSDictionary * dict_ in dict) {
//                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
//                                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
//                                     [UrlArray addObject:url];
//                                 }
//                                 
//                                 NSString *result2 = [UrlArray componentsJoinedByString:@","];
//                                 [User_UserNameArrayTempPostsImg addObject:result2];
//                             }
                             
                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                             NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict in PhotoData) {
                                 NSString *url;
                                 for (NSDictionary * dict_ in dict) {
                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                                     
                                     url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                                     
                                     break;
                                 }
                                 [UrlArray addObject:url];
                                 
                             }
                             NSString *result2 = [UrlArray componentsJoinedByString:@","];
                             [User_UserNameArrayTempPostsImg addObject:result2];

                         }
                         NSString *result2 = [User_UserNameArrayTempPostsImg componentsJoinedByString:@"$"];
                         [User_PhotoArray addObject:result2];
                         NSString *TempLocation = [User_LocationArrayTemp componentsJoinedByString:@"$"];
                         [User_LocationArray addObject:TempLocation];
                         NSString *TempID = [User_IDArrayTemp componentsJoinedByString:@"$"];
                         [User_IDArray addObject:TempID];
                         NSString *TempName = [User_NameArrayTemp componentsJoinedByString:@"$"];
                         [User_NameArray addObject:TempName];
                         NSString *TempProfileImage = [User_ProfileImageArrayTemp componentsJoinedByString:@"$"];
                         [User_ProfileImageArray addObject:TempProfileImage];
                         NSString *TempFollow = [User_FollowArrayTemp componentsJoinedByString:@"$"];
                         [User_FollowArray addObject:TempFollow];
                         NSString *TempUsername = [User_UserNameArrayTemp componentsJoinedByString:@"$"];
                         [User_UserNameArray addObject:TempUsername];
                         
                     }else if([posttype isEqualToString:@"follow_suggestion_friend"]){
                         NSMutableArray *User_LocationArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_IDArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_NameArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_ProfileImageArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_FollowArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_UserNameArrayTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *User_UserNameArrayTempPostsImg = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in GetItemsData) {
                             NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"location"]];
                             [User_LocationArrayTemp addObject:location];
                             NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                             [User_IDArrayTemp addObject:uid];
                             NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                             [User_NameArrayTemp addObject:name];
                             NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [User_ProfileImageArrayTemp addObject:profile_photo];
                             NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"following"]];
                             [User_FollowArrayTemp addObject:followed];
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [User_UserNameArrayTemp addObject:username];
                             
//                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
//                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
//                             
//                             for (NSDictionary * dict in PhotoData) {
//                                 NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
//                                 for (NSDictionary * dict_ in dict) {
//                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
//                                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
//                                     [UrlArray addObject:url];
//                                 }
//                                 
//                                 NSString *result2 = [UrlArray componentsJoinedByString:@","];
//                                 [User_UserNameArrayTempPostsImg addObject:result2];
//                             }
                             
                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                             NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                             for (NSDictionary * dict in PhotoData) {
                                 NSString *url;
                                 for (NSDictionary * dict_ in dict) {
                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                                     
                                     url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                                     
                                     break;
                                 }
                                 [UrlArray addObject:url];
                                 
                             }
                             NSString *result2 = [UrlArray componentsJoinedByString:@","];
                             [User_UserNameArrayTempPostsImg addObject:result2];
                             
                         }
                         NSString *result2 = [User_UserNameArrayTempPostsImg componentsJoinedByString:@"$"];
                         [User_PhotoArray addObject:result2];
                         NSString *TempLocation = [User_LocationArrayTemp componentsJoinedByString:@"$"];
                         [User_LocationArray addObject:TempLocation];
                         NSString *TempID = [User_IDArrayTemp componentsJoinedByString:@"$"];
                         [User_IDArray addObject:TempID];
                         NSString *TempName = [User_NameArrayTemp componentsJoinedByString:@"$"];
                         [User_NameArray addObject:TempName];
                         NSString *TempProfileImage = [User_ProfileImageArrayTemp componentsJoinedByString:@"$"];
                         [User_ProfileImageArray addObject:TempProfileImage];
                         NSString *TempFollow = [User_FollowArrayTemp componentsJoinedByString:@"$"];
                         [User_FollowArray addObject:TempFollow];
                         NSString *TempUsername = [User_UserNameArrayTemp componentsJoinedByString:@"$"];
                         [User_UserNameArray addObject:TempUsername];
                     }else{
                         [User_IDArray addObject:@""];
                         [User_LocationArray addObject:@""];
                         [User_NameArray addObject:@""];
                         [User_ProfileImageArray addObject:@""];
                         [User_FollowArray addObject:@""];
                         [User_UserNameArray addObject:@""];
                         [User_PhotoArray addObject:@""];
                     }
                     
                
                
               // NSLog(@"--------User_IDArray,User_NameArray-----------");
                     

                     
                     
//                     if ([posttype isEqualToString:@"announcement"]) {
//                     }else if ([posttype isEqualToString:@"announcement_welcome"]) {
//                     }else if ([posttype isEqualToString:@"announcement_campaign"]) {
//                     }else if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
//                     }else if ([posttype isEqualToString:@"follow_suggestion_friend"]) {
//                     }else if ([posttype isEqualToString:@"deal"]) {
//                     }else if ([posttype isEqualToString:@"invite_friend"]) {
//                     }else if ([posttype isEqualToString:@"abroad_quality_post"]) {
//                     }else{
//                         
//                     }
            }
                
                
//                NSLog(@"arrType is %@",arrType);
//                NSLog(@"arrAddress is %@",arrAddress);
//                NSLog(@"arrPostID is %@",arrPostID);
//                NSLog(@"arrUserID is %@",arrUserID);

             //   DataCount = DataTotal;
            //    DataTotal = [arrType count];
                
               // NSLog(@"User_PhotoArray is %@",User_PhotoArray);
               // NSLog(@"User_PhotoArray is %lu",(unsigned long)[User_PhotoArray count]);
    
                if (CheckFirstTimeLoad == 0) {
                    [self StartInit1stView];
                    CheckFirstTimeLoad = 1;
                }else{
                    [self InitContent];
                }
                
                OnLoad = NO;
            }else{
                
                
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
              //  [ShowAlert show];
                
            
            }
        
        }
        
    }else if(connection == theConnection_likes){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Send post like return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            //NSDictionary *GetAllData = [res valueForKey:@"data"];
           // NSLog(@"GetAllData is %@",GetAllData);

        }
    }else if(connection == theConnection_QuickCollect){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Quick Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];
        }
    }else if(connection == theConnection_TrackPromotedUserViews){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"theConnection_TrackPromotedUserViews return get data to server ===== %@",GetData);
    }else if(connection == theConnection_FollowCollect){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Follow Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            if ([GetCollectionFollowing isEqualToString:@"0"]) {
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success follow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"1";
            }else{
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success unfollow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"0";
            }
            
            
        }
    }
}
-(void)ReinitData{
    //init again
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    // Your Code
    [refreshControl endRefreshing];
    
    [UIView animateWithDuration:5.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         ShowUpdateText.frame = CGRectMake(0, 0, screenWidth, 20);
                         ShowUpdateText.text = @"Updating new data...";
                     }
                     completion:^(BOOL finished) {
                         ShowUpdateText.hidden = YES;
                     }];
    
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
    
    heightcheck = 0;
    //[ShowActivity startAnimating];
    [arrDisplayCountryName removeAllObjects];
    [arrDistance removeAllObjects];
    [arrMessage removeAllObjects];
    [arrTitle removeAllObjects];
    [arrType removeAllObjects];
    [arrImage removeAllObjects];
    [arrUserImage removeAllObjects];
    [arrUserName removeAllObjects];
    [arrImageWidth removeAllObjects];
    [arrImageHeight removeAllObjects];
    [arrlike removeAllObjects];
    [arrAddress removeAllObjects];
    [arrPostID removeAllObjects];
    [arrCollect removeAllObjects];


}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == LocalScroll) {
        
    }else if(scrollView == MainScroll){
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        float endScrolling1 = scrollView.contentOffset.x + scrollView.frame.size.width;
        NSLog(@"endScrolling1 %f ",endScrolling1);
        if (endScrolling >= scrollView.contentSize.height)
        {
            if ([GetNextPaging length] == 0) {
                
            }else{
                if (OnLoad == YES) {
                    
                }else{
                    if (LocalScroll.hidden == YES) {
                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                        [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 150)];
                        UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, heightcheck + 40, 30, 30)];
                        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                        [MainScroll addSubview:activityindicator1];
                        [activityindicator1 startAnimating];
                        [self GetFeedDataFromServer];
                        //[activityindicator1 stopAnimating];
                        
                    }
                    
                }
                
                
            }
        }
    }

    
    
}

-(IBAction)ClickToDetailButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    if (LocalScroll.hidden == YES) {
        NSString *GetLikeClick = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:getbuttonIDN]];
        NSString *GetCollectionClick = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:getbuttonIDN]];
        
        NSLog(@"GetLikeClick is %@",GetLikeClick);
        NSLog(@"GetCollectionClick is %@",GetCollectionClick);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:GetLikeClick forKey:@"PostToDetail_like"];
        [defaults setObject:GetCollectionClick forKey:@"PostToDetail_Collect"];
        [defaults setInteger:getbuttonIDN + 6000 forKey:@"PostToDetail_IDN"];
        [defaults synchronize];
        
        FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc GetPostID:[arrPostID objectAtIndex:getbuttonIDN]];
    }else{
        FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc GetPostID:[arrLocalPostID objectAtIndex:getbuttonIDN]];
    }
    

    
}
-(IBAction)NearbyButton:(id)sender{
    if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {

        
        EnbleLocationViewController *EnbleLocationView = [[EnbleLocationViewController alloc]init];
        [self presentViewController:EnbleLocationView animated:YES completion:nil];
    }else{
        NearbyViewController *NearbyView = [[NearbyViewController alloc]init];
        [self.navigationController pushViewController:NearbyView animated:YES onCompletion:^{
            [NearbyView Getlat:latPoint GetLong:lonPoint];

        }];
    }
}
-(IBAction)OpenUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *CheckUsername = [[NSString alloc]initWithFormat:@"%@",[arrUserName objectAtIndex:getbuttonIDN]];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:CheckUsername]) {
    }else{
//        NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//        [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//        [NewUserProfileV2View GetUserName:[arrUserName objectAtIndex:getbuttonIDN]];
        _profileViewController = nil;
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrUserID objectAtIndex:getbuttonIDN]];
        [self.navigationController pushViewController:self.profileViewController animated:YES];
    
    }
    

}
-(IBAction)LikeButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);

    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    getbuttonIDN -= 6000;
    
    CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:getbuttonIDN]];
    SendLikePostID = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:getbuttonIDN]];
    if ([CheckLike isEqualToString:@"0"]) {
        NSLog(@"send like to server");
        [self SendPostLike];
        [arrlike replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
    }else{
        NSLog(@"send unlike to server");
        [self GetUnLikeData];
        [arrlike replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
    }

//    if (buttonWithTag1.selected) {
//        NSLog(@"send like to server");
//    }else{
//        NSLog(@"send unlike to server");
//        
//    }
}
-(IBAction)InviteFriendsButton:(id)sender{
    InviteFrenViewController *InviteFrenView = [[InviteFrenViewController alloc]init];
    [self presentViewController:InviteFrenView animated:YES completion:nil];
}
-(void)GetUnLikeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like?token=%@",DataUrl.UserWallpaper_Url,SendLikePostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
    
}
-(void)SendPostLike{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,SendLikePostID];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"getbuttonIDN is %ld",(long)getbuttonIDN);
    NSInteger ButtonIDN = getbuttonIDN;
    ButtonIDN -= 5000;
    NSLog(@"ButtonIDN is %ld",(long)ButtonIDN);
   // NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Quick CollectButtonOnClick");
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:ButtonIDN]];
    CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:ButtonIDN]];
    
    if ([CheckCollect isEqualToString:@"0"]) {
        [arrCollect replaceObjectAtIndex:ButtonIDN withObject:@"1"];
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        
        [self SendQuickCollect];
    }else{
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
       // [self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:[arrPostID objectAtIndex:ButtonIDN] GetImageData:[arrImage objectAtIndex:ButtonIDN]];
    }
    
    
    
    
    
    
}
-(void)SendQuickCollect{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/0/collect",DataUrl.UserWallpaper_Url,GetUseruid];
    NSLog(@"Send Quick Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSString *dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@",GetExpertToken,GetPostID];
    
    NSData *postBodyData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)AddCollectButtonOnClick:(id)sender{
    NSLog(@"Add Collection Button On Click");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
    [self presentViewController:AddCollectionDataView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
    [AddCollectionDataView GetPostID:[arrPostID objectAtIndex:getbuttonIDN] GetImageData:[arrImage objectAtIndex:getbuttonIDN]];
}

//'post',
//'url',
//'user'
-(IBAction)AnnouncementButtonOnClick:(id)sender{
     NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    NSString *GetAnnType = [[NSString alloc]initWithFormat:@"%@",[arrType_Announcement objectAtIndex:getbuttonIDN]];
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrID_Announcement objectAtIndex:getbuttonIDN]];
    if ([GetAnnType isEqualToString:@"post"]) {
        
        FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc GetPostID:GetID];
    }else if([GetAnnType isEqualToString:@"url"]){
        OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
        [self presentViewController:OpenWebView animated:YES completion:nil];
        [OpenWebView GetFullUrlString:GetID];
    }else if([GetAnnType isEqualToString:@"user"]){
//        NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//        [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//        [NewUserProfileV2View GetUid:GetID];
        _profileViewController = nil;
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetID];
        [self.navigationController pushViewController:self.profileViewController animated:YES];
    
    }else{
        AnnounceViewController *AnnounceView = [[AnnounceViewController alloc]init];
        [self.navigationController pushViewController:AnnounceView animated:YES];
        [AnnounceView GetDisplayImage:[arrImage objectAtIndex:getbuttonIDN] GetContent:[arrTitle objectAtIndex:getbuttonIDN]];
    }
    
    
}
-(IBAction)AboadOpenPostsOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrAboadID objectAtIndex:getbuttonIDN]];
    NSLog(@"AboadOpenPostsOnClick GetID is %@",GetID);
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:GetID];
}
-(IBAction)AboadUserOpenProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrAboadUserID objectAtIndex:getbuttonIDN]];
    NSLog(@"AboadUserOpenProfileOnClick GetID is %@",GetID);
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetID];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
-(IBAction)DealOpenPostsOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrDealID objectAtIndex:getbuttonIDN]];
    NSLog(@"DealOpenPostsOnClick GetID is %@",GetID);
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:GetID];
}
-(IBAction)DealUserOpenProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrDealUserID objectAtIndex:getbuttonIDN]];
    NSLog(@"DealUserOpenProfileOnClick GetID is %@",GetID);
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetID];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
-(IBAction)FeaturedOpenUserProfile:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
//    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrfeaturedUserName objectAtIndex:getbuttonIDN]];
//    NSLog(@"FeaturedOpenUserProfile Getname is %@",Getname);
//    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:Getname];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrfeaturedUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)FriendsOpenUserProfile:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrFriendUserName objectAtIndex:getbuttonIDN]];
    NSLog(@"FriendsOpenUserProfile Getname is %@",Getname);
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:Getname];
    
    SLog(@"user ID : %@",arrFriendUserID);
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:arrFriendUserID[getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)ShareButtonOnClick:(id)sender{
    NSLog(@"ShareButtonOnClick");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
//    ShareViewController *ShareView = [[ShareViewController alloc]init];
////    [self presentViewController:ShareView animated:YES completion:nil];
////    //[self.view.window.rootViewController presentViewController:ShareView animated:YES completion:nil];
////    [ShareView GetPostID:[arrPostID objectAtIndex:getbuttonIDN] GetMessage:[arrMessage objectAtIndex:getbuttonIDN] GetTitle:[arrTitle objectAtIndex:getbuttonIDN] GetImageData:[arrImage objectAtIndex:getbuttonIDN]];
//    
//    
//    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:ShareView];
//    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
//    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
//    [self presentViewController:formSheetController animated:YES completion:nil];
//    [ShareView GetPostID:[arrPostID objectAtIndex:getbuttonIDN] GetMessage:[arrMessage objectAtIndex:getbuttonIDN] GetTitle:[arrTitle objectAtIndex:getbuttonIDN] GetImageData:[arrImage objectAtIndex:getbuttonIDN]];
    
    _shareV2ViewController = nil;
    UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
    [naviVC setNavigationBarHidden:YES animated:NO];
    [self.shareV2ViewController share:@"" title:[arrTitle objectAtIndex:getbuttonIDN] imagURL:[arrImage objectAtIndex:getbuttonIDN] shareType:ShareTypeFacebookPost shareID:[arrPostID objectAtIndex:getbuttonIDN]];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    [self presentViewController:formSheetController animated:YES completion:nil];
}

-(IBAction)CommentButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    CommentViewController *CommentView = [[CommentViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:CommentView animated:YES completion:nil];
    [CommentView GetRealPostIDAndAllComment:[arrPostID objectAtIndex:getbuttonIDN]];
    [CommentView GetWhatView:@"Comment"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetBackCheckAPI = [defaults objectForKey:@"CheckAPI"];
            //NSString *GetBackAPIVersion = [defaults objectForKey:@"APIVersionSet"];
            
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSLog(@"language is %@",language);
            // zh-Hans - Simplified Chinese
            // zh-Hant - Traditional Chinese
            // en - English
            // th - Thai
            // id - Bahasa Indonesia
            NSInteger CheckSystemLanguage;
            if ([language isEqualToString:@"en"]) {
                CheckSystemLanguage = 0;
            }else if([language isEqualToString:@"zh-Hans"]){
                CheckSystemLanguage = 1;
            }else if([language isEqualToString:@"zh-Hant"]){
                CheckSystemLanguage = 2;
            }else if([language isEqualToString:@"id"]){
                CheckSystemLanguage = 3;
            }else if([language isEqualToString:@"th"]){
                CheckSystemLanguage = 4;
            }else if([language isEqualToString:@"tl-PH"]){
                CheckSystemLanguage = 5;
            }else{
                CheckSystemLanguage = 0;
            }
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
            [languageManager setLanguageWithLocale:localeForRow];
            
            //save back
            [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
            //[defaults setObject:GetBackAPIVersion forKey:@"APIVersionSet"];
            [defaults synchronize];
            
            
            LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }else{
            //reset clicked
        }
    }
    
}
-(IBAction)OpenPromotionButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"Get TrackerUrl is %@",TrackerUrl);
    NSLog(@"Get username is %@",[arrUserName objectAtIndex:getbuttonIDN]);
    
    [self SendUserTrackerToServer];
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:[arrUserName objectAtIndex:getbuttonIDN]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(void)SendUserTrackerToServer{
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:TrackerUrl];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_TrackPromotedUserViews = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_TrackPromotedUserViews start];
    
    
    if( theConnection_TrackPromotedUserViews ){
        webData = [NSMutableData data];
    }
}

//Collection 2.0
-(IBAction)OpenCollectionButtonOnClick:(id)sender{

    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    CollectionViewController *OpenCollectionView = [[CollectionViewController alloc]init];
    [self.navigationController pushViewController:OpenCollectionView animated:YES];
    [OpenCollectionView GetCollectionID:[arrCollectionID objectAtIndex:getbuttonIDN] GetPermision:@"User"];
}
-(IBAction)CollectionUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
//    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrCollectionName objectAtIndex:getbuttonIDN]];
//    NSLog(@"CollectionUserProfileOnClick Getname is %@",Getname);
//    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:Getname];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrCollectionUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)SeeAllButtonOnClick:(id)sender{
    NSLog(@"Suggested Collection SeeAllButtonOnClick");
    
    _collectionListingViewController = nil;
    
    ProfileModel* model = [ProfileModel new];
    model.uid = [Utils getUserID];
    [self.collectionListingViewController setType:ProfileViewTypeOthers ProfileModel:model NumberOfPage:1 collectionType:CollectionListingTypeSuggestion];
    [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
//    SuggestedCollectionsViewController *SuggestedCollectionsView = [[SuggestedCollectionsViewController alloc]init];
//    [self.navigationController pushViewController:SuggestedCollectionsView animated:YES];
}

-(IBAction)CollectionFollowingButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
//    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
//    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    NSInteger ButtonIDN = getbuttonIDN;
    ButtonIDN -= 8000;
    
    NSLog(@"Get Collection User ID == %@",[arrCollectionUserID objectAtIndex:ButtonIDN]);
    NSLog(@"Get Collection Following == %@",[arrCollectionFollowing objectAtIndex:ButtonIDN]);
    GetCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrCollectionFollowing objectAtIndex:ButtonIDN]];
    GetCollectUserID = [[NSString alloc]initWithFormat:@"%@",[arrCollectionUserID objectAtIndex:ButtonIDN]];
    GetCollectID = [[NSString alloc]initWithFormat:@"%@",[arrCollectionID objectAtIndex:ButtonIDN]];
    
    if ([GetCollectionFollowing isEqualToString:@"0"]) {
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        [self FollowCollection];
        [arrCollectionFollowing replaceObjectAtIndex:ButtonIDN withObject:@"1"];
    }else{

        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
                buttonWithTag1.selected = !buttonWithTag1.selected;
                [self DeleteFollowCollection];
                [arrCollectionFollowing replaceObjectAtIndex:ButtonIDN withObject:@"0"];
                
                
            }
        }];
    }
}
-(void)FollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID];
    NSLog(@"Send Follow Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)DeleteFollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID,GetExpertToken];
    NSLog(@"Send Delete Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
-(IBAction)FollowingCollectionButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"FollowingCollectionButtonOnClick");
    NSString *GetFollowingCollectionID = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:getbuttonIDN]];
    NSLog(@"GetFollowingCollectionID is %@",GetFollowingCollectionID);
    
    _followingCollectionPostsViewController = nil;
    [self.followingCollectionPostsViewController initData:GetFollowingCollectionID];
    [self.navigationController pushViewController:self.followingCollectionPostsViewController animated:YES];
}
-(IBAction)FollowCollectionShareButtonOnClick:(id)sender{
   NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
//    ShareViewController *ShareView = [[ShareViewController alloc]init];
//    
//    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:ShareView];
//    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
//    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
//    [self presentViewController:formSheetController animated:YES completion:nil];
//    [ShareView GetCollectionID:[arrPostID objectAtIndex:getbuttonIDN] GetCollectionTitle:[arrTitle objectAtIndex:getbuttonIDN]];

    _shareV2ViewController = nil;
    UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
    [naviVC setNavigationBarHidden:YES animated:NO];
    [self.shareV2ViewController share:@"" title:[arrTitle objectAtIndex:getbuttonIDN] imagURL:@"" shareType:ShareTypeFacebookCollection shareID:[arrCollectionID objectAtIndex:getbuttonIDN]];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    [self presentViewController:formSheetController animated:YES completion:nil];
}

-(IBAction)FollowingCollectionUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    //    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrCollectionName objectAtIndex:getbuttonIDN]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
}
-(IBAction)DealSeeAllButtonOnClick:(id)sender{
    NSLog(@"Open all deal");
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrDealUserID objectAtIndex:0]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetID];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
@end

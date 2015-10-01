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
@interface FeedViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation FeedViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
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
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SearchButton.frame = CGRectMake(screenWidth - 40, 20, 40, 44);
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    //    ShowFeedText.text = CustomLocalisedString(@"MainTab_Feed",nil);
    //    [NearbyButton setTitle:CustomLocalisedString(@"NearBy",nil) forState:UIControlStateNormal];
    //    [FilterButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    
    heightcheck = 0;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
                                       0,
                                       refreshControl.bounds.size.width,
                                       refreshControl.bounds.size.height);
    // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
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
    


    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
        
        
        [self initData];
        [self initSelfView];
        
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
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
//    if ([CheckString isEqualToString:@"Done"]) {
//    }else{
//        [self GetFeedDataFromServer];
//    }
    
    [self initData];
    [self initSelfView];
}
-(void)initData
{


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {

        // put data here
        NSMutableArray *arrImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalImg"]];
        arrImage = [[NSMutableArray alloc]initWithArray:arrImageTemp];
        NSMutableArray *arrAddressTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrAddress"]];
        arrAddress = [[NSMutableArray alloc]initWithArray:arrAddressTemp];
        NSMutableArray *arrTitleTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrTitle"]];
        arrTitle = [[NSMutableArray alloc]initWithArray:arrTitleTemp];
        NSMutableArray *arrMessageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrMessage"]];
        arrMessage = [[NSMutableArray alloc]initWithArray:arrMessageTemp];
        NSMutableArray *arrTypeTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrType"]];
        arrType = [[NSMutableArray alloc]initWithArray:arrTypeTemp];
        NSMutableArray *arrDistanceTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDistance"]];
        arrDistance = [[NSMutableArray alloc]initWithArray:arrDistanceTemp];
        NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserName"]];
        arrUserName = [[NSMutableArray alloc]initWithArray:arrUserNameTemp];
        NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserImage"]];
        arrUserImage = [[NSMutableArray alloc]initWithArray:arrUserImageTemp];
        NSMutableArray *arrDisplayCountryNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDisplayCountryName"]];
        arrDisplayCountryName = [[NSMutableArray alloc]initWithArray:arrDisplayCountryNameTemp];
        NSMutableArray *arrPostIDTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrPostID"]];
        arrPostID = [[NSMutableArray alloc]initWithArray:arrPostIDTemp];
        NSMutableArray *arrImageHeightTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrImageHeight"]];
        arrImageHeight = [[NSMutableArray alloc]initWithArray:arrImageHeightTemp];
        NSMutableArray *arrImageWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrImageWidth"]];
        arrImageWidth = [[NSMutableArray alloc]initWithArray:arrImageWidthTemp];
        NSMutableArray *arrLikeWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrLike"]];
        arrlike = [[NSMutableArray alloc]initWithArray:arrLikeWidthTemp];
        NSMutableArray *arrCollectWidthTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrCollect"]];
        arrCollect = [[NSMutableArray alloc]initWithArray:arrCollectWidthTemp];
    }else{
        arrAddress = [[NSMutableArray alloc]init];
        arrTitle = [[NSMutableArray alloc]init];
        arrMessage = [[NSMutableArray alloc]init];
        arrType = [[NSMutableArray alloc]init];
        arrImage = [[NSMutableArray alloc]init];//https://unsplash.it/375/400/?random
        arrDistance = [[NSMutableArray alloc]init];
        arrUserName = [[NSMutableArray alloc]init];
        arrUserImage = [[NSMutableArray alloc]init];
        arrDisplayCountryName = [[NSMutableArray alloc]init];
        arrPostID = [[NSMutableArray alloc]init];
        arrImageWidth = [[NSMutableArray alloc]init];
        arrImageHeight = [[NSMutableArray alloc]init];
        arrlike = [[NSMutableArray alloc]init];
        arrCollect = [[NSMutableArray alloc]init];
    }

    User_LocationArray = [[NSMutableArray alloc]init];
    User_IDArray = [[NSMutableArray alloc]init];
    User_NameArray = [[NSMutableArray alloc]init];
    User_ProfileImageArray = [[NSMutableArray alloc]init];
    User_FollowArray = [[NSMutableArray alloc]init];
    User_UserNameArray = [[NSMutableArray alloc]init];
    User_PhotoArray = [[NSMutableArray alloc]init];
    
    
    arrType_Announcement = [[NSMutableArray alloc]init];
    arrID_Announcement = [[NSMutableArray alloc]init];
    
   // TotalPage = 1;
    //CurrentPage = 0;
    DataCount = 0;
    Offset = 1;
    CheckFirstTimeLoad = 0;
    OnLoad = NO;

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
        
        arrType_Announcement = [[NSMutableArray alloc]init];
        arrID_Announcement = [[NSMutableArray alloc]init];
        
        DataCount = 0;
        Offset = 1;
        CheckFirstTimeLoad = 0;
        OnLoad = NO;
        
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
                                           0,
                                           refreshControl.bounds.size.width,
                                           refreshControl.bounds.size.height);
        // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
        [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
        [MainScroll addSubview:refreshControl];
        
        GetNextPaging = @"";
        [self GetFeedDataFromServer];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"SelfDeletePost"];
        [defaults synchronize];
    }
    
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
    
    arrType_Announcement = [[NSMutableArray alloc]init];
    arrID_Announcement = [[NSMutableArray alloc]init];
    
    DataCount = 0;
    Offset = 1;
    CheckFirstTimeLoad = 0;
    OnLoad = NO;
    
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
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *TempBackground = [[UIButton alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, 120);
    TempBackground.backgroundColor = [UIColor grayColor];
    [LocalScroll addSubview:TempBackground];
    
    UIImageView *NearbyImg = [[UIImageView alloc]init];
    NearbyImg.image = [UIImage imageNamed:@"Nearbyimage.png"];
    NearbyImg.frame = CGRectMake(0, 0, screenWidth, 120);
    NearbyImg.contentMode = UIViewContentModeScaleAspectFill;
    NearbyImg.layer.masksToBounds = YES;
    [LocalScroll addSubview:NearbyImg];
    
    
    
    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake((screenWidth / 2) - 60, 41, 120, 37);
    [TempButton setTitle:@"Nearby" forState:UIControlStateNormal];
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
    
    for (NSInteger i = 0; i < [arrImage count]; i++) {
        
        NSString *GetType = [arrType objectAtIndex:i];
        
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
            stringPath  = [stringPath stringByAppendingPathComponent:[arrImage objectAtIndex:i]];
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
            ShowUserProfileImage.frame = CGRectMake(25, heightcheck + 10, 40, 40);
            // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=3;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *stringPath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
            stringPath1  = [stringPath1 stringByAppendingPathComponent:[arrUserImage objectAtIndex:i]];
            ShowUserProfileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath1]];
            [LocalScroll addSubview:ShowUserProfileImage];
            
            UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
            ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 10, 40, 40);
            [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
            ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
            ClicktoOpenUserProfileButton.tag = i;
            [ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [LocalScroll addSubview:ClicktoOpenUserProfileButton];
        
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(75, heightcheck + 10, 200, 40);
            ShowUserName.text = [arrUserName objectAtIndex:i];
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor whiteColor];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [LocalScroll addSubview:ShowUserName];
            
            NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
            
            if ([TempDistanceString isEqualToString:@"0"]) {
                
            }else{
                CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                int x_Nearby = [TempDistanceString intValue] / 1000;
                // NSLog(@"x_Nearby is %i",x_Nearby);
                
                UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                NSString *FullShowLocatinString;
                if (x_Nearby < 10) {
                    if (x_Nearby <= 1) {
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else{
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                    }
                    
                }else if(x_Nearby > 10 && x_Nearby < 30){
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                }else{
                    ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    
                }
                ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 12, 40, 36);
                [LocalScroll addSubview:ShowDistanceIcon];

                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 10, 100, 40);
                // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                ShowDistance.text = FullShowLocatinString;
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [LocalScroll addSubview:ShowDistance];
                
                
                
                
                
            }
            
            
            
            heightcheck += newImage.size.height + 20;
            TempCountWhiteHeight += newImage.size.height + 20;
            
            NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
            if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                
            }else{
                UILabel *ShowTitle = [[UILabel alloc]init];
                ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                ShowTitle.text = TempGetStirng;
                ShowTitle.backgroundColor = [UIColor clearColor];
                ShowTitle.numberOfLines = 2;
                ShowTitle.textAlignment = NSTextAlignmentLeft;
                ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
                [LocalScroll addSubview:ShowTitle];
                
                if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                {
                    ShowTitle.frame = CGRectMake(25, heightcheck + i, screenWidth - 50,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
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
            ShowAddress.text = [arrAddress objectAtIndex:i];
            ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [LocalScroll addSubview:ShowAddress];
            
            heightcheck += 30;
            TempCountWhiteHeight += 30;
            
            NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[arrMessage objectAtIndex:i]];
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
                
                [ShowMessage setAttributedText:string];
                
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
            
            
//            UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
//            ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//            ShowLikesIcon.frame = CGRectMake(40 , heightcheck + i + 20 ,23, 19);
//            //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
//            [LocalScroll addSubview:ShowLikesIcon];
            
            UIButton *LikeButton = [[UIButton alloc]init];
            LikeButton.frame = CGRectMake(25, heightcheck + 4, 37, 37);
            CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
            if ([CheckLike isEqualToString:@"0"]) {
                [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
            }else{
                [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
            }
            LikeButton.backgroundColor = [UIColor clearColor];
            LikeButton.tag = i;
            [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [LocalScroll addSubview:LikeButton];
            
            
            UIButton *CommentButton = [[UIButton alloc]init];
            CommentButton.frame = CGRectMake(75, heightcheck + 4 ,37, 37);
            [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
            CommentButton.backgroundColor = [UIColor clearColor];
            CommentButton.tag = i;
            [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [LocalScroll addSubview:CommentButton];
            
//            UIImageView *ShowShareIcon = [[UIImageView alloc]init];
//            ShowShareIcon.image = [UIImage imageNamed:@"share_icon.png"];
//            ShowShareIcon.frame = CGRectMake(160, heightcheck + i + 20 ,19, 19);
//            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
//            [LocalScroll addSubview:ShowShareIcon];
            
            UIButton *ShareButton = [[UIButton alloc]init];
            ShareButton.frame = CGRectMake(127, heightcheck + 4 ,37, 37);
            [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
            ShareButton.backgroundColor = [UIColor clearColor];
            ShareButton.tag = i;
            [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [LocalScroll addSubview:ShareButton];
            
            
            CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
            UIButton *QuickCollectButton = [[UIButton alloc]init];
            if ([CheckCollect isEqualToString:@"0"]) {
                [QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
                [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
            }else{
                [QuickCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
            }
           // [QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
            [QuickCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [QuickCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
            QuickCollectButton.backgroundColor = [UIColor clearColor];
            QuickCollectButton.frame = CGRectMake(screenWidth - 20 - 140, heightcheck -5, 140, 50);
            [QuickCollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            QuickCollectButton.tag = i;
            QuickCollectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [LocalScroll addSubview:QuickCollectButton];
            
            UIButton *CollectButton = [[UIButton alloc]init];
            [CollectButton setTitle:@"" forState:UIControlStateNormal];
            CollectButton.backgroundColor = [UIColor clearColor];
            CollectButton.frame = CGRectMake(screenWidth - 20 - 60, heightcheck - 5, 60, 37);
            [CollectButton addTarget:self action:@selector(AddCollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
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

}

-(void)StartInit1stView{
//    heightcheck = 0;
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
    MainScroll.hidden = NO;
    LocalScroll.hidden = YES;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *TempBackground = [[UIButton alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, 120);
    TempBackground.backgroundColor = [UIColor grayColor];
    [MainScroll addSubview:TempBackground];
    
    UIImageView *NearbyImg = [[UIImageView alloc]init];
    NearbyImg.image = [UIImage imageNamed:@"Nearbyimage.png"];
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
    [TempButton setTitle:@"Nearby" forState:UIControlStateNormal];
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


    
    for (NSInteger i = DataCount; i < [arrType count]; i++) {
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[arrType objectAtIndex:i]];
        
        NSArray *items = @[@"following_post", @"local_quality_post", @"abroad_quality_post", @"announcement", @"announcement_welcome", @"announcement_campaign", @"follow_suggestion_featured", @"follow_suggestion_friend", @"deal", @"invite_friend"];
        NSInteger item = [items indexOfObject:GetType];
        switch (item) {
            case 0:{
           //     NSLog(@"in following_post");
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
                ShowUserProfileImage.frame = CGRectMake(25, heightcheck + 10, 40, 40);
                // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=3;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
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
                ClicktoOpenUserProfileButton.frame = CGRectMake(20, heightcheck + 10, 40, 40);
                [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
                ClicktoOpenUserProfileButton.tag = i;
                [ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClicktoOpenUserProfileButton];
                
                
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(75, heightcheck + 10, 200, 40);
                ShowUserName.text = [arrUserName objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor whiteColor];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];
                
                NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
                
                if ([TempDistanceString isEqualToString:@"0"]) {
                    
                }else{
                    CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                    int x_Nearby = [TempDistanceString intValue] / 1000;
                    // NSLog(@"x_Nearby is %i",x_Nearby);
                    
                    UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                    NSString *FullShowLocatinString;
                    if (x_Nearby < 10) {
                        if (x_Nearby <= 1) {
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                        }else{
                            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }
                        
                    }else if(x_Nearby > 10 && x_Nearby < 30){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                    }else{
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                        
                    }
                    ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 12, 40, 36);
                    [MainScroll addSubview:ShowDistanceIcon];
                    
                    UILabel *ShowDistance = [[UILabel alloc]init];
                    ShowDistance.frame = CGRectMake(screenWidth - 165, heightcheck + 10, 100, 40);
                    ShowDistance.text = FullShowLocatinString;
                    ShowDistance.textColor = [UIColor whiteColor];
                    ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistance.textAlignment = NSTextAlignmentRight;
                    ShowDistance.backgroundColor = [UIColor clearColor];
                    [MainScroll addSubview:ShowDistance];
                }
                
                
                heightcheck += resultHeight + 20;
                TempCountWhiteHeight += resultHeight + 20;
                
                NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    ShowTitle.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    ShowTitle.text = TempGetStirng;
                    ShowTitle.backgroundColor = [UIColor clearColor];
                    ShowTitle.numberOfLines = 2;
                    ShowTitle.textAlignment = NSTextAlignmentLeft;
                    ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
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
                ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
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
                    
                    [ShowMessage setAttributedText:string];
                    
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
                LikeButton.frame = CGRectMake(25, heightcheck + 4, 37, 37);
                CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
                if ([CheckLike isEqualToString:@"0"]) {
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
                }else{
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
                }
                LikeButton.backgroundColor = [UIColor clearColor];
                LikeButton.tag = i;
                [LikeButton addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:LikeButton];
                
                
                UIButton *CommentButton = [[UIButton alloc]init];
                CommentButton.frame = CGRectMake(75, heightcheck + 4 ,37, 37);
                [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
                CommentButton.backgroundColor = [UIColor clearColor];
                CommentButton.tag = i;
                [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:CommentButton];
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(127, heightcheck + 4 ,37, 37);
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor clearColor];
                ShareButton.tag = i;
                [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ShareButton];
                
                CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
                UIButton *QuickCollectButton = [[UIButton alloc]init];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [QuickCollectButton setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
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
                QuickCollectButton.tag = i;
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
              //  NSLog(@"in local_quality_post");
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
                ShowUserProfileImageLocalQR.frame = CGRectMake(25, heightcheck + 10, 40, 40);
                // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImageLocalQR.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImageLocalQR.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImageLocalQR.layer.cornerRadius=20;
                ShowUserProfileImageLocalQR.layer.borderWidth=3;
                ShowUserProfileImageLocalQR.layer.masksToBounds = YES;
                ShowUserProfileImageLocalQR.layer.borderColor=[[UIColor whiteColor] CGColor];
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
                ClicktoOpenUserProfileButtonLocalQR.frame = CGRectMake(20, heightcheck + 10, 40, 40);
                [ClicktoOpenUserProfileButtonLocalQR setTitle:@"" forState:UIControlStateNormal];
                ClicktoOpenUserProfileButtonLocalQR.backgroundColor = [UIColor clearColor];
                ClicktoOpenUserProfileButtonLocalQR.tag = i;
                [ClicktoOpenUserProfileButtonLocalQR addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ClicktoOpenUserProfileButtonLocalQR];
                
                
                
                UILabel *ShowUserNameLocalQR = [[UILabel alloc]init];
                ShowUserNameLocalQR.frame = CGRectMake(75, heightcheck + 10, 200, 40);
                ShowUserNameLocalQR.text = [arrUserName objectAtIndex:i];
                ShowUserNameLocalQR.backgroundColor = [UIColor clearColor];
                ShowUserNameLocalQR.textColor = [UIColor whiteColor];
                ShowUserNameLocalQR.textAlignment = NSTextAlignmentLeft;
                ShowUserNameLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserNameLocalQR];
                
                NSString *TempDistanceStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
                
                if ([TempDistanceStringLocalQR isEqualToString:@"0"]) {
                    
                }else{
                    CGFloat strFloatLocalQR = (CGFloat)[TempDistanceStringLocalQR floatValue] / 1000;
                    int x_NearbyLocalQR = [TempDistanceStringLocalQR intValue] / 1000;
                    // NSLog(@"x_Nearby is %i",x_Nearby);
                    
                    UIImageView *ShowDistanceIcon = [[UIImageView alloc]init];
                    NSString *FullShowLocatinStringLocalQR;
                    if (x_NearbyLocalQR < 10) {
                        if (x_NearbyLocalQR <= 1) {
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance2Icon.png"];
                            FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"1km"];//within
                        }else{
                            FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%.fkm",strFloatLocalQR];
                            ShowDistanceIcon.image = [UIImage imageNamed:@"Distance1Icon.png"];
                        }
                        
                    }else if(x_NearbyLocalQR > 10 && x_NearbyLocalQR < 30){
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance3Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%.fkm",strFloatLocalQR];
                    }else{
                        ShowDistanceIcon.image = [UIImage imageNamed:@"Distance4Icon.png"];
                        FullShowLocatinStringLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                        
                    }
                    
                    ShowDistanceIcon.frame = CGRectMake(screenWidth - 60, heightcheck + 12, 40, 36);
                    [MainScroll addSubview:ShowDistanceIcon];
                    
                    UILabel *ShowDistanceLocalQR = [[UILabel alloc]init];
                    ShowDistanceLocalQR.frame = CGRectMake(screenWidth - 165, heightcheck + 10, 100, 40);
                    ShowDistanceLocalQR.text = FullShowLocatinStringLocalQR;
                    ShowDistanceLocalQR.textColor = [UIColor whiteColor];
                    ShowDistanceLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistanceLocalQR.textAlignment = NSTextAlignmentRight;
                    ShowDistanceLocalQR.backgroundColor = [UIColor clearColor];
                    [MainScroll addSubview:ShowDistanceLocalQR];
                }
                
                
                
                heightcheck += resultHeightLocalQR + 20;
                TempCountWhiteHeightLocalQR += resultHeightLocalQR + 20;
                
                NSString *TempGetStirngLocalQR = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
                if ([TempGetStirngLocalQR length] == 0 || [TempGetStirngLocalQR isEqualToString:@""] || [TempGetStirngLocalQR isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitleLocalQR = [[UILabel alloc]init];
                    ShowTitleLocalQR.frame = CGRectMake(25, heightcheck, screenWidth - 50, 40);
                    ShowTitleLocalQR.text = TempGetStirngLocalQR;
                    ShowTitleLocalQR.backgroundColor = [UIColor clearColor];
                    ShowTitleLocalQR.numberOfLines = 2;
                    ShowTitleLocalQR.textAlignment = NSTextAlignmentLeft;
                    ShowTitleLocalQR.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitleLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
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
                ShowAddressLocalQR.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
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
                    
                    [ShowMessageLocalQR setAttributedText:stringLocalQR];
                    
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
                LikeButtonLocalQR.frame = CGRectMake(25, heightcheck + 4, 37, 37);
                CheckLike = [[NSString alloc]initWithFormat:@"%@",[arrlike objectAtIndex:i]];
                if ([CheckLike isEqualToString:@"0"]) {
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateSelected];
                }else{
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                    [LikeButtonLocalQR setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateSelected];
                }
                LikeButtonLocalQR.backgroundColor = [UIColor clearColor];
                LikeButtonLocalQR.tag = i;
                [LikeButtonLocalQR addTarget:self action:@selector(LikeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:LikeButtonLocalQR];
                
                
//                UIImageView *ShowCommentIconLocalQR = [[UIImageView alloc]init];
//                ShowCommentIconLocalQR.image = [UIImage imageNamed:@"comment_icon.png"];
//                ShowCommentIconLocalQR.frame = CGRectMake(100, heightcheck + 20 ,23, 19);
//                //    ShowCommentIcon.backgroundColor = [UIColor redColor];
//                [MainScroll addSubview:ShowCommentIconLocalQR];
                UIButton *CommentButton = [[UIButton alloc]init];
                CommentButton.frame = CGRectMake(75, heightcheck + 4 ,37, 37);
                [CommentButton setImage:[UIImage imageNamed:@"CommentIcon.png"] forState:UIControlStateNormal];
                CommentButton.backgroundColor = [UIColor clearColor];
                CommentButton.tag = i;
                [CommentButton addTarget:self action:@selector(CommentButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:CommentButton];
                
                UIButton *ShareButton = [[UIButton alloc]init];
                ShareButton.frame = CGRectMake(127, heightcheck + 4 ,37, 37);
                [ShareButton setImage:[UIImage imageNamed:@"ShareToIcon.png"] forState:UIControlStateNormal];
                ShareButton.backgroundColor = [UIColor clearColor];
                ShareButton.tag = i;
                [ShareButton addTarget:self action:@selector(ShareButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:ShareButton];
                
                
                CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];;
                UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:@"CollectBtn.png"] forState:UIControlStateNormal];
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
                }else{
                    [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
                }
                [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
                QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
                QuickCollectButtonLocalQR.frame = CGRectMake(screenWidth - 20 - 140, heightcheck - 5, 140, 50);
                [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                QuickCollectButtonLocalQR.tag = i;
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
                Line01.frame = CGRectMake(0, heightcheck, screenWidth, 1);
                [Line01 setTitle:@"" forState:UIControlStateNormal];
                Line01.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
                [MainScroll addSubview:Line01];
                
                UILabel *ShowSuggestedLocalQR = [[UILabel alloc]init];
                ShowSuggestedLocalQR.frame = CGRectMake(20, heightcheck, screenWidth - 80, 50);
                ShowSuggestedLocalQR.text = @"Suggested local QR";
                ShowSuggestedLocalQR.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowSuggestedLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedLocalQR];
                
                heightcheck += 50;
                TempCountWhiteHeightLocalQR += 50;
                
                
                
                TempButtonLocalQR.frame = CGRectMake(10, TempHeightLocalQR, screenWidth - 20, TempCountWhiteHeightLocalQR);
                
                heightcheck += 10;
                
            }
                break;
            case 2:{
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
                NSArray *SplitArray_Title = [TempTitle componentsSeparatedByString:@","];
                
                NSString *TempAddress = [[NSString alloc]initWithFormat:@"%@",[arrAddress objectAtIndex:i]];
                NSArray *SplitArray_Address = [TempAddress componentsSeparatedByString:@","];
                
                NSString *TempId = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:i]];
                NSArray *SplitArray_Id = [TempId componentsSeparatedByString:@","];
                arrAboadID = [[NSMutableArray alloc]initWithArray:SplitArray_Id];
                
               // NSLog(@"in abroad_quality_post");
                SuggestedScrollview_Aboad = [[UIScrollView alloc]init];
                SuggestedScrollview_Aboad.delegate = self;
                SuggestedScrollview_Aboad.frame = CGRectMake(0, heightcheck, screenWidth, 420);
                SuggestedScrollview_Aboad.backgroundColor = [UIColor whiteColor];
                SuggestedScrollview_Aboad.pagingEnabled = YES;
                [SuggestedScrollview_Aboad setShowsHorizontalScrollIndicator:NO];
                [SuggestedScrollview_Aboad setShowsVerticalScrollIndicator:NO];
                SuggestedpageControl_Aboad.tag = 1000;
                [MainScroll addSubview:SuggestedScrollview_Aboad];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
                ShowSuggestedText.text = @"Suggested Abroad QR";
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[SplitArray_Title count]];
                
                ShowSuggestedCount_Aboad = [[UILabel alloc]init];
                ShowSuggestedCount_Aboad.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
                ShowSuggestedCount_Aboad.text = TempCount;
                ShowSuggestedCount_Aboad.backgroundColor = [UIColor clearColor];
                ShowSuggestedCount_Aboad.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedCount_Aboad.textAlignment = NSTextAlignmentRight;
                ShowSuggestedCount_Aboad.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedCount_Aboad];
                
                SuggestedpageControl_Aboad = [[UIPageControl alloc] init];
                SuggestedpageControl_Aboad.frame = CGRectMake(0,heightcheck + 390,screenWidth,30);
                SuggestedpageControl_Aboad.numberOfPages = [SplitArray_Title count];
                SuggestedpageControl_Aboad.currentPage = 0;
                SuggestedpageControl_Aboad.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
                SuggestedpageControl_Aboad.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
                [MainScroll addSubview:SuggestedpageControl_Aboad];
                



                for (int i = 0; i < [SplitArray_username count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * screenWidth, 50 , screenWidth - 20 ,320);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SuggestedScrollview_Aboad addSubview: TempButton];
                    
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(11 + i * screenWidth, 51 , screenWidth - 22 ,198);
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
                    
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(31 + i * screenWidth, 51 + 10, 40, 40);
                   // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=3;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
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
                    ShowUserName.frame = CGRectMake(81 + i * screenWidth, 51 + 10, 200, 40);
                    ShowUserName.text = usernameTemp;
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor whiteColor];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Aboad addSubview:ShowUserName];
                    
                    UILabel *ShowDistance = [[UILabel alloc]init];
                    ShowDistance.frame = CGRectMake(screenWidth - 125 + i * screenWidth, 51 + 10, 100, 40);
                    // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                    ShowDistance.text = Distance;
                    ShowDistance.textColor = [UIColor whiteColor];
                    ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistance.textAlignment = NSTextAlignmentRight;
                    ShowDistance.backgroundColor = [UIColor clearColor];
                    [SuggestedScrollview_Aboad addSubview:ShowDistance];
                    
                    
                    UIImageView *ShowPinLocalQR = [[UIImageView alloc]init];
                    ShowPinLocalQR.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                    ShowPinLocalQR.frame = CGRectMake(20 + i * screenWidth, 51 + 198 + 10, 18, 18);
                    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                    [SuggestedScrollview_Aboad addSubview:ShowPinLocalQR];
                    
                    UILabel *ShowAddressLocalQR = [[UILabel alloc]init];
                    ShowAddressLocalQR.frame = CGRectMake(40 + i * screenWidth, 51 + 198 + 10, screenWidth - 80, 20);
                    ShowAddressLocalQR.text = Address;
                    ShowAddressLocalQR.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Aboad addSubview:ShowAddressLocalQR];
                    
                    //  int TempCountWhiteHeight = 51 + 198 + 10;
                    
                    NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Title objectAtIndex:i]];
                    if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                        
                    }else{
                        UILabel *ShowTitle = [[UILabel alloc]init];
                        ShowTitle.frame = CGRectMake(25 + i * screenWidth, 51 + 198 + 10 + 30, screenWidth - 50, 40);
                        ShowTitle.text = TempGetStirng;
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
                    OpenPostsButton.frame = CGRectMake(10 + i * screenWidth, 50 , screenWidth - 20 ,320);
                    [OpenPostsButton addTarget:self action:@selector(AboadOpenPostsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenPostsButton.tag = i;
                    [SuggestedScrollview_Aboad addSubview:OpenPostsButton];
                    
                    
                    SuggestedScrollview_Aboad.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 300);
                }
                
                
                
                heightcheck += 430;

                
            }
                break;
            case 3:{
               // NSLog(@"in announcement");
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
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                ShowUserName.text = [arrTitle objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];
                
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
               // NSLog(@"in announcement_welcome");
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
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                ShowUserName.text = [arrTitle objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];
                
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
                //NSLog(@"in announcement_campaign");
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
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(20, heightcheck + 250, screenWidth - 40, 50);
                ShowUserName.text = [arrTitle objectAtIndex:i];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowUserName];
                
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
            //    NSLog(@"in follow_suggestion_featured");
                
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[User_IDArray objectAtIndex:i]];
                NSString *TempUserProfileImg = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
             //   NSString *TempUser_Name = [[NSString alloc]initWithFormat:@"%@",[User_NameArray objectAtIndex:i]];
           //     NSString *TempUserLocation = [[NSString alloc]initWithFormat:@"%@",[User_LocationArray objectAtIndex:i]];
              //  NSString *TempUserFollow = [[NSString alloc]initWithFormat:@"%@",[User_FollowArray objectAtIndex:i]];
                NSString *TempUseName = [[NSString alloc]initWithFormat:@"%@",[User_UserNameArray objectAtIndex:i]];
                NSString *TempUserPhoto = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
                
                NSArray *SplitArray_Id = [TempUserID componentsSeparatedByString:@"$"];
                NSArray *SplitArray_ProfileImg = [TempUserProfileImg componentsSeparatedByString:@"$"];
             //   NSArray *SplitArray_name = [TempUser_Name componentsSeparatedByString:@"$"];
              //  NSArray *SplitArray_Location = [TempUserLocation componentsSeparatedByString:@"$"];
              //  NSArray *SplitArray_Follow = [TempUserFollow componentsSeparatedByString:@"$"];
                NSArray *SplitArray_Username = [TempUseName componentsSeparatedByString:@"$"];
                NSArray *SplitArray_PostsImg = [TempUserPhoto componentsSeparatedByString:@"$"];
                arrfeaturedUserName = [[NSMutableArray alloc]initWithArray:SplitArray_Username];
                int TestWidth = screenWidth - 40;
                //    NSLog(@"TestWidth is %i",TestWidth);
                int FinalWidth = TestWidth / 4;
                //    NSLog(@"FinalWidth is %i",FinalWidth);
                int SpaceWidth = FinalWidth + 4;
                
                SUserScrollview_Featured = [[UIScrollView alloc]init];
                SUserScrollview_Featured.delegate = self;
                SUserScrollview_Featured.frame = CGRectMake(0, heightcheck, screenWidth, FinalWidth + 10 + 70 + 50 + 30);
                SUserScrollview_Featured.backgroundColor = [UIColor whiteColor];
                SUserScrollview_Featured.pagingEnabled = YES;
                [SUserScrollview_Featured setShowsHorizontalScrollIndicator:NO];
                [SUserScrollview_Featured setShowsVerticalScrollIndicator:NO];
                SUserScrollview_Featured.tag = 2000;
                [MainScroll addSubview:SUserScrollview_Featured];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
                ShowSuggestedText.text = @"Your friends are on Seeties";
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[SplitArray_Id count]];
                
                ShowSUserCount_Featured = [[UILabel alloc]init];
                ShowSUserCount_Featured.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
                ShowSUserCount_Featured.text = TempCount;
                ShowSUserCount_Featured.backgroundColor = [UIColor clearColor];
                ShowSUserCount_Featured.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSUserCount_Featured.textAlignment = NSTextAlignmentRight;
                ShowSUserCount_Featured.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSUserCount_Featured];
                
                
                SUserpageControl_Featured = [[UIPageControl alloc] init];
                SUserpageControl_Featured.frame = CGRectMake(0,heightcheck + FinalWidth + 10 + 70 + 50,screenWidth,30);
                SUserpageControl_Featured.numberOfPages = 3;
                SUserpageControl_Featured.currentPage = 0;
                SUserpageControl_Featured.pageIndicatorTintColor = [UIColor darkGrayColor];
                SUserpageControl_Featured.currentPageIndicatorTintColor = [UIColor orangeColor];
                [MainScroll addSubview:SUserpageControl_Featured];
                
                
                for (int i = 0; i < [SplitArray_Id count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * screenWidth, 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SUserScrollview_Featured addSubview: TempButton];
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(20 + i * screenWidth, 60, 40, 40);
                   // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=3;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ProfileImg objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SUserScrollview_Featured addSubview:ShowUserProfileImage];
                    
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(70 + i * screenWidth, 50 + 10, 200, 20);
                    ShowUserName.text = [SplitArray_Username objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SUserScrollview_Featured addSubview:ShowUserName];
                    
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(70 + i * screenWidth, 50 + 30, 200, 20);
                    ShowMessage.text = @"Based on your interest";
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SUserScrollview_Featured addSubview:ShowMessage];
                    
                    UIButton *FollowButton = [[UIButton alloc]init];
                    FollowButton.frame = CGRectMake(screenWidth - 20 - 70 + i * screenWidth, 52,70, 48);
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
                    
                    NSString *GetImg = [[NSString alloc]initWithFormat:@"%@",[SplitArray_PostsImg objectAtIndex:i]];
                    NSArray *PostsImg = [GetImg componentsSeparatedByString:@","];
                    
                    for (int z = 0; z < [PostsImg count]; z++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * screenWidth +(z % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                       // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[PostsImg objectAtIndex:z]];
                        if ([ImageData length] == 0) {
                            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage.imageURL = url_NearbySmall;
                        }
                        [SUserScrollview_Featured addSubview:ShowImage];
                    }
                    
                    UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                    [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                    OpenUserProfileButton.frame = CGRectMake(10 + i * screenWidth, 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [OpenUserProfileButton addTarget:self action:@selector(FeaturedOpenUserProfile:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserProfileButton.tag = i;
                    [SUserScrollview_Featured addSubview:OpenUserProfileButton];
                    
                    
                    SUserScrollview_Featured.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 100);
                }
                
                heightcheck += FinalWidth + 10 + 70 + 50 + 30 + 10;

            }break;
            case 7:{
               // NSLog(@"in follow_suggestion_friend");
                NSString *TempUserID = [[NSString alloc]initWithFormat:@"%@",[User_IDArray objectAtIndex:i]];
                NSString *TempUserProfileImg = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
                //   NSString *TempUser_Name = [[NSString alloc]initWithFormat:@"%@",[User_NameArray objectAtIndex:i]];
                //     NSString *TempUserLocation = [[NSString alloc]initWithFormat:@"%@",[User_LocationArray objectAtIndex:i]];
                //  NSString *TempUserFollow = [[NSString alloc]initWithFormat:@"%@",[User_FollowArray objectAtIndex:i]];
                NSString *TempUseName = [[NSString alloc]initWithFormat:@"%@",[User_UserNameArray objectAtIndex:i]];
                NSString *TempUserPhoto = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
                
                NSArray *SplitArray_Id = [TempUserID componentsSeparatedByString:@"$"];
                
                NSArray *SplitArray_ProfileImg = [TempUserProfileImg componentsSeparatedByString:@"$"];
                //   NSArray *SplitArray_name = [TempUser_Name componentsSeparatedByString:@"$"];
                //  NSArray *SplitArray_Location = [TempUserLocation componentsSeparatedByString:@"$"];
                //  NSArray *SplitArray_Follow = [TempUserFollow componentsSeparatedByString:@"$"];
                NSArray *SplitArray_Username = [TempUseName componentsSeparatedByString:@"$"];
                NSArray *SplitArray_PostsImg = [TempUserPhoto componentsSeparatedByString:@"$"];
                arrFriendUserName = [[NSMutableArray alloc]initWithArray:SplitArray_Username];
                int TestWidth = screenWidth - 40;
                //    NSLog(@"TestWidth is %i",TestWidth);
                int FinalWidth = TestWidth / 4;
                //    NSLog(@"FinalWidth is %i",FinalWidth);
                int SpaceWidth = FinalWidth + 4;
                
                SUserScrollview_Friend = [[UIScrollView alloc]init];
                SUserScrollview_Friend.delegate = self;
                SUserScrollview_Friend.frame = CGRectMake(0, heightcheck, screenWidth, FinalWidth + 10 + 70 + 50 + 30);
                SUserScrollview_Friend.backgroundColor = [UIColor whiteColor];
                SUserScrollview_Friend.pagingEnabled = YES;
                [SUserScrollview_Friend setShowsHorizontalScrollIndicator:NO];
                [SUserScrollview_Friend setShowsVerticalScrollIndicator:NO];
                SUserScrollview_Friend.tag = 2100;
                [MainScroll addSubview:SUserScrollview_Friend];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
                ShowSuggestedText.text = @"Your friends are on Seeties";
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
                NSString *TempCount = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[SplitArray_Id count]];
                
                ShowSUserCount_Friend = [[UILabel alloc]init];
                ShowSUserCount_Friend.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
                ShowSUserCount_Friend.text = TempCount;
                ShowSUserCount_Friend.backgroundColor = [UIColor clearColor];
                ShowSUserCount_Friend.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSUserCount_Friend.textAlignment = NSTextAlignmentRight;
                ShowSUserCount_Friend.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSUserCount_Friend];
                
                
                SUserpageControl_Friend = [[UIPageControl alloc] init];
                SUserpageControl_Friend.frame = CGRectMake(0,heightcheck + FinalWidth + 10 + 70 + 50,screenWidth,30);
                SUserpageControl_Friend.numberOfPages = 3;
                SUserpageControl_Friend.currentPage = 0;
                SUserpageControl_Friend.pageIndicatorTintColor = [UIColor darkGrayColor];
                SUserpageControl_Friend.currentPageIndicatorTintColor = [UIColor orangeColor];
                [MainScroll addSubview:SUserpageControl_Friend];
                
                
                for (int i = 0; i < [SplitArray_Id count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * screenWidth, 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SUserScrollview_Friend addSubview: TempButton];
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(20 + i * screenWidth, 60, 40, 40);
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=3;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                    NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ProfileImg objectAtIndex:i]];
                    if ([ImageData length] == 0) {
                        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
                    }else{
                        NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                        ShowUserProfileImage.imageURL = url_NearbySmall;
                    }
                    [SUserScrollview_Friend addSubview:ShowUserProfileImage];
                    
                    
                    UILabel *ShowUserName = [[UILabel alloc]init];
                    ShowUserName.frame = CGRectMake(70 + i * screenWidth, 50 + 10, 200, 20);
                    ShowUserName.text = [SplitArray_Username objectAtIndex:i];
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SUserScrollview_Friend addSubview:ShowUserName];
                    
                    UILabel *ShowMessage = [[UILabel alloc]init];
                    ShowMessage.frame = CGRectMake(70 + i * screenWidth, 50 + 30, 200, 20);
                    ShowMessage.text = @"Based on your interest";
                    ShowMessage.backgroundColor = [UIColor clearColor];
                    ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowMessage.textAlignment = NSTextAlignmentLeft;
                    ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    [SUserScrollview_Friend addSubview:ShowMessage];
                    
                    UIButton *FollowButton = [[UIButton alloc]init];
                    FollowButton.frame = CGRectMake(screenWidth - 20 - 70 + i * screenWidth, 52,70, 48);
                    // [FollowButton setTitle:@"Icon" forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateNormal];
                    [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateSelected];
                    FollowButton.backgroundColor = [UIColor clearColor];
                    //[FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
                    [SUserScrollview_Friend addSubview: FollowButton];
                    
                    NSString *GetImg = [[NSString alloc]initWithFormat:@"%@",[SplitArray_PostsImg objectAtIndex:i]];
                    NSArray *PostsImg = [GetImg componentsSeparatedByString:@","];
                    
                    for (int z = 0; z < [PostsImg count]; z++) {
                        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                        ShowImage.frame = CGRectMake(15 + i * screenWidth +(z % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                        // ShowImage.image = [UIImage imageNamed:[PostsImg objectAtIndex:z]];
                        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                        ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        ShowImage.layer.cornerRadius=5;
                        ShowImage.layer.masksToBounds = YES;
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                        NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[PostsImg objectAtIndex:z]];
                        if ([ImageData length] == 0) {
                            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                        }else{
                            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                            ShowImage.imageURL = url_NearbySmall;
                        }
                        [SUserScrollview_Friend addSubview:ShowImage];
                    }
                    
                    UIButton *OpenUserProfileButton = [[UIButton alloc]init];
                    [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
                    OpenUserProfileButton.backgroundColor = [UIColor clearColor];
                    OpenUserProfileButton.frame = CGRectMake(10 + i * screenWidth, 50, screenWidth - 20, FinalWidth + 10 + 70);
                    [OpenUserProfileButton addTarget:self action:@selector(FriendsOpenUserProfile:) forControlEvents:UIControlEventTouchUpInside];
                    OpenUserProfileButton.tag = i;
                    [SUserScrollview_Friend addSubview:OpenUserProfileButton];
                    
                    SUserScrollview_Friend.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 100);
                }
                
                heightcheck += FinalWidth + 10 + 70 + 50 + 30 + 10;
            }break;
            case 8:{
               // NSLog(@"in deal");
                SuggestedScrollview_Deal = [[UIScrollView alloc]init];
                SuggestedScrollview_Deal.delegate = self;
                SuggestedScrollview_Deal.frame = CGRectMake(0, heightcheck, screenWidth, 360);
                SuggestedScrollview_Deal.backgroundColor = [UIColor whiteColor];
                SuggestedScrollview_Deal.pagingEnabled = YES;
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
                NSArray *SplitArray_Title = [TempTitle componentsSeparatedByString:@","];
                
                NSString *TempAddress = [[NSString alloc]initWithFormat:@"%@",[arrAddress objectAtIndex:i]];
                NSArray *SplitArray_Address = [TempAddress componentsSeparatedByString:@","];
                
                NSString *TempId = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:i]];
                NSArray *SplitArray_Id = [TempId componentsSeparatedByString:@","];
                arrDealID = [[NSMutableArray alloc]initWithArray:SplitArray_Id];
                
                UILabel *ShowSuggestedText = [[UILabel alloc]init];
                ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
                ShowSuggestedText.text = @"Local Deals";
                ShowSuggestedText.backgroundColor = [UIColor clearColor];
                ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
                ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedText];
                
                NSString *TempString = [[NSString alloc]initWithFormat:@"1/%lu",(unsigned long)[SplitArray_Id count]];
                
                ShowSuggestedCount_Deal = [[UILabel alloc]init];
                ShowSuggestedCount_Deal.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
                ShowSuggestedCount_Deal.text = TempString;
                ShowSuggestedCount_Deal.backgroundColor = [UIColor clearColor];
                ShowSuggestedCount_Deal.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowSuggestedCount_Deal.textAlignment = NSTextAlignmentRight;
                ShowSuggestedCount_Deal.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowSuggestedCount_Deal];
                
                SuggestedpageControl_Deal = [[UIPageControl alloc] init];
                SuggestedpageControl_Deal.frame = CGRectMake(0,heightcheck + 330,screenWidth,30);
                SuggestedpageControl_Deal.numberOfPages = [SplitArray_Id count];
                SuggestedpageControl_Deal.currentPage = 0;
                SuggestedpageControl_Deal.pageIndicatorTintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
                SuggestedpageControl_Deal.currentPageIndicatorTintColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
                [MainScroll addSubview:SuggestedpageControl_Deal];
                

                
                for (int i = 0; i < [SplitArray_username count]; i++) {
                    UIButton *TempButton = [[UIButton alloc]init];
                    TempButton.frame = CGRectMake(10 + i * screenWidth, 50 , screenWidth - 20 ,280);
                    [TempButton setTitle:@"" forState:UIControlStateNormal];
                    TempButton.backgroundColor = [UIColor whiteColor];
                    TempButton.layer.cornerRadius = 5;
                    TempButton.layer.borderWidth=1;
                    TempButton.layer.masksToBounds = YES;
                    TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
                    [SuggestedScrollview_Deal addSubview: TempButton];
                    
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(11 + i * screenWidth, 51 , screenWidth - 22 ,198);
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
                    
                    
                    
                    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                    ShowUserProfileImage.frame = CGRectMake(25 + i * screenWidth, 51 + 10, 40, 40);
                    // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowUserProfileImage.layer.cornerRadius=20;
                    ShowUserProfileImage.layer.borderWidth=3;
                    ShowUserProfileImage.layer.masksToBounds = YES;
                    ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
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
                    ShowUserName.frame = CGRectMake(75 + i * screenWidth, 51 + 10, 200, 40);
                    ShowUserName.text = usernameTemp;
                    ShowUserName.backgroundColor = [UIColor clearColor];
                    ShowUserName.textColor = [UIColor whiteColor];
                    ShowUserName.textAlignment = NSTextAlignmentLeft;
                    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Deal addSubview:ShowUserName];
                    
                    UILabel *ShowDistance = [[UILabel alloc]init];
                    ShowDistance.frame = CGRectMake(screenWidth - 125 + i * screenWidth, 51 + 10, 100, 40);
                    // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                    ShowDistance.text = Distance;
                    ShowDistance.textColor = [UIColor whiteColor];
                    ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    ShowDistance.textAlignment = NSTextAlignmentRight;
                    ShowDistance.backgroundColor = [UIColor clearColor];
                    [SuggestedScrollview_Deal addSubview:ShowDistance];
                    
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Title objectAtIndex:i]];
                    if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                        
                    }else{
                        
                        ShowTitle.frame = CGRectMake(25 + i * screenWidth, 51 + 198 + 20, screenWidth - 50, 30);
                        ShowTitle.text = TempGetStirng;
                        ShowTitle.backgroundColor = [UIColor clearColor];
                        ShowTitle.numberOfLines = 2;
                        ShowTitle.textAlignment = NSTextAlignmentLeft;
                        ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                        [SuggestedScrollview_Deal addSubview:ShowTitle];
                        
                        if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                        {
                            ShowTitle.frame = CGRectMake(25 + i * screenWidth, 51 + 198 + 20, screenWidth - 50,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                        }
                    }
                    
                    UIImageView *ShowPinLocalQR = [[UIImageView alloc]init];
                    ShowPinLocalQR.image = [UIImage imageNamed:@"LocationpinIcon.png"];
                    ShowPinLocalQR.frame = CGRectMake(20 + i * screenWidth, 51 + 198 + ShowTitle.frame.size.height + 25, 18, 18);
                    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
                    [SuggestedScrollview_Deal addSubview:ShowPinLocalQR];
                    
                    UILabel *ShowAddressLocalQR = [[UILabel alloc]init];
                    ShowAddressLocalQR.frame = CGRectMake(40 + i * screenWidth, 51 + 198 + ShowTitle.frame.size.height + 25, screenWidth - 80, 20);
                    ShowAddressLocalQR.text = Address;
                    ShowAddressLocalQR.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                    ShowAddressLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview_Deal addSubview:ShowAddressLocalQR];
                    
                    //  int TempCountWhiteHeight = 51 + 198 + 10;
                    
                    UIButton *OpenPostsButton = [[UIButton alloc]init];
                    [OpenPostsButton setTitle:@"" forState:UIControlStateNormal];
                    OpenPostsButton.backgroundColor = [UIColor clearColor];
                    OpenPostsButton.frame = CGRectMake(10 + i * screenWidth, 50 , screenWidth - 20 ,280);
                    [OpenPostsButton addTarget:self action:@selector(DealOpenPostsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    OpenPostsButton.tag = i;
                    [SuggestedScrollview_Deal addSubview:OpenPostsButton];
                    
                    
                    SuggestedScrollview_Deal.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 300);
                }
                heightcheck += 370;
            }break;
            case 9:{
                //NSLog(@"in invite_friend");
                AsyncImageView *BannerImage = [[AsyncImageView alloc]init];
                BannerImage.frame = CGRectMake(0, heightcheck, screenWidth, 250);
              //  BannerImage.image = [UIImage imageNamed:@"Demoanner.jpg"];
                BannerImage.contentMode = UIViewContentModeScaleToFill;
                BannerImage.backgroundColor = [UIColor whiteColor];
               // BannerImage.layer.cornerRadius = 5;
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
                TempButton.frame = CGRectMake(0, heightcheck, screenWidth, 250);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor clearColor];
                [TempButton addTarget:self action:@selector(OpenInviteButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview: TempButton];
                
                heightcheck += 260;
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
    
    NSMutableArray *TempArray_FeedImage = [[NSMutableArray alloc]init];
    NSMutableArray *TempArray_FeedUserImage = [[NSMutableArray alloc]init];
    for (NSInteger i = DataCount; i < [arrPostID count]; i++) {
        
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[arrType objectAtIndex:i]];
        if ([GetType isEqualToString:@"following_post"]) {
            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
            UIImage *newImage;
            if ([TempImage length] == 0) {
                newImage = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:TempImage];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                newImage = [UIImage imageWithData:data];
            }
            
            NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
            UIImage *UserImage;
            if ([FullImagesURL length] == 0) {
                UserImage = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                UserImage = [UIImage imageWithData:data];
            }
            
            if (CheckFirstTimeLoad == 0) {
                NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                // Content_ Folder is your folder name
                NSError *error = nil;
                if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
                //This will create a new folder if content folder is not exist
                NSString *fileName = [stringPath stringByAppendingFormat:@"/FeedLocalimage_%li.jpg",(long)i];
                [imageData writeToFile:fileName atomically:YES];
               // NSLog(@"fileName is %@",fileName);
                NSString *SaveFileName = [[NSString alloc]initWithFormat:@"FeedLocalimage_%li.jpg",(long)i];
                [TempArray_FeedImage addObject:SaveFileName];
                
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
            if (CheckFirstTimeLoad == 0) {
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
            
        }
    
}

    
    NSLog(@"Done Save Data in Local");
    CheckFirstTimeLoad = 1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView == SuggestedScrollview_Aboad) {
        CGFloat pageWidth = SuggestedScrollview_Aboad.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SuggestedScrollview_Aboad.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SuggestedpageControl_Aboad.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrAboadID count]];
        ShowSuggestedCount_Aboad.text = TempCount;
    }else if (scrollView == SuggestedScrollview_Deal){
        CGFloat pageWidth = SuggestedScrollview_Deal.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SuggestedScrollview_Deal.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SuggestedpageControl_Deal.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrDealID count]];
        ShowSuggestedCount_Deal.text = TempCount;
    }else if(scrollView == SUserScrollview_Friend){
        CGFloat pageWidth = SUserScrollview_Friend.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SUserScrollview_Friend.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SUserpageControl_Friend.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrFriendUserName count]];
        ShowSUserCount_Friend.text = TempCount;
    }else if(scrollView == SUserScrollview_Featured){
        CGFloat pageWidth = SUserScrollview_Featured.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SUserScrollview_Featured.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SUserpageControl_Featured.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/%lu",page + 1,(unsigned long)[arrfeaturedUserName count]];
        ShowSUserCount_Featured.text = TempCount;
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
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
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
                     
                     
                     NSDictionary *titleData = [GetItemsData valueForKey:@"title"];
                     NSString *Title1;
                     NSString *Title2;
                     NSString *ThaiTitle;
                     NSString *IndonesianTitle;
                     NSString *PhilippinesTitle;
                     if ([titleData count] == 0) {
                         Title1 = @"";
                         Title2 = @"";
                         ThaiTitle = @"";
                         IndonesianTitle = @"";
                         PhilippinesTitle = @"";
                         [arrTitle addObject:Title1];
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
                             Title1 = [TempTitleArray componentsJoinedByString:@","];
                             [arrTitle addObject:Title1];
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
                     
                     
                     
                     NSDictionary *messageData = [GetItemsData valueForKey:@"message"];
                     NSString *Title1_message;
                     NSString *Title2_message;
                     NSString *ThaiTitle_message;
                     NSString *IndonesianTitle_message;
                     NSString *PhilippinesTitle_message;
                     if ([messageData count] == 0) {
                         Title1_message = @"";
                         Title2_message = @"";
                         ThaiTitle_message = @"";
                         IndonesianTitle_message = @"";
                         PhilippinesTitle_message = @"";
                         [arrMessage addObject:Title1_message];
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
                     
                     
                     
                     
                     NSDictionary *UserInfoData = [GetItemsData valueForKey:@"user_info"];
                   //  NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                     NSString *username = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"username"]];
                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"profile_photo"]];
                     
                     if ([posttype isEqualToString:@"announcement"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"announcement_welcome"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"announcement_campaign"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_featured"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"follow_suggestion_friend"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"deal"]) {
                         NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in UserInfoData) {
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [arrUserNameTemp addObject:username];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [arrUserImageTemp addObject:url];
                         }
                         username = [arrUserNameTemp componentsJoinedByString:@","];
                         url = [arrUserImageTemp componentsJoinedByString:@","];
                     }else if ([posttype isEqualToString:@"invite_friend"]) {
                         username = @"";
                         url = @"";
                     }else if ([posttype isEqualToString:@"abroad_quality_post"]) {
                         NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]init];
                         NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]init];
                         for (NSDictionary * dict in UserInfoData) {
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [arrUserNameTemp addObject:username];
                             NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [arrUserImageTemp addObject:url];
                         }
                         username = [arrUserNameTemp componentsJoinedByString:@","];
                         url = [arrUserImageTemp componentsJoinedByString:@","];
                     }else{

                     }
                     
                     
                    [arrUserName addObject:username];
                    [arrUserImage addObject:url];
                     
                     
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
                             NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"_id"]];
                             [User_IDArrayTemp addObject:uid];
                             NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                             [User_NameArrayTemp addObject:name];
                             NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [User_ProfileImageArrayTemp addObject:profile_photo];
                             NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"following"]];
                             [User_FollowArrayTemp addObject:followed];
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [User_UserNameArrayTemp addObject:username];
                             
                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                             
                             for (NSDictionary * dict in PhotoData) {
                                  NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                                 for (NSDictionary * dict_ in dict) {
                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                                     [UrlArray addObject:url];
                                 }
                                 
                                 NSString *result2 = [UrlArray componentsJoinedByString:@","];
                                 [User_UserNameArrayTempPostsImg addObject:result2];
                             }

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
                             NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"_id"]];
                             [User_IDArrayTemp addObject:uid];
                             NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                             [User_NameArrayTemp addObject:name];
                             NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                             [User_ProfileImageArrayTemp addObject:profile_photo];
                             NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"following"]];
                             [User_FollowArrayTemp addObject:followed];
                             NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                             [User_UserNameArrayTemp addObject:username];
                             
                             NSDictionary *PostsData = [dict valueForKey:@"posts"];
                             NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                             
                             for (NSDictionary * dict in PhotoData) {
                                 NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                                 for (NSDictionary * dict_ in dict) {
                                     NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                                     NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                                     [UrlArray addObject:url];
                                 }
                                 
                                 NSString *result2 = [UrlArray componentsJoinedByString:@","];
                                 [User_UserNameArrayTempPostsImg addObject:result2];
                             }
                             
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

             //   DataCount = DataTotal;
            //    DataTotal = [arrType count];
                
               // NSLog(@"User_PhotoArray is %@",User_PhotoArray);
               // NSLog(@"User_PhotoArray is %lu",(unsigned long)[User_PhotoArray count]);
    
                if (CheckFirstTimeLoad == 0) {
                    [self StartInit1stView];
                   // CheckFirstTimeLoad = 1;
                }else{
                    [self InitContent];
                }
                
                OnLoad = NO;
            }else{
            
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
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
                                       0,
                                       refreshControl.bounds.size.width,
                                       refreshControl.bounds.size.height);
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
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
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:[arrPostID objectAtIndex:getbuttonIDN]];
    
}
-(IBAction)NearbyButton:(id)sender{
    if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
//        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
//                                                           message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil];
//        [alert show];
        
        EnbleLocationViewController *EnbleLocationView = [[EnbleLocationViewController alloc]init];
        [self presentViewController:EnbleLocationView animated:YES completion:nil];
    }else{
        NearbyViewController *NearbyView = [[NearbyViewController alloc]init];
        [self.navigationController pushViewController:NearbyView animated:YES];
        [NearbyView Getlat:latPoint GetLong:lonPoint];
    }
}
-(IBAction)OpenUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
    [NewUserProfileV2View GetUserName:[arrUserName objectAtIndex:getbuttonIDN]];
}
-(IBAction)LikeButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);

    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
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
   // NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Quick CollectButtonOnClick");
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[arrPostID objectAtIndex:getbuttonIDN]];
    CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:getbuttonIDN]];
    
    if ([CheckCollect isEqualToString:@"0"]) {
        [arrCollect replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        
        [self SendQuickCollect];
    }else{
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
       // [self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:[arrPostID objectAtIndex:getbuttonIDN] GetImageData:[arrImage objectAtIndex:getbuttonIDN]];
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
    
    NSData *postBodyData = [NSData dataWithBytes: [dataString UTF8String] length:[dataString length]];
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
    
    }else if([GetAnnType isEqualToString:@"user"]){
        NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
        [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
        [NewUserProfileV2View GetUid:GetID];
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
-(IBAction)DealOpenPostsOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetID = [[NSString alloc]initWithFormat:@"%@",[arrDealID objectAtIndex:getbuttonIDN]];
    NSLog(@"DealOpenPostsOnClick GetID is %@",GetID);
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:GetID];
}
-(IBAction)FeaturedOpenUserProfile:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrfeaturedUserName objectAtIndex:getbuttonIDN]];
    NSLog(@"FeaturedOpenUserProfile Getname is %@",Getname);
    
    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
    [NewUserProfileV2View GetUserName:Getname];
}
-(IBAction)FriendsOpenUserProfile:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrFriendUserName objectAtIndex:getbuttonIDN]];
    NSLog(@"FriendsOpenUserProfile Getname is %@",Getname);
    
    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
    [NewUserProfileV2View GetUserName:Getname];
}
-(IBAction)ShareButtonOnClick:(id)sender{
    NSLog(@"ShareButtonOnClick");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    ShareViewController *ShareView = [[ShareViewController alloc]init];
    [self presentViewController:ShareView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:ShareView animated:YES completion:nil];
    [ShareView GetPostID:[arrPostID objectAtIndex:getbuttonIDN] GetMessage:[arrMessage objectAtIndex:getbuttonIDN] GetTitle:[arrTitle objectAtIndex:getbuttonIDN] GetImageData:[arrImage objectAtIndex:getbuttonIDN]];
}
-(IBAction)CommentButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    CommentViewController *CommentView = [[CommentViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:CommentView animated:YES completion:nil];
    [CommentView GetRealPostIDAndAllComment:[arrPostID objectAtIndex:getbuttonIDN]];
    [CommentView GetWhatView:@"Comment"];
}
@end

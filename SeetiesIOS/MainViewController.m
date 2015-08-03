//
//  MainViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "PublishViewController.h"
#import "MainTableViewCell.h"
#import "PublishMainViewController.h"
#import "FeedDetailViewController.h"
#import "SearchViewController.h"
//#import "ProgressHUD.h"
#import "ExpertsUserProfileViewController.h"
#import "NotificationViewController.h"
#import "LandingViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

#import "SelectImageViewController.h"

#import <Parse/Parse.h>
#import "SearchViewV2.h"
@interface MainViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation MainViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    BackgroundImage.frame = CGRectMake(0, 0, 320, 568);
    
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 113);
    
    CheckLocationOnOff = 0;
    
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
    
    ShowNoDataView.hidden = YES;


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *GetDeviceToken = [defaults objectForKey:@"DeviceTokenPush"];
    NSString *GetUserUID = [defaults objectForKey:@"Useruid"];
    NSLog(@"GetDeviceToken is %@",GetDeviceToken);
    NSLog(@"GetUserUID is %@",GetUserUID);
    if ([GetDeviceToken length] == 0 || GetDeviceToken == (id)[NSNull null] || GetDeviceToken.length == 0) {
        
    }else{
        NSString *Check = [defaults objectForKey:@"CheckGetPushToken"];
        if ([Check isEqualToString:@"Done"]) {
            
        }else{
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setDeviceTokenFromData:GetDeviceToken];
            NSString *TempTokenString = [[NSString alloc]initWithFormat:@"seeties_%@",GetUserUID];
            currentInstallation.channels = @[TempTokenString,@"all"];
            [currentInstallation saveInBackground];
            NSLog(@"work here?");
            NSString *TempString = @"Done";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:TempString forKey:@"CheckGetPushToken"];
            [defaults synchronize];
        }
        
    }
    
    ShowBadgeText = [[UILabel alloc]init];
    ShowBadgeText.frame = CGRectMake(26, 22, 20, 20);
    ShowBadgeText.layer.cornerRadius = 10;
    ShowBadgeText.layer.masksToBounds = YES;
    ShowBadgeText.backgroundColor = [UIColor redColor];
    ShowBadgeText.textAlignment = NSTextAlignmentCenter;
    ShowBadgeText.textColor = [UIColor whiteColor];
    ShowBadgeText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    ShowBadgeText.hidden = YES;
    [self.view addSubview:ShowBadgeText];
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
//    [MainScroll addSubview:refreshControl];
    

//    [tblview registerNib:[UINib nibWithNibName:@"MainTableViewCell"
//                                        bundle:[NSBundle mainBundle]]
//  forCellReuseIdentifier:@"CustomCellReuseID"];
//    
//    __weak MainViewController *weakSelf = self;
//    
//    // setup pull-to-refresh
//    [tblview addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
    
//    NSTimer *RandomTimer;
//    //    //2 sec to show button.
//    RandomTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
//
    
    //[self GetFeedDataFromServer];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
          //[self GetFeedDataFromServer];
            [refreshControl endRefreshing];
            NSLog(@"refresh end");
        });
    });
}

//-(void)changeview{
//    ShowAllDoneImage.hidden = YES;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Main View";
     self.title = CustomLocalisedString(@"MainTab_Feed",nil);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckRole = [defaults objectForKey:@"Role"];
    NSLog(@"CheckRole is %@",CheckRole);
    if ([CheckRole isEqualToString:@"user"]) {
    }else{
//        UIImageView *ShowImage = [[UIImageView alloc]init];
//        ShowImage.frame = CGRectMake(135, 519, 50, 49);
//        ShowImage.image = [UIImage imageNamed:@"TabBarPublish.png"];
//        [self.tabBarController.view addSubview:ShowImage];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(135, screenHeight - 49, 50, 49);
        ShowImage.image = [UIImage imageNamed:@"TabBarPublish.png"];
        [self.tabBarController.view addSubview:ShowImage];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(135, screenHeight - 49, 50, 49);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(ChangeViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:SelectButton];
    }
    

    GetNotifactionCountTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(CheckNotificationCount) userInfo:nil repeats:YES];
//    [MainScroll setScrollEnabled:YES];
//    [MainScroll setContentSize:CGSizeMake(320, 568)];
   // MainScroll.delegate = self;
}
-(IBAction)ChangeViewButton:(id)sender{
    NSLog(@"ChangeViewButton Click");
    SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
    [self presentViewController:SelectImageView animated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    ShowBadgeText.hidden = YES;
    [GetNotifactionCountTimer invalidate];
    GetNotifactionCountTimer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)NotificationButton:(id)sender{
    NotificationViewController *NotificationView = [[NotificationViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
 //   NotificationView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:NotificationView animated:YES completion:nil];
}
-(IBAction)SettingsButton:(id)sender{

    SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:SettingsView animated:NO completion:nil];
}
-(IBAction)PublishButton:(id)sender{
    PublishViewController *PublishView = [[PublishViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PublishView animated:NO completion:nil];
}
-(IBAction)SearchButton:(id)sender{
//    SearchViewController *SearchView = [[SearchViewController alloc]init];
//    [self presentViewController:SearchView animated:YES completion:nil];
    SearchViewV2 *SearchView = [[SearchViewV2 alloc]init];
    [self presentViewController:SearchView animated:YES completion:nil];

}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = [locations lastObject];
//    
//    latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    
//    NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
//    //Now you know the location has been found, do other things, call others methods here
//    [self.locationManager stopUpdatingLocation];
//     CheckLocationOnOff = 0;
//    [self GetFeedDataFromServer];
//  //  [self performSearchLatnLong];
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:latPoint forKey:@"UserCurrentLocation_Lat"];
        [defaults setObject:lonPoint forKey:@"UserCurrentLocation_Long"];
        [defaults synchronize];
        
        NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
        CheckLocationOnOff = 0;
      //  [self GetFeedDataFromServer];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetLat = [defaults objectForKey:@"GetLat"];
        NSString *GetLon = [defaults objectForKey:@"GetLang"];
        
        latPoint = GetLat;
        lonPoint = GetLon;
        
      //  [self GetFeedDataFromServer];
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
           
            CheckLocationOnOff = 1;
          //  [self GetFeedDataFromServer];
        }
//         CheckLocationOnOff = 1;
//        [self GetFeedDataFromServer];
    }else{
        CheckLocationOnOff = 1;
      //  [self GetFeedDataFromServer];
    }
}
-(void)GetFeedDataFromServer{
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.delegate = self;
//    HUD.labelText = @"Loading...";

    [ShowActivity startAnimating];
    
    NSDate *now = [NSDate date];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:enUSPOSIXLocale];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    NSString *GetCurrentTime = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:now]];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)GetCurrentTime,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"+",
                                                                                                    kCFStringEncodingUTF8 ));

//    NSString *ExternalIPAddress = [NSString stringWithFormat:@"%@",[SystemSharedServices externalIPAddress]];
//    NSLog(@"External IP Address: %@",ExternalIPAddress);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
    NSString *FullString;
    if (CheckLocationOnOff == 1) {
        FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&time=%@&ip_address=%@&device_type=2",DataUrl.Feed_Url,GetExpertToken,encodedString,ExternalIPAddress];
    }else{
        FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&time=%@&ip_address=%@&device_type=2&lat=%@&lng=%@",DataUrl.Feed_Url,GetExpertToken,encodedString,ExternalIPAddress,latPoint,lonPoint];
    }


    
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
//    expectedLength = [response expectedContentLength];
//    NSLog(@"expectedLength is %lld",expectedLength);
//    currentLength = 0;
//    HUD.mode = MBProgressHUDModeDeterminate;
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
//    currentLength += [data length];
//    HUD.progress = currentLength / (float)expectedLength;
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  //  [HUD hide:YES];
    [ShowActivity stopAnimating];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Connection" message:@"Check your wifi or 3G data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
     ShowNoDataView.hidden = NO;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Feed return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                //    NSString *CountString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
                //    NSLog(@"CountString is %@",CountString);
                
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                // NSLog(@"GetAllData ===== %@",GetAllData);
                if ([GetAllData count] == 0) {
                    
                }else{
                    
                    NSArray *GetNearbyData = (NSArray *)[GetAllData valueForKey:@"nearby"];
                      NSLog(@"GetNearbyData ===== %@",GetNearbyData);
                    NSDictionary *UserInfoData_Nearby = [GetNearbyData valueForKey:@"user_info"];
                      NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                    NSDictionary *UserInfoData_Nearby_ProfilePhoto = [UserInfoData_Nearby valueForKey:@"profile_photo"];
                       NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                    // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                    NSDictionary *titleData_Nearby = [GetNearbyData valueForKey:@"title"];
                    NSLog(@"titleData_Nearby is %@",titleData_Nearby);
                    NSDictionary *messageData_Nearby = [GetNearbyData valueForKey:@"message"];
                    NSLog(@"messageData_Nearby is %@",messageData_Nearby);
                    NSDictionary *locationData_Nearby = [GetNearbyData valueForKey:@"location"];
                    NSLog(@"locationData_Nearby is %@",locationData_Nearby);
                    NSDictionary *locationData_Address_Nearby = [locationData_Nearby valueForKey:@"address_components"];
                    NSLog(@"locationData_Address_Nearby is %@",locationData_Address_Nearby);
                    NSDictionary *CategoryMeta_Nearby = [GetNearbyData valueForKey:@"category_meta"];
                    NSLog(@"CategoryMeta_Nearby is %@",CategoryMeta_Nearby);
                    NSDictionary *SingleLine_Nearby = [CategoryMeta_Nearby valueForKey:@"single_line"];
                    NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                    
                    
//                    CategoryArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[SingleLine_Nearby count]];
//                    for (NSDictionary * dict in SingleLine_Nearby) {
//                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                        [CategoryArray_Nearby addObject:username];
//                    }
//                    NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
                    UserInfo_NameArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Nearby count]];
                    UserInfo_AddressArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Nearby count]];
                    UserInfo_uidArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Nearby count]];
                    UserInfo_FollowingArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Nearby count]];
                    for (NSDictionary * dict in UserInfoData_Nearby) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray_Nearby addObject:username];
                        NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                        [UserInfo_AddressArray_Nearby addObject:location];
                        NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                        [UserInfo_uidArray_Nearby addObject:uid];
                        NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                        [UserInfo_FollowingArray_Nearby addObject:following];
                    }
                    NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
                    //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
                    
                    UserInfo_UrlArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_Nearby_ProfilePhoto count]];
                    for (NSDictionary * dict in UserInfoData_Nearby_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray_Nearby addObject:url];
                    }
                    //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
                    
                    TitleArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[titleData_Nearby count]];
                    LangArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[titleData_Nearby count]];
                    for (NSDictionary * dict in titleData_Nearby) {
                        NSString *ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *EngTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        NSLog(@"Title1 is %@",ChineseTitle);
                        NSLog(@"Title2 is %@",EngTitle);
                        //                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        //                    [TitleArray_Nearby addObject:Title2];
                        //                    [LangArray_Nearby addObject:@"EN"];
                        //                }else{
                        //                    [TitleArray_Nearby addObject:Title1];
                        //                    [LangArray_Nearby addObject:@"CN"];
                        //                }
                        if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        }else{
                                            [TitleArray_Nearby addObject:PhilippinesTitle];
                                        }
                                    }else{
                                        [TitleArray_Nearby addObject:IndonesianTitle];
                                    }
                                }else{
                                    [TitleArray_Nearby addObject:ThaiTitle];
                                }
                            }else{
                                [TitleArray_Nearby addObject:EngTitle];
                            }
                            
                        }else{
                            [TitleArray_Nearby addObject:ChineseTitle];
                        }
                    }
                    //NSLog(@"TitleArray_Nearby is %@",TitleArray_Nearby);
                    
                    MessageArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[messageData_Nearby count]];
                    for (NSDictionary * dict in messageData_Nearby) {
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            [MessageArray_Nearby addObject:Title2];
                        }else{
                            [MessageArray_Nearby addObject:Title1];
                        }
                    }
                    LocationArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[locationData_Address_Nearby count]];
                    Location_DistanceArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[locationData_Nearby count]];
                    LatArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[locationData_Nearby count]];
                    LongArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[locationData_Nearby count]];
                    for (NSDictionary * dict in locationData_Nearby) {
                        NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                        [LatArray_Nearby addObject:lat];
                        NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                        [LongArray_Nearby addObject:lng];
                        NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [Location_DistanceArray_Nearby addObject:Distance];
                    }
                    
                    for (NSDictionary * dict in locationData_Address_Nearby) {
                        NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                        NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                        NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                        NSString *FullString;
                        if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                            if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                                if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                    if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                        FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                    }else{
                                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                    }
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                        }
                        
                        NSLog(@"Locality is %@",Locality);
                        NSLog(@"Address3 is %@",Address3);
                        NSLog(@"Address2 is %@",Address2);
                        NSLog(@"Address1 is %@",Address1);
                        NSLog(@"Country is %@",Country);
                        
                        //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                        [LocationArray_Nearby addObject:FullString];
                    }
                    // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
                    NSLog(@"LatArray_Nearby is %@",LatArray_Nearby);
                    NSLog(@"LongArray_Nearby is %@",LongArray_Nearby);
                    place_nameArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[GetNearbyData count]];
                    LPhotoArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[GetNearbyData count]];
                    LikesArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[GetNearbyData count]];
                    CommentArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[GetNearbyData count]];
                    PostIDArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[GetNearbyData count]];
                    CheckLikeArray_Nearby = [[NSMutableArray alloc]initWithCapacity:[GetNearbyData count]];
                    Link_Array_Nearby = [[NSMutableArray alloc]initWithCapacity:[GetNearbyData count]];
                    FullPhotoArray_Nearby = [[NSMutableArray alloc]init];
                    
                    
                    Activities_profile_photoArray_Nearby = [[NSMutableArray alloc]init];
                    Activities_uidArray_Nearby = [[NSMutableArray alloc]init];
                    Activities_typeArray_Nearby = [[NSMutableArray alloc]init];
                    Activities_usernameArray_Nearby = [[NSMutableArray alloc]init];
                    
                    
                    
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    for (NSDictionary * dict in GetNearbyData){
                        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [place_nameArray_Nearby addObject:place_name];
                        NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [LikesArray_Nearby addObject:total_like];
                        NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [CommentArray_Nearby addObject:total_comments];
                        NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray_Nearby addObject:post_id];
                        NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [CheckLikeArray_Nearby addObject:like];
                        NSString *Link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                        [Link_Array_Nearby addObject:Link];
                        
                        //
                        NSDictionary *Activities_Nearby = [dict valueForKey:@"activities"];
                        NSLog(@"Activities_Nearby is %@",Activities_Nearby);
                        
                        
                        if ([Activities_Nearby count] == 0){
                            
                            //TheDict is null
                            NSLog(@"Activities_Nearby is nil");
                            [Activities_profile_photoArray_Nearby addObject:@"nil"];
                            [Activities_typeArray_Nearby addObject:@"nil"];
                            [Activities_uidArray_Nearby addObject:@"nil"];
                            [Activities_usernameArray_Nearby addObject:@"nil"];
                        }
                        else{
                            //TheDict is not null
                            NSLog(@"Activities_Nearby is not nil");
                            NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                            for (NSDictionary * dict in Activities_Nearby){
                                NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                                [testarray_Photo addObject:profile_photo];
                                // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                                NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                                //[Activities_typeArray_Nearby addObject:type];
                                [testarray_type addObject:type];
                                NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                                // [Activities_uidArray_Nearby addObject:uid];
                                [testarray_uid addObject:uid];
                                NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                                // [Activities_usernameArray_Nearby addObject:username];
                                [testarray_username addObject:username];
                            }
                            NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                            [Activities_profile_photoArray_Nearby addObject:result_Photo];
                            NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                            [Activities_typeArray_Nearby addObject:result_Type];
                            NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                            [Activities_uidArray_Nearby addObject:result_Uid];
                            NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                            [Activities_usernameArray_Nearby addObject:result_Username];
                        }
                        
                        
                        
                        
                        
                        //  NSLog(@"Activities_profile_photoArray_Nearby is %@",Activities_profile_photoArray_Nearby);
                        
                        
                        
                        NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                        //  NSLog(@"photos is %@",photos);
                        // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                        photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                        // NSLog(@"photos is %@", photos);
                        NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                        //  NSLog(@"SplitArray is %@",SplitArray);
                        NSString *GetSplitString;
                        if ([SplitArray count] > 1) {
                            GetSplitString = [SplitArray objectAtIndex: 1];
                            NSMutableArray *testarray = [[NSMutableArray alloc]init];
                            for (int i = 0; i < [SplitArray count]; i++) {
                                NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                                
                                if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                                } else {
                                    //  NSLog(@"Get GetData is %@",GetData);
                                    NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                    [testarray addObject:FinalString];
                                }
                            }
                            //   NSLog(@"testarray is %@",testarray);
                            NSString * result = [testarray componentsJoinedByString:@","];
                            [FullPhotoArray_Nearby addObject:result];
                        }else{
                            GetSplitString = @"";
                        }
                        
                        NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                        //NSLog(@"SplitArray2 is %@",SplitArray2);
                        NSString *FinalString = [SplitArray2 objectAtIndex:0];
                        
                        [LPhotoArray_Nearby addObject:FinalString];
                    }
                    
                    NSLog(@"LikesArray_Nearby = %@",LikesArray_Nearby);
                    NSLog(@"CommentArray_Nearby = %@",CommentArray_Nearby);
                    //   NSLog(@"PostIDArray_Nearby is %@",PostIDArray_Nearby);
                    
                    //nearby, country, world, extra
                    NSArray *GetLocalData = (NSArray *)[GetAllData valueForKey:@"country"];
                    NSLog(@"GetLocalData ===== %@",GetLocalData);
                    NSDictionary *UserInfoData_Local = [GetLocalData valueForKey:@"user_info"];
                    //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                    NSDictionary *UserInfoData_Local_ProfilePhoto = [UserInfoData_Local valueForKey:@"profile_photo"];
                    //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                    // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                    NSDictionary *titleData_Local = [GetLocalData valueForKey:@"title"];
                    //  NSLog(@"titleData is %@",titleData);
                    NSDictionary *messageData_Local = [GetLocalData valueForKey:@"message"];
                    // NSLog(@"messageData is %@",messageData);
                    NSDictionary *locationData_Local = [GetLocalData valueForKey:@"location"];
                    //  NSLog(@"locationData is %@",locationData_Nearby);
                    NSDictionary *locationData_Address_Local = [locationData_Local valueForKey:@"address_components"];
                    //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
                //    NSDictionary *CategoryMeta_Local = [GetLocalData valueForKey:@"category_meta"];
                //    NSDictionary *SingleLine_Local = [CategoryMeta_Local valueForKey:@"single_line"];
                    //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                    
                    
//                    CategoryArray_Local = [[NSMutableArray alloc] initWithCapacity:[SingleLine_Local count]];
//                    for (NSDictionary * dict in SingleLine_Local) {
//                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                        [CategoryArray_Local addObject:username];
//                    }
//                    //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
                    UserInfo_NameArray_Local = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Local count]];
                    UserInfo_AddressArray_Local = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Local count]];
                    UserInfo_uidArray_Local = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Local count]];
                    UserInfo_FollowingArray_Local = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Local count]];
                    for (NSDictionary * dict in UserInfoData_Local) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray_Local addObject:username];
                        NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                        [UserInfo_AddressArray_Local addObject:location];
                        NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                        [UserInfo_uidArray_Local addObject:uid];
                        NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                        [UserInfo_FollowingArray_Local addObject:following];
                    }
                    //NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
                    //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
                    
                    UserInfo_UrlArray_Local = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_Local_ProfilePhoto count]];
                    for (NSDictionary * dict in UserInfoData_Local_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray_Local addObject:url];
                    }
                    //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
                    
                    TitleArray_Local = [[NSMutableArray alloc]initWithCapacity:[titleData_Local count]];
                    LangArray_Local = [[NSMutableArray alloc]initWithCapacity:[titleData_Nearby count]];
                    for (NSDictionary * dict in titleData_Local) {
                        NSString *ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *EngTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        NSLog(@"Title1 is %@",ChineseTitle);
                        NSLog(@"Title2 is %@",EngTitle);
                        //                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        //                    [TitleArray_Nearby addObject:Title2];
                        //                    [LangArray_Nearby addObject:@"EN"];
                        //                }else{
                        //                    [TitleArray_Nearby addObject:Title1];
                        //                    [LangArray_Nearby addObject:@"CN"];
                        //                }
                        if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        }else{
                                            [TitleArray_Local addObject:PhilippinesTitle];
                                        }
                                    }else{
                                        [TitleArray_Local addObject:IndonesianTitle];
                                    }
                                }else{
                                    [TitleArray_Local addObject:ThaiTitle];
                                }
                            }else{
                                [TitleArray_Local addObject:EngTitle];
                            }
                            
                        }else{
                            [TitleArray_Local addObject:ChineseTitle];
                        }
                        
                    }
                    //NSLog(@"TitleArray_Nearby is %@",TitleArray_Nearby);
                    
                    MessageArray_Local = [[NSMutableArray alloc]initWithCapacity:[messageData_Local count]];
                    for (NSDictionary * dict in messageData_Local) {
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            [MessageArray_Local addObject:Title2];
                        }else{
                            [MessageArray_Local addObject:Title1];
                        }
                    }
                    Location_DistanceArray_Local = [[NSMutableArray alloc]initWithCapacity:[locationData_Local count]];
                    LatArray_Local = [[NSMutableArray alloc]initWithCapacity:[locationData_Local count]];
                    LongArray_Local = [[NSMutableArray alloc]initWithCapacity:[locationData_Local count]];
                    for (NSDictionary * dict in locationData_Local) {
                        NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                        [LatArray_Local addObject:lat];
                        NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                        [LongArray_Local addObject:lng];
                        NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [Location_DistanceArray_Local addObject:Distance];
                    }
                    
                    LocationArray_Local = [[NSMutableArray alloc]initWithCapacity:[locationData_Address_Local count]];
                    for (NSDictionary * dict in locationData_Address_Local) {
                        NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                        NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                        NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                        NSString *FullString;
                        if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                            if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                                if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                    if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                        FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                    }else{
                                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                    }
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                        }
                        
                        NSLog(@"Locality is %@",Locality);
                        NSLog(@"Address3 is %@",Address3);
                        NSLog(@"Address2 is %@",Address2);
                        NSLog(@"Address1 is %@",Address1);
                        NSLog(@"Country is %@",Country);
                        
                        //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                        [LocationArray_Local addObject:FullString];
                    }
                    // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
                    
                    
                    place_nameArray_Local = [[NSMutableArray alloc] initWithCapacity:[GetLocalData count]];
                    LPhotoArray_Local = [[NSMutableArray alloc] initWithCapacity:[GetLocalData count]];
                    FullPhotoArray_Local = [[NSMutableArray alloc]init];
                    LikesArray_Local = [[NSMutableArray alloc] initWithCapacity:[GetLocalData count]];
                    CommentArray_Local = [[NSMutableArray alloc] initWithCapacity:[GetLocalData count]];
                    PostIDArray_Local = [[NSMutableArray alloc]initWithCapacity:[GetLocalData count]];
                    CheckLikeArray_Local = [[NSMutableArray alloc]initWithCapacity:[GetLocalData count]];
                    Link_Array_Local = [[NSMutableArray alloc]initWithCapacity:[GetLocalData count]];
                    
                    Activities_profile_photoArray_Local = [[NSMutableArray alloc]init];
                    Activities_uidArray_Local = [[NSMutableArray alloc]init];
                    Activities_typeArray_Local = [[NSMutableArray alloc]init];
                    Activities_usernameArray_Local = [[NSMutableArray alloc]init];
                    
                    // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    for (NSDictionary * dict in GetLocalData){
                        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [place_nameArray_Local addObject:place_name];
                        NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [LikesArray_Local addObject:total_like];
                        NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [CommentArray_Local addObject:total_comments];
                        NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray_Local addObject:post_id];
                        NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [CheckLikeArray_Local addObject:like];
                        NSString *Link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                        [Link_Array_Local addObject:Link];
                        
                        NSDictionary *Activities_Local = [dict valueForKey:@"activities"];
                        NSLog(@"Activities_Local is %@",Activities_Local);
                        
                        
                        if ([Activities_Local count] == 0){
                            
                            //TheDict is null
                            NSLog(@"Activities_Nearby is nil");
                            [Activities_profile_photoArray_Local addObject:@"nil"];
                            [Activities_typeArray_Local addObject:@"nil"];
                            [Activities_uidArray_Local addObject:@"nil"];
                            [Activities_usernameArray_Local addObject:@"nil"];
                        }
                        else{
                            //TheDict is not null
                            NSLog(@"Activities_Nearby is not nil");
                            NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                            for (NSDictionary * dict in Activities_Local){
                                NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                                [testarray_Photo addObject:profile_photo];
                                // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                                NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                                //[Activities_typeArray_Nearby addObject:type];
                                [testarray_type addObject:type];
                                NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                                // [Activities_uidArray_Nearby addObject:uid];
                                [testarray_uid addObject:uid];
                                NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                                // [Activities_usernameArray_Nearby addObject:username];
                                [testarray_username addObject:username];
                            }
                            NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                            [Activities_profile_photoArray_Local addObject:result_Photo];
                            NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                            [Activities_typeArray_Local addObject:result_Type];
                            NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                            [Activities_uidArray_Local addObject:result_Uid];
                            NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                            [Activities_usernameArray_Local addObject:result_Username];
                        }
                        
                        NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                        //  NSLog(@"photos is %@",photos);
                        // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                        photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                        // NSLog(@"photos is %@", photos);
                        NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                        //  NSLog(@"SplitArray is %@",SplitArray);
                        NSString *GetSplitString;
                        if ([SplitArray count] > 1) {
                            GetSplitString = [SplitArray objectAtIndex: 1];
                            NSMutableArray *testarray = [[NSMutableArray alloc]init];
                            for (int i = 0; i < [SplitArray count]; i++) {
                                NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                                
                                if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                                } else {
                                    //  NSLog(@"Get GetData is %@",GetData);
                                    NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                    [testarray addObject:FinalString];
                                }
                            }
                            //   NSLog(@"testarray is %@",testarray);
                            NSString * result = [testarray componentsJoinedByString:@","];
                            [FullPhotoArray_Local addObject:result];
                        }else{
                            GetSplitString = @"";
                        }
                        
                        NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                        //NSLog(@"SplitArray2 is %@",SplitArray2);
                        NSString *FinalString = [SplitArray2 objectAtIndex:0];
                        
                        [LPhotoArray_Local addObject:FinalString];
                    }
                    
                    
                    //nearby, country, world, extra
                    NSArray *GetForeignLandData = (NSArray *)[GetAllData valueForKey:@"world"];
                    //   NSLog(@"GetNearbyData ===== %@",GetNearbyData);
                    NSDictionary *UserInfoData_ForeignLand = [GetForeignLandData valueForKey:@"user_info"];
                    //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                    NSDictionary *UserInfoData_ForeignLand_ProfilePhoto = [UserInfoData_ForeignLand valueForKey:@"profile_photo"];
                    //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                    // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                    NSDictionary *titleData_ForeignLand = [GetForeignLandData valueForKey:@"title"];
                    //  NSLog(@"titleData is %@",titleData);
                    NSDictionary *messageData_ForeignLand = [GetForeignLandData valueForKey:@"message"];
                    // NSLog(@"messageData is %@",messageData);
                    NSDictionary *locationData_ForeignLand = [GetForeignLandData valueForKey:@"location"];
                    //  NSLog(@"locationData is %@",locationData_Nearby);
                    NSDictionary *locationData_Address_ForeignLand = [locationData_ForeignLand valueForKey:@"address_components"];
                    //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
                  //  NSDictionary *CategoryMeta_ForeignLand = [GetForeignLandData valueForKey:@"category_meta"];
                 //   NSDictionary *SingleLine_ForeignLand = [CategoryMeta_ForeignLand valueForKey:@"single_line"];
                    //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                    //            NSDictionary *AllComment_ForeignLand = [GetForeignLandData valueForKey:@"comment_list"];
                    //            NSLog(@"AllComment_ForeignLand is %@",AllComment_ForeignLand);
                    
//                    CategoryArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[SingleLine_ForeignLand count]];
//                    for (NSDictionary * dict in SingleLine_ForeignLand) {
//                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                        [CategoryArray_ForeignLand addObject:username];
//                    }
//                    //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
                    UserInfo_NameArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ForeignLand count]];
                    UserInfo_AddressArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ForeignLand count]];
                    UserInfo_uidArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ForeignLand count]];
                    UserInfo_FollowingArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ForeignLand count]];
                    for (NSDictionary * dict in UserInfoData_ForeignLand) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray_ForeignLand addObject:username];
                        NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                        [UserInfo_AddressArray_ForeignLand addObject:location];
                        NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                        [UserInfo_uidArray_ForeignLand addObject:uid];
                        NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                        [UserInfo_FollowingArray_ForeignLand addObject:following];
                    }
                    //NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
                    //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
                    
                    UserInfo_UrlArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ForeignLand_ProfilePhoto count]];
                    for (NSDictionary * dict in UserInfoData_ForeignLand_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray_ForeignLand addObject:url];
                    }
                    //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
                    
                    TitleArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[titleData_ForeignLand count]];
                    LangArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[titleData_Nearby count]];
                    for (NSDictionary * dict in titleData_ForeignLand) {
                        NSString *ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *EngTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        NSLog(@"Title1 is %@",ChineseTitle);
                        NSLog(@"Title2 is %@",EngTitle);
                        //                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        //                    [TitleArray_Nearby addObject:Title2];
                        //                    [LangArray_Nearby addObject:@"EN"];
                        //                }else{
                        //                    [TitleArray_Nearby addObject:Title1];
                        //                    [LangArray_Nearby addObject:@"CN"];
                        //                }
                        if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        }else{
                                            [TitleArray_ForeignLand addObject:PhilippinesTitle];
                                        }
                                    }else{
                                        [TitleArray_ForeignLand addObject:IndonesianTitle];
                                    }
                                }else{
                                    [TitleArray_ForeignLand addObject:ThaiTitle];
                                }
                            }else{
                                [TitleArray_ForeignLand addObject:EngTitle];
                            }
                            
                        }else{
                            [TitleArray_ForeignLand addObject:ChineseTitle];
                        }
                    }
                    //NSLog(@"TitleArray_Nearby is %@",TitleArray_Nearby);
                    
                    MessageArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[messageData_ForeignLand count]];
                    for (NSDictionary * dict in messageData_ForeignLand) {
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            [MessageArray_ForeignLand addObject:Title2];
                        }else{
                            [MessageArray_ForeignLand addObject:Title1];
                        }
                    }
                    LatArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[locationData_ForeignLand count]];
                    LongArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[locationData_ForeignLand count]];
                    Location_DistanceArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[locationData_ForeignLand count]];
                    for (NSDictionary * dict in locationData_ForeignLand) {
                        NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                        [LatArray_ForeignLand addObject:lat];
                        NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                        [LongArray_ForeignLand addObject:lng];
                        NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [Location_DistanceArray_ForeignLand addObject:Distance];
                    }
                    
                    LocationArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[locationData_Address_ForeignLand count]];
                    for (NSDictionary * dict in locationData_Address_ForeignLand) {
                        NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                        NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                        NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                        NSString *FullString;
                        if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                            if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                                if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                    if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                        FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                    }else{
                                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                    }
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                        }
                        
                        NSLog(@"Locality is %@",Locality);
                        NSLog(@"Address3 is %@",Address3);
                        NSLog(@"Address2 is %@",Address2);
                        NSLog(@"Address1 is %@",Address1);
                        NSLog(@"Country is %@",Country);
                        
                        //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                        [LocationArray_ForeignLand addObject:FullString];
                    }
                    // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
                    
                    place_nameArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[GetForeignLandData count]];
                    LPhotoArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[GetForeignLandData count]];
                    FullPhotoArray_ForeignLand = [[NSMutableArray alloc]init];
                    LikesArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[GetForeignLandData count]];
                    CommentArray_ForeignLand = [[NSMutableArray alloc] initWithCapacity:[GetForeignLandData count]];
                    PostIDArray_FOreignLand = [[NSMutableArray alloc] initWithCapacity:[GetForeignLandData count]];
                    CheckLikeArray_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[GetForeignLandData count]];
                    Link_Array_ForeignLand = [[NSMutableArray alloc]initWithCapacity:[GetForeignLandData count]];
                    // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    
                    Activities_profile_photoArray_ForeignLand = [[NSMutableArray alloc]init];
                    Activities_uidArray_ForeignLand = [[NSMutableArray alloc]init];
                    Activities_typeArray_ForeignLand = [[NSMutableArray alloc]init];
                    Activities_usernameArray_ForeignLand = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary * dict in GetForeignLandData){
                        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [place_nameArray_ForeignLand addObject:place_name];
                        NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [LikesArray_ForeignLand addObject:total_like];
                        NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [CommentArray_ForeignLand addObject:total_comments];
                        NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray_FOreignLand addObject:post_id];
                        NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [CheckLikeArray_ForeignLand addObject:like];
                        NSString *Link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                        [Link_Array_ForeignLand addObject:Link];
                        
                        NSDictionary *Activities_ForeignLand = [dict valueForKey:@"activities"];
                        NSLog(@"Activities_ForeignLand is %@",Activities_ForeignLand);
                        
                        if ([Activities_ForeignLand count] == 0){
                            
                            //TheDict is null
                            NSLog(@"Activities_Nearby is nil");
                            [Activities_profile_photoArray_ForeignLand addObject:@"nil"];
                            [Activities_typeArray_ForeignLand addObject:@"nil"];
                            [Activities_uidArray_ForeignLand addObject:@"nil"];
                            [Activities_usernameArray_ForeignLand addObject:@"nil"];
                        }
                        else{
                            //TheDict is not null
                            NSLog(@"Activities_Nearby is not nil");
                            NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                            for (NSDictionary * dict in Activities_ForeignLand){
                                NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                                [testarray_Photo addObject:profile_photo];
                                // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                                NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                                //[Activities_typeArray_Nearby addObject:type];
                                [testarray_type addObject:type];
                                NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                                // [Activities_uidArray_Nearby addObject:uid];
                                [testarray_uid addObject:uid];
                                NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                                // [Activities_usernameArray_Nearby addObject:username];
                                [testarray_username addObject:username];
                            }
                            NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                            [Activities_profile_photoArray_ForeignLand addObject:result_Photo];
                            NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                            [Activities_typeArray_ForeignLand addObject:result_Type];
                            NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                            [Activities_uidArray_ForeignLand addObject:result_Uid];
                            NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                            [Activities_usernameArray_ForeignLand addObject:result_Username];
                        }
                        
                        NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                        //  NSLog(@"photos is %@",photos);
                        // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                        photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                        // NSLog(@"photos is %@", photos);
                        NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                        //  NSLog(@"SplitArray is %@",SplitArray);
                        NSString *GetSplitString;
                        if ([SplitArray count] > 1) {
                            GetSplitString = [SplitArray objectAtIndex: 1];
                            NSMutableArray *testarray = [[NSMutableArray alloc]init];
                            for (int i = 0; i < [SplitArray count]; i++) {
                                NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                                
                                if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                                } else {
                                    //  NSLog(@"Get GetData is %@",GetData);
                                    NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                    [testarray addObject:FinalString];
                                }
                            }
                            //   NSLog(@"testarray is %@",testarray);
                            NSString * result = [testarray componentsJoinedByString:@","];
                            [FullPhotoArray_ForeignLand addObject:result];
                        }else{
                            GetSplitString = @"";
                        }
                        
                        NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                        //NSLog(@"SplitArray2 is %@",SplitArray2);
                        NSString *FinalString = [SplitArray2 objectAtIndex:0];
                        
                        [LPhotoArray_ForeignLand addObject:FinalString];
                    }
                    
                    //nearby, country, world, extra
                    NSArray *GetExtraData = (NSArray *)[GetAllData valueForKey:@"extra"];
                    //   NSLog(@"GetNearbyData ===== %@",GetNearbyData);
                    NSDictionary *UserInfoData_Extra = [GetExtraData valueForKey:@"user_info"];
                    //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                    NSDictionary *UserInfoData_Extra_ProfilePhoto = [UserInfoData_Extra valueForKey:@"profile_photo"];
                    //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                    // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                    NSDictionary *titleData_Extra = [GetExtraData valueForKey:@"title"];
                    //  NSLog(@"titleData is %@",titleData);
                    NSDictionary *messageData_Extra = [GetExtraData valueForKey:@"message"];
                    // NSLog(@"messageData is %@",messageData);
                    NSDictionary *locationData_Extra = [GetExtraData valueForKey:@"location"];
                    //  NSLog(@"locationData is %@",locationData_Nearby);
                    NSDictionary *locationData_Address_Extra = [locationData_Extra valueForKey:@"address_components"];
                    //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
                   // NSDictionary *CategoryMeta_Extra = [GetExtraData valueForKey:@"category_meta"];
                  //  NSDictionary *SingleLine_Extra = [CategoryMeta_Extra valueForKey:@"single_line"];
                    //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                    //            NSDictionary *AllComment_Extra = [GetExtraData valueForKey:@"comment_list"];
                    //            NSLog(@"AllComment_Extra is %@",AllComment_Extra);
                    
//                    CategoryArray_Extra = [[NSMutableArray alloc] initWithCapacity:[SingleLine_Extra count]];
//                    for (NSDictionary * dict in SingleLine_Extra) {
//                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                        [CategoryArray_Extra addObject:username];
//                    }
//                    //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
                    UserInfo_NameArray_Extra = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Extra count]];
                    UserInfo_AddressArray_Extra = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Extra count]];
                    UserInfo_uidArray_Extra = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Extra count]];
                    UserInfo_FollowingArray_Extra = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_Extra count]];
                    for (NSDictionary * dict in UserInfoData_Extra) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray_Extra addObject:username];
                        NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                        [UserInfo_AddressArray_Extra addObject:location];
                        NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                        [UserInfo_uidArray_Extra addObject:uid];
                        NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                        [UserInfo_FollowingArray_Extra addObject:following];
                    }
                    //NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
                    //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
                    
                    UserInfo_UrlArray_Extra = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_Extra_ProfilePhoto count]];
                    for (NSDictionary * dict in UserInfoData_Extra_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray_Extra addObject:url];
                    }
                    //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
                    
                    TitleArray_Extra = [[NSMutableArray alloc]initWithCapacity:[titleData_Extra count]];
                    LangArray_Extra = [[NSMutableArray alloc]initWithCapacity:[titleData_Nearby count]];
                    for (NSDictionary * dict in titleData_Extra) {
                        NSString *ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *EngTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        NSLog(@"Title1 is %@",ChineseTitle);
                        NSLog(@"Title2 is %@",EngTitle);
                        //                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        //                    [TitleArray_Nearby addObject:Title2];
                        //                    [LangArray_Nearby addObject:@"EN"];
                        //                }else{
                        //                    [TitleArray_Nearby addObject:Title1];
                        //                    [LangArray_Nearby addObject:@"CN"];
                        //                }
                        if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        }else{
                                            [TitleArray_Extra addObject:PhilippinesTitle];
                                        }
                                    }else{
                                        [TitleArray_Extra addObject:IndonesianTitle];
                                    }
                                }else{
                                    [TitleArray_Extra addObject:ThaiTitle];
                                }
                            }else{
                                [TitleArray_Extra addObject:EngTitle];
                            }
                            
                        }else{
                            [TitleArray_Extra addObject:ChineseTitle];
                        }
                    }
                    //NSLog(@"TitleArray_Nearby is %@",TitleArray_Nearby);
                    
                    MessageArray_Extra = [[NSMutableArray alloc]initWithCapacity:[messageData_Extra count]];
                    for (NSDictionary * dict in messageData_Extra) {
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            [MessageArray_Extra addObject:Title2];
                        }else{
                            [MessageArray_Extra addObject:Title1];
                        }
                    }
                    LatArray_Extra = [[NSMutableArray alloc]initWithCapacity:[locationData_Extra count]];
                    LongArray_Extra = [[NSMutableArray alloc]initWithCapacity:[locationData_Extra count]];
                    Location_DistanceArray_Extra = [[NSMutableArray alloc]initWithCapacity:[locationData_Extra count]];
                    for (NSDictionary * dict in locationData_Extra) {
                        NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                        [LatArray_Extra addObject:lat];
                        NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                        [LongArray_Extra addObject:lng];
                        NSString *Distance = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [Location_DistanceArray_Extra addObject:Distance];
                    }
                    
                    LocationArray_Extra = [[NSMutableArray alloc]initWithCapacity:[locationData_Address_Extra count]];
                    for (NSDictionary * dict in locationData_Address_Extra) {
                        NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                        NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                        NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                        NSString *FullString;
                        if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                            if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                                if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                    if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                        FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                    }else{
                                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                    }
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                        }
                        
                        NSLog(@"Locality is %@",Locality);
                        NSLog(@"Address3 is %@",Address3);
                        NSLog(@"Address2 is %@",Address2);
                        NSLog(@"Address1 is %@",Address1);
                        NSLog(@"Country is %@",Country);
                        
                        //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                        [LocationArray_Extra addObject:FullString];
                    }
                    // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
                    
                    place_nameArray_Extra = [[NSMutableArray alloc] initWithCapacity:[GetExtraData count]];
                    LPhotoArray_Extra = [[NSMutableArray alloc] initWithCapacity:[GetExtraData count]];
                    FullPhotoArray_Extra = [[NSMutableArray alloc]init];
                    LikesArray_Extra = [[NSMutableArray alloc] initWithCapacity:[GetExtraData count]];
                    CommentArray_Extra = [[NSMutableArray alloc] initWithCapacity:[GetExtraData count]];
                    PostIDArray_Extra = [[NSMutableArray alloc]initWithCapacity:[GetExtraData count]];
                    CheckLikeArray_Extra = [[NSMutableArray alloc]initWithCapacity:[GetExtraData count]];
                    Link_Array_Extra = [[NSMutableArray alloc]initWithCapacity:[GetExtraData count]];
                    
                    Activities_profile_photoArray_Extra = [[NSMutableArray alloc]init];
                    Activities_uidArray_Extra = [[NSMutableArray alloc]init];
                    Activities_typeArray_Extra = [[NSMutableArray alloc]init];
                    Activities_usernameArray_Extra = [[NSMutableArray alloc]init];
                    // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    for (NSDictionary * dict in GetExtraData){
                        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [place_nameArray_Extra addObject:place_name];
                        NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [LikesArray_Extra addObject:total_like];
                        NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [CommentArray_Extra addObject:total_comments];
                        NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray_Extra addObject:post_id];
                        NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [CheckLikeArray_Extra addObject:like];
                        NSString *Link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                        [Link_Array_Extra addObject:Link];
                        
                        NSDictionary *Activities_Extra = [dict valueForKey:@"activities"];
                        NSLog(@"Activities_Extra is %@",Activities_Extra);
                        
                        if ([Activities_Extra count] == 0){
                            
                            //TheDict is null
                            NSLog(@"Activities_Nearby is nil");
                            [Activities_profile_photoArray_Extra addObject:@"nil"];
                            [Activities_typeArray_Extra addObject:@"nil"];
                            [Activities_uidArray_Extra addObject:@"nil"];
                            [Activities_usernameArray_Extra addObject:@"nil"];
                        }
                        else{
                            //TheDict is not null
                            NSLog(@"Activities_Nearby is not nil");
                            NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                            NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                            for (NSDictionary * dict in Activities_Extra){
                                NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                                [testarray_Photo addObject:profile_photo];
                                // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                                NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                                //[Activities_typeArray_Nearby addObject:type];
                                [testarray_type addObject:type];
                                NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                                // [Activities_uidArray_Nearby addObject:uid];
                                [testarray_uid addObject:uid];
                                NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                                // [Activities_usernameArray_Nearby addObject:username];
                                [testarray_username addObject:username];
                            }
                            NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                            [Activities_profile_photoArray_Extra addObject:result_Photo];
                            NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                            [Activities_typeArray_Extra addObject:result_Type];
                            NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                            [Activities_uidArray_Extra addObject:result_Uid];
                            NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                            [Activities_usernameArray_Extra addObject:result_Username];
                        }
                        
                        NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                        //  NSLog(@"photos is %@",photos);
                        // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                        photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                        // NSLog(@"photos is %@", photos);
                        NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                        //  NSLog(@"SplitArray is %@",SplitArray);
                        NSString *GetSplitString;
                        if ([SplitArray count] > 1) {
                            GetSplitString = [SplitArray objectAtIndex: 1];
                            NSMutableArray *testarray = [[NSMutableArray alloc]init];
                            for (int i = 0; i < [SplitArray count]; i++) {
                                NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                                
                                if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                                } else {
                                    //  NSLog(@"Get GetData is %@",GetData);
                                    NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                    [testarray addObject:FinalString];
                                }
                            }
                            //   NSLog(@"testarray is %@",testarray);
                            NSString * result = [testarray componentsJoinedByString:@","];
                            [FullPhotoArray_Extra addObject:result];
                        }else{
                            GetSplitString = @"";
                        }
                        
                        NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                        //NSLog(@"SplitArray2 is %@",SplitArray2);
                        NSString *FinalString = [SplitArray2 objectAtIndex:0];
                        
                        [LPhotoArray_Extra addObject:FinalString];
                    }
                    
                    NSDictionary *featured = [res valueForKey:@"featured"];
                    NSLog(@"featured is %@",featured);
                    
                    NSDictionary *users = [featured valueForKey:@"users"];
                    NSLog(@"users is %@",users);
                    
                    featured_userImgArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
                    featured_userUidArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
                    featured_usernameArray = [[NSMutableArray alloc] initWithCapacity:[users count]];
                    for (NSDictionary * dict in users){
                        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                        [featured_userImgArray addObject:place_name];
                        NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                        [featured_userUidArray addObject:uid];
                        NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [featured_usernameArray addObject:username];
                    }
                    NSLog(@"featured_userImgArray is %@",featured_userImgArray);
                    NSLog(@"featured_userUidArray is %@",featured_userUidArray);
                    [self InitView];
                }
                //        NSLog(@"place_nameArray_Nearby is %@",place_nameArray_Nearby);
                //        NSLog(@"LPhotoArray_Nearby is %@",LPhotoArray_Nearby);
                //        NSLog(@"FullPhotoArray_Nearby is %@",FullPhotoArray_Nearby);
                
                
                //[ProgressHUD showSuccess:@"That was great!"];
                [ShowActivity stopAnimating];
                
            }
                }
               
        
        
        NSLog(@"Location_DistanceArray_Nearby is %@",Location_DistanceArray_Nearby);
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"GetNotificationCount return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Explore Json = %@",res);
        
        NSString *GetCountString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
        NSLog(@"GetCountString is %@",GetCountString);
        
        if ([GetCountString isEqualToString:@"0"] || [GetCountString isEqualToString:@"(null)"]) {

        }else{
            ShowBadgeText.hidden = NO;
            ShowBadgeText.text = GetCountString;
        }
    }
    

    
    
   // NSLog(@"CategoryArray is %@",CategoryArray);
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.labelText = @"Done";
//    [HUD hide:YES afterDelay:0.5];
    
    //[ProgressHUD showSuccess:@"That was great!"];
    
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return [LPhotoArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"CustomCellReuseID";
//    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//    }else{
//        //cancel loading previous image for cell
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.ShowImage];
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.ShowUserImage];
//    }
//    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:indexPath.row]];
//   // NSLog(@"FullImagesURL ====== %@",FullImagesURL);
//    if ([FullImagesURL length] == 0) {
//        cell.ShowImage.image = [UIImage imageNamed:@"No_image_available.jpg"];
//    }else{
//        NSURL *url = [NSURL URLWithString:FullImagesURL];
//        //load the image
//        cell.ShowImage.imageURL = url;
//    }
//    
//    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:indexPath.row]];
//    // NSLog(@"FullImagesURL ====== %@",FullImagesURL);
//    if ([FullImagesURL1 length] == 0) {
//        cell.ShowUserImage.image = [UIImage imageNamed:@"No_image_available.jpg"];
//    }else{
//        NSURL *url = [NSURL URLWithString:FullImagesURL1];
//        //load the image
//        cell.ShowUserImage.imageURL = url;
//    }
//    
//    cell.ShowTitle.text = [TitleArray objectAtIndex:indexPath.row];
//    cell.ShowLocation.text = [place_nameArray objectAtIndex:indexPath.row];
//    cell.ShowAddress.text = [UserInfo_NameArray objectAtIndex:indexPath.row];
//
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Click...");
//}
//- (void)insertRowAtTop {
//   // __weak MainViewController *weakSelf = self;
//    
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [tblview beginUpdates];
//         //do refeash data here.
//        [self GetFeedDataFromServer];
//        [tblview endUpdates];
//        
//        [tblview.pullToRefreshView stopAnimating];
//    });
//}

-(void)InitView{
   // NSLog(@"InitView...");
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    
    if ([TitleArray_Nearby count] == 0) {
        NSLog(@"TItle Array Nearby nil");
    }else{
        NSLog(@"Got Title");
        
        UIImageView *ShowNearbyTitleImage = [[UIImageView alloc]init];
        ShowNearbyTitleImage.frame = CGRectMake(0, 0, 320, 97);
        ShowNearbyTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"NearbyImg", nil)];
        
        AsyncImageView *ShowNearbyBigImage = [[AsyncImageView alloc]init];
        ShowNearbyBigImage.frame = CGRectMake(0, 60, 320, 241);
        ShowNearbyBigImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbyBigImage.backgroundColor = [UIColor clearColor];
        ShowNearbyBigImage.clipsToBounds = YES;
        //ShowNearbyBigImage.tag = 999;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbyBigImage];
        NSURL *url_NearbyBig = [NSURL URLWithString:[LPhotoArray_Nearby objectAtIndex:0]];
        NSLog(@"%@",url_NearbyBig);
        ShowNearbyBigImage.imageURL = url_NearbyBig;
        
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 321, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Nearby objectAtIndex:0]];
        CGFloat strFloat = (CGFloat)[TempDistanceString floatValue];
        
        //   NSString *FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:0]];
        int x_Nearby = [TempDistanceString intValue];
        NSString *FullShowLocatinString;
        if (x_Nearby < 100) {
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:0]];
        }else{
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Nearby objectAtIndex:0]];
        }
    //    NSLog(@"Location_DistanceArray_Nearby is %@",Location_DistanceArray_Nearby);
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 317, 290, 20);
        ShowLocationLabel.text = FullShowLocatinString;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        
        // ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 349, 290, 30);
        ShowTitleLabel.text = [TitleArray_Nearby objectAtIndex:0];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 399, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Nearby objectAtIndex:0]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 399, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Nearby objectAtIndex:0];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 449, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *BigButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
        [BigButton_Nearby setTitle:@"" forState:UIControlStateNormal];
        [BigButton_Nearby setFrame:CGRectMake(0, 60, 320, 380)];
        [BigButton_Nearby setBackgroundColor:[UIColor clearColor]];
        [BigButton_Nearby addTarget:self action:@selector(BigButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [MainScroll addSubview:ShowNearbyBigImage];
        [MainScroll addSubview:ShowNearbyTitleImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:BigButton_Nearby];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Nearby objectAtIndex:0];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Nearby objectAtIndex:0];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        for (int i = 0; i < [ArrayActivitiesProfilePhoto count]; i++) {
            NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:i]];
            if ([CheckActivitiesString isEqualToString:@"nil"]) {
                
            }else{
                AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
                Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, 260, 30, 30);
                Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
                Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                Activities_ShowUserImage.layer.cornerRadius=15;
                Activities_ShowUserImage.layer.borderWidth=1;
                Activities_ShowUserImage.layer.masksToBounds = YES;
                Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
                NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:i]];
                NSLog(@"activities FullImagesURL2 ====== %@",FullImagesURL2);
                if ([FullImagesURL2 length] == 0) {
                    Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                    Activities_ShowUserImage.imageURL = url_UserImage;
                }
                [MainScroll addSubview:Activities_ShowUserImage];
                
                UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
                ShowMiniIcon.frame = CGRectMake(300 - i * 40, 280, 13, 13);
                NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:i]];
                if ([CheckTypeString isEqualToString:@"like"]) {
                    ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
                }else{
                    ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
                }
                [MainScroll addSubview:ShowMiniIcon];
                
                UIButton *SmallImgButton = [[UIButton alloc]init];
                SmallImgButton.tag = i;
                [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
                [SmallImgButton setFrame:CGRectMake(280 - i * 40, 260, 30, 30)];
                [SmallImgButton setBackgroundColor:[UIColor clearColor]];
                [SmallImgButton addTarget:self action:@selector(SmallImgButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
                
                [MainScroll addSubview:SmallImgButton];
                
                
            }
        }
       
    }
    
    
    int height_Local = 0;
    if ([LPhotoArray_Nearby count] > 1) {
        height_Local = 0;
    }else{
        height_Local = 310;
    }
    
    for (int i = 1; i < [LPhotoArray_Nearby count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, 310 + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_Nearby objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 310 + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Nearby objectAtIndex:i]];
        CGFloat strFloat = (CGFloat)[TempDistanceString floatValue];
        
        //  NSString *FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:i]];
        int x = [TempDistanceString intValue];
        NSString *FullShowLocatinString;
        if (x < 100) {
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:i]];
        }else{
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Nearby objectAtIndex:i]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 306 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 338 + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_Nearby objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 408 + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Nearby objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 408 + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Nearby objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 450 + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_Nearby setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_Nearby setFrame:CGRectMake(0, 320 + i * 158, 320, 120)];
        [SmallButton_Nearby setBackgroundColor:[UIColor clearColor]];
        SmallButton_Nearby.tag = i;
        [SmallButton_Nearby addTarget:self action:@selector(SmallButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
        
        height_Local = 459 + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_Nearby];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Nearby objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Nearby objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, 375 + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, 395 + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, 375 + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Nearby_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
            
            
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
    }
    // NSLog(@"nearby data done.");
    UIImageView *ShowLocalTitleImage = [[UIImageView alloc]init];
    ShowLocalTitleImage.frame = CGRectMake(0, height_Local + 1, 320, 97);
    ShowLocalTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"LocalImg", nil)];
    
    AsyncImageView *ShowLocalBigImage = [[AsyncImageView alloc]init];
    ShowLocalBigImage.frame = CGRectMake(0, height_Local + 60, 320, 241);
    ShowLocalBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowLocalBigImage.backgroundColor = [UIColor clearColor];
    ShowLocalBigImage.clipsToBounds = YES;
    ShowLocalBigImage.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLocalBigImage];
    NSURL *url_LocalBig = [NSURL URLWithString:[LPhotoArray_Local objectAtIndex:0]];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowLocalBigImage.imageURL = url_LocalBig;
    
    
    UIImageView *ShowLocationImage_Local = [[UIImageView alloc]init];
    ShowLocationImage_Local.frame = CGRectMake(15, height_Local + 321, 8, 12);
    ShowLocationImage_Local.image = [UIImage imageNamed:@"LocationPin.png"];
    
    NSString *TempDistanceString_Local = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Local objectAtIndex:0]];
    CGFloat strFloat_Local = (CGFloat)[TempDistanceString_Local floatValue];
    
    // NSString *FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:0]];
    int x_Local = [TempDistanceString_Local intValue];
    NSString *FullShowLocatinString_Local;
    if (x_Local < 100) {
        FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:0]];
    }else{
        FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Local objectAtIndex:0]];
    }
    UILabel *ShowLocationLabel_Local = [[UILabel alloc]init];
    ShowLocationLabel_Local.frame = CGRectMake(30, height_Local + 317, 250, 20);
    ShowLocationLabel_Local.text = FullShowLocatinString_Local;
    ShowLocationLabel_Local.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    //ShowLocationLabel_Local.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [ShowLocationLabel_Local setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    
    UILabel *ShowTitleLabel_Local = [[UILabel alloc]init];
    ShowTitleLabel_Local.frame = CGRectMake(15, height_Local + 349, 300, 30);
    ShowTitleLabel_Local.text = [TitleArray_Local objectAtIndex:0];
    ShowTitleLabel_Local.numberOfLines = 2;
    ShowTitleLabel_Local.textAlignment = NSTextAlignmentLeft;
    ShowTitleLabel_Local.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowTitleLabel_Local.textColor = [UIColor blackColor];
    ShowTitleLabel_Local.backgroundColor = [UIColor clearColor];
    
    AsyncImageView *ShowUserImage_Local = [[AsyncImageView alloc]init];
    ShowUserImage_Local.frame = CGRectMake(15, height_Local + 399, 30, 30);
    ShowUserImage_Local.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserImage_Local.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserImage_Local.layer.cornerRadius=15;
    ShowUserImage_Local.layer.borderWidth=1;
    ShowUserImage_Local.layer.masksToBounds = YES;
    ShowUserImage_Local.layer.borderColor=[[UIColor clearColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage_Local];
    NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Local objectAtIndex:0]];
    NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
    if ([FullImagesURL2 length] == 0) {
        ShowUserImage_Local.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowUserImage_Local.imageURL = url_UserImage;
    }
    
    UILabel *ShowUserName_Local = [[UILabel alloc]init];
    ShowUserName_Local.frame = CGRectMake(60, height_Local + 399, 250, 30);
    ShowUserName_Local.text = [UserInfo_NameArray_Local objectAtIndex:0];
    ShowUserName_Local.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowUserName_Local.textColor = [UIColor lightGrayColor];
    
    UIButton *Line01_Local = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01_Local setTitle:@"" forState:UIControlStateNormal];
    [Line01_Local setFrame:CGRectMake(0, height_Local + 449, 320, 1)];
    [Line01_Local setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    UIButton *BigButton_Local = [UIButton buttonWithType:UIButtonTypeCustom];
    [BigButton_Local setTitle:@"" forState:UIControlStateNormal];
    [BigButton_Local setFrame:CGRectMake(0, height_Local + 60, 320, 380)];
    [BigButton_Local setBackgroundColor:[UIColor clearColor]];
    [BigButton_Local addTarget:self action:@selector(BigButton_Local:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:ShowLocalBigImage];
    [MainScroll addSubview:ShowLocalTitleImage];
    [MainScroll addSubview:ShowLocationLabel_Local];
    [MainScroll addSubview:ShowLocationImage_Local];
    [MainScroll addSubview:ShowTitleLabel_Local];
    [MainScroll addSubview:ShowUserImage_Local];
    [MainScroll addSubview:ShowUserName_Local];
    [MainScroll addSubview:Line01_Local];
    [MainScroll addSubview:BigButton_Local];
    
    NSString *GetActivitiesProfilePhoto_Local = [Activities_profile_photoArray_Local objectAtIndex:0];
    NSArray *SplitArray_ActivitiesProfilePhoto_Local = [GetActivitiesProfilePhoto_Local componentsSeparatedByString:@","];
    NSString *GetActivitiestype_Local = [Activities_typeArray_Local objectAtIndex:0];
    NSArray *SplitArray_Activitiestype_Local = [GetActivitiestype_Local componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesProfilePhoto_Local = [[NSMutableArray alloc]init];
    NSMutableArray *ArrayActivitiestype_Local = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto_Local count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto_Local objectAtIndex:i]];
        [ArrayActivitiesProfilePhoto_Local addObject:GetSplitData];
        NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype_Local objectAtIndex:i]];
        [ArrayActivitiestype_Local addObject:GetSplitData_type];
    }
    
    for (int i = 0; i < [ArrayActivitiesProfilePhoto_Local count]; i++) {
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_Local objectAtIndex:i]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, height_Local + 261, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_Local objectAtIndex:i]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(300 - i * 40, height_Local + 281, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype_Local objectAtIndex:i]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(280 - i * 40, height_Local + 261, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Local:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
    }
    int Height_ForeignLand = 0;
    if ([LPhotoArray_Local count] > 1) {
        Height_ForeignLand = 0;
    }else{
        Height_ForeignLand = height_Local + 310;
    }
    
   
    
    for (int i = 1; i < [LPhotoArray_Local count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, (height_Local + 310) + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_Local objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, (height_Local + 310) + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        
        NSString *TempDistanceString_Local = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Local objectAtIndex:i]];
        CGFloat strFloat_Local = (CGFloat)[TempDistanceString_Local floatValue];
        
        // NSString *FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:i]];
        int x = [TempDistanceString_Local intValue];
        NSString *FullShowLocatinString_Local;
        if (x < 100) {
            FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:i]];
        }else{
            FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Local objectAtIndex:i]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, height_Local + 306 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString_Local;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, (height_Local + 338) + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_Local objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, (height_Local + 408) + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Local objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, (height_Local + 408) + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Local objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, (height_Local + 450) + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_Local = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_Local setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_Local setFrame:CGRectMake(0, (height_Local + 320) + i * 158, 320, 120)];
        [SmallButton_Local setBackgroundColor:[UIColor clearColor]];
        SmallButton_Local.tag = i;
        [SmallButton_Local addTarget:self action:@selector(SmallButton_Local:) forControlEvents:UIControlEventTouchUpInside];
        
        Height_ForeignLand = (height_Local + 459) + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_Local];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Local objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Local objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, (height_Local + 375) + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, (height_Local + 395) + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, (height_Local + 375) + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Local_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
            
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
        
    }
    
    UIImageView *ShowForeignLandTitleImage = [[UIImageView alloc]init];
    ShowForeignLandTitleImage.frame = CGRectMake(0, Height_ForeignLand + 1, 320, 97);
    ShowForeignLandTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"ForeignLandImg", nil)];
    
    AsyncImageView *ShowForeignLandBigImage = [[AsyncImageView alloc]init];
    ShowForeignLandBigImage.frame = CGRectMake(0, Height_ForeignLand + 60, 320, 241);
    ShowForeignLandBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowForeignLandBigImage.backgroundColor = [UIColor clearColor];
    ShowForeignLandBigImage.clipsToBounds = YES;
    ShowForeignLandBigImage.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowForeignLandBigImage];
    NSURL *url_ForeignLandBig = [NSURL URLWithString:[LPhotoArray_ForeignLand objectAtIndex:0]];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowForeignLandBigImage.imageURL = url_ForeignLandBig;
    
    
    UIImageView *ShowLocationImage_ForeignLand = [[UIImageView alloc]init];
    ShowLocationImage_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 321, 8, 12);
    ShowLocationImage_ForeignLand.image = [UIImage imageNamed:@"LocationPin.png"];
    
    NSString *TempDistanceString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_ForeignLand objectAtIndex:0]];
    CGFloat strFloat_ForeignLand = (CGFloat)[TempDistanceString_ForeignLand floatValue];
    
    //    NSString *FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:0]];
    int x_ForeignLand = [TempDistanceString_ForeignLand intValue];
    NSString *FullShowLocatinString_ForeignLand;
    if (x_ForeignLand < 100) {
        FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:0]];
    }else{
        FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[LocationArray_ForeignLand objectAtIndex:0]];
    }
    
    
    UILabel *ShowLocationLabel_ForeignLand = [[UILabel alloc]init];
    ShowLocationLabel_ForeignLand.frame = CGRectMake(30, Height_ForeignLand + 317, 250, 20);
    ShowLocationLabel_ForeignLand.text = FullShowLocatinString_ForeignLand;
    ShowLocationLabel_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    // ShowLocationLabel_ForeignLand.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [ShowLocationLabel_ForeignLand setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    
    UILabel *ShowTitleLabel_ForeignLand = [[UILabel alloc]init];
    ShowTitleLabel_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 349, 300, 30);
    ShowTitleLabel_ForeignLand.text = [TitleArray_ForeignLand objectAtIndex:0];
    ShowTitleLabel_ForeignLand.numberOfLines = 2;
    ShowTitleLabel_ForeignLand.textAlignment = NSTextAlignmentLeft;
    ShowTitleLabel_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowTitleLabel_ForeignLand.textColor = [UIColor blackColor];
    ShowTitleLabel_ForeignLand.backgroundColor = [UIColor clearColor];
    
    AsyncImageView *ShowUserImage_ForeignLand = [[AsyncImageView alloc]init];
    ShowUserImage_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 399, 30, 30);
    ShowUserImage_ForeignLand.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserImage_ForeignLand.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserImage_ForeignLand.layer.cornerRadius=15;
    ShowUserImage_ForeignLand.layer.borderWidth=1;
    ShowUserImage_ForeignLand.layer.masksToBounds = YES;
    ShowUserImage_ForeignLand.layer.borderColor=[[UIColor clearColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage_ForeignLand];
    NSString *FullImagesURL3 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_ForeignLand objectAtIndex:0]];
    NSLog(@"FullImagesURL3 ====== %@",FullImagesURL3);
    if ([FullImagesURL3 length] == 0) {
        ShowUserImage_ForeignLand.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL3];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowUserImage_ForeignLand.imageURL = url_UserImage;
    }
    
    UILabel *ShowUserName_ForeignLand = [[UILabel alloc]init];
    ShowUserName_ForeignLand.frame = CGRectMake(60, Height_ForeignLand + 399, 250, 30);
    ShowUserName_ForeignLand.text = [UserInfo_NameArray_ForeignLand objectAtIndex:0];
    ShowUserName_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowUserName_ForeignLand.textColor = [UIColor lightGrayColor];
    
    UIButton *Line01_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01_ForeignLand setTitle:@"" forState:UIControlStateNormal];
    [Line01_ForeignLand setFrame:CGRectMake(0, Height_ForeignLand + 439, 320, 1)];
    [Line01_ForeignLand setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    UIButton *BigButton_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
    [BigButton_ForeignLand setTitle:@"" forState:UIControlStateNormal];
    [BigButton_ForeignLand setFrame:CGRectMake(0, Height_ForeignLand + 60, 320, 380)];
    [BigButton_ForeignLand setBackgroundColor:[UIColor clearColor]];
    [BigButton_ForeignLand addTarget:self action:@selector(BigButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:ShowForeignLandBigImage];
    [MainScroll addSubview:ShowForeignLandTitleImage];
    [MainScroll addSubview:ShowLocationLabel_ForeignLand];
    [MainScroll addSubview:ShowLocationImage_ForeignLand];
    [MainScroll addSubview:ShowTitleLabel_ForeignLand];
    [MainScroll addSubview:ShowUserImage_ForeignLand];
    [MainScroll addSubview:ShowUserName_ForeignLand];
    [MainScroll addSubview:Line01_ForeignLand];
    [MainScroll addSubview:BigButton_ForeignLand];
    
    NSString *GetActivitiesProfilePhoto_ForeignLand = [Activities_profile_photoArray_ForeignLand objectAtIndex:0];
    NSArray *SplitArray_ActivitiesProfilePhoto_ForeignLand = [GetActivitiesProfilePhoto_ForeignLand componentsSeparatedByString:@","];
    NSString *GetActivitiestype_ForeignLand = [Activities_typeArray_ForeignLand objectAtIndex:0];
    NSArray *SplitArray_Activitiestype_ForeignLand = [GetActivitiestype_ForeignLand componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesProfilePhoto_ForeignLand = [[NSMutableArray alloc]init];
    NSMutableArray *ArrayActivitiestype_ForeignLand = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto_ForeignLand count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
        [ArrayActivitiesProfilePhoto_ForeignLand addObject:GetSplitData];
        NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype_ForeignLand objectAtIndex:i]];
        [ArrayActivitiestype_ForeignLand addObject:GetSplitData_type];
    }
    NSLog(@"Height_ForeignLand is %i",Height_ForeignLand);
    for (int i = 0; i < [ArrayActivitiesProfilePhoto_ForeignLand count]; i++) {
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, Height_ForeignLand + 261, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
            NSLog(@"foreignland FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(300 - i * 40, Height_ForeignLand + 281, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype_ForeignLand objectAtIndex:i]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(280 - i * 40, Height_ForeignLand + 261, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
            
            
        }
    }
    
    int Height_Final = 0;
    if ([LPhotoArray_ForeignLand count] > 1) {
        Height_Final = 0;
    }else{
        Height_Final = Height_ForeignLand + 300;
    }
    
    for (int i = 1; i < [LPhotoArray_ForeignLand count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, (Height_ForeignLand + 300) + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_ForeignLand objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, (Height_ForeignLand + 300) + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        
        NSString *TempDistanceString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_ForeignLand objectAtIndex:i]];
        CGFloat strFloat_ForeignLand = (CGFloat)[TempDistanceString_ForeignLand floatValue];
        int x = [TempDistanceString_ForeignLand intValue];
        NSString *FullShowLocatinString_ForeignLand;
        if (x < 100) {
            FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:i]];
        }else{
            FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[LocationArray_ForeignLand objectAtIndex:i]];
        }
        
        
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, Height_ForeignLand + 296 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString_ForeignLand;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        // ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, (Height_ForeignLand + 328) + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_ForeignLand objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, (Height_ForeignLand + 398) + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_ForeignLand objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, (Height_ForeignLand + 398) + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_ForeignLand objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, (Height_ForeignLand + 435) + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_ForeignLand setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_ForeignLand setFrame:CGRectMake(0, (Height_ForeignLand + 320) + i * 158, 320, 120)];
        [SmallButton_ForeignLand setBackgroundColor:[UIColor clearColor]];
        SmallButton_ForeignLand.tag = i;
        [SmallButton_ForeignLand addTarget:self action:@selector(SmallButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
        
        Height_Final = (Height_ForeignLand + 459) + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_ForeignLand];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_ForeignLand objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_ForeignLand objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, (Height_ForeignLand + 365) + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, (Height_ForeignLand + 385) + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, (Height_ForeignLand + 365) + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_ForeignLand_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
            
            
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
        
    }
    
    UIImageView *ShowExpertsLabelImage = [[UIImageView alloc]init];
    ShowExpertsLabelImage.frame = CGRectMake(0, Height_Final + 1, 320, 64);
    ShowExpertsLabelImage.image = [UIImage imageNamed:CustomLocalisedString(@"ExpertsImg", nil)];
    for (int i = 0; i < 4; i++) {
        AsyncImageView *ShowOtherExpertsImage = [[AsyncImageView alloc]init];
        ShowOtherExpertsImage.frame = CGRectMake(10 + i * 75, Height_Final + 65, 70, 70);
        ShowOtherExpertsImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowOtherExpertsImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowOtherExpertsImage.layer.cornerRadius=35;
        ShowOtherExpertsImage.layer.borderWidth=1;
        ShowOtherExpertsImage.layer.masksToBounds = YES;
        ShowOtherExpertsImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowOtherExpertsImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[featured_userImgArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0) {
            ShowOtherExpertsImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowOtherExpertsImage.imageURL = url_UserImage;
        }
        
        UIButton *OtherExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [OtherExpertsButton setTitle:@"" forState:UIControlStateNormal];
        [OtherExpertsButton setFrame:CGRectMake(10 + i * 75, Height_Final + 65, 70, 70)];
        [OtherExpertsButton setBackgroundColor:[UIColor clearColor]];
        OtherExpertsButton.tag = i;
        [OtherExpertsButton addTarget:self action:@selector(OtherExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:ShowOtherExpertsImage];
        [MainScroll addSubview:OtherExpertsButton];
    }
    
    UIButton *MoreCommendationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [MoreCommendationsButton setTitle:CustomLocalisedString(@"MoreRecommendations", nil) forState:UIControlStateNormal];
    MoreCommendationsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [MoreCommendationsButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:225.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [MoreCommendationsButton setBackgroundImage:[UIImage imageNamed:@"MoreRecommendation.png"] forState:UIControlStateNormal];
    [MoreCommendationsButton setBackgroundImage:[UIImage imageNamed:@"MoreRecommendationHover.png"] forState:UIControlStateHighlighted];
    [MoreCommendationsButton setFrame:CGRectMake(14, Height_Final + 164, 292, 51)];
    [MoreCommendationsButton setBackgroundColor:[UIColor clearColor]];
    [MoreCommendationsButton addTarget:self action:@selector(MoreCommendationsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:ShowExpertsLabelImage];
    [MainScroll addSubview:MoreCommendationsButton];
    
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll setContentSize:CGSizeMake(320, Height_Final + 230)];
    
   

}
-(IBAction)BigButton_Nearby:(id)sender{
    NSLog(@"Nearby Button Click");
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_Nearby objectAtIndex:0]];
//    [FeedDetailView GetPostID:[PostIDArray_Nearby objectAtIndex:0] GetUserUid:[UserInfo_uidArray_Nearby objectAtIndex:0] GetUserFollowing:[UserInfo_FollowingArray_Nearby objectAtIndex:0] GetCheckLike:[CheckLikeArray_Nearby objectAtIndex:0] GetLink:[Link_Array_Nearby objectAtIndex:0]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_Nearby objectAtIndex:0] GetTitle:[TitleArray_Nearby objectAtIndex:0] GetUserName:[UserInfo_NameArray_Nearby objectAtIndex:0] GetUserProfilePhoto:[UserInfo_UrlArray_Nearby objectAtIndex:0] GetMessage:[MessageArray_Nearby objectAtIndex:0] GetUserAddress:[UserInfo_AddressArray_Nearby objectAtIndex:0] GetCategory:[CategoryArray_Nearby objectAtIndex:0] GetTotalLikes:[LikesArray_Nearby objectAtIndex:0] GetTotalComment:[CommentArray_Nearby objectAtIndex:0]];
//    [FeedDetailView GetLat:[LatArray_Nearby objectAtIndex:0] GetLong:[LongArray_Nearby objectAtIndex:0] GetLocation:[LocationArray_Nearby objectAtIndex:0]];
      [FeedDetailView GetPostID:[PostIDArray_Nearby objectAtIndex:0]];
}
-(IBAction)BigButton_Local:(id)sender{
    NSLog(@"Local Button Click");
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_Local objectAtIndex:0]];
//        [FeedDetailView GetPostID:[PostIDArray_Local objectAtIndex:0] GetUserUid:[UserInfo_uidArray_Local objectAtIndex:0] GetUserFollowing:[UserInfo_FollowingArray_Local objectAtIndex:0] GetCheckLike:[CheckLikeArray_Local objectAtIndex:0] GetLink:[Link_Array_Local objectAtIndex:0]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_Local objectAtIndex:0] GetTitle:[TitleArray_Local objectAtIndex:0] GetUserName:[UserInfo_NameArray_Local objectAtIndex:0] GetUserProfilePhoto:[UserInfo_UrlArray_Local objectAtIndex:0] GetMessage:[MessageArray_Local objectAtIndex:0] GetUserAddress:[UserInfo_AddressArray_Local objectAtIndex:0] GetCategory:[CategoryArray_Local objectAtIndex:0] GetTotalLikes:[LikesArray_Local objectAtIndex:0] GetTotalComment:[CommentArray_Local objectAtIndex:0]];
//    [FeedDetailView GetLat:[LatArray_Local objectAtIndex:0] GetLong:[LongArray_Local objectAtIndex:0] GetLocation:[LocationArray_Local objectAtIndex:0]];
    [FeedDetailView GetPostID:[PostIDArray_Local objectAtIndex:0]];
}
-(IBAction)BigButton_ForeignLand:(id)sender{
    NSLog(@"ForeignLand Button Click");
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_ForeignLand objectAtIndex:0]];
//        [FeedDetailView GetPostID:[PostIDArray_FOreignLand objectAtIndex:0] GetUserUid:[UserInfo_uidArray_ForeignLand objectAtIndex:0] GetUserFollowing:[UserInfo_FollowingArray_ForeignLand objectAtIndex:0] GetCheckLike:[CheckLikeArray_ForeignLand objectAtIndex:0] GetLink:[Link_Array_ForeignLand objectAtIndex:0]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_ForeignLand objectAtIndex:0] GetTitle:[TitleArray_ForeignLand objectAtIndex:0] GetUserName:[UserInfo_NameArray_ForeignLand objectAtIndex:0] GetUserProfilePhoto:[UserInfo_UrlArray_ForeignLand objectAtIndex:0] GetMessage:[MessageArray_ForeignLand objectAtIndex:0] GetUserAddress:[UserInfo_AddressArray_ForeignLand objectAtIndex:0] GetCategory:[CategoryArray_ForeignLand objectAtIndex:0] GetTotalLikes:[LikesArray_ForeignLand objectAtIndex:0] GetTotalComment:[CommentArray_ForeignLand objectAtIndex:0]];
//    [FeedDetailView GetLat:[LatArray_ForeignLand objectAtIndex:0] GetLong:[LongArray_ForeignLand objectAtIndex:0] GetLocation:[LocationArray_ForeignLand objectAtIndex:0]];
    [FeedDetailView GetPostID:[PostIDArray_FOreignLand objectAtIndex:0]];
}
-(IBAction)SmallButton_Nearby:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_Nearby objectAtIndex:getbuttonIDN]];
//        [FeedDetailView GetPostID:[PostIDArray_Nearby objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray_Nearby objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray_Nearby objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray_Nearby objectAtIndex:getbuttonIDN] GetLink:[Link_Array_Nearby objectAtIndex:getbuttonIDN]];
//        [FeedDetailView GetImageArray:[FullPhotoArray_Nearby objectAtIndex:getbuttonIDN] GetTitle:[TitleArray_Nearby objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray_Nearby objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray_Nearby objectAtIndex:getbuttonIDN] GetMessage:[MessageArray_Nearby objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray_Nearby objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray_Nearby objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray_Nearby objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray_Nearby objectAtIndex:getbuttonIDN]];
//        [FeedDetailView GetLat:[LatArray_Nearby objectAtIndex:getbuttonIDN] GetLong:[LongArray_Nearby objectAtIndex:getbuttonIDN] GetLocation:[LocationArray_Nearby objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray_Nearby objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallButton_Local:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_Local objectAtIndex:getbuttonIDN]];
//            [FeedDetailView GetPostID:[PostIDArray_Local objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray_Local objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray_Local objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray_Local objectAtIndex:getbuttonIDN] GetLink:[Link_Array_Local objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_Local objectAtIndex:getbuttonIDN] GetTitle:[TitleArray_Local objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray_Local objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray_Local objectAtIndex:getbuttonIDN] GetMessage:[MessageArray_Local objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray_Local objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray_Local objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray_Local objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray_Local objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray_Local objectAtIndex:getbuttonIDN] GetLong:[LongArray_Local objectAtIndex:getbuttonIDN] GetLocation:[LocationArray_Local objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray_Local objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallButton_ForeignLand:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_ForeignLand objectAtIndex:getbuttonIDN]];
//            [FeedDetailView GetPostID:[PostIDArray_FOreignLand objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray_ForeignLand objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray_ForeignLand objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray_ForeignLand objectAtIndex:getbuttonIDN] GetLink:[Link_Array_ForeignLand objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_ForeignLand objectAtIndex:getbuttonIDN] GetTitle:[TitleArray_ForeignLand objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray_ForeignLand objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray_ForeignLand objectAtIndex:getbuttonIDN] GetMessage:[MessageArray_ForeignLand objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray_ForeignLand objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray_ForeignLand objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray_ForeignLand objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray_ForeignLand objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray_ForeignLand objectAtIndex:getbuttonIDN] GetLong:[LongArray_ForeignLand objectAtIndex:getbuttonIDN] GetLocation:[LocationArray_ForeignLand objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray_FOreignLand objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallButton_Extra:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray_Extra objectAtIndex:getbuttonIDN]];
//            [FeedDetailView GetPostID:[PostIDArray_Extra objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray_Extra objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray_Extra objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray_Extra objectAtIndex:getbuttonIDN] GetLink:[Link_Array_Extra objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray_Extra objectAtIndex:getbuttonIDN] GetTitle:[TitleArray_Extra objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray_Extra objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray_Extra objectAtIndex:getbuttonIDN] GetMessage:[MessageArray_Extra objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray_Extra objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray_Extra objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray_Extra objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray_Extra objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray_Extra objectAtIndex:getbuttonIDN] GetLong:[LongArray_Extra objectAtIndex:getbuttonIDN] GetLocation:[LocationArray_Extra objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray_Extra objectAtIndex:getbuttonIDN]];
}
-(IBAction)MoreCommendationsButtonClick:(id)sender{
    for (UIView *subview in MainScroll.subviews) {
       // if ([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }

    

    [self InitExtraView];
}
-(void)InitExtraView{

    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    
    if ([TitleArray_Nearby count] == 0) {
        NSLog(@"TItle Array Nearby nil");
    }else{
        NSLog(@"got title");
        UIImageView *ShowNearbyTitleImage = [[UIImageView alloc]init];
        ShowNearbyTitleImage.frame = CGRectMake(0, 0, 320, 97);
        ShowNearbyTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"NearbyImg", nil)];
        
        AsyncImageView *ShowNearbyBigImage = [[AsyncImageView alloc]init];
        ShowNearbyBigImage.frame = CGRectMake(0, 60, 320, 241);
        ShowNearbyBigImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbyBigImage.backgroundColor = [UIColor clearColor];
        ShowNearbyBigImage.clipsToBounds = YES;
        //ShowNearbyBigImage.tag = 999;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbyBigImage];
        NSURL *url_NearbyBig = [NSURL URLWithString:[LPhotoArray_Nearby objectAtIndex:0]];
        NSLog(@"%@",url_NearbyBig);
        ShowNearbyBigImage.imageURL = url_NearbyBig;
        
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 321, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Nearby objectAtIndex:0]];
        CGFloat strFloat = (CGFloat)[TempDistanceString floatValue];
        
        //   NSString *FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:0]];
        int x_Nearby = [TempDistanceString intValue];
        NSString *FullShowLocatinString;
        if (x_Nearby < 100) {
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:0]];
        }else{
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Nearby objectAtIndex:0]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 317, 290, 20);
        ShowLocationLabel.text = FullShowLocatinString;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        
        // ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 349, 290, 30);
        ShowTitleLabel.text = [TitleArray_Nearby objectAtIndex:0];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 399, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Nearby objectAtIndex:0]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 399, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Nearby objectAtIndex:0];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 449, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *BigButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
        [BigButton_Nearby setTitle:@"" forState:UIControlStateNormal];
        [BigButton_Nearby setFrame:CGRectMake(0, 60, 320, 380)];
        [BigButton_Nearby setBackgroundColor:[UIColor clearColor]];
        [BigButton_Nearby addTarget:self action:@selector(BigButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [MainScroll addSubview:ShowNearbyBigImage];
        [MainScroll addSubview:ShowNearbyTitleImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:BigButton_Nearby];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Nearby objectAtIndex:0];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Nearby objectAtIndex:0];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        for (int i = 0; i < [ArrayActivitiesProfilePhoto count]; i++) {
            NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:i]];
            if ([CheckActivitiesString isEqualToString:@"nil"]) {
                
            }else{
                AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
                Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, 260, 30, 30);
                Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
                Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                Activities_ShowUserImage.layer.cornerRadius=15;
                Activities_ShowUserImage.layer.borderWidth=1;
                Activities_ShowUserImage.layer.masksToBounds = YES;
                Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
                NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:i]];
                NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
                if ([FullImagesURL2 length] == 0) {
                    Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                    Activities_ShowUserImage.imageURL = url_UserImage;
                }
                [MainScroll addSubview:Activities_ShowUserImage];
                
                UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
                ShowMiniIcon.frame = CGRectMake(300 - i * 40, 280, 13, 13);
                NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:i]];
                if ([CheckTypeString isEqualToString:@"like"]) {
                    ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
                }else{
                    ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
                }
                [MainScroll addSubview:ShowMiniIcon];
                
                UIButton *SmallImgButton = [[UIButton alloc]init];
                SmallImgButton.tag = i;
                [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
                [SmallImgButton setFrame:CGRectMake(280 - i * 40, 260, 30, 30)];
                [SmallImgButton setBackgroundColor:[UIColor clearColor]];
                [SmallImgButton addTarget:self action:@selector(SmallImgButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
                
                [MainScroll addSubview:SmallImgButton];
                
                
            }
        }
    }
    
   
    
    int height_Local = 0;
    if ([LPhotoArray_Nearby count] > 1) {
        height_Local = 0;
    }else{
        height_Local = 310;
    }
    
    for (int i = 1; i < [LPhotoArray_Nearby count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, 310 + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_Nearby objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 310 + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Nearby objectAtIndex:i]];
        CGFloat strFloat = (CGFloat)[TempDistanceString floatValue];
        
        //  NSString *FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:i]];
        int x = [TempDistanceString intValue];
        NSString *FullShowLocatinString;
        if (x < 100) {
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat,[LocationArray_Nearby objectAtIndex:i]];
        }else{
            FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Nearby objectAtIndex:i]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 306 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 338 + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_Nearby objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 408 + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Nearby objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 408 + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Nearby objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 450 + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_Nearby setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_Nearby setFrame:CGRectMake(0, 320 + i * 158, 320, 120)];
        [SmallButton_Nearby setBackgroundColor:[UIColor clearColor]];
        SmallButton_Nearby.tag = i;
        [SmallButton_Nearby addTarget:self action:@selector(SmallButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
        
        height_Local = 459 + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_Nearby];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Nearby objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Nearby objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, 375 + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, 395 + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, 375 + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Nearby_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
    }
    
    UIImageView *ShowLocalTitleImage = [[UIImageView alloc]init];
    ShowLocalTitleImage.frame = CGRectMake(0, height_Local + 1, 320, 97);
    ShowLocalTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"LocalImg", nil)];
    
    AsyncImageView *ShowLocalBigImage = [[AsyncImageView alloc]init];
    ShowLocalBigImage.frame = CGRectMake(0, height_Local + 60, 320, 241);
    ShowLocalBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowLocalBigImage.backgroundColor = [UIColor clearColor];
    ShowLocalBigImage.clipsToBounds = YES;
    ShowLocalBigImage.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowLocalBigImage];
    NSURL *url_LocalBig = [NSURL URLWithString:[LPhotoArray_Local objectAtIndex:0]];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowLocalBigImage.imageURL = url_LocalBig;
    
    
    UIImageView *ShowLocationImage_Local = [[UIImageView alloc]init];
    ShowLocationImage_Local.frame = CGRectMake(15, height_Local + 321, 8, 12);
    ShowLocationImage_Local.image = [UIImage imageNamed:@"LocationPin.png"];
    
    NSString *TempDistanceString_Local = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Local objectAtIndex:0]];
    CGFloat strFloat_Local = (CGFloat)[TempDistanceString_Local floatValue];
    
    // NSString *FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:0]];
    int x_Local = [TempDistanceString_Local intValue];
    NSString *FullShowLocatinString_Local;
    if (x_Local < 100) {
        FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:0]];
    }else{
        FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Local objectAtIndex:0]];
    }
    UILabel *ShowLocationLabel_Local = [[UILabel alloc]init];
    ShowLocationLabel_Local.frame = CGRectMake(30, height_Local + 317, 250, 20);
    ShowLocationLabel_Local.text = FullShowLocatinString_Local;
    ShowLocationLabel_Local.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    //ShowLocationLabel_Local.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [ShowLocationLabel_Local setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    
    UILabel *ShowTitleLabel_Local = [[UILabel alloc]init];
    ShowTitleLabel_Local.frame = CGRectMake(15, height_Local + 349, 300, 30);
    ShowTitleLabel_Local.text = [TitleArray_Local objectAtIndex:0];
    ShowTitleLabel_Local.numberOfLines = 2;
    ShowTitleLabel_Local.textAlignment = NSTextAlignmentLeft;
    ShowTitleLabel_Local.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowTitleLabel_Local.textColor = [UIColor blackColor];
    ShowTitleLabel_Local.backgroundColor = [UIColor clearColor];
    
    AsyncImageView *ShowUserImage_Local = [[AsyncImageView alloc]init];
    ShowUserImage_Local.frame = CGRectMake(15, height_Local + 399, 30, 30);
    ShowUserImage_Local.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserImage_Local.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserImage_Local.layer.cornerRadius=15;
    ShowUserImage_Local.layer.borderWidth=1;
    ShowUserImage_Local.layer.masksToBounds = YES;
    ShowUserImage_Local.layer.borderColor=[[UIColor clearColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage_Local];
    NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Local objectAtIndex:0]];
    NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
    if ([FullImagesURL2 length] == 0) {
        ShowUserImage_Local.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowUserImage_Local.imageURL = url_UserImage;
    }
    
    UILabel *ShowUserName_Local = [[UILabel alloc]init];
    ShowUserName_Local.frame = CGRectMake(60, height_Local + 399, 250, 30);
    ShowUserName_Local.text = [UserInfo_NameArray_Local objectAtIndex:0];
    ShowUserName_Local.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowUserName_Local.textColor = [UIColor lightGrayColor];
    
    UIButton *Line01_Local = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01_Local setTitle:@"" forState:UIControlStateNormal];
    [Line01_Local setFrame:CGRectMake(0, height_Local + 449, 320, 1)];
    [Line01_Local setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    UIButton *BigButton_Local = [UIButton buttonWithType:UIButtonTypeCustom];
    [BigButton_Local setTitle:@"" forState:UIControlStateNormal];
    [BigButton_Local setFrame:CGRectMake(0, height_Local + 60, 320, 380)];
    [BigButton_Local setBackgroundColor:[UIColor clearColor]];
    [BigButton_Local addTarget:self action:@selector(BigButton_Local:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:ShowLocalBigImage];
    [MainScroll addSubview:ShowLocalTitleImage];
    [MainScroll addSubview:ShowLocationLabel_Local];
    [MainScroll addSubview:ShowLocationImage_Local];
    [MainScroll addSubview:ShowTitleLabel_Local];
    [MainScroll addSubview:ShowUserImage_Local];
    [MainScroll addSubview:ShowUserName_Local];
    [MainScroll addSubview:Line01_Local];
    [MainScroll addSubview:BigButton_Local];
    
    NSString *GetActivitiesProfilePhoto_Local = [Activities_profile_photoArray_Local objectAtIndex:0];
    NSArray *SplitArray_ActivitiesProfilePhoto_Local = [GetActivitiesProfilePhoto_Local componentsSeparatedByString:@","];
    NSString *GetActivitiestype_Local = [Activities_typeArray_Local objectAtIndex:0];
    NSArray *SplitArray_Activitiestype_Local = [GetActivitiestype_Local componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesProfilePhoto_Local = [[NSMutableArray alloc]init];
    NSMutableArray *ArrayActivitiestype_Local = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto_Local count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto_Local objectAtIndex:i]];
        [ArrayActivitiesProfilePhoto_Local addObject:GetSplitData];
        NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype_Local objectAtIndex:i]];
        [ArrayActivitiestype_Local addObject:GetSplitData_type];
    }
    
    for (int i = 0; i < [ArrayActivitiesProfilePhoto_Local count]; i++) {
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_Local objectAtIndex:i]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, height_Local + 261, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_Local objectAtIndex:i]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(300 - i * 40, height_Local + 281, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype_Local objectAtIndex:i]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(280 - i * 40, height_Local + 261, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Local:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
    }
    
    int Height_ForeignLand = 0;
    if ([LPhotoArray_Local count] > 1) {
        Height_ForeignLand = 0;
    }else{
        Height_ForeignLand = height_Local + 310;
    }
    
    for (int i = 1; i < [LPhotoArray_Local count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, (height_Local + 310) + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_Local objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, (height_Local + 310) + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        
        NSString *TempDistanceString_Local = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Local objectAtIndex:i]];
        CGFloat strFloat_Local = (CGFloat)[TempDistanceString_Local floatValue];
        
        // NSString *FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:i]];
        int x = [TempDistanceString_Local intValue];
        NSString *FullShowLocatinString_Local;
        if (x < 100) {
            FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Local,[LocationArray_Local objectAtIndex:i]];
        }else{
            FullShowLocatinString_Local = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Local objectAtIndex:i]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, height_Local + 306 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString_Local;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        //ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, (height_Local + 338) + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_Local objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, (height_Local + 408) + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Local objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, (height_Local + 408) + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Local objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, (height_Local + 450) + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_Local = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_Local setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_Local setFrame:CGRectMake(0, (height_Local + 320) + i * 158, 320, 120)];
        [SmallButton_Local setBackgroundColor:[UIColor clearColor]];
        SmallButton_Local.tag = i;
        [SmallButton_Local addTarget:self action:@selector(SmallButton_Local:) forControlEvents:UIControlEventTouchUpInside];
        
        Height_ForeignLand = (height_Local + 459) + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_Local];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Local objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Local objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, (height_Local + 375) + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, (height_Local + 395) + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, (height_Local + 375) + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Local_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
        
    }
    
    UIImageView *ShowForeignLandTitleImage = [[UIImageView alloc]init];
    ShowForeignLandTitleImage.frame = CGRectMake(0, Height_ForeignLand + 1, 320, 97);
    ShowForeignLandTitleImage.image = [UIImage imageNamed:CustomLocalisedString(@"ForeignLandImg", nil)];
    
    AsyncImageView *ShowForeignLandBigImage = [[AsyncImageView alloc]init];
    ShowForeignLandBigImage.frame = CGRectMake(0, Height_ForeignLand + 60, 320, 241);
    ShowForeignLandBigImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowForeignLandBigImage.backgroundColor = [UIColor clearColor];
    ShowForeignLandBigImage.clipsToBounds = YES;
    ShowForeignLandBigImage.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowForeignLandBigImage];
    NSURL *url_ForeignLandBig = [NSURL URLWithString:[LPhotoArray_ForeignLand objectAtIndex:0]];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowForeignLandBigImage.imageURL = url_ForeignLandBig;
    
    
    UIImageView *ShowLocationImage_ForeignLand = [[UIImageView alloc]init];
    ShowLocationImage_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 321, 8, 12);
    ShowLocationImage_ForeignLand.image = [UIImage imageNamed:@"LocationPin.png"];
    
    NSString *TempDistanceString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_ForeignLand objectAtIndex:0]];
    CGFloat strFloat_ForeignLand = (CGFloat)[TempDistanceString_ForeignLand floatValue];
    
    //    NSString *FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:0]];
    int x_ForeignLand = [TempDistanceString_ForeignLand intValue];
    NSString *FullShowLocatinString_ForeignLand;
    if (x_ForeignLand < 100) {
        FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:0]];
    }else{
        FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[LocationArray_ForeignLand objectAtIndex:0]];
    }
    
    
    UILabel *ShowLocationLabel_ForeignLand = [[UILabel alloc]init];
    ShowLocationLabel_ForeignLand.frame = CGRectMake(30, Height_ForeignLand + 317, 250, 20);
    ShowLocationLabel_ForeignLand.text = FullShowLocatinString_ForeignLand;
    ShowLocationLabel_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    // ShowLocationLabel_ForeignLand.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [ShowLocationLabel_ForeignLand setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    
    UILabel *ShowTitleLabel_ForeignLand = [[UILabel alloc]init];
    ShowTitleLabel_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 349, 300, 30);
    ShowTitleLabel_ForeignLand.text = [TitleArray_ForeignLand objectAtIndex:0];
    ShowTitleLabel_ForeignLand.numberOfLines = 2;
    ShowTitleLabel_ForeignLand.textAlignment = NSTextAlignmentLeft;
    ShowTitleLabel_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowTitleLabel_ForeignLand.textColor = [UIColor blackColor];
    ShowTitleLabel_ForeignLand.backgroundColor = [UIColor clearColor];
    
    AsyncImageView *ShowUserImage_ForeignLand = [[AsyncImageView alloc]init];
    ShowUserImage_ForeignLand.frame = CGRectMake(15, Height_ForeignLand + 399, 30, 30);
    ShowUserImage_ForeignLand.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserImage_ForeignLand.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserImage_ForeignLand.layer.cornerRadius=15;
    ShowUserImage_ForeignLand.layer.borderWidth=1;
    ShowUserImage_ForeignLand.layer.masksToBounds = YES;
    ShowUserImage_ForeignLand.layer.borderColor=[[UIColor clearColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage_ForeignLand];
    NSString *FullImagesURL3 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_ForeignLand objectAtIndex:0]];
    NSLog(@"FullImagesURL3 ====== %@",FullImagesURL3);
    if ([FullImagesURL3 length] == 0) {
        ShowUserImage_ForeignLand.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL3];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowUserImage_ForeignLand.imageURL = url_UserImage;
    }
    
    UILabel *ShowUserName_ForeignLand = [[UILabel alloc]init];
    ShowUserName_ForeignLand.frame = CGRectMake(60, Height_ForeignLand + 399, 250, 30);
    ShowUserName_ForeignLand.text = [UserInfo_NameArray_ForeignLand objectAtIndex:0];
    ShowUserName_ForeignLand.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowUserName_ForeignLand.textColor = [UIColor lightGrayColor];
    
    UIButton *Line01_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01_ForeignLand setTitle:@"" forState:UIControlStateNormal];
    [Line01_ForeignLand setFrame:CGRectMake(0, Height_ForeignLand + 439, 320, 1)];
    [Line01_ForeignLand setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    UIButton *BigButton_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
    [BigButton_ForeignLand setTitle:@"" forState:UIControlStateNormal];
    [BigButton_ForeignLand setFrame:CGRectMake(0, Height_ForeignLand + 60, 320, 380)];
    [BigButton_ForeignLand setBackgroundColor:[UIColor clearColor]];
    [BigButton_ForeignLand addTarget:self action:@selector(BigButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:ShowForeignLandBigImage];
    [MainScroll addSubview:ShowForeignLandTitleImage];
    [MainScroll addSubview:ShowLocationLabel_ForeignLand];
    [MainScroll addSubview:ShowLocationImage_ForeignLand];
    [MainScroll addSubview:ShowTitleLabel_ForeignLand];
    [MainScroll addSubview:ShowUserImage_ForeignLand];
    [MainScroll addSubview:ShowUserName_ForeignLand];
    [MainScroll addSubview:Line01_ForeignLand];
    [MainScroll addSubview:BigButton_ForeignLand];
    
    NSString *GetActivitiesProfilePhoto_ForeignLand = [Activities_profile_photoArray_ForeignLand objectAtIndex:0];
    NSArray *SplitArray_ActivitiesProfilePhoto_ForeignLand = [GetActivitiesProfilePhoto_ForeignLand componentsSeparatedByString:@","];
    NSString *GetActivitiestype_ForeignLand = [Activities_typeArray_ForeignLand objectAtIndex:0];
    NSArray *SplitArray_Activitiestype_ForeignLand = [GetActivitiestype_ForeignLand componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesProfilePhoto_ForeignLand = [[NSMutableArray alloc]init];
    NSMutableArray *ArrayActivitiestype_ForeignLand = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto_ForeignLand count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
        [ArrayActivitiesProfilePhoto_ForeignLand addObject:GetSplitData];
        NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype_ForeignLand objectAtIndex:i]];
        [ArrayActivitiestype_ForeignLand addObject:GetSplitData_type];
    }
    
    for (int i = 0; i < [ArrayActivitiesProfilePhoto_ForeignLand count]; i++) {
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(280 - i * 40, Height_ForeignLand + 261, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto_ForeignLand objectAtIndex:i]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(300 - i * 40, Height_ForeignLand + 281, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype_ForeignLand objectAtIndex:i]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(280 - i * 40, Height_ForeignLand + 261, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
    }
    
    int Height_Final = 0;
    if ([LPhotoArray_ForeignLand count] > 1) {
        Height_Final = 0;
    }else{
        Height_Final = Height_ForeignLand + 300;
    }
    for (int i = 1; i < [LPhotoArray_ForeignLand count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, (Height_ForeignLand + 300) + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_ForeignLand objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, (Height_ForeignLand + 300) + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        
        NSString *TempDistanceString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_ForeignLand objectAtIndex:i]];
        CGFloat strFloat_ForeignLand = (CGFloat)[TempDistanceString_ForeignLand floatValue];
        int x = [TempDistanceString_ForeignLand intValue];
        NSString *FullShowLocatinString_ForeignLand;
        if (x < 100) {
            FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_ForeignLand,[LocationArray_ForeignLand objectAtIndex:i]];
        }else{
            FullShowLocatinString_ForeignLand = [[NSString alloc]initWithFormat:@"%@",[LocationArray_ForeignLand objectAtIndex:i]];
        }
        
        
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, Height_ForeignLand + 296 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString_ForeignLand;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        // ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [ShowLocationLabel setTextColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, (Height_ForeignLand + 328) + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_ForeignLand objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, (Height_ForeignLand + 398) + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_ForeignLand objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, (Height_ForeignLand + 398) + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_ForeignLand objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, (Height_ForeignLand + 435) + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_ForeignLand = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_ForeignLand setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_ForeignLand setFrame:CGRectMake(0, (Height_ForeignLand + 320) + i * 158, 320, 120)];
        [SmallButton_ForeignLand setBackgroundColor:[UIColor clearColor]];
        SmallButton_ForeignLand.tag = i;
        [SmallButton_ForeignLand addTarget:self action:@selector(SmallButton_ForeignLand:) forControlEvents:UIControlEventTouchUpInside];
        
        Height_Final = (Height_ForeignLand + 459) + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_ForeignLand];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_ForeignLand objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_ForeignLand objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, (Height_ForeignLand + 365) + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL2 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, (Height_ForeignLand + 385) + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, (Height_ForeignLand + 365) + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_ForeignLand_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
            
        }
        
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
        
    }
    
    UIImageView *ShowExpertsLabelImage = [[UIImageView alloc]init];
    ShowExpertsLabelImage.frame = CGRectMake(0, Height_Final, 320, 64);
    ShowExpertsLabelImage.image = [UIImage imageNamed:CustomLocalisedString(@"ExpertsImg", nil)];
    for (int i = 0; i < 4; i++) {
        AsyncImageView *ShowOtherExpertsImage = [[AsyncImageView alloc]init];
        ShowOtherExpertsImage.frame = CGRectMake(10 + i * 75, Height_Final + 65, 70, 70);
        ShowOtherExpertsImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowOtherExpertsImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowOtherExpertsImage.layer.cornerRadius=35;
        ShowOtherExpertsImage.layer.borderWidth=1;
        ShowOtherExpertsImage.layer.masksToBounds = YES;
        ShowOtherExpertsImage.layer.borderColor=[[UIColor clearColor] CGColor];
        ShowOtherExpertsImage.image = [UIImage imageNamed:@"avatar.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowOtherExpertsImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[featured_userImgArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0) {
            ShowOtherExpertsImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowOtherExpertsImage.imageURL = url_UserImage;
        }
        
        UIButton *OtherExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [OtherExpertsButton setTitle:@"" forState:UIControlStateNormal];
        [OtherExpertsButton setFrame:CGRectMake(10 + i * 75, Height_Final + 65, 70, 70)];
        [OtherExpertsButton setBackgroundColor:[UIColor clearColor]];
        OtherExpertsButton.tag = i;
        [OtherExpertsButton addTarget:self action:@selector(OtherExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:ShowOtherExpertsImage];
        [MainScroll addSubview:OtherExpertsButton];
    }
    
    UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setFrame:CGRectMake(0, Height_Final + 155, 320, 1)];
    [Line02 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    
    [MainScroll addSubview:ShowExpertsLabelImage];
    [MainScroll addSubview:Line02];
    
    int Height_Extra = 0;
    if ([LPhotoArray_Extra count] > 1) {
        Height_Extra = 0;
    }else{
        Height_Extra = Height_Final + 175;
    }
    for (int i = 0; i < [LPhotoArray_Extra count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, (Height_Final + 175) + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray_Extra objectAtIndex:i]];
        //NSLog(@"url is %@",url);
        ShowNearbySmallImage.imageURL = url_NearbySmall;
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, (Height_Final + 175) + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempDistanceString_Extra = [[NSString alloc]initWithFormat:@"%@",[Location_DistanceArray_Extra objectAtIndex:i]];
        CGFloat strFloat_Extra = (CGFloat)[TempDistanceString_Extra floatValue];
        
       // NSString *TempDistanceString_Extra = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Extra,[LocationArray_Extra objectAtIndex:i]];
        int x = [TempDistanceString_Extra intValue];
        NSString *FullShowLocatinString_Extra;
        if (x < 100) {
            FullShowLocatinString_Extra = [[NSString alloc]initWithFormat:@"%.2f km • %@",strFloat_Extra,[LocationArray_Extra objectAtIndex:i]];
        }else{
            FullShowLocatinString_Extra = [[NSString alloc]initWithFormat:@"%@",[LocationArray_Extra objectAtIndex:i]];
        }
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, Height_Final + 171 + i * 158, 165, 20);
        ShowLocationLabel.text = FullShowLocatinString_Extra;
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, (Height_Final + 203) + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray_Extra objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, (Height_Final + 273) + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Extra objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, (Height_Final + 273) + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray_Extra objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, (Height_Final + 313) + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        
        UIButton *SmallButton_Extra = [UIButton buttonWithType:UIButtonTypeCustom];
        [SmallButton_Extra setTitle:@"" forState:UIControlStateNormal];
        [SmallButton_Extra setFrame:CGRectMake(0, (Height_Final + 204) + i * 150, 320, 120)];
        [SmallButton_Extra setBackgroundColor:[UIColor clearColor]];
        SmallButton_Extra.tag = i;
        [SmallButton_Extra addTarget:self action:@selector(SmallButton_Extra:) forControlEvents:UIControlEventTouchUpInside];
        
        Height_Extra = (Height_Final + 352) + i * 158;
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:SmallButton_Extra];
        
        NSString *GetActivitiesProfilePhoto = [Activities_profile_photoArray_Extra objectAtIndex:i];
        NSArray *SplitArray_ActivitiesProfilePhoto = [GetActivitiesProfilePhoto componentsSeparatedByString:@","];
        NSString *GetActivitiestype = [Activities_typeArray_Extra objectAtIndex:i];
        NSArray *SplitArray_Activitiestype = [GetActivitiestype componentsSeparatedByString:@","];
        
        NSMutableArray *ArrayActivitiesProfilePhoto = [[NSMutableArray alloc]init];
        NSMutableArray *ArrayActivitiestype = [[NSMutableArray alloc]init];
        for (int i = 0; i < [SplitArray_ActivitiesProfilePhoto count]; i++) {
            NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesProfilePhoto objectAtIndex:i]];
            [ArrayActivitiesProfilePhoto addObject:GetSplitData];
            NSString *GetSplitData_type = [[NSString alloc]initWithFormat:@"%@",[SplitArray_Activitiestype objectAtIndex:i]];
            [ArrayActivitiestype addObject:GetSplitData_type];
        }
        
        NSString *CheckActivitiesString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
        if ([CheckActivitiesString isEqualToString:@"nil"]) {
            
        }else{
            AsyncImageView *Activities_ShowUserImage = [[AsyncImageView alloc]init];
            Activities_ShowUserImage.frame = CGRectMake(270, (Height_Final + 240) + i * 158, 30, 30);
            Activities_ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
            Activities_ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            Activities_ShowUserImage.layer.cornerRadius=15;
            Activities_ShowUserImage.layer.borderWidth=1;
            Activities_ShowUserImage.layer.masksToBounds = YES;
            Activities_ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:Activities_ShowUserImage];
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiesProfilePhoto objectAtIndex:0]];
            NSLog(@"FullImagesURL2 ====== %@",FullImagesURL2);
            if ([FullImagesURL1 length] == 0) {
                Activities_ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                Activities_ShowUserImage.imageURL = url_UserImage;
            }
            [MainScroll addSubview:Activities_ShowUserImage];
            
            UIImageView *ShowMiniIcon = [[UIImageView alloc]init];
            ShowMiniIcon.frame = CGRectMake(290, (Height_Final + 260) + i * 158, 13, 13);
            NSString *CheckTypeString = [[NSString alloc]initWithFormat:@"%@",[ArrayActivitiestype objectAtIndex:0]];
            if ([CheckTypeString isEqualToString:@"like"]) {
                ShowMiniIcon.image = [UIImage imageNamed:@"Like.png"];
            }else{
                ShowMiniIcon.image = [UIImage imageNamed:@"Comment.png"];
            }
            [MainScroll addSubview:ShowMiniIcon];
            
            UIButton *SmallImgButton = [[UIButton alloc]init];
            SmallImgButton.tag = i;
            [SmallImgButton setTitle:@"" forState:UIControlStateNormal];
            [SmallImgButton setFrame:CGRectMake(270, (Height_Final + 240) + i * 158, 30, 30)];
            [SmallImgButton setBackgroundColor:[UIColor clearColor]];
            [SmallImgButton addTarget:self action:@selector(SmallImgButton_Extra_Forloop:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:SmallImgButton];
        }
        
        // [MainScroll setContentSize:CGSizeMake(320, 800)];
        }

    UIButton *ExploreMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
   // [ExploreMoreButton setTitle:CustomLocalisedString(@"ExploreMore", nil) forState:UIControlStateNormal];
   // ExploreMoreButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
   // [ExploreMoreButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:225.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [ExploreMoreButton setBackgroundImage:[UIImage imageNamed:@"ExploreMore.png"] forState:UIControlStateNormal];
     [ExploreMoreButton setBackgroundImage:[UIImage imageNamed:@"ExploreMoreHover.png"] forState:UIControlStateHighlighted];
    [ExploreMoreButton setFrame:CGRectMake(14, Height_Extra - 20, 292, 51)];
    [ExploreMoreButton setBackgroundColor:[UIColor clearColor]];
    [ExploreMoreButton addTarget:self action:@selector(ExploreMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *ExploreMoreText = [[UILabel alloc]init];
    ExploreMoreText.frame = CGRectMake(130, Height_Extra - 20, 170, 51);
    ExploreMoreText.text = CustomLocalisedString(@"ExploreMore", nil);
    ExploreMoreText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    ExploreMoreText.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    ExploreMoreText.backgroundColor = [UIColor clearColor];
    
    [MainScroll addSubview:ShowExpertsLabelImage];
    [MainScroll addSubview:ExploreMoreButton];
    [MainScroll addSubview:ExploreMoreText];
    
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll setContentSize:CGSizeMake(320, Height_Extra + 50)];
}
-(IBAction)OtherExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[featured_usernameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ExploreMoreButton:(id)sende{
    [self.tabBarController setSelectedIndex:1];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
            for (NSString *key in [defaultsDictionary allKeys]) {
                NSLog(@"removing user pref for %@", key);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            
            LandingViewController *LandingView = [[LandingViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }else{
            //reset clicked
        }
    }

}
-(IBAction)SmallImgButton_Nearby:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
  // NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_Nearby objectAtIndex:0];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
   // NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
  //  NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]);
    
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallImgButton_Nearby_Forloop:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
  //  NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_Nearby objectAtIndex:getbuttonIDN];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
  //  NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
   // NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:0]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:0]];
}
-(IBAction)SmallImgButton_Local:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
  //  NSLog(@"button %li",(long)getbuttonIDN);
   // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_Local objectAtIndex:0];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
  //  NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
   // NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallImgButton_Local_Forloop:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
  //  NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_Local objectAtIndex:getbuttonIDN];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
 //   NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
  //  NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:0]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:0]];
}
-(IBAction)SmallImgButton_ForeignLand:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
   // NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_ForeignLand objectAtIndex:0];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
   // NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
   // NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:getbuttonIDN]];
}
-(IBAction)SmallImgButton_ForeignLand_Forloop:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
   // NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_ForeignLand objectAtIndex:getbuttonIDN];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
   // NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
   // NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:0]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:0]];
}
-(IBAction)SmallImgButton_Extra_Forloop:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
   // NSLog(@"button %li",(long)getbuttonIDN);
    // NSLog(@"Get name is %@",[Activities_usernameArray_Local objectAtIndex:getbuttonIDN]);
    NSString *GetActivitiesUsername = [Activities_usernameArray_Extra objectAtIndex:getbuttonIDN];
    NSArray *SplitArray_ActivitiesUsername = [GetActivitiesUsername componentsSeparatedByString:@","];
    
    NSMutableArray *ArrayActivitiesUsername = [[NSMutableArray alloc]init];
    for (int i = 0; i < [SplitArray_ActivitiesUsername count]; i++) {
        NSString *GetSplitData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_ActivitiesUsername objectAtIndex:i]];
        [ArrayActivitiesUsername addObject:GetSplitData];
    }
   // NSLog(@"ArrayActivitiesUsername is %@",ArrayActivitiesUsername);
   // NSLog(@"Get name is %@",[ArrayActivitiesUsername objectAtIndex:0]);
    ExpertsUserProfileViewController *ExpertsUserProfileView = [[ExpertsUserProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[ArrayActivitiesUsername objectAtIndex:0]];
}
-(IBAction)RetryButton:(id)sender{
    NSLog(@"Retry Button Click");
    ShowNoDataView.hidden = YES;
  //  [self GetFeedDataFromServer];
}
-(void)CheckNotificationCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.GetNotificationCount_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_CheckNotification = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CheckNotification start];
    
    
    if( theConnection_CheckNotification ){
        webData = [NSMutableData data];
    }
}
@end

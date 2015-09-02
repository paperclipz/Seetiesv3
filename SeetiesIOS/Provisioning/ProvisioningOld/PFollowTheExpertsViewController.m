//
//  PFollowTheExpertsViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PFollowTheExpertsViewController.h"
#import "AsyncImageView.h"
//#import "MainViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "SelectImageViewController.h"
#import "NotificationViewController.h"
#import "ProfileV2ViewController.h"

#import "FeedV2ViewController.h"
#import "LeveyTabBarController.h"
#import "RecommendPopUpViewController.h"

#import "FeedViewController.h"
#import "NewProfileV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface PFollowTheExpertsViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation PFollowTheExpertsViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *CheckStatus = @"5";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
    // Do any additional setup after loading the view from its nib.
    
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    iPhone4Scroll.delegate = self;
    iPhone6Scroll.delegate = self;
    iPhone6Scroll.clipsToBounds = NO;
    iPhone6PlusScroll.delegate = self;
    iPhone6Scroll.translatesAutoresizingMaskIntoConstraints  = NO;
    
    iPhone4Scroll.frame  = CGRectMake(0, 0, 320, 480);
    MainScroll.frame  = CGRectMake(0, 0, 320, 568);
    iPhone6Scroll.frame = CGRectMake(0, 0, 375, 667);
    iPhone6PlusScroll.frame = CGRectMake(0, 0, 414, 736);
    
    [SkipButton_01_568 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_01_480 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_02_568 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_02_480 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_03_568 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_03_480 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_04_568 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_04_480 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [DoneButton_568 setTitle:NSLocalizedString(@"DoneButton",nil) forState:UIControlStateNormal];
    [DoneButton_480 setTitle:NSLocalizedString(@"DoneButton",nil) forState:UIControlStateNormal];
    
    WelcometoSeeties_568.text = NSLocalizedString(@"WelcometoSeeties",nil);
    WelcometoSeeties_480.text = NSLocalizedString(@"WelcometoSeeties",nil);
    Seewhypeopleloveus_568.text = NSLocalizedString(@"Seewhypeopleloveus",nil);
    Seewhypeopleloveus_480.text = NSLocalizedString(@"Seewhypeopleloveus",nil);
    Slideformore_568.text = NSLocalizedString(@"Slideformore",nil);
    Slideformore_480.text = NSLocalizedString(@"Slideformore",nil);
    
    Recommend_480.text = NSLocalizedString(@"Recommend",nil);
    Shareyourstories_480.text = NSLocalizedString(@"Shareyourstories",nil);
    Friends_480.text = NSLocalizedString(@"Friends",nil);
    Seewhatyourfriends_480.text = NSLocalizedString(@"Seewhatyourfriends",nil);
    AnewWay_480.text = NSLocalizedString(@"AnewWay",nil);
    Eatwhere_480.text = NSLocalizedString(@"Eatwhere",nil);
    Allofyour_480.text = NSLocalizedString(@"Allofyour",nil);
    Keepyourbestcity_480.text = NSLocalizedString(@"Keepyourbestcity",nil);
    
    Recommend_568.text = NSLocalizedString(@"Recommend",nil);
    Shareyourstories_568.text = NSLocalizedString(@"Shareyourstories",nil);
    Friends_568.text = NSLocalizedString(@"Friends",nil);
    Seewhatyourfriends_568.text = NSLocalizedString(@"Seewhatyourfriends",nil);
    AnewWay_568.text = NSLocalizedString(@"AnewWay",nil);
    Eatwhere_568.text = NSLocalizedString(@"Eatwhere",nil);
    Allofyour_568.text = NSLocalizedString(@"Allofyour",nil);
    Keepyourbestcity_568.text = NSLocalizedString(@"Keepyourbestcity",nil);
    
    [SkipButton_01_iPH6 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_01_iPH6Plus setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_02_iPH6 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_02_iPH6Plus setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_03_iPH6 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_03_iPH6Plus setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_04_iPH6 setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [SkipButton_04_iPH6Plus setTitle:NSLocalizedString(@"SkipButton",nil) forState:UIControlStateNormal];
    [DoneButton_iPH6 setTitle:NSLocalizedString(@"DoneButton",nil) forState:UIControlStateNormal];
    [DoneButton_iPH6Plus setTitle:NSLocalizedString(@"DoneButton",nil) forState:UIControlStateNormal];
    
    WelcometoSeeties_iPH6.text = NSLocalizedString(@"WelcometoSeeties",nil);
    WelcometoSeeties_iPH6Plus.text = NSLocalizedString(@"WelcometoSeeties",nil);
    Seewhypeopleloveus_iPH6.text = NSLocalizedString(@"Seewhypeopleloveus",nil);
    Seewhypeopleloveus_iPH6Plus.text = NSLocalizedString(@"Seewhypeopleloveus",nil);
    Slideformore_iPH6.text = NSLocalizedString(@"Slideformore",nil);
    Slideformore_iPH6Plus.text = NSLocalizedString(@"Slideformore",nil);
    
    Recommend_iPH6Plus.text = NSLocalizedString(@"Recommend",nil);
    Shareyourstories_iPH6Plus.text = NSLocalizedString(@"Shareyourstories",nil);
    Friends_iPH6Plus.text = NSLocalizedString(@"Friends",nil);
    Seewhatyourfriends_iPH6Plus.text = NSLocalizedString(@"Seewhatyourfriends",nil);
    AnewWay_iPH6Plus.text = NSLocalizedString(@"AnewWay",nil);
    Eatwhere_iPH6Plus.text = NSLocalizedString(@"Eatwhere",nil);
    Allofyour_iPH6Plus.text = NSLocalizedString(@"Allofyour",nil);
    Keepyourbestcity_iPH6Plus.text = NSLocalizedString(@"Keepyourbestcity",nil);
    
    Recommend_iPH6.text = NSLocalizedString(@"Recommend",nil);
    Shareyourstories_iPH6.text = NSLocalizedString(@"Shareyourstories",nil);
    Friends_iPH6.text = NSLocalizedString(@"Friends",nil);
    Seewhatyourfriends_iPH6.text = NSLocalizedString(@"Seewhatyourfriends",nil);
    AnewWay_iPH6.text = NSLocalizedString(@"AnewWay",nil);
    Eatwhere_iPH6.text = NSLocalizedString(@"Eatwhere",nil);
    Allofyour_iPH6.text = NSLocalizedString(@"Allofyour",nil);
    Keepyourbestcity_iPH6.text = NSLocalizedString(@"Keepyourbestcity",nil);
    
    
    
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
        
        [self UpdateUserDataToServer];
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
    
    [self UpdateUserDataToServer];
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidLayoutSubviews{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if( screenHeight > 480 && screenHeight < 667 ){
            NSLog(@"iPhone 5/5s");
            
            MainScroll.hidden = NO;
            iPhone4Scroll.hidden = YES;
            iPhone6PlusScroll.hidden = YES;
            iPhone6Scroll.hidden = YES;
            [MainScroll setContentSize:CGSizeMake(1600, 568)];
        }else if ( screenHeight > 480 && screenHeight < 736 ){
            NSLog(@"use iPhone 6 ?????? ");
            
            MainScroll.hidden = YES;
            iPhone4Scroll.hidden = YES;
            iPhone6PlusScroll.hidden = YES;
            iPhone6Scroll.hidden = NO;
            //  [iPhone6Scroll setContentSize:CGSizeMake(1875, 667)];
            [iPhone6Scroll setContentSize:CGSizeMake(1875, 667)];
        } else if ( screenHeight > 480 ){
            NSLog(@"iPhone 6 Plus");
            
            MainScroll.hidden = YES;
            iPhone4Scroll.hidden = YES;
            iPhone6PlusScroll.hidden = NO;
            iPhone6Scroll.hidden = YES;
            [iPhone6PlusScroll setContentSize:CGSizeMake(2070, 736)];
        }else {
            NSLog(@"iPhone 4/4s");
            
            MainScroll.hidden = YES;
            iPhone4Scroll.hidden = NO;
            iPhone6PlusScroll.hidden = YES;
            iPhone6Scroll.hidden = YES;
            [iPhone4Scroll setContentSize:CGSizeMake(1600, 300)];
        }
        
    }
    NSLog(@"MainScroll is %@",MainScroll);
    NSLog(@"iPhone4Scroll is %@",iPhone4Scroll);
    NSLog(@"iPhone6Scroll is %@",iPhone6Scroll);
    NSLog(@"iPhone6PlusScroll is %@",iPhone6PlusScroll);
    
    [self.view addSubview:iPhone6Scroll];
    [self.view addSubview:iPhone4Scroll];
    [self.view addSubview:iPhone6PlusScroll];
    
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    pageControl.frame = CGRectMake(0, screenHeight - 50, screenWidth, 37);
    [self.view addSubview:pageControl];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Provisioning Follow The Experts";
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == theConnection_UpdateData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Update return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"res is %@",res);
        
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        
        
        NSString *GetName = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"name"]];
        NSLog(@"GetName is %@",GetName);
        NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
        NSLog(@"Getusername is %@",Getusername);
        NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
        NSLog(@"Getemail is %@",Getemail);
        NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"location"]];
        NSLog(@"GetLocation is %@",GetLocation);
        NSString *GetAbouts = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
        NSLog(@"GetAbouts is %@",GetAbouts);
        NSString *GetUrl = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"personal_link"]];
        NSLog(@"GetUrl is %@",GetUrl);
        NSString *GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"follower_count"]];
        NSLog(@"GetFollowersCount is %@",GetFollowersCount);
        NSString *GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"following_count"]];
        NSLog(@"GetFollowingCount is %@",GetFollowingCount);
        NSString *Getcategories = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"categories"]];
        NSLog(@"Getcategories is %@",Getcategories);
        NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
        NSLog(@"Getdob is %@",Getdob);
        NSString *GetGender = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"gender"]];
        NSLog(@"GetGender is %@",GetGender);
        NSString *GetFbExtendedToken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"fb_extended_token"]];
        NSLog(@"GetFbExtendedToken is %@",GetFbExtendedToken);
        
        NSDictionary *SystemLanguage = [GetAllData valueForKey:@"system_language"];
        NSLog(@"SystemLanguage is %@",SystemLanguage);
        NSString *GetCaption;
        if ([SystemLanguage isKindOfClass:[NSNull class]]) {
            GetCaption = @"English";
        }else{
            GetCaption = [[NSString alloc]initWithFormat:@"%@",[SystemLanguage objectForKey:@"caption"]];
            NSLog(@"GetCaption is %@",GetCaption);
        }
        
        NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]init];
        NSMutableArray *TempArray = [[NSMutableArray alloc]init];
        NSDictionary *NSDictionaryLanguage = [GetAllData valueForKey:@"languages"];
        NSLog(@"NSDictionaryLanguage is %@",NSDictionaryLanguage);
        for (NSDictionary * dict in NSDictionaryLanguage){
            NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [GetUserSelectLanguagesArray addObject:Getid];
            NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
            NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
            [TempArray addObject:GetLanguage_1];
        }
        NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
        
        NSString *GetLanguage_1;
        NSString *GetLanguage_2;
        if ([TempArray count] == 1) {
            GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
        }else{
            GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
            GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
        }
        
        NSInteger CheckSystemLanguage;
        if ([GetCaption isEqualToString:@"English"]) {
            CheckSystemLanguage = 0;
        }else if([GetCaption isEqualToString:@"Simplified Chinese"]){
            CheckSystemLanguage = 1;
        }else if([GetCaption isEqualToString:@"Traditional Chinese"]){
            CheckSystemLanguage = 2;
        }else if([GetCaption isEqualToString:@"Bahasa Indonesia"]){
            CheckSystemLanguage = 3;
        }else if([GetCaption isEqualToString:@"Thai"]){
            CheckSystemLanguage = 4;
        }else if([GetCaption isEqualToString:@"Filipino"]){
            CheckSystemLanguage = 5;
        }
        
        //  NSLog(@"CheckSystemLanguage is %li",(long)CheckSystemLanguage);
        LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
        
        Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
        
        NSLog(@"Landing Language selected: %@", localeForRow.name);
        
        [languageManager setLanguageWithLocale:localeForRow];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Getcategories forKey:@"UserData_Categories"];
        [defaults setObject:GetName forKey:@"UserData_Name"];
        [defaults setObject:Getusername forKey:@"UserData_Username"];
        [defaults setObject:GetAbouts forKey:@"UserData_Abouts"];
        [defaults setObject:GetUrl forKey:@"UserData_Url"];
        [defaults setObject:Getemail forKey:@"UserData_Email"];
        [defaults setObject:GetLocation forKey:@"UserData_Location"];
        [defaults setObject:Getdob forKey:@"UserData_dob"];
        [defaults setObject:GetGender forKey:@"UserData_Gender"];
        [defaults setObject:GetCaption forKey:@"UserData_SystemLanguage"];
        [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
        [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
        [defaults setObject:GetFollowersCount forKey:@"UserData_FollowersCount"];
        [defaults setObject:GetFollowingCount forKey:@"UserData_FollowingCount"];
        [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
        [defaults setObject:GetFbExtendedToken forKey:@"fbextendedtoken"];
        [defaults synchronize];
        
        
//        NSTimer *RandomTimer;
//        //    //2 sec to show button.
//        RandomTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
    }
    
}
-(IBAction)DoneButton:(id)sender{
    NSString *CheckStatus = @"0";
    NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults setObject:CheckLogin forKey:@"CheckLogin"];
    [defaults synchronize];

    FeedViewController *firstViewController=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
    //SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
    RecommendPopUpViewController *threeViewController=[[RecommendPopUpViewController alloc]initWithNibName:@"RecommendPopUpViewController" bundle:nil];
    NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
    //ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
    NewProfileV2ViewController *fiveViewController=[[NewProfileV2ViewController alloc]initWithNibName:@"NewProfileV2ViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:fourViewController];
    UINavigationController *navController4 = [[UINavigationController alloc] initWithRootViewController:fiveViewController];
    
    NSArray *ctrlArr = [NSArray arrayWithObjects:navController,navController2,threeViewController,navController3,navController4,nil];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"TabBarFeed.png"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"TabBarFeed_on.png"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"TabBarFeed_on.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"TabBarExplore.png"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"TabBarExplore_on.png"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"TabBarExplore_on.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"TabBarNew.png"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"FollowDeny.png"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"FollowDeny.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"TabBarActivity.png"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"TabBarActivity_on.png"] forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"TabBarActivity_on.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:@"TabBarProfile.png"] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"TabBarProfile_on.png"] forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:@"TabBarProfile_on.png"] forKey:@"Seleted"];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
    
    leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    [leveyTabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [leveyTabBarController setTabBarTransparent:YES];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:leveyTabBarController];
}
-(void)UpdateUserDataToServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetProvisioning_Interest_ID = [defaults objectForKey:@"Provisioning_Interest"];
    NSString *GetLocationJson = [defaults objectForKey:@"Provisioning_FullJson"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetLang01 = [defaults objectForKey:@"Provisioning_SelectLanguage01"];
    NSString *GetLang02 = [defaults objectForKey:@"Provisioning_SelectLanguage02"];
    NSString *GetSystemLanguage = [defaults objectForKey:@"SystemLanguage"];
    NSMutableArray *GetlanguageCodeArray = [defaults objectForKey:@"LanguageData_Code"];
    NSMutableArray *GetlanguageIDArray = [defaults objectForKey:@"LanguageData_ID"];
    NSString *GetSystemLanguageData;
    for (int i = 0; i < [GetlanguageCodeArray count]; i++) {
        NSString *GetLanguageCode = [[NSString alloc]initWithFormat:@"%@",[GetlanguageCodeArray objectAtIndex:i]];
        
        if ([GetLanguageCode isEqualToString:GetSystemLanguage]) {
            GetSystemLanguageData = [[NSString alloc]initWithFormat:@"%@",[GetlanguageIDArray objectAtIndex:i]];
            break;
        }else{
        GetSystemLanguageData = @"530b0ab26424400c76000003";
        }
    }
    
    NSLog(@"GetExpertToken is %@",GetExpertToken);
    NSLog(@"GetProvisioning_Interest_ID is %@",GetProvisioning_Interest_ID);
    NSLog(@"GetLocationJson is %@",GetLocationJson);
    NSLog(@"Getuid is %@",Getuid);
    NSLog(@"GetLang01 is %@",GetLang01);
    NSLog(@"GetLang02 is %@",GetLang02);
    
    if ([GetLocationJson length] == 0 || [GetLocationJson isEqualToString:@"(null)"]) {
        GetLocationJson = @"";
    }
    if ([GetLang01 length] == 0 || [GetLang01 isEqualToString:@"(null)"]) {
        GetLang01 = @"530b0ab26424400c76000003";
    }

    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/provisioning",DataUrl.UserWallpaper_Url,Getuid];
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
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"home_city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetLocationJson] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"other_city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetLocationJson] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"system_language\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetSystemLanguageData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetProvisioning_Interest_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"languages[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetLang01] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([GetLang02 length] == 0 || [GetLang02 isEqualToString:@"(null)"] || [GetLang02 isEqualToString:@"None"]) {
        GetLang02 = @"530b0ab26424400c76000003";
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"languages[1]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLang02] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if ([lonPoint length] == 0 || [lonPoint isEqualToString:@"(null)"] || [lonPoint isEqualToString:@"None"]) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",latPoint] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lng\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",lonPoint] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    

    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_UpdateData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_UpdateData) {
      //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }

}
-(IBAction)SkipButton01:(id)sender{
    [MainScroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone4Scroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone6Scroll setContentOffset:CGPointMake(1500, 0) animated:YES];
    [iPhone6PlusScroll setContentOffset:CGPointMake(1656, 0) animated:YES];
}
-(IBAction)SkipButton02:(id)sender{
    [MainScroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone4Scroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone6Scroll setContentOffset:CGPointMake(1500, 0) animated:YES];
    [iPhone6PlusScroll setContentOffset:CGPointMake(1656, 0) animated:YES];
}
-(IBAction)SkipButton03:(id)sender{
    [MainScroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone4Scroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone6Scroll setContentOffset:CGPointMake(1500, 0) animated:YES];
    [iPhone6PlusScroll setContentOffset:CGPointMake(1656, 0) animated:YES];
}
-(IBAction)SkipButton04:(id)sender{
    [MainScroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone4Scroll setContentOffset:CGPointMake(1280, 0) animated:YES];
    [iPhone6Scroll setContentOffset:CGPointMake(1500, 0) animated:YES];
    [iPhone6PlusScroll setContentOffset:CGPointMake(1656, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (scrollView == MainScroll) {
        CGFloat pageWidth = MainScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = MainScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    }else if (scrollView == iPhone4Scroll){
        CGFloat pageWidth = iPhone4Scroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = iPhone4Scroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    }else if (scrollView == iPhone6Scroll){
        CGFloat pageWidth = screenWidth; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = iPhone6Scroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    }else if (scrollView == iPhone6PlusScroll){
        CGFloat pageWidth = screenWidth; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = iPhone6PlusScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    }
    

}
@end

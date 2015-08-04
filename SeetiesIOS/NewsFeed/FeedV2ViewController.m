//
//  FeedV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/7/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "FeedV2ViewController.h"
#import "SelectImageViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
#import "FeedV2DetailViewController.h"
#import "LandingV2ViewController.h"
#import "SearchDetailViewController.h"
#import "SearchViewV2.h"
#import <CoreLocation/CoreLocation.h>
#import "UserProfileV2ViewController.h"
#import "Filter2ViewController.h"
#import "InviteFrenViewController.h"

#import "NSAttributedString+DVSTracking.h"
#import "CommentViewController.h"
#import "NSString+ChangeAsciiString.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
@interface FeedV2ViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@implementation FeedV2ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CheckLoad = NO;
    CheckSuggestions = NO;
    CheckFirstTimeUser = NO;
    CheckPromotion = NO;
    
    MainScroll.delegate = self;
    [MainScroll setScrollEnabled:YES];
     MainScroll.alwaysBounceVertical = TRUE;
    MainScroll.backgroundColor = [UIColor whiteColor];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 104);
    ClickBackToTopButton.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowFeedText.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    NearbyButton.frame = CGRectMake(screenWidth - 84 - 15, 27, 84, 30);
   // [self InitView];
   // [self GetFeedDataFromServer];
    KosongView.hidden = YES;
    KosongView.frame = CGRectMake(0, screenHeight - 150, screenWidth, 100);
    
    ArrowIcon.frame = CGRectMake((screenWidth / 2) - 8, 8, 16, 16);
    KosongLabel_1.frame = CGRectMake(15, 41, screenWidth - 30, 21);
    KosongLabel_2.frame = CGRectMake(15, 63, screenWidth - 30, 21);
    
    ShowFeedText.text = CustomLocalisedString(@"MainTab_Feed",nil);
    [NearbyButton setTitle:CustomLocalisedString(@"NearBy",nil) forState:UIControlStateNormal];
    [FilterButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    CheckFollow = 0;
    AddFollowCount = 0;
    CheckLoadDone = NO;
    
    DontLoadAgain = 0;
    
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
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    


    //[self GetFeedDataFromServer];
    CheckGoPost = 0;
    heightcheck = 0;
    CountFollowFirstTime = 3;
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    
    
    //[self GetExternalIPAddress];
    

    


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
        if (DontLoadAgain == 0) {
            DontLoadAgain = 1;
            [self GetExternalIPAddress];
            [self GetFeedDataFromServer];
        }else{
           
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
    if (DontLoadAgain == 0) {
        DontLoadAgain = 1;
        [self GetExternalIPAddress];
        [self GetFeedDataFromServer];
    }else{
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (CheckGoPost == 100) {
//        CheckGoPost = 0;
//    }else{
//      [MainScroll setContentOffset:CGPointZero animated:YES];
//    }

    self.screenName = @"IOS Feed Main View V2";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        
    }else{
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        TotalPage = 0;
        CurrentPage = 0;
        DataCount = 0;
        DataTotal = 0;
        CheckLoadDone = NO;
        heightcheck = 0;
        NSLog(@"got filter get feed data");
        [self GetFeedDataFromServer];
    }
    
    //self.title = CustomLocalisedString(@"MainTab_Feed",nil);
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (screenWidth > 320) {
        NSLog(@"iphone 6 / iphone 6 plus");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 175 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed_on.png"];
        [self.tabBarController.view addSubview:ShowImage_Feed];
        
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 100, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore.png"];
        [self.tabBarController.view addSubview:ShowImage_Explore];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake((screenWidth / 2) - 25, screenHeight - 50, 50, 50);
        ShowImage.image = [UIImage imageNamed:@"TabBarNew.png"];
        [self.tabBarController.view addSubview:ShowImage];
        
        UIImageView *ShowImage_Collecation = [[UIImageView alloc]init];
        ShowImage_Collecation.frame = CGRectMake((screenWidth / 2) + 50, screenHeight - 50, 50, 50);
        ShowImage_Collecation.image = [UIImage imageNamed:@"TabBarActivity.png"];
        [self.tabBarController.view addSubview:ShowImage_Collecation];
        
        UIImageView *ShowImage_Profile = [[UIImageView alloc]init];
        ShowImage_Profile.frame = CGRectMake((screenWidth / 2) + 125, screenHeight - 50, 50, 50);
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile.png"];
        [self.tabBarController.view addSubview:ShowImage_Profile];
    }else{
        NSLog(@"iphone 5 / iphone 5s / iphone 4");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 153 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed_on.png"];
        [self.tabBarController.view addSubview:ShowImage_Feed];
        
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 89, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore.png"];
        [self.tabBarController.view addSubview:ShowImage_Explore];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake((screenWidth / 2) - 25, screenHeight - 50, 50, 50);
        ShowImage.image = [UIImage imageNamed:@"TabBarNew.png"];
        [self.tabBarController.view addSubview:ShowImage];
        
        UIImageView *ShowImage_Collecation = [[UIImageView alloc]init];
        ShowImage_Collecation.frame = CGRectMake((screenWidth / 2) + 39, screenHeight - 50, 50, 50);
        ShowImage_Collecation.image = [UIImage imageNamed:@"TabBarActivity.png"];
        [self.tabBarController.view addSubview:ShowImage_Collecation];
        
        UIImageView *ShowImage_Profile = [[UIImageView alloc]init];
        ShowImage_Profile.frame = CGRectMake((screenWidth / 2) + 106, screenHeight - 50, 50, 50);
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile.png"];
        [self.tabBarController.view addSubview:ShowImage_Profile];
    }
    
    UIButton *BackToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackToTopButton.frame = CGRectMake(0, screenHeight - 50, 80, 50);
    [BackToTopButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [BackToTopButton setBackgroundColor:[UIColor clearColor]];
    [BackToTopButton addTarget:self action:@selector(BackToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:BackToTopButton];
    
    UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SelectButton.frame = CGRectMake((screenWidth/2) - 40, screenHeight - 50, 80, 50);
    [SelectButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [SelectButton setBackgroundColor:[UIColor clearColor]];
    [SelectButton addTarget:self action:@selector(ChangeViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:SelectButton];
    
    
    
    NSString *CheckSelfDelete = [defaults objectForKey:@"SelfDeletePost"];
    if ([CheckSelfDelete isEqualToString:@"YES"]) {
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        TotalPage = 0;
        CurrentPage = 0;
        DataCount = 0;
        DataTotal = 0;
        heightcheck = 0;
        CheckLoadDone = NO;
        NSLog(@"delete post get feed data");
        [self GetFeedDataFromServer];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"SelfDeletePost"];
        [defaults synchronize];
    }
    
    if (CheckLoadDone == NO) {
//        spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//        spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//        spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//        spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        spinnerView.lineWidth = 1.0f;
//        [self.view addSubview:spinnerView];
//        [spinnerView startAnimating];
        
        [ShowActivity startAnimating];

    }
    
    TempBackground = [[UIView alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    TempBackground.backgroundColor = [UIColor blackColor];
    TempBackground.alpha = 0.5f;
    [self.view addSubview:TempBackground];
    TempBackground.hidden = YES;
    
    ShowSelectImageButton = [[UIButton alloc]init];
    ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
    [ShowSelectImageButton setTitle:@"Image" forState:UIControlStateNormal];
    ShowSelectImageButton.backgroundColor = [UIColor redColor];
    [ShowSelectImageButton addTarget:self action:@selector(OpenSelectImgButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShowSelectImageButton];
    
    ShowSelectDaftButton = [[UIButton alloc]init];
    ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
    [ShowSelectDaftButton setTitle:@"Draft" forState:UIControlStateNormal];
    ShowSelectDaftButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:ShowSelectDaftButton];
    
    CheckButtonClick = NO;
    

    


}
-(IBAction)ClickBackToTopButton:(id)sender{
[MainScroll setContentOffset:CGPointZero animated:YES];
}
-(IBAction)BackToTopButton:(id)sender{
[MainScroll setContentOffset:CGPointZero animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    
    [ShowActivity stopAnimating];
    //[ShowActivity removeFromSuperview];
    
    CheckButtonClick = NO;
    TempBackground.hidden = YES;
    ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
    ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
}
-(IBAction)OpenSelectImgButton:(id)sender{
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
    cont.nMaxCount = 10;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];

}
-(IBAction)ChangeViewButton:(id)sender{
    NSLog(@"ChangeViewButton Click");
//    SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
//    [self presentViewController:SelectImageView animated:YES completion:nil];
    
//    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
//    cont.delegate = self;
//    cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
//    cont.nMaxCount = 10;
//    cont.nColumnCount = 3;
//    
//    [self presentViewController:cont animated:YES completion:nil];
    

    
    if (CheckButtonClick == NO) {
        CheckButtonClick = YES;
        TempBackground.hidden = NO;

        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             ShowSelectImageButton.frame = CGRectMake(160, 300, 100, 100);
                             ShowSelectDaftButton.frame = CGRectMake(160, 300, 100, 100);
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.2f
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  ShowSelectImageButton.frame = CGRectMake(50, 300, 100, 100);
                                                  ShowSelectDaftButton.frame = CGRectMake(250, 300, 100, 100);
                                              }
                                              completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
    }else{
        CheckButtonClick = NO;
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             ShowSelectImageButton.frame = CGRectMake(160, 300, 100, 100);
                             ShowSelectDaftButton.frame = CGRectMake(160, 300, 100, 100);
                         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.2f
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  ShowSelectImageButton.frame = CGRectMake(160, 800, 100, 100);
                                                  ShowSelectDaftButton.frame = CGRectMake(160, 800, 100, 100);
                                              }
                                              completion:^(BOOL finished) {
                                                 TempBackground.hidden = YES;
                                              }];
                         }];
    }
    

    
    

    


    
    
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)testRefresh:(UIRefreshControl *)refreshControlTemp
{
    NSLog(@"in herer testrefresh???");
    refreshControlTemp.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
      //  [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            refreshControlTemp.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            [refreshControlTemp endRefreshing];
            NSLog(@"refresh end");
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            TotalPage = 0;
            CurrentPage = 0;
            DataCount = 0;
            DataTotal = 0;
            heightcheck = 0;
            CheckLoadDone = NO;
            if (CheckLoadDone == NO) {
//                spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//                spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//                spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//                spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//                spinnerView.lineWidth = 1.0f;
//                [self.view addSubview:spinnerView];
//                [spinnerView startAnimating];
                [ShowActivity startAnimating];

            }

            NSLog(@"refresh get feed data");
            [self GetFeedDataFromServer];

        });
    });
}

-(void)InitView_V2{
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (CheckSuggestions == YES) {//draw suggestion fren
        if (CheckFirstTimeUser == YES) {
            
            if (CountFollowFirstTime == 3) {
                
                
                if (CheckPromotion == YES) {
                    UIImageView *BannerImage = [[UIImageView alloc]init];
                    BannerImage.frame = CGRectMake(0, 0, screenWidth, 85);
                    NSURL *tempurl = [NSURL URLWithString:GetPromotionImage];
                    BannerImage.imageURL = tempurl;
                    BannerImage.contentMode = UIViewContentModeScaleAspectFit;
                    BannerImage.backgroundColor = [UIColor whiteColor];
                    [MainScroll addSubview:BannerImage];
                    
//                    UIButton *DemoBlackButton = [[UIButton alloc]init];
//                    DemoBlackButton.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                    [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
//                    DemoBlackButton.layer.cornerRadius = 5;
//                    DemoBlackButton.clipsToBounds = YES;
//                    [MainScroll addSubview:DemoBlackButton];
//                    
//                    UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                    DemoWhiteButton.frame = CGRectMake(screenWidth - 15 - 59, 28, 58, 28);
//                    [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                    [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                    DemoWhiteButton.layer.cornerRadius = 4;
//                    DemoWhiteButton.clipsToBounds = YES;
//                    [MainScroll addSubview:DemoWhiteButton];
//                    
//                    UILabel *ShowFindText = [[UILabel alloc]init];
//                    ShowFindText.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                    ShowFindText.text = @"View";
//                    ShowFindText.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
//                    ShowFindText.textAlignment = NSTextAlignmentCenter;
//                    ShowFindText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
//                    [MainScroll addSubview:ShowFindText];
                    
                    UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
                    SuggestionsLine.frame = CGRectMake(0, 84, screenWidth, 1);
                    [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
                    [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
                    [MainScroll addSubview:SuggestionsLine];
                    
                    UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    SelectButton.frame = CGRectMake(0, 0, screenWidth, 85);
                    [SelectButton setTitle:@"" forState:UIControlStateNormal];
                    [SelectButton setBackgroundColor:[UIColor clearColor]];
                    [SelectButton addTarget:self action:@selector(PromotionButton:) forControlEvents:UIControlEventTouchUpInside];
                    [MainScroll addSubview:SelectButton];
                    
                   // ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, 220)];
                    if (screenWidth > 400) {
                        ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, screenWidth, screenWidth)];
                    }else{
                        ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, screenWidth, 550)];
                    }
                }else{
                    
                    //ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
                    if (screenWidth > 400) {
                        ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
                    }else{
                        ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 550)];
                    }
                    
                }
                
//                if (screenWidth > 400) {
//                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
//                }else{
//                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 550)];
//                }
                
            }else if(CountFollowFirstTime == 2){
                if (CheckPromotion == YES) {
                UIImageView *BannerImage = [[UIImageView alloc]init];
                BannerImage.frame = CGRectMake(0, 0, screenWidth, 85);
                NSURL *tempurl = [NSURL URLWithString:GetPromotionImage];
                BannerImage.imageURL = tempurl;
                BannerImage.contentMode = UIViewContentModeScaleToFill;
                BannerImage.backgroundColor = [UIColor blackColor];
                [MainScroll addSubview:BannerImage];
                    
//                    UIButton *DemoBlackButton = [[UIButton alloc]init];
//                    DemoBlackButton.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                    [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
//                    DemoBlackButton.layer.cornerRadius = 5;
//                    DemoBlackButton.clipsToBounds = YES;
//                    [MainScroll addSubview:DemoBlackButton];
//                    
//                    UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                    DemoWhiteButton.frame = CGRectMake(screenWidth - 15 - 59, 28, 58, 28);
//                    [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                    [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                    DemoWhiteButton.layer.cornerRadius = 4;
//                    DemoWhiteButton.clipsToBounds = YES;
//                    [MainScroll addSubview:DemoWhiteButton];
//                    
//                    UILabel *ShowFindText = [[UILabel alloc]init];
//                    ShowFindText.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                    ShowFindText.text = @"View";
//                    ShowFindText.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
//                    ShowFindText.textAlignment = NSTextAlignmentCenter;
//                    ShowFindText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
//                    [MainScroll addSubview:ShowFindText];
                
                UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
                SelectButton.frame = CGRectMake(0, 0, screenWidth, 85);
                [SelectButton setTitle:@"" forState:UIControlStateNormal];
                [SelectButton setBackgroundColor:[UIColor clearColor]];
                [SelectButton addTarget:self action:@selector(PromotionButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:SelectButton];
                    
                    UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
                    SuggestionsLine.frame = CGRectMake(0, 84, screenWidth, 1);
                    [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
                    [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
                    [MainScroll addSubview:SuggestionsLine];
                
                // ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, 220)];
                if (screenWidth > 400) {
                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, screenWidth, screenWidth)];
                }else{
                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, screenWidth, 375)];
                }
            }else{
                
                //ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
                if (screenWidth > 400) {
                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
                }else{
                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 375)];
                }
                
            }
            
            
            
//                if (screenWidth > 400) {
//                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
//                }else{
//                    ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 375)];
//                }
            }else{
                   ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
            }
    

    
            ShowUserSuggestionsView.delegate = self;
            ShowUserSuggestionsView.backgroundColor = [UIColor whiteColor];
            [MainScroll addSubview:ShowUserSuggestionsView];
            
            UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
            SuggestionsLine.frame = CGRectMake(0, 0, screenWidth, 1);
            [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
            [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            [ShowUserSuggestionsView addSubview:SuggestionsLine];
            
            UILabel *ShowSuggestions = [[UILabel alloc]init];
            // NSString *TempString = [[NSString alloc]initWithFormat:@"%@",CustomLocalisedString(@"FeaturedUserin", nil)];
            ShowSuggestions.text = CustomLocalisedString(@"FeaturedUserin", nil);
            //        ShowSuggestions.attributedText = [NSAttributedString dvs_attributedStringWithString:[TempString uppercaseString]
            //                                                                                   tracking:200
            //                                                                                       font:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
            ShowSuggestions.frame = CGRectMake(15, 10, screenWidth - 30, 40);
            ShowSuggestions.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
            ShowSuggestions.textAlignment = NSTextAlignmentCenter;
            ShowSuggestions.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            ShowSuggestions.backgroundColor = [UIColor clearColor];
            [ShowUserSuggestionsView addSubview:ShowSuggestions];
            
            int TestWidth = screenWidth - 40;
            //    NSLog(@"TestWidth is %i",TestWidth);
            int FinalWidth = TestWidth / 4;
            //    NSLog(@"FinalWidth is %i",FinalWidth);
            int SpaceWidth = FinalWidth + 8;
            
            int HeightGet = FinalWidth * 2;
            for ( int i = 0; i < CountFollowFirstTime; i ++) {
                NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
                NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
                for (int z = 0; z < [SplitArray count]; z++) {
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(8 +(z % 4) * SpaceWidth, 65 + i * HeightGet, FinalWidth, FinalWidth);
                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage.layer.cornerRadius=5;
                    ShowImage.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                    NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:z]];
                    if ([FullImagesURL_First length] == 0) {
                        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
                    }else{
                        NSURL *url = [NSURL URLWithString:FullImagesURL_First];
                        ShowImage.imageURL = url;
                    }
                    [ShowUserSuggestionsView addSubview:ShowImage];
                }
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(15, (75 + FinalWidth) + i * HeightGet, 40, 40);
                ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=0.5;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[User_ProfilePhotoArray objectAtIndex:i]];
                if ([FullImagesURL_First length] == 0) {
                    ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url = [NSURL URLWithString:FullImagesURL_First];
                    ShowUserProfileImage.imageURL = url;
                }
                
                [ShowUserSuggestionsView addSubview:ShowUserProfileImage];
                
                UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
                [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
                OpenProfileButton.tag = i;
                OpenProfileButton.backgroundColor = [UIColor clearColor];
                [OpenProfileButton addTarget:self action:@selector(OpenProfileButton:) forControlEvents:UIControlEventTouchUpInside];
                [ShowUserSuggestionsView addSubview:OpenProfileButton];
                
                UIButton *FollowButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 40 - 15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
                [FollowButton setTitle:@"" forState:UIControlStateNormal];
                FollowButton.tag = i;
                [FollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
                FollowButton.backgroundColor = [UIColor clearColor];
                [FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
                [FollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateSelected];
                [ShowUserSuggestionsView addSubview:FollowButton];
                
                UIButton *DenyButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 90 - 15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
                [DenyButton setTitle:@"" forState:UIControlStateNormal];
                DenyButton.tag = i;
                [DenyButton setImage:[UIImage imageNamed:@"FollowDeny.png"] forState:UIControlStateNormal];
                DenyButton.backgroundColor = [UIColor clearColor];
                [DenyButton addTarget:self action:@selector(DenyButton:) forControlEvents:UIControlEventTouchUpInside];
                [ShowUserSuggestionsView addSubview:DenyButton];
                
                
                UILabel *ShowName = [[UILabel alloc]init];
                ShowName.frame = CGRectMake(65, (75 + FinalWidth) + i * HeightGet, screenWidth - 90 - 20, 20);
                ShowName.text = [User_UserNameArray objectAtIndex:i];
                ShowName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [ShowUserSuggestionsView addSubview:ShowName];
                
                UILabel *ShowAddress = [[UILabel alloc]init];
                ShowAddress.frame = CGRectMake(65, (95 + FinalWidth) + i * HeightGet, screenWidth - 90 - 30, 20);
                ShowAddress.text = [User_LocationArray objectAtIndex:i];
                ShowAddress.textColor = [UIColor grayColor];
                ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
                [ShowUserSuggestionsView addSubview:ShowAddress];
                
                UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
                SuggestionsLine.frame = CGRectMake(0, (130 + FinalWidth) + i * HeightGet, screenWidth, 1);
                [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
                [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
                [ShowUserSuggestionsView addSubview:SuggestionsLine];
                
            }
            if (CheckLoad == YES) {
                heightcheck = MainScroll.contentSize.height - 80;
            }else{
                if (CountFollowFirstTime == 1) {
                    heightcheck = 240;
                }else{
                heightcheck = screenWidth + 30;
                }
                
                
            }
                  [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 250)];
        }else{
            CountFollowFirstTime = 1;
            
            if (CheckPromotion == YES) {
                UIImageView *BannerImage = [[UIImageView alloc]init];
                BannerImage.frame = CGRectMake(0, 0, screenWidth, 85);
                NSURL *tempurl = [NSURL URLWithString:GetPromotionImage];
                BannerImage.imageURL = tempurl;
                BannerImage.contentMode = UIViewContentModeScaleToFill;
                BannerImage.backgroundColor = [UIColor blackColor];
                [MainScroll addSubview:BannerImage];
                
//                UIButton *DemoBlackButton = [[UIButton alloc]init];
//                DemoBlackButton.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
//                DemoBlackButton.layer.cornerRadius = 5;
//                DemoBlackButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoBlackButton];
//                
//                UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                DemoWhiteButton.frame = CGRectMake(screenWidth - 15 - 59, 28, 58, 28);
//                [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                DemoWhiteButton.layer.cornerRadius = 4;
//                DemoWhiteButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoWhiteButton];
//                
//                UILabel *ShowFindText = [[UILabel alloc]init];
//                ShowFindText.frame = CGRectMake(screenWidth - 15 - 60, 27, 60, 30);
//                ShowFindText.text = @"View";
//                ShowFindText.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
//                ShowFindText.textAlignment = NSTextAlignmentCenter;
//                ShowFindText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
//                [MainScroll addSubview:ShowFindText];
                
                UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
                SelectButton.frame = CGRectMake(0, 0, screenWidth, 85);
                [SelectButton setTitle:@"" forState:UIControlStateNormal];
                [SelectButton setBackgroundColor:[UIColor clearColor]];
                [SelectButton addTarget:self action:@selector(PromotionButton:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:SelectButton];
                
                UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
                SuggestionsLine.frame = CGRectMake(0, 84, screenWidth, 1);
                [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
                [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
                [MainScroll addSubview:SuggestionsLine];
                
                ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, screenWidth, 220)];
            }else{
                
                ShowUserSuggestionsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
            
            }
            

            
            
            
            ShowUserSuggestionsView.delegate = self;
            ShowUserSuggestionsView.backgroundColor = [UIColor whiteColor];
            [MainScroll addSubview:ShowUserSuggestionsView];
            
            
//            UIImageView *InviteBackground = [[UIImageView alloc]init];
//            InviteBackground.frame = CGRectMake(15, 20, screenWidth - 30, 154);
//            InviteBackground.image = [UIImage imageNamed:@"FriendsBanner.png"];
//            [ShowUserSuggestionsView addSubview:InviteBackground];
            
            
            UILabel *ShowSuggestions = [[UILabel alloc]init];
            ShowSuggestions.text = CustomLocalisedString(@"FeaturedUserin", nil);
            ShowSuggestions.frame = CGRectMake(15, 10, screenWidth - 30, 40);
            ShowSuggestions.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
            ShowSuggestions.textAlignment = NSTextAlignmentCenter;
            ShowSuggestions.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            ShowSuggestions.backgroundColor = [UIColor clearColor];
            [ShowUserSuggestionsView addSubview:ShowSuggestions];
            
            
            UIButton *DemoBlackButton = [[UIButton alloc]init];
            DemoBlackButton.frame = CGRectMake((screenWidth / 2) - 120, 140, 240, 40);
            [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
            [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
            DemoBlackButton.layer.cornerRadius = 20;
            DemoBlackButton.clipsToBounds = YES;
            [ShowUserSuggestionsView addSubview:DemoBlackButton];
            
            UIButton *DemoWhiteButton = [[UIButton alloc]init];
            DemoWhiteButton.frame = CGRectMake((screenWidth / 2) - 119, 141, 238, 38);
            [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
            [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
            DemoWhiteButton.layer.cornerRadius = 19;
            DemoWhiteButton.clipsToBounds = YES;
            [ShowUserSuggestionsView addSubview:DemoWhiteButton];

            UILabel *ShowFindText = [[UILabel alloc]init];
            ShowFindText.frame = CGRectMake((screenWidth / 2) - 120, 140, 240, 40);
            ShowFindText.text = CustomLocalisedString(@"Findorinviteyourfriends", nil);
            ShowFindText.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
            ShowFindText.textAlignment = NSTextAlignmentCenter;
            ShowFindText.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
            [ShowUserSuggestionsView addSubview:ShowFindText];
            
            UIButton *OpenInviteButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, screenWidth - 30, 154)];
            [OpenInviteButton setTitle:@"" forState:UIControlStateNormal];
            OpenInviteButton.backgroundColor = [UIColor clearColor];
            [OpenInviteButton addTarget:self action:@selector(OpenInviteButton:) forControlEvents:UIControlEventTouchUpInside];
            [ShowUserSuggestionsView addSubview:OpenInviteButton];
            
            NSInteger getwidth = 0;
            NSInteger FinalWidth = 0;
            NSInteger ProfileCount = 0;
            
            if ([User_ProfilePhotoArray count] <= 6) {
                ProfileCount = [User_ProfilePhotoArray count];
                getwidth = 50 * ProfileCount;
                FinalWidth = (screenWidth / 2) - (getwidth / 2);
            }else{
                ProfileCount = 6;
                getwidth = 300;
                FinalWidth = (screenWidth / 2) - (getwidth / 2);

            }
            FinalWidth -= 5;
            NSLog(@"FinalWidth is %ld",(long)FinalWidth);
            for (NSInteger i = 0; i < ProfileCount; i++) {
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(FinalWidth + i * 50, 65, 60, 60);
                ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=30;
                ShowUserProfileImage.layer.borderWidth=1;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[User_ProfilePhotoArray objectAtIndex:i]];
                if ([FullImagesURL_First length] == 0) {
                    ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
                }else{
                    NSURL *url = [NSURL URLWithString:FullImagesURL_First];
                    ShowUserProfileImage.imageURL = url;
                }
                
                [ShowUserSuggestionsView addSubview:ShowUserProfileImage];

            }

            
            
//            UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
//            SuggestionsLine.frame = CGRectMake(0, 0, screenWidth, 1);
//            [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
//            [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
//            [ShowUserSuggestionsView addSubview:SuggestionsLine];
//            
//            UILabel *ShowSuggestions = [[UILabel alloc]init];
//            // NSString *TempString = [[NSString alloc]initWithFormat:@"%@",CustomLocalisedString(@"FeaturedUserin", nil)];
//            ShowSuggestions.text = CustomLocalisedString(@"FeaturedUserin", nil);
//            //        ShowSuggestions.attributedText = [NSAttributedString dvs_attributedStringWithString:[TempString uppercaseString]
//            //                                                                                   tracking:200
//            //                                                                                       font:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
//            ShowSuggestions.frame = CGRectMake(15, 10, screenWidth - 30, 40);
//            ShowSuggestions.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
//            ShowSuggestions.textAlignment = NSTextAlignmentCenter;
//            ShowSuggestions.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
//            ShowSuggestions.backgroundColor = [UIColor clearColor];
//            [ShowUserSuggestionsView addSubview:ShowSuggestions];
//            
//            int TestWidth = screenWidth - 40;
//            //    NSLog(@"TestWidth is %i",TestWidth);
//            int FinalWidth = TestWidth / 4;
//            //    NSLog(@"FinalWidth is %i",FinalWidth);
//            int SpaceWidth = FinalWidth + 8;
//            
//            int HeightGet = FinalWidth * 2;
//            for ( int i = 0; i < 1; i ++) {
//                NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
//                NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
//                for (int z = 0; z < [SplitArray count]; z++) {
//                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
//                    ShowImage.frame = CGRectMake(8 +(z % 4) * SpaceWidth, 65 + i * HeightGet, FinalWidth, FinalWidth);
//                    ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//                    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//                    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//                    ShowImage.layer.cornerRadius=5;
//                    ShowImage.layer.masksToBounds = YES;
//                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//                    NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:z]];
//                    if ([FullImagesURL_First length] == 0) {
//                        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//                    }else{
//                        NSURL *url = [NSURL URLWithString:FullImagesURL_First];
//                        ShowImage.imageURL = url;
//                    }
//                    [ShowUserSuggestionsView addSubview:ShowImage];
//                }
//                
//                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
//                ShowUserProfileImage.frame = CGRectMake(15, (75 + FinalWidth) + i * HeightGet, 40, 40);
//                ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
//                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
//                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//                ShowUserProfileImage.layer.cornerRadius=20;
//                ShowUserProfileImage.layer.borderWidth=0.5;
//                ShowUserProfileImage.layer.masksToBounds = YES;
//                ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
//                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
//                NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[User_ProfilePhotoArray objectAtIndex:i]];
//                if ([FullImagesURL_First length] == 0) {
//                    ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
//                }else{
//                    NSURL *url = [NSURL URLWithString:FullImagesURL_First];
//                    ShowUserProfileImage.imageURL = url;
//                }
//                
//                [ShowUserSuggestionsView addSubview:ShowUserProfileImage];
//
//                UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
//                [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
//                OpenProfileButton.tag = i;
//                OpenProfileButton.backgroundColor = [UIColor clearColor];
//                [OpenProfileButton addTarget:self action:@selector(OpenProfileButton:) forControlEvents:UIControlEventTouchUpInside];
//                [ShowUserSuggestionsView addSubview:OpenProfileButton];
//
//                UIButton *FollowButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 40 - 15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
//                [FollowButton setTitle:@"" forState:UIControlStateNormal];
//                FollowButton.tag = i;
//                [FollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
//                FollowButton.backgroundColor = [UIColor clearColor];
//                [FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
//                [FollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateSelected];
//                [ShowUserSuggestionsView addSubview:FollowButton];
//                
//                UIButton *DenyButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 90 - 15, (75 + FinalWidth) + i * HeightGet, 40, 40)];
//                [DenyButton setTitle:@"" forState:UIControlStateNormal];
//                DenyButton.tag = i;
//                [DenyButton setImage:[UIImage imageNamed:@"FollowDeny.png"] forState:UIControlStateNormal];
//                DenyButton.backgroundColor = [UIColor clearColor];
//                [DenyButton addTarget:self action:@selector(DenyButton:) forControlEvents:UIControlEventTouchUpInside];
//                [ShowUserSuggestionsView addSubview:DenyButton];
//                
//                
//                UILabel *ShowName = [[UILabel alloc]init];
//                ShowName.frame = CGRectMake(65, (75 + FinalWidth) + i * HeightGet, screenWidth - 90 - 20, 20);
//                ShowName.text = [User_UserNameArray objectAtIndex:i];
//                ShowName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//                ShowName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//                [ShowUserSuggestionsView addSubview:ShowName];
//                
//                UILabel *ShowAddress = [[UILabel alloc]init];
//                ShowAddress.frame = CGRectMake(65, (95 + FinalWidth) + i * HeightGet, screenWidth - 90 - 30, 20);
//                ShowAddress.text = [User_LocationArray objectAtIndex:i];
//                ShowAddress.textColor = [UIColor grayColor];
//                ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//                [ShowUserSuggestionsView addSubview:ShowAddress];
//                
//                UIButton *SuggestionsLine = [UIButton buttonWithType:UIButtonTypeCustom];
//                SuggestionsLine.frame = CGRectMake(0, (130 + FinalWidth) + i * HeightGet + 20, screenWidth, 1);
//                [SuggestionsLine setTitle:@"" forState:UIControlStateNormal];
//                [SuggestionsLine setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
//                [ShowUserSuggestionsView addSubview:SuggestionsLine];
//                
//            }
            if (CheckLoad == YES) {
                heightcheck = MainScroll.contentSize.height - 80;
            }else{
                heightcheck = 194;
                
            }
        }
    }else{
        if (CheckLoad == YES) {
            heightcheck = MainScroll.contentSize.height - 80;
        }else{
            heightcheck = 0;
        }
    }
//    if (CheckPromotion == YES) {
//        AsyncImageView *BannerImage = [[AsyncImageView alloc]init];
//        BannerImage.frame = CGRectMake(0, heightcheck + 50, screenWidth, 50);
//        NSURL *tempurl = [NSURL URLWithString:GetPromotionImage];
//        BannerImage.imageURL = tempurl;
//        BannerImage.contentMode = UIViewContentModeScaleToFill;
//        BannerImage.backgroundColor = [UIColor blackColor];
//        [MainScroll addSubview:BannerImage];
//        
//        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        SelectButton.frame = CGRectMake(0, heightcheck + 50, screenWidth, 50);
//        [SelectButton setTitle:@"" forState:UIControlStateNormal];
//        [SelectButton setBackgroundColor:[UIColor clearColor]];
//        [SelectButton addTarget:self action:@selector(PromotionButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:SelectButton];
//        
//        heightcheck += 100;
//    }else{
//    
//    }
    
    if (CheckPromotion == YES) {
        heightcheck += 85;
    }else{
    
    }
    

    

    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        UIImage *image_;
        UIImage *newImage;
        if ([FullImagesURL_First length] == 0) {
            image_ = [UIImage imageNamed:@"NoImage.png"];
           // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, screenWidth);
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
         //   ShowImage.imageURL = url_NearbySmall;
            NSData *data = [[NSData alloc]initWithContentsOfURL:url_NearbySmall];
            image_ = [[UIImage alloc]initWithData:data];
        }
        float oldWidth = image_.size.width;
        float scaleFactor = screenWidth / oldWidth;
        
        float newHeight = image_.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image_ drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        ShowImage.image = newImage;
        
        ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, newImage.size.height);
       // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 200);
        [MainScroll addSubview:ShowImage];
        //heightcheck += 210;
        
//        NSLog(@"image_.size.height is %f",image_.size.height);
//        NSLog(@"newImage.size.height is %f",newImage.size.height);
        
//        UIImageView *ImageShade = [[UIImageView alloc]init];
//        ImageShade.frame = CGRectMake(0, heightcheck + i, screenWidth, 149);
//        ImageShade.image = [UIImage imageNamed:@"ImageShade.png"];
//        ImageShade.alpha = 0.2;
//        [MainScroll addSubview:ImageShade];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(0, heightcheck + i, screenWidth, newImage.size.height + 100);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:SelectButton];
    
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(15, newImage.size.height + 8 + heightcheck + i, 8, 11);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [MainScroll addSubview:ShowPin];

        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[DistanceArray objectAtIndex:i]];
        if ([TempDistanceString isEqualToString:@"0"]) {
            
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
           // NSLog(@"x_Nearby is %i",x_Nearby);

            NSString *FullShowLocatinString;
            if (x_Nearby < 100) {
                if (x_Nearby <= 1) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                }else{
                   FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                }
                
            }else{
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[SearchDisplayNameArray objectAtIndex:i]];

            }
            
          //  NSLog(@"FullShowLocatinString is %@",FullShowLocatinString);
            
            UILabel *ShowDistance = [[UILabel alloc]init];
            ShowDistance.frame = CGRectMake(screenWidth - 115, newImage.size.height + heightcheck + i, 100, 20);
           // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
            ShowDistance.text = FullShowLocatinString;
            ShowDistance.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowDistance.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowDistance.textAlignment = NSTextAlignmentRight;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowDistance];
        }


        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(30, newImage.size.height + 3 + heightcheck + i, screenWidth - 150, 20);
        //ShowAddress.frame = CGRectMake(30, 210 + 3 + heightcheck + i, screenWidth - 150, 20);
        ShowAddress.text = [PlaceNameArray objectAtIndex:i];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowAddress.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowAddress];


        
        heightcheck += newImage.size.height + 30;
        //heightcheck += 210 + 30;

        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
        }else{
            UILabel *ShowTitle = [[UILabel alloc]init];
            ShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
            ShowTitle.text = TempGetStirng;
            ShowTitle.backgroundColor = [UIColor clearColor];
            ShowTitle.numberOfLines = 2;
            ShowTitle.textAlignment = NSTextAlignmentLeft;
            ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
//            ShowTitle.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetStirng
//                                                                                               tracking:100
//                                                                                                   font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            [MainScroll addSubview:ShowTitle];
            
            if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
            {
                ShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowTitle.frame.size.height + 10;

         //   heightcheck += 30;
        }
        
        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
        TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
        if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
        }else{
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
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
            ShowMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//            ShowMessage.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetMessage
//                                                                                 tracking:100
//                                                                                     font:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [MainScroll addSubview:ShowMessage];
            
            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
            {
                ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            heightcheck += ShowMessage.frame.size.height + 10;
            //   heightcheck += 30;
        }

        
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(15, heightcheck + i , 30, 30);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = 15;
        ShowUserProfileImage.layer.borderWidth=0;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [MainScroll addSubview:ShowUserProfileImage];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            //NSLog(@"url is %@",url);
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        
        
        UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, heightcheck + i , 200, 30)];
        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
        OpenProfileButton.tag = i;
        OpenProfileButton.backgroundColor = [UIColor clearColor];
        [OpenProfileButton addTarget:self action:@selector(OpenProfileButton2:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenProfileButton];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(55, heightcheck + i, 200, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:15];
        [MainScroll addSubview:ShowUserName];
        
        NSString *CheckCommentTotal = [[NSString alloc]initWithFormat:@"%@",[TotalCommentArray objectAtIndex:i]];
        NSString *CheckLikeTotal = [[NSString alloc]initWithFormat:@"%@",[TotalLikeArray objectAtIndex:i]];
        NSString *CheckSelfLike = [[NSString alloc]initWithFormat:@"%@",[SelfCheckLikeArray objectAtIndex:i]];
        
        
        
        if ([CheckCommentTotal isEqualToString:@"0"]) {
//            UIButton *DemoBlackButton = [[UIButton alloc]init];
//            DemoBlackButton.frame = CGRectMake(screenWidth - 65, heightcheck + i + 10, 50, 40);
//            [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//            [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//            DemoBlackButton.layer.cornerRadius = 20;
//            DemoBlackButton.clipsToBounds = YES;
//            [MainScroll addSubview:DemoBlackButton];
//            
//            UIButton *DemoWhiteButton = [[UIButton alloc]init];
//            DemoWhiteButton.frame = CGRectMake(screenWidth - 64, heightcheck + i + 11, 48, 38);
//            [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//            [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//            DemoWhiteButton.layer.cornerRadius = 19;
//            DemoWhiteButton.clipsToBounds = YES;
//            DemoWhiteButton.tag = i;
//            [DemoWhiteButton addTarget:self action:@selector(OpenCommentButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:DemoWhiteButton];
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 23 - 15, heightcheck + i + 6 ,23, 19);
        //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
//                UIButton *DemoBlackButton = [[UIButton alloc]init];
//                DemoBlackButton.frame = CGRectMake(screenWidth - 130, heightcheck + i + 10, 50, 40);
//                [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//                DemoBlackButton.layer.cornerRadius = 20;
//                DemoBlackButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoBlackButton];
//                
//                UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                DemoWhiteButton.frame = CGRectMake(screenWidth - 129, heightcheck + i + 11, 48, 38);
//                [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                DemoWhiteButton.layer.cornerRadius = 19;
//                DemoWhiteButton.clipsToBounds = YES;
//                DemoWhiteButton.tag = i;
//                [DemoWhiteButton addTarget:self action:@selector(OpenLikesButton:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:DemoWhiteButton];
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 23 - 15 - 23 - 20 , heightcheck + i + 6 ,23, 19);
             //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [MainScroll addSubview:ShowLikesIcon];
            }else{
//                UIButton *DemoBlackButton = [[UIButton alloc]init];
//                DemoBlackButton.frame = CGRectMake(screenWidth - 145, heightcheck + i + 10, 70, 40);
//                [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//                }else{
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
//                }
//                
//                DemoBlackButton.layer.cornerRadius = 20;
//                DemoBlackButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoBlackButton];
//                
//                UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                DemoWhiteButton.frame = CGRectMake(screenWidth - 144, heightcheck + i + 11, 68, 38);
//                [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                DemoWhiteButton.layer.cornerRadius = 19;
//                DemoWhiteButton.clipsToBounds = YES;
//                DemoWhiteButton.tag = i;
//                [DemoWhiteButton addTarget:self action:@selector(OpenLikesButton:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:DemoWhiteButton];
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
            //    ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 78 - 23, heightcheck + i + 6 ,23, 19);
                [MainScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 78, heightcheck + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
            //    ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [MainScroll addSubview:ShowLikeCount];
            }
        }else{
//            UIButton *DemoBlackButton = [[UIButton alloc]init];
//            DemoBlackButton.frame = CGRectMake(screenWidth - 85, heightcheck + i + 10, 70, 40);
//            [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//            [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//            DemoBlackButton.layer.cornerRadius = 20;
//            DemoBlackButton.clipsToBounds = YES;
//            [MainScroll addSubview:DemoBlackButton];
//            
//            UIButton *DemoWhiteButton = [[UIButton alloc]init];
//            DemoWhiteButton.frame = CGRectMake(screenWidth - 84, heightcheck + i + 11, 68, 38);
//            [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//            [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//            DemoWhiteButton.layer.cornerRadius = 19;
//            DemoWhiteButton.clipsToBounds = YES;
//            DemoWhiteButton.tag = i;
//            [DemoWhiteButton addTarget:self action:@selector(OpenCommentButton:) forControlEvents:UIControlEventTouchUpInside];
//            [MainScroll addSubview:DemoWhiteButton];
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 35 - 23 , heightcheck + i + 6 ,23, 19);
          //  ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            UILabel *ShowCommentCount = [[UILabel alloc]init];
            ShowCommentCount.frame = CGRectMake(screenWidth - 20 - 15, heightcheck + i, 20, 30);
            ShowCommentCount.text = CheckCommentTotal;
            ShowCommentCount.textAlignment = NSTextAlignmentRight;
         //   ShowCommentCount.backgroundColor = [UIColor redColor];
            ShowCommentCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowCommentCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            [MainScroll addSubview:ShowCommentCount];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
//                UIButton *DemoBlackButton = [[UIButton alloc]init];
//                DemoBlackButton.frame = CGRectMake(screenWidth - 140, heightcheck + i + 10, 50, 40);
//                [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//                DemoBlackButton.layer.cornerRadius = 20;
//                DemoBlackButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoBlackButton];
//                
//                UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                DemoWhiteButton.frame = CGRectMake(screenWidth - 139, heightcheck + i + 11, 48, 38);
//                [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                DemoWhiteButton.layer.cornerRadius = 19;
//                DemoWhiteButton.clipsToBounds = YES;
//                DemoWhiteButton.tag = i;
//                [DemoWhiteButton addTarget:self action:@selector(OpenLikesButton:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:DemoWhiteButton];
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 101, heightcheck + i + 6 ,23, 19);
               // ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [MainScroll addSubview:ShowLikesIcon];
            }else{
//                UIButton *DemoBlackButton = [[UIButton alloc]init];
//                DemoBlackButton.frame = CGRectMake(screenWidth - 165, heightcheck + i + 10, 70, 40);
//                [DemoBlackButton setTitle:@"" forState:UIControlStateNormal];
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f]];
//                }else{
//                    [DemoBlackButton setBackgroundColor:[UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
//                }
//                
//                DemoBlackButton.layer.cornerRadius = 20;
//                DemoBlackButton.clipsToBounds = YES;
//                [MainScroll addSubview:DemoBlackButton];
//                
//                UIButton *DemoWhiteButton = [[UIButton alloc]init];
//                DemoWhiteButton.frame = CGRectMake(screenWidth - 164, heightcheck + i + 11, 68, 38);
//                [DemoWhiteButton setTitle:@"" forState:UIControlStateNormal];
//                [DemoWhiteButton setBackgroundColor:[UIColor whiteColor]];
//                DemoWhiteButton.layer.cornerRadius = 19;
//                DemoWhiteButton.clipsToBounds = YES;
//                DemoWhiteButton.tag = i;
//                [DemoWhiteButton addTarget:self action:@selector(OpenLikesButton:) forControlEvents:UIControlEventTouchUpInside];
//                [MainScroll addSubview:DemoWhiteButton];
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
             //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 121, heightcheck + i + 6 ,23, 19);
                [MainScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 98, heightcheck + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
               // ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [MainScroll addSubview:ShowLikeCount];
            }
            
        
        }
        
        heightcheck += 55;
      //  heightcheck += newImage.size.height + 10;
        
        UIImageView *ShowGradient = [[UIImageView alloc]init];
        ShowGradient.frame = CGRectMake(0, heightcheck + i, screenWidth, 25);
        ShowGradient.image = [UIImage imageNamed:@"FeedGradient.png"];
        [MainScroll addSubview:ShowGradient];
        heightcheck += 24;
        
        
        [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + i)];
    }
    
    
    

    [ShowActivity stopAnimating];
  //  [ShowActivity removeFromSuperview];
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    CheckLoadDone = YES;
}
-(IBAction)PromotionButton:(id)sender{
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:GetPromotionUserName];
}
-(IBAction)FollowButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        CheckFollow = getbuttonIDN;
        buttonWithTag1.userInteractionEnabled = NO;
    }else{
    }
    
    GetUserID = [[NSString alloc]initWithFormat:@"%@",[User_IDArray objectAtIndex:getbuttonIDN]];
    
//    TotalPage = 0;
//    CurrentPage = 0;
//    DataCount = 0;
//    DataTotal = 0;
    
    [self SendFollowUserData];
}
-(IBAction)DenyButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    [User_IDArray removeObjectAtIndex:getbuttonIDN];
    [User_NameArray removeObjectAtIndex:getbuttonIDN];
    [User_LocationArray removeObjectAtIndex:getbuttonIDN];
    [User_ProfilePhotoArray removeObjectAtIndex:getbuttonIDN];
    [User_PhotoArray removeObjectAtIndex:getbuttonIDN];
    [User_UserNameArray removeObjectAtIndex:getbuttonIDN];
    for (UIView *subview in ShowUserSuggestionsView.subviews) {
        [subview removeFromSuperview];
    }
    [self InitView_V2];
}
-(IBAction)SelectButton:(id)sender{
    CheckGoPost = 100;
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
   // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc] ;
   // [self presentModalViewController:navController animated:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    
}
//-(void)GetUserSuggestions{
//   // [ShowActivity startAnimating];
//   //  [self.spinnerView startAnimating];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
//    
//    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&number_of_suggestions=2",DataUrl.Suggestions_Url,GetExpertToken];
//    
//    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
//    NSLog(@"MainView check postBack URL ==== %@",postBack);
//    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURL *url = [NSURL URLWithString:postBack];
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    NSLog(@"theRequest === %@",theRequest);
//    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
//    
//    theConnection_UserSuggestions = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    [theConnection_UserSuggestions start];
//    
//    
//    if( theConnection_UserSuggestions ){
//        webData = [NSMutableData data];
//    }
//}
-(void)SendFollowUserData{
    NSLog(@"GetUserID is %@",GetUserID);
   // [ShowActivity startAnimating];
    // [self.spinnerView startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow",DataUrl.UserWallpaper_Url,GetUserID];
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
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_Following = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Following) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)GetFeedDataFromServer{
   // [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
    
    
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] || [ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }else{
    
    }
    

    NSString *FullString;
    if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
        FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&ip_address=%@",DataUrl.Feed_Url,GetExpertToken,ExternalIPAddress];
    }else{//ip_address=119.92.244.146
        FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&lat=%@&lng=%@&ip_address=%@",DataUrl.Feed_Url,GetExpertToken,latPoint,lonPoint,ExternalIPAddress];
    }
    
    if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
        
    }else{
        FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
    }
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        
    }else{
        FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
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
-(void)GetMoreFeedData{
    NSLog(@"in here getmorefeeddata");
    if (CurrentPage == TotalPage) {
        NSLog(@"here ????");
    }else{
      //  [ShowActivity startAnimating];
        CurrentPage += 1;
         NSLog(@"or here ????");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
        NSString *FullString;
        if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&page=%li",DataUrl.Feed_Url,GetExpertToken,(long)CurrentPage];
        }else{
            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&page=%li&lat=%@&lng=%@",DataUrl.Feed_Url,GetExpertToken,(long)CurrentPage,latPoint,lonPoint];
        }
        
        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
        }
        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
        }
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_MorePost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_MorePost start];
        
        
        if( theConnection_MorePost ){
            webData = [NSMutableData data];
        }
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
//    //  [HUD hide:YES];
//    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
//    
//    ShowNoDataView.hidden = NO;
//     [spinnerView stopAnimating];
//     [spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];
   // [ShowActivity removeFromSuperview];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Feed return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:GetData forKey:@"LocalFeed_JsonData"];
                [defaults setInteger:DontLoadAgain forKey:@"LocalFeed_DontLoadAgain"];
                [defaults synchronize];
                
                NSDictionary *GetAllData = [res valueForKey:@"data"];
               // NSLog(@"GetAllData ===== %@",GetAllData);
                
                //start filter data
                NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"page"]];
               // NSLog(@"Temppage is %@",Temppage);
                NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_page"]];
              //  NSLog(@"Temptotal_page is %@",Temptotal_page);
               // NSString *TempCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"count"]];
              //  NSLog(@"TempCount is %@",TempCount);
    
                CurrentPage = [Temppage intValue];
                TotalPage = [Temptotal_page intValue];
                
                if (TotalPage == 0) {
                    //KosongView.hidden = NO;
                    CheckFirstTimeUser = YES;
                 //   CountFollowFirstTime = 3;
                }else{
                  //  CountFollowFirstTime = 1;
                    KosongView.hidden = YES;
                }
              //  NSLog(@"CountFollowFirstTime is ====== %li",(long)CountFollowFirstTime);
                if ([GetAllData count] == 0) {
                //no data
                   
                }else{
                    NSArray *PostsData = [GetAllData valueForKey:@"posts"];
                 //   NSLog(@"PostsData is %@",PostsData);
                    if ([PostsData count] == 0) {
                        NSLog(@"No data");
                      //  KosongView.hidden = NO;
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
                        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
                            CheckFirstTimeUser = YES;
                         //   CountFollowFirstTime = 3;
                        }else{
                        }
                    }else{
                        NSLog(@"got data");
                        KosongView.hidden = YES;
                       // CountFollowFirstTime = 1;
                        
                    }
                    
                    NSDictionary *locationData = [PostsData valueForKey:@"location"];
                    DistanceArray = [[NSMutableArray alloc]init];
                    SearchDisplayNameArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in locationData) {
                        NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [DistanceArray addObject:formatted_address];
                        NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                        [SearchDisplayNameArray addObject:SearchDisplayName];
                    }
                  //  NSLog(@"SearchDisplayNameArray is %@",SearchDisplayNameArray);
                    
                    
                    
                    UpdatedTimeArray = [[NSMutableArray alloc]init];
                    SelfCheckLikeArray = [[NSMutableArray alloc]init];
                    TotalLikeArray = [[NSMutableArray alloc]init];
                    TotalCommentArray = [[NSMutableArray alloc]init];
                    PostIDArray = [[NSMutableArray alloc]init];
                    PlaceNameArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in PostsData) {
                        NSString *updated_at = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"updated_at"]];
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *date = [dateFormat dateFromString:updated_at];
                     //   NSLog(@"datedata is %@",date);
                        
                        NSDateFormatter *f = [[NSDateFormatter alloc] init];
                        [f setDateFormat:@"yyyy-MM-dd"];
                       // NSDate *startDate = [f dateFromString:start];
                        NSDate *now = [NSDate date];
                        
                        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                            fromDate:date
                                                                              toDate:now
                                                                             options:0];
                        
                        NSString *CheckString = [[NSString alloc]initWithFormat:@"%ld",(long)[components day]];
                        if ([CheckString isEqualToString:@"0"]) {
                            NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:date];
                            double secondsInAnHour = 3600;
                            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
                            // NSLog(@"%ld", [components day]);
                          //  NSLog(@"%ld",(long)hoursBetweenDates);
                            NSString *CheckString = [[NSString alloc]initWithFormat:@"%ldh",(long)hoursBetweenDates];
                            [UpdatedTimeArray addObject:CheckString];
                        }else{
                            NSString *CheckString_ = [[NSString alloc]initWithFormat:@"%@d",CheckString];
                        [UpdatedTimeArray addObject:CheckString_];
                        }
                       
                        NSString *SelfCheck = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [SelfCheckLikeArray addObject:SelfCheck];
                        NSString *total_like = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [TotalLikeArray addObject:total_like];
                        NSString *total_comments = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [TotalCommentArray addObject:total_comments];
                        NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray addObject:PlaceID];
                        NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [PlaceNameArray addObject:PlaceName];
                        
                    }
                 //   NSLog(@"TotalLikeArray is %@",TotalLikeArray);
                 //   NSLog(@"SelfCheckLikeArray is %@",SelfCheckLikeArray);
                //    NSLog(@"TotalCommentArray is %@",TotalCommentArray);
                    
                    NSDictionary *titleData = [PostsData valueForKey:@"title"];
                    
                    TitleArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in titleData) {
                 //       NSLog(@"dict is %@",dict);
                        if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                     //       NSLog(@"titleData nil");
                            [TitleArray addObject:@""];
//                            [LangArray addObject:@"English"];
                        }else{
                      //      NSLog(@"titleData got data");
                                NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                                NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                                NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                                NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                                NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        //        NSLog(@"Title1 is %@",Title1);
                        //        NSLog(@"Title2 is %@",Title2);
                                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                                    if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                        if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                            if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                                if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                                    [TitleArray addObject:@""];
                                                }else{
                                                    [TitleArray addObject:PhilippinesTitle];
                                                    
                                                }
                                            }else{
                                                [TitleArray addObject:IndonesianTitle];
                                                
                                            }
                                        }else{
                                            [TitleArray addObject:ThaiTitle];
                                        }
                                    }else{
                                        [TitleArray addObject:Title2];
                                    }
                                    
                                }else{
                                    [TitleArray addObject:Title1];
                                    
                                }
                            
                        }
                            
                    }
                    
                    NSDictionary *messageData = [PostsData valueForKey:@"message"];
                    
                    MessageArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in messageData) {
              //          NSLog(@"dict is %@",dict);
                        if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
              //              NSLog(@"titleData nil");
                            [MessageArray addObject:@""];
                            //                            [LangArray addObject:@"English"];
                        }else{
                 //           NSLog(@"titleData got data");
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
              //              NSLog(@"Title1 is %@",Title1);
               //             NSLog(@"Title2 is %@",Title2);
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                                if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                    if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                        if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                                [MessageArray addObject:@""];
                                            }else{
                                                [MessageArray addObject:PhilippinesTitle];
                                                
                                            }
                                        }else{
                                            [MessageArray addObject:IndonesianTitle];
                                            
                                        }
                                    }else{
                                        [MessageArray addObject:ThaiTitle];
                                    }
                                }else{
                                    [MessageArray addObject:Title2];
                                }
                                
                            }else{
                                [MessageArray addObject:Title1];
                                
                            }
                            
                        }
                        
                    }
                    
                    NSDictionary *UserInfoData = [PostsData valueForKey:@"user_info"];
                    NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                    
                    UserInfo_NameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                    for (NSDictionary * dict in UserInfoData) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray addObject:username];
                    }
                    UserInfo_UrlArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ProfilePhoto count]];
                    for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray addObject:url];
                    }
                    
                    
                    NSArray *PhotoData = [PostsData valueForKey:@"photos"];
           //         NSLog(@"PhotoData is %@",PhotoData);
//                    NSDictionary *PhotoData_ImageSize = [PhotoData valueForKey:@"s"];
//                    NSLog(@"PhotoData_ImageSize is %@",PhotoData_ImageSize);
                    
                    PhotoArray = [[NSMutableArray alloc]init];
                    PhotoCaptionArray = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary * dict in PhotoData) {
               //         NSLog(@"can in %@",dict);
                        NSMutableArray *captionArray = [[NSMutableArray alloc]init];
                        NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict_ in dict) {
               //             NSLog(@"dict_ in %@",dict_);
                            NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                            //  [UserInfo_NameArray addObject:username];
              //              NSLog(@"captionata is %@",caption);
                            [captionArray addObject:caption];
                            NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                  //          NSLog(@"UserInfoData is %@",UserInfoData);
                            
                            NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                   //         NSLog(@"url is %@",url);
                            [UrlArray addObject:url];
                        }
                        NSString *result = [captionArray componentsJoinedByString:@","];
                        [PhotoCaptionArray addObject:result];
                        NSString *result2 = [UrlArray componentsJoinedByString:@","];
                        [PhotoArray addObject:result2];
                    }
                    
                    DataCount = 0;
                    DataTotal = [TitleArray count];
                    
                    NSDictionary *GetFollowUserData = [res valueForKey:@"follow_suggestions"];
              //      NSLog(@"GetFollowUserData ===== %@",GetFollowUserData);
                    
                    if ([GetFollowUserData count] > 0) {
                  //      NSLog(@"need show user suggestions");
                  //      NSString *GetTotalFollowingUser = [[NSString alloc]initWithFormat:@"%@",[GetFollowUserData objectForKey:@"total_following_users"]];
                 //       NSLog(@"GetTotalFollowingUser is %@",GetTotalFollowingUser);
                  //      NSString *GetTotalRandomUser = [[NSString alloc]initWithFormat:@"%@",[GetFollowUserData objectForKey:@"total_random_users"]];
                 //       NSLog(@"GetTotalRandomUser is %@",GetTotalRandomUser);
                        
                        CheckSuggestions = YES;
                        
                        NSDictionary *GetAllData = [GetFollowUserData valueForKey:@"random_users"];
                      //  NSLog(@"GetAllData ===== %@",GetAllData);
                        
                        User_IDArray = [[NSMutableArray alloc]init];
                        User_LocationArray = [[NSMutableArray alloc]init];
                        User_NameArray = [[NSMutableArray alloc]init];
                        User_ProfilePhotoArray = [[NSMutableArray alloc]init];
                        User_PhotoArray = [[NSMutableArray alloc]init];
                        User_UserNameArray = [[NSMutableArray alloc]init];
                        
                        for (NSDictionary * dict in GetAllData) {

                            NSString *GetUserID_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                            [User_IDArray addObject:GetUserID_];
                            NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                            [User_LocationArray addObject:GetLocation];
                            NSString *GetName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                            [User_NameArray addObject:GetName];
                            NSString *GetProfilePhoto = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                            [User_ProfilePhotoArray addObject:GetProfilePhoto];
                            NSString *GetUserName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                            [User_UserNameArray addObject:GetUserName];
                            NSDictionary *PostsData = [dict valueForKey:@"posts"];
                            NSMutableArray *TempPhotoArray = [[NSMutableArray alloc]init];
                            for (NSDictionary * dict in PostsData) {
                                NSString *GetPhoto = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"photos"]];
                                [TempPhotoArray addObject:GetPhoto];
                            }
                            NSString *result = [TempPhotoArray componentsJoinedByString:@","];
                            [User_PhotoArray addObject:result];
                        }
                        
//                        NSLog(@"User_IDArray is %@",User_IDArray);
//                        NSLog(@"User_NameArray is %@",User_NameArray);
//                        NSLog(@"User_LocationArray is %@",User_LocationArray);
//                        NSLog(@"User_ProfilePhotoArray is %@",User_ProfilePhotoArray);
//                        NSLog(@"User_PhotoArray is %@",User_PhotoArray);
                    }else{
                  //      NSLog(@"more then 30 no need show user suggestions");
                        CheckSuggestions = NO;
                        KosongView.hidden = YES;
                    }
                    
                    NSDictionary *GetPromotionData = [res valueForKey:@"promotion"];
                    if ([GetPromotionData count] > 0) {
                        CheckPromotion = YES;
                        for (NSDictionary * dict in GetPromotionData){
                            GetPromotionImage = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"image"]];
                            NSDictionary *UserData = [dict valueForKey:@"user"];
                            GetPromotionUserName = [[NSString alloc]initWithFormat:@"%@",[UserData valueForKey:@"username"]];
                        }

                    }else{
                        CheckPromotion = NO;
                    
                    }
                    
                    NSLog(@"GetPromotionImage is %@",GetPromotionImage);
                    NSLog(@"GetPromotionUserName is %@",GetPromotionUserName);
            
                    [ShowUserSuggestionsView removeFromSuperview];
                    [self InitView_V2];
                }
                
            }
        }
    }else if(connection == theConnection_Following){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
     //   NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
     //   NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
     //   NSLog(@"ResultString is %@",ResultString);
        [ShowActivity stopAnimating];
        if ([ResultString isEqualToString:@"ok"]) {
//            AddFollowCount++;
////            if (CheckFollow == 2) {
////                CheckFollow = 0;
//
////            }
//            if (AddFollowCount < 2) {
//                [User_IDArray removeObjectAtIndex:CheckFollow];
//                [User_NameArray removeObjectAtIndex:CheckFollow];
//                [User_LocationArray removeObjectAtIndex:CheckFollow];
//                [User_ProfilePhotoArray removeObjectAtIndex:CheckFollow];
//                [User_PhotoArray removeObjectAtIndex:CheckFollow];
//                [User_UserNameArray removeObjectAtIndex:CheckFollow];
//                
//                if ([User_UserNameArray count] <= 2) {
//                    for (UIView *subview in ShowUserSuggestionsView.subviews) {
//                        [subview removeFromSuperview];
//                    }
//                    CheckSuggestions = NO;
//                    [self InitView_V2];
//                }else{
//                    for (UIView *subview in ShowUserSuggestionsView.subviews) {
//                        [subview removeFromSuperview];
//                    }
//                    [self InitView_V2];
//                }
//            }else{
//                AddFollowCount = 0;

//            }
            
            if (CheckFirstTimeUser == YES) {
                 CountFollowFirstTime --;
            }
            NSLog(@"after follow CountFollowFirstTime is %li",(long)CountFollowFirstTime);
            if (CountFollowFirstTime == 1) {
                NSLog(@"in here got remove mainscroll");
                CountFollowFirstTime = 1;
                for (UIView *subview in MainScroll.subviews) {
                    [subview removeFromSuperview];
                }
                CheckFirstTimeUser = NO;
                TotalPage = 0;
                CurrentPage = 0;
                DataCount = 0;
                DataTotal = 0;
                CheckLoadDone = NO;
                [self GetFeedDataFromServer];
                if (CheckLoadDone == NO) {
//                    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//                    spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//                    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//                    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//                    spinnerView.lineWidth = 1.0f;
//                    [self.view addSubview:spinnerView];
//                    [spinnerView startAnimating];
                    [ShowActivity startAnimating];
                }
            }else{
                NSLog(@"in here not remove mainscroll");
                CheckLoadDone = NO;
                [self GetFeedDataFromServer];
                if (CheckLoadDone == NO) {
//                    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//                    spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//                    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//                    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//                    spinnerView.lineWidth = 1.0f;
//                    [self.view addSubview:spinnerView];
//                    [spinnerView startAnimating];
                    [ShowActivity startAnimating];

                }
            }
            
            
            

 
        }
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
     //   NSLog(@"Feed return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
     //   NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
                //start filter data
                
                NSDictionary *GetAllData = [res valueForKey:@"data"];
           //     NSLog(@"GetAllData ===== %@",GetAllData);
                
                if ([GetAllData count] == 0) {
                    //no data
                }else{
                    NSArray *PostsData = [GetAllData valueForKey:@"posts"];
                    
                    NSDictionary *locationData = [PostsData valueForKey:@"location"];
                    for (NSDictionary * dict in locationData) {
                        NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                        [DistanceArray addObject:formatted_address];
                        NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                        [SearchDisplayNameArray addObject:SearchDisplayName];
                    }
               //     NSLog(@"DistanceArray is %@",DistanceArray);
                    
                    for (NSDictionary * dict in PostsData) {
                        NSString *updated_at = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"updated_at"]];
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *date = [dateFormat dateFromString:updated_at];
                  //      NSLog(@"datedata is %@",date);
                        
                        NSDateFormatter *f = [[NSDateFormatter alloc] init];
                        [f setDateFormat:@"yyyy-MM-dd"];
                        // NSDate *startDate = [f dateFromString:start];
                        NSDate *now = [NSDate date];
                        
                        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                            fromDate:date
                                                                              toDate:now
                                                                             options:0];
                        
                        NSString *CheckString = [[NSString alloc]initWithFormat:@"%ld",(long)[components day]];
                        if ([CheckString isEqualToString:@"0"]) {
                            NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:date];
                            double secondsInAnHour = 3600;
                            NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
                            // NSLog(@"%ld", [components day]);
                     //       NSLog(@"%ld",(long)hoursBetweenDates);
                            NSString *CheckString = [[NSString alloc]initWithFormat:@"%ldh",(long)hoursBetweenDates];
                            [UpdatedTimeArray addObject:CheckString];
                        }else{
                            NSString *CheckString_ = [[NSString alloc]initWithFormat:@"%@d",CheckString];
                            [UpdatedTimeArray addObject:CheckString_];
                        }
                        
                        NSString *SelfCheck = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"like"]];
                        [SelfCheckLikeArray addObject:SelfCheck];
                        NSString *total_like = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                        [TotalLikeArray addObject:total_like];
                        NSString *total_comments = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                        [TotalCommentArray addObject:total_comments];
                        NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [PostIDArray addObject:PlaceID];
                        NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [PlaceNameArray addObject:PlaceName];
                        
                    }
                    
                    
                    NSDictionary *titleData = [PostsData valueForKey:@"title"];
                    for (NSDictionary * dict in titleData) {
              //          NSLog(@"titleData is %@",titleData);
                        if ([dict count] == 0 || dict == nil || [dict objectForKey:@"530b0ab26424400c76000003"] == nil) {
                //            NSLog(@"titleData nil");
                            [TitleArray addObject:@""];
                            //                            [LangArray addObject:@"English"];
                        }else{
                   //         NSLog(@"titleData got data");
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                   //         NSLog(@"Title1 is %@",Title1);
                   //         NSLog(@"Title2 is %@",Title2);
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                                if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                    if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                        if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                                [TitleArray addObject:@""];
                                            }else{
                                                [TitleArray addObject:PhilippinesTitle];
                                                
                                            }
                                        }else{
                                            [TitleArray addObject:IndonesianTitle];
                                            
                                        }
                                    }else{
                                        [TitleArray addObject:ThaiTitle];
                                    }
                                }else{
                                    [TitleArray addObject:Title2];
                                }
                                
                            }else{
                                [TitleArray addObject:Title1];
                                
                            }
                        }
                    }
               //     NSLog(@"TitleArray is %@",TitleArray);
                    
                    NSDictionary *messageData = [PostsData valueForKey:@"message"];
                    for (NSDictionary * dict in messageData) {
                   //     NSLog(@"dict is %@",dict);
                        if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                     //       NSLog(@"titleData nil");
                            [MessageArray addObject:@""];
                            //                            [LangArray addObject:@"English"];
                        }else{
                      //      NSLog(@"titleData got data");
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                       //     NSLog(@"Title1 is %@",Title1);
                       //     NSLog(@"Title2 is %@",Title2);
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                                if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                    if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                        if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                                [MessageArray addObject:@""];
                                            }else{
                                                [MessageArray addObject:PhilippinesTitle];
                                                
                                            }
                                        }else{
                                            [MessageArray addObject:IndonesianTitle];
                                            
                                        }
                                    }else{
                                        [MessageArray addObject:ThaiTitle];
                                    }
                                }else{
                                    [MessageArray addObject:Title2];
                                }
                                
                            }else{
                                [MessageArray addObject:Title1];
                                
                            }
                            
                        }
                        
                    }
                //    NSLog(@"MessageArray is %@",MessageArray);
                    
                    NSDictionary *UserInfoData = [PostsData valueForKey:@"user_info"];
                    NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                    for (NSDictionary * dict in UserInfoData) {
                        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                        [UserInfo_NameArray addObject:username];
                    }
                    for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                        [UserInfo_UrlArray addObject:url];
                    }
                    
                    
                    NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                //    NSLog(@"PhotoData is %@",PhotoData);
                    
                    for (NSDictionary * dict in PhotoData) {
                //        NSLog(@"can in %@",dict);
                        NSMutableArray *captionArray = [[NSMutableArray alloc]init];
                        NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict_ in dict) {
                   //         NSLog(@"dict_ in %@",dict_);
                            NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                            //  [UserInfo_NameArray addObject:username];
                   //         NSLog(@"captionata is %@",caption);
                            [captionArray addObject:caption];
                            NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                    //        NSLog(@"UserInfoData is %@",UserInfoData);
                            
                            NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                   //         NSLog(@"url is %@",url);
                            [UrlArray addObject:url];
                        }
                        NSString *result = [captionArray componentsJoinedByString:@","];
                        [PhotoCaptionArray addObject:result];
                        NSString *result2 = [UrlArray componentsJoinedByString:@","];
                        [PhotoArray addObject:result2];
                    }
                    
                    DataCount = DataTotal;
                    DataTotal = [TitleArray count];
                    [self InitView_V2];
                    CheckLoad = NO;
                    [activityindicator1 stopAnimating];
                }
                
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //get back
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetBackCheckAPI = [defaults objectForKey:@"CheckAPI"];
            NSString *GetBackAPIVersion = [defaults objectForKey:@"APIVersionSet"];

            //cancel clicked ...do your action
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
            for (NSString *key in [defaultsDictionary allKeys]) {
                NSLog(@"removing user pref for %@", key);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            //save back
            [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
            [defaults setObject:GetBackAPIVersion forKey:@"APIVersionSet"];
            [defaults synchronize];
            
            
            LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }else{
            //reset clicked
        }
    }
    
}
-(IBAction)NearbyButton:(id)sender{
    if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {


        SearchViewV2 *SearchView = [[SearchViewV2 alloc]init];
        [self presentViewController:SearchView animated:YES completion:nil];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
        NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
        NSMutableArray *GetNameArray;
        if ([GetSystemLanguage isEqualToString:@"English"]) {
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
        }else if([GetSystemLanguage isEqualToString:@"繁體中文"] || [GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Tw"]];
        }else if([GetSystemLanguage isEqualToString:@"简体中文"] || [GetSystemLanguage isEqualToString:@"Simplified Chinese"] || [GetSystemLanguage isEqualToString:@"中文"]){
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Cn"]];
        }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_In"]];
        }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Fn"]];
        }else if([GetSystemLanguage isEqualToString:@"ภาษาไทย"] || [GetSystemLanguage isEqualToString:@"Thai"]){
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Th"]];
        }else{
            GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
        }
        
        NSMutableArray *CategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
        NSString *JoinAllCategoryID = [CategoryIDArray componentsJoinedByString:@","];
        //NSMutableArray *CategoryNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
        NSString *JoinAllCategoryName = [GetNameArray componentsJoinedByString:@","];
        
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
        [SearchDetailView SearchCategory:JoinAllCategoryID Getlat:latPoint GetLong:lonPoint GetCategoryName:JoinAllCategoryName];
        [SearchDetailView GetTitle:@"All"];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 5000) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            NSLog(@"we are at the end");
            if (CheckLoad == YES) {
                
            }else{
                if (CheckFirstTimeUser == NO) {
                    
                    if (CurrentPage == TotalPage) {
                        
                    }else{
                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                        
                        [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 50)];
                        // MainScroll.frame = CGRectMake(0, heightcheck, screenWidth, MainScroll.frame.size.height + 20);
                        activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, heightcheck + 20, 30, 30)];
                        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                        [MainScroll addSubview:activityindicator1];
                        [activityindicator1 startAnimating];
                        [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 80)];
                        //[MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + MainScroll.frame.size.height)];
                        [self GetMoreFeedData];
                        CheckLoad = YES;
                    }

                }else{

                }

            }
            
        }
    }else{
    
    }

}
-(IBAction)OpenProfileButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)OpenProfileButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[User_UserNameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)OpenCommentButton:(id)sender{
    NSLog(@"Open Commenut Button Click");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    CommentViewController *CommentView = [[CommentViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:NO completion:nil];
    [CommentView GetRealPostIDAndAllComment:[PostIDArray objectAtIndex:getbuttonIDN]];
    [CommentView GetWhatView:@"Comment"];
}



-(IBAction)OpenLikesButton:(id)sender{
    NSLog(@"Open Likes Button Click");
}
-(IBAction)FiltersButton:(id)sender{
    NSLog(@"Open Filters Button Click");
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    [self presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Feed"];
}

-(IBAction)OpenInviteButton:(id)sender{
    InviteFrenViewController *InviteFrenView = [[InviteFrenViewController alloc]init];
    [self presentViewController:InviteFrenView animated:YES completion:nil];
}
@end

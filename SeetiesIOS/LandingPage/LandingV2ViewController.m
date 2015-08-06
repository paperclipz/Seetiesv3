//
//  LandingV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "LandingV2ViewController.h"
#import "AppDelegate.h"
#import "ExpertLoginViewController.h"
#import "PTnCViewController.h"
#import "AsyncImageView.h"
#import "WhyWeUseFBViewController.h"
#import "SignupViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "PTellUsYourCityViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "ProfileV2ViewController.h"
#import "PublishMainViewController.h"

#import "PTellUsYourCityViewController.h"
#import "PSelectYourInterestViewController.h"
#import "PFollowTheExpertsViewController.h"
#import "SelectImageViewController.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

#import "FeedV2ViewController.h"

#import <Parse/Parse.h>
#import "InstagramLoginWebViewController.h"

#import "CRMotionView.h"
#import "LeveyTabBarController.h"
#import "RecommendPopUpViewController.h"

#import "TestFeedV2ViewController.h"
#import "NewProfileV2ViewController.h"
@interface LandingV2ViewController ()

@end

@implementation LandingV2ViewController
@synthesize leveyTabBarController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    FBLoginButton.hidden = YES;
    FBLoginButton.layer.cornerRadius = 5;
    LogInButton.hidden = YES;
    WhyWeUseFBButton.hidden = YES;
    SignUpWithEmailButton.hidden = YES;
    InstagramButton.hidden = YES;
    InstagramButton.layer.cornerRadius = 5;
    
    MainText.text = NSLocalizedString(@"LandingPage_MainText", nil);
    [FBLoginButton setTitle:NSLocalizedString(@"LandingPage_ContinueFacebook",nil) forState:UIControlStateNormal];
    [LogInButton setTitle:NSLocalizedString(@"LandingPage_Login",nil) forState:UIControlStateNormal];
    [WhyWeUseFBButton setTitle:NSLocalizedString(@"LandingPage_WhyUseFacebook",nil) forState:UIControlStateNormal];
   // [SignUpWithEmailButton setTitle:NSLocalizedString(@"LandingPage_SignupWithEmail",nil) forState:UIControlStateNormal];
    [SignUpWithEmailButton setTitle:@"Sign up" forState:UIControlStateNormal];

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    FBLoginButton.frame = CGRectMake((screenWidth/2) - 130, screenHeight - 256, 260, 50);
    LogInButton.frame = CGRectMake((screenWidth/2) + 130 - 74, screenHeight - 130, 74, 34);
    WhyWeUseFBButton.frame = CGRectMake(0, screenHeight - 128, screenWidth, 34);
    InstagramButton.frame = CGRectMake((screenWidth/2) - 130, screenHeight - 198, 260, 50);
    SignUpWithEmailButton.frame = CGRectMake((screenWidth/2) - 130, screenHeight - 130, 125, 34);
    MainText.frame = CGRectMake(30, 150, screenWidth - 60, 65);
    MainLogo.frame = CGRectMake((screenWidth/2) - 104, 70, 208, 82);
    ShowBackgroundImage.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    ShowTnCText.frame = CGRectMake(30, screenHeight - 70, screenWidth - 60, 50);
    
    [self DeleteAllSaveData];
    

//    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DemoTest.png"]];
//    [motionView setContentView:imageView];
//    [BackgroundView addSubview:motionView];
//    [motionView setScrollDragEnabled:YES];
//    [motionView setScrollBounceEnabled:NO];
    
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//        
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        if( screenHeight < screenWidth ){
//            screenHeight = screenWidth;
//        }
//        if( screenHeight > 480 && screenHeight < 667 ){
//            //   NSLog(@"iPhone 5/5s");
//            animationImages = @[[UIImage imageNamed:@"640x1136-01.jpg"], [UIImage imageNamed:@"640x1136-03.jpg"], [UIImage imageNamed:@"640x1136-04.jpg"]];
//            //  ShowBackgroundImage.image = [UIImage imageNamed:@"LandingBackground.jpg"];
//        } else if ( screenHeight > 480 && screenHeight < 736 ){
//            //  NSLog(@"iPhone 6");
//            animationImages = @[[UIImage imageNamed:@"750x1334-01.jpg"], [UIImage imageNamed:@"750x1334-03.jpg"], [UIImage imageNamed:@"750x1334-04.jpg"]];
//        } else if ( screenHeight > 480 ){
//            // NSLog(@"iPhone 6 Plus");
//            animationImages = @[[UIImage imageNamed:@"1242x2208-01.jpg"], [UIImage imageNamed:@"1242x2208-03.jpg"], [UIImage imageNamed:@"1242x2208-04.jpg"]];
//        }    else {
//            //NSLog(@"iPhone 4/4s");
//            animationImages = @[[UIImage imageNamed:@"640x960-01.jpg"], [UIImage imageNamed:@"640x960-03.jpg"], [UIImage imageNamed:@"640x960-04.jpg"]];
//            // ShowBackgroundImage.image = [UIImage imageNamed:@"LandingBackground2.jpg"];
//        }
//        
//    }
    
    
    count = 0;
}

//- (CRMotionView *)motionViewWithImage
//{
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DemoTest.png"]];
//    [motionView setContentView:imageView];
//    [self.view addSubview:motionView];
//    [motionView setScrollDragEnabled:YES];
//    [motionView setScrollBounceEnabled:NO];
//    return motionView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)DeleteAllSaveData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Feed_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Feed_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Search_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Search_Category"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lat"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lng"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Link"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Contact"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Hour"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_City"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Country"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_State"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PostalCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_ReferralId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_type"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_Show"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_NumCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_BlogLink"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs_Data"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Source"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Period"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_OpenNow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Draft_PhotoCaption"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Title"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Message"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionDataArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringDataArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckPhotoCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PlaceId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoPosition"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
    
    //delete Images
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
        }
    } else {
        // Error handling
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    BackgroundView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    ShowBackgroundImage.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckLogin = [defaults objectForKey:@"CheckLogin"];
    NSString *CheckProvisioningStatus = [defaults objectForKey:@"CheckProvisioningStatus"];
    NSLog(@"CheckProvisioningStatus is %@",CheckProvisioningStatus);
    NSString *APIVersionSet = [defaults objectForKey:@"APIVersionSet"];
    NSLog(@"APIVersionSet is %@",APIVersionSet);
    NSTimer *RandomTimer;
    if ([CheckLogin isEqualToString:@"LoginDone"]) {
        ShowBackgroundImage.image = [UIImage imageNamed:@"HomeBg.png"];
        MainLogo.hidden = YES;
        MainText.hidden = YES;
        ShowTnCText.hidden = YES;
//        if ([APIVersionSet isEqualToString:@"1.3"]) {
//            
//        }else{
            [self GetAlllanguages];
        //}
        
        RandomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ChangeView2) userInfo:nil repeats:NO];
    }else{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DemoTest.png"]];
        [motionView setContentView:imageView];
        [BackgroundView addSubview:motionView];
        [motionView setScrollDragEnabled:YES];
        [motionView setScrollBounceEnabled:NO];
        
        if ([CheckProvisioningStatus isEqualToString:@"1"]) {
            PTnCViewController *PTnCView = [[PTnCViewController alloc]init];
            [self presentViewController:PTnCView animated:YES completion:nil];
        }else if([CheckProvisioningStatus isEqualToString:@"2"]){
            PTellUsYourCityViewController *PTellUsYourCityView = [[PTellUsYourCityViewController alloc]init];
            [self presentViewController:PTellUsYourCityView animated:YES completion:nil];
        }else if([CheckProvisioningStatus isEqualToString:@"3"]){
            PSelectYourInterestViewController *PSelectYourInterestView = [[PSelectYourInterestViewController alloc]init];
            [self presentViewController:PSelectYourInterestView animated:YES completion:nil];
        }else if([CheckProvisioningStatus isEqualToString:@"4"]){
            PFollowTheExpertsViewController *PFollowTheExpertsView = [[PFollowTheExpertsViewController alloc]init];
            [self presentViewController:PFollowTheExpertsView animated:YES completion:nil];
        }else if([CheckProvisioningStatus isEqualToString:@"5"]){
            RandomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
        }else{
         //   if ([APIVersionSet isEqualToString:@"1.3"]) {
                
          //  }else{
                [self GetAlllanguages];
         //   }
            RandomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
        }
        
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Landing Page";
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ShowActivity stopAnimating];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)changeview{
    //[self animateImages];
    

    
    
    FBLoginButton.hidden = NO;
    LogInButton.hidden = NO;
    WhyWeUseFBButton.hidden = NO;
    SignUpWithEmailButton.hidden = NO;
    InstagramButton.hidden = NO;
    //
    //    ShowBackgroundImage.animationImages = animationImages;
    //    ShowBackgroundImage.animationDuration = 8.0f;
    //    ShowBackgroundImage.animationRepeatCount = 0;
    //    [ShowBackgroundImage startAnimating];
    
}
-(void)ChangeView2{
    NSLog(@"ChangeView2 in here???");
    
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    UITabBarController *tabBarController=[[UITabBarController alloc]init];
//    tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
//    //  [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
//    //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
//    // UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
//    //   [[UITabBar appearance] setShadowImage:tabBarBackground];
//    //   [[UITabBar appearance] setBackgroundImage:tabBarBackground];
//    
//    
//   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
//    
//    FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
//    //firstViewController.title= CustomLocalisedString(@"MainTab_Feed",nil);TabBarNew.png
//    //firstViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarFeed_on.png"];//TabBarFeed.png
//
//    
//    Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
//    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:secondViewController];
//    //secondViewController.title= CustomLocalisedString(@"MainTab_Explore",nil);
//    //secondViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarExplore.png"];
//    
//    SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
//    //        PublishMainViewController *threeViewController=[[PublishMainViewController alloc]initWithNibName:@"PublishMainViewController" bundle:nil];
//    //        //threeViewController.title=@"";
//    //        //threeViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarPublish.png"];
//    
//    NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
//    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:fourViewController];
//    //fourViewController.title= CustomLocalisedString(@"MainTab_Like",nil);
//    //  fourViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarActivity.png"];
//    
//    ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
//    UINavigationController *navController4 = [[UINavigationController alloc] initWithRootViewController:fiveViewController];
//    //fiveViewController.title= CustomLocalisedString(@"MainTab_Profile",nil);
//    //  fiveViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarProfile.png"];
//    
//    //adding view controllers to your tabBarController bundling them in an array
//    tabBarController.viewControllers=[NSArray arrayWithObjects:navController,navController2,threeViewController,navController3,navController4, nil];
//    
//    
//    //[self presentModalViewController:tabBarController animated:YES];
//    // [self presentViewController:tabBarController animated:NO completion:nil];
//    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
    
    
   // FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
    TestFeedV2ViewController *firstViewController=[[TestFeedV2ViewController alloc]initWithNibName:@"TestFeedV2ViewController" bundle:nil];
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
    [imgDic3 setObject:[UIImage imageNamed:@"TabBarNew.png"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"TabBarNew.png"] forKey:@"Seleted"];
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
- (void)animateImages
{
    
    // UIImage *image = [animationImages objectAtIndex:(count % [animationImages count])];
    
    [UIView transitionWithView:BackgroundView
                      duration:2.0f // animation duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        ShowBackgroundImage.image = [animationImages objectAtIndex:(count % [animationImages count])];
                    } completion:^(BOOL finished) {
                        
                        if (finished) {
                            count++;
                            [self animateImages];
                        }
                        
                    }];
    
}
-(IBAction)ExpertLoginButton:(id)sender{
    
    ExpertLoginViewController *ExpertLoginView = [[ExpertLoginViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertLoginView animated:NO completion:nil];
    
}
-(IBAction)WhyWeUseFBButton:(id)sender{
    WhyWeUseFBViewController *WhyWeUseFBView = [[WhyWeUseFBViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:WhyWeUseFBView animated:NO completion:nil];
}
-(IBAction)SignUpWithEmailButton:(id)sender{
    SignupViewController *SignupView = [[SignupViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:SignupView animated:NO completion:nil];
    
}
-(IBAction)FbButton:(id)sender{
    
    
    //    // If the session state is any of the two "open" states when the button is clicked
    //    if (FBSession.activeSession.state == FBSessionStateOpen
    //        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    //
    //        // Close the session and remove the access token from the cache
    //        // The session state handler (in the app delegate) will be called automatically
    //        [FBSession.activeSession closeAndClearTokenInformation];
    //
    //        // If the session state is not any of the two "open" states when the button is clicked
    //    } else {
    //        // Open a session showing the user the login UI
    //        // You must ALWAYS ask for basic_info permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         switch (state) {
             case FBSessionStateOpen:{
                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (error) {
                         
                         NSLog(@"error:%@",error);
                         
                         
                     }
                     else
                     {
                         // retrive user's details at here as shown below
                         NSLog(@"all information is %@",user);
                         GetFB_ID = (NSString *)[user valueForKey:@"id"];
                         
                         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                             if (error) {
                                 // Handle error
                             }else {
                                 Name = [FBuser name];
                                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", GetFB_ID];
                                 UserEmail = [user valueForKey:@"email"];
                                 UserGender = [user valueForKey:@"gender"];
                                 Userdob = [user valueForKey:@"birthday"];
                                 UserName = [user valueForKey:@"last_name"];
                                 UserName = [[NSString alloc]initWithFormat:@"%@%@",[user valueForKey:@"first_name"],[user valueForKey:@"last_name"]];
                                 
                                 NSLog(@"name is %@",Name);
                                 NSLog(@"username is %@",UserName);
                                 NSLog(@"Userid is %@",GetFB_ID);
                                 NSLog(@"useremail is %@",UserEmail);
                                 NSLog(@"usergender is %@",UserGender);
                                 NSLog(@"userImageURL is %@",userImageURL);
                                 NSLog(@"userdob is %@",Userdob);
                                 NSLog(@"session is %@",session);
                                 
                                 GetFB_Token = [FBSession activeSession].accessTokenData.accessToken;
                                 NSLog(@"GetToken is %@",GetFB_Token);
                                 
                                 //                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                 //                                 [defaults setObject:session forKey:@"fbsession"];
                                 //                                 [defaults synchronize];
                                 
                                 [self UploadInformationToServer];
                                 
                             }
                         }];
                         
                     }
                 }];
                 break;
             }
             case FBSessionStateClosed:
             case FBSessionStateClosedLoginFailed:
                 [FBSession.activeSession closeAndClearTokenInformation];
                 break;
                 
             default:
                 break;
         }
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
         
     }];
    //    }
    
    
    
    //    PTnCViewController *PTnCView = [[PTnCViewController alloc]init];
    //    CATransition *transition = [CATransition animation];
    //    transition.duration = 0.4;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    transition.type = kCATransitionPush;
    //    transition.subtype = kCATransitionFromRight;
    //    [self.view.window.layer addAnimation:transition forKey:nil];
    //    [self presentViewController:PTnCView animated:NO completion:nil];
}
-(void)UploadInformationToServer{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] ||[ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.FacebookRegister_Url];
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
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_Token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"role\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"user"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ip_address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ExternalIPAddress] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
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
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Facebook) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Facebook Register return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Facebook Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSLog(@"Got Data.");
            NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithArray:[res valueForKey:@"categories"]];
            NSLog(@"categoriesArray is %@",categoriesArray);
            NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"country"]];
            NSLog(@"GetCountry is %@",GetCountry);
            NSString *Getcrawler = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"crawler"]];
            NSLog(@"Getcrawler is %@",Getcrawler);
            NSString *Getcreated_at = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"created_at"]];
            NSLog(@"Getcreated_at is %@",Getcreated_at);
            NSString *Getdescription = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"Getdescription is %@",Getdescription);
            NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"profile_photo"]];
            NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            NSString *Gettoken = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"token"]];
            NSLog(@"Gettoken is %@",Gettoken);
            NSString *Getuid = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"uid"]];
            NSLog(@"Getuid is %@",Getuid);
            NSString *Getprovisioning = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"provisioning"]];
            NSLog(@"Getprovisioning is %@",Getprovisioning);
            NSString *Getrole = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"role"]];
            NSLog(@"Getrole is %@",Getrole);
            NSDictionary *SystemLanguage = [res valueForKey:@"system_language"];
            NSLog(@"SystemLanguage is %@",SystemLanguage);
            NSString *GetCaption;
            if ([SystemLanguage isKindOfClass:[NSNull class]]) {
                GetCaption = @"English";
            }else{
                GetCaption = [[NSString alloc]initWithFormat:@"%@",[SystemLanguage objectForKey:@"caption"]];
                NSLog(@"GetCaption is %@",GetCaption);
            }
            //            NSString *GetCaption = [[NSString alloc]initWithFormat:@"%@",[SystemLanguage objectForKey:@"caption"]];
            //            NSLog(@"GetCaption is %@",GetCaption);
            NSString *GetPasswordCheck = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"has_password"]];
            NSLog(@"GetPasswordCheck is %@",GetPasswordCheck);
            NSString *GetFbExtendedToken = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"fb_extended_token"]];
            NSLog(@"GetFbExtendedToken is %@",GetFbExtendedToken);
            
            NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]init];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            NSDictionary *NSDictionaryLanguage = [res valueForKey:@"languages"];
            NSLog(@"NSDictionaryLanguage is %@",NSDictionaryLanguage);
            NSString *GetLanguage_1;
            NSString *GetLanguage_2;
            if ([NSDictionaryLanguage isKindOfClass:[NSNull class]]) {
                GetLanguage_1 = @"English";
                GetLanguage_2 = @"English";
            }else{
                for (NSDictionary * dict in NSDictionaryLanguage){
                    NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
                    [GetUserSelectLanguagesArray addObject:Getid];
                    NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                    NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                    [TempArray addObject:GetLanguage_1];
                }
                NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
                
                
                if ([TempArray count] == 1) {
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                }else{
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                }
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
            
            NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:Gettoken forKey:@"ExpertToken"];
            [defaults setObject:Getusername forKey:@"UserName"];
            [defaults setObject:Getprofile_photo forKey:@"UserProfilePhoto"];
            [defaults setObject:Getuid forKey:@"Useruid"];
            [defaults setObject:CheckLogin forKey:@"CheckLogin"];
            [defaults setObject:Getrole forKey:@"Role"];
            [defaults setObject:GetPasswordCheck forKey:@"CheckPassword"];
            [defaults setObject:GetCaption forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
            [defaults setObject:GetFbExtendedToken forKey:@"fbextendedtoken"];
            if (NSDictionaryLanguage == NULL) {
                
            }else{
                [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
                [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            }
            
            [defaults synchronize];
            
            //     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
            
            if ([Getprovisioning isEqualToString:@"1"]) {
                [self ChangeView2];
                
                
            }else{
                PTellUsYourCityViewController *TellUsYourCityView = [[PTellUsYourCityViewController alloc]init];
                [self presentViewController:TellUsYourCityView animated:YES completion:nil];
            }
            
            
            
            
        }
        
        [ShowActivity stopAnimating];
        
        
        
    }else if(connection == theConnection_GetLanguages){
        //get all languages
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //  NSLog(@"All Languages return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"Facebook Json = %@",res);
        
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"languages"];
        //  NSLog(@"GetAllData Json = %@",GetAllData);
        
        NSMutableArray *LanguageID_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *LanguageName_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *LanguageCode_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        NSMutableArray *SystemLanguageID_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *SystemLanguageName_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *id_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [SystemLanguageID_Array addObject:id_];
            if ([id_ isEqualToString:@"530d5e9b642440d128000018"]) {
                
            }else{
                [LanguageID_Array addObject:id_];
            }
            
            NSString *origin_caption = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
            //    NSLog(@"origin_caption is %@",origin_caption);
            [SystemLanguageName_Array addObject:origin_caption];
            if ([origin_caption isEqualToString:@"繁體中文"]) {
                
            }else{
                if ([origin_caption isEqualToString:@"简体中文"]) {
                    origin_caption = @"中文";
                }
                [LanguageName_Array addObject:origin_caption];
            }
            
            NSString *language_code = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"language_code"]];
            if ([language_code isEqualToString:@"zh_TW"]) {
                
            }else{
                [LanguageCode_Array addObject:language_code];
            }
            
        }
        //  NSLog(@"SystemLanguageID_Array is %@",SystemLanguageID_Array);
        // NSLog(@"SystemLanguageName_Array is %@",SystemLanguageName_Array);
        //  NSLog(@"LanguageCode_Array is %@",LanguageCode_Array);
        
        
        NSString *CheckStatus = @"5";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:LanguageID_Array forKey:@"LanguageData_ID"];
        [defaults setObject:LanguageName_Array forKey:@"LanguageData_Name"];
        [defaults setObject:LanguageCode_Array forKey:@"LanguageData_Code"];
        [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
        [defaults setObject:SystemLanguageID_Array forKey:@"SystemLanguageData_ID"];
        [defaults setObject:SystemLanguageName_Array forKey:@"SystemLanguageData_Name"];
        [defaults synchronize];
        
        
        [self GetALlCategory];
    }else if(connection == theConnection_GetAllCategory){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //  NSLog(@"Get All Category return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"categories"];
        //   NSLog(@"GetAllData Json = %@",GetAllData);
        
        NSMutableArray *Category_IDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_ImageArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_BackgroundImageArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        NSMutableArray *Category_NameArray_CN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TW = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TH = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_IN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_FN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *id_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [Category_IDArray addObject:id_];
            NSString *imagedata = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"image"]];
            NSString *stringWithoutSpaces = [imagedata stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            [Category_ImageArray addObject:stringWithoutSpaces];
            NSString *background_color = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"background_color"]];
            [Category_BackgroundImageArray addObject:background_color];
            NSDictionary *NameData = [dict valueForKey:@"single_line"];
            NSString *EnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0ab26424400c76000003"]];
            [Category_NameArray addObject:EnData];
            NSString *CnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0aa16424400c76000002"]];
            [Category_NameArray_CN addObject:CnData];
            NSString *TwData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530d5e9b642440d128000018"]];
            [Category_NameArray_TW addObject:TwData];
            NSString *InData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"53672e863efa3f857f8b4ed2"]];
            [Category_NameArray_IN addObject:InData];
            NSString *FnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"539fbb273efa3fde3f8b4567"]];
            [Category_NameArray_FN addObject:FnData];
            NSString *ThData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"544481503efa3ff1588b4567"]];
            [Category_NameArray_TH addObject:ThData];
        }
        
        //        NSLog(@"Category_IDArray is %@",Category_IDArray);
        //        NSLog(@"Category_NameArray is %@",Category_NameArray);
        //        NSLog(@"Category_ImageArray is %@",Category_ImageArray);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Category_IDArray forKey:@"Category_All_ID"];
        [defaults setObject:Category_NameArray forKey:@"Category_All_Name"];
        [defaults setObject:Category_ImageArray forKey:@"Category_All_Image"];
        [defaults setObject:Category_BackgroundImageArray forKey:@"Category_All_Background"];
        
        [defaults setObject:Category_NameArray_CN forKey:@"Category_All_Name_Cn"];
        [defaults setObject:Category_NameArray_TW forKey:@"Category_All_Name_Tw"];
        [defaults setObject:Category_NameArray_IN forKey:@"Category_All_Name_In"];
        [defaults setObject:Category_NameArray_FN forKey:@"Category_All_Name_Fn"];
        [defaults setObject:Category_NameArray_TH forKey:@"Category_All_Name_Th"];
        [defaults synchronize];
        
        [ShowActivity stopAnimating];
    }
    
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(void)GetAlllanguages{
    [ShowActivity startAnimating];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetAlllangauge_Url];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetLanguages = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetLanguages start];
    
    
    if( theConnection_GetLanguages ){
        webData = [NSMutableData data];
    }
}
-(void)GetALlCategory{
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetAllCategory_Url];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllCategory = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllCategory start];
    
    
    if( theConnection_GetAllCategory ){
        webData = [NSMutableData data];
    }
}
-(IBAction)InstagramButton:(id)sender{
    NSLog(@"Instagram Click");
    InstagramLoginWebViewController *WebViewLogin = [[InstagramLoginWebViewController alloc]init];
    [self presentViewController:WebViewLogin animated:YES completion:nil];
}
@end

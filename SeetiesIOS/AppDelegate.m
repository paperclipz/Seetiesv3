//
//  AppDelegate.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/14/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "AppDelegate.h"
#import "LandingV2ViewController.h"
#import "GAI.h"
#import "Foursquare2.h"
#import "PTnCViewController.h"
#import "PTellUsYourCityViewController.h"
#import "PFollowTheExpertsViewController.h"
#import "PSelectYourInterestViewController.h"
#import "SearchViewController.h"
#import "AccountSettingViewController.h"
#import "CommentViewController.h"
#import "PublishViewController.h"
#import "PublishMainViewController.h"
#import "AddLocationViewController.h"
#import "Constants.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "SearchViewV2.h"
#import "WhereIsThisViewController.h"
#import "AddPriceViewController.h"
#import "PSearchLocationViewController.h"
#import "SettingsViewController.h"
#import "Filter2ViewController.h"
#import "NotificationViewController.h"

#import <Parse/Parse.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "SelectImageViewController.h"
#import "FeedV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "ProfileV2ViewController.h"
#import "TellaStoryViewController.h"

#import "PInterestV2ViewController.h"

#import "DoImagePickerController.h"
#import "TestFeedV2ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Fabric with:@[CrashlyticsKit]];
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"MMpGchSOutbiRC4KpHW47VLBFFQgv2jj5DIM4Qdi" clientKey:@"4kkfBL3btDWxoQN89WRBXVWYEUDZKD38XuzCakK7"];
   // [Parse setApplicationId:@"UDy6JpDrh7N6mWznTYusRruA8a1VrCLK2s5gCXZo" clientKey:@"cDs5Sml0kIzwplNSMOnXgV5LnJiAP0UK1Z2K5pZm"];
    // ****************************************************************************
    
//    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                    UIUserNotificationTypeBadge |
//                                                    UIUserNotificationTypeSound);
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                             categories:nil];
//    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    APIVersionSet = @"1.3";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:APIVersionSet forKey:@"APIVersionSet"];
    [defaults synchronize];
    [self CheckApiVersion];
    

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
    NSLog(@"Language: %@", [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0]);
    NSLog(@"Region: %@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]);

    /*
     * Check the user defaults to find whether a localisation has been set before.
     * If it hasn't been set, (i.e. first run of the app), select the locale based
     * on the device locale setting.
     */
    
    // Check whether the language code has already been set.
    if (![userDefaults stringForKey:DEFAULTS_KEY_LANGUAGE_CODE]) {
        
        NSLog(@"No language set - trying to find the right setting for the device locale.");
        
        NSLocale *currentLocale = [NSLocale currentLocale];
        
        // Iterate through available localisations to find the matching one for the device locale.
        for (Locale *localisation in languageManager.availableLocales) {
            
            if ([localisation.languageCode caseInsensitiveCompare:[currentLocale objectForKey:NSLocaleLanguageCode]] == NSOrderedSame) {
                
                [languageManager setLanguageWithLocale:localisation];
                break;
            }
        }
        
        // If the device locale doesn't match any of the available ones, just pick the first one.
        if (![userDefaults stringForKey:DEFAULTS_KEY_LANGUAGE_CODE]) {
          //  NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *language = [[NSString alloc]initWithFormat:@"%@",[[NSLocale preferredLanguages] objectAtIndex:0]];
            NSLog(@"Get System language is %@",language);
            // zh-Hans - Simplified Chinese
            // zh-Hant - Traditional Chinese
            // en - English
            // th - Thai
            // id - Bahasa Indonesia
            NSInteger CheckSystemLanguage;
            if ([language isEqualToString:@"en"]) {
                CheckSystemLanguage = 0;
                NSLog(@"language in here 0");
            }else if([language isEqualToString:@"zh-Hans"]){
                CheckSystemLanguage = 1;
                NSLog(@"language in here 1");
            }else if([language isEqualToString:@"zh-Hant"]){
                CheckSystemLanguage = 2;
                NSLog(@"language in here 2");
            }else if([language isEqualToString:@"id"]){
                CheckSystemLanguage = 3;
                NSLog(@"language in here 3");
            }else if([language isEqualToString:@"th"]){
                CheckSystemLanguage = 4;
                NSLog(@"language in here 4");
            }else if([language isEqualToString:@"tl-PH"]){
                CheckSystemLanguage = 5;
                NSLog(@"language in here 5");
            }else{
                CheckSystemLanguage = 0;
                NSLog(@"language in here 0");
            }
            
            
            NSLog(@"Couldn't find the right localisation - using default.");
            [languageManager setLanguageWithLocale:languageManager.availableLocales[CheckSystemLanguage]];
        }
    }
    else {
        NSLog(@"DEFAULTS_KEY_LANGUAGE_CODE = %@",DEFAULTS_KEY_LANGUAGE_CODE);
        NSLog(@"The language has already been set :)");
    }
    
    
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 30;
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-45737845-4"];
    
    [Foursquare2 setupFoursquareWithClientId:@"V0RPRPAUHB1ZCFSKOXKNM0JA3Q1RN1QUBK14RZFOUYY15I4R"
                                      secret:@"T5XT0AVNHLLO1NMXRNFCDBYGA453E12CTVN0WOSIHREEZTWA"
                                 callbackURL:@"testapp123://foursquare"];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckLogin = [defaults objectForKey:@"CheckLogin"];
    if ([CheckLogin isEqualToString:@"LoginDone"]) {

    }else{
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"language is %@",language);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:language forKey:@"SystemLanguage"];
        [defaults synchronize];
    }
    
   // zh-Hans - Simplified Chinese
   // zh-Hant - Traditional Chinese
   // en - English
   // th - Thai
   // id - Bahasa Indonesia
    
//    LandingViewController *LandingView = [[LandingViewController alloc]init];
//    self.window.rootViewController = LandingView;
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//
////    SearchViewV2 *LandingView = [[SearchViewV2 alloc]init];
////    self.window.rootViewController = LandingView;
//
//    
////    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
////     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
////    
////    UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
////    NSLog(@"enabledTypes is %u",enabledTypes);
////    
////    
    application.applicationIconBadgeNumber = 0;
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        //        UIButton *loginButton = [self.customLoginViewController FBloginButton];
        //        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
   // [self CheckApiVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    //    UIButton *loginButton = [self.customLoginViewController FBloginButton];
    //    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    //  [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    //    UIButton *loginButton = self.customLoginViewController.FBloginButton;
    //    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
    return [Foursquare2 handleURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setDeviceTokenFromData:deviceToken];
//    currentInstallation.channels = @[@"global"];
//    [currentInstallation saveInBackground];
    NSLog(@"deviceToken = %@",deviceToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"DeviceTokenPush"];
    [defaults synchronize];
    
    
//    NSData *GetDeviceToken = [defaults objectForKey:@"DeviceTokenPush"];
//    NSString *GetUserUID = [defaults objectForKey:@"Useruid"];
//    NSLog(@"GetDeviceToken is %@",GetDeviceToken);
//    NSLog(@"GetUserUID is %@",GetUserUID);
//    if ([GetDeviceToken length] == 0 || GetDeviceToken == (id)[NSNull null] || GetDeviceToken.length == 0) {
//        
//    }else{
//        NSString *Check = [defaults objectForKey:@"CheckGetPushToken"];
//        if ([Check isEqualToString:@"Done"]) {
//            
//        }else{
//            if ([GetUserUID length] == 0 || GetUserUID == (id)[NSNull null] || GetUserUID.length == 0) {
//                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//                [currentInstallation setDeviceTokenFromData:GetDeviceToken];
//                currentInstallation.channels = @[@"IOS_FirstLogin"];
//                [currentInstallation saveInBackground];
//            }else{
//                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//                [currentInstallation setDeviceTokenFromData:GetDeviceToken];
//                NSString *tempTokenString = [[NSString alloc]initWithFormat:@"seeties_%@",GetUserUID];
//                currentInstallation.channels = @[tempTokenString,@"all"];
//                [currentInstallation saveInBackground];
//            //    NSLog(@"work here?");
//                NSString *TempString = @"Done";
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:TempString forKey:@"CheckGetPushToken"];
//                [defaults synchronize];
//            }
//
//        }
//        
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    
    
    FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
    
    SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
    
    NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
    
    ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
    
    //adding view controllers to your tabBarController bundling them in an array
    tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
     tabBarController.selectedIndex = 3;
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
    
}

-(void)CheckApiVersion{
    //https://itcave-api.seeties.me/v1.3/system/apiversion?device_type=2 - itcave test
    //https://ios-api.seeties.me/v1.3/system/apiversion?device_type=2 - live
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://itcave-api.seeties.me/v1.3/system/apiversion?device_type=2"];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLConnection *theConnection_CheckNotification = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CheckNotification start];
    
    
    if( theConnection_CheckNotification ){
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
    NSLog(@"AppDelegate Check API Version Error.");
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Connection" message:@"Check your wifi or 3G data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    alert.tag = 100;
//    [alert show];
    
    LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
    self.window.rootViewController = LandingView;


    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"AppDelegate Check API Version return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Return Json = %@",res);
    
    NSString *GetVersionString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"version"]];
    NSLog(@"GetVersionString is %@",GetVersionString);
    
    NSString *GetTitleString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"title"]];
    NSLog(@"GetTitleString is %@",GetTitleString);
    
    NSString *GetMessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"GetMessageString is %@",GetMessageString);
    
    NSString *GetProductionString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"production"]];
    NSLog(@"GetProductionString is %@",GetProductionString);
    
    NSString *CheckAPI = [[NSString alloc]init];
    
    if ([GetProductionString isEqualToString:@"0"]) {
        //dev use
        CheckAPI = @"0";
    }else{
    //live
        CheckAPI = @"1";
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckAPI forKey:@"CheckAPI"];
    [defaults synchronize];
    
    if ([GetVersionString isEqualToString:APIVersionSet]) {
        LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
        self.window.rootViewController = LandingView;
        
//        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
//        cont.delegate = self;
//        cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
//        cont.nMaxCount = 10;
//        cont.nColumnCount = 3;
//        self.window.rootViewController = cont;

        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        

    }else{
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:GetTitleString message:GetMessageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        ShowAlertView.tag = 200;
        [ShowAlertView show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            exit(0);
        }else{
            //reset clicked
        }
    }else{
        if (buttonIndex == [alertView cancelButtonIndex]){//https://itunes.apple.com/app/seeties-mobile-citypass-for/id956400552?mt=8
            NSString *iTunesLink = @"https://itunes.apple.com/app/seeties-mobile-citypass-for/id956400552?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }else{
            //reset clicked
        }
    }
    
}
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
}
void myExceptionHandler(NSException *exception)
{
    NSArray *stack = [exception callStackReturnAddresses];
    NSLog(@"Stack trace: %@", stack);
}
@end

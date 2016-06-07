
//
//  AppDelegate.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/14/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "AppDelegate.h"
#import "LanguageManager.h"
#import "Locale.h"
#import <Parse/Parse.h>
#import <sys/utsname.h>
#import "NewLandingViewController.h"
#import "AFHTTPSessionManager.h"
#import "FBLoginManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ACTReporter.h"

#define FABRIC_API_KEY @"506d5ee5657719d0cbaa94569d3352125456f169"

@interface AppDelegate ()

@end


@implementation AppDelegate

-(void)registrationForApi
{
    
   // [FIRApp configure];

    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"UDy6JpDrh7N6mWznTYusRruA8a1VrCLK2s5gCXZo" clientKey:@"cDs5Sml0kIzwplNSMOnXgV5LnJiAP0UK1Z2K5pZm"];
    // ****************************************************************************


    [Parse setApplicationId:@"MMpGchSOutbiRC4KpHW47VLBFFQgv2jj5DIM4Qdi" clientKey:@"4kkfBL3btDWxoQN89WRBXVWYEUDZKD38XuzCakK7"];
    [Foursquare2 setupFoursquareWithClientId:@"V0RPRPAUHB1ZCFSKOXKNM0JA3Q1RN1QUBK14RZFOUYY15I4R"
                                      secret:@"T5XT0AVNHLLO1NMXRNFCDBYGA453E12CTVN0WOSIHREEZTWA"
                                 callbackURL:@"testapp123://foursquare"];
  

    // ===== Google Conversion Tracking Code ===== //
    [ACTConversionReporter reportWithConversionID:@"881569983" label:@"D1qLCIvA4mYQv-GupAM" value:@"0.00" isRepeatable:NO];
//    if (!IS_SIMULATOR) {
//        //Optional: automatically send uncaught exceptions to Google Analytics.
//        [GAI sharedInstance].trackUncaughtExceptions = YES;
//        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
//        [GAI sharedInstance].dispatchInterval = 30;
//        // Optional: set Logger to VERBOSE for debug information.
//        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
//        // Initialize tracker. Replace with your tracking ID.
//        [[GAI sharedInstance] trackerWithTrackingId:@"UA-45737845-4"];
//        
//    }
}

-(void)configureSetup
{
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
   // [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[CT3_SearchListingViewController class]];


//        #ifdef DEBUG
//            [[AFNetworkActivityLogger sharedLogger] startLogging];
//            [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//        #endif
}

-(void)configureNotificaiton:(UIApplication*)application
{
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

-(void)checkCurrentAppLanguage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
    
    NSString* key_system_lang = [userDefaults stringForKey:KEY_SYSTEM_LANG];

    // Check whether the language code has already been set.
    if (!key_system_lang) {
        
        NSLog(@"No language set - trying to find the right setting for the device locale.");
        
        NSLocale *currentLocale = [NSLocale currentLocale];
        
        NSString* localDeviceLanguageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
        
        NSString* localServerLanguageCode = [LanguageManager convertLocalCodeToServer:localDeviceLanguageCode];

        NSString* langServerCode = ENGLISH_SERVER_NAME;
        
        // Iterate through available localisations to find the matching one for the device locale.
        for (Locale *localisation in languageManager.availableLocales) {
            
            if ([localisation.languageCode caseInsensitiveCompare:localServerLanguageCode] == NSOrderedSame) {
                
                langServerCode = localisation.languageCode;

                break;
            }
        }
        
        [LanguageManager setDeviceAppLanguage:langServerCode];
    }
    
    SLog(@"\n ========== Current Language : %@ ==========",[LanguageManager getAppServerCode]);

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];

    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    
 
    
    //[self requestForApiVersion];
    [self registrationForApi];
    [self configureNotificaiton:application];
    [self configureSetup];
    [self checkCurrentAppLanguage];
    [self showWindow];
   
    [Crashlytics startWithAPIKey:FABRIC_API_KEY];

    [Fabric with:@[CrashlyticsKit]];
    
    if (![Utils isLogin]) {
      
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"language is %@",language);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:language forKey:@"SystemLanguage"];
        [defaults synchronize];

    }
    application.applicationIconBadgeNumber = 0;
    
    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        NSLog(@"Found a cached session");
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//        
//        // If there's no cached session, we will show a login button
//    } else {
//        //        UIButton *loginButton = [self.customLoginViewController FBloginButton];
//        //        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  //  NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   // NSLog(@"applicationWillEnterForeground");
    // [self CheckApiVersion];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}
// This method will handle ALL the session state changes in the app
//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
//{
//    // If the session was opened successfully
//    if (!error && state == FBSessionStateOpen){
//        NSLog(@"Session opened");
//        // Show the user the logged-in UI
//        [self userLoggedIn];
//        return;
//    }
//    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
//        // If the session is closed
//        NSLog(@"Session closed");
//        // Show the user the logged-out UI
//        [self userLoggedOut];
//        [FBSession.activeSession closeAndClearTokenInformation];
//    }
//    
//    // Handle errors
//    if (error){
//        NSLog(@"Error");
//        NSString *alertText;
//        NSString *alertTitle;
//        // If the error requires people using an app to make an action outside of the app in order to recover
//        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
//            alertTitle = @"Something went wrong";
//            alertText = [FBErrorUtility userMessageForError:error];
//            [self showMessage:alertText withTitle:alertTitle];
//        } else {
//            
//            // If the user cancelled login, do nothing
//            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                NSLog(@"User cancelled login");
//                
//                // Handle session closures that happen outside of the app
//            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
//                alertTitle = @"Session Error";
//                alertText = @"Your current session is no longer valid. Please log in again.";
//                [self showMessage:alertText withTitle:alertTitle];
//                
//                // For simplicity, here we just show a generic message for all other errors
//                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
//            } else {
//                //Get more error information from the error
//                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
//                
//                // Show the user an error message
//                alertTitle = @"Something went wrong";
//                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                [self showMessage:alertText withTitle:alertTitle];
//            }
//        }
//        // Clear this token
//        [FBSession.activeSession closeAndClearTokenInformation];
//        // Show the user the logged-out UI
//        [self userLoggedOut];
//    }
//}

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
//    return [FBSession.activeSession handleOpenURL:url];
//    return [Foursquare2 handleURL:url];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
//    [FBAppCall handleDidBecomeActive];
    
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
//    [FBAppEvents activateApp];
    [FBSDKAppEvents activateApp];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    
    [Utils setParseToken:deviceToken];
    
  
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
    
    NSString* action = userInfo[@"click_action"];
    
    if (action) {
        
        [self.landingViewController showPushNotificationView:action];
    }
    
    SLog(@"didReceiveRemoteNotification : %@",userInfo);
    
//    self.window.rootViewController = self.landingV2ViewController;//self.landingV2ViewController
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
}

-(void)showWindow
{
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:self.landingViewController];
    navigationController.navigationBar.hidden = YES;
    self.window.rootViewController = navigationController;//self.landingV2ViewController
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];

}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
}
void myExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    NSString *GetDevice = deviceName();
    NSLog(@"Device Info: %@",GetDevice);
    
}

NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


#pragma mark - Declaration

-(NewLandingViewController*)landingViewController
{
    if (!_landingViewController) {
        _landingViewController = [NewLandingViewController new];
    }
    
    return _landingViewController;
}
@end

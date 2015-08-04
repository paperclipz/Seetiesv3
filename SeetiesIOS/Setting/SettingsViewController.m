//
//  SettingsViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditProfileViewController.h"
#import "EditInterestViewController.h"
#import "EditInterestV2ViewController.h"
#import "AccountSettingViewController.h"
#import "LLARingSpinnerView.h"
#import "LandingV2ViewController.h"
#import "OpenWebViewController.h"
#import "FeedbackViewController.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface SettingsViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    ShowTitle.text = CustomLocalisedString(@"SettingsPage_Title",nil);
    Title_Account.text = CustomLocalisedString(@"SettingsPage_Account",nil);
    EditProfile.text = CustomLocalisedString(@"SettingsPage_EditProfile",nil);
    EditInterests.text = CustomLocalisedString(@"SettingsPage_EditInterests",nil);
    AccountSetting.text = CustomLocalisedString(@"SettingsPage_AccountSettings",nil);
    FindInviteFriends.text = CustomLocalisedString(@"SettingsPage_Find&InviteFriends",nil);
    
    Title_Support.text = CustomLocalisedString(@"SettingsPage_SUPPORT",nil);
    AboutSeeties.text = CustomLocalisedString(@"SettingsPage_AboutSeeties",nil);
    TermOfUse.text = CustomLocalisedString(@"SettingsPage_TermsofUse",nil);
    PrivacyPolicy.text = CustomLocalisedString(@"SettingsPage_PrivacyPolicy",nil);
    Feedback.text = CustomLocalisedString(@"SettingsPage_Feedback",nil);
    
    [CheckForUpdateButton setTitle:CustomLocalisedString(@"SettingsPage_Checkforupdates",nil) forState:UIControlStateNormal];
    [LogoutButton setTitle:CustomLocalisedString(@"SettingsPage_LogOut",nil) forState:UIControlStateNormal];
    
     [EditProfileButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [EditInterestsButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [AccountSettingsButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [AboutsButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [TermOfUseButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [PrivacyButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
     [FeedBackButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Settings Page";
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    
    CopyrightText.frame = CGRectMake(15, 475, screenWidth - 30, 21);
    VersionText.frame = CGRectMake(15, 490, screenWidth - 30, 21);
    
    Table1Img_1.frame = CGRectMake(0, 428, screenWidth, 44);
    Table1Img_2.frame = CGRectMake(0, 41, screenWidth, 133);
    Table1Img_3.frame = CGRectMake(-1, 83, screenWidth, 44);
    Table4Img.frame = CGRectMake(0, 228, screenWidth, 176);
    
    CaretImg_1.frame = CGRectMake(screenWidth - 30, 58, 8, 13);
    CaretImg_2.frame = CGRectMake(screenWidth - 30, 101, 8, 13);
    CaretImg_3.frame = CGRectMake(screenWidth - 30, 145, 8, 13);
    CaretImg_4.frame = CGRectMake(screenWidth - 30, 242, 8, 13);
    CaretImg_5.frame = CGRectMake(screenWidth - 30, 285, 8, 13);
    CaretImg_6.frame = CGRectMake(screenWidth - 30, 330, 8, 13);
    CaretImg_7.frame = CGRectMake(screenWidth - 30, 374, 8, 13);
    
    LogoutButton.frame = CGRectMake(0, 525, screenWidth, 44);
    CheckForUpdateButton.frame = CGRectMake(0, 428, screenWidth, 44);
}
-(IBAction)BackButton:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)EditProfileButton:(id)sender{
    EditProfileViewController *EditProfileView = [[EditProfileViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:EditProfileView animated:NO completion:nil];
}
-(IBAction)AccountSettingButton:(id)sender{
    AccountSettingViewController *AccountSettingView = [[AccountSettingViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:AccountSettingView animated:NO completion:nil];
}
-(IBAction)EditInterestButton:(id)sender{
    EditInterestV2ViewController *EditInterestView = [[EditInterestV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:EditInterestView animated:NO completion:nil];
}
-(IBAction)AboutSeetiesButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"AboutSeeties"];
}
-(IBAction)TermsofUseButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"TermsofUse"];
}
-(IBAction)PrivacyPolicyButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"PrivacyPolicy"];
}
-(IBAction)FeedBackButton:(id)sender{
    FeedbackViewController *FeedbackView = [[FeedbackViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedbackView animated:NO completion:nil];
}
-(IBAction)LogoutButton:(id)sender{

    [self SendUserLogoutToServer];
}
-(void)SendUserLogoutToServer{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    self.spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.spinnerView.lineWidth = 1.0f;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.UserLogout_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_logout = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_logout start];
    
    
    if( theConnection_logout ){
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
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_logout) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"User Logout return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //   NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        [self.spinnerView stopAnimating];
        [self.spinnerView removeFromSuperview];
        if ([statusString isEqualToString:@"ok"]) {
            
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

        }

    }
    
    

    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(IBAction)CheckNewUpdateButton:(id)sender{

    BOOL CheckUpdate = [self appHasNewVersion];
   // NSLog(CheckUpdate ? @"Yes" : @"No");
    if (CheckUpdate == YES) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:@"A new version of Seeties is available to download" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:@"You are in current version." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
}
- (BOOL)appHasNewVersion
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [bundleInfo valueForKey:@"CFBundleIdentifier"];
//    NSLog(@"bundleIdentifier is %@",bundleIdentifier);
    NSURL *lookupURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/my/lookup?bundleId=%@", bundleIdentifier]];
    NSData *lookupResults = [NSData dataWithContentsOfURL:lookupURL];
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:lookupResults options:0 error:nil];
//    NSLog(@"jsonResults is %@",jsonResults);
    NSUInteger resultCount = [[jsonResults objectForKey:@"resultCount"] integerValue];
//    NSLog(@"resultCount is %i",resultCount);
    if (resultCount){
        NSDictionary *appDetails = [[jsonResults objectForKey:@"results"] firstObject];
        NSString *latestVersion = [appDetails objectForKey:@"version"];
        NSString *currentVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
//        NSLog(@"appDetails is %@",appDetails);
//        NSLog(@"latestVersion is %@",latestVersion);
//        NSLog(@"currentVersion is %@",currentVersion);
        if (![latestVersion isEqualToString:currentVersion]) return YES;
    }
    return NO;
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
@end

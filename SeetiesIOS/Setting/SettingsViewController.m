//
//  SettingsViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SettingsViewController.h"
#import "EditProfileV2ViewController.h"

#import "EditInterestV2ViewController.h"
#import "AccountSettingViewController.h"
#import "LLARingSpinnerView.h"
#import "LandingV2ViewController.h"
#import "OpenWebViewController.h"
#import "FeedbackViewController.h"
#import "NotificationSettingsViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import <Parse/Parse.h>
@interface SettingsViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    ShowTitle.text = CustomLocalisedString(@"Settings",nil);
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
    
    
    
    
    //Initialize the dataArray
    dataArray = [[NSMutableArray alloc] init];
    
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"Edit Profile"), LocalisedString(@"Edit Interest"),LocalisedString(@"Account Settings"), nil];//@"Notification Settings"
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"About Seeties"), LocalisedString(@"Terms of Use"),LocalisedString(@"Privacy Policy"),LocalisedString(@"Send Feedback"), nil];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];
    
    //Second section data
    NSArray *threeItemsArray = [[NSArray alloc] initWithObjects:LocalisedString(@"Sign out of Seeties"), nil];
    NSDictionary *threeItemsArrayDict = [NSDictionary dictionaryWithObject:threeItemsArray forKey:@"data"];
    [dataArray addObject:threeItemsArrayDict];
    
    [tblview reloadData];
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
    tblview.frame = CGRectMake(0, 64,screenWidth , screenHeight);

}
-(IBAction)BackButton:(id)sender{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
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
            }else{
                CheckSystemLanguage = 0;
            }
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
            [languageManager setLanguageWithLocale:localeForRow];
            
           // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetUserUID = [defaults objectForKey:@"Useruid"];
            NSString *TempTokenString = [[NSString alloc]initWithFormat:@"seeties_%@",GetUserUID];
//
//            // When users indicate they are no longer Giants fans, we unsubscribe them.
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation removeObject:@"all" forKey:@"channels"];
            [currentInstallation removeObject:TempTokenString forKey:@"channels"];
            [currentInstallation saveInBackground];
            

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return LocalisedString(@"Profile");
    if(section == 1)
        return LocalisedString(@"Support");
    if(section == 2)
        return LocalisedString(@"Log out");
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
        
        
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(15, 30, tableView.frame.size.width - 5, 22);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        headerLabel.text = LocalisedString(@"Profile");
        headerLabel.textAlignment = NSTextAlignmentLeft;
        
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
        
        
        // 5. Finally return
        return headerView;
    }
    
    if (section == 1) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
        
        
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(15, 5, tableView.frame.size.width - 5, 30);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        headerLabel.text = LocalisedString(@"Support");
        headerLabel.textAlignment = NSTextAlignmentLeft;
        
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
        
        
        // 5. Finally return
        return headerView;
    }
    if (section == 2) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];
        
        
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(15, 5, tableView.frame.size.width - 5, 30);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        headerLabel.text = LocalisedString(@"Log out");
        headerLabel.textAlignment = NSTextAlignmentLeft;
        
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
        
        
        // 5. Finally return
        return headerView;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (indexPath.section == 0) {
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(20, 0, 250, 44);
        ShowTitle_.tag = 50;
        //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentLeft;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [cell addSubview:ShowTitle_];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView *AddArrowImg = [[UIImageView alloc]init];
        AddArrowImg.frame = CGRectMake(screenWidth - 30, 15, 8, 13);
        AddArrowImg.image = [UIImage imageNamed:@"Caret.png"];
        [cell addSubview:AddArrowImg];
    }else if (indexPath.section == 1) {
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(20, 0, 250, 44);
        ShowTitle_.tag = 100;
        //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentLeft;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [cell addSubview:ShowTitle_];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView *AddArrowImg = [[UIImageView alloc]init];
        AddArrowImg.frame = CGRectMake(screenWidth - 30, 15, 8, 13);
        AddArrowImg.image = [UIImage imageNamed:@"Caret.png"];
        [cell addSubview:AddArrowImg];
    }else{
        
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(20, 0, 250, 44);
        ShowTitle_.tag = 150;
        //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentLeft;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [cell addSubview:ShowTitle_];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UIImageView *AddArrowImg = [[UIImageView alloc]init];
        AddArrowImg.frame = CGRectMake(screenWidth - 30, 15, 8, 13);
        AddArrowImg.image = [UIImage imageNamed:@"Caret.png"];
        [cell addSubview:AddArrowImg];
    }
    
    if (indexPath.section == 0) {
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        //cell.textLabel.text = cellValue;
        UILabel *ShowProfileText = (UILabel *)[cell viewWithTag:50];
        ShowProfileText.text = cellValue;
    }else if (indexPath.section == 1) {
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        //cell.textLabel.text = cellValue;
        UILabel *ShowSupportText = (UILabel *)[cell viewWithTag:100];
        ShowSupportText.text = cellValue;
    }else{
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        UILabel *ShowLogOutText = (UILabel *)[cell viewWithTag:150];
        ShowLogOutText.text = cellValue;
        
    }
    
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
    
    if (indexPath.section == 0) {
        
        NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        selectedCell = [array objectAtIndex:indexPath.row];
        
        NSLog(@"Profile By %@", selectedCell);
        switch (indexPath.row) {
            case 0:{
                EditProfileV2ViewController *EditProfileView = [[EditProfileV2ViewController alloc]init];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:EditProfileView animated:NO completion:nil];
               // [self.view.window.rootViewController presentViewController:EditProfileView animated:YES completion:nil];
                //[self.parentViewController presentViewController:EditProfileView animated:YES completion:nil];
            }
                break;
            case 1:{
                EditInterestV2ViewController *EditInterestView = [[EditInterestV2ViewController alloc]init];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:EditInterestView animated:NO completion:nil];
            }
                break;
            case 2:{
                AccountSettingViewController *AccountSettingView = [[AccountSettingViewController alloc]init];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:AccountSettingView animated:NO completion:nil];
            }
                break;
            case 3:{
//                NotificationSettingsViewController *NotificationSettingsView = [[NotificationSettingsViewController alloc]init];
//                CATransition *transition = [CATransition animation];
//                transition.duration = 0.2;
//                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                transition.type = kCATransitionPush;
//                transition.subtype = kCATransitionFromRight;
//                [self.view.window.layer addAnimation:transition forKey:nil];
//                [self presentViewController:NotificationSettingsView animated:NO completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }else if(indexPath.section == 1){
        NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        selectedCell = [array objectAtIndex:indexPath.row];
        
        NSLog(@"Support By %@", selectedCell);
        switch (indexPath.row) {
            case 0:{
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
                break;
            case 1:{
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
                break;
            case 2:{
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
                break;
            case 3:{
                FeedbackViewController *FeedbackView = [[FeedbackViewController alloc]init];
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self presentViewController:FeedbackView animated:NO completion:nil];
            }
                break;
                
            default:
                break;
        }
    }else{
        
        NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        selectedCell = [array objectAtIndex:indexPath.row];
        
        NSLog(@"Log Out %@", selectedCell);
        switch (indexPath.row) {
            case 0:{
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Log out") message:LocalisedString(@"Are you sure you want to sign out of Seeties?") delegate:self cancelButtonTitle:LocalisedString(@"Maybe not..") otherButtonTitles:LocalisedString(@"Yeah!!"), nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
              //  [self SendUserLogoutToServer];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            exit(0);
        }else{
            //reset clicked
        }
    }else if(alertView.tag == 1000){
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            NSLog(@"Cancel");
        }else{
            //reset clicked
            // [self SendLoginDataToServer];
            [self SendUserLogoutToServer];
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

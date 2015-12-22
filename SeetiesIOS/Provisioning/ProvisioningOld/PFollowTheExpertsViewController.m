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

#import "FeedViewController.h"
#import "NewProfileV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface PFollowTheExpertsViewController ()<CLLocationManagerDelegate>
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
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.frame = CGRectMake(0, -20, screenWidth, screenHeight + 20);
    [MainScroll setContentSize:CGSizeMake(screenWidth * 5, 480)];
    
    Feed1View.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    Feed1Img.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    Feed1DoneButton.frame = CGRectMake(screenWidth - 70, 22, 70, 40);
    Feed1_nearby.frame = CGRectMake(0, 40, screenWidth, 25);
    Feed1_nearbySub.frame = CGRectMake(0, 65, screenWidth, 25);
    Feed1_Recommend.frame = CGRectMake(0, screenHeight - 100, screenWidth, 25);
    Feed1_RecommendSub.frame = CGRectMake(0, screenHeight - 75, screenWidth, 25);

    Feed2View.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    Feed2Img.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    Feed2DoneButton.frame = CGRectMake(screenWidth - 70, 22, 70, 40);
    Feed2_CollectIn.frame = CGRectMake(40, 60, 180, 25);
    Feed2_CollectInSub.frame = CGRectMake(5, 85, 250, 25);
    Feed2_Collect.frame = CGRectMake(screenWidth - 125, 170, 100, 25);
    Feed2_CollectSub.frame = CGRectMake(screenWidth - 125, 195, 100, 50);
    Feed2_Follow.frame = CGRectMake(screenWidth - 125, screenHeight - 100, 100, 25);
    Feed2_FollowSub.frame = CGRectMake(screenWidth - 155, screenHeight - 75, 150, 50);
    
    ProfileView.frame = CGRectMake(screenWidth * 2, 0, screenWidth, screenHeight);
    ProfileImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ProfileDoneButton.frame = CGRectMake(screenWidth - 70, 22, 70, 40);
    Profile_EditProfile.frame = CGRectMake((screenWidth / 2) - 75, 60, 150, 25);
    Profile_EditProfileSub.frame = CGRectMake((screenWidth / 2) - 75, 85, 150, 50);
    Profile_Collections.frame = CGRectMake(0, screenHeight - 100, screenWidth, 25);
    Profile_CollectionsSub.frame = CGRectMake(0, screenHeight - 75, screenWidth, 25);

    EditPostView.frame = CGRectMake(screenWidth * 3, 0, screenWidth, screenHeight);
    EditPostImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    EditPostDoneButton.frame = CGRectMake(screenWidth - 70, 22, 70, 40);
    EditPost_Addurl.frame = CGRectMake(0, screenHeight - 100, 150, 25);
    EditPost_AddurlSub.frame = CGRectMake(0, screenHeight - 75, 150, 50);
    EditPost_Save.frame = CGRectMake(screenWidth - 150, screenHeight - 100, 150, 25);
    EditPost_SaveSub.frame = CGRectMake(screenWidth - 150, screenHeight - 75, 150, 25);
    
    TranslateView.frame = CGRectMake(screenWidth * 4, 0, screenWidth, screenHeight);
    TranslateImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    TranslateDoneButton.frame = CGRectMake(screenWidth - 70, 22, 70, 40);
    Translate_Title.frame = CGRectMake(0, screenHeight - 100, screenWidth, 25);
    Translate_Sub.frame = CGRectMake(0, screenHeight - 75, screenWidth, 25);
    
    
    Feed1_nearby.text = NSLocalizedString(@"PNearby", nil);
    Feed1_nearbySub.text = NSLocalizedString(@"PExplore goodies around you.", nil);
    Feed1_Recommend.text = NSLocalizedString(@"PRecommend", nil);
    Feed1_RecommendSub.text = NSLocalizedString(@"PShare your thoughts with friends.", nil);
    
    Feed2_CollectIn.text = NSLocalizedString(@"PCollect In", nil);
    Feed2_CollectInSub.text = NSLocalizedString(@"PPersonalize your collection.", nil);
    Feed2_Collect.text = NSLocalizedString(@"PCollect", nil);
    Feed2_CollectSub.text = NSLocalizedString(@"PCollect post here!", nil);
    Feed2_Follow.text = NSLocalizedString(@"PFollow", nil);
    Feed2_FollowSub.text = NSLocalizedString(@"PSee more from your favourite Seetizens.", nil);
    
    Profile_EditProfile.text = NSLocalizedString(@"PEdit Profile", nil);
    Profile_EditProfileSub.text = NSLocalizedString(@"PPeople know you and find you better.", nil);
    Profile_Collections.text = NSLocalizedString(@"PCollections", nil);
    Profile_CollectionsSub.text = NSLocalizedString(@"PView your collections here.", nil);
    
    EditPost_Addurl.text = NSLocalizedString(@"PAdd URL", nil);
    EditPost_AddurlSub.text = NSLocalizedString(@"PDrive traffic to your page or blog.", nil);
    EditPost_Save.text = NSLocalizedString(@"PSave", nil);
    EditPost_SaveSub.text = NSLocalizedString(@"PFinish it later.", nil);
    
    Translate_Title.text = NSLocalizedString(@"PTranslate", nil);
    Translate_Sub.text = NSLocalizedString(@"PNo more language barrier", nil);
    
    [Feed1DoneButton setTitle:NSLocalizedString(@"PSkip", nil) forState:UIControlStateNormal];
    [Feed2DoneButton setTitle:NSLocalizedString(@"PSkip", nil) forState:UIControlStateNormal];
    [ProfileDoneButton setTitle:NSLocalizedString(@"PSkip", nil) forState:UIControlStateNormal];
    [EditPostDoneButton setTitle:NSLocalizedString(@"PSkip", nil) forState:UIControlStateNormal];
    [TranslateDoneButton setTitle:NSLocalizedString(@"PDone", nil) forState:UIControlStateNormal];
    
    pageControl.frame = CGRectMake(0, screenHeight - 50, screenWidth, 37);
    [self.view addSubview:pageControl];

    
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
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
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
        NSString *GetCategories = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"categories"]];
        NSString *GetFbID = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"fb_id"]];
        NSString *GetInstaID = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"insta_id"]];
        
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
//        if ([TempArray count] < 1) {
            GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
//        }else{
//            GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
//            GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
//        }
        GetLanguage_2 = @"";
        if ([GetLanguage_1 isEqualToString:@""] || [GetLanguage_1 length] == 0 || [GetLanguage_1 isEqualToString:@"(null)"]) {
            GetLanguage_1 = @"";
           // GetLanguage_2 = @"";
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
        [defaults setObject:GetCategories forKey:@"UserData_Categories"];
        [defaults setObject:GetFbID forKey:@"UserData_FbID"];
        [defaults setObject:GetInstaID forKey:@"UserData_instaID"];
        [defaults synchronize];
        
        
//        NSTimer *RandomTimer;
//        //    //2 sec to show button.
//        RandomTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
    }
}

-(IBAction)DoneButton:(id)sender{
    NSString *CheckStatus = @"0";
    NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
    NSString *CheckNewUser = @"NewUser";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults setObject:CheckLogin forKey:@"CheckLogin"];
    [defaults setObject:CheckNewUser forKey:@"CheckNewUser"];
    [defaults synchronize];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)UpdateUserDataToServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetProvisioning_Interest_ID = [defaults objectForKey:@"Provisioning_Interest"];
    NSString *GetLocationJson = [defaults objectForKey:@"Provisioning_FullJson"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *GetLang01 = [defaults objectForKey:@"Provisioning_SelectLanguage01"];
    NSString *GetLang02 = [defaults objectForKey:@"Provisioning_SelectLanguage02"];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"PFollow language is %@",language);
    NSString *GetSystemLanguage;
    if ([GetLang01 length] == 0 || [GetLang01 isEqualToString:@"(null)"]) {
        GetLang01 = @"530b0ab26424400c76000003";
    }
    if ([language isEqualToString:@"en"]) {
        GetSystemLanguage = @"530b0ab26424400c76000003";
        GetLang01 = @"530b0ab26424400c76000003";
    }else if([language isEqualToString:@"zh-Hans"]){
        GetSystemLanguage = @"530b0aa16424400c76000002";
        GetLang01 = @"530b0aa16424400c76000002";
    }else if([language isEqualToString:@"zh-Hant"]){
        GetSystemLanguage = @"530d5e9b642440d128000018";
        GetLang01 = @"530b0aa16424400c76000002";
    }else if([language isEqualToString:@"id"]){
        GetSystemLanguage = @"53672e863efa3f857f8b4ed2";
        GetLang01 = @"53672e863efa3f857f8b4ed2";
    }else if([language isEqualToString:@"th"]){
        GetSystemLanguage = @"544481503efa3ff1588b4567";
        GetLang01 = @"544481503efa3ff1588b4567";
    }else{
        GetSystemLanguage = @"530b0ab26424400c76000003";
        GetLang01 = @"530b0ab26424400c76000003";
    }
   
//    NSMutableArray *GetlanguageCodeArray = [defaults objectForKey:@"LanguageData_Code"];
//    NSMutableArray *GetlanguageIDArray = [defaults objectForKey:@"LanguageData_ID"];
//    NSString *GetSystemLanguageData;
//    for (int i = 0; i < [GetlanguageCodeArray count]; i++) {
//        NSString *GetLanguageCode = [[NSString alloc]initWithFormat:@"%@",[GetlanguageCodeArray objectAtIndex:i]];
//        
//        if ([GetLanguageCode isEqualToString:language]) {
//            GetSystemLanguageData = [[NSString alloc]initWithFormat:@"%@",[GetlanguageIDArray objectAtIndex:i]];
//            break;
//        }else{
//        GetSystemLanguageData = @"530b0ab26424400c76000003";
//        }
//    }
    
    NSLog(@"GetExpertToken is %@",GetExpertToken);
    NSLog(@"GetProvisioning_Interest_ID is %@",GetProvisioning_Interest_ID);
    NSLog(@"GetLocationJson is %@",GetLocationJson);
    NSLog(@"Getuid is %@",Getuid);
    NSLog(@"GetLang01 is %@",GetLang01);
    NSLog(@"GetLang02 is %@",GetLang02);
    
    if ([GetLocationJson length] == 0 || [GetLocationJson isEqualToString:@"(null)"]) {
        GetLocationJson = @"";
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
    [body appendData:[[NSString stringWithFormat:@"%@",GetSystemLanguage] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
//    if ([GetLang02 length] == 0 || [GetLang02 isEqualToString:@"(null)"] || [GetLang02 isEqualToString:@"None"]) {
//        GetLang02 = @"530b0ab26424400c76000003";
//    }else{
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        //Attaching the key name @"parameter_second" to the post body
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"languages[1]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        //Attaching the content to be posted ( ParameterSecond )
//        [body appendData:[[NSString stringWithFormat:@"%@",GetLang02] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
    
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (scrollView == MainScroll) {
        CGFloat pageWidth = MainScroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = MainScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl

    }
}
-(IBAction)Feed1DoneButtonOnClick:(id)sender{
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
     [MainScroll setContentOffset:CGPointMake(screenWidth * 4, -20) animated:YES];
}
-(IBAction)Feed2DoneButtonOnClick:(id)sender{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [MainScroll setContentOffset:CGPointMake(screenWidth * 4, -20) animated:YES];
}
-(IBAction)ProfileDoneButtonOnClick:(id)sender{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [MainScroll setContentOffset:CGPointMake(screenWidth * 4, -20) animated:YES];}
-(IBAction)EditPostDoneButtonOnClick:(id)sender{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [MainScroll setContentOffset:CGPointMake(screenWidth * 4, -20) animated:YES];
}
-(IBAction)TranslateDoneButtonOnClick:(id)sender{
    NSLog(@"Done tour");
    NSString *CheckStatus = @"0";
    NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
    NSString *CheckNewUser = @"NewUser";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults setObject:CheckLogin forKey:@"CheckLogin"];
    [defaults setObject:CheckNewUser forKey:@"CheckNewUser"];
    [defaults synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end

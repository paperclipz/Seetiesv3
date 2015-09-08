//
//  ExpertLoginViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ExpertLoginViewController.h"
//#import "MainViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "PublishMainViewController.h"
#import "NotificationViewController.h"
#import "ProfileV2ViewController.h"
#import "ForgotPasswordViewController.h"
#import "LLARingSpinnerView.h"
#import "FeedbackViewController.h"
#import "ExpertLoginViewController.h"
#import "SelectImageViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

#import "FeedV2ViewController.h"

#import "LeveyTabBarController.h"
#import "RecommendPopUpViewController.h"

#import "FeedViewController.h"
#import "NewProfileV2ViewController.h"

#import <Parse/Parse.h>
@interface ExpertLoginViewController ()
//@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation ExpertLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    [self initSelfView];
}

-(void)initSelfView
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowBackgroundImage.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    Scrollview.delegate = self;
    Scrollview.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(0, 30, screenWidth, 44);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    LoginBackgroundImg.frame = CGRectMake(0, 78, screenWidth, 89);
    CancelButton.frame = CGRectMake(screenWidth - 70, 20, 70, 44);
    LogoImg.frame = CGRectMake((screenWidth / 2) - 20, 20, 40, 40);
    
    
    ShowLoginID.frame = CGRectMake(40, 82, screenWidth - 80, 50);
    ShowPassword.frame = CGRectMake(40, 134, screenWidth - 80, 50);
    
    btnBackground_1.frame = CGRectMake(30, 82, screenWidth - 60, 50);
    btnBackground_2.frame = CGRectMake(30, 134, screenWidth - 60, 50);
    btnBackground_1.layer.cornerRadius = 5;
    btnBackground_2.layer.cornerRadius = 5;
    
    if (screenHeight > 480) {
        LoginButton.frame = CGRectMake(30, 195, screenWidth - 60, 50);
        ForgotPasswordButton.frame = CGRectMake(30, 269, 129, 30);
        NeedHelpButton.frame = CGRectMake(screenWidth - 30 - 94, 269, 94, 30);
    }else{
        LoginButton.frame = CGRectMake(30, 175, screenWidth - 60, 50);
        ForgotPasswordButton.frame = CGRectMake(30, 229, 129, 30);
        NeedHelpButton.frame = CGRectMake(screenWidth - 30 - 94, 229, 94, 30);
    }
}

-(void)GetSameEmailData:(NSString *)EmailData{
    ShowLoginID.text = EmailData;
}
//- (UIStatusBarStyle) preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Expert Login Page";
    
    
    
    ShowLoginID.delegate = self;
    ShowPassword.delegate = self;
    
    
    ShowLoginID.placeholder = NSLocalizedString(@"ExpertLogin_Username",nil);
    ShowPassword.placeholder = NSLocalizedString(@"ExpertLogin_Password", nil);
    ShowTitle.text = NSLocalizedString(@"ExpertLogin_Title",nil);
    [LoginButton setTitle:NSLocalizedString(@"ExpertLogin_LoginButton",nil) forState:UIControlStateNormal];
    [ForgotPasswordButton setTitle:NSLocalizedString(@"ExpertLogin_ForgotPassword",nil) forState:UIControlStateNormal];
    [NeedHelpButton setTitle:NSLocalizedString(@"ExpertLogin_NeedHelp",nil) forState:UIControlStateNormal];
    
//    ShowLoginID.text = @"reinerlee";
//    ShowPassword.text = @"1234qwer";
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ShowLoginID becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ShowLoginID resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == ShowLoginID) {
        [ShowLoginID resignFirstResponder];
        [ShowPassword becomeFirstResponder];
    }else if(textField == ShowPassword){
        [ShowPassword resignFirstResponder];
        
        GetLoginID = ShowLoginID.text;
        GetPassword = ShowPassword.text;
        
        [self SendLoginDataToServer];
    }else{
        [textField resignFirstResponder];
        

    }
    
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(IBAction)LoginButton:(id)sender{
    
    if ([ShowLoginID.text length] == 0 || [ShowPassword.text length] == 0) {
         [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Opps! Seem like you have forgot to insert username or password :)" type:TSMessageNotificationTypeError];
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Opps! Seem like you have forgot to insert username or password :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [ShowAlert show];
    }else{
        [ShowLoginID resignFirstResponder];
        [ShowPassword resignFirstResponder];
        
        GetLoginID = ShowLoginID.text;
        GetPassword = ShowPassword.text;
        
        NSLog(@"GetLoginID is %@",GetLoginID);
        NSLog(@"GetPassword is %@",GetPassword);
        
        [self SendLoginDataToServer];
    }
    

    
  //  MainViewController *MainView = [[MainViewController alloc]init];
   // [self presentViewController:MainView animated:YES completion:nil];
}
-(IBAction)ForgotPasswordButton:(id)sender{
    ForgotPasswordViewController *ForgotPasswordView = [[ForgotPasswordViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ForgotPasswordView animated:NO completion:nil];
}
-(void)SendLoginDataToServer{
    
    [ShowActivity startAnimating];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.ExpertLogin_Url];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"login_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetLoginID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetPassword] dataUsingEncoding:NSUTF8StringEncoding]];
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
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
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
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    [TSMessage showNotificationInViewController:self title:CustomLocalisedString(@"ErrorConnection", nil) subtitle:CustomLocalisedString(@"NoData", nil) type:TSMessageNotificationTypeError];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"ExpertLogin return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Expert Json = %@",res);
    
    [ShowActivity stopAnimating];
    
    NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    NSLog(@"ErrorString is %@",ErrorString);
    NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"MessageString is %@",MessageString);
    
    if ([MessageString length] == 0 || [MessageString isEqualToString:@"(null)"] || [MessageString isEqualToString:@"None"]) {
        [ShowActivity stopAnimating];
        
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        
        NSLog(@"Got Data.");
        NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithArray:[GetAllData valueForKey:@"categories"]];
        NSLog(@"categoriesArray is %@",categoriesArray);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"country"]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *Getcrawler = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"crawler"]];
        NSLog(@"Getcrawler is %@",Getcrawler);
        NSString *Getcreated_at = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"created_at"]];
        NSLog(@"Getcreated_at is %@",Getcreated_at);
        NSString *Getdescription = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
        NSLog(@"Getdescription is %@",Getdescription);
        NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
        NSLog(@"Getdob is %@",Getdob);
        NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
        NSLog(@"Getemail is %@",Getemail);
        NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
        NSLog(@"Getusername is %@",Getusername);
        NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"profile_photo"]];
        NSLog(@"Getprofile_photo is %@",Getprofile_photo);
        NSString *Gettoken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"token"]];
        NSLog(@"Gettoken is %@",Gettoken);
        NSString *Getuid = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"uid"]];
        NSLog(@"Getuid is %@",Getuid);
        NSString *Getprovisioning = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"provisioning"]];
        NSLog(@"Getprovisioning is %@",Getprovisioning);
        NSString *Getrole = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"role"]];
        NSLog(@"Getrole is %@",Getrole);
        NSString *GetPasswordCheck = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"has_password"]];
        NSLog(@"GetPasswordCheck is %@",GetPasswordCheck);
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
        
        
        
        LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
        
        Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
        
        NSLog(@"Language selected: %@", localeForRow.name);
        
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
        [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
        [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
        [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
        [defaults setObject:GetCaption forKey:@"UserData_SystemLanguage"];
        [defaults setObject:GetFbExtendedToken forKey:@"fbextendedtoken"];
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
                
                NSArray *subscribedChannels = [PFInstallation currentInstallation].channels;
                NSLog(@"subscribedChannels is %@",subscribedChannels);
                
                NSString *TempString = @"Done";
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:TempString forKey:@"CheckGetPushToken"];
                [defaults synchronize];
            }
            
        }
        
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

    }else{
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:MessageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [ShowAlert show];

        

    }
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
@end

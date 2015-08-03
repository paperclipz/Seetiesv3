//
//  EditProfileViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "EditProfileViewController.h"
#import "PSearchLocationViewController.h"


#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    EditBackImg.frame = CGRectMake(0, 110, screenWidth, 379);
    
    ShowTitle.text = CustomLocalisedString(@"EditProfileText",nil);
    SubTitle.text = CustomLocalisedString(@"EditProfileSubText",nil);
    UsernameText.text = CustomLocalisedString(@"EditProfileUsername",nil);
    FullnameText.text = CustomLocalisedString(@"EditProfileFullname",nil);
    WebsiteText.text = CustomLocalisedString(@"EditProfileWebsite",nil);
    BioText.text = CustomLocalisedString(@"EditProfileBio",nil);
    LocationText.text = CustomLocalisedString(@"EditProfileLocation",nil);
    
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];
    
    ShowUsername.frame = CGRectMake(123, 119, screenWidth - 123 - 15, 30);
    ShowName.frame = CGRectMake(123, 162, screenWidth - 123 - 15, 30);
    ShowWebsite.frame = CGRectMake(123, 204, screenWidth - 123 - 15, 30);
    ShowAbouts.frame = CGRectMake(118, 247, screenWidth - 118 - 15, 168);
    ShowLocation.frame = CGRectMake(123, 446, screenWidth - 123 - 30, 43);

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Edit Profile Page";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetName = [defaults objectForKey:@"UserData_Name"];
    GetUserName = [defaults objectForKey:@"UserData_Username"];
    GetAbouts = [defaults objectForKey:@"UserData_Abouts"];
    GetWebsite = [defaults objectForKey:@"UserData_Url"];
    FullLocation = [defaults objectForKey:@"UserData_Location"];
    NSString *CheckFullLocation = [defaults objectForKey:@"Provisioning_LocationName"];
    
    ShowName.text = GetName;
    ShowUsername.text = GetUserName;
    
    if ([GetAbouts length] == 0) {
        ShowAbouts.text = @"Bio";
    }else{
        ShowAbouts.text = GetAbouts;
    }
    
    if ([GetWebsite length] == 0) {
        //  ShowWebsite.text = @"Bio";
        ShowWebsite.placeholder = @"Website";
    }else{
        ShowWebsite.text = GetWebsite;
    }
    if ([FullLocation length] == 0) {
        //  ShowWebsite.text = @"Bio";
        if ([CheckFullLocation length] == 0) {
            ShowLocation.text = @"Location";
        }else{
            ShowLocation.text = CheckFullLocation;
        }
    }else{
        if ([CheckFullLocation length] == 0) {
            ShowLocation.text = FullLocation;
        }else{
            ShowLocation.text = CheckFullLocation;
        }
        
    }
   // ShowLocation.text = FullLocation;
    
    CheckName = 0;
    CheckWebsite = 0;
    CheckFUllLocation= 0;
    CheckAbouts = 0;
}
-(IBAction)OpenLocationButton:(id)sender{
    PSearchLocationViewController *PSearchLocationView = [[PSearchLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PSearchLocationView animated:NO completion:nil];
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
-(IBAction)SaveButton:(id)sender{
    NSLog(@"ShowName is %@",ShowName.text);
    if ([ShowName.text isEqualToString:GetName]) {
        NSLog(@"name same data.");
        CheckName = 0;
    }else{
        if ([ShowName.text length] == 0) {
            CheckName = 0;
        }else{
        CheckName = 1;
        }
        
    
    }
    NSLog(@"ShowUsername is %@",ShowUsername.text);
    NSLog(@"ShowAbouts is %@",ShowAbouts.text);
    if ([ShowAbouts.text isEqualToString:@"Bio"] || [ShowAbouts.text length] == 0) {
        NSLog(@"user abouts same data.");
        CheckAbouts = 0;
    }else{
        CheckAbouts = 1;
    }
    NSLog(@"ShowWebsite is %@",ShowWebsite.text);
    if ([ShowWebsite.text length] == 0) {
        NSLog(@"user no update website");
        CheckWebsite = 0;
    }else{
        CheckWebsite = 1;
    }
    NSLog(@"ShowLocation is %@",ShowLocation.text);
    if ([ShowLocation.text isEqualToString:FullLocation]) {
        NSLog(@"ShowLocation same data.");
        CheckFUllLocation = 0;
    }else{
        CheckFUllLocation = 1;
    }
    SaveButton.enabled = NO;
    
    [self UpdateUserInformation];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)UpdateUserInformation{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    LoadingBlackBackground = [[UIButton alloc]init];
    [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
    LoadingBlackBackground.backgroundColor = [UIColor blackColor];
    LoadingBlackBackground.alpha = 0.5f;
    LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:LoadingBlackBackground];
    
    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.lineWidth = 1.0f;
    [self.view addSubview:spinnerView];
    [spinnerView startAnimating];
    
    ShowLoadingText = [[UILabel alloc]init];
    ShowLoadingText.frame = CGRectMake(0, (screenHeight/2) + 30, screenWidth, 40);
    ShowLoadingText.text = @"Uploading...";
    ShowLoadingText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    ShowLoadingText.textColor = [UIColor whiteColor];
    ShowLoadingText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowLoadingText];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DataUrl.UserWallpaper_Url,Getuid];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (CheckName == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",ShowName.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (CheckAbouts == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",ShowAbouts.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (CheckWebsite == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"personal_link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",ShowWebsite.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (CheckFUllLocation == 1) {
        
        NSString *GetLocationJson = [defaults objectForKey:@"Provisioning_FullJson"];
        NSLog(@"GetLocationJson is %@",GetLocationJson);
        if ([GetLocationJson isEqualToString:@"(null)"]) {
             GetLocationJson = @"";
        }else{

        }
        
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"home_city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationJson] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Update Category return get data to server ===== %@",GetData);

    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"res is %@",res);
    
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
            NSString *GetName_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
            NSLog(@"GetName_ is %@",GetName_);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
            NSLog(@"GetLocation is %@",GetLocation);
            NSString *GetAbouts_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"GetAbouts_ is %@",GetAbouts_);
            NSString *GetUrl = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"personal_link"]];
            NSLog(@"GetUrl is %@",GetUrl);
            NSString *GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"follower_count"]];
            NSLog(@"GetFollowersCount is %@",GetFollowersCount);
            NSString *GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"following_count"]];
            NSLog(@"GetFollowingCount is %@",GetFollowingCount);
            NSString *Getcategories = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"categories"]];
            NSLog(@"Getcategories is %@",Getcategories);
            NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            NSString *GetGender = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
            NSLog(@"GetGender is %@",GetGender);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
            
            NSInteger CheckSystemLanguageData;
            if ([GetSystemLanguage isEqualToString:@"English"]) {
                CheckSystemLanguageData = 0;
            }else if([GetSystemLanguage isEqualToString:@"Simplified Chinese"]){
                CheckSystemLanguageData = 1;
            }else if([GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
                CheckSystemLanguageData = 2;
            }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
                CheckSystemLanguageData = 3;
            }else if([GetSystemLanguage isEqualToString:@"Thai"] || [GetSystemLanguage isEqualToString:@"th"]){
                CheckSystemLanguageData = 4;
            }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
                CheckSystemLanguageData = 5;
            }
            
            
            //  NSLog(@"CheckSystemLanguage is %li",(long)CheckSystemLanguage);
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguageData];
            
            NSLog(@"Landing Language selected: %@", localeForRow.name);
            
            [languageManager setLanguageWithLocale:localeForRow];
            
            NSDictionary *LanguageData = [res valueForKey:@"languages"];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in LanguageData) {
                NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                [TempArray addObject:GetLanguage_1];
            }
            
//            NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
//            NSString *GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
            NSString *GetLanguage_1;
            NSString *GetLanguage_2;
            if ([TempArray count] == 1) {
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
            }else{
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
            }
            NSString *CheckGetUserProfile = @"false";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
            [defaults setObject:Getcategories forKey:@"UserData_Categories"];
            [defaults setObject:GetName_ forKey:@"UserData_Name"];
            [defaults setObject:Getusername forKey:@"UserData_Username"];
            [defaults setObject:GetAbouts_ forKey:@"UserData_Abouts"];
            [defaults setObject:GetUrl forKey:@"UserData_Url"];
            [defaults setObject:Getemail forKey:@"UserData_Email"];
            [defaults setObject:GetLocation forKey:@"UserData_Location"];
            [defaults setObject:Getdob forKey:@"UserData_dob"];
            [defaults setObject:GetGender forKey:@"UserData_Gender"];
            [defaults setObject:GetSystemLanguage forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults synchronize];
            
            //  [ProgressHUD showSuccess:@""];
            
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            //[self presentViewController:ListingDetail animated:NO completion:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    SaveButton.enabled = YES;
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == ShowUsername) {
        [ShowUsername resignFirstResponder];
        [ShowName becomeFirstResponder];
    }else if(textField == ShowName){
        [ShowName resignFirstResponder];
        [ShowWebsite becomeFirstResponder];
        // RedIcon.hidden = NO;
    }else{
        [textField resignFirstResponder];
    }
    
    
    return YES;
}
@end

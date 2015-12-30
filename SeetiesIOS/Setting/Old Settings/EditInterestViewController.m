//
//  EditInterestViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "EditInterestViewController.h"
//#import "ProgressHUD.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface EditInterestViewController ()

@end

@implementation EditInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    // Do any additional setup after loading the view from its nib.

    ShowTitle.text = CustomLocalisedString(@"SettingsPage_EditInterests",nil);
    ShowSubTitle.text = CustomLocalisedString(@"Selectyourinterest",nil);
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];
    
    checkSelectData = 0;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    ShowSubTitle.frame = CGRectMake(15, 71, screenWidth - 30, 40);
    
    
   // CategorySelectIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *GetCategories = [defaults objectForKey:@"UserData_Categories"];
    NSLog(@"GetCategories is %@",GetCategories);
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
    GetCategories = [[GetCategories componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSArray *arr = [GetCategories componentsSeparatedByString:@","];
    NSLog(@"arr is %@",arr);
    CategorySelectIDArray = [[NSMutableArray alloc]initWithArray:arr];
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    
    NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
    GetCategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
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
    // NSMutableArray *GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
    NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image"]];
    NSMutableArray *GetBackgroundArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
    
    NSMutableArray *GetImageArray1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < [GetTempImageArray count]; i++) {
        
        [GetImageArray1 addObject:[self decodeBase64ToImage:[GetTempImageArray objectAtIndex:i]]];
    }
    
    int GetWidth = (screenWidth / 2);
    int ButtonWidth = (GetWidth/2);
    
    // 40,49,75,75 101 21
    for (int i = 0; i < [GetCategoryIDArray count]; i++) {
        CGSize rect = CGSizeMake(40, 40);
        CGFloat scale = [[UIScreen mainScreen]scale];
        UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
        [[GetImageArray1 objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIButton *ShowImageButton = [[UIButton alloc]init];
        ShowImageButton.tag = i;
        ShowImageButton.frame = CGRectMake((GetWidth/2) - (ButtonWidth/2) +(i % 2)* GetWidth, 120 + ((ButtonWidth + 60) * (CGFloat)(i /2)), ButtonWidth, ButtonWidth);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        NSString *CheckCategoryID = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:i]];
        for (int z = 0; z < [CategorySelectIDArray count]; z++) {
            if ([CheckCategoryID isEqualToString:[CategorySelectIDArray objectAtIndex:z]]) {
                ShowImageButton.selected = YES;
                break;
            }
        }
        
        
        NSUInteger red, green, blue;
        sscanf([[GetBackgroundArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = (ButtonWidth/2); // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowImageButton];
       // NSLog(@"ShowImageButton.tag === is %ld",(long)ShowImageButton.tag);
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(0 +(i % 2)*GetWidth, (120 + ButtonWidth + 10) + ((ButtonWidth + 60) * (CGFloat)(i /2)), GetWidth, 21);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowTitle_];
        
        [MainScroll setContentSize:CGSizeMake(300, (120 + ButtonWidth + 60) + ((ButtonWidth + 60) * (CGFloat)(i /2)))];
    }

}
-(IBAction)ShowImageButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray addObject:TempIDN];
        
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
    }

}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Edit Interest Page";
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
            NSString *Getdob_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob_ is %@",Getdob_);
            NSString *GetGender_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
            NSLog(@"GetGender_ is %@",GetGender_);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            NSString *GetSystemLanguage_ = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage_ is %@",GetSystemLanguage_);
            
            NSInteger CheckSystemLanguageData;
            if ([GetSystemLanguage_ isEqualToString:@"English"]) {
                CheckSystemLanguageData = 0;
            }else if([GetSystemLanguage_ isEqualToString:@"Simplified Chinese"]){
                CheckSystemLanguageData = 1;
            }else if([GetSystemLanguage_ isEqualToString:@"Traditional Chinese"]){
                CheckSystemLanguageData = 2;
            }else if([GetSystemLanguage_ isEqualToString:@"Bahasa Indonesia"]){
                CheckSystemLanguageData = 3;
            }else if([GetSystemLanguage_ isEqualToString:@"Thai"] || [GetSystemLanguage_ isEqualToString:@"th"]){
                CheckSystemLanguageData = 4;
            }else if([GetSystemLanguage_ isEqualToString:@"Filipino"]){
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
            [defaults setObject:Getdob_ forKey:@"UserData_dob"];
            [defaults setObject:GetGender_ forKey:@"UserData_Gender"];
            [defaults setObject:GetSystemLanguage_ forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults synchronize];
            
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
            [LoadingBlackBackground removeFromSuperview];
            [ShowLoadingText removeFromSuperview];

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

    
}
-(IBAction)SaveButton:(id)sender{
    if ([CategorySelectIDArray count] == 0) {
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Category cannot empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [ShowAlert show];
    }else{
    [self UpdateUserCategory];
    }
    
}
-(void)UpdateUserCategory{
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
    ShowLoadingText.text = @"Updating...";
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disvposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *GetSelectID = [CategorySelectIDArray componentsJoinedByString: @","];
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetSelectID] dataUsingEncoding:NSUTF8StringEncoding]];
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
@end

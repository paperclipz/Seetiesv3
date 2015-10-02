//
//  AccountSettingViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "AccountSettingViewController.h"

#import "ChangePasswordViewController.h"
#import "LandingV2ViewController.h"

#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "SelectImageViewController.h"
#import "FeedV2ViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface AccountSettingViewController ()
@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 600)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowTitle.text = LocalisedString(@"Account Settings");
    SaveButton.frame = CGRectMake(screenWidth - 50, 20, 50, 44);
    EditBackImg.frame = CGRectMake(0, 85, screenWidth, 462);
    
    Emailfield.frame = CGRectMake(screenWidth - 216 - 23, 301, 216, 30);
    ShowPrimary.frame = CGRectMake(screenWidth - 107 - 40, 136, 107, 21);
    ShowSecondary.frame = CGRectMake(screenWidth - 107 - 40, 180, 107, 21);
    ShowSystemlanguage.frame = CGRectMake(screenWidth - 107 - 40, 223, 107, 21);
    
    CaretPrimaryImg.frame = CGRectMake(screenWidth - 10 - 13, 140, 8, 13);
    CaretSecondaryImg.frame = CGRectMake(screenWidth - 10 - 13, 184, 8, 13);
    CaretAppLanguageImg.frame = CGRectMake(screenWidth - 10 - 13, 227, 8, 13);
    CaretChangePasswordImg.frame = CGRectMake(screenWidth - 10 - 13, 353, 8, 13);
    CaretDeleteAccountImg.frame = CGRectMake(screenWidth - 10 - 13, 521, 8, 13);

    DeleteButton.frame = CGRectMake(0, 506, screenWidth, 44);
    [DeleteButton setTitle:LocalisedString(@"Delete Account") forState:UIControlStateNormal];
    
    FacebookSwitch.frame = CGRectMake(screenWidth - 51 - 10, 390, 51, 31);
    InstagramSwitch.frame = CGRectMake(screenWidth - 51- 10, 431, 51, 31);
    DataUrl = [[UrlDataClass alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetEmail = [defaults objectForKey:@"UserData_Email"];
    GetSystemLanguage = [defaults objectForKey:@"UserData_SystemLanguage"];
    GetLanguage1 = [defaults objectForKey:@"UserData_Language1"];
    GetLanguage2 = [defaults objectForKey:@"UserData_Language2"];
    
    NSLog(@"Init GetLanguage1 == %@",GetLanguage1);
     NSLog(@"Init GetLanguage2 == %@",GetLanguage2);
    
    if ([GetLanguage1 isEqualToString:@"简体中文"] || [GetLanguage1 isEqualToString:@"繁體中文"]) {
        GetLanguage1 = @"中文";
    }
    if ([GetLanguage2 isEqualToString:@"简体中文"] || [GetLanguage2 isEqualToString:@"繁體中文"]) {
        GetLanguage2 = @"中文";
    }
    
    
    Emailfield.delegate = self;
    Emailfield.text = GetEmail;
   // ShowEmail.text = GetEmail;
    
    ShowSystemlanguage.text = GetSystemLanguage;
    ShowPrimary.text = GetLanguage1;
    if ([GetLanguage2 isEqualToString:@""]) {
        ShowSecondary.text = @"(Choose one)";
    }else{
        ShowSecondary.text = GetLanguage2;
    }
    
    NSLog(@"Init ShowPrimary == %@",ShowPrimary.text);
    NSLog(@"Init ShowSecondary == %@",ShowSecondary.text);
    
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,screenWidth, 44)];
    Toolbar.translucent=NO;
    Toolbar.barTintColor=[UIColor whiteColor];
    [self.view addSubview:Toolbar];
    
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    LanguageArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    LanguageID2Array = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    Language2Array = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    [Language2Array addObject:@"None"];
    [LanguageID2Array addObject:@""];
    
    NSMutableArray *SystemLanguageID_Array = [defaults objectForKey:@"SystemLanguageData_ID"];
    NSMutableArray *SystemLanguageName_Array = [defaults objectForKey:@"SystemLanguageData_Name"];
    
    SystemLanguageIDArray = [[NSMutableArray alloc]initWithArray:SystemLanguageID_Array];
    SystemLanguageNameArray = [[NSMutableArray alloc]initWithArray:SystemLanguageName_Array];
    
    for (int i = 0; i < [LanguageArray count]; i++) {
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[LanguageArray objectAtIndex:i]];
        if ([GetLanguage1 isEqualToString:TempString]) {
            GetLanguage1_ID = [[NSString alloc]initWithFormat:@"%@",[LanguageIDArray objectAtIndex:i]];
        }
        if ([GetLanguage2 isEqualToString:TempString]) {
            GetLanguage2_ID = [[NSString alloc]initWithFormat:@"%@",[LanguageIDArray objectAtIndex:i]];
        }
    }
    NSLog(@"GetLanguage1_ID is %@",GetLanguage1_ID);
    NSLog(@"GetLanguage2_ID is %@",GetLanguage2_ID);
    
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Language_PickerView.tag = 1;
    [self.view addSubview:Language_PickerView];
    Language_PickerView.delegate = self;
    Language_PickerView.backgroundColor = [UIColor whiteColor];
    Language_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    CheckSystemLanguage = 0;
    CheckLangauge1 = 0;
    CheckLanguage2 = 0;

    
    
    ShowTitle.text = CustomLocalisedString(@"SettingsPage_AccountSettings",nil);
   // [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];
    EmailText.text = CustomLocalisedString(@"SignUpPage_Email", nil);
    PrimaryText.text = CustomLocalisedString(@"Primary", nil);
    SecondaryText.text = CustomLocalisedString(@"Secondary", nil);
    AppLanguageText.text = CustomLocalisedString(@"AppLangauge", nil);
    ChangePasswordText.text = CustomLocalisedString(@"ChangePassword", nil);
   // [DeleteButton setTitle:CustomLocalisedString(@"Deactivateaccount",nil) forState:UIControlStateNormal];
    ShowSubTitle.text = CustomLocalisedString(@"ContentLanguage", nil);
    ConnectFBText.text = LocalisedString(@"Connect to Facebook");
    ConnectInstagramText.text = LocalisedString(@"Connect to Instagram");
    
    MainLanguage.text = LocalisedString(@"Language");
    MainAccount.text = LocalisedString(@"Account");
    MainOther.text = LocalisedString(@"Others");
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Account Setting Page";
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
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - UIPicker view Delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   if(pickerView.tag == 3){
        return [SystemLanguageNameArray count];
    }else if(pickerView.tag == 1){
    return [LanguageArray count];
    }else{
    return [Language2Array count];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1){
        ShowPrimary.text = [LanguageArray objectAtIndex:row];
        GetLanguage1_ID = [LanguageIDArray objectAtIndex:row];
    }else if(pickerView.tag == 2){
        ShowSecondary.text = [Language2Array objectAtIndex:row];
        GetLanguage2_ID = [LanguageID2Array objectAtIndex:row];
    }else{
        ShowSystemlanguage.text = [SystemLanguageNameArray objectAtIndex:row];
        GetSystemLanguage_ID = [SystemLanguageIDArray objectAtIndex:row];
    }

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 3){
        return [SystemLanguageNameArray objectAtIndex:row];
    }else if(pickerView.tag == 1){
        return [LanguageArray objectAtIndex:row];
    }else{
     return [Language2Array objectAtIndex:row];
    }
   
}
-(IBAction)DoneSelect:(id)sender{
    
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;

    
}
-(IBAction)SelectPrimaryButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    [LanguageIDArray removeAllObjects];
    [LanguageArray removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    LanguageArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    [LanguageArray removeObject:ShowSecondary.text];
    [LanguageIDArray removeObject:GetLanguage2_ID];
    [Language_PickerView reloadAllComponents];

    [Emailfield resignFirstResponder];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Language_PickerView.tag = 1;
    [self.view addSubview:Language_PickerView];
    Language_PickerView.delegate = self;
    Language_PickerView.backgroundColor = [UIColor whiteColor];
    Language_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    Toolbar.hidden = NO;
}
-(IBAction)SelectSecondaryButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    [LanguageID2Array removeAllObjects];
    [Language2Array removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageID2Array = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    Language2Array = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    [Language2Array addObject:@"None"];
    [LanguageID2Array addObject:@""];
    
    [Language2Array removeObject:ShowPrimary.text];
    [LanguageID2Array removeObject:GetLanguage1_ID];
    [Language_PickerView reloadAllComponents];

    [Emailfield resignFirstResponder];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Language_PickerView.tag = 2;
    [self.view addSubview:Language_PickerView];
    Language_PickerView.delegate = self;
    Language_PickerView.backgroundColor = [UIColor whiteColor];
    Language_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    Toolbar.hidden = NO;
}
-(IBAction)SystemLanguageButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;

    [Emailfield resignFirstResponder];
    
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Language_PickerView.tag = 3;
    [self.view addSubview:Language_PickerView];
    Language_PickerView.delegate = self;
    Language_PickerView.backgroundColor = [UIColor whiteColor];
    Language_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    Toolbar.hidden = NO;
}
-(IBAction)ChangePasswordButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    ChangePasswordViewController *ChangePasswordView = [[ChangePasswordViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ChangePasswordView animated:NO completion:nil];
}

-(IBAction)SaveButton:(id)sender{
    if ([ShowSystemlanguage.text isEqualToString:GetSystemLanguage]) {
        CheckSystemLanguage = 0;
    }else{
        CheckSystemLanguage = 1;
    }
    if ([ShowPrimary.text isEqualToString:GetLanguage1]) {
        CheckLangauge1 = 1;
    }else{
        CheckLangauge1 = 1;
    }
    if ([ShowSecondary.text isEqualToString:@"(Choose one)"] || [ShowSecondary.text isEqualToString:@"None"]) {
        CheckLanguage2 = 0;
    }else{
        CheckLanguage2 = 1;
    }
    NSLog(@"ShowSecondary.text is %@",ShowSecondary.text);
    NSLog(@"GetLanguage2 is %@",GetLanguage2);
    if ([Emailfield.text length] == 0) {
        
    }else{
        
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        
        if ([emailTest evaluateWithObject:Emailfield.text] == NO) {
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct email id"
                                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertsuccess show];
        }else{
            SaveButton.enabled = NO;
            [self updateUserInformation];
        }
    
    }
    
    
}
-(void)updateUserInformation{
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
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",Emailfield.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (CheckSystemLanguage == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"system_language\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetSystemLanguage_ID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (CheckLangauge1 == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"languages[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLanguage1_ID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (CheckLanguage2 == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"languages[1]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLanguage2_ID] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    theConnection_UpdateUserData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_UpdateUserData) {
      //  NSLog(@"Connection Successful");
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
    if (connection == theConnection_UpdateUserData) {
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
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                
                NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
                NSLog(@"Getemail is %@",Getemail);
                
                NSDictionary *SystemLanguageData = [GetAllData valueForKey:@"system_language"];
                NSString *GetSystemLanguage_ = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
                NSLog(@"GetSystemLanguage_ is %@",GetSystemLanguage_);
                
                NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]init];
                NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                NSDictionary *NSDictionaryLanguage = [GetAllData valueForKey:@"languages"];
                NSLog(@"NSDictionaryLanguage is %@",NSDictionaryLanguage);
                for (NSDictionary * dict in NSDictionaryLanguage){
                    NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
                    [GetUserSelectLanguagesArray addObject:Getid];
                    
                    NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                    //NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                    [TempArray addObject:GetLanguage_1];
                }
                NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
                
                NSString *GetLanguage_1;
                NSString *GetLanguage_2;
                if ([TempArray count] == 1) {
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                }else{
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                }
                
                NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                NSLog(@"GetLanguage_2 is %@",GetLanguage_2);
                
                
                NSInteger CheckSystemLanguageData;
                if ([GetSystemLanguage_ isEqualToString:@"English"]) {
                    CheckSystemLanguageData = 0;
                }else if([GetSystemLanguage_ isEqualToString:@"Simplified Chinese"] || [GetSystemLanguage_ isEqualToString:@"简体中文"]){
                    CheckSystemLanguageData = 1;
                }else if([GetSystemLanguage_ isEqualToString:@"Traditional Chinese"] || [GetSystemLanguage_ isEqualToString:@"繁體中文"]){
                    CheckSystemLanguageData = 2;
                }else if([GetSystemLanguage_ isEqualToString:@"Bahasa Indonesia"]){
                    CheckSystemLanguageData = 3;
                }else if([GetSystemLanguage_ isEqualToString:@"Thai"] || [GetSystemLanguage_ isEqualToString:@"th"] || [GetSystemLanguage_ isEqualToString:@"ภาษาไทย"]){
                    CheckSystemLanguageData = 4;
                }else if([GetSystemLanguage_ isEqualToString:@"Filipino"]){
                    CheckSystemLanguageData = 5;
                }
                
                //  NSLog(@"CheckSystemLanguage is %li",(long)CheckSystemLanguage);
                LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
                
                Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguageData];
                
                NSLog(@"Landing Language selected: %@", localeForRow.name);
                
                [languageManager setLanguageWithLocale:localeForRow];
                
                
                NSString *CheckGetUserProfile = @"false";
                
                
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *TempCheckSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
                NSLog(@"TempCheckSystemLanguage is %@",TempCheckSystemLanguage);
                if ([TempCheckSystemLanguage isEqualToString:GetSystemLanguage_]) {
                    [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
                    [defaults setObject:Getemail forKey:@"UserData_Email"];
                    [defaults setObject:GetSystemLanguage_ forKey:@"UserData_SystemLanguage"];
                    [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
                    [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
                    [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
                    [defaults synchronize];
                    
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.2;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromLeft;
                    [self.view.window.layer addAnimation:transition forKey:nil];
                    //[self presentViewController:ListingDetail animated:NO completion:nil];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
                    [defaults setObject:Getemail forKey:@"UserData_Email"];
                    [defaults setObject:GetSystemLanguage_ forKey:@"UserData_SystemLanguage"];
                    [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
                    [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
                    [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
                    [defaults synchronize];
                    
//                    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//                    NSLog(@"language is %@",language);
//                    // zh-Hans - Simplified Chinese
//                    // zh-Hant - Traditional Chinese
//                    // en - English
//                    // th - Thai
//                    // id - Bahasa Indonesia
//                    NSInteger CheckSystemLanguageIDN;
//                    if ([language isEqualToString:@"en"]) {
//                        CheckSystemLanguageIDN = 0;
//                    }else if([language isEqualToString:@"zh-Hans"]){
//                        CheckSystemLanguageIDN = 1;
//                    }else if([language isEqualToString:@"zh-Hant"]){
//                        CheckSystemLanguageIDN = 2;
//                    }else if([language isEqualToString:@"id"]){
//                        CheckSystemLanguageIDN = 3;
//                    }else if([language isEqualToString:@"th"]){
//                        CheckSystemLanguageIDN = 4;
//                    }else if([language isEqualToString:@"tl-PH"]){
//                        CheckSystemLanguageIDN = 5;
//                    }
//                    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
//                    
//                    Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguageIDN];
//                    [languageManager setLanguageWithLocale:localeForRow];
                    
                    LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
                    [self presentViewController:LandingView animated:YES completion:nil];

                }
                                                 

                
                // [ProgressHUD showSuccess:@""];
               
                

            }
        }
        SaveButton.enabled = YES;
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
        [LoadingBlackBackground removeFromSuperview];
        [ShowLoadingText removeFromSuperview];
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"User Logout return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //   NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
        [LoadingBlackBackground removeFromSuperview];
        [ShowLoadingText removeFromSuperview];
        if ([statusString isEqualToString:@"ok"]) {
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
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSLog(@"language is %@",language);
            // zh-Hans - Simplified Chinese
            // zh-Hant - Traditional Chinese
            // en - English
            // th - Thai
            // id - Bahasa Indonesia
            NSInteger CheckSystemLanguage_;
            if ([language isEqualToString:@"en"]) {
                CheckSystemLanguage_ = 0;
            }else if([language isEqualToString:@"zh-Hans"]){
                CheckSystemLanguage_ = 1;
            }else if([language isEqualToString:@"zh-Hant"]){
                CheckSystemLanguage_ = 2;
            }else if([language isEqualToString:@"id"]){
                CheckSystemLanguage_ = 3;
            }else if([language isEqualToString:@"th"]){
                CheckSystemLanguage_ = 4;
            }else if([language isEqualToString:@"tl-PH"]){
                CheckSystemLanguage_ = 5;
            }
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage_];
            [languageManager setLanguageWithLocale:localeForRow];
            
            //save back
            [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
            [defaults setObject:GetBackAPIVersion forKey:@"APIVersionSet"];
            [defaults synchronize];
            
            
            LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }
        
        

    }
   
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)DeleteAccountButton:(id)sender{
    
    UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"• Your profile will disappear from Seeties. \n\n• Other user cannot search for you, your comments will remain visible \n\n• You can reactivate this account in future." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Deactivate", nil];
    [ShowAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        NSLog(@"Cancel");
    }else{
        //reset clicked
       // [self SendLoginDataToServer];
        [self SendUserLogoutToServer];
    }
}
-(void)SendUserLogoutToServer{
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
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.UserLogout_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_UserDeleteAccount = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_UserDeleteAccount start];
    
    
    if( theConnection_UserDeleteAccount ){
        webData = [NSMutableData data];
    }
    
}


@end

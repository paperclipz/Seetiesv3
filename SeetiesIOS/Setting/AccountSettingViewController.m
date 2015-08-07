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
    [MainScroll setContentSize:CGSizeMake(screenWidth, screenHeight)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    EditBackImg.frame = CGRectMake(0, 85, screenWidth, 462);
    
    Emailfield.frame = CGRectMake(screenWidth - 216 - 15, 92, 216, 30);
    ShowPrimary.frame = CGRectMake(screenWidth - 107 - 30, 186, 107, 21);
    ShowSecondary.frame = CGRectMake(screenWidth - 107 - 30, 230, 107, 21);
    ShowSystemlanguage.frame = CGRectMake(screenWidth - 107 - 30, 289, 107, 21);
    ShowGender.frame = CGRectMake(screenWidth - 107 - 30, 411, 107, 21);
    ShowBirthday.frame = CGRectMake(screenWidth - 107 - 30, 453, 107, 21);

    DeleteButton.frame = CGRectMake(0, 503, screenWidth, 44);
    
    DataUrl = [[UrlDataClass alloc]init];
    
    GenderArray = [[NSMutableArray alloc]init];
    [GenderArray addObject:CustomLocalisedString(@"Male",nil)];
    [GenderArray addObject:CustomLocalisedString(@"Female",nil)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetEmail = [defaults objectForKey:@"UserData_Email"];
    GetGender = [defaults objectForKey:@"UserData_Gender"];
    if ([GetGender isEqualToString:@"m"]) {
        ShowGender.text = CustomLocalisedString(@"Male",nil);
        GetGender = CustomLocalisedString(@"Male", nil);
    }else{
        ShowGender.text = CustomLocalisedString(@"Female",nil);
        GetGender = CustomLocalisedString(@"Female", nil);
    }
    Getdob = [defaults objectForKey:@"UserData_dob"];
    GetSystemLanguage = [defaults objectForKey:@"UserData_SystemLanguage"];
    GetLanguage1 = [defaults objectForKey:@"UserData_Language1"];
    GetLanguage2 = [defaults objectForKey:@"UserData_Language2"];
    
    if ([GetLanguage1 isEqualToString:@"简体中文"] || [GetLanguage1 isEqualToString:@"繁體中文"]) {
        GetLanguage1 = @"中文";
    }
    if ([GetLanguage2 isEqualToString:@"简体中文"] || [GetLanguage2 isEqualToString:@"繁體中文"]) {
        GetLanguage2 = @"中文";
    }
    
    
    Emailfield.delegate = self;
    Emailfield.text = GetEmail;
   // ShowEmail.text = GetEmail;
    ShowBirthday.text = Getdob;
    
    ShowSystemlanguage.text = GetSystemLanguage;
    ShowPrimary.text = GetLanguage1;
    if ([GetLanguage2 isEqualToString:@""]) {
        ShowSecondary.text = @"(Choose one)";
    }else{
        ShowSecondary.text = GetLanguage2;
    }
    
    
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
    Checkdob = 0;
    CheckGender = 0;
    
    
    ShowTitle.text = CustomLocalisedString(@"SettingsPage_AccountSettings",nil);
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];
    EmailText.text = CustomLocalisedString(@"SignUpPage_Email", nil);
    PrimaryText.text = CustomLocalisedString(@"Primary", nil);
    SecondaryText.text = CustomLocalisedString(@"Secondary", nil);
    GenderText.text = CustomLocalisedString(@"Gender", nil);
    BirthdayText.text = CustomLocalisedString(@"Birthday", nil);
    AppLanguageText.text = CustomLocalisedString(@"AppLangauge", nil);
    ChangePasswordText.text = CustomLocalisedString(@"ChangePassword", nil);
    [DeleteButton setTitle:CustomLocalisedString(@"Deactivateaccount",nil) forState:UIControlStateNormal];
    ShowSubTitle.text = CustomLocalisedString(@"ContentLanguage", nil);
    
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
    if (pickerView.tag == 100) {
        return [GenderArray count];
    }else if(pickerView.tag == 3){
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
    if (pickerView.tag == 100) {
        ShowGender.text = [GenderArray objectAtIndex:row];
      //  GetGender = [GenderArray objectAtIndex:row];
    }else if(pickerView.tag == 1){
        ShowPrimary.text = [LanguageArray objectAtIndex:row];
        GetLanguage1_ID = [LanguageIDArray objectAtIndex:row];
    }else if(pickerView.tag == 2){
        ShowSecondary.text = [Language2Array objectAtIndex:row];
        GetLanguage2_ID = [LanguageID2Array objectAtIndex:row];
    }else{
        ShowSystemlanguage.text = [SystemLanguageNameArray objectAtIndex:row];
        GetSystemLanguage_ID = [SystemLanguageIDArray objectAtIndex:row];
    }
    
    
//    if (CheckSelectLang == 1) {
//        GetSelectLang01 = [LanguageIDArray objectAtIndex:row];
//        ShowSelectLang01.text = [LanguageArray objectAtIndex:row];
//    }else{
//        GetSelectLang02 = [LanguageIDArray objectAtIndex:row];
//        ShowSelectLang02.text = [LanguageArray objectAtIndex:row];
//    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
         return [GenderArray objectAtIndex:row];
    }else if(pickerView.tag == 3){
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
    Birthday_Picker.hidden = YES;
   // CheckSelectLang = 0;
    
}
-(IBAction)SelectPrimaryButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
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
    Birthday_Picker.hidden = YES;
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
    Birthday_Picker.hidden = YES;
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
-(IBAction)GenderButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
    [Emailfield resignFirstResponder];
    
    
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Language_PickerView.tag = 100;
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
-(IBAction)BirthdayButton:(id)sender{
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
    [Emailfield resignFirstResponder];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Birthday_Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Birthday_Picker.tag = 100;
    [self.view addSubview:Birthday_Picker];
   // Birthday_Picker.delegate = self;
    Birthday_Picker.datePickerMode = UIDatePickerModeDate;
    NSLog(@"ShowBirthday.text is %@",ShowBirthday.text);
    if ([ShowBirthday.text length] == 0 || [ShowBirthday.text isEqualToString:@"0000-00-00"]) {
        Birthday_Picker.date = [NSDate date];
    }else{
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormat dateFromString:ShowBirthday.text];
        [Birthday_Picker setDate:date];
    }
    
    [Birthday_Picker addTarget:self   action:@selector(GetBirthdayChange)forControlEvents:UIControlEventValueChanged];
    Birthday_Picker.backgroundColor = [UIColor whiteColor];
   //Birthday_Picker.showsSelectionIndicator = YES;
    
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
    Birthday_Picker.hidden = YES;
    
    ChangePasswordViewController *ChangePasswordView = [[ChangePasswordViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ChangePasswordView animated:NO completion:nil];
}
-(void)GetBirthdayChange{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormat stringFromDate:Birthday_Picker.date];
    NSLog(@"date is >>> , %@",date);
    ShowBirthday.text = date;
}

-(IBAction)SaveButton:(id)sender{

    if ([ShowBirthday.text isEqualToString:Getdob]) {
        Checkdob = 0;
       // NSLog(@"1");
    }else{
        Checkdob = 1;
      //  NSLog(@"2");
    }
    if ([ShowGender.text isEqualToString:GetGender]) {
        CheckGender = 0;
    }else{
        CheckGender = 1;
    }
    NSLog(@"CheckGender is %i",CheckGender);
    NSLog(@"GetGender is %@",GetGender);
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
    if ([ShowSecondary.text isEqualToString:GetLanguage2] || [ShowSecondary.text isEqualToString:@"(Choose one)"] || [ShowSecondary.text isEqualToString:@"None"]) {
        CheckLanguage2 = 0;
    }else{
        CheckLanguage2 = 1;
    }
    NSLog(@"ShowSecondary.text is %@",ShowSecondary.text);
    NSLog(@"GetLanguage2 is %@",GetLanguage2);
    if ([Emailfield.text length] == 0) {
        
    }else{
        BOOL eb=[self validateEmail:Emailfield.text];
        
        if(!eb)
        {
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct email id"
                                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertsuccess show];

        }else{
            SaveButton.enabled = NO;
        [self updateUserInformation];
        }
    
    }
    
    
}
-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
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
    
    if (Checkdob == 1) {
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dob\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",ShowBirthday.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (CheckGender == 1) {
        NSString *TempGender;
        if ([ShowGender.text isEqualToString:CustomLocalisedString(@"Male",nil)]) {
            TempGender = @"m";
        }else{
            TempGender = @"f";
        }
        
        
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",TempGender] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
                
                NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]init];
                NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                NSDictionary *NSDictionaryLanguage = [res valueForKey:@"languages"];
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
                if ([TempArray count] == 1) {
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                }else{
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                }
                
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
                    
                    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    
                    UITabBarController *tabBarController=[[UITabBarController alloc]init];
                    tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                    //  [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
                    //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
                    // UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
                    //   [[UITabBar appearance] setShadowImage:tabBarBackground];
                    //   [[UITabBar appearance] setBackgroundImage:tabBarBackground];
                   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
                    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
                    
                    FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
                    Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
                    
                    SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
                    
                    NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];

                    ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
                    
                    //adding view controllers to your tabBarController bundling them in an array
                    tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
                    
                    
                    //[self presentModalViewController:tabBarController animated:YES];
                    // [self presentViewController:tabBarController animated:NO completion:nil];
                    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
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
    Birthday_Picker.hidden = YES;
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

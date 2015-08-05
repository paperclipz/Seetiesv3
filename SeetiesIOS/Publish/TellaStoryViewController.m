//
//  TellaStoryViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/19/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "TellaStoryViewController.h"
#import "AddPriceViewController.h"
#import "AddContactViewController.h"
#import "AddLinkViewController.h"


#import "LanguageManager.h"
#import "Locale.h"


//#import "MainViewController.h"
#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "SelectImageViewController.h"

#import "FeedV2ViewController.h"
@interface TellaStoryViewController ()

@end

@implementation TellaStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    ShowTitle.text = CustomLocalisedString(@"TellStory", nil);
    [SaveDraftButton setTitle:CustomLocalisedString(@"SaveasDraft", nil) forState:UIControlStateNormal];
    [SkipAndDoneButton setTitle:CustomLocalisedString(@"SkipAndDone", nil) forState:UIControlStateNormal];
    
    [PublishButton setTitle:CustomLocalisedString(@"Publish", nil) forState:UIControlStateNormal];
    [CancelButton setTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) forState:UIControlStateNormal];
    [MiniTagButton setTitle:CustomLocalisedString(@"Addtag", nil) forState:UIControlStateNormal];
    
    ShowMiniTitle.text = CustomLocalisedString(@"ChooseCategories", nil);
    ShowCategoryTitle.text = CustomLocalisedString(@"youcanchoose2", nil);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetUserLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language1"]];
    GetUserLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language2"]];
    NSLog(@"GetUserLanguage_1 is %@",GetUserLanguage_1);
    NSLog(@"GetUserLanguage_2 is %@",GetUserLanguage_2);
    
    TitleField.delegate = self;
    ExperienceTextView.delegate = self;
    // ExperienceTextView.text = @"Tell us your experience...";
    ExperienceTextView.textColor = [UIColor grayColor];
    ExperienceTextView.tag = 100;
    
    if ([GetUserLanguage_1 isEqualToString:@"English"]) {
        TitleField.placeholder = @"Write a title...";
        ExperienceTextView.text = @"How was your experience?";
    }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
        TitleField.placeholder = @"标题...";
        ExperienceTextView.text = @"说明 & 经验";
    }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
        TitleField.placeholder = @"Tulis Judul...";
        ExperienceTextView.text = @"Deskripsi dan pengalaman";
    }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
        TitleField.placeholder = @"Magsulat ng pamagat...";
        ExperienceTextView.text = @"Pagsasalarawan at mga karanasan";
    }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
        TitleField.placeholder = @"เขียนชื่อเรื่อง...";
        ExperienceTextView.text = @"รีวิว";
    }else{
        TitleField.placeholder = @"Write a title...";
        ExperienceTextView.text = @"How was your experience?";
    }
    NSLog(@"TitleField is %@",TitleField);
    NSLog(@"ExperienceTextView is %@",ExperienceTextView);
    ChineseExperienceTextView.delegate = self;
    //ChineseExperienceTextView.text = @"Tell us your experience...";
    ChineseExperienceTextView.textColor = [UIColor grayColor];
    ChineseExperienceTextView.tag = 200;
    
    if ([GetUserLanguage_2 isEqualToString:@"English"]) {
        ChineseTextField.placeholder = @"Write a title...";
        ChineseExperienceTextView.text = @"How was your experience?";
    }else if([GetUserLanguage_2 isEqualToString:@"中文"] || [GetUserLanguage_2 isEqualToString:@"简体中文"] || [GetUserLanguage_2 isEqualToString:@"繁體中文"]){
        ChineseTextField.placeholder = @"标题...";
        ChineseExperienceTextView.text = @"说明 & 经验";
    }else if([GetUserLanguage_2 isEqualToString:@"Bahasa Indonesia"]){
        ChineseTextField.placeholder = @"Tulis Judul...";
        ChineseExperienceTextView.text = @"Deskripsi dan pengalaman";
    }else if([GetUserLanguage_2 isEqualToString:@"Filipino"]){
        ChineseTextField.placeholder = @"Magsulat ng pamagat...";
        ChineseExperienceTextView.text = @"Pagsasalarawan at mga karanasan";
    }else if([GetUserLanguage_2 isEqualToString:@"ภาษาไทย"]){
        ChineseTextField.placeholder = @"เขียนชื่อเรื่อง...";
        ChineseExperienceTextView.text = @"รีวิว";
    }else{
        ChineseTextField.placeholder = @"Write a title...";
        ChineseExperienceTextView.text = @"How was your experience?";
    }
    
//    TitleArray = [[NSMutableArray alloc]init];
//    MessageArray = [[NSMutableArray alloc]init];
    
    SkipAndDoneButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, 320, 60);


    ButtonScroll.delegate = self;
    MainScroll.delegate = self;
    ButtonScroll.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 130, 320, 70);
    MainScroll.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 60);
    [MainScroll setContentSize:CGSizeMake(320, 458)];
    

    
    ChineseView.hidden = YES;
    OtherInformationView.hidden = YES;
    
    PublishView.hidden = YES;
    PublishView.frame = CGRectMake(0, 600, 320, [UIScreen mainScreen].bounds.size.height);
    SelectCategoryScrollView.frame = CGRectMake(10, 200, 300, [UIScreen mainScreen].bounds.size.height - 260);
    PublishButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, 320, 60);
    [self.view addSubview:PublishView];
    
    SelectCategoryScrollView.delegate = self;
    [SelectCategoryScrollView setContentSize:CGSizeMake(300, 650)];
    
    CategorySelectIDArray = [[NSMutableArray alloc]init];
//    
//    tagField.tagDelegate  = self;
//    tagField.delegate = self;
//    tagField.backgroundColor = [UIColor clearColor];
    
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetCategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
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
        ShowImageButton.frame = CGRectMake(37+(i % 2)*150, 49 + (114 * (CGFloat)(i /2)), 75, 75);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        sscanf([[GetBackgroundArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = 37.5; // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [SelectCategoryScrollView addSubview:ShowImageButton];
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(0 +(i % 2)*150, 132 + (115 * (CGFloat)(i /2)), 150, 21);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [SelectCategoryScrollView addSubview:ShowTitle_];
        
        [SelectCategoryScrollView setContentSize:CGSizeMake(300, 200 + (115 * (CGFloat)(i /2)))];
    }
    

}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID{
    GetUpdatePost = UpdatePost;
    GetPostID = PostID;
    NSLog(@"GetUpdatePost is %@",GetUpdatePost);
    NSLog(@"GetPostID is %@",GetPostID);
//    if ([GetUpdatePost length] == 0) {
//        GetUpdatePost = @"no";
//    }
}
-(IBAction)ShowImageButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        if ([CategorySelectIDArray count] >= 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limit Exceed" message:@"You cannot select more than 2 Category." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            buttonWithTag1.selected = NO;
        }else{
            NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
            [CategorySelectIDArray addObject:TempIDN];
        }
        
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SelectButtonArray = [[NSMutableArray alloc]init];
    SelectButtonDataArray = [[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    NSLog(@"LanguageID_Array is %@",LanguageID_Array);
    NSLog(@"LanguageName_Array is %@",LanguageName_Array);
    
    NSString *GetUserLanguage_1_ = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language1"]];
    NSString *GetUserLanguage_2_ = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language2"]];
    
    NSLog(@"GetUserLanguage_1_ is %@",GetUserLanguage_1_);
    NSLog(@"GetUserLanguage_2_ is %@",GetUserLanguage_2_);
    
    if ([GetUserLanguage_1_ isEqualToString:@"简体中文"] || [GetUserLanguage_1_ isEqualToString:@"繁體中文"]) {
        GetUserLanguage_1_ = @"中文";
    }
    
    if ([GetUserLanguage_2_ isEqualToString:@"简体中文"] || [GetUserLanguage_2_ isEqualToString:@"繁體中文"]) {
        GetUserLanguage_2_ = @"中文";
    }
    
    LangIDArray = [[NSMutableArray alloc]init];
    LangArray = [[NSMutableArray alloc]init];
    TitleArray = [[NSMutableArray alloc]init];
    MessageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [LanguageName_Array count]; i++) {
        
        NSString *GetTempLang = [[NSString alloc]initWithFormat:@"%@",[LanguageName_Array objectAtIndex:i]];
        NSString *GetTempLangID = [[NSString alloc]initWithFormat:@"%@",[LanguageID_Array objectAtIndex:i]];
        
        if ([GetTempLang isEqualToString:@"简体中文"] || [GetTempLang isEqualToString:@"繁體中文"] || [GetTempLang isEqualToString:@"中文"]) {
            GetTempLang = @"中文";
        }
        
        if ([GetUserLanguage_1 isEqualToString:GetTempLang]) {
            [LangArray addObject:GetTempLang];
            [LangIDArray addObject:GetTempLangID];
            [TitleArray addObject:@""];
            [MessageArray addObject:@""];
        }else{
            
            
        }
    }
    if ([GetUserLanguage_2 length] == 0) {
        
    }else{
        for (int i = 0; i < [LanguageName_Array count]; i++) {
            
            NSString *GetTempLang = [[NSString alloc]initWithFormat:@"%@",[LanguageName_Array objectAtIndex:i]];
            NSString *GetTempLangID = [[NSString alloc]initWithFormat:@"%@",[LanguageID_Array objectAtIndex:i]];
            
            if ([GetTempLang isEqualToString:@"简体中文"] || [GetTempLang isEqualToString:@"繁體中文"] || [GetTempLang isEqualToString:@"中文"]) {
                GetTempLang = @"中文";
            }
            
            if ([GetUserLanguage_2 isEqualToString:GetTempLang]) {
            [LangArray addObject:GetTempLang];
            [LangIDArray addObject:GetTempLangID];
            [TitleArray addObject:@""];
            [MessageArray addObject:@""];
            }else{}
        }
    }
     NSLog(@"LangArray is %@",LangArray);
    NSLog(@"LangIDArray is %@",LangIDArray);
    NSLog(@"TitleArray is %@",TitleArray);
    NSLog(@"MessageArray is %@",MessageArray);
    ButtonNameArray = [[NSMutableArray alloc]init];
    [ButtonNameArray addObject:@"Address"];
  //  [ButtonNameArray addObject:@"Rate"];
    [ButtonNameArray addObject:CustomLocalisedString(@"AddPrice", nil)];
    [ButtonNameArray addObject:CustomLocalisedString(@"Addfb", nil)];
    if ([GetUserLanguage_2 length] == 0) {
        
    }else{
        [ButtonNameArray addObject:GetUserLanguage_2];
    }
    
    [ButtonNameArray addObject:CustomLocalisedString(@"AddLink", nil)];
    //[ButtonNameArray addObject:@"Hour"];
    [ButtonNameArray addObject:CustomLocalisedString(@"AddPhoneNumber", nil)];
    
    NSString *GetTitleData = [defaults objectForKey:@"PublishV2_Title"];
    NSArray *SplitArrayTitle = [GetTitleData componentsSeparatedByString:@","];
    NSString *GetMessage = [defaults objectForKey:@"PublishV2_Message"];
    NSArray *SplitArrayMessage = [GetMessage componentsSeparatedByString:@","];
    
    if ([GetTitleData length] == 0) {
    }else{
        for (int i = 0; i < [SplitArrayTitle count]; i++) {
            switch (i) {
                case 0:
                    TitleField.text = [SplitArrayTitle objectAtIndex:i];
                    ExperienceTextView.text = [SplitArrayMessage objectAtIndex:i];
                    ShowQualityRecommendationView.hidden = YES;
                    break;
                case 1:
                    ChineseTextField.text = [SplitArrayTitle objectAtIndex:i];
                    ChineseExperienceTextView.text = [SplitArrayMessage objectAtIndex:i];
                    break;
                default:
                    break;
            }
        }
        
        if (ExperienceTextView.tag == 100) {
            if([ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height!=ExperienceTextView.frame.size.height)
            {
                ExperienceTextView.frame = CGRectMake(10, 291, 300,[ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
                if (ExperienceTextView.frame.size.height  > 147) {
                    if (ChineseView.hidden == YES) {
                        LineExperience.frame = CGRectMake(0, 311 + [ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                        OtherInformationView.frame = CGRectMake(0, 312 + [ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
                        ButtonScroll.frame = CGRectMake(0, 312 + CheckOtherInformationViewHeight + [ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                        [MainScroll setContentSize:CGSizeMake(320, 382 + CheckOtherInformationViewHeight + [ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
                    }else{
                        LineExperience.frame = CGRectMake(0, 311 + [ExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                        ChineseView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, ChineseView.frame.size.height);
                        if (OtherInformationView.hidden == YES) {
                            CheckOtherInformationViewHeight = 0;
                        }else{
                            OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y +ChineseView.frame.size.height, 320, CheckOtherInformationViewHeight);
                        }
                        
                        ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y  + CheckOtherInformationViewHeight, 320, 70);
                        [MainScroll setContentSize:CGSizeMake(320, 70 + ButtonScroll.frame.origin.y )];
                        //                    OtherInformationView.frame = CGRectMake(0, 312 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
                        //                    ButtonScroll.frame = CGRectMake(0, 312 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                        //                    [MainScroll setContentSize:CGSizeMake(320, 382 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
                    }
                    
                }else{
                    // ButtonScroll.frame = CGRectMake(0, 438, 320, 70);
                }
            }
        }else{
            if([ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height!=ChineseExperienceTextView.frame.size.height)
            {
                
                ChineseExperienceTextView.frame = CGRectMake(10, 57, 300,[ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
                if (ChineseExperienceTextView.frame.size.height  > 80) {
                    //  LineExperience.frame = CGRectMake(0, 311 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                    ChineseView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, 80 + [ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
                    NSLog(@"ChineseView add text is %@",ChineseView);
                    if (OtherInformationView.hidden == YES) {
                        CheckOtherInformationViewHeight = 0;
                    }else{
                        OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + 80 + [ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
                    }
                    
                    ButtonScroll.frame = CGRectMake(0, ChineseView.frame.origin.y + 80 + CheckOtherInformationViewHeight + [ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                    [MainScroll setContentSize:CGSizeMake(320, ChineseView.frame.origin.y + 150 + CheckOtherInformationViewHeight + [ChineseExperienceTextView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
                }else{
                    // ButtonScroll.frame = CGRectMake(0, 438, 320, 70);
                }
            }
        }
    }
    

    
    
    
    
    
    NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
    GetImageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [TempArray count]; i++) {
        
        [GetImageArray addObject:[self decodeBase64ToImage:[TempArray objectAtIndex:i]]];
    }
    
    ShowImageCover.image = [GetImageArray objectAtIndex:0];
    ShowImageCover.frame = CGRectMake(0, 0, 320, 290);
    ShowImageCover.contentMode = UIViewContentModeScaleAspectFill;
    ShowImageCover.layer.masksToBounds = YES;
    //check data
    GetAddress = [defaults objectForKey:@"PublishV2_Address"];
    GetPlaceName = [defaults objectForKey:@"PublishV2_Name"];
    GetPlaceLat = [defaults objectForKey:@"PublishV2_Lat"];
    GetPlaceLng = [defaults objectForKey:@"PublishV2_Lng"];
    GetFBWebsite = [defaults objectForKey:@"PublishV2_Link"];
    GetContactNumber = [defaults objectForKey:@"PublishV2_Contact"];
    GetHour = [defaults objectForKey:@"PublishV2_Hour"];
    GetPriceData = [defaults objectForKey:@"PublishV2_Price"];
    GetPriceNumCodeData = [defaults objectForKey:@"PublishV2_Price_NumCode"];
    GetPriceShowData = [defaults objectForKey:@"PublishV2_Price_Show"];
    GetBlogLinkData = [defaults objectForKey:@"PublishV2_BlogLink"];
    
    TagStringArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringArray"]];
    TagStringDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringDataArray"]];
    
    
    
    NSLog(@"GetAddress is %@",GetAddress);
    if ([GetAddress isEqualToString:@""] || GetAddress == nil || [GetAddress isEqualToString:@"(null)"] || [GetAddress isEqualToString:@"nil"]) {
        
    }else{
        [SelectButtonArray addObject:@"Address"];
        [SelectButtonDataArray addObject:GetAddress];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    NSLog(@"GetPlaceName is %@",GetPlaceName);
    NSLog(@"GetPlaceLat is %@",GetPlaceLat);
    NSLog(@"GetPlaceLng is %@",GetPlaceLng);
    NSLog(@"GetFBWebsite is %@",GetFBWebsite);
    if ([GetFBWebsite isEqualToString:@""] || GetFBWebsite == nil || [GetFBWebsite isEqualToString:@"(null)"] || [GetFBWebsite isEqualToString:@"nil"]) {
        
    }else{
        [SelectButtonArray addObject:CustomLocalisedString(@"Addfb", nil)];
        [SelectButtonDataArray addObject:GetFBWebsite];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    NSLog(@"GetContactNumber is %@",GetContactNumber);
    if ([GetContactNumber isEqualToString:@""] || GetContactNumber == nil || [GetContactNumber isEqualToString:@"(null)"] || [GetContactNumber isEqualToString:@"nil"]) {
        
    }else{
        [SelectButtonArray addObject:CustomLocalisedString(@"AddPhoneNumber", nil)];
        [SelectButtonDataArray addObject:GetContactNumber];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    NSLog(@"GetHour is %@",GetHour);
    if ([GetHour isEqualToString:@""] || GetHour == nil || [GetHour isEqualToString:@"(null)"] || [GetHour isEqualToString:@"nil"] || [GetHour isEqualToString:@"Add Opening Hour"]) {
        
    }else{
        [SelectButtonArray addObject:@"Hour"];
        [SelectButtonDataArray addObject:GetHour];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    if ([GetPriceData isEqualToString:@""] || GetPriceData == nil || [GetPriceData isEqualToString:@"(null)"] || [GetPriceData isEqualToString:@"nil"]) {
        
    }else{
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@",GetPriceShowData,GetPriceData];
        [SelectButtonArray addObject:CustomLocalisedString(@"AddPrice", nil)];
        [SelectButtonDataArray addObject:TempString];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    if ([GetBlogLinkData isEqualToString:@""] || GetBlogLinkData == nil || [GetBlogLinkData isEqualToString:@"(null)"] || [GetBlogLinkData isEqualToString:@"nil"]) {
        
    }else{
        [SelectButtonArray addObject:CustomLocalisedString(@"AddLink", nil)];
        [SelectButtonDataArray addObject:GetBlogLinkData];
        // [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    }
    if ([ChineseExperienceTextView.text length] == 0 || [ChineseExperienceTextView.text isEqualToString:@"How was your experience?"] || [ChineseExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ChineseExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ChineseExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ChineseExperienceTextView.text isEqualToString:@"รีวิว"]) {
        
    }else{
        [SelectButtonArray addObject:GetUserLanguage_2];
        [SelectButtonDataArray addObject:@""];
    }
    
    for (int i = 0; i < [SelectButtonArray count]; i++) {
        NSString *GetData = [SelectButtonArray objectAtIndex:i];
        [ButtonNameArray removeObject:GetData];
    }

    
    
    //    [SelectButtonArray addObject:[ButtonNameArray objectAtIndex:0]];
    //    [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:0]];
    //    [SelectButtonArray addObject:[ButtonNameArray objectAtIndex:2]];
    //    [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:2]];
    [self InitButtonView];
    [self InitAddtionlView];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"Are you sure want Back?" message:@"Tell a story all information will not save." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Draft",@"Back", nil];
    AlertView.tag = 500;
    [AlertView show];
   // [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)InitButtonView{
    for (UIView *subview in ButtonScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    UIButton *LineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LineButton.frame = CGRectMake(15, 0, 1000, 1);
    [LineButton setTitle:@"" forState:UIControlStateNormal];
    [LineButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [ButtonScroll addSubview:LineButton];
    
    for (int i = 0; i < [ButtonNameArray count]; i++) {
        UIButton *ForloopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ForloopButton.frame = CGRectMake(15 + i * 141, 20, 140, 30);
        [ForloopButton setTitle:[ButtonNameArray objectAtIndex:i] forState:UIControlStateNormal];
        [ForloopButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [ForloopButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [ForloopButton setImage:[UIImage imageNamed:@"BtnAddInfo.png"] forState:UIControlStateNormal];
        [ForloopButton setBackgroundColor:[UIColor clearColor]];
        ForloopButton.tag = i;
        [ForloopButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, 0.f)];
        ForloopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [ForloopButton addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [ButtonScroll addSubview:ForloopButton];
        
        [ButtonScroll setContentSize:CGSizeMake(155 + i * 141, 50)];
    }
    

}
-(IBAction)SelectButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    [SelectButtonArray addObject:[ButtonNameArray objectAtIndex:getbuttonIDN]];
    

    NSString *GetButtonName = [[NSString alloc]initWithFormat:@"%@",[ButtonNameArray objectAtIndex:getbuttonIDN]];
    if ([GetButtonName isEqualToString:@"Hour"]) {
        [SelectButtonDataArray addObject:@"Add hour"];
    }
    if ([GetButtonName isEqualToString:@"Rate"]) {
        [SelectButtonDataArray addObject:@"Add Rate"];
    }
    if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddPrice", nil)]) {
        [SelectButtonDataArray addObject:CustomLocalisedString(@"AddPrice", nil)];
    }
    if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddLink", nil)]) {
        [SelectButtonDataArray addObject:CustomLocalisedString(@"AddLink", nil)];
    }
    if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddPhoneNumber", nil)]) {
        [SelectButtonDataArray addObject:CustomLocalisedString(@"AddPhoneNumber", nil)];
    }
    if ([GetButtonName isEqualToString:CustomLocalisedString(@"Addfb", nil)]) {
        [SelectButtonDataArray addObject:CustomLocalisedString(@"Addfb", nil)];
    }
    
    
    [ButtonNameArray removeObject:[ButtonNameArray objectAtIndex:getbuttonIDN]];
    [self InitButtonView];
    [self InitAddtionlView];
    
}


-(void)InitAddtionlView{
    for (UIView *subview in OtherInformationView.subviews) {
        [subview removeFromSuperview];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUserLanguage_2_ = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language2"]];
    NSLog(@"GetUserLanguage_2 2222222 is %@",GetUserLanguage_2);
    if ([GetUserLanguage_2_ isEqualToString:@"简体中文"] || [GetUserLanguage_2_ isEqualToString:@"繁體中文"]) {
        GetUserLanguage_2_ = @"中文";
    }
    for (int i = 0; i < [SelectButtonArray count]; i++) {
        
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[SelectButtonArray objectAtIndex:i]];
        NSLog(@"1111  TempString is %@",TempString);
        if ([TempString isEqualToString:GetUserLanguage_2]) {

            [SelectButtonArray removeObjectAtIndex:i];
            ChineseView.hidden = NO;
            ChineseView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, 151);
            if (OtherInformationView.hidden == YES) {
               // OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + ChineseView.frame.size.height, 320, 70 + i * 35);
               // ButtonScroll.frame = CGRectMake(0, ChineseView.frame.origin.y + ChineseView.frame.size.height, 320, 50);
                [MainScroll setContentSize:CGSizeMake(320, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height)];
                
                CheckOtherInformationViewHeight = 0;
            }else{
                OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + ChineseView.frame.size.height, 320, 70 + i * 35);
              //  ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height, 320, 50);
                [MainScroll setContentSize:CGSizeMake(320, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height + 140)];
                
                CheckOtherInformationViewHeight = OtherInformationView.frame.size.height;
            }

            
            

        }else{
            OtherInformationView.hidden = NO;
            UIImageView *IconImage = [[UIImageView alloc]init];
            NSString *GetButtonName = [[NSString alloc]initWithFormat:@"%@",[SelectButtonDataArray objectAtIndex:i]];
            
            UILabel *ShowSelectView = [[UILabel alloc]init];
            ShowSelectView.frame = CGRectMake(50, 15 + i * 60, 250, 35);
            ShowSelectView.text = [SelectButtonDataArray objectAtIndex:i];
            ShowSelectView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowSelectView.backgroundColor = [UIColor clearColor];
            ShowSelectView.numberOfLines = 0;
            ShowSelectView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            //  [ShowSelectView sizeToFit];
            [OtherInformationView addSubview:ShowSelectView];
            
            if ([GetButtonName isEqualToString:GetHour]) {
                IconImage.image = [UIImage imageNamed:@"IconHours.png"];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"", nil)]){
                IconImage.image = [UIImage imageNamed:@"IconHours.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            if ([GetButtonName isEqualToString:GetAddress]) {
                IconImage.image = [UIImage imageNamed:@"IconLocation.png"];
                ShowSelectView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"", nil)]){
                IconImage.image = [UIImage imageNamed:@"IconLocation.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@",GetPriceShowData,GetPriceData];
            if ([GetButtonName isEqualToString:TempString]) {
                IconImage.image = [UIImage imageNamed:@"IconPrice.png"];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddPrice", nil)]){
                IconImage.image = [UIImage imageNamed:@"IconPrice.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            if ([GetButtonName isEqualToString:GetBlogLinkData]) {
                IconImage.image = [UIImage imageNamed:@"IconLink.png"];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddLink", nil)]){
            IconImage.image = [UIImage imageNamed:@"IconLink.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            if ([GetButtonName isEqualToString:GetContactNumber]) {
                IconImage.image = [UIImage imageNamed:@"IconPhone.png"];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"AddPhoneNumber", nil)]){
                IconImage.image = [UIImage imageNamed:@"IconPhone.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            if ([GetButtonName isEqualToString:GetFBWebsite]) {
                IconImage.image = [UIImage imageNamed:@"IconLink.png"];
            }else if ([GetButtonName isEqualToString:CustomLocalisedString(@"Addfb", nil)]){
                IconImage.image = [UIImage imageNamed:@"IconLink.png"];
                ShowSelectView.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            }
            IconImage.frame = CGRectMake(15, 20 + i * 60, IconImage.image.size.width, IconImage.image.size.height);
             [OtherInformationView addSubview:IconImage];
            

            
            UIButton *ForloopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            ForloopButton.frame = CGRectMake(50, 15 + i * 60, 250, 35);
            [ForloopButton setTitle:@"" forState:UIControlStateNormal];
            [ForloopButton setBackgroundColor:[UIColor clearColor]];
            ForloopButton.tag = i;
            [ForloopButton addTarget:self action:@selector(ExtrasInfoButton:) forControlEvents:UIControlEventTouchUpInside];
            [OtherInformationView addSubview:ForloopButton];
            
            UIButton *LineButton = [UIButton buttonWithType:UIButtonTypeCustom];
            LineButton.frame = CGRectMake(50, 62 + i * 60, 320, 1);
            [LineButton setTitle:@"" forState:UIControlStateNormal];
            [LineButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
            [OtherInformationView addSubview:LineButton];
            
            if (ChineseView.hidden == YES) {
                if (ExperienceTextView.frame.size.height  > 147) {
                    OtherInformationView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, 70 + i * 60);
                  //  ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height, 320, 50);
                    [MainScroll setContentSize:CGSizeMake(320, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height)];
                }else{
                    OtherInformationView.frame = CGRectMake(0, 439, 320, 70 + i * 60);
                 //   ButtonScroll.frame = CGRectMake(0, 509 + i * 40, 320, 50);
                    [MainScroll setContentSize:CGSizeMake(320, 580 + i * 60)];
                }
                
                CheckOtherInformationViewHeight = 70 + i * 60;
            }else{
                NSLog(@"go in here....");
                NSLog(@"ChineseView is %@",ChineseView);
//                if (ChineseExperienceTextView.frame.size.height > 100) {
//                    OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + ChineseView.frame.size.height, 320, 70 + i * 35);
//                    NSLog(@"1111 OtherInformationView is %@",OtherInformationView);
//                    ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height, 320, 70);
//                    [MainScroll setContentSize:CGSizeMake(320, ButtonScroll.frame.origin.y + ButtonScroll.frame.size.height)];
//                }else{
                    OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + ChineseView.frame.size.height, 320, 70 + i * 60);
                    NSLog(@"OtherInformationView is %@",OtherInformationView);
                 //   ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height, 320, 50);
                    [MainScroll setContentSize:CGSizeMake(320, OtherInformationView.frame.origin.y + OtherInformationView.frame.size.height)];
//                }

                
                CheckOtherInformationViewHeight = OtherInformationView.frame.size.height;
            }
            

        
        }
        

        

        
    }
}
-(IBAction)ExtrasInfoButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[SelectButtonDataArray objectAtIndex:getbuttonIDN]];
    NSLog(@"GetString is %@",GetString);

    
    if ([GetString isEqualToString:CustomLocalisedString(@"AddPrice", nil)]) {
        AddPriceViewController *AddPriceView = [[AddPriceViewController alloc]init];
        [self presentViewController:AddPriceView animated:YES completion:nil];
    }
    if ([GetString isEqualToString:CustomLocalisedString(@"AddLink", nil)]) {
        AddLinkViewController *AddLinkView = [[AddLinkViewController alloc]init];
        [self presentViewController:AddLinkView animated:YES completion:nil];
        [AddLinkView GetWhatLink:@"Blog"];
    }
    if ([GetString isEqualToString:CustomLocalisedString(@"AddPhoneNumber", nil)]) {
        AddContactViewController *AddContactView = [[AddContactViewController alloc]init];
        [self presentViewController:AddContactView animated:YES completion:nil];
    }
    if ([GetString isEqualToString:CustomLocalisedString(@"Addfb", nil)]) {
        AddLinkViewController *AddLinkView = [[AddLinkViewController alloc]init];
        [self presentViewController:AddLinkView animated:YES completion:nil];
        [AddLinkView GetWhatLink:@"FB/Site"];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [TitleField resignFirstResponder];
    [ExperienceTextView resignFirstResponder];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"did begin editing");
    if(textView.tag == 100){
        if ([ExperienceTextView.text isEqualToString:@"How was your experience?"] || [ExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ExperienceTextView.text isEqualToString:@"รีวิว"]) {
            ExperienceTextView.text = @"";
            ShowQualityRecommendationView.hidden = YES;
        }else{
            
        }
        
        ExperienceTextView.textColor = [UIColor blackColor];
    }else{
        if ([ChineseExperienceTextView.text isEqualToString:@"How was your experience?"] || [ChineseExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ChineseExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ChineseExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ChineseExperienceTextView.text isEqualToString:@"รีวิว"]) {
            ChineseExperienceTextView.text = @"";
            ShowQualityRecommendationView.hidden = YES;
        }else{
            
        }
        
        ChineseExperienceTextView.textColor = [UIColor blackColor];
    }

}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 100){
        if ([ExperienceTextView.text length] == 0) {
            if ([GetUserLanguage_1 isEqualToString:@"English"]) {
                ExperienceTextView.text = @"How was your experience?";
            }else if([GetUserLanguage_1 isEqualToString:@"中文"]){
                ExperienceTextView.text = @"说明 & 经验";
            }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
                ExperienceTextView.text = @"Deskripsi dan pengalaman";
            }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
                ExperienceTextView.text = @"Pagsasalarawan at mga karanasan";
            }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
                ExperienceTextView.text = @"รีวิว";
            }else{
                ExperienceTextView.text = @"How was your experience?";
            }
            ExperienceTextView.textColor = [UIColor grayColor];
            ShowQualityRecommendationView.hidden = NO;
        }
    }else{
        if ([ChineseExperienceTextView.text length] == 0) {
            if ([GetUserLanguage_2 isEqualToString:@"English"]) {
                ChineseExperienceTextView.text = @"How was your experience?";
            }else if([GetUserLanguage_2 isEqualToString:@"中文"]){
                ChineseExperienceTextView.text = @"说明 & 经验";
            }else if([GetUserLanguage_2 isEqualToString:@"Bahasa Indonesia"]){
                ChineseExperienceTextView.text = @"Deskripsi dan pengalaman";
            }else if([GetUserLanguage_2 isEqualToString:@"Filipino"]){
                ChineseExperienceTextView.text = @"Pagsasalarawan at mga karanasan";
            }else if([GetUserLanguage_2 isEqualToString:@"ภาษาไทย"]){
                ChineseExperienceTextView.text = @"รีวิว";
            }else{
                ChineseExperienceTextView.text = @"How was your experience?";
            }
            ChineseExperienceTextView.textColor = [UIColor grayColor];
            ShowQualityRecommendationView.hidden = NO;
        }
    }

}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 100) {
        if([textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height!=textView.frame.size.height)
        {
            textView.frame = CGRectMake(10, 291, 300,[textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
            if (textView.frame.size.height  > 147) {
                if (ChineseView.hidden == YES) {
                    LineExperience.frame = CGRectMake(0, 311 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                    OtherInformationView.frame = CGRectMake(0, 312 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
                    ButtonScroll.frame = CGRectMake(0, 312 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                    [MainScroll setContentSize:CGSizeMake(320, 382 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
                }else{
                    LineExperience.frame = CGRectMake(0, 311 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                    ChineseView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, ChineseView.frame.size.height);
                    if (OtherInformationView.hidden == YES) {
                        CheckOtherInformationViewHeight = 0;
                    }else{
                        OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y +ChineseView.frame.size.height, 320, CheckOtherInformationViewHeight);
                    }
                    
                    ButtonScroll.frame = CGRectMake(0, OtherInformationView.frame.origin.y  + CheckOtherInformationViewHeight, 320, 70);
                    [MainScroll setContentSize:CGSizeMake(320, 70 + ButtonScroll.frame.origin.y )];
//                    OtherInformationView.frame = CGRectMake(0, 312 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
//                    ButtonScroll.frame = CGRectMake(0, 312 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
//                    [MainScroll setContentSize:CGSizeMake(320, 382 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
                }

            }else{
                // ButtonScroll.frame = CGRectMake(0, 438, 320, 70);
            }
        }
    }else{
        if([textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height!=textView.frame.size.height)
        {

            textView.frame = CGRectMake(10, 57, 300,[textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
            if (textView.frame.size.height  > 80) {
                //  LineExperience.frame = CGRectMake(0, 311 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 1);
                ChineseView.frame = CGRectMake(0, LineExperience.frame.origin.y + 1, 320, 80 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height);
                NSLog(@"ChineseView add text is %@",ChineseView);
                if (OtherInformationView.hidden == YES) {
                    CheckOtherInformationViewHeight = 0;
                }else{
                OtherInformationView.frame = CGRectMake(0, ChineseView.frame.origin.y + 80 + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, CheckOtherInformationViewHeight);
                }
                
                ButtonScroll.frame = CGRectMake(0, ChineseView.frame.origin.y + 80 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height, 320, 70);
                [MainScroll setContentSize:CGSizeMake(320, ChineseView.frame.origin.y + 150 + CheckOtherInformationViewHeight + [textView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)].height)];
            }else{
                // ButtonScroll.frame = CGRectMake(0, 438, 320, 70);
            }
        }
    }

}
-(IBAction)QualityRecommendationButton:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"A quality recommendation" message:@"Make it rich and exciting, with clear, helpful and interesting information. Share your personal experiences to make your recommendations more interesting and relatable." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(IBAction)DoneButton:(id)sender{
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         PublishView.hidden = NO;
         PublishView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
     }completion:^(BOOL finished){
         
     }];
    
    NSLog(@"TitleField is %@",TitleField.text);
    NSLog(@"ChineseTextField is %@",ChineseTextField.text);
    NSLog(@"ExperienceTextView is %@",ExperienceTextView.text);
    NSLog(@"ChineseExperienceTextView is %@",ChineseExperienceTextView.text);
    
    
    
//    tagField.tags = TagStringArray;
    
}
-(IBAction)CancelButton:(id)sender{
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         
         PublishView.frame = CGRectMake(0, 600, 320, [UIScreen mainScreen].bounds.size.height);
     }completion:^(BOOL finished){
         PublishView.hidden = YES;
     }];
}
-(IBAction)PublishButton:(id)sender{
    NSLog(@"Publich Button Click");
    
    NSLog(@"TitleArray is %@",TitleArray);
    NSLog(@"MessageArray is %@",MessageArray);
    
    StatusString = @"1";
    if ([CategorySelectIDArray count] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Must select category" delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        TagString = [TagStringDataArray componentsJoinedByString:@","];
        if ([TagString length] == 0) {
            TagString = @"";
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SendCaptionDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionDataArray"]];
        
        NSString *GetAddress_ = [defaults objectForKey:@"PublishV2_Location_Address"];
        NSString *GetCity_ = [defaults objectForKey:@"PublishV2_Location_City"];
        NSString *GetCountry_ = [defaults objectForKey:@"PublishV2_Location_Country"];
        NSString *GetState_ = [defaults objectForKey:@"PublishV2_Location_State"];
        NSString *GetpostalCode_ = [defaults objectForKey:@"PublishV2_Location_PostalCode"];
        NSString *GetreferralId_ = [defaults objectForKey:@"PublishV2_Location_ReferralId"];
        NSString *GetAddressData_ = [defaults objectForKey:@"PublishV2_Address"];
        NSString *GetNameData_ = [defaults objectForKey:@"PublishV2_Name"];
        NSString *GetLatData_ = [defaults objectForKey:@"PublishV2_Lat"];
        NSString *GetLngData_ = [defaults objectForKey:@"PublishV2_Lng"];
        NSString *GetContactData_ = [defaults objectForKey:@"PublishV2_Contact"];
        NSString *GetLinkData_ = [defaults objectForKey:@"PublishV2_Link"];
        NSString *GetTypeData_ = [defaults objectForKey:@"PublishV2_type"];
        NSString *GetPriceData_ = [defaults objectForKey:@"PublishV2_Price"];
        NSString *GetPriceNumCodeData_ = [defaults objectForKey:@"PublishV2_Price_NumCode"];
        NSString *GetSource_ = [defaults objectForKey:@"PublishV2_Source"];
        NSString *GetPeriod_ = [defaults objectForKey:@"PublishV2_Period"];
        NSString *GetOpenNow_ = [defaults objectForKey:@"PublishV2_OpenNow"];
        GetBlogString = [defaults objectForKey:@"PublishV2_BlogLink"];
        if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
            GetBlogString = @"";
        }
        if ([GetPriceData_ isEqualToString:@""] || GetPriceData_ == nil || [GetPriceData_ isEqualToString:@"(null)"] || [GetPriceData_ isEqualToString:@"nil"]) {
            GetPriceData_ = @"";
        }
        if ([GetPriceNumCodeData_ isEqualToString:@""] || GetPriceNumCodeData_ == nil || [GetPriceNumCodeData_ isEqualToString:@"(null)"] || [GetPriceNumCodeData_ isEqualToString:@"nil"]) {
            GetPriceNumCodeData_ = @"";
        }
        if ([GetLinkData_ isEqualToString:@""] || GetLinkData_ == nil || [GetLinkData_ isEqualToString:@"(null)"] || [GetLinkData_ isEqualToString:@"nil"]) {
            GetLinkData_ = @"";
        }
        if ([GetContactData_ isEqualToString:@""] || GetContactData_ == nil || [GetContactData_ isEqualToString:@"(null)"] || [GetContactData_ isEqualToString:@"nil"]) {
            GetContactData_ = @"";
        }
        if ([GetSource_ isEqualToString:@""] || GetSource_ == nil || [GetSource_ isEqualToString:@"(null)"] || [GetSource_ isEqualToString:@"nil"]) {
            GetSource_ = @"";
        }else{
        }
        if ([GetPeriod_ isEqualToString:@""] || GetPeriod_ == nil || [GetPeriod_ isEqualToString:@"(null)"] || [GetPeriod_ isEqualToString:@"nil"]) {
            GetPeriod_ = @"";
        }else{
        }
        if ([GetOpenNow_ isEqualToString:@""] || GetOpenNow_ == nil || [GetOpenNow_ isEqualToString:@"(null)"] || [GetOpenNow_ isEqualToString:@"nil"]) {
            GetOpenNow_ = @"false";
        }else{
            GetOpenNow_ = @"true";
        }
        //location json
        //type 1 == foursqure
        if ([GetTypeData_ isEqualToString:@"1"]) {
            if ([GetPriceNumCodeData_ isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetLinkData_,GetContactData_];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetPriceNumCodeData_,GetPriceData_,GetLinkData_,GetContactData_];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }

        }else{
            //        NSString *TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@]},\"weekday_text\":\"Monday: 8:00 am - 12:00 am\",\"Tuesday: 8:00 am - 12:00 am\",\"Wednesday: 8:00 am - 12:00 am\",\"Thursday: 8:00 am - 12:00 am\",\"Friday: 8:00 am - 12:00 am\",\"Saturday: 9:00 am - 12:00 am\",\"Sunday: 9:00 am - 12:00 am\"}",GetOpenNow,GetPeriod];
            NSString *TempString;
            if ([GetUpdatePost isEqualToString:@"YES"]) {
                NSString *GetSource = [defaults objectForKey:@"PublishV2_Source"];
                if ([GetSource isEqualToString:@""] || GetSource == nil || [GetSource isEqualToString:@"(null)"] || [GetSource isEqualToString:@"nil"]) {
                    TempString = @"\"\"";
                }else{
                    TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow_,GetPeriod_,GetSource_];
                }
                
            }else{
                TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow_,GetPeriod_,GetSource_];
            }
            
            if ([GetPriceNumCodeData_ isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetLinkData_,GetContactData_,TempString,GetOpenNow_,GetPeriod_];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{

                
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetPriceNumCodeData_,GetPriceData_,GetLinkData_,GetContactData_,TempString,GetOpenNow_,GetPeriod_];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }
            

        }
        
        if ([ExperienceTextView.text isEqualToString:@"How was your experience?"] || [ExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ExperienceTextView.text isEqualToString:@"รีวิว"]) {
            ExperienceTextView.text = @"";
        }
        if ([ChineseExperienceTextView.text isEqualToString:@"How was your experience?"] || [ChineseExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ChineseExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ChineseExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ChineseExperienceTextView.text isEqualToString:@"รีวิว"]) {
            ChineseExperienceTextView.text = @"";
        }
        
        if ([TitleArray count] > 1) {
            [TitleArray replaceObjectAtIndex:0 withObject:TitleField.text];
            [TitleArray replaceObjectAtIndex:1 withObject:ChineseTextField.text];
            
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            [MessageArray replaceObjectAtIndex:1 withObject:ChineseExperienceTextView.text];
            
            NSString *GetTempString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:1]];
            if ([GetTempString isEqualToString:@""] || GetTempString == nil || [GetTempString isEqualToString:@"(null)"] || [GetTempString isEqualToString:@"nil"]) {
                [TitleArray removeLastObject];
                [LangIDArray removeLastObject];
                [MessageArray removeLastObject];
            }
        }else{
            [TitleArray replaceObjectAtIndex:0 withObject:TitleField.text];
            
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
        }
        

        
        
        NSLog(@"TitleArray is %@",TitleArray);
        NSLog(@"MessageArray is %@",MessageArray);
        NSLog(@"StatusString is %@",StatusString);
        NSLog(@"TagString is %@",TagString);
        NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
        NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
//        NSLog(@"GetImageArray count is %lu",(unsigned long)[GetImageArray count]);
        
        [self SendDataToServer];
    }
    
    
}
-(void)SendDataToServer{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.lineWidth = 1.0f;
    [self.view addSubview:spinnerView];
    [spinnerView startAnimating];
    
    
    if ([GetUpdatePost isEqualToString:@"YES"]) {
        NSLog(@"YES");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        // NSString *GetplaceNameData = [defaults objectForKey:@"PublishV2_Name"];
        
        //Server Address URL
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",DataUrl.Publish_PostUrl,GetPostID];
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
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_first" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterFirst )
        [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",StatusString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        for (int i = 0; i < [LangIDArray count]; i++) {
            NSString *CheckTItleString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
            if ([CheckTItleString isEqualToString:@""] || CheckTItleString == nil || [CheckTItleString isEqualToString:@"(null)"] || [CheckTItleString isEqualToString:@"nil"]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[%@]\"\r\n\r\n",[LangIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[TitleArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            NSString *CheckMessageString = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
            if ([CheckMessageString isEqualToString:@""] || CheckMessageString == nil || [CheckMessageString isEqualToString:@"(null)"] || [CheckMessageString isEqualToString:@"nil"]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[%@]\"\r\n\r\n",[LangIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[MessageArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
        }
        
        
        
        if ([CategorySelectIDArray count] == 0) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            for (int i = 0; i < [CategorySelectIDArray count]; i++) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[CategorySelectIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",CreateLocationJsonString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    //Attaching the key name @"parameter_second" to the post body
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"place_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //    //Attaching the content to be posted ( ParameterSecond )
        //    [body appendData:[[NSString stringWithFormat:@"%@",GetplaceNameData] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
            GetBlogString = @"";
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetBlogString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        if ([TagString length] == 0) {
            
        }else{
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",TagString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSString *GetPhotoCount = [defaults objectForKey:@"PublishV2_PhotoCount"];
        NSString *GetPhotoID = [defaults objectForKey:@"PublishV2_PhotoID"];
        NSArray *SplitArray = [GetPhotoID componentsSeparatedByString:@","];
        
        
        int PhotoCountData = [GetPhotoCount intValue];
        if ([GetImageArray count] == PhotoCountData) {
            for (int i = 0; i < PhotoCountData; i++) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //        [body appendData:[@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"Image%i.jpg\"\r\n",i,[i ] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"\"\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][position]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%i",i+1] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *TempGetData = [[NSString alloc]initWithFormat:@"%@",[SendCaptionDataArray objectAtIndex:i]];
                if ([TempGetData isEqualToString:@"Add captions & tag this photo..."]) {
                    TempGetData = @"";
                }else{
                    
                }
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][caption]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",TempGetData] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][photo_id]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[SplitArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            //close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
            
            //setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            NSURLConnection *theConnection_Post = [[NSURLConnection alloc]initWithRequest:request delegate:self];
            if(theConnection_Post) {
                // NSLog(@"Connection Successful");
                webData = [NSMutableData data];
            } else {
                
            }
        }
    }else{
        NSLog(@"NO");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        // NSString *GetplaceNameData = [defaults objectForKey:@"PublishV2_Name"];
        
        //Server Address URL
        NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.Publish_PostUrl];
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
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_first" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterFirst )
        [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",StatusString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        for (int i = 0; i < [LangIDArray count]; i++) {
            NSString *CheckTItleString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
            if ([CheckTItleString isEqualToString:@""] || CheckTItleString == nil || [CheckTItleString isEqualToString:@"(null)"] || [CheckTItleString isEqualToString:@"nil"]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[%@]\"\r\n\r\n",[LangIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[TitleArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            NSString *CheckMessageString = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
            if ([CheckMessageString isEqualToString:@""] || CheckMessageString == nil || [CheckMessageString isEqualToString:@"(null)"] || [CheckMessageString isEqualToString:@"nil"]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[%@]\"\r\n\r\n",[LangIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[MessageArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            
        }
        
        
        
        if ([CategorySelectIDArray count] == 0) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            for (int i = 0; i < [CategorySelectIDArray count]; i++) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%@",[CategorySelectIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",CreateLocationJsonString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
            GetBlogString = @"";
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetBlogString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        if ([TagString length] == 0) {
            
        }else{
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",TagString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        
        for (int i = 0; i < [GetImageArray count]; i++) {
            UIImage *GetImage = [GetImageArray objectAtIndex:i];
            NSData *imageData = UIImagePNGRepresentation(GetImage);
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //        [body appendData:[@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"Image%i.jpg\"\r\n",i,[i ] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"Image%i.jpg\"\r\n",i,i] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            // add it to body
            [body appendData:imageData];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][position]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%i",i+1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *TempGetData = [[NSString alloc]initWithFormat:@"%@",[SendCaptionDataArray objectAtIndex:i]];
            if ([TempGetData isEqualToString:@"Add captions & tag this photo..."]) {
                TempGetData = @"";
            }else{
                
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][caption]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",TempGetData] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
        
        //setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        NSURLConnection *theConnection_Post = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(theConnection_Post) {
            // NSLog(@"Connection Successful");
            webData = [NSMutableData data];
        } else {
            
        }
        
        
        

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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Post Data return is ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Create Post Json = %@",res);
    
    
    
    NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    NSLog(@"ErrorString is %@",ErrorString);
    NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"MessageString is %@",MessageString);
    
    if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        ShowAlertView.tag = 300;
        [ShowAlertView show];
    }else{
        
        NSString *TempStatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"TempStatusString is %@",TempStatusString);
        
        if ([TempStatusString isEqualToString:@"ok"]) {
            UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"Status" message:@"Successful Post." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlertView.tag = 200;
            [ShowAlertView show];
        }else{
            UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"Status" message:@"Unsuccessful please try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlertView.tag = 300;
            [ShowAlertView show];
        }
        
    }
    
    
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
}

//#pragma mark - SMTagField delegate
//-(void)tagField:(SMTagField *)_tagField tagAdded:(NSString *)tag{
//    // log.text                = [log.text stringByAppendingFormat:@"\nTag Added: %@", tag];
//    // [log scrollRangeToVisible: NSMakeRange(log.text.length - 1, 1)];
//    // [TagArray addObject:tag];
//    NSLog(@"tag is %@",tag);
//    [TagStringArray addObject:tag];
//    NSString *TagData = [[NSString alloc]initWithFormat:@"#[tag:%@]",tag];
//    [TagStringDataArray addObject:TagData];
//}
//-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    
//    [textField resignFirstResponder];
//    return YES;
//}
//-(void)tagField:(SMTagField *)_tagField tagRemoved:(NSString *)tag{
//    //log.text                = [log.text stringByAppendingFormat:@"\nTag Removed: %@", tag];
//    // [log scrollRangeToVisible: NSMakeRange(log.text.length - 1, 1)];
//    //  [TagArray removeObject:tag];
//    [TagStringArray removeObject:tag];
//    NSString *TagData = [[NSString alloc]initWithFormat:@"#[tag:%@]",tag];
//    [TagStringDataArray removeObject:TagData];
//}
//
//-(BOOL)tagField:(SMTagField *)_tagField shouldAddTag:(NSString *)tag{
//    // Limits to a maximum of 5 tags and doesn't allow to add a tag called "cat"
//    if(_tagField.tags.count >= 20 ||
//       [[tag lowercaseString] isEqualToString: @"cat"])
//        return NO;
//    
//    return YES;
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 300) {//handle error
        
    }
    if (alertView.tag == 200) {//done post back to mainview
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UITabBarController *tabBarController=[[UITabBarController alloc]init];
        tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
        [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
        //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
//        UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
//        [[UITabBar appearance] setShadowImage:tabBarBackground];
//        [[UITabBar appearance] setBackgroundImage:tabBarBackground];
        
        
        FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
        //firstViewController.title= CustomLocalisedString(@"MainTab_Feed",nil);
       // firstViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarFeed.png"];
        
        Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
        //secondViewController.title= CustomLocalisedString(@"MainTab_Explore",nil);
      //  secondViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarExplore.png"];
        
        SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
        //        PublishMainViewController *threeViewController=[[PublishMainViewController alloc]initWithNibName:@"PublishMainViewController" bundle:nil];
        //        //threeViewController.title=@"";
        //        //threeViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarPublish.png"];
        
        NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
        //fourViewController.title= CustomLocalisedString(@"MainTab_Like",nil);
      //  fourViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarActivity.png"];
        
        ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
        //fiveViewController.title= CustomLocalisedString(@"MainTab_Profile",nil);
      //  fiveViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarProfile.png"];
        
        //adding view controllers to your tabBarController bundling them in an array
        tabBarController.viewControllers=[NSArray arrayWithObjects:firstViewController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
        
        
        //[self presentModalViewController:tabBarController animated:YES];
        // [self presentViewController:tabBarController animated:NO completion:nil];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Address"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lat"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lng"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Link"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Contact"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Hour"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Address"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_City"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Country"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_State"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PostalCode"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_ReferralId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_type"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_Show"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_NumCode"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_BlogLink"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs_Data"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Source"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Period"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_OpenNow"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Draft_PhotoCaption"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoCount"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Title"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Message"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionDataArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringDataArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionArray"];

    }
    if (alertView.tag == 500) {//handle error
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            NSLog(@"save draft click");
            [self SaveDaftSendDataToServer];
        }else{
            NSLog(@"confirm back");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
-(IBAction)SaveDaftButton:(id)sender{
    NSLog(@"SaveDaftButton click");
    [self SaveDaftSendDataToServer];
}

-(void)SaveDaftSendDataToServer{
    
    StatusString = @"0";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SendCaptionDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionDataArray"]];
    
    NSString *GetAddress_ = [defaults objectForKey:@"PublishV2_Location_Address"];
    NSString *GetCity_ = [defaults objectForKey:@"PublishV2_Location_City"];
    NSString *GetCountry_ = [defaults objectForKey:@"PublishV2_Location_Country"];
    NSString *GetState_ = [defaults objectForKey:@"PublishV2_Location_State"];
    NSString *GetpostalCode_ = [defaults objectForKey:@"PublishV2_Location_PostalCode"];
    NSString *GetreferralId_ = [defaults objectForKey:@"PublishV2_Location_ReferralId"];
    NSString *GetAddressData_ = [defaults objectForKey:@"PublishV2_Address"];
    NSString *GetNameData_ = [defaults objectForKey:@"PublishV2_Name"];
    NSString *GetLatData_ = [defaults objectForKey:@"PublishV2_Lat"];
    NSString *GetLngData_ = [defaults objectForKey:@"PublishV2_Lng"];
    NSString *GetContactData_ = [defaults objectForKey:@"PublishV2_Contact"];
    NSString *GetLinkData_ = [defaults objectForKey:@"PublishV2_Link"];
    NSString *GetTypeData_ = [defaults objectForKey:@"PublishV2_type"];
    NSString *GetPriceData_ = [defaults objectForKey:@"PublishV2_Price"];
    NSString *GetPriceNumCodeData_ = [defaults objectForKey:@"PublishV2_Price_NumCode"];
    NSString *GetSource_ = [defaults objectForKey:@"PublishV2_Source"];
    NSString *GetPeriod_ = [defaults objectForKey:@"PublishV2_Period"];
    NSString *GetOpenNow_ = [defaults objectForKey:@"PublishV2_OpenNow"];
    GetBlogString = [defaults objectForKey:@"PublishV2_BlogLink"];
    if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
        GetBlogString = @"";
    }
    if ([GetPriceData_ isEqualToString:@""] || GetPriceData_ == nil || [GetPriceData_ isEqualToString:@"(null)"] || [GetPriceData_ isEqualToString:@"nil"]) {
        GetPriceData_ = @"";
    }
    if ([GetPriceNumCodeData_ isEqualToString:@""] || GetPriceNumCodeData_ == nil || [GetPriceNumCodeData_ isEqualToString:@"(null)"] || [GetPriceNumCodeData_ isEqualToString:@"nil"]) {
        GetPriceNumCodeData_ = @"";
    }
    if ([GetLinkData_ isEqualToString:@""] || GetLinkData_ == nil || [GetLinkData_ isEqualToString:@"(null)"] || [GetLinkData_ isEqualToString:@"nil"]) {
        GetLinkData_ = @"";
    }
    if ([GetContactData_ isEqualToString:@""] || GetContactData_ == nil || [GetContactData_ isEqualToString:@"(null)"] || [GetContactData_ isEqualToString:@"nil"]) {
        GetContactData_ = @"";
    }
    if ([GetSource_ isEqualToString:@""] || GetSource_ == nil || [GetSource_ isEqualToString:@"(null)"] || [GetSource_ isEqualToString:@"nil"]) {
        GetSource_ = @"";
    }else{
    }
    if ([GetPeriod_ isEqualToString:@""] || GetPeriod_ == nil || [GetPeriod_ isEqualToString:@"(null)"] || [GetPeriod_ isEqualToString:@"nil"]) {
        GetPeriod_ = @"";
    }else{
    }
    if ([GetOpenNow_ isEqualToString:@""] || GetOpenNow_ == nil || [GetOpenNow_ isEqualToString:@"(null)"] || [GetOpenNow_ isEqualToString:@"nil"]) {
        GetOpenNow_ = @"false";
    }else{
        GetOpenNow_ = @"true";
    }
    //location json
    //type 1 == foursqure
    if ([GetTypeData_ isEqualToString:@"1"]) {
        if ([GetPriceNumCodeData_ isEqualToString:@""]) {
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetLinkData_,GetContactData_];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }else{
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetPriceNumCodeData_,GetPriceData_,GetLinkData_,GetContactData_];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }
        
    }else{
        //        NSString *TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@]},\"weekday_text\":\"Monday: 8:00 am - 12:00 am\",\"Tuesday: 8:00 am - 12:00 am\",\"Wednesday: 8:00 am - 12:00 am\",\"Thursday: 8:00 am - 12:00 am\",\"Friday: 8:00 am - 12:00 am\",\"Saturday: 9:00 am - 12:00 am\",\"Sunday: 9:00 am - 12:00 am\"}",GetOpenNow,GetPeriod];
        NSString *TempString;
        if ([GetUpdatePost isEqualToString:@"YES"]) {
            NSString *GetSource = [defaults objectForKey:@"PublishV2_Source"];
            if ([GetSource isEqualToString:@""] || GetSource == nil || [GetSource isEqualToString:@"(null)"] || [GetSource isEqualToString:@"nil"]) {
                TempString = @"\"\"";
            }else{
                TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow_,GetPeriod_,GetSource_];
            }
            
        }else{
            TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow_,GetPeriod_,GetSource_];
        }
        
        if ([GetPriceNumCodeData_ isEqualToString:@""]) {
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetLinkData_,GetContactData_,TempString,GetOpenNow_,GetPeriod_];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }else{
            
            
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress_,GetCity_,GetState_,GetpostalCode_,GetCountry_,GetNameData_,GetAddressData_,GetLatData_,GetLngData_,GetreferralId_,GetTypeData_,GetPriceNumCodeData_,GetPriceData_,GetLinkData_,GetContactData_,TempString,GetOpenNow_,GetPeriod_];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }
        
        
    }
    
    if ([ExperienceTextView.text isEqualToString:@"How was your experience?"] || [ExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ExperienceTextView.text isEqualToString:@"รีวิว"]) {
        ExperienceTextView.text = @"";
    }
    if ([ChineseExperienceTextView.text isEqualToString:@"How was your experience?"] || [ChineseExperienceTextView.text isEqualToString:@"说明 & 经验"] || [ChineseExperienceTextView.text isEqualToString:@"Deskripsi dan pengalaman"] || [ChineseExperienceTextView.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [ChineseExperienceTextView.text isEqualToString:@"รีวิว"]) {
        ChineseExperienceTextView.text = @"";
    }
    
    
    if ([TitleArray count] > 1) {
        [TitleArray replaceObjectAtIndex:0 withObject:TitleField.text];
        [TitleArray replaceObjectAtIndex:1 withObject:ChineseTextField.text];
        
        [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
        [MessageArray replaceObjectAtIndex:1 withObject:ChineseExperienceTextView.text];
        
        NSString *GetTempString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:1]];
        if ([GetTempString isEqualToString:@""] || GetTempString == nil || [GetTempString isEqualToString:@"(null)"] || [GetTempString isEqualToString:@"nil"]) {
            [TitleArray removeLastObject];
            [LangIDArray removeLastObject];
            [MessageArray removeLastObject];
        }
    }else{
        [TitleArray replaceObjectAtIndex:0 withObject:TitleField.text];
        
        [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
    }
    
    
    
    
    NSLog(@"TitleArray is %@",TitleArray);
    NSLog(@"MessageArray is %@",MessageArray);
    NSLog(@"StatusString is %@",StatusString);
    NSLog(@"TagString is %@",TagString);
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
    //        NSLog(@"GetImageArray count is %lu",(unsigned long)[GetImageArray count]);
    
    [self SendDataToServer];
}

@end

//
//  RecommendV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/28/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "RecommendV2ViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "SelectImageViewController.h"
#import "AddLinkViewController.h"
#import "FeedV2ViewController.h"
#import "FullImageViewController.h"

#import "LanguageManager.h"
#import "Locale.h"


#import "ConfirmPlaceViewController.h"
#import "ShowImageViewController.h"
@interface RecommendV2ViewController ()

@end

@implementation RecommendV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    [SaveDraftButton setTitle:CustomLocalisedString(@"RecommendSaveDraft", nil) forState:UIControlStateNormal];
    SaveDraftButton.frame = CGRectMake(screenWidth - 77 - 15, 20, 77, 44);
    ShowTitle.text = CustomLocalisedString(@"Recommend", nil);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 60);
    ImageScroll.delegate = self;
    ImageScroll.frame = CGRectMake(0, 64, screenWidth, 100);
    
    ShowDownView.frame = CGRectMake(0, screenHeight - 60, screenWidth, 60);
    DownLineButton.frame = CGRectMake(0, 0, screenWidth, 1);
    NextButton.frame = CGRectMake(screenWidth - 120, 0, 100, 60);
    [NextButton setTitle:CustomLocalisedString(@"Next", nil) forState:UIControlStateNormal];
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    ShowLineImg.frame = CGRectMake(screenWidth - 120, 11, 1, 37);
    
    ShowQRText.text = CustomLocalisedString(@"ShowQualityRecommendation", nil);
    ShowQRText.numberOfLines = 0;
    ShowQRText.frame = CGRectMake(15, 5, 320, [ShowQRText sizeThatFits:CGSizeMake(320, CGFLOAT_MAX)].height);
    LineButton.frame = CGRectMake(15, 249, screenWidth, 1);
    
    ShowQualityView.frame = CGRectMake(0, screenHeight - 130, screenWidth, 50);
    
    [PublishButton setTitle:CustomLocalisedString(@"Publish", nil) forState:UIControlStateNormal];
    [CancelButton setTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) forState:UIControlStateNormal];
    [MainCancelButton setTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) forState:UIControlStateNormal];
    
    ShowMiniTitle.text = CustomLocalisedString(@"youcanchoose2", nil);
    ShowCategoryTitle.text = CustomLocalisedString(@"ChooseCategories", nil);
    ShowMiniTitle.frame = CGRectMake(15, 10, screenWidth - 45, 21);
    
    PublishView.hidden = YES;
    PublishView.frame = CGRectMake(0, 600, screenWidth, screenHeight);
    SelectCategoryScrollView.frame = CGRectMake(10, 70, screenWidth - 20, screenHeight - 130);
    PublishButton.frame = CGRectMake(0, screenHeight - 60, screenWidth, 60);
    [self.view addSubview:PublishView];
    BlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    CategoryBackgroundImg.frame = CGRectMake(10, 24, screenWidth - 20, 254);
    CategoryLineButton.frame = CGRectMake(10, 70, screenWidth - 20, 1);
    ShowCategoryTitle.frame = CGRectMake(20, 32, screenWidth - 30 - 80, 30);
    CancelButton.frame = CGRectMake(screenWidth - 20 - 80, 32, 80, 30);
    ShowTitleCountText.frame = CGRectMake(screenWidth - 42 - 15, 188, 42, 37);
    ShowExperienceCountText.frame = CGRectMake(screenWidth - 42 - 15, 267, 42, 37);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([GetUpdatePost isEqualToString:@"YES"]) {

    }else{
        ExperienceTextView.frame = CGRectMake(15, 267, screenWidth - 30, 128);
        ExperienceTextView.delegate = self;
        ExperienceTextView.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ExperienceTextView.tag = 100;
        ExperienceTextView.text = @"Share your experience...";
        
        TitleTextView.delegate = self;
        TitleTextView.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        TitleTextView.tag = 200;
        TitleTextView.text = @"Write a title... (Optional)";
        TitleTextView.frame = CGRectMake(15, 188, screenWidth - 30, 37);
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [MainScroll addGestureRecognizer:tapGesture];
    
   // [MainScroll setContentSize:CGSizeMake(screenWidth, 1500)];
    
    NSString *GetSelectCategory = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"PublishV2_Category"]];
    if ([GetSelectCategory length] == 0 || GetSelectCategory == nil || [GetSelectCategory isEqualToString:@"(null)"] || [GetSelectCategory isKindOfClass:[NSNull class]]) {
        CategorySelectIDArray = [[NSMutableArray alloc]init];
      //  NSLog(@"error 1 CategorySelectIDArray is %@",CategorySelectIDArray);
    }else{
        NSArray *arr = [GetSelectCategory componentsSeparatedByString:@","];
        CategorySelectIDArray = [[NSMutableArray alloc]initWithArray:arr];
       // NSLog(@"error 2 CategorySelectIDArray is %@",CategorySelectIDArray);
    }
    
    
    
    SelectCategoryScrollView.delegate = self;
    [SelectCategoryScrollView setContentSize:CGSizeMake(300, 650)];
    
   // [self InitImageData];
    
    //Init Category
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
    
    int GetWidth = (screenWidth / 2) - 20;
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
        ShowImageButton.frame = CGRectMake((GetWidth/2) - (ButtonWidth/2) +(i % 2)* GetWidth, 49 + ((ButtonWidth + 60) * (CGFloat)(i /2)), ButtonWidth, ButtonWidth);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        
        NSString *CheckCategoryID = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:i]];
        for (int z = 0; z < [CategorySelectIDArray count]; z++) {
            if ([CheckCategoryID isEqualToString:[CategorySelectIDArray objectAtIndex:z]]) {
                ShowImageButton.selected = YES;
                break;
            }
        }
        
        sscanf([[GetBackgroundArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = (ButtonWidth/2); // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [SelectCategoryScrollView addSubview:ShowImageButton];
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(0 +(i % 2)*GetWidth, (49 + ButtonWidth + 10) + ((ButtonWidth + 60) * (CGFloat)(i /2)), GetWidth, 21);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [SelectCategoryScrollView addSubview:ShowTitle_];
        
        [SelectCategoryScrollView setContentSize:CGSizeMake(300, (49 + ButtonWidth + 60) + ((ButtonWidth + 60) * (CGFloat)(i /2)))];
    }
    
    
//    if ([GetUpdatePost isEqualToString:@"YES"]) {
//       
//    }else{
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
        NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
        NSLog(@"LanguageID_Array is %@",LanguageID_Array);
        NSLog(@"LanguageName_Array is %@",LanguageName_Array);
        
        GetUserLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language1"]];
        GetUserLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language2"]];
        NSLog(@"GetUserLanguage_1 is %@",GetUserLanguage_1);
        NSLog(@"GetUserLanguage_2 is %@",GetUserLanguage_2);
        
        if ([GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]) {
            GetUserLanguage_1 = @"中文";
        }
        
        if ([GetUserLanguage_2 isEqualToString:@"简体中文"] || [GetUserLanguage_2 isEqualToString:@"繁體中文"]) {
            GetUserLanguage_2 = @"中文";
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
                }else{
                    
                }
            }
        }
        NSLog(@"LangArray is %@",LangArray);
        NSLog(@"LangIDArray is %@",LangIDArray);
        NSLog(@"TitleArray is %@",TitleArray);
        NSLog(@"MessageArray is %@",MessageArray);
        
        if ([GetUserLanguage_1 isEqualToString:@"English"]) {
            TitleTextView.text = @"Write a title... (Optional)";
            ExperienceTextView.text = @"Share your experience...";
        }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
            TitleTextView.text = @"请输入标题（自选项）";
            ExperienceTextView.text = @"推荐文内容...";
        }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
            TitleTextView.text = @"Tulis judul (Opsional)";
            ExperienceTextView.text = @"Bagikan pengalaman kamu";
        }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
            TitleTextView.text = @"Write a title... (Optional)";
            ExperienceTextView.text = @"Share your experience...";
        }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
            TitleTextView.text = @"ชื่อเรื่อง";
            ExperienceTextView.text = @"แชร์ประสบการณ์";
        }else{
            TitleTextView.text = @"Write a title... (Optional)";
            ExperienceTextView.text = @"Share your experience...";
        }
  //  }
    
    CheckKeyboard = 0;
    CheckDraft = 0;
    CheckEdit = 0;
}
-(void)EditPost:(NSString *)CheckEditPost{

    CheckEditPostData = CheckEditPost;
    //SaveDraftButton.hidden = YES;
    CheckEdit = 1;
    [SaveDraftButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID{
    GetUpdatePost = UpdatePost;
    GetPostID = PostID;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    ExperienceTextView.frame = CGRectMake(15, 267, screenWidth - 30, 128);
//    ExperienceTextView.delegate = self;
//    ExperienceTextView.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    ExperienceTextView.tag = 100;
//    ExperienceTextView.text = @"Tell us your experience...";
//    
//    TitleTextView.delegate = self;
//    TitleTextView.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    TitleTextView.tag = 200;
//    TitleTextView.text = @"Write a title...";
//    TitleTextView.frame = CGRectMake(15, 188, screenWidth - 30, 37);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetTitleData = [defaults objectForKey:@"PublishV2_Title"];
   // NSArray *SplitArrayTitle = [GetTitleData componentsSeparatedByString:@","];
    NSString *GetMessage = [defaults objectForKey:@"PublishV2_Message"];
    //NSArray *SplitArrayMessage = [GetMessage componentsSeparatedByString:@","];
    
    NSLog(@"GetTitleData is %@",GetTitleData);
    NSLog(@"GetMessage is %@",GetMessage);
    
    if ([GetTitleData length] == 0) {
    }else{
//        for (int i = 0; i < [SplitArrayTitle count]; i++) {
//            switch (i) {
//                case 0:
                    TitleTextView.text = GetTitleData;
                    ShowQualityView.hidden = YES;
                    TitleTextView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//                    break;
//                case 1:
//                //    ChineseTextField.text = [SplitArrayTitle objectAtIndex:i];
//                   // ChineseExperienceTextView.text = [SplitArrayMessage objectAtIndex:i];
//                    break;
//                default:
//                    break;
//            }
//        }
    }
    
    if ([GetMessage length] == 0) {
    }else{
//        for (int i = 0; i < [SplitArrayTitle count]; i++) {
//            switch (i) {
//                case 0:
                    ExperienceTextView.text = GetMessage;
                    ShowQualityView.hidden = YES;
                    ExperienceTextView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//                    break;
//                case 1:
//                    //    ChineseTextField.text = [SplitArrayTitle objectAtIndex:i];
//                    // ChineseExperienceTextView.text = [SplitArrayMessage objectAtIndex:i];
//                    break;
//                default:
//                    break;
//            }
//        }
    }
    

    int GetHeight = screenHeight - 50;
    int FinalHeight = 267 - screenHeight - 50;
    if (TitleTextView.tag == 200) {
        if ([TitleTextView.text isEqualToString:@"Write a title... (Optional)"] || [TitleTextView.text isEqualToString:@"请输入标题（自选项）"] || [TitleTextView.text isEqualToString:@"Tulis judul (Opsional)"] || [TitleTextView.text isEqualToString:@"ชื่อเรื่อง"]) {
        }else{
            NSUInteger len = TitleTextView.text.length;
            ShowTitleCountText.text = [NSString stringWithFormat:@"%lu",70 - len];
            NSLog(@"len is %lu",(unsigned long)len);
        }
        TitleTextView.frame = CGRectMake(15, 172, screenWidth - 30,[TitleTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
        ShowTitleCountText.frame = CGRectMake(screenWidth - 42 - 15, 172 + [TitleTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height, 42, 37);
        LineButton.frame = CGRectMake(15, 172 + [TitleTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 30, screenWidth, 1);
        ExperienceTextView.frame = CGRectMake(15, 172 + [TitleTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 50, screenWidth - 30, ExperienceTextView.frame.size.height);
        ShowExperienceCountText.frame = CGRectMake(screenWidth - 42 - 15, 172 + [TitleTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 50, 42,37);
    }
    if (ExperienceTextView.tag == 100) {
        if ([ExperienceTextView.text isEqualToString:@"Share your experience..."] || [ExperienceTextView.text isEqualToString:@"推荐文内容..."] || [ExperienceTextView.text isEqualToString:@"Bagikan pengalaman kamu"] || [ExperienceTextView.text isEqualToString:@"แชร์ประสบการณ์"]) {
        }else{
            NSUInteger len = ExperienceTextView.text.length;
            ShowExperienceCountText.text = [NSString stringWithFormat:@"%lu",1000 - len];
        }

        if([ExperienceTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ExperienceTextView.frame.size.height)
        {
            ExperienceTextView.frame = CGRectMake(15, 172 + LineButton.frame.size.height + TitleTextView.frame.size.height + 40, screenWidth - 30,[ExperienceTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            ShowExperienceCountText.frame = CGRectMake(screenWidth - 42 - 15,172 + LineButton.frame.size.height + TitleTextView.frame.size.height + 40 + [ExperienceTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height, 42,37);
            if (ExperienceTextView.frame.size.height  > FinalHeight) {
                
                [MainScroll setContentSize:CGSizeMake(300, GetHeight + [ExperienceTextView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height)];
            }
        }
        
    }

    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
   // [self InitImageData];
    self.screenName = @"IOS Recommend View V2";
    [NSThread detachNewThreadSelector:@selector(InitImageData) toTarget:self withObject:nil];
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    NSLog(@"BackButton Click ?");
    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
    
    if ([CheckEditPostData isEqualToString:@"100"]) {
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"AskExit", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Publish", nil),CustomLocalisedString(@"Exit", nil), nil];
        AlertView.tag = 1500;
        [AlertView show];
    }else{
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"AskExit", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"AskSaveDraft", nil),CustomLocalisedString(@"Exit", nil), nil];
        AlertView.tag = 500;
        [AlertView show];
    }
    

}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)InitImageData{
    for (UIView *subview in ImageScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
    GetImageArray = [[NSMutableArray alloc]init];
    GetPhotoPositionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_PhotoPosition"]];
    
    if ([GetPhotoPositionArray count] == 0) {
        for (int i = 0; i < [TempArray count]; i++) {
            NSString *GetCount = [[NSString alloc]initWithFormat:@"%ld",(long)i + 1];
            [GetPhotoPositionArray addObject:GetCount];
        }
    }else{
    
    }
    
    for (int i = 0; i < [TempArray count]; i++) {
        [GetImageArray addObject:[TempArray objectAtIndex:i]];
       // [GetImageArray addObject:[self decodeBase64ToImage:[TempArray objectAtIndex:i]]];
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (int i = 0; i < [GetImageArray count]; i++) {
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(10 + i * 90, 12, 76, 76);
        //ShowImage.image = [GetImageArray objectAtIndex:i];
        ShowImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [ImageScroll addSubview:ShowImage];
        
//        UIButton *ImageClick = [[UIButton alloc]init];
//        ImageClick.frame = CGRectMake(10 + i * 90, 12, 76, 76);
//        [ImageClick setTitle:@"" forState:UIControlStateNormal];
//        ImageClick.backgroundColor = [UIColor clearColor];
//        ImageClick.tag = i;
//        [ImageClick addTarget:self action:@selector(ImageClickButton:) forControlEvents:UIControlEventTouchUpInside];
//        [ImageScroll addSubview:ImageClick];
//        [ImageScroll setContentSize:CGSizeMake(110 + i * 90, 100)];
        
        UIButton *OpenEditClick = [[UIButton alloc]init];
        OpenEditClick.frame = CGRectMake(0, 0, screenWidth, 100);
        [OpenEditClick setTitle:@"" forState:UIControlStateNormal];
        OpenEditClick.backgroundColor = [UIColor clearColor];
        //ImageClick.tag = i;
        [OpenEditClick addTarget:self action:@selector(EditPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [ImageScroll addSubview:OpenEditClick];
        [ImageScroll setContentSize:CGSizeMake(110 + i * 90, 100)];

    }
}
-(IBAction)ImageClickButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FullImageViewController *FullImageView = [[FullImageViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FullImageView animated:NO completion:nil];
    [FullImageView GetLocalAllImageArray:GetImageArray GetIDN:getbuttonIDN];
}
-(IBAction)QualityRecommendationButton:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ShowQR_Title", nil) message:CustomLocalisedString(@"ShowQR_Detail", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
    
}
-(void)hideKeyboard
{
    CheckKeyboard = 0;
    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
    if (CheckEdit == 1) {
        [SaveDraftButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    }else{
        [SaveDraftButton setTitle:CustomLocalisedString(@"SaveasDraft", nil) forState:UIControlStateNormal];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CheckKeyboard = 1;
    [SaveDraftButton setTitle:CustomLocalisedString(@"DoneButton", nil) forState:UIControlStateNormal];
    ShowQualityView.hidden = YES;
    NSLog(@"did begin editing");
    if(textView.tag == 100){
        if ([ExperienceTextView.text isEqualToString:@"Share your experience..."] || [ExperienceTextView.text isEqualToString:@"推荐文内容..."] || [ExperienceTextView.text isEqualToString:@"Bagikan pengalaman kamu"] || [ExperienceTextView.text isEqualToString:@"แชร์ประสบการณ์"]) {
            ExperienceTextView.text = @"";
        }else{
            
        }
        
        ExperienceTextView.textColor = [UIColor blackColor];
    }else{
        if ([TitleTextView.text isEqualToString:@"Write a title... (Optional)"] || [TitleTextView.text isEqualToString:@"请输入标题（自选项）"] || [TitleTextView.text isEqualToString:@"Tulis judul (Opsional)"] || [TitleTextView.text isEqualToString:@"ชื่อเรื่อง"]) {
            TitleTextView.text = @"";
        }else{
            
        }
        TitleTextView.textColor = [UIColor blackColor];
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CheckKeyboard = 0;
    if (CheckEdit == 1) {
        [SaveDraftButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    }else{
        [SaveDraftButton setTitle:CustomLocalisedString(@"SaveasDraft", nil) forState:UIControlStateNormal];
    }
    if(textView.tag == 100){
        if ([ExperienceTextView.text length] == 0) {
            if ([GetUserLanguage_1 isEqualToString:@"English"]) {
                ExperienceTextView.text = @"Share your experience...";
            }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
                ExperienceTextView.text = @"推荐文内容...";
            }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
                ExperienceTextView.text = @"Bagikan pengalaman kamu";
            }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
                ExperienceTextView.text = @"Share your experience...";
            }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
                ExperienceTextView.text = @"แชร์ประสบการณ์";
            }else{
                ExperienceTextView.text = @"Share your experience...";
            }
            ExperienceTextView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowQualityView.hidden = NO;
        }
    }else{
        if ([TitleTextView.text length] == 0) {
            if ([GetUserLanguage_1 isEqualToString:@"English"]) {
                TitleTextView.text = @"Write a title... (Optional)";
            }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
                TitleTextView.text = @"请输入标题（自选项）";
            }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
                TitleTextView.text = @"Tulis judul (Opsional)";
            }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
                TitleTextView.text = @"WWrite a title... (Optional)";
            }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
                TitleTextView.text = @"ชื่อเรื่อง";
            }else{
                TitleTextView.text = @"Write a title... (Optional)";
            }
             TitleTextView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowQualityView.hidden = NO;
        }
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    int GetHeight = screenHeight - 50;
    int FinalHeight = 267 - screenHeight - 50;
    if (textView.tag == 100) {
        NSUInteger len = textView.text.length;
        ShowExperienceCountText.text = [NSString stringWithFormat:@"%lu",1000 - len];
        
        if([textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=textView.frame.size.height)
        {
            textView.frame = CGRectMake(15, 172 + LineButton.frame.size.height + TitleTextView.frame.size.height + 40, screenWidth - 30,[textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            ShowExperienceCountText.frame = CGRectMake(screenWidth - 42 - 15, 172 + LineButton.frame.size.height + TitleTextView.frame.size.height + 40 + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height, 42,37);
            if (textView.frame.size.height  > FinalHeight) {
                [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height)];
            }
        }

    }else{
        NSUInteger len = textView.text.length;
        ShowTitleCountText.text = [NSString stringWithFormat:@"%lu",70 - len];
        textView.frame = CGRectMake(15, 172, screenWidth - 30,[textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
        ShowTitleCountText.frame = CGRectMake(screenWidth - 42 - 15, 156 + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height, 42, 37);
        LineButton.frame = CGRectMake(15, 172 + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 30, screenWidth, 1);
        ExperienceTextView.frame = CGRectMake(15, 172 + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 50, screenWidth - 30, ExperienceTextView.frame.size.height);
        ShowExperienceCountText.frame = CGRectMake(screenWidth - 42 - 15, 172 + [textView sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height + 50, 42,37);
    }
    

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == 200) {
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            else if([[textView text] length] >= 70)
            {
                ShowTitleCountText.text = @"0";
                ShowTitleCountText.textColor = [UIColor redColor];
                return NO;
            }
        }
    }else{
        if([text length] == 0)
        {
            if([textView.text length] != 0)
            {
                return YES;
            }
        }
        else if([[textView text] length] >= 1000)
        {
            ShowExperienceCountText.text = @"0";
            ShowExperienceCountText.textColor = [UIColor redColor];
            return NO;
        }
    }

    return YES;
}
-(IBAction)NextButton:(id)sender{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         PublishView.hidden = NO;
         PublishView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
     }completion:^(BOOL finished){
        // PublishButton.alpha = 0.5f;
         if ([CategorySelectIDArray count] == 0) {
             PublishButton.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:218.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
             [PublishButton setTitleColor:[UIColor colorWithRed:208.0f/255.0f green:237.0f/255.0f blue:249.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
             PublishButton.userInteractionEnabled = NO;
         }
     }];
}
-(IBAction)CancelButton:(id)sender{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         
         PublishView.frame = CGRectMake(0, 700, screenWidth, screenHeight);
     }completion:^(BOOL finished){
         PublishView.hidden = YES;
     }];
}
-(IBAction)ShowImageButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        PublishButton.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        [PublishButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        PublishButton.userInteractionEnabled = YES;
        if ([CategorySelectIDArray count] >= 2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalisedString(@"LimitExceed", nil) message:CustomLocalisedString(@"LimitText", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            buttonWithTag1.selected = NO;
        }else{
            NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
            [CategorySelectIDArray addObject:TempIDN];
        }
        
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
        if ([CategorySelectIDArray count] == 0) {
            PublishButton.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:218.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
            [PublishButton setTitleColor:[UIColor colorWithRed:208.0f/255.0f green:237.0f/255.0f blue:249.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            PublishButton.userInteractionEnabled = NO;
        }
    }
    
}
-(IBAction)EditLocationButton:(id)sender{
    ConfirmPlaceViewController *ConfirmView = [[ConfirmPlaceViewController alloc]init];
    [self presentViewController:ConfirmView animated:YES completion:nil];
}
-(IBAction)EditPhotoButton:(id)sender{
    ShowImageViewController *ShowImageView = [[ShowImageViewController alloc]init];
    [self presentViewController:ShowImageView animated:YES completion:nil];
    if ([GetUpdatePost isEqualToString:@"YES"]) {
        [ShowImageView GetIsupdatePost:GetUpdatePost GetPostID:GetPostID];
    }

}
-(IBAction)SubMenubutton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"AddBlogLink", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 200;

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"AddBlogLink", nil)]) {
            NSLog(@"Add Blog Link");
            AddLinkViewController *AddLinkView = [[AddLinkViewController alloc]init];
            [self presentViewController:AddLinkView animated:YES completion:nil];
            [AddLinkView GetWhatLink:@"Blog"];
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }
}
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
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
        Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
        
        SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
        
        NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
        
        ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
        
        //adding view controllers to your tabBarController bundling them in an array
        tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
        tabBarController.selectedIndex = 4;
        
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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionDataArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringDataArray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionArray"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckPhotoCount"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PlaceId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoPosition"];
        
        //delete Images
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSError *error = nil;
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsPath error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                if (!removeSuccess) {
                    // Error handling
                    
                }
            }
        } else {
            // Error handling
            
        }
        
    }
    if (alertView.tag == 500) {//delete action
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            //save daft;
            NSLog(@"Save Daft Button");
            if ([GetPostID length] == 0) {
               CheckDraft = 0;
            }else{
            CheckDraft = 1;
            }
            
            [self SaveDraftDataToServer];
        }else{
            NSLog(@"confirm delete post");
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            
            UITabBarController *tabBarController=[[UITabBarController alloc]init];
            tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
            [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
            //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
//            UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
//            [[UITabBar appearance] setShadowImage:tabBarBackground];
//            [[UITabBar appearance] setBackgroundImage:tabBarBackground];
            
            
            FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
            Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
            
            SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
            
            NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
            
            ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
            
            //adding view controllers to your tabBarController bundling them in an array
            tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];

            if ([GetPostID length] == 0 || [GetPostID isEqualToString:@""]) {
                
            }else{
            tabBarController.selectedIndex = 4;
            }
            
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
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckPhotoCount"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PlaceId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoPosition"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
            
            //delete Images
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [[NSFileManager alloc] init];
            NSError *error = nil;
            NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsPath error:&error];
            if (error == nil) {
                for (NSString *path in directoryContents) {
                    NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
                    BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                    if (!removeSuccess) {
                        // Error handling
                        
                    }
                }
            } else {
                // Error handling
                
            }
        }
    }
    if (alertView.tag == 1500) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            //save daft;
            NSLog(@"Edit Publish Button");
            [self  EditPostDataToServer];
        }else{
            NSLog(@"confirm back post");
            [self dismissViewControllerAnimated:YES completion:nil];
            //delete Images
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSFileManager *fileMgr = [[NSFileManager alloc] init];
            NSError *error = nil;
            NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsPath error:&error];
            if (error == nil) {
                for (NSString *path in directoryContents) {
                    NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
                    BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                    if (!removeSuccess) {
                        // Error handling
                        
                    }
                }
            } else {
                // Error handling
                
            }
        }
    }
    
}
-(IBAction)PublishButton:(id)sender{
    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
    NSLog(@"PublishButton Click");
    StatusString = @"1";
     CheckDraft = 1;
    if ([CategorySelectIDArray count] == 0) {

        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Must select category" delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }else{

        if ([ExperienceTextView.text isEqualToString:@"Share your experience..."] || [ExperienceTextView.text isEqualToString:@"推荐文内容..."] || [ExperienceTextView.text isEqualToString:@"Bagikan pengalaman kamu"] || [ExperienceTextView.text isEqualToString:@"แชร์ประสบการณ์"]) {
            ExperienceTextView.text = @"";
        }else{
            
        }
        if ([TitleTextView.text isEqualToString:@"Write a title... (Optional)"] || [TitleTextView.text isEqualToString:@"请输入标题（自选项）"] || [TitleTextView.text isEqualToString:@"Tulis judul (Opsional)"] || [TitleTextView.text isEqualToString:@"ชื่อเรื่อง"]) {
            TitleTextView.text = @"";
        }else{
            
        }
        NSLog(@"TitleArray count %lu",(unsigned long)[TitleArray count]);
        if ([TitleArray count] == 1) {// support two language
//            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
//            [TitleArray replaceObjectAtIndex:1 withObject:ChineseTextField.text];
//            
//            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
//            [MessageArray replaceObjectAtIndex:1 withObject:ChineseExperienceTextView.text];
            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            
            NSLog(@"[TitleArray count] == 1 in here?????");

        }else{
            NSLog(@"[TitleArray count] == 2 in here?????");
            
            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            
            NSString *GetTempString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:1]];
            if ([GetTempString isEqualToString:@""] || GetTempString == nil || [GetTempString isEqualToString:@"(null)"] || [GetTempString isEqualToString:@"nil"]) {
                [TitleArray removeLastObject];
                [LangIDArray removeLastObject];
                [MessageArray removeLastObject];
                [LangArray removeLastObject];
            }
        }
        
        NSLog(@"TitleArray is %@",TitleArray);
        NSLog(@"MessageArray is %@",MessageArray);
        NSLog(@"LangArray is %@",LangArray);
        NSLog(@"LangIDArray is %@",LangIDArray);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SendCaptionDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionDataArray"]];
        NSMutableArray *TagStringArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringArray"]];
        NSMutableArray *TagStringDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringDataArray"]];
        NSMutableArray *CaptionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionArray"]];
        
        NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
        NSLog(@"TagStringArray is %@",TagStringArray);
        NSLog(@"TagStringDataArray is %@",TagStringDataArray);
        NSLog(@"CaptionArray is %@",CaptionArray);
        
        if ([SendCaptionDataArray count] == 0) {
            for (int i = 0; i < [GetImageArray count]; i++) {
                [SendCaptionDataArray addObject:@""];
            }
        }
        
        GetTagString = [TagStringDataArray componentsJoinedByString:@","];
        NSString *GetAddress = [defaults objectForKey:@"PublishV2_Location_Address"];
        NSString *GetCity = [defaults objectForKey:@"PublishV2_Location_City"];
        NSString *GetCountry = [defaults objectForKey:@"PublishV2_Location_Country"];
        NSString *GetState = [defaults objectForKey:@"PublishV2_Location_State"];
        NSString *GetpostalCode = [defaults objectForKey:@"PublishV2_Location_PostalCode"];
        NSString *GetreferralId = [defaults objectForKey:@"PublishV2_Location_ReferralId"];
        NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
        NSString *GetNameData = [defaults objectForKey:@"PublishV2_Name"];
        NSString *GetLatData = [defaults objectForKey:@"PublishV2_Lat"];
        NSString *GetLngData = [defaults objectForKey:@"PublishV2_Lng"];
        NSString *GetContactData = [defaults objectForKey:@"PublishV2_Contact"];
        NSString *GetLinkData = [defaults objectForKey:@"PublishV2_Link"];
        NSString *GetTypeData = [defaults objectForKey:@"PublishV2_type"];
        NSString *GetPriceData = [defaults objectForKey:@"PublishV2_Price"];
        NSString *GetPriceNumCodeData = [defaults objectForKey:@"PublishV2_Price_NumCode"];
        NSString *GetSource = [defaults objectForKey:@"PublishV2_Source"];
        NSString *GetPeriod = [defaults objectForKey:@"PublishV2_Period"];
        NSString *GetOpenNow = [defaults objectForKey:@"PublishV2_OpenNow"];
        NSString *GetPlaceID = [defaults objectForKey:@"PublishV2_Location_PlaceId"];
        GetBlogString = [defaults objectForKey:@"PublishV2_BlogLink"];
        
        NSLog(@"GetAddress is %@",GetAddress);
        NSLog(@"GetCity is %@",GetCity);
        NSLog(@"GetCountry is %@",GetCountry);
        NSLog(@"GetState is %@",GetState);
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        NSLog(@"GetreferralId is %@",GetreferralId);
        NSLog(@"GetAddressData is %@",GetAddressData);
        NSLog(@"GetNameData is %@",GetNameData);
        NSLog(@"GetLatData is %@",GetLatData);
        NSLog(@"GetLngData is %@",GetLngData);
        NSLog(@"GetContactData is %@",GetContactData);
        NSLog(@"GetLinkData is %@",GetLinkData);
        NSLog(@"GetTypeData is %@",GetTypeData);
        NSLog(@"GetPriceData is %@",GetPriceData);
        NSLog(@"GetPriceNumCodeData is %@",GetPriceNumCodeData);
        NSLog(@"GetSource is %@",GetSource);
        NSLog(@"GetPeriod is %@",GetPeriod);
        NSLog(@"GetOpenNow is %@",GetOpenNow);
        NSLog(@"GetPlaceID is %@",GetPlaceID);
        NSLog(@"GetBlogString is %@",GetBlogString);
        
        if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
            GetBlogString = @"";
        }
        if ([GetPriceData isEqualToString:@""] || GetPriceData == nil || [GetPriceData isEqualToString:@"(null)"] || [GetPriceData isEqualToString:@"nil"]) {
            GetPriceData = @"";
        }
        if ([GetPriceNumCodeData isEqualToString:@""] || GetPriceNumCodeData == nil || [GetPriceNumCodeData isEqualToString:@"(null)"] || [GetPriceNumCodeData isEqualToString:@"nil"]) {
            GetPriceNumCodeData = @"";
        }
        if ([GetLinkData isEqualToString:@""] || GetLinkData == nil || [GetLinkData isEqualToString:@"(null)"] || [GetLinkData isEqualToString:@"nil"]) {
            GetLinkData = @"";
        }
        if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
            GetreferralId = @"";
        }
        if ([GetContactData isEqualToString:@""] || GetContactData == nil || [GetContactData isEqualToString:@"(null)"] || [GetContactData isEqualToString:@"nil"]) {
            GetContactData = @"";
        }
        if ([GetSource isEqualToString:@""] || GetSource == nil || [GetSource isEqualToString:@"(null)"] || [GetSource isEqualToString:@"nil"]) {
            GetSource = @"";
        }else{
        }
        
        if ([GetPeriod isEqualToString:@""] || GetPeriod == nil || [GetPeriod isEqualToString:@"(null)"] || [GetPeriod isEqualToString:@"nil"] || [GetPeriod isEqualToString:@"(\n)"]) {
            GetPeriod = @"";
        }else{
        }
        if ([GetOpenNow isEqualToString:@""] || GetOpenNow == nil || [GetOpenNow isEqualToString:@"(null)"] || [GetOpenNow isEqualToString:@"nil"]) {
            GetOpenNow = @"false";
        }else{
            GetOpenNow = @"true";
        }
        
        if ([GetAddress isEqualToString:@""] || GetAddress == nil || [GetAddress isEqualToString:@"(null)"] || [GetAddress isEqualToString:@"nil"]) {
            GetAddress = @"";
        }else{
        }
        if ([GetCity isEqualToString:@""] || GetCity == nil || [GetCity isEqualToString:@"(null)"] || [GetCity isEqualToString:@"nil"]) {
            GetCity = @"";
        }else{
        }
        if ([GetState isEqualToString:@""] || GetState == nil || [GetState isEqualToString:@"(null)"] || [GetState isEqualToString:@"nil"]) {
            GetState = @"";
        }else{
        }
        if ([GetpostalCode isEqualToString:@""] || GetpostalCode == nil || [GetpostalCode isEqualToString:@"(null)"] || [GetpostalCode isEqualToString:@"nil"]) {
            GetpostalCode = @"";
        }else{
        }
        if ([GetCountry isEqualToString:@""] || GetCountry == nil || [GetCountry isEqualToString:@"(null)"] || [GetCountry isEqualToString:@"nil"]) {
            GetCountry = @"";
        }else{
        }
        if ([GetNameData isEqualToString:@""] || GetNameData == nil || [GetNameData isEqualToString:@"(null)"] || [GetNameData isEqualToString:@"nil"]) {
            GetNameData = @"";
        }else{
        }
        if ([GetAddressData isEqualToString:@""] || GetAddressData == nil || [GetAddressData isEqualToString:@"(null)"] || [GetAddressData isEqualToString:@"nil"]) {
            GetAddressData = @"";
        }else{
        }
        if ([GetLatData isEqualToString:@""] || GetLatData == nil || [GetLatData isEqualToString:@"(null)"] || [GetLatData isEqualToString:@"nil"]) {
            GetLatData = @"";
        }else{
        }
        if ([GetLngData isEqualToString:@""] || GetLngData == nil || [GetLngData isEqualToString:@"(null)"] || [GetLngData isEqualToString:@"nil"]) {
            GetLngData = @"";
        }else{
        }
        if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
            GetreferralId = @"";
        }else{
        }
        if ([GetTypeData isEqualToString:@""] || GetTypeData == nil || [GetTypeData isEqualToString:@"(null)"] || [GetTypeData isEqualToString:@"nil"]) {
            GetTypeData = @"";
        }else{
        }
        if ([GetPlaceID isEqualToString:@""] || GetPlaceID == nil || [GetPlaceID isEqualToString:@"(null)"] || [GetPlaceID isEqualToString:@"nil"]) {
            GetPlaceID = @"";
        }else{
        }
        //location json
        //type 1 == foursqure
        if ([GetTypeData isEqualToString:@"1"]) {
            if ([GetPriceNumCodeData isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetLinkData,GetContactData];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData];
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
                    TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
                }
                
            }else{
                TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
            }
            
            if ([GetPriceNumCodeData isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{
                
                
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }
            
            
        }
        
        
        NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
        
        SaveDraftButton.enabled = NO;
        NextButton.enabled = NO;
        OpenEditPlaceButton.enabled = NO;
        OpenPhotoButton.enabled = NO;
        OpenSubMenuButton.enabled = NO;
        CancelButton.enabled = NO;
        
        
        [self SendAllDataToServer];
    }
}
-(void)SaveDraftDataToServer{

    StatusString = @"0";
        if ([ExperienceTextView.text isEqualToString:@"Share your experience..."] || [ExperienceTextView.text isEqualToString:@"推荐文内容..."] || [ExperienceTextView.text isEqualToString:@"Bagikan pengalaman kamu"] || [ExperienceTextView.text isEqualToString:@"แชร์ประสบการณ์"]) {
        ExperienceTextView.text = @"";
    }else{
        
    }
        if ([TitleTextView.text isEqualToString:@"Write a title... (Optional)"] || [TitleTextView.text isEqualToString:@"请输入标题（自选项）"] || [TitleTextView.text isEqualToString:@"Tulis judul (Opsional)"] || [TitleTextView.text isEqualToString:@"ชื่อเรื่อง"]) {
        TitleTextView.text = @"";
    }else{
        
    }
    NSLog(@"TitleArray count %lu",(unsigned long)[TitleArray count]);
    if ([TitleArray count] == 1) {// support two language
        //            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
        //            [TitleArray replaceObjectAtIndex:1 withObject:ChineseTextField.text];
        //
        //            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
        //            [MessageArray replaceObjectAtIndex:1 withObject:ChineseExperienceTextView.text];
        [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
        [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
        
        NSLog(@"[TitleArray count] == 1 in here?????");
        
    }else{
        NSLog(@"[TitleArray count] == 2 in here?????");
        
        [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
        [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
        
        NSString *GetTempString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:1]];
        if ([GetTempString isEqualToString:@""] || GetTempString == nil || [GetTempString isEqualToString:@"(null)"] || [GetTempString isEqualToString:@"nil"]) {
            [TitleArray removeLastObject];
            [LangIDArray removeLastObject];
            [MessageArray removeLastObject];
            [LangArray removeLastObject];
        }
    }
    
    NSLog(@"TitleArray is %@",TitleArray);
    NSLog(@"MessageArray is %@",MessageArray);
    NSLog(@"LangArray is %@",LangArray);
    NSLog(@"LangIDArray is %@",LangIDArray);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SendCaptionDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionDataArray"]];
    NSMutableArray *TagStringArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringArray"]];
    NSMutableArray *TagStringDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringDataArray"]];
    NSMutableArray *CaptionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionArray"]];
    
    NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
    
    if ([SendCaptionDataArray count] == 0) {
        for (int i = 0; i < [GetImageArray count]; i++) {
            [SendCaptionDataArray addObject:@""];
        }
    }
    
    NSLog(@"TagStringArray is %@",TagStringArray);
    NSLog(@"TagStringDataArray is %@",TagStringDataArray);
    NSLog(@"CaptionArray is %@",CaptionArray);
    
    GetTagString = [TagStringDataArray componentsJoinedByString:@","];
    NSString *GetAddress = [defaults objectForKey:@"PublishV2_Location_Address"];
    NSString *GetCity = [defaults objectForKey:@"PublishV2_Location_City"];
    NSString *GetCountry = [defaults objectForKey:@"PublishV2_Location_Country"];
    NSString *GetState = [defaults objectForKey:@"PublishV2_Location_State"];
    NSString *GetpostalCode = [defaults objectForKey:@"PublishV2_Location_PostalCode"];
    NSString *GetreferralId = [defaults objectForKey:@"PublishV2_Location_ReferralId"];
    NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
    NSString *GetNameData = [defaults objectForKey:@"PublishV2_Name"];
    NSString *GetLatData = [defaults objectForKey:@"PublishV2_Lat"];
    NSString *GetLngData = [defaults objectForKey:@"PublishV2_Lng"];
    NSString *GetContactData = [defaults objectForKey:@"PublishV2_Contact"];
    NSString *GetLinkData = [defaults objectForKey:@"PublishV2_Link"];
    NSString *GetTypeData = [defaults objectForKey:@"PublishV2_type"];
    NSString *GetPriceData = [defaults objectForKey:@"PublishV2_Price"];
    NSString *GetPriceNumCodeData = [defaults objectForKey:@"PublishV2_Price_NumCode"];
    NSString *GetSource = [defaults objectForKey:@"PublishV2_Source"];
    NSString *GetPeriod = [defaults objectForKey:@"PublishV2_Period"];
    NSString *GetOpenNow = [defaults objectForKey:@"PublishV2_OpenNow"];
    NSString *GetPlaceID = [defaults objectForKey:@"PublishV2_Location_PlaceId"];
    GetBlogString = [defaults objectForKey:@"PublishV2_BlogLink"];
    
    NSLog(@"GetAddress is %@",GetAddress);
    NSLog(@"GetCity is %@",GetCity);
    NSLog(@"GetCountry is %@",GetCountry);
    NSLog(@"GetState is %@",GetState);
    NSLog(@"GetpostalCode is %@",GetpostalCode);
    NSLog(@"GetreferralId is %@",GetreferralId);
    NSLog(@"GetAddressData is %@",GetAddressData);
    NSLog(@"GetNameData is %@",GetNameData);
    NSLog(@"GetLatData is %@",GetLatData);
    NSLog(@"GetLngData is %@",GetLngData);
    NSLog(@"GetContactData is %@",GetContactData);
    NSLog(@"GetLinkData is %@",GetLinkData);
    NSLog(@"GetTypeData is %@",GetTypeData);
    NSLog(@"GetPriceData is %@",GetPriceData);
    NSLog(@"GetPriceNumCodeData is %@",GetPriceNumCodeData);
    NSLog(@"GetSource is %@",GetSource);
    NSLog(@"GetPeriod is %@",GetPeriod);
    NSLog(@"GetOpenNow is %@",GetOpenNow);
    NSLog(@"GetBlogString is %@",GetBlogString);
    NSLog(@"GetPlaceID is %@",GetPlaceID);
    
    if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
        GetBlogString = @"";
    }
    if ([GetPriceData isEqualToString:@""] || GetPriceData == nil || [GetPriceData isEqualToString:@"(null)"] || [GetPriceData isEqualToString:@"nil"]) {
        GetPriceData = @"";
    }
    if ([GetPriceNumCodeData isEqualToString:@""] || GetPriceNumCodeData == nil || [GetPriceNumCodeData isEqualToString:@"(null)"] || [GetPriceNumCodeData isEqualToString:@"nil"]) {
        GetPriceNumCodeData = @"";
    }
    if ([GetLinkData isEqualToString:@""] || GetLinkData == nil || [GetLinkData isEqualToString:@"(null)"] || [GetLinkData isEqualToString:@"nil"]) {
        GetLinkData = @"";
    }
    if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
        GetreferralId = @"";
    }
    if ([GetContactData isEqualToString:@""] || GetContactData == nil || [GetContactData isEqualToString:@"(null)"] || [GetContactData isEqualToString:@"nil"]) {
        GetContactData = @"";
    }
    if ([GetSource isEqualToString:@""] || GetSource == nil || [GetSource isEqualToString:@"(null)"] || [GetSource isEqualToString:@"nil"]) {
        GetSource = @"";
    }else{
    }

    if ([GetPeriod isEqualToString:@""] || GetPeriod == nil || [GetPeriod isEqualToString:@"(null)"] || [GetPeriod isEqualToString:@"nil"] || [GetPeriod isEqualToString:@"(\n)"]) {
        GetPeriod = @"";
    }else{
    }
    if ([GetOpenNow isEqualToString:@""] || GetOpenNow == nil || [GetOpenNow isEqualToString:@"(null)"] || [GetOpenNow isEqualToString:@"nil"]) {
        GetOpenNow = @"false";
    }else{
        GetOpenNow = @"true";
    }
    
    if ([GetAddress isEqualToString:@""] || GetAddress == nil || [GetAddress isEqualToString:@"(null)"] || [GetAddress isEqualToString:@"nil"]) {
        GetAddress = @"";
    }else{
    }
    if ([GetCity isEqualToString:@""] || GetCity == nil || [GetCity isEqualToString:@"(null)"] || [GetCity isEqualToString:@"nil"]) {
        GetCity = @"";
    }else{
    }
    if ([GetState isEqualToString:@""] || GetState == nil || [GetState isEqualToString:@"(null)"] || [GetState isEqualToString:@"nil"]) {
        GetState = @"";
    }else{
    }
    if ([GetpostalCode isEqualToString:@""] || GetpostalCode == nil || [GetpostalCode isEqualToString:@"(null)"] || [GetpostalCode isEqualToString:@"nil"]) {
        GetpostalCode = @"";
    }else{
    }
    if ([GetCountry isEqualToString:@""] || GetCountry == nil || [GetCountry isEqualToString:@"(null)"] || [GetCountry isEqualToString:@"nil"]) {
        GetCountry = @"";
    }else{
    }
    if ([GetNameData isEqualToString:@""] || GetNameData == nil || [GetNameData isEqualToString:@"(null)"] || [GetNameData isEqualToString:@"nil"]) {
        GetNameData = @"";
    }else{
    }
    if ([GetAddressData isEqualToString:@""] || GetAddressData == nil || [GetAddressData isEqualToString:@"(null)"] || [GetAddressData isEqualToString:@"nil"]) {
        GetAddressData = @"";
    }else{
    }
    if ([GetLatData isEqualToString:@""] || GetLatData == nil || [GetLatData isEqualToString:@"(null)"] || [GetLatData isEqualToString:@"nil"]) {
        GetLatData = @"";
    }else{
    }
    if ([GetLngData isEqualToString:@""] || GetLngData == nil || [GetLngData isEqualToString:@"(null)"] || [GetLngData isEqualToString:@"nil"]) {
        GetLngData = @"";
    }else{
    }
    if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
        GetreferralId = @"";
    }else{
    }
    if ([GetTypeData isEqualToString:@""] || GetTypeData == nil || [GetTypeData isEqualToString:@"(null)"] || [GetTypeData isEqualToString:@"nil"]) {
        GetTypeData = @"";
    }else{
    }
    if ([GetPlaceID isEqualToString:@""] || GetPlaceID == nil || [GetPlaceID isEqualToString:@"(null)"] || [GetPlaceID isEqualToString:@"nil"]) {
        GetPlaceID = @"";
    }else{
    }
    //location json
    //type 1 == foursqure
    if ([GetTypeData isEqualToString:@"1"]) {
        if ([GetPriceNumCodeData isEqualToString:@""]) {
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetLinkData,GetContactData];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }else{
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData];
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
                TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
            }
            
        }else{
            TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
        }
        
        if ([GetPriceNumCodeData isEqualToString:@""]) {
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }else{
            
            
            CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
            NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
        }
        
        
    }
    
    
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    
    [self SendAllDataToServer];
}
-(IBAction)SaveDraftButton:(id)sender{
    

    if (CheckKeyboard == 1) {
        [TitleTextView resignFirstResponder];
        [ExperienceTextView resignFirstResponder];
        if (CheckEdit == 1) {
            [SaveDraftButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
        }else{
        [SaveDraftButton setTitle:CustomLocalisedString(@"SaveasDraft", nil) forState:UIControlStateNormal];
        }
        
    }else{
        if (CheckEdit == 1) {
            [self EditPostDataToServer];
        }else{
            [SaveDraftButton setTitle:CustomLocalisedString(@"SaveasDraft", nil) forState:UIControlStateNormal];
            
            CheckDraft = 0;
            
            
            SaveDraftButton.enabled = NO;
            NextButton.enabled = NO;
            OpenEditPlaceButton.enabled = NO;
            OpenPhotoButton.enabled = NO;
            OpenSubMenuButton.enabled = NO;
            CancelButton.enabled = NO;
            [self SaveDraftDataToServer];
            
        }

    }



}
-(void)SendAllDataToServer{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    LoadingBlackBackground = [[UIButton alloc]init];
    [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
    LoadingBlackBackground.backgroundColor = [UIColor blackColor];
    LoadingBlackBackground.alpha = 0.5f;
    LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:LoadingBlackBackground];
    
    [self.view addSubview:ShowActivity];
    [ShowActivity startAnimating];
    
    ShowLoadingText = [[UILabel alloc]init];
    ShowLoadingText.frame = CGRectMake(0, (screenHeight/2) + 30, screenWidth, 40);
    ShowLoadingText.text = @"Saving...";
    ShowLoadingText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    ShowLoadingText.textColor = [UIColor whiteColor];
    ShowLoadingText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowLoadingText];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    // NSString *GetplaceNameData = [defaults objectForKey:@"PublishV2_Name"];
    
    NSString *urlString;
    if ([GetUpdatePost isEqualToString:@"YES"]) {
        urlString = [NSString stringWithFormat:@"%@/%@",DataUrl.Publish_PostUrl,GetPostID];
    }else{
        urlString = [NSString stringWithFormat:@"%@",DataUrl.Publish_PostUrl];
    }
    
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
    
    NSLog(@"StatusString work");
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
    NSLog(@"title and message work");
   
    if ([CategorySelectIDArray count] == 0) {
         NSLog(@"No Category");
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[0]\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSLog(@"Got Category");
        for (int i = 0; i < [CategorySelectIDArray count]; i++) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",[CategorySelectIDArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
   // NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    NSLog(@"Category work");
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
    
    NSLog(@"blog work");
    if ([GetTagString length] == 0) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetTagString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"tag work");
    NSLog(@"[GetImageArray count] === %lu",(unsigned long)[GetImageArray count]);
    
    NSString *GetDeletePhotoID = [defaults objectForKey:@"PublishV2_PhotoID_Delete"];
    NSLog(@"GetDeletePhotoID is %@",GetDeletePhotoID);
    if ([GetDeletePhotoID isEqualToString:@""] || [GetDeletePhotoID isEqualToString:@"<null>"] || GetDeletePhotoID == nil) {
        NSLog(@"no delete image data");
    }else{
        NSArray *SplitArray = [GetDeletePhotoID componentsSeparatedByString:@","];
        NSLog(@"SplitArray is %@",SplitArray);
        for (int i = 0; i < [SplitArray count]; i++) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"delete_photos[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",[SplitArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
       NSLog(@"Delete image work");
    }
    
    
    if ([GetUpdatePost isEqualToString:@"YES"]) {
        NSString *GetPhotoCount = [defaults objectForKey:@"PublishV2_PhotoCount"];
        NSString *GetPhotoID = [defaults objectForKey:@"PublishV2_PhotoID"];
        NSArray *SplitArray = [GetPhotoID componentsSeparatedByString:@","];
        NSLog(@"GetPhotoCount is %@",GetPhotoCount);
        NSLog(@"GetPhotoID is %@",GetPhotoID);
        
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
                [body appendData:[[NSString stringWithFormat:@"%d",i+1] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *TempGetData = [[NSString alloc]initWithFormat:@"%@",[SendCaptionDataArray objectAtIndex:i]];
                if ([TempGetData isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)] || [TempGetData length] == 0 || [TempGetData isEqualToString:@"(null)"] || [TempGetData isEqualToString:@""]) {
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
        }else{
            NSString *GetPhotoID = [defaults objectForKey:@"PublishV2_PhotoID"];
            NSArray *SplitArray = [GetPhotoID componentsSeparatedByString:@","];
            NSLog(@"Photo ID SplitArray is %@",SplitArray);
            

            NSLog(@"reupload GetImageArray is %@",GetImageArray);
            NSLog(@"reupload GetPhotoID is %@",GetPhotoID);
            NSLog(@"reupload SendCaptionDataArray is %@",SendCaptionDataArray);
            
            
//            NSLog(@"PhotoCountData is %d",PhotoCountData);
//            NSLog(@"before delete GetImageArray == %lu",(unsigned long)[GetImageArray count]);
//            NSLog(@"before delete SendCaptionDataArray == %lu",(unsigned long)[SendCaptionDataArray count]);
//            
//            for (int i = 0; i < PhotoCountData; i++) {
//                NSLog(@"loop");
//                NSLog(@"in loop delete GetImageArray == %lu",(unsigned long)[GetImageArray count]);
//                NSLog(@"in loop delete SendCaptionDataArray == %lu",(unsigned long)[SendCaptionDataArray count]);
//                [GetImageArray removeObjectAtIndex:i];
//                [SendCaptionDataArray removeObjectAtIndex:i];
//                NSLog(@"in loop done delete GetImageArray == %lu",(unsigned long)[GetImageArray count]);
//                NSLog(@"in loop done delete SendCaptionDataArray == %lu",(unsigned long)[SendCaptionDataArray count]);
//                PhotoCountData --;
//            }
//            for (int i = PhotoCountData - 1; i >= 0; i--) {
//                [GetImageArray removeObjectAtIndex:i];
//                [SendCaptionDataArray removeObjectAtIndex:i];
//            }

            for (int i = 0; i < [GetImageArray count]; i++) {
                NSString *CheckPhotoID = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                if ([CheckPhotoID isEqualToString:@""]) {
                    UIImage *GetImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
                    NSData *imageData = UIImagePNGRepresentation(GetImage);
                    
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    //        [body appendData:[@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"Image%i.jpg\"\r\n",i,[i ] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos[%i]\"; filename=\"Image%i.jpg\"\r\n",i,i] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[NSData dataWithData:imageData]];
                    // add it to bodyr
                    [body appendData:imageData];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                }else{
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    //Attaching the key name @"parameter_second" to the post body
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][photo_id]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                    //Attaching the content to be posted ( ParameterSecond )
                    [body appendData:[[NSString stringWithFormat:@"%@",[SplitArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                }

                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][position]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@"%d",i+1] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *TempGetData = [[NSString alloc]initWithFormat:@"%@",[SendCaptionDataArray objectAtIndex:i]];
                NSLog(@"TempGetData is %@",TempGetData);
                if ([TempGetData isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)] || [TempGetData length] == 0 || [TempGetData isEqualToString:@"(null)"] || [TempGetData isEqualToString:@""]) {
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
        }
    }else{
        for (int i = 0; i < [GetImageArray count]; i++) {
            UIImage *GetImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
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
            [body appendData:[[NSString stringWithFormat:@"%d",i+1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *TempGetData = [[NSString alloc]initWithFormat:@"%@",[SendCaptionDataArray objectAtIndex:i]];
            NSLog(@"TempGetData is %@",TempGetData);
            if ([TempGetData isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)] || [TempGetData length] == 0 || [TempGetData isEqualToString:@"(null)"] || [TempGetData isEqualToString:@""]) {
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
       
    }
     NSLog(@"image work");
    
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
    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
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
            if (CheckDraft == 0) {
                
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Draft Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 9999;
                [ShowAlert show];
                
                if ([TitleTextView.text length] == 0) {
                    if ([GetUserLanguage_1 isEqualToString:@"English"]) {
                        TitleTextView.text = @"Write a title... (Optional)";
                    }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
                        TitleTextView.text = @"请输入标题（自选项）";
                    }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
                        TitleTextView.text = @"Tulis judul (Opsional)";
                    }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
                        TitleTextView.text = @"Write a title... (Optional)";

                    }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
                        TitleTextView.text = @"ชื่อเรื่อง";
                    }else{
                        TitleTextView.text = @"Write a title... (Optional)";
                    }
                }
                if ([ExperienceTextView.text length] == 0) {
                    if ([GetUserLanguage_1 isEqualToString:@"English"]) {
                        ExperienceTextView.text = @"Share your experience...";
                    }else if([GetUserLanguage_1 isEqualToString:@"中文"] || [GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]){
                        ExperienceTextView.text = @"推荐文内容...";
                    }else if([GetUserLanguage_1 isEqualToString:@"Bahasa Indonesia"]){
                        ExperienceTextView.text = @"Bagikan pengalaman kamu";
                    }else if([GetUserLanguage_1 isEqualToString:@"Filipino"]){
                        ExperienceTextView.text = @"Share your experience...";
                    }else if([GetUserLanguage_1 isEqualToString:@"ภาษาไทย"]){
                        ExperienceTextView.text = @"แชร์ประสบการณ์";
                    }else{
                        ExperienceTextView.text = @"Share your experience...";
                    }
                }
                

                
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                NSLog(@"PhotoData is %@",PhotoData);
                NSString *result;
                NSString *result2;
                NSString *result3;
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                NSMutableArray *CaptionArray = [[NSMutableArray alloc]init];
                NSMutableArray *PhotoIDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in PhotoData) {
                    NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                    [CaptionArray addObject:caption];
                        
                    NSString *photo_id = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"photo_id"]];
                    [PhotoIDArray addObject:photo_id];
                        
                    NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                    [UrlArray addObject:url];
                }
                result = [CaptionArray componentsJoinedByString:@","];
                result2 = [UrlArray componentsJoinedByString:@","];
                result3 = [PhotoIDArray componentsJoinedByString:@","];
            

                NSLog(@"result CaptionArray is %@",result);
                NSLog(@"result2 UrlArray is %@",result2);
                NSLog(@"result3 PhotoIDArray is  %@",result3);
            
                GetUpdatePost = @"YES";
                GetPostID = [GetAllData valueForKey:@"post_id"];
                NSString *photos_count = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"photos_count"]];
                
                NSLog(@"GetUpdatePost is %@",GetUpdatePost);
                NSLog(@"GetPostID is %@",GetPostID);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:photos_count forKey:@"PublishV2_PhotoCount"];
                [defaults setObject:result3 forKey:@"PublishV2_PhotoID"];
                [defaults synchronize];
                
            }else if(CheckDraft == 1){//back to menu
                CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                
                UITabBarController *tabBarController=[[UITabBarController alloc]init];
                tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
                
                FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
                Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
                
                SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
                
                NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
                
                ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
                
                //adding view controllers to your tabBarController bundling them in an array
                tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
                //tabBarController.selectedIndex = 4;

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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckPhotoCount"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PlaceId"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoPosition"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
                
                //delete Images
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0];
                NSFileManager *fileMgr = [[NSFileManager alloc] init];
                NSError *error = nil;
                NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsPath error:&error];
                if (error == nil) {
                    for (NSString *path in directoryContents) {
                        NSString *fullPath = [documentsPath stringByAppendingPathComponent:path];
                        BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                        if (!removeSuccess) {
                            // Error handling
                            
                        }
                    }
                } else {
                    // Error handling
                    
                }
            }else{
                UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Published Succesfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlertView.tag = 200;
                [ShowAlertView show];
            }

        }else{
            UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Unsuccessful please try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlertView.tag = 300;
            [ShowAlertView show];
        }
        
    }
    SaveDraftButton.enabled = YES;
    NextButton.enabled = YES;
    OpenEditPlaceButton.enabled = YES;
    OpenPhotoButton.enabled = YES;
    OpenSubMenuButton.enabled = YES;
    CancelButton.enabled = YES;
    
    [ShowActivity stopAnimating];

    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
}
-(void)EditPostDataToServer{

    [TitleTextView resignFirstResponder];
    [ExperienceTextView resignFirstResponder];
    NSLog(@"EditPostDataToServer work");
    StatusString = @"1";
    CheckDraft = 1;
    if ([CategorySelectIDArray count] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Must select category" delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        
        if ([ExperienceTextView.text isEqualToString:@"Share your experience..."] || [ExperienceTextView.text isEqualToString:@"推荐文内容..."] || [ExperienceTextView.text isEqualToString:@"Bagikan pengalaman kamu"] || [ExperienceTextView.text isEqualToString:@"แชร์ประสบการณ์"]) {
            ExperienceTextView.text = @"";
        }else{
            
        }
        if ([TitleTextView.text isEqualToString:@"Write a title... (Optional)"] || [TitleTextView.text isEqualToString:@"请输入标题（自选项）"] || [TitleTextView.text isEqualToString:@"Tulis judul (Opsional)"] || [TitleTextView.text isEqualToString:@"ชื่อเรื่อง"]) {
            TitleTextView.text = @"";
        }else{
            
        }
        NSLog(@"TitleArray count %lu",(unsigned long)[TitleArray count]);
        if ([TitleArray count] == 1) {// support two language
            //            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
            //            [TitleArray replaceObjectAtIndex:1 withObject:ChineseTextField.text];
            //
            //            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            //            [MessageArray replaceObjectAtIndex:1 withObject:ChineseExperienceTextView.text];
            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            
            NSLog(@"[TitleArray count] == 1 in here?????");
            
        }else{
            NSLog(@"[TitleArray count] == 2 in here?????");
            
            [TitleArray replaceObjectAtIndex:0 withObject:TitleTextView.text];
            [MessageArray replaceObjectAtIndex:0 withObject:ExperienceTextView.text];
            
            NSString *GetTempString = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:1]];
            if ([GetTempString isEqualToString:@""] || GetTempString == nil || [GetTempString isEqualToString:@"(null)"] || [GetTempString isEqualToString:@"nil"]) {
                [TitleArray removeLastObject];
                [LangIDArray removeLastObject];
                [MessageArray removeLastObject];
                [LangArray removeLastObject];
            }
        }
        
        NSLog(@"TitleArray is %@",TitleArray);
        NSLog(@"MessageArray is %@",MessageArray);
        NSLog(@"LangArray is %@",LangArray);
        NSLog(@"LangIDArray is %@",LangIDArray);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SendCaptionDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionDataArray"]];
        NSMutableArray *TagStringArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringArray"]];
        NSMutableArray *TagStringDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_TagStringDataArray"]];
        NSMutableArray *CaptionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionArray"]];
        
        NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
        NSLog(@"TagStringArray is %@",TagStringArray);
        NSLog(@"TagStringDataArray is %@",TagStringDataArray);
        NSLog(@"CaptionArray is %@",CaptionArray);
        
        if ([SendCaptionDataArray count] == 0) {
            for (int i = 0; i < [GetImageArray count]; i++) {
                [SendCaptionDataArray addObject:@""];
            }
        }
        
        GetTagString = [TagStringDataArray componentsJoinedByString:@","];
        NSString *GetAddress = [defaults objectForKey:@"PublishV2_Location_Address"];
        NSString *GetCity = [defaults objectForKey:@"PublishV2_Location_City"];
        NSString *GetCountry = [defaults objectForKey:@"PublishV2_Location_Country"];
        NSString *GetState = [defaults objectForKey:@"PublishV2_Location_State"];
        NSString *GetpostalCode = [defaults objectForKey:@"PublishV2_Location_PostalCode"];
        NSString *GetreferralId = [defaults objectForKey:@"PublishV2_Location_ReferralId"];
        NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
        NSString *GetNameData = [defaults objectForKey:@"PublishV2_Name"];
        NSString *GetLatData = [defaults objectForKey:@"PublishV2_Lat"];
        NSString *GetLngData = [defaults objectForKey:@"PublishV2_Lng"];
        NSString *GetContactData = [defaults objectForKey:@"PublishV2_Contact"];
        NSString *GetLinkData = [defaults objectForKey:@"PublishV2_Link"];
        NSString *GetTypeData = [defaults objectForKey:@"PublishV2_type"];
        NSString *GetPriceData = [defaults objectForKey:@"PublishV2_Price"];
        NSString *GetPriceNumCodeData = [defaults objectForKey:@"PublishV2_Price_NumCode"];
        NSString *GetSource = [defaults objectForKey:@"PublishV2_Source"];
        NSString *GetPeriod = [defaults objectForKey:@"PublishV2_Period"];
        NSString *GetOpenNow = [defaults objectForKey:@"PublishV2_OpenNow"];
        NSString *GetPlaceID = [defaults objectForKey:@"PublishV2_Location_PlaceId"];
        GetBlogString = [defaults objectForKey:@"PublishV2_BlogLink"];
        
        NSLog(@"GetAddress is %@",GetAddress);
        NSLog(@"GetCity is %@",GetCity);
        NSLog(@"GetCountry is %@",GetCountry);
        NSLog(@"GetState is %@",GetState);
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        NSLog(@"GetreferralId is %@",GetreferralId);
        NSLog(@"GetAddressData is %@",GetAddressData);
        NSLog(@"GetNameData is %@",GetNameData);
        NSLog(@"GetLatData is %@",GetLatData);
        NSLog(@"GetLngData is %@",GetLngData);
        NSLog(@"GetContactData is %@",GetContactData);
        NSLog(@"GetLinkData is %@",GetLinkData);
        NSLog(@"GetTypeData is %@",GetTypeData);
        NSLog(@"GetPriceData is %@",GetPriceData);
        NSLog(@"GetPriceNumCodeData is %@",GetPriceNumCodeData);
        NSLog(@"GetSource is %@",GetSource);
        NSLog(@"GetPeriod is %@",GetPeriod);
        NSLog(@"GetOpenNow is %@",GetOpenNow);
        NSLog(@"GetBlogString is %@",GetBlogString);
        NSLog(@"GetPlaceID is %@",GetPlaceID);
        
        if ([GetBlogString isEqualToString:@""] || GetBlogString == nil || [GetBlogString isEqualToString:@"(null)"] || [GetBlogString isEqualToString:@"nil"]) {
            GetBlogString = @"";
        }
        if ([GetPriceData isEqualToString:@""] || GetPriceData == nil || [GetPriceData isEqualToString:@"(null)"] || [GetPriceData isEqualToString:@"nil"]) {
            GetPriceData = @"";
        }
        if ([GetPriceNumCodeData isEqualToString:@""] || GetPriceNumCodeData == nil || [GetPriceNumCodeData isEqualToString:@"(null)"] || [GetPriceNumCodeData isEqualToString:@"nil"]) {
            GetPriceNumCodeData = @"";
        }
        if ([GetLinkData isEqualToString:@""] || GetLinkData == nil || [GetLinkData isEqualToString:@"(null)"] || [GetLinkData isEqualToString:@"nil"]) {
            GetLinkData = @"";
        }
        if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
            GetreferralId = @"";
        }
        if ([GetContactData isEqualToString:@""] || GetContactData == nil || [GetContactData isEqualToString:@"(null)"] || [GetContactData isEqualToString:@"nil"]) {
            GetContactData = @"";
        }
        if ([GetSource isEqualToString:@""] || GetSource == nil || [GetSource isEqualToString:@"(null)"] || [GetSource isEqualToString:@"nil"]) {
            GetSource = @"";
        }else{
        }
        
        if ([GetPeriod isEqualToString:@""] || GetPeriod == nil || [GetPeriod isEqualToString:@"(null)"] || [GetPeriod isEqualToString:@"nil"] || [GetPeriod isEqualToString:@"(\n)"]) {
            GetPeriod = @"";
        }else{
        }
        if ([GetOpenNow isEqualToString:@""] || GetOpenNow == nil || [GetOpenNow isEqualToString:@"(null)"] || [GetOpenNow isEqualToString:@"nil"]) {
            GetOpenNow = @"false";
        }else{
            GetOpenNow = @"true";
        }
        
        if ([GetAddress isEqualToString:@""] || GetAddress == nil || [GetAddress isEqualToString:@"(null)"] || [GetAddress isEqualToString:@"nil"]) {
            GetAddress = @"";
        }else{
        }
        if ([GetCity isEqualToString:@""] || GetCity == nil || [GetCity isEqualToString:@"(null)"] || [GetCity isEqualToString:@"nil"]) {
            GetCity = @"";
        }else{
        }
        if ([GetState isEqualToString:@""] || GetState == nil || [GetState isEqualToString:@"(null)"] || [GetState isEqualToString:@"nil"]) {
            GetState = @"";
        }else{
        }
        if ([GetpostalCode isEqualToString:@""] || GetpostalCode == nil || [GetpostalCode isEqualToString:@"(null)"] || [GetpostalCode isEqualToString:@"nil"]) {
            GetpostalCode = @"";
        }else{
        }
        if ([GetCountry isEqualToString:@""] || GetCountry == nil || [GetCountry isEqualToString:@"(null)"] || [GetCountry isEqualToString:@"nil"]) {
            GetCountry = @"";
        }else{
        }
        if ([GetNameData isEqualToString:@""] || GetNameData == nil || [GetNameData isEqualToString:@"(null)"] || [GetNameData isEqualToString:@"nil"]) {
            GetNameData = @"";
        }else{
        }
        if ([GetAddressData isEqualToString:@""] || GetAddressData == nil || [GetAddressData isEqualToString:@"(null)"] || [GetAddressData isEqualToString:@"nil"]) {
            GetAddressData = @"";
        }else{
        }
        if ([GetLatData isEqualToString:@""] || GetLatData == nil || [GetLatData isEqualToString:@"(null)"] || [GetLatData isEqualToString:@"nil"]) {
            GetLatData = @"";
        }else{
        }
        if ([GetLngData isEqualToString:@""] || GetLngData == nil || [GetLngData isEqualToString:@"(null)"] || [GetLngData isEqualToString:@"nil"]) {
            GetLngData = @"";
        }else{
        }
        if ([GetreferralId isEqualToString:@""] || GetreferralId == nil || [GetreferralId isEqualToString:@"(null)"] || [GetreferralId isEqualToString:@"nil"]) {
            GetreferralId = @"";
        }else{
        }
        if ([GetTypeData isEqualToString:@""] || GetTypeData == nil || [GetTypeData isEqualToString:@"(null)"] || [GetTypeData isEqualToString:@"nil"]) {
            GetTypeData = @"";
        }else{
        }
        if ([GetPlaceID isEqualToString:@""] || GetPlaceID == nil || [GetPlaceID isEqualToString:@"(null)"] || [GetPlaceID isEqualToString:@"nil"]) {
            GetPlaceID = @"";
        }else{
        }
        //location json
        //type 1 == foursqure
        if ([GetTypeData isEqualToString:@"1"]) {
            if ([GetPriceNumCodeData isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetLinkData,GetContactData];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":\"\",\n  \"opening_hours\":{\"open_now\":\"true\",\"periods\":\"\"}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData];
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
                    TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
                }
                
            }else{
                TempString = [[NSString alloc]initWithFormat:@"{\"open_now\":\"%@\",\"periods\":[%@],\"weekday_text\":[%@]}",GetOpenNow,GetPeriod,GetSource];
            }
            
            if ([GetPriceNumCodeData isEqualToString:@""]) {
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }else{
                
                
                CreateLocationJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"locality\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"postalCode\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"name\": \"%@\",\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"place_id\": \"%@\",\n  \"type\": %@,\n \"expense\":{\"%@\":\"%@\"},\n  \"rating\": 0,\n  \"link\": \"%@\",\n  \"contact_no\": \"%@\",\n  \"source\":%@,\n  \"opening_hours\":{\"open_now\":\"%@\",\"periods\":[%@]}\n}",GetAddress,GetCity,GetState,GetpostalCode,GetCountry,GetNameData,GetAddressData,GetLatData,GetLngData,GetreferralId,GetPlaceID,GetTypeData,GetPriceNumCodeData,GetPriceData,GetLinkData,GetContactData,TempString,GetOpenNow,GetPeriod];
                NSLog(@"CreateLocationJsonString is %@",CreateLocationJsonString);
            }
            
            
        }
        
        
        NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
        
        SaveDraftButton.enabled = NO;
        NextButton.enabled = NO;
        OpenEditPlaceButton.enabled = NO;
        OpenPhotoButton.enabled = NO;
        OpenSubMenuButton.enabled = NO;
        CancelButton.enabled = NO;
        
        
        [self SendAllDataToServer];
    }

}
@end


//PhotoIDArray is (
//                 558d16668acc43a85c8b4574,
//                 558d16668acc43a85c8b457b,
//                 558d16678acc43a85c8b4582
//                 )


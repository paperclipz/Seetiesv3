//
//  PublishViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PublishViewController.h"
#import "ChooseCategoryViewController.h"
#import "SelectPhotosViewController.h"
#import "AddLocationViewController.h"
#import "ExtasViewController.h"
#import "LLARingSpinnerView.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

//#import "MainViewController.h"
#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "PublishMainViewController.h"

#import "FeedV2ViewController.h"
@interface PublishViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64);
    
    DataUrl = [[UrlDataClass alloc]init];
    
    TitleField.delegate = self;
    DescriptionField.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    NSLog(@"LanguageID_Array is %@",LanguageID_Array);
    NSLog(@"LanguageName_Array is %@",LanguageName_Array);
//
//    LangIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
//    LangArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    NSString *GetUserLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language1"]];
    NSString *GetUserLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_Language2"]];
    
    if ([GetUserLanguage_1 isEqualToString:@"简体中文"] || [GetUserLanguage_1 isEqualToString:@"繁體中文"]) {
        GetUserLanguage_1 = @"中文";
    }
    
    if ([GetUserLanguage_2 isEqualToString:@"简体中文"] || [GetUserLanguage_2 isEqualToString:@"繁體中文"]) {
        GetUserLanguage_2 = @"中文";
    }
    
    NSLog(@"GetUserLanguage_1 is %@",GetUserLanguage_1);
    NSLog(@"GetUserLanguage_2 is %@",GetUserLanguage_2);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    LangIDArray = [[NSMutableArray alloc]init];
    LangArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [LanguageName_Array count]; i++) {

        NSString *GetTempLang = [[NSString alloc]initWithFormat:@"%@",[LanguageName_Array objectAtIndex:i]];
        NSString *GetTempLangID = [[NSString alloc]initWithFormat:@"%@",[LanguageID_Array objectAtIndex:i]];
        
        if ([GetTempLang isEqualToString:@"简体中文"] || [GetTempLang isEqualToString:@"繁體中文"] || [GetTempLang isEqualToString:@"中文"]) {
            GetTempLang = @"中文";
        }
        
        if ([GetUserLanguage_1 isEqualToString:GetTempLang] || [GetUserLanguage_2 isEqualToString:GetTempLang]) {
            [LangArray addObject:GetTempLang];
            [LangIDArray addObject:GetTempLangID];
            
        }else{

        
        }
    }
    
    NSLog(@"LangArray is %@",LangArray);
    NSLog(@"LangIDArray is %@",LangIDArray);
//    [LangArray addObject:@"English"];
//    [LangArray addObject:@"中文"];
//    
//    [LangIDArray addObject:@"530b0ab26424400c76000003"];
//    [LangIDArray addObject:@"530b0aa16424400c76000002"];
    
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,320, 44)];
    // Toolbar.barStyle = UIBarStyleDefault;
    Toolbar.translucent=NO;
    Toolbar.barTintColor=[UIColor whiteColor];
    Lang_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, 320, 216)];
    //Industry_PickerView.tag = 1;
    Lang_PickerView.backgroundColor = [UIColor whiteColor];
    [ShowSelectLangView addSubview:Lang_PickerView];
    Lang_PickerView.delegate = self;
    Lang_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    [ShowSelectLangView addSubview:Toolbar];
    
    
    GetLang = [defaults objectForKey:@"SelectLanguage"];
    GetLangID = [defaults objectForKey:@"SelectLanguageID"];
    NSLog(@"GetLang is %@",GetLang);
    if ([GetLang length] == 0) {

        
        ShowSelectLangView.hidden = NO;
        [self.view addSubview:ShowSelectLangView];
        
         ShowSelectLangImage.hidden = YES;
    }else{
        ShowTitle.text = GetLang;
        if ([GetLang isEqualToString:@"English"]) {
            TitleField.placeholder = @"Write a title";
            DescriptionField.text = @"How was your experience?";
        }else if([GetLang isEqualToString:@"中文"]){
            TitleField.placeholder = @"标题";
            DescriptionField.text = @"说明 & 经验";
        }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
            TitleField.placeholder = @"Tulis Judul";
            DescriptionField.text = @"Deskripsi dan pengalaman";
        }else if([GetLang isEqualToString:@"Filipino"]){
            TitleField.placeholder = @"Magsulat ng pamagat";
            DescriptionField.text = @"Pagsasalarawan at mga karanasan";
        }else if([GetLang isEqualToString:@"ภาษาไทย"]){
            TitleField.placeholder = @"เขียนชื่อเรื่อง";
            DescriptionField.text = @"รีวิว";
        }
         ShowSelectLangImage.hidden = NO;
    }
    
    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
    [ShowImage setClipsToBounds:YES];
    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowImage.layer.cornerRadius=8;
    ShowImage.layer.masksToBounds = YES;
    
    [MainScroll setScrollEnabled:YES];
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(320, 568)];
    
    [ExtrasButton setTitle:CustomLocalisedString(@"Extras", nil) forState:UIControlStateNormal];
    [PublishButton setTitle:CustomLocalisedString(@"Publish", nil) forState:UIControlStateNormal];
    SelectPhotoText.text = CustomLocalisedString(@"SelectPhotos", nil);


}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish Page";
    NSLog(@"Publish viewWillAppear");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetSelectCategoryString = [defaults objectForKey:@"CategorySelected"];
    if ([GetSelectCategoryString length] == 0) {
        ShowCategoryImage.hidden = YES;
        ShowSelectCategoryImage.hidden = YES;
       // ShowCooseCategoryText.text = @"Choose a category";
        ShowCooseCategoryText.text = CustomLocalisedString(@"Chooseacategory", nil);
    }else{
        ShowCategoryImage.hidden = NO;
        ShowSelectCategoryImage.hidden = NO;
      //  ShowCooseCategoryText.text = GetSelectCategoryString;
        if ([GetSelectCategoryString isEqualToString:@"Art & Entertainment"]) {
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Art&Entertainment.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Art", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Beauty & Fashion"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Beauty&Fashion.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Beauty", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Food & Drink"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Food&Drink.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Food", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Kitchen Recipe"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_KitchenRecipe.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Kitchen", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Nightlife"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Nightlife.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Nightlife", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Outdoor & Sport"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Outdoor&Sport.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Outdoor", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Product"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Product.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Product", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Staycation"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Staycation.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Staycation", nil);
        }else if([GetSelectCategoryString isEqualToString:@"Culture & Attraction"] || [GetSelectCategoryString isEqualToString:@"Culture & Landmark"]){
            ShowCategoryImage.image = [UIImage imageNamed:@"Icon_Culture&Attraction.png"];
            ShowCooseCategoryText.text = CustomLocalisedString(@"Culture", nil);
        }
    }
    
    NSMutableArray *TempImgArray = [defaults objectForKey:@"SelectImageData"];
   // NSLog(@"TempImgArray is %@",TempImgArray);
    GetImgArray = [[NSMutableArray alloc]initWithArray:TempImgArray];
   // NSLog(@"GetImgArray is %@",GetImgArray);
    if ([GetImgArray count] == 0) {
        ShowImgCount.hidden = YES;
    }else{
       // ShowImage.image = [GetImgArray objectAtIndex:0];
        ShowImage.image = [self decodeBase64ToImage:[GetImgArray objectAtIndex:0]];
        ShowImgCount.hidden = NO;
        NSString *GetImgCount = [[NSString alloc]initWithFormat:@"%lu photos uploaded",(unsigned long)[GetImgArray count]];
        [ShowImgCount setTitle:GetImgCount forState:UIControlStateNormal];
    }
    
    NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
    NSString *GetLocationAddress = [defaults objectForKey:@"Location_Address"];
    if ([GetLocationPlaceName length] == 0) {
        NSLog(@"GetLocationPlaceName 1");
        ShowTitleName.text = CustomLocalisedString(@"Addlocation", nil);
        [AddLocationButton setImage:[UIImage imageNamed:@"Publish_Back_3.png"] forState:UIControlStateNormal];
        AddLocationButton.frame = CGRectMake(10, 398, 300, 44);
        ShowTitleName.frame = CGRectMake(61, 398, 300, 44);
        ExtrasButton.frame = CGRectMake(8, 450, 300, 44);
        ExtrasGotDataImg_2.frame = CGRectMake(281, 459, 25, 25);
        [MainScroll setContentSize:CGSizeMake(320, 568)];
        ShowAddress.hidden = YES;
    }else{
        NSLog(@"GetLocationPlaceName 2");
        ShowTitleName.text = GetLocationPlaceName;
        ShowAddress.text = GetLocationAddress;
        
        [AddLocationButton setImage:[UIImage imageNamed:@"Publish_Back_3.1.png"] forState:UIControlStateNormal];
        AddLocationButton.frame = CGRectMake(10, 398, 300, 86);
        ShowTitleName.frame = CGRectMake(61, 398, 200, 43);
        ShowAddress.frame = CGRectMake(61, 441, 300, 42);
        ExtrasButton.frame = CGRectMake(8, 492, 300, 44);
        ExtrasGotDataImg_2.frame = CGRectMake(281, 501, 25, 25);
        [MainScroll setContentSize:CGSizeMake(320, 600)];
    }
    
    NSString *GetLinkString = [defaults objectForKey:@"Extras_Link"];
    NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
    if ([GetLinkString length] == 0 && [GetTagString length] == 0) {
        ExtrasGotDataImg_2.hidden = YES;
    }else{
        ExtrasGotDataImg_2.hidden = NO;
    }
    
    NSString *GetTempTitle = [defaults objectForKey:@"Publish_Title"];
    NSString *GetTempDescription = [defaults objectForKey:@"Publish_Description"];
    NSString *GetTampLang = [defaults objectForKey:@"SelectLanguage"];
    if ([GetTampLang length] == 0) {

    }else{

        ShowTitle.text = GetTampLang;
        if ([GetTampLang isEqualToString:@"English"]) {
            if ([GetTempTitle length] == 0) {
                TitleField.placeholder = @"Write a title";
            }else{
                TitleField.text = GetTempTitle;
            }
            if ([GetTempDescription length] == 0) {
                DescriptionField.text = @"How was your experience?";
            }else{
                DescriptionField.text = GetTempDescription;
                DescriptionField.textColor = [UIColor blackColor];
                NSUInteger len = DescriptionField.text.length;
                ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
            }
        }else if ([GetTampLang isEqualToString:@"中文"]){
            if ([GetTempTitle length] == 0) {
                TitleField.placeholder = @"标题";
                
            }else{
                TitleField.text = GetTempTitle;

            }
            if ([GetTempDescription length] == 0) {
                DescriptionField.text = @"说明 & 经验";
            }else{
                DescriptionField.text = GetTempDescription;
                DescriptionField.textColor = [UIColor blackColor];
                NSUInteger len = DescriptionField.text.length;
                ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
            }
        }else if ([GetTampLang isEqualToString:@"Bahasa Indonesia"]){
            if ([GetTempTitle length] == 0) {
                TitleField.placeholder = @"Tulis Judul";
                
            }else{
                TitleField.text = GetTempTitle;

            }
            if ([GetTempDescription length] == 0) {
                DescriptionField.text = @"Deskripsi dan pengalaman";
            }else{
                DescriptionField.text = GetTempDescription;
                DescriptionField.textColor = [UIColor blackColor];
                NSUInteger len = DescriptionField.text.length;
                ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
            }
        }else if ([GetTampLang isEqualToString:@"Filipino"]){
            if ([GetTempTitle length] == 0) {
                TitleField.placeholder = @"Magsulat ng pamagat";
                
            }else{
                TitleField.text = GetTempTitle;

            }
            if ([GetTempDescription length] == 0) {
                DescriptionField.text = @"Pagsasalarawan at mga karanasan";
            }else{
                DescriptionField.text = GetTempDescription;
                DescriptionField.textColor = [UIColor blackColor];
                NSUInteger len = DescriptionField.text.length;
                ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
            }
        }else if ([GetTampLang isEqualToString:@"ภาษาไทย"]){
            if ([GetTempTitle length] == 0) {
                TitleField.placeholder = @"เขียนชื่อเรื่อง";
                
            }else{
                TitleField.text = GetTempTitle;

            }
            if ([GetTempDescription length] == 0) {
                DescriptionField.text = @"รีวิว";
            }else{
                DescriptionField.text = GetTempDescription;
                DescriptionField.textColor = [UIColor blackColor];
                NSUInteger len = DescriptionField.text.length;
                ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
            }
        }
    }
    if([DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height!=DescriptionField.frame.size.height)
    {
        //change this to reflect the constraints of your UITextView
        DescriptionField.frame = CGRectMake(17, 258, 295,[DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height);
        NSLog(@"textView is %f",DescriptionField.frame.size.height);
        if (DescriptionField.frame.size.height  > 112) {
            ShowTextCount.frame = CGRectMake(90, 258 +[DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 258 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {
                NSLog(@"in here? 1");
                AddLocationButton.frame = CGRectMake(10, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 216, 44);
                ExtrasButton.frame = CGRectMake(8, 348 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 357 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 400 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }else{
                NSLog(@"in here? 2");
                AddLocationButton.frame = CGRectMake(10, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 216, 43);
                ShowAddress.frame = CGRectMake(61, 339 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 390 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 399 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 442 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }
        }else{
            ShowTextCount.frame = CGRectMake(90, 360, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 360, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {
                NSLog(@"in here? 3");
                AddLocationButton.frame = CGRectMake(10, 398, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 398, 216, 44);
                ExtrasButton.frame = CGRectMake(8, 450, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 459, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 568)];
            }else{
                NSLog(@"in here? 4");
                AddLocationButton.frame = CGRectMake(10, 398, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 398, 216, 43);
                ShowAddress.frame = CGRectMake(61, 441, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 492, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 501, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 600)];
            }
            
        }
    }else{
        //change this to reflect the constraints of your UITextView
        DescriptionField.frame = CGRectMake(17, 258, 295,[DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height);
        NSLog(@"textView is %f",DescriptionField.frame.size.height);
        if (DescriptionField.frame.size.height  > 112) {
            ShowTextCount.frame = CGRectMake(90, 258 +[DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 258 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {
                NSLog(@"in here? 1");
                AddLocationButton.frame = CGRectMake(10, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 216, 44);
                ExtrasButton.frame = CGRectMake(8, 348 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 357 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 400 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }else{
                NSLog(@"in here? 2");
                AddLocationButton.frame = CGRectMake(10, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 296 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 216, 43);
                ShowAddress.frame = CGRectMake(61, 339 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 390 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 399 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 442 + [DescriptionField sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }
        }else{
            ShowTextCount.frame = CGRectMake(90, 360, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 360, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {
                NSLog(@"in here? 3");
                AddLocationButton.frame = CGRectMake(10, 398, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 398, 216, 44);
                ExtrasButton.frame = CGRectMake(8, 450, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 459, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 568)];
            }else{
                NSLog(@"in here? 4");
                AddLocationButton.frame = CGRectMake(10, 398, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 398, 216, 43);
                ShowAddress.frame = CGRectMake(61, 441, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 492, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 501, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 600)];
            }
            
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [TitleField resignFirstResponder];
    [DescriptionField resignFirstResponder];
}
-(IBAction)DoneSelect:(id)sender
{
    [Lang_PickerView removeFromSuperview];
    [Toolbar removeFromSuperview];
    ShowSelectLangView.hidden = YES;
    if ([GetLang length] == 0) {
        GetLang = [LangArray objectAtIndex:0];
        GetLangID = [LangIDArray objectAtIndex:0];
        ShowTitle.text = GetLang;
        
        if ([TitleField.placeholder isEqualToString:@"Write a title"] || [TitleField.placeholder isEqualToString:@"标题"] || [TitleField.placeholder isEqualToString:@"Tulis Judul"] || [TitleField.placeholder isEqualToString:@"Magsulat ng pamagat"] || [TitleField.placeholder isEqualToString:@"เขียนชื่อเรื่อง"]) {
            if ([GetLang isEqualToString:@"English"]) {
                TitleField.placeholder = @"Write a title";
            }else if([GetLang isEqualToString:@"中文"]){
                TitleField.placeholder = @"标题";
            }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
                TitleField.placeholder = @"Tulis Judul";
            }else if([GetLang isEqualToString:@"Filipino"]){
                TitleField.placeholder = @"Magsulat ng pamagat";
            }else if([GetLang isEqualToString:@"ภาษาไทย"]){
            }
        }
        
        if ([DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
            if ([GetLang isEqualToString:@"English"]) {
                DescriptionField.text = @"How was your experience?";
            }else if([GetLang isEqualToString:@"中文"]){
                DescriptionField.text = @"说明 & 经验";
            }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
                DescriptionField.text = @"Deskripsi dan pengalaman";
            }else if([GetLang isEqualToString:@"Filipino"]){
                DescriptionField.text = @"Pagsasalarawan at mga karanasan";
            }else if([GetLang isEqualToString:@"ภาษาไทย"]){
                DescriptionField.text = @"รีวิว";
            }
        }
//        
//        if ([GetLang isEqualToString:@"English"]) {
//            TitleField.placeholder = @"Write a title";
//            DescriptionField.text = @"How was your experience?";
//        }else if([GetLang isEqualToString:@"中文"]){
//            TitleField.placeholder = @"标题";
//            DescriptionField.text = @"说明 & 经验";
//        }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
//            TitleField.placeholder = @"Tulis Judul";
//            DescriptionField.text = @"Deskripsi dan pengalaman";
//        }else if([GetLang isEqualToString:@"Filipino"]){
//            TitleField.placeholder = @"Magsulat ng pamagat";
//            DescriptionField.text = @"Pagsasalarawan at mga karanasan";
//        }else if([GetLang isEqualToString:@"ภาษาไทย"]){
//            TitleField.placeholder = @"เขียนชื่อเรื่อง";
//            DescriptionField.text = @"รีวิว";
//        }
    }else{
        ShowTitle.text = GetLang;
        if ([TitleField.placeholder isEqualToString:@"Write a title"] || [TitleField.placeholder isEqualToString:@"标题"] || [TitleField.placeholder isEqualToString:@"Tulis Judul"] || [TitleField.placeholder isEqualToString:@"Magsulat ng pamagat"] || [TitleField.placeholder isEqualToString:@"เขียนชื่อเรื่อง"]) {
            if ([GetLang isEqualToString:@"English"]) {
                TitleField.placeholder = @"Write a title";
            }else if([GetLang isEqualToString:@"中文"]){
                TitleField.placeholder = @"标题";
            }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
                TitleField.placeholder = @"Tulis Judul";
            }else if([GetLang isEqualToString:@"Filipino"]){
                TitleField.placeholder = @"Magsulat ng pamagat";
            }else if([GetLang isEqualToString:@"ภาษาไทย"]){
            }
        }
        
        if ([DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
            if ([GetLang isEqualToString:@"English"]) {
                DescriptionField.text = @"How was your experience?";
            }else if([GetLang isEqualToString:@"中文"]){
                DescriptionField.text = @"说明 & 经验";
            }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
                DescriptionField.text = @"Deskripsi dan pengalaman";
            }else if([GetLang isEqualToString:@"Filipino"]){
                DescriptionField.text = @"Pagsasalarawan at mga karanasan";
            }else if([GetLang isEqualToString:@"ภาษาไทย"]){
                DescriptionField.text = @"รีวิว";
            }
        }
//        if ([GetLang isEqualToString:@"English"]) {
//            TitleField.placeholder = @"Write a title";
//            DescriptionField.text = @"How was your experience?";
//        }else if([GetLang isEqualToString:@"中文"]){
//            TitleField.placeholder = @"标题";
//            DescriptionField.text = @"说明 & 经验";
//        }else if([GetLang isEqualToString:@"Bahasa Indonesia"]){
//            TitleField.placeholder = @"Tulis Judul";
//            DescriptionField.text = @"Deskripsi dan pengalaman";
//        }else if([GetLang isEqualToString:@"Filipino"]){
//            TitleField.placeholder = @"Magsulat ng pamagat";
//            DescriptionField.text = @"Pagsasalarawan at mga karanasan";
//        }else if([GetLang isEqualToString:@"ภาษาไทย"]){
//            TitleField.placeholder = @"เขียนชื่อเรื่อง";
//            DescriptionField.text = @"รีวิว";
//        }
    }
    ShowSelectLangImage.hidden = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetLang forKey:@"SelectLanguage"];
    [defaults setObject:GetLangID forKey:@"SelectLanguageID"];
    [defaults synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    
    UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"SaveasDraft", nil) message:CustomLocalisedString(@"Doyouwantsave", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"Discard", nil) otherButtonTitles:CustomLocalisedString(@"EditProfileSave", nil), nil];
    ShowAlertView.tag = 100;
    [ShowAlertView show];
    


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"PhotoLibrary",nil)]) {
            NSLog(@"Photo Library");
            SelectPhotosViewController *SelectPhotosView = [[SelectPhotosViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SelectPhotosView animated:NO completion:nil];
            [SelectPhotosView GetType:@"Photo Library"];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Camera",nil)]) {
            NSLog(@"Camera");
            SelectPhotosViewController *SelectPhotosView = [[SelectPhotosViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SelectPhotosView animated:NO completion:nil];
            [SelectPhotosView GetType:@"Camera"];
        }
        
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel",nil)]) {
            NSLog(@"Cancel Button");
        }
    }
    
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID{

    UpdatePostCheck = UpdatePost;
    GetPostID = PostID;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.2;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            //[self presentViewController:ListingDetail animated:NO completion:nil];
//            [self dismissViewControllerAnimated:NO completion:nil];
            
            UITabBarController *tabBarController=[[UITabBarController alloc]init];
            [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
            //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
            UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
            [[UITabBar appearance] setShadowImage:tabBarBackground];
            [[UITabBar appearance] setBackgroundImage:tabBarBackground];
            
            
            FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
            firstViewController.title= CustomLocalisedString(@"MainTab_Feed",nil);
            firstViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarFeed.png"];
            
            Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
            secondViewController.title= CustomLocalisedString(@"MainTab_Explore",nil);
            secondViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarExplore.png"];
            
            PublishMainViewController *threeViewController=[[PublishMainViewController alloc]initWithNibName:@"PublishMainViewController" bundle:nil];
            //threeViewController.title=@"";
            //threeViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarPublish.png"];
            
            NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
            fourViewController.title= CustomLocalisedString(@"MainTab_Like",nil);
            fourViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarLikes.png"];
            
            ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
            fiveViewController.title= CustomLocalisedString(@"MainTab_Profile",nil);
            fiveViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarProfile.png"];
            
            //adding view controllers to your tabBarController bundling them in an array
            tabBarController.viewControllers=[NSArray arrayWithObjects:firstViewController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
            
            
            //[self presentModalViewController:tabBarController animated:YES];
            [self presentViewController:tabBarController animated:NO completion:nil];
            
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CategorySelected"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Lat"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Long"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_PlaceName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Address"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Link"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Tag"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_ShareFB"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Title"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Description"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectImageData"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Json"];
            

        }else{
            //reset clicked
            NSLog(@"Save button click.");
            StatusString = @"0";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetSelectCategoryString = [defaults objectForKey:@"CategorySelected"];
            NSString *GetSelectCategoryIDN = [defaults objectForKey:@"CategorySelectedIDN"];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            NSString *GetLocationAddress = [defaults objectForKey:@"Location_Address"];
            NSString *GetLinkString = [defaults objectForKey:@"Extras_Link"];
            NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
            NSString *GetShareFB = [defaults objectForKey:@"Extras_ShareFB"];
            NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
            //NSMutableArray *GetImageArray = [defaults objectForKey:@"SelectImageData"];
            
            NSLog(@"GetExpertToken is %@",GetExpertToken);
            NSLog(@"Category Name is %@",GetSelectCategoryString);
            NSLog(@"Category IDN is %@",GetSelectCategoryIDN);
            NSLog(@"Title data is %@",TitleField.text);
            NSLog(@"Description data is %@",DescriptionField.text);
            NSLog(@"LocationPlaceName is %@",GetLocationPlaceName);
            NSLog(@"LocationAddress is %@",GetLocationAddress);
            NSLog(@"Extras Link String is %@",GetLinkString);
            NSLog(@"Extras tag String is %@",GetTagString);
            NSLog(@"Extras Share FB is %@",GetShareFB);
            [self PostAllDataToServer];
        }
    }else if(alertView.tag == 200){
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            UITabBarController *tabBarController=[[UITabBarController alloc]init];
            [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
            //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
            UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
            [[UITabBar appearance] setShadowImage:tabBarBackground];
            [[UITabBar appearance] setBackgroundImage:tabBarBackground];
            
            
            FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
            firstViewController.title= CustomLocalisedString(@"MainTab_Feed",nil);
            firstViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarFeed.png"];
            
            Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
            secondViewController.title= CustomLocalisedString(@"MainTab_Explore",nil);
            secondViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarExplore.png"];
            
            PublishMainViewController *threeViewController=[[PublishMainViewController alloc]initWithNibName:@"PublishMainViewController" bundle:nil];
            //threeViewController.title=@"";
            //threeViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarPublish.png"];
            
            NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
            fourViewController.title= CustomLocalisedString(@"MainTab_Like",nil);
            fourViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarLikes.png"];
            
            ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
            fiveViewController.title= CustomLocalisedString(@"MainTab_Profile",nil);
            fiveViewController.tabBarItem.image=[UIImage imageNamed:@"TabBarProfile.png"];
            
            //adding view controllers to your tabBarController bundling them in an array
            tabBarController.viewControllers=[NSArray arrayWithObjects:firstViewController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
            
            
            //[self presentModalViewController:tabBarController animated:YES];
            [self presentViewController:tabBarController animated:NO completion:nil];

            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CategorySelected"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Lat"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Long"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_PlaceName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Address"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Link"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Tag"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_ShareFB"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Title"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Description"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectImageData"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Json"];
            
            
            NSString *CheckPost = [[NSString alloc]initWithFormat:@"Done"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckPost forKey:@"CheckPost"];
            [defaults synchronize];
        }else{
            //reset clicked
            NSLog(@"Save button click.");
        }
    }else{
    
    }

}
-(IBAction)SelectCategoryButton:(id)sender{
    [TitleField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    ChooseCategoryViewController *ChooseCategoryView = [[ChooseCategoryViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ChooseCategoryView animated:NO completion:nil];
}
-(IBAction)SelectImagesButton:(id)sender{
    [TitleField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:TitleField.text forKey:@"Publish_Title"];
    [defaults setObject:DescriptionField.text forKey:@"Publish_Description"];
    [defaults synchronize];
//    SelectPhotosViewController *SelectPhotosView = [[SelectPhotosViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:SelectPhotosView animated:NO completion:nil];
    NSLog(@"UpdatePostCheck in selectimgbutton is %@",UpdatePostCheck);
    if ([UpdatePostCheck isEqualToString:@"YES"]) {
        SelectPhotosViewController *SelectPhotosView = [[SelectPhotosViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SelectPhotosView animated:NO completion:nil];
        [SelectPhotosView GetImgArray:GetImgArray];
       // [SelectPhotosView GetType:@"Photo Library"];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CustomLocalisedString(@"Howdoyouwanttodoaddimage",nil)
                                                                 delegate:self
                                                        cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel",nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:CustomLocalisedString(@"PhotoLibrary",nil),CustomLocalisedString(@"Camera",nil), nil];
        
        [actionSheet showInView:self.view];
        
        actionSheet.tag = 100;
    }

}
-(IBAction)AddLocationButton:(id)sender{
    [TitleField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:TitleField.text forKey:@"Publish_Title"];
    [defaults setObject:DescriptionField.text forKey:@"Publish_Description"];
    [defaults synchronize];
    
    AddLocationViewController *AddLocationView = [[AddLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:AddLocationView animated:NO completion:nil];
}
-(IBAction)ExtrasButton:(id)sender{
    [TitleField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:TitleField.text forKey:@"Publish_Title"];
    [defaults setObject:DescriptionField.text forKey:@"Publish_Description"];
    [defaults synchronize];
    
//    ExtasViewController *ExtasView = [[ExtasViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExtasView animated:NO completion:nil];
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [LangArray count];
}
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"GetLang is %@",[LangArray objectAtIndex:row]);
    GetLang = [LangArray objectAtIndex:row];
    GetLangID = [LangIDArray objectAtIndex:row];
    NSLog(@"GetLangID is %@",GetLangID);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [LangArray objectAtIndex:row];
}
-(IBAction)SelectLangButton:(id)sender{
    NSLog(@"Select Langauge Button");
    //[TitleField resignFirstResponder];
  //  [DescriptionField resignFirstResponder];
    ShowSelectLangView.hidden = NO;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    GetLang = @"";
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,320, 44)];
    Toolbar.translucent=NO;
    Toolbar.barTintColor=[UIColor whiteColor];
    Lang_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, 320, 216)];
    //Industry_PickerView.tag = 1;
    Lang_PickerView.backgroundColor = [UIColor whiteColor];
    [ShowSelectLangView addSubview:Lang_PickerView];
    Lang_PickerView.delegate = self;
    Lang_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    [ShowSelectLangView addSubview:Toolbar];
    [self.view addSubview:ShowSelectLangView];

    
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{

    
    NSLog(@"did begin editing");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetTempDescription = [defaults objectForKey:@"Publish_Description"];
    NSLog(@"GetTempDescription is %@",GetTempDescription);
    if ([GetTempDescription length]  == 0 || [GetTempDescription isEqualToString:@"How was your experience?"] || [GetTempDescription isEqualToString:@"说明 & 经验"] || [GetTempDescription isEqualToString:@"Deskripsi dan pengalaman"] ||[GetTempDescription isEqualToString:@"Pagsasalarawan at mga karanasan"] || [GetTempDescription isEqualToString:@"รีวิว"]) {
        if ([DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
            DescriptionField.text = @"";
        }else{
        
        }
        
    }else{
    
    }
    
    DescriptionField.textColor = [UIColor blackColor];
}
-(void)textViewDidChange:(UITextView *)textView
{

    DescriptionField.textColor = [UIColor blackColor];
    NSUInteger len = textView.text.length;
    ShowTextCount.text=[NSString stringWithFormat:@"(300- 1000 characters) %lu remaining",1000 - len];
    //We enter this method AFTER the edit has been drawn to the screen, therefore check to see if we should shrink.
    if([textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height!=textView.frame.size.height)
    {
        //change this to reflect the constraints of your UITextView
        textView.frame = CGRectMake(17, 258, 295,[textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height);
        NSLog(@"textView is %f",textView.frame.size.height);
        if (textView.frame.size.height  > 112) {
            ShowTextCount.frame = CGRectMake(90, 258 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 258 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {
                AddLocationButton.frame = CGRectMake(10, 296 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 296 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasButton.frame = CGRectMake(8, 348 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 357 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 400 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }else{
                AddLocationButton.frame = CGRectMake(10, 296 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 296 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 43);
                ShowAddress.frame = CGRectMake(61, 339 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 390 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 399 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 442 + [textView sizeThatFits:CGSizeMake(295, CGFLOAT_MAX)].height)];
            }
        }else{
            ShowTextCount.frame = CGRectMake(90, 360, 222, 21);
            Publish_Back_2.frame = CGRectMake(11, 360, 300, 27);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
            if ([GetLocationPlaceName length] == 0) {

                AddLocationButton.frame = CGRectMake(10, 398, 300, 44);
                ShowTitleName.frame = CGRectMake(61, 398, 300, 44);
                ExtrasButton.frame = CGRectMake(8, 450, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 459, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 568)];
            }else{
                AddLocationButton.frame = CGRectMake(10, 398, 300, 86);
                ShowTitleName.frame = CGRectMake(61, 398, 300, 43);
                ShowAddress.frame = CGRectMake(61, 441, 300, 42);
                ExtrasButton.frame = CGRectMake(8, 492, 300, 44);
                ExtrasGotDataImg_2.frame = CGRectMake(281, 501, 25, 25);
                [MainScroll setContentSize:CGSizeMake(320, 600)];
            }

        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 1000)
    {
        return NO;
    }
    return YES;
}

-(IBAction)PublishButton:(id)sender{
    NSLog(@"Publish Button Click.");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetSelectCategoryString = [defaults objectForKey:@"CategorySelected"];
    NSString *GetSelectCategoryIDN = [defaults objectForKey:@"CategorySelectedIDN"];
    NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
    NSString *GetLocationAddress = [defaults objectForKey:@"Location_Address"];
    NSString *GetLinkString = [defaults objectForKey:@"Extras_Link"];
    NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
    NSString *GetShareFB = [defaults objectForKey:@"Extras_ShareFB"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //NSMutableArray *GetImageArray = [defaults objectForKey:@"SelectImageData"];
    
    NSLog(@"GetExpertToken is %@",GetExpertToken);
    NSLog(@"Category Name is %@",GetSelectCategoryString);
    NSLog(@"Category IDN is %@",GetSelectCategoryIDN);
    NSLog(@"Title data is %@",TitleField.text);
    NSLog(@"Description data is %@",DescriptionField.text);
    NSLog(@"LocationPlaceName is %@",GetLocationPlaceName);
    NSLog(@"LocationAddress is %@",GetLocationAddress);
    NSLog(@"Extras Link String is %@",GetLinkString);
    NSLog(@"Extras tag String is %@",GetTagString);
    NSLog(@"Extras Share FB is %@",GetShareFB);
    //NSLog(@"GetImageArray is %@",GetImageArray);
    
    //‘token’,’message', 'status', 'category', 'location', 'place_name', 'photos', 'link','title','device_type','tags'
    //status = 0 draft
    //status = 1 post
    // device_type = 2
    //title and message is array
    

    
    if ([GetSelectCategoryString isEqualToString:@"(null)"] || [GetSelectCategoryString length] == 0 || [TitleField.text length] == 0 || [DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
        //check category
        //check title
        //check description
        
    }else{
        StatusString = @"1";
        [self PostAllDataToServer];
    }
    

    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [TitleField resignFirstResponder];
    return YES;
}
-(void)PostAllDataToServer{

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    self.spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.spinnerView.lineWidth = 1.0f;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    
    if ([UpdatePostCheck isEqualToString:@"YES"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // NSString *GetSelectCategoryString = [defaults objectForKey:@"CategorySelected"];
        NSLog(@"GetLangID is %@",GetLangID);
        NSString *GetSelectCategoryIDN = [defaults objectForKey:@"CategorySelectedIDN"];
        NSLog(@"GetSelectCategoryIDN is %@",GetSelectCategoryIDN);
        NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
        NSString *GetLocationAddress = [defaults objectForKey:@"Location_Json"];
        NSLog(@"GetLocationAddress is %@",GetLocationAddress);
        NSString *GetLinkString = [defaults objectForKey:@"Extras_Link"];
        NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
        // NSString *GetShareFB = [defaults objectForKey:@"Extras_ShareFB"];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        //NSMutableArray *GetImageArray = [defaults objectForKey:@"SelectImageData"];
        
        //    GetLocationAddress = @"{\n  \"address_components\":\n  {\n   \"route\":\"Batu 5 Cheras\",\n   \"administrative_area_level_1\":\"Kuala Lumpur\",\n   \"country\":\"Malaysia\"\n  },\n  \"formatted_address\": \"Batu 5 Cheras,56100 Cheras,Kuala Lumpur,Malaysia\",\n  \"lat\": \"3.099504988381667\",\n  \"lng\": \"101.739358\",\n  \"reference\": \"v-1415079170\",\n  \"type\": 1\n}";
        
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
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetSelectCategoryIDN] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLocationAddress length] == 0 || [GetLocationAddress isEqualToString:@"(null)"]) {
            NSLog(@"No location address Post");
            GetLocationAddress = @"";
        }else{
            NSLog(@"got location address Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationAddress] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLocationPlaceName length] == 0 || [GetLocationPlaceName isEqualToString:@"(null)"]) {
            NSLog(@"No location Place Name Post");
            GetLocationPlaceName = @"";
        }else{
            NSLog(@"got location Place Name Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"place_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationPlaceName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSLog(@"Save Drafts Submit Data GetLangID is %@",GetLangID);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[%@]\"\r\n\r\n",GetLangID] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",TitleField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"(null)"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
            NSLog(@"No DescriptionField Post");
            DescriptionField.text = @"";
        }else{
            NSLog(@"got DescriptionField Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[%@]\"\r\n\r\n",GetLangID] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",DescriptionField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLinkString length] == 0 || [GetLinkString isEqualToString:@"(null)"]) {
            NSLog(@"No link Post");
            GetLinkString = @"";
        }else{
            NSLog(@"got link Post");
            
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLinkString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetTagString length] == 0 || [GetTagString isEqualToString:@"(null)"]) {
            NSLog(@"No tag Post");
            GetTagString = @"";
        }else{
            NSLog(@"got tag Post");
            
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetTagString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        NSString *CheckString = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"CheckDaftsImg"]];
        if ([CheckString isEqualToString:@"ChangeNewImage"]) {
            for (int i = 0; i < [GetImgArray count]; i++) {
                UIImage *GetImage = [self decodeBase64ToImage:[GetImgArray objectAtIndex:i]];
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
                
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the key name @"parameter_second" to the post body
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][caption]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
                //Attaching the content to be posted ( ParameterSecond )
                [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }else{


        }
//        NSMutableArray *CheckImgArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"SelectImageData"]];
//        if ([CheckImgArray count] == [GetImgArray count]) {
//            
//        }else{
//                    }

        
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
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // NSString *GetSelectCategoryString = [defaults objectForKey:@"CategorySelected"];
        NSLog(@"GetLangID is %@",GetLangID);
        NSString *GetSelectCategoryIDN = [defaults objectForKey:@"CategorySelectedIDN"];
        NSString *GetLocationPlaceName = [defaults objectForKey:@"Location_PlaceName"];
        NSString *GetLocationAddress = [defaults objectForKey:@"Location_Json"];
        NSLog(@"GetLocationAddress is %@",GetLocationAddress);
        NSString *GetLinkString = [defaults objectForKey:@"Extras_Link"];
        NSString *GetTagString = [defaults objectForKey:@"Extras_Tag"];
        // NSString *GetShareFB = [defaults objectForKey:@"Extras_ShareFB"];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        //NSMutableArray *GetImageArray = [defaults objectForKey:@"SelectImageData"];
        
        //    GetLocationAddress = @"{\n  \"address_components\":\n  {\n   \"route\":\"Batu 5 Cheras\",\n   \"administrative_area_level_1\":\"Kuala Lumpur\",\n   \"country\":\"Malaysia\"\n  },\n  \"formatted_address\": \"Batu 5 Cheras,56100 Cheras,Kuala Lumpur,Malaysia\",\n  \"lat\": \"3.099504988381667\",\n  \"lng\": \"101.739358\",\n  \"reference\": \"v-1415079170\",\n  \"type\": 1\n}";
        
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
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetSelectCategoryIDN] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLocationAddress length] == 0 || [GetLocationAddress isEqualToString:@"(null)"]) {
            NSLog(@"No location address Post");
            GetLocationAddress = @"";
        }else{
            NSLog(@"got location address Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationAddress] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLocationPlaceName length] == 0 || [GetLocationPlaceName isEqualToString:@"(null)"]) {
            NSLog(@"No location Place Name Post");
            GetLocationPlaceName = @"";
        }else{
            NSLog(@"got location Place Name Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"place_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationPlaceName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title[%@]\"\r\n\r\n",GetLangID] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",TitleField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        

        
        if ([DescriptionField.text isEqualToString:@"How was your experience?"] || [DescriptionField.text isEqualToString:@"(null)"] || [DescriptionField.text isEqualToString:@"说明 & 经验"] || [DescriptionField.text isEqualToString:@"Deskripsi dan pengalaman"] || [DescriptionField.text isEqualToString:@"Pagsasalarawan at mga karanasan"] || [DescriptionField.text isEqualToString:@"รีวิว"]) {
            NSLog(@"No DescriptionField Post");
            DescriptionField.text = @"";
        }else{
            NSLog(@"got DescriptionField Post");
            
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message[%@]\"\r\n\r\n",GetLangID] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",DescriptionField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetLinkString length] == 0 || [GetLinkString isEqualToString:@"(null)"]) {
            NSLog(@"No link Post");
            GetLinkString = @"";
        }else{
            NSLog(@"got link Post");
            
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLinkString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([GetTagString length] == 0 || [GetTagString isEqualToString:@"(null)"]) {
            NSLog(@"No tag Post");
            GetTagString = @"";
        }else{
            NSLog(@"got tag Post");
            
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetTagString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        for (int i = 0; i < [GetImgArray count]; i++) {
            UIImage *GetImage = [self decodeBase64ToImage:[GetImgArray objectAtIndex:i]];
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
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photos_meta[%i][caption]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
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
    NSLog(@"Facebook Json = %@",res);
    

    
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
//            
//          //  [self.tabBarController setSelectedIndex:0];
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.4;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            //[self presentViewController:ListingDetail animated:NO completion:nil];
//            [self dismissViewControllerAnimated:NO completion:nil];
//            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CategorySelected"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Name"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Lat"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ChangeSearchLocation_Long"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_PlaceName"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Address"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Link"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_Tag"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Extras_ShareFB"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Title"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Publish_Description"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectImageData"];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Location_Json"];
        }else{
            UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"Status" message:@"Unsuccessful please try later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlertView.tag = 200;
            [ShowAlertView show];
        }

    }
    
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
}

@end

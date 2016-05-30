//
//  PSelectYourInterestViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PSelectYourInterestViewController.h"
//#import "ProgressHUD.h"
@interface PSelectYourInterestViewController ()

@end

@implementation PSelectYourInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *CheckStatus = @"3";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 510)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 70);
    
    ContiuneBtn.frame = CGRectMake(15, screenHeight - 60, screenWidth - 30, 50);
    SelectAllBtn.frame = CGRectMake(screenWidth - 100 - 15, 24, 100, 34);
    ShowTitle.frame = CGRectMake(15, 55, screenWidth - 30, 35);
    
    SelectIDNArray = [[NSMutableArray alloc]init];
    SelectCategoryNameArray = [[NSMutableArray alloc]init];
    
    checkSelectData = 0;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"Phone Language is %@",language);
    
    CategorySelectIDArray = [[NSMutableArray alloc]init];
    GetCategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    NSMutableArray *GetNameArray;
    if ([language isEqualToString:@"en"]) {
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
    }else if([language isEqualToString:@"zh-Hant"] || [language isEqualToString:@"Traditional Chinese"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Tw"]];
    }else if([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"Simplified Chinese"] || [language isEqualToString:@"zh-HK"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Cn"]];
    }else if([language isEqualToString:@"id"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_In"]];
    }else if([language isEqualToString:@"fn"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Fn"]];
    }else if([language isEqualToString:@"th"] || [language isEqualToString:@"Thai"]){
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
        ShowImageButton.frame = CGRectMake((GetWidth/2) - (ButtonWidth/2) +(i % 2)* GetWidth, 100 + ((ButtonWidth + 60) * (CGFloat)(i /2)), ButtonWidth, ButtonWidth);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        sscanf([[GetBackgroundArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = (ButtonWidth/2); // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowImageButton];
        NSLog(@"ShowImageButton.tag === is %ld",(long)ShowImageButton.tag);
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(0 +(i % 2)*GetWidth, (100 + ButtonWidth + 10) + ((ButtonWidth + 60) * (CGFloat)(i /2)), GetWidth, 21);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowTitle_];
        
        [MainScroll setContentSize:CGSizeMake(300, (100 + ButtonWidth + 60) + ((ButtonWidth + 60) * (CGFloat)(i /2)))];
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
        
        ContiuneBtn.enabled = YES;
        
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
        if ([CategorySelectIDArray count] == 0) {
             ContiuneBtn.enabled = NO;
        }
    }
    
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ShowTitle.text = NSLocalizedString(@"Provisioning_PSelectYourInterestView_Title",nil);
    [ContiuneBtn setTitle:NSLocalizedString(@"Provisioning_PTellUsYourCityView_8",nil) forState:UIControlStateNormal];
    ContiuneBtn.enabled = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)SelectAllButton:(id)sender{
    
    ContiuneBtn.enabled = YES;

    [CategorySelectIDArray removeAllObjects];
    CategorySelectIDArray = [[NSMutableArray alloc]initWithArray:GetCategoryIDArray];
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"Phone Language is %@",language);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *GetNameArray;
    if ([language isEqualToString:@"en"]) {
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
    }else if([language isEqualToString:@"zh-Hant"] || [language isEqualToString:@"Traditional Chinese"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Tw"]];
    }else if([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"Simplified Chinese"] || [language isEqualToString:@"zh-HK"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Cn"]];
    }else if([language isEqualToString:@"id"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_In"]];
    }else if([language isEqualToString:@"fn"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Fn"]];
    }else if([language isEqualToString:@"th"] || [language isEqualToString:@"Thai"]){
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
        ShowImageButton.frame = CGRectMake((GetWidth/2) - (ButtonWidth/2) +(i % 2)* GetWidth, 100 + ((ButtonWidth + 60) * (CGFloat)(i /2)), ButtonWidth, ButtonWidth);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        ShowImageButton.selected = YES;
        NSUInteger red, green, blue;
        sscanf([[GetBackgroundArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = (ButtonWidth/2); // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowImageButton];
        NSLog(@"ShowImageButton.tag === is %ld",(long)ShowImageButton.tag);
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(0 +(i % 2)*GetWidth, (100 + ButtonWidth + 10) + ((ButtonWidth + 60) * (CGFloat)(i /2)), GetWidth, 21);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowTitle_];
        
        [MainScroll setContentSize:CGSizeMake(300, (100 + ButtonWidth + 60) + ((ButtonWidth + 60) * (CGFloat)(i /2)))];
    }
}
-(IBAction)ContiuneButton:(id)sender{
    NSString *GetSelectID = [CategorySelectIDArray componentsJoinedByString:@","];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetSelectID forKey:@"Provisioning_Interest"];
    [defaults synchronize];
    
//    PFollowTheExpertsViewController *SelectYourInterestView = [[PFollowTheExpertsViewController alloc]init];
//    [self presentViewController:SelectYourInterestView animated:YES completion:nil];
}

@end

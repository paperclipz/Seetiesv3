//
//  FilterViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 5/15/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "FilterViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 124);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);

    ApplyFilterButton.frame = CGRectMake(0, screenHeight - 60, screenWidth, 60);
    
    TitleLabel.text = CustomLocalisedString(@"Filter", nil);
    ShowDistance.text = CustomLocalisedString(@"Distance", nil);
    ShowPopular.text = CustomLocalisedString(@"Popular", nil);
    ShowRecent.text = CustomLocalisedString(@"MostRecent", nil);
    SortByText.text = CustomLocalisedString(@"SortByBig", nil);
    CategoryText.text = CustomLocalisedString(@"ChooseacategoryBig", nil);
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Filter View";
}
-(void)GetWhatViewComeHere:(NSString *)WhatView{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    GetWhatViewCome = WhatView;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *TempSortByString;
    NSString *GetCategoryString;
    
    if ([GetWhatViewCome isEqualToString:@"Feed"]) {
        TempSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
        GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
        
    }else if([GetWhatViewCome isEqualToString:@"Search"]){
        
    }else if([GetWhatViewCome isEqualToString:@"Explore"]){
        TempSortByString = [defaults objectForKey:@"Filter_Explore_SortBy"];
        GetCategoryString = [defaults objectForKey:@"Filter_Explore_Category"];
    }
    
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
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
    
    CategoryArray = [[NSMutableArray alloc]initWithArray:GetNameArray];
    BackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
    
    
    NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image"]];
    
    GetImageArray1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < [GetTempImageArray count]; i++) {
        
        [GetImageArray1 addObject:[self decodeBase64ToImage:[GetTempImageArray objectAtIndex:i]]];
    }
    
    SortByText.frame = CGRectMake(15, 15, screenWidth - 30, 21);
    CategoryText.frame = CGRectMake(15, 212, screenWidth - 30, 21);
    
    ShowPopular.frame = CGRectMake(15, 42, screenWidth - 30, 50);
    ShowDistance.frame = CGRectMake(15, 93, screenWidth - 30, 50);
    ShowRecent.frame = CGRectMake(15, 144, screenWidth - 30, 50);
    
    WhiteBack_1.frame = CGRectMake(0, 42, screenWidth, 50);
    WhiteBack_2.frame = CGRectMake(0, 93, screenWidth, 50);
    WhiteBack_3.frame = CGRectMake(0, 144, screenWidth, 50);
    
    [WhiteBack_1 setImage:[UIImage imageNamed:@"CategorySelected.png"] forState:UIControlStateSelected];
    WhiteBack_1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(screenWidth - 47 - 15));
    
    [WhiteBack_2 setImage:[UIImage imageNamed:@"CategorySelected.png"] forState:UIControlStateSelected];
    WhiteBack_2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(screenWidth - 47 - 15));
    
    [WhiteBack_3 setImage:[UIImage imageNamed:@"CategorySelected.png"] forState:UIControlStateSelected];
    WhiteBack_3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(screenWidth - 47 - 15));
    
    [MainScroll setContentSize:CGSizeMake(320, 900)];
    
    
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        SelectCategoryIDArray = [[NSMutableArray alloc]init];
    }else{
        if ([TempSortByString isEqualToString:@"1"]) {
            WhiteBack_1.selected = YES;
        }else if([TempSortByString isEqualToString:@"2"]){
            WhiteBack_2.selected = YES;
        }else if([TempSortByString isEqualToString:@"3"]){
            WhiteBack_3.selected = YES;
        }
        NSLog(@"GetCategoryString is %@",GetCategoryString);
        
        NSArray *arr = [GetCategoryString componentsSeparatedByString:@","];
        NSLog(@"arr is %@",arr);
        SelectCategoryIDArray = [[NSMutableArray alloc]initWithArray:arr];
        NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
        
    }
    
    [self InitView];
    
    

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)InitView{

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < [CategoryArray count]; i++) {
        UIButton *WhiteBack = [[UIButton alloc]init];
        [WhiteBack setTitle:@"" forState:UIControlStateNormal];
        WhiteBack.frame = CGRectMake(0, 240 + i * 61, screenWidth, 60);
        WhiteBack.backgroundColor = [UIColor whiteColor];
        WhiteBack.tag = i;
        
        NSString *CheckCategoryID = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:i]];
        for (int z = 0; z < [SelectCategoryIDArray count]; z++) {
            if ([CheckCategoryID isEqualToString:[SelectCategoryIDArray objectAtIndex:z]]) {
                WhiteBack.selected = YES;
                NSLog(@"check got data");
                break;
            }
        }
        
        [WhiteBack setImage:[UIImage imageNamed:@"CategorySelected.png"] forState:UIControlStateSelected];
        [WhiteBack addTarget:self action:@selector(SelectCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        WhiteBack.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(screenWidth - 47 - 15));

        
        [MainScroll addSubview:WhiteBack];
        

        
        CGSize rect = CGSizeMake(20, 20);
        CGFloat scale = [[UIScreen mainScreen]scale];
        UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
        [[GetImageArray1 objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIButton *ShowImageButton = [[UIButton alloc]init];
        ShowImageButton.tag = i;
        ShowImageButton.frame = CGRectMake(15, 250 + i * 61, 40, 40);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        sscanf([[BackgroundColorArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = 20; // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
       // [ShowImageButton addTarget:self action:@selector(SelectCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowImageButton];

        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(70, 240 + i * 61, screenWidth - 70 - 15, 60);
        ShowTitle_.text = [CategoryArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentLeft;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowTitle_];
        
    }

}
-(IBAction)SelectCategoryButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:getbuttonIDN]];
        [SelectCategoryIDArray addObject:TempIDN];

        
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:getbuttonIDN]];
        [SelectCategoryIDArray removeObject:TempIDN];

    }

}
-(IBAction)PopularButton:(id)sender{
    NSLog(@"PopularButton Click ?");
    WhiteBack_1.selected = !WhiteBack_1.selected;
    WhiteBack_2.selected = NO;
    WhiteBack_3.selected = NO;
    GetSortByString = @"2";
}
-(IBAction)DistanceButton:(id)sender{
    NSLog(@"DistanceButton Click ?");
    WhiteBack_2.selected = !WhiteBack_2.selected;
    WhiteBack_1.selected = NO;
    WhiteBack_3.selected = NO;
    GetSortByString = @"3";
}

-(IBAction)RecentButton:(id)sender{
    NSLog(@"RecentButton Click ?");
    WhiteBack_3.selected = !WhiteBack_3.selected;
    WhiteBack_1.selected = NO;
    WhiteBack_2.selected = NO;
    GetSortByString = @"1";
}
-(IBAction)ApplyButton:(id)sender{
    if ([SelectCategoryIDArray count] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Must select category" delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSString *TempString = [SelectCategoryIDArray componentsJoinedByString:@","];
        if ([GetWhatViewCome isEqualToString:@"Feed"]) {
            [defaults setObject:GetSortByString forKey:@"Filter_Feed_SortBy"];
            [defaults setObject:TempString forKey:@"Filter_Feed_Category"];
            [defaults synchronize];
        }else if([GetWhatViewCome isEqualToString:@"Search"]){
        
        }else if([GetWhatViewCome isEqualToString:@"Explore"]){
            [defaults setObject:GetSortByString forKey:@"Filter_Explore_SortBy"];
            [defaults setObject:TempString forKey:@"Filter_Explore_Category"];
            [defaults synchronize];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end

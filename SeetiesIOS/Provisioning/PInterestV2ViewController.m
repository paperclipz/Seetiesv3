//
//  PInterestV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/24/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "PInterestV2ViewController.h"

@interface PInterestV2ViewController ()

@end

@implementation PInterestV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowTitle.frame = CGRectMake(30, 50, screenWidth - 60, 25);
    ShowSubTitle.frame = CGRectMake(30, 85, screenWidth - 60, 65);
    DoneButton.frame = CGRectMake(30, screenHeight - 70, screenWidth - 60, 50);
    DoneButton.layer.cornerRadius = 5;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 160, screenWidth, screenHeight - 160 - 80);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"Phone Language is %@",language);
    
    GetCategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
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
    GetBackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
    
    GetImageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [GetTempImageArray count]; i++) {
        
        [GetImageArray addObject:[self decodeBase64ToImage:[GetTempImageArray objectAtIndex:i]]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitView{
    
    for (int i = 0; i < [GetCategoryIDArray count]; i++) {
        UIButton *CoverButton = [[UIButton alloc]init];
        CoverButton.frame = CGRectMake(30 +(i % 5)*160, 210 * (CGFloat)(i /5), 150, 200);
        [CoverButton setTitle:@"aa" forState:UIControlStateNormal];
        CoverButton.backgroundColor = [UIColor whiteColor];
        CoverButton.layer.cornerRadius = 5;
        CoverButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        CoverButton.layer.borderWidth = 1.0;
        CoverButton.tag = i + 200;
        [MainScroll addSubview:CoverButton];
        
        CGSize rect = CGSizeMake(80, 80);
        CGFloat scale = [[UIScreen mainScreen]scale];
        UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
        [[GetImageArray objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIButton *ShowImageButton = [[UIButton alloc]init];
        ShowImageButton.tag = i;
        ShowImageButton.frame = CGRectMake(45 +(i % 5)*160, 10 +  (CGFloat)(i /5) * 210, 120, 120);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        sscanf([[GetBackgroundColorArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = 60; // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowImageButton];
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(30 +(i % 5)*160, 135 +  (CGFloat)(i /5) * 210, 150, 50);
        ShowTitle_.text = [GetNameArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        ShowTitle_.textColor = color;
        ShowTitle_.textAlignment = NSTextAlignmentCenter;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        ShowTitle_.numberOfLines = 3;
        [ShowTitle_ setTag:i + 500];
        [MainScroll addSubview:ShowTitle_];
        
        
    }
    
    [MainScroll setContentSize:CGSizeMake(850, 200)];

}
-(IBAction)ShowImageButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    UILabel *ShowTitle_ = (UILabel *)[MainScroll viewWithTag:getbuttonIDN + 500];
    
    UIButton *BackgroundButton = (UIButton *)[MainScroll viewWithTag:getbuttonIDN + 200];
    
    NSUInteger red, green, blue;
    sscanf([[GetBackgroundColorArray objectAtIndex:getbuttonIDN] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    if (buttonWithTag1.selected) {
//        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
//        [CategorySelectIDArray addObject:TempIDN];
//        
//        ContiuneBtn.enabled = YES;
      //
        BackgroundButton.backgroundColor = color;
        ShowTitle_.textColor = [UIColor whiteColor];
    }else{
//        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
//        [CategorySelectIDArray removeObject:TempIDN];
//        if ([CategorySelectIDArray count] == 0) {
//            ContiuneBtn.enabled = NO;
//        }
        BackgroundButton.backgroundColor = [UIColor whiteColor];
        ShowTitle_.textColor = color;
        
        
    }
    
   // NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
}
@end

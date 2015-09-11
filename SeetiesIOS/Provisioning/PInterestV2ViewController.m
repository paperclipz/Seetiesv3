//
//  PInterestV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/24/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "PInterestV2ViewController.h"
#import "AsyncImageView.h"
#import "PFollowTheExpertsViewController.h"
@interface PInterestV2ViewController ()

@property(nonatomic,strong)PFollowTheExpertsViewController* pFollowTheExpertsViewController;
@end

@implementation PInterestV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *CheckStatus = @"3";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowTitle.frame = CGRectMake(30, 50, screenWidth - 60, 25);
    ShowSubTitle.frame = CGRectMake(30, 40, screenWidth - 60, 65);
    DoneButton.frame = CGRectMake(30, screenHeight - 70, screenWidth - 60, 50);
    DoneButton.layer.cornerRadius = 5;
    DoneButton.enabled = NO;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 110, screenWidth, screenHeight - 110 - 80);

    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"Phone Language is %@",language);
    
    CategorySelectIDArray = [[NSMutableArray alloc]init];
    
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
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int TestWidth = screenWidth - 50;
    //NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 5;
    // NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 5;
    
    for (NSInteger i = 0; i < 10; i++) {
//        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
//        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
//        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowImage.layer.masksToBounds = YES;
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[ArrLikeImg objectAtIndex:i]];
//        if ([FullImagesURL_First length] == 0) {
//            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        }else{
//            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//            ShowImage.imageURL = url_NearbySmall;
//        }
//        [LikeView addSubview:ShowImage];
        if (i == 9) {
            UIButton *ImageButton = [[UIButton alloc]init];
            [ImageButton setBackgroundColor:[UIColor lightGrayColor]];
            [ImageButton setTitle:@"" forState:UIControlStateNormal];
            ImageButton.frame = CGRectMake(17+(i % 3)*SpaceWidth + FinalWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ImageButton.tag = i + 200;
            ImageButton.layer.cornerRadius = 5;
           // [ImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:ImageButton];
            
            CGSize rect = CGSizeMake(50, 50);
            CGFloat scale = [[UIScreen mainScreen]scale];
            UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
            [[GetImageArray objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIButton *ShowImageButton = [[UIButton alloc]init];
            ShowImageButton.tag = i;
            ShowImageButton.frame = CGRectMake(17+(i % 3)*SpaceWidth + FinalWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth - 40);
            [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
            [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
            [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
            ShowImageButton.backgroundColor = [UIColor clearColor];
            //            NSUInteger red, green, blue;
            //            sscanf([[GetBackgroundColorArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
            //            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
            //            ShowImageButton.backgroundColor = color;
            //            ShowImageButton.layer.cornerRadius = 60; // this value vary as per your desire
            //            ShowImageButton.clipsToBounds = YES;
            [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            [MainScroll addSubview:ShowImageButton];
            
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(22+(i % 3)*SpaceWidth + FinalWidth, (FinalWidth - 40) + (SpaceWidth * (CGFloat)(i /3)), FinalWidth - 10, 40);
            ShowTitle_.text = [GetNameArray objectAtIndex:i];
            /// ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-regular" size:8];
            ShowTitle_.font = [UIFont systemFontOfSize:12];
            ShowTitle_.textColor = [UIColor blackColor];
            ShowTitle_.textAlignment = NSTextAlignmentCenter;
            ShowTitle_.backgroundColor = [UIColor clearColor];
            ShowTitle_.numberOfLines = 3;
            [ShowTitle_ setTag:i + 500];
            [MainScroll addSubview:ShowTitle_];
        }else{
            UIButton *ImageButton = [[UIButton alloc]init];
            [ImageButton setBackgroundColor:[UIColor lightGrayColor]];
            [ImageButton setTitle:@"" forState:UIControlStateNormal];
            ImageButton.frame = CGRectMake(12+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ImageButton.tag = i + 200;
            ImageButton.layer.cornerRadius = 5;
           // [ImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:ImageButton];
            
            
            CGSize rect = CGSizeMake(50, 50);
            CGFloat scale = [[UIScreen mainScreen]scale];
            UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
            [[GetImageArray objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIButton *ShowImageButton = [[UIButton alloc]init];
            ShowImageButton.tag = i;
            ShowImageButton.frame = CGRectMake(12+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth - 40);
            [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
            [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
            [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
            ShowImageButton.backgroundColor = [UIColor clearColor];
//            NSUInteger red, green, blue;
//            sscanf([[GetBackgroundColorArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
//            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
//            ShowImageButton.backgroundColor = color;
//            ShowImageButton.layer.cornerRadius = 60; // this value vary as per your desire
//            ShowImageButton.clipsToBounds = YES;
            [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            [MainScroll addSubview:ShowImageButton];

            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(17+(i % 3)*SpaceWidth, (FinalWidth - 40) + (SpaceWidth * (CGFloat)(i /3)), FinalWidth - 10, 40);
            ShowTitle_.text = [GetNameArray objectAtIndex:i];
           /// ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-regular" size:8];
            ShowTitle_.font = [UIFont systemFontOfSize:12];
            ShowTitle_.textColor = [UIColor blackColor];
            ShowTitle_.textAlignment = NSTextAlignmentCenter;
            ShowTitle_.backgroundColor = [UIColor clearColor
                                          ];
            ShowTitle_.numberOfLines = 3;
            [ShowTitle_ setTag:i + 500];
            [MainScroll addSubview:ShowTitle_];

        }
//        
        

        //[MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
        //MainScroll.frame = CGRectMake(0, 110, screenWidth, 0 + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }
    
    
    [MainScroll setContentSize:CGSizeMake(screenWidth, 600)];
    
//    for (int i = 0; i < [GetCategoryIDArray count]; i++) {
//        UIButton *CoverButton = [[UIButton alloc]init];
//        CoverButton.frame = CGRectMake(30 +(i % 5)*160, 210 * (CGFloat)(i /5), 150, 200);
//        [CoverButton setTitle:@"aa" forState:UIControlStateNormal];
//        CoverButton.backgroundColor = [UIColor whiteColor];
//        CoverButton.layer.cornerRadius = 5;
//        CoverButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        CoverButton.layer.borderWidth = 1.0;
//        CoverButton.tag = i + 200;
//        [MainScroll addSubview:CoverButton];
//        
//        CGSize rect = CGSizeMake(80, 80);
//        CGFloat scale = [[UIScreen mainScreen]scale];
//        UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
//        [[GetImageArray objectAtIndex:i] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
//        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        UIButton *ShowImageButton = [[UIButton alloc]init];
//        ShowImageButton.tag = i;
//        ShowImageButton.frame = CGRectMake(45 +(i % 5)*160, 10 +  (CGFloat)(i /5) * 210, 120, 120);
//        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
//        [ShowImageButton setImage:[UIImage imageNamed:@"Testingaaaaaa.png"] forState:UIControlStateSelected];
//        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
//        NSUInteger red, green, blue;
//        sscanf([[GetBackgroundColorArray objectAtIndex:i] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
//        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
//        ShowImageButton.backgroundColor = color;
//        ShowImageButton.layer.cornerRadius = 60; // this value vary as per your desire
//        ShowImageButton.clipsToBounds = YES;
//        [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:ShowImageButton];
//
//        UILabel *ShowTitle_ = [[UILabel alloc]init];
//        ShowTitle_.frame = CGRectMake(30 +(i % 5)*160, 135 +  (CGFloat)(i /5) * 210, 150, 50);
//        ShowTitle_.text = [GetNameArray objectAtIndex:i];
//        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
//        ShowTitle_.textColor = color;
//        ShowTitle_.textAlignment = NSTextAlignmentCenter;
//        ShowTitle_.backgroundColor = [UIColor clearColor];
//        ShowTitle_.numberOfLines = 3;
//        [ShowTitle_ setTag:i + 500];
//        [MainScroll addSubview:ShowTitle_];
//
//        
//    }
//    
//    [MainScroll setContentSize:CGSizeMake(850, 200)];

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
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray addObject:TempIDN];

        DoneButton.enabled = YES;
      
        BackgroundButton.backgroundColor = color;
        ShowTitle_.textColor = [UIColor whiteColor];
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
        if ([CategorySelectIDArray count] == 0) {
            DoneButton.enabled = NO;
        }
        BackgroundButton.backgroundColor = [UIColor lightGrayColor];
        ShowTitle_.textColor = [UIColor blackColor];
        
        
    }
    
   // NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
}
-(IBAction)NextButton:(id)sender{
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    NSString *GetSelectID = [CategorySelectIDArray componentsJoinedByString:@","];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetSelectID forKey:@"Provisioning_Interest"];
    [defaults synchronize];
    
    [self.navigationController pushViewController:self.pFollowTheExpertsViewController animated:YES];
}

#pragma mark - Declaration
-(PFollowTheExpertsViewController*)pFollowTheExpertsViewController
{
    if (!_pFollowTheExpertsViewController) {
        _pFollowTheExpertsViewController = [PFollowTheExpertsViewController new];
    }
    return _pFollowTheExpertsViewController;
}
@end

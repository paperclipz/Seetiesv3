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
    DataUrl = [[UrlDataClass alloc]init];
    NSString *CheckStatus = @"3";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowTitle.frame = CGRectMake(30, 50, screenWidth - 60, 25);
    ShowSubTitle.frame = CGRectMake(30, 40, screenWidth - 60, 65);
    ShowSubTitle.text = NSLocalizedString(@"What are you interested in?",nil);
    DoneButton.frame = CGRectMake(30, screenHeight - 70, screenWidth - 60, 50);
    DoneButton.layer.cornerRadius = 5;
    [DoneButton setTitle:NSLocalizedString(@"Let's go!",nil) forState:UIControlStateNormal];
    //DoneButton.enabled = NO;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 110, screenWidth, screenHeight - 110 - 80);
    ShowActivity.hidden = YES;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"Phone Language is %@",language);
    
    CategorySelectIDArray = [[NSMutableArray alloc]init];
    
    GetCategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    
    
    if ([GetCategoryIDArray count] == 0) {
        //cannot get data in landing view, so we load again
        ShowActivity.hidden = NO;
        [ShowActivity startAnimating];
        [self GetAllCategory];
    }else{
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

        GetBackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
        
        NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Default"]];
        GetImageDefaultArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray];
        NSMutableArray *GetTempImageArray1 = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Selected"]];
        GetImageSelectedArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray1];
        
        [self InitView];
    
    }
    

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
        if (i == 9) {
            UIButton *ImageButton = [[UIButton alloc]init];
            [ImageButton setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
            [ImageButton setTitle:@"" forState:UIControlStateNormal];
            ImageButton.frame = CGRectMake(17+(i % 3)*SpaceWidth + FinalWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ImageButton.tag = i + 200;
            ImageButton.layer.cornerRadius = 5;
           // [ImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:ImageButton];
            
            
            
            NSURL *imageURL_Default = [NSURL URLWithString:[GetImageDefaultArray objectAtIndex:i]];
            NSURL *imageURL_Selected = [NSURL URLWithString:[GetImageSelectedArray objectAtIndex:i]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData_Default = [NSData dataWithContentsOfURL:imageURL_Default];
                NSData *imageData_Selected = [NSData dataWithContentsOfURL:imageURL_Selected];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *newImage_Default = [UIImage imageWithData:imageData_Default];
                    CGSize rect = CGSizeMake(50, 50);
                    CGFloat scale = [[UIScreen mainScreen]scale];
                    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
                    [newImage_Default drawInRect:CGRectMake(0,0,rect.width,rect.height)];
                    UIImage *IconDefault = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    UIImage *newImage_Selected = [UIImage imageWithData:imageData_Selected];
                    CGSize rect_Selected = CGSizeMake(50, 50);
                    CGFloat scale_Selected = [[UIScreen mainScreen]scale];
                    UIGraphicsBeginImageContextWithOptions(rect_Selected, NO, scale_Selected);
                    [newImage_Selected drawInRect:CGRectMake(0,0,rect_Selected.width,rect_Selected.height)];
                    UIImage *IconSelected = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    UIButton *ShowImageButton = [[UIButton alloc]init];
                    ShowImageButton.tag = i;
                    ShowImageButton.frame = CGRectMake(17+(i % 3)*SpaceWidth + FinalWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth - 40);
                    [ShowImageButton setImage:IconDefault forState:UIControlStateNormal];
                    [ShowImageButton setImage:IconSelected forState:UIControlStateSelected];
                    [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
                    ShowImageButton.backgroundColor = [UIColor clearColor];
                    ShowImageButton.tintColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
                    [MainScroll addSubview:ShowImageButton];
                });
            });
            

            
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(22+(i % 3)*SpaceWidth + FinalWidth, (FinalWidth - 40) + (SpaceWidth * (CGFloat)(i /3)), FinalWidth - 10, 40);
            ShowTitle_.text = [GetNameArray objectAtIndex:i];
            /// ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-regular" size:8];
            ShowTitle_.font = [UIFont systemFontOfSize:12];
            ShowTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowTitle_.textAlignment = NSTextAlignmentCenter;
            ShowTitle_.backgroundColor = [UIColor clearColor];
            ShowTitle_.numberOfLines = 3;
            [ShowTitle_ setTag:i + 500];
            [MainScroll addSubview:ShowTitle_];
        }else{
            UIButton *ImageButton = [[UIButton alloc]init];
            [ImageButton setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
            [ImageButton setTitle:@"" forState:UIControlStateNormal];
            ImageButton.frame = CGRectMake(12+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ImageButton.tag = i + 200;
            ImageButton.layer.cornerRadius = 5;
           // [ImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [MainScroll addSubview:ImageButton];
            
            
            
            NSURL *imageURL_Default = [NSURL URLWithString:[GetImageDefaultArray objectAtIndex:i]];
            NSURL *imageURL_Selected = [NSURL URLWithString:[GetImageSelectedArray objectAtIndex:i]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData_Default = [NSData dataWithContentsOfURL:imageURL_Default];
                NSData *imageData_Selected = [NSData dataWithContentsOfURL:imageURL_Selected];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *newImage_Default = [UIImage imageWithData:imageData_Default];
                    CGSize rect = CGSizeMake(50, 50);
                    CGFloat scale = [[UIScreen mainScreen]scale];
                    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
                    [newImage_Default drawInRect:CGRectMake(0,0,rect.width,rect.height)];
                    UIImage *IconDefault = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    UIImage *newImage_Selected = [UIImage imageWithData:imageData_Selected];
                    CGSize rect_Selected = CGSizeMake(50, 50);
                    CGFloat scale_Selected = [[UIScreen mainScreen]scale];
                    UIGraphicsBeginImageContextWithOptions(rect_Selected, NO, scale_Selected);
                    [newImage_Selected drawInRect:CGRectMake(0,0,rect_Selected.width,rect_Selected.height)];
                    UIImage *IconSelected = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    UIButton *ShowImageButton = [[UIButton alloc]init];
                    ShowImageButton.tag = i;
                    ShowImageButton.frame = CGRectMake(12+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth - 40);
                    [ShowImageButton setImage:IconDefault forState:UIControlStateNormal];
                    [ShowImageButton setImage:IconSelected forState:UIControlStateSelected];
                    [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
                    ShowImageButton.backgroundColor = [UIColor clearColor];
                    ShowImageButton.tintColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    [ShowImageButton addTarget:self action:@selector(ShowImageButton:) forControlEvents:UIControlEventTouchUpInside];
                    [MainScroll addSubview:ShowImageButton];
                });
            });

            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(17+(i % 3)*SpaceWidth, (FinalWidth - 40) + (SpaceWidth * (CGFloat)(i /3)), FinalWidth - 10, 40);
            ShowTitle_.text = [GetNameArray objectAtIndex:i];
           /// ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-regular" size:8];
            ShowTitle_.font = [UIFont systemFontOfSize:12];
            ShowTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
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

     //   DoneButton.enabled = YES;
      
        BackgroundButton.backgroundColor = color;
        ShowTitle_.textColor = [UIColor whiteColor];
    }else{
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[GetCategoryIDArray objectAtIndex:getbuttonIDN]];
        [CategorySelectIDArray removeObject:TempIDN];
        if ([CategorySelectIDArray count] == 0) {
          //  DoneButton.enabled = NO;
            
        }
        [BackgroundButton setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        ShowTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        
        
    }
    
   // NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
}
-(IBAction)NextButton:(id)sender{
    NSLog(@"CategorySelectIDArray is %@",CategorySelectIDArray);
    
    if ([CategorySelectIDArray count] == 0) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:NSLocalizedString(@"PleaseSelectatleast1category", nil
                                                                                              ) type:TSMessageNotificationTypeError];
    }else{
        NSString *GetSelectID = [CategorySelectIDArray componentsJoinedByString:@","];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:GetSelectID forKey:@"Provisioning_Interest"];
        [defaults synchronize];
        
        [self.navigationController pushViewController:self.pFollowTheExpertsViewController animated:YES];
    }
    
    

}

#pragma mark - Declaration
-(PFollowTheExpertsViewController*)pFollowTheExpertsViewController
{
    if (!_pFollowTheExpertsViewController) {
        _pFollowTheExpertsViewController = [PFollowTheExpertsViewController new];
    }
    return _pFollowTheExpertsViewController;
}

-(void)GetAllCategory{
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetAllCategory_Url];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllCategory = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllCategory start];
    
    
    if( theConnection_GetAllCategory ){
        webData = [NSMutableData data];
    }
}
#pragma mark - Connection Delegate
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == theConnection_GetAllCategory){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //  NSLog(@"Get All Category return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"categories"];
        //   NSLog(@"GetAllData Json = %@",GetAllData);
        
        NSMutableArray *Category_IDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_ImageDefaultArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_ImageSelectedArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_BackgroundImageArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        NSMutableArray *Category_NameArray_CN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TW = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TH = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_IN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_FN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *id_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [Category_IDArray addObject:id_];
            
            NSDictionary *GetImageData = [dict valueForKey:@"images"];
            
            NSString *DefaultImg = [[NSString alloc]initWithFormat:@"%@",[GetImageData objectForKey:@"default"]];
            NSString *SelectImg = [[NSString alloc]initWithFormat:@"%@",[GetImageData objectForKey:@"selected"]];
            [Category_ImageDefaultArray addObject:DefaultImg];
            [Category_ImageSelectedArray addObject:SelectImg];
            
            NSString *background_color = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"background_color"]];
            [Category_BackgroundImageArray addObject:background_color];
            NSDictionary *NameData = [dict valueForKey:@"single_line"];
            NSString *EnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0ab26424400c76000003"]];
            [Category_NameArray addObject:EnData];
            NSString *CnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0aa16424400c76000002"]];
            [Category_NameArray_CN addObject:CnData];
            NSString *TwData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530d5e9b642440d128000018"]];
            [Category_NameArray_TW addObject:TwData];
            NSString *InData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"53672e863efa3f857f8b4ed2"]];
            [Category_NameArray_IN addObject:InData];
            NSString *FnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"539fbb273efa3fde3f8b4567"]];
            [Category_NameArray_FN addObject:FnData];
            NSString *ThData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"544481503efa3ff1588b4567"]];
            [Category_NameArray_TH addObject:ThData];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Category_IDArray forKey:@"Category_All_ID"];
        [defaults setObject:Category_NameArray forKey:@"Category_All_Name"];
        [defaults setObject:Category_ImageDefaultArray forKey:@"Category_All_Image_Default"];
        [defaults setObject:Category_ImageSelectedArray forKey:@"Category_All_Image_Selected"];
        [defaults setObject:Category_BackgroundImageArray forKey:@"Category_All_Background"];
        
        [defaults setObject:Category_NameArray_CN forKey:@"Category_All_Name_Cn"];
        [defaults setObject:Category_NameArray_TW forKey:@"Category_All_Name_Tw"];
        [defaults setObject:Category_NameArray_IN forKey:@"Category_All_Name_In"];
        [defaults setObject:Category_NameArray_FN forKey:@"Category_All_Name_Fn"];
        [defaults setObject:Category_NameArray_TH forKey:@"Category_All_Name_Th"];
        [defaults synchronize];
        
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

            GetBackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
            
        NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Default"]];
        GetImageDefaultArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray];
        NSMutableArray *GetTempImageArray1 = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Selected"]];
        GetImageSelectedArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray1];
            
            [self InitView];
        
        [ShowActivity stopAnimating];
    }
}

@end

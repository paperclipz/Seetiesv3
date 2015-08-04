//
//  ExploreCountryViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ExploreCountryViewController.h"
#import "AsyncImageView.h"
#import "SearchViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface ExploreCountryViewController ()

@end

@implementation ExploreCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
   // [self initView];
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64);
}
-(void)viewDidAppear:(BOOL)animated{
    self.screenName = @"IOS Explore Country Page";
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
-(void)GetCountryName:(NSString *)CountryName GetCountryIDN:(NSString *)CountryIDN{
    GetCountryName = CountryName;
    GetCountryIDN = CountryIDN;
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@ %@",GetCountryName,CustomLocalisedString(@"ExplorePage_Title", nil)];
    ShowTitle.text = FullString;
    
    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
    NSInteger selectedIndex = 0;
    Locale *selectedLocale = [languageManager getSelectedLocale];
    selectedIndex = [languageManager.availableLocales indexOfObject:selectedLocale];
    NSLog(@"selectedIndex is %li",(long)selectedIndex);
    
    NSString *FullString1;
    if (selectedIndex == 1 || selectedIndex == 2) {
        FullString1 = [[NSString alloc]initWithFormat:@"%@%@",GetCountryName,CustomLocalisedString(@"ExplorePage_SecondTitle", nil)];
    }else{
        FullString1 = [[NSString alloc]initWithFormat:@"%@ %@",CustomLocalisedString(@"ExplorePage_SecondTitle", nil),GetCountryName];
    }
    
  //  NSString *FullString1 = [[NSString alloc]initWithFormat:@"%@ %@",CustomLocalisedString(@"ExplorePage_SecondTitle", nil),GetCountryName];
    ShowSubTitle.text = FullString1;
    
    [self GetDataFromServer];
}
-(void)GetDataFromServer{
   //[ProgressHUD show:@"Please wait..."];
    [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/country/%@/posts?token=%@&featured=0",DataUrl.Explore_Url,GetCountryIDN,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLConnection *theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_All start];
    
    
    if( theConnection_All ){
        webData = [NSMutableData data];
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
   // [ProgressHUD showError:@"Something went wrong."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"ExploreCountry return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"ExploreCountry Json = %@",res);
    
    NSArray *GetAllData = (NSArray *)[res valueForKey:@"posts"];
    NSLog(@"GetAllData ===== %@",GetAllData);
    
    NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
    //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
    NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
    //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
    // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
    NSDictionary *titleData = [GetAllData valueForKey:@"title"];
    //  NSLog(@"titleData is %@",titleData);
    NSDictionary *messageData = [GetAllData valueForKey:@"message"];
    // NSLog(@"messageData is %@",messageData);
    NSDictionary *locationData = [GetAllData valueForKey:@"location"];
    //  NSLog(@"locationData is %@",locationData_Nearby);
    NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
    //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
    //NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
    //NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
    //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
    
    
//    CategoryArray = [[NSMutableArray alloc] initWithCapacity:[SingleLine count]];
//    for (NSDictionary * dict in SingleLine) {
//        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//        [CategoryArray addObject:username];
//    }
    //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
    UserInfo_NameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
    UserInfo_AddressArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
    UserInfo_UrlArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
    UserInfo_FollowingArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
    for (NSDictionary * dict in UserInfoData) {
        NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
        [UserInfo_NameArray addObject:username];
        NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
        [UserInfo_AddressArray addObject:location];
        NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
        [UserInfo_uidArray addObject:uid];
        NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
        [UserInfo_FollowingArray addObject:following];
    }
    //NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
    //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
    
    UserInfo_UrlArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ProfilePhoto count]];
    for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
        [UserInfo_UrlArray addObject:url];
    }
    //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
    
    TitleArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
    LangArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
    for (NSDictionary * dict in titleData) {
        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
        NSLog(@"Title1 is %@",Title1);
        NSLog(@"Title2 is %@",Title2);
        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                            
                        }else{
                            [TitleArray addObject:PhilippinesTitle];
                            [LangArray addObject:@"CN"];
                        }
                    }else{
                        [TitleArray addObject:IndonesianTitle];
                        [LangArray addObject:@"CN"];
                    }
                }else{
                    [TitleArray addObject:ThaiTitle];
                    [LangArray addObject:@"CN"];
                }
            }else{
                [TitleArray addObject:Title2];
                [LangArray addObject:@"EN"];
            }

        }else{
            [TitleArray addObject:Title1];
            [LangArray addObject:@"CN"];
            
        }
        
        
    }

    
    MessageArray = [[NSMutableArray alloc]initWithCapacity:[messageData count]];
    for (NSDictionary * dict in messageData) {
        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//        NSString *ThaiMessage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
//        NSString *IndonesianMessage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
//        NSString *PhilippinesMessage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
            [MessageArray addObject:Title2];
        }else{
            [MessageArray addObject:Title1];
        }
    }
    LocationArray = [[NSMutableArray alloc]initWithCapacity:[locationData_Address count]];
    LatArray = [[NSMutableArray alloc]initWithCapacity:[locationData count]];
    LongArray = [[NSMutableArray alloc]initWithCapacity:[locationData count]];
    for (NSDictionary * dict in locationData) {
        NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
        [LatArray addObject:lat];
        NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
        [LongArray addObject:lng];
    }
    
    for (NSDictionary * dict in locationData_Address) {
       //1. Locality, 2. Administrative_area_3 , 3. administrative_area_2 , 4. administrative_area_1
        NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
        NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
        NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
        NSString *FullString;
        if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
            if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                    if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                        FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                    }else{
                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                    }
                }else{
                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                }
            }else{
            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
            }
        }else{
        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
        }
        
        NSLog(@"Locality is %@",Locality);
        NSLog(@"Address3 is %@",Address3);
        NSLog(@"Address2 is %@",Address2);
        NSLog(@"Address1 is %@",Address1);
        NSLog(@"Country is %@",Country);
        
      //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
        [LocationArray addObject:FullString];
    }
    // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
    NSLog(@"LatArray_Nearby is %@",LatArray);
    NSLog(@"LongArray_Nearby is %@",LongArray);
    place_nameArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
    LPhotoArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
    LikesArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
    CommentArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
    PostIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
    CheckLikeArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
    FullPhotoArray = [[NSMutableArray alloc]init];
    LinkArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
    
    
    Activities_profile_photoArray = [[NSMutableArray alloc]init];
    Activities_uidArray = [[NSMutableArray alloc]init];
    Activities_typeArray = [[NSMutableArray alloc]init];
    Activities_usernameArray = [[NSMutableArray alloc]init];
    
    
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
    for (NSDictionary * dict in GetAllData){
        NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
        [place_nameArray addObject:place_name];
        NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
        [LikesArray addObject:total_like];
        NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
        [CommentArray addObject:total_comments];
        NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
        [PostIDArray addObject:post_id];
        NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
        [CheckLikeArray addObject:like];
        NSString *link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
        [LinkArray addObject:link];
        
        //
        NSDictionary *Activities = [dict valueForKey:@"activities"];
        NSLog(@"Activities is %@",Activities);
        
        
        if ([Activities count] == 0){
            
            //TheDict is null
            NSLog(@"Activities_Nearby is nil");
            [Activities_profile_photoArray addObject:@"nil"];
            [Activities_typeArray addObject:@"nil"];
            [Activities_uidArray addObject:@"nil"];
            [Activities_usernameArray addObject:@"nil"];
        }
        else{
            //TheDict is not null
            NSLog(@"Activities_Nearby is not nil");
            NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
            NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
            NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
            NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in Activities){
                NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [testarray_Photo addObject:profile_photo];
                // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                //[Activities_typeArray_Nearby addObject:type];
                [testarray_type addObject:type];
                NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                // [Activities_uidArray_Nearby addObject:uid];
                [testarray_uid addObject:uid];
                NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                // [Activities_usernameArray_Nearby addObject:username];
                [testarray_username addObject:username];
            }
            NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
            [Activities_profile_photoArray addObject:result_Photo];
            NSString *result_Type = [testarray_type componentsJoinedByString:@","];
            [Activities_typeArray addObject:result_Type];
            NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
            [Activities_uidArray addObject:result_Uid];
            NSString *result_Username = [testarray_username componentsJoinedByString:@","];
            [Activities_usernameArray addObject:result_Username];
        }
        
        
        
        
        
        //  NSLog(@"Activities_profile_photoArray_Nearby is %@",Activities_profile_photoArray_Nearby);
        
        
        
        NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
        //  NSLog(@"photos is %@",photos);
        // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
        photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        // NSLog(@"photos is %@", photos);
        NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
        //  NSLog(@"SplitArray is %@",SplitArray);
        NSString *GetSplitString;
        if ([SplitArray count] > 1) {
            GetSplitString = [SplitArray objectAtIndex: 1];
            NSMutableArray *testarray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [SplitArray count]; i++) {
                NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                
                if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                } else {
                    //  NSLog(@"Get GetData is %@",GetData);
                    NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                    [testarray addObject:FinalString];
                }
            }
            //   NSLog(@"testarray is %@",testarray);
            NSString * result = [testarray componentsJoinedByString:@","];
            [FullPhotoArray addObject:result];
        }else{
            GetSplitString = @"";
        }
        
        NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
        //NSLog(@"SplitArray2 is %@",SplitArray2);
        NSString *FinalString = [SplitArray2 objectAtIndex:0];
        
        [LPhotoArray addObject:FinalString];
    }
    
    
    [self initView];
    
    [ShowActivity stopAnimating];
}

-(void)initView{

    
    for (int i = 0; i < [TitleArray count]; i++) {
        AsyncImageView *ShowBigImage = [[AsyncImageView alloc]init];
        ShowBigImage.frame = CGRectMake(0, 120 + i * 388, 320, 240);
        ShowBigImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowBigImage.backgroundColor = [UIColor clearColor];
        ShowBigImage.clipsToBounds = YES;
        ShowBigImage.tag = 999;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowBigImage];
        NSURL *url_NearbyBig = [NSURL URLWithString:[LPhotoArray objectAtIndex:i]];
        //        NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowBigImage.imageURL = url_NearbyBig;
       // ShowBigImage.image = [UIImage imageNamed:@"ImgSample.png"];
        
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 380 + i * 388, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 376 + i * 388, 250, 20);
        ShowLocationLabel.text = [LocationArray objectAtIndex:i];
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 408 + i * 388, 290, 30);
        ShowTitleLabel.text = [TitleArray objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 458 + i * 388, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
     //   NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        NSURL *url_ShowImage = [NSURL URLWithString:[UserInfo_UrlArray objectAtIndex:i]];
        //        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        ShowUserImage.imageURL = url_ShowImage;
       // ShowUserImage.image = [UIImage imageNamed:@"ImgSample.png"];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 458 + i * 388, 250, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 508 + i * 388, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(0, 120 + i * 388, 320, 240)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:ShowBigImage];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:ClickButton];
        
        [MainScroll setScrollEnabled:YES];
        MainScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll setContentSize:CGSizeMake(320, 508 + i * 388)];
        
    }
    
}
-(IBAction)ButtonClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    //FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray objectAtIndex:getbuttonIDN] GetLink:[LinkArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray objectAtIndex:getbuttonIDN] GetTitle:[TitleArray objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray objectAtIndex:getbuttonIDN] GetMessage:[MessageArray objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray objectAtIndex:getbuttonIDN] GetLong:[LongArray objectAtIndex:getbuttonIDN] GetLocation:[LocationArray objectAtIndex:getbuttonIDN]];
   // [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)SearchButton:(id)sender{
    SearchViewController *SearchView = [[SearchViewController alloc]init];
    //CATransition *transition = [CATransition animation];
    //transition.duration = 0.2;
    //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionPush;
    //transition.subtype = kCATransitionFromRight;
    //[self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:SearchView animated:YES completion:nil];
}
@end

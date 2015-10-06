//
//  NearbyViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NearbyViewController.h"
#import "FeedV2DetailViewController.h"
#import "AddCollectionDataViewController.h"
@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    ShowTitle.text = LocalisedString(@"Nearby");
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    
//    if ([GetLatdata length] ==0) {
//        
//    }else{
//        [self SendDataToServer];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Getlat:(NSString *)lat GetLong:(NSString *)Long{

    GetLatdata = lat;
    GetLongData = Long;
    
    
    
    [self SendDataToServer];
}
-(void)SendDataToServer{
    
    if (CheckFirstTimeLoad == 0) {
        [ShowActivity startAnimating];
    }
    

    // CurrentPage = -1;
    if (CurrentPage == TotalPage) {
    }else{
        CurrentPage += 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@search?token=%@&keyword=&sort=&lat=%@&lng=%@&page=%li",DataUrl.UserWallpaper_Url,GetExpertToken,GetLatdata,GetLongData,(long)CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_Nearby = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_Nearby start];
        if( theConnection_Nearby ){
            webData = [NSMutableData data];
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
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Nearby) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        // NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
         NSLog(@"Feed Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            NSDictionary *ResData = [res valueForKey:@"data"];
            
            NSDictionary *recommendationsData = [ResData valueForKey:@"recommendations"];
            
            NSArray *GetAllData = (NSArray *)[recommendationsData valueForKey:@"posts"];
            NSDictionary *locationData = [GetAllData valueForKey:@"location"];
            NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
            NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];

            
            NSString *page = [[NSString alloc]initWithFormat:@"%@",[recommendationsData objectForKey:@"page"]];
            NSLog(@"page is %@",page);
            NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[recommendationsData objectForKey:@"total_page"]];
            NSLog(@"total_page is %@",total_page);
            
            CurrentPage = [page intValue];
            TotalPage = [total_page intValue];
            
            if (CheckFirstTimeLoad == 0) {
                PostIDArray = [[NSMutableArray alloc]init];
                LPhotoArray = [[NSMutableArray alloc]init];
                place_nameArray = [[NSMutableArray alloc]init];
                LocationArray = [[NSMutableArray alloc]init];
                UserInfo_UrlArray = [[NSMutableArray alloc]init];
                UserInfo_NameArray = [[NSMutableArray alloc]init];
                MessageArray = [[NSMutableArray alloc]init];
                TitleArray = [[NSMutableArray alloc]init];
                DistanceArray = [[NSMutableArray alloc]init];
                SearchDisplayNameArray = [[NSMutableArray alloc]init];
                SelfCheckLikeArray = [[NSMutableArray alloc]init];
                TotalLikeArray = [[NSMutableArray alloc]init];
                TotalCommentArray = [[NSMutableArray alloc]init];
                DataCount = 0;
                
                arrCollect = [[NSMutableArray alloc]init];
            }else{
                
            }
            
            for (NSDictionary * dict in locationData) {
                NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                [DistanceArray addObject:formatted_address];
                NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                [SearchDisplayNameArray addObject:SearchDisplayName];
            }
            
            NSDictionary *titleData = [GetAllData valueForKey:@"title"];
            
            
            for (NSDictionary * dict in titleData) {
                //       NSLog(@"dict is %@",dict);
                if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    //       NSLog(@"titleData nil");
                    [TitleArray addObject:@""];
                    //                            [LangArray addObject:@"English"];
                }else{
                    //      NSLog(@"titleData got data");
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    //        NSLog(@"Title1 is %@",Title1);
                    //        NSLog(@"Title2 is %@",Title2);
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        [TitleArray addObject:@""];
                                    }else{
                                        [TitleArray addObject:PhilippinesTitle];
                                        
                                    }
                                }else{
                                    [TitleArray addObject:IndonesianTitle];
                                    
                                }
                            }else{
                                [TitleArray addObject:ThaiTitle];
                            }
                        }else{
                            [TitleArray addObject:Title2];
                        }
                        
                    }else{
                        [TitleArray addObject:Title1];
                        
                    }
                    
                }
                
            }
            
            NSDictionary *messageData = [GetAllData valueForKey:@"message"];
            
            
            for (NSDictionary * dict in messageData) {
                //          NSLog(@"dict is %@",dict);
                if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    //              NSLog(@"titleData nil");
                    [MessageArray addObject:@""];
                    //                            [LangArray addObject:@"English"];
                }else{
                    //           NSLog(@"titleData got data");
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    //              NSLog(@"Title1 is %@",Title1);
                    //             NSLog(@"Title2 is %@",Title2);
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        [MessageArray addObject:@""];
                                    }else{
                                        [MessageArray addObject:PhilippinesTitle];
                                        
                                    }
                                }else{
                                    [MessageArray addObject:IndonesianTitle];
                                    
                                }
                            }else{
                                [MessageArray addObject:ThaiTitle];
                            }
                        }else{
                            [MessageArray addObject:Title2];
                        }
                        
                    }else{
                        [MessageArray addObject:Title1];
                        
                    }
                    
                }
                
            }
            
            for (NSDictionary * dict in UserInfoData) {
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [UserInfo_NameArray addObject:username];
                NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [UserInfo_UrlArray addObject:url];
            }
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
            for (NSDictionary * dict in GetAllData){
                NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [PostIDArray addObject:post_id];
                NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                [place_nameArray addObject:place_name];
                NSString *SelfCheck = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"like"]];
                [SelfCheckLikeArray addObject:SelfCheck];
                NSString *total_like = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                [TotalLikeArray addObject:total_like];
                NSString *total_comments = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                [TotalCommentArray addObject:total_comments];
                NSString *collect = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collect"]];
                [arrCollect addObject:collect];
                
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
                    // NSString * result = [testarray componentsJoinedByString:@","];
                }else{
                    GetSplitString = @"";
                }
                
                NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                //NSLog(@"SplitArray2 is %@",SplitArray2);
                NSString *FinalString = [SplitArray2 objectAtIndex:0];
                
                [LPhotoArray addObject:FinalString];
            }
            for (NSDictionary * dict in locationData_Address) {
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
                [LocationArray addObject:FullString];
            }
            DataCount = DataTotal;
            DataTotal = [LPhotoArray count];
            CheckLoad = NO;
         
            if (CheckFirstTimeLoad == 0) {
               [self InitView];
                CheckFirstTimeLoad = 1;
            }else{
                [self InitContentView];
            }
            
            [ShowActivity stopAnimating];
        }
        
        
    }else if(connection == theConnection_QuickCollect){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Quick Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];
        }
    }
}

-(void)InitContentView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (CheckFirstTimeLoad == 0) {
        CenterLine = [[UIButton alloc]init];
        CenterLine.frame = CGRectMake((screenWidth / 2), 170, 1, 100);
        [CenterLine setTitle:@"" forState:UIControlStateNormal];//238
        [CenterLine setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:CenterLine];
        
        GetHeight += 20;
    }else{
        
    }
    

    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(15, GetHeight, screenWidth - 30, 90);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [MainScroll addSubview: TempButton];
        
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(25, GetHeight + 5, 80, 80);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        
        [MainScroll addSubview:ShowImage];
        
        int TempHeight = 0;
        
        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
            TempHeight += 10;
        }else{
            UILabel *TempShowTitle = [[UILabel alloc]init];
            TempShowTitle.frame = CGRectMake(120, GetHeight + 5, screenWidth - 210, 20);
            TempShowTitle.text = [TitleArray objectAtIndex:i];
            TempShowTitle.backgroundColor = [UIColor clearColor];
            TempShowTitle.textAlignment = NSTextAlignmentLeft;
            TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            TempShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:TempShowTitle];
            
            TempHeight += 25;
        }
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
        ShowPin.frame = CGRectMake(120, GetHeight + TempHeight, 18, 18);
        [MainScroll addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(140, GetHeight + TempHeight, screenWidth - 210, 20);
        ShowPlaceName.text = [place_nameArray objectAtIndex:i];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowPlaceName];
        
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[DistanceArray objectAtIndex:i]];
        
        if ([TempDistanceString isEqualToString:@"0"]) {
            UILabel *ShowLocation = [[UILabel alloc]init];
            ShowLocation.frame = CGRectMake(120, GetHeight + TempHeight + 25, screenWidth - 210, 20);
            ShowLocation.text = [LocationArray objectAtIndex:i];
            ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowLocation.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowLocation.textAlignment = NSTextAlignmentLeft;
            ShowLocation.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowLocation];
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            NSString *FullShowLocatinString;
            if (x_Nearby < 1) {
                if (x_Nearby <= 1) {
                  //  FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km • %@",[LocationArray objectAtIndex:i]];//within
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fM • %@",[TempDistanceString floatValue],[LocationArray objectAtIndex:i]];
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm • %@",strFloat,[LocationArray objectAtIndex:i]];
                }
                
            }else if(x_Nearby > 10 && x_Nearby < 30){

                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm • %@",strFloat,[LocationArray objectAtIndex:i]];
            }else{

                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[SearchDisplayNameArray objectAtIndex:i]];
                
            }
            
            UILabel *ShowLocation = [[UILabel alloc]init];
            ShowLocation.frame = CGRectMake(120, GetHeight + TempHeight + 25, screenWidth - 210, 20);
            ShowLocation.text = FullShowLocatinString;
            ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowLocation.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowLocation.textAlignment = NSTextAlignmentLeft;
            ShowLocation.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowLocation];
            
       }
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(15, GetHeight, screenWidth - 30, 100);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(ProductButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:SelectButton];
        
        CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:i]];
        
        UIButton *CollectButton = [[UIButton alloc]init];
        [CollectButton setBackgroundColor:[UIColor clearColor]];
        if ([CheckCollect isEqualToString:@"0"]) {
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollect.png"] forState:UIControlStateNormal];
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateSelected];
        }else{
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateNormal];
        }
        CollectButton.frame = CGRectMake(screenWidth - 15 - 57 - 10, GetHeight + 16, 57, 57);
        CollectButton.tag = i;
        [CollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:CollectButton];
        
        GetHeight += 100;
        
        CenterLine.frame = CGRectMake((screenWidth / 2), 170, 1, GetHeight + 100);
        
    }
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + 120;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}


-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    UIButton *BackgroundImg = [[UIButton alloc]init];
//    [BackgroundImg setTitle:@"" forState:UIControlStateNormal];
//    BackgroundImg.frame = CGRectMake(0, 0, screenWidth, 150);
//    BackgroundImg.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    [MainScroll addSubview:BackgroundImg];
    
    UIImageView *NearbyImg = [[UIImageView alloc]init];
    NearbyImg.image = [UIImage imageNamed:@"NearbyBackground.png"];
    NearbyImg.frame = CGRectMake(0, 0, screenWidth, 150);
    NearbyImg.contentMode = UIViewContentModeScaleAspectFill;
    NearbyImg.layer.masksToBounds = YES;
    [MainScroll addSubview:NearbyImg];
    
    UIButton *ShowNearbyLocationText = [[UIButton alloc]init];
    [ShowNearbyLocationText setTitle:[LocationArray objectAtIndex:0] forState:UIControlStateNormal];
    ShowNearbyLocationText.layer.cornerRadius = 20;
    ShowNearbyLocationText.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:204.0f/255.0f blue:101.0f/255.0f alpha:1.0f];
    [ShowNearbyLocationText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ShowNearbyLocationText.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
     ShowNearbyLocationText.frame = CGRectMake((screenWidth / 2) - 100, 130, 200, 40);
    [MainScroll addSubview:ShowNearbyLocationText];
    
    
    GetHeight += 170;
    [self InitContentView];
}
-(IBAction)ProductButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    // NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Quick CollectButtonOnClick");
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[PostIDArray objectAtIndex:getbuttonIDN]];
    CheckCollect = [[NSString alloc]initWithFormat:@"%@",[arrCollect objectAtIndex:getbuttonIDN]];
    
    if ([CheckCollect isEqualToString:@"0"]) {
        [arrCollect replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        
        [self SendQuickCollect];
    }else{
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
        //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN] GetImageData:[LPhotoArray objectAtIndex:getbuttonIDN]];
    }
    
    
    
    
    
    
}
-(void)SendQuickCollect{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/0/collect",DataUrl.UserWallpaper_Url,GetUseruid];
    NSLog(@"Send Quick Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSString *dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@",GetExpertToken,GetPostID];
    
    NSData *postBodyData = [NSData dataWithBytes: [dataString UTF8String] length:[dataString length]];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == MainScroll) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            if (CheckLoad == YES) {
                
            }else{
                CheckLoad = YES;
                if (CurrentPage == TotalPage) {
                    
                }else{
                    
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 150)];
                    UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, GetHeight + 40, 30, 30)];
                    [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                    [MainScroll addSubview:activityindicator1];
                    [activityindicator1 startAnimating];
                    [self SendDataToServer];
                }
                
            }
        }

    }
}
@end

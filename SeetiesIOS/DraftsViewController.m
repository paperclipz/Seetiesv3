//
//  DraftsViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/5/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "DraftsViewController.h"
#import "AsyncImageView.h"
#import "PublishViewController.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface DraftsViewController ()

@end
@implementation DraftsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    DataUrl = [[UrlDataClass alloc]init];
    // Do any additional setup after loading the view from its nib.
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64);
    
    ShowTitle.text = CustomLocalisedString(@"Drafts", nil);
    
    [self GetDraftsData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Drafts Page";
    
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
-(void)GetDraftsData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.GetDrafts_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLConnection *theConnection_GetDrafts = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetDrafts start];
    
    
    if( theConnection_GetDrafts ){
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}




- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [array enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         NSNumber *index = [NSNumber numberWithInteger:idx];
         [mutableDictionary setObject:obj forKey:index];
     }];
    NSDictionary *result = [NSDictionary.alloc initWithDictionary:mutableDictionary];
    return result;
}




-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Get Drafts return get data to server ===== %@",GetData);
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
 //   NSLog(@"Feed Json = %@",res);
    
    NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    NSLog(@"ErrorString is %@",ErrorString);
    NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"MessageString is %@",MessageString);
    
    if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        ShowAlertView.tag = 300;
        [ShowAlertView show];
    }else{
        
        // NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        //  NSLog(@"GetAllData ===== %@",GetAllData);
        
        //  NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
        //   NSLog(@"UserInfoData is %@",UserInfoData);
        // NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
        //  NSLog(@"UserInfoData_ProfilePhoto is %@",UserInfoData_ProfilePhoto);
        // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
        NSDictionary *titleData = [GetAllData valueForKey:@"title"];
        NSLog(@"titleData is %@",titleData);
        NSDictionary *messageData = [GetAllData valueForKey:@"message"];
        NSLog(@"messageData is %@",messageData);
        NSDictionary *locationData = [GetAllData valueForKey:@"location"];
        NSLog(@"locationData is %@",locationData);
        NSArray *locationDataArray = (NSArray *)[GetAllData valueForKey:@"location"];
        NSLog(@"locationDataArray is %@",locationDataArray);
        
        
        
        NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
        NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
        // NSLog(@"SingleLine is %@",SingleLine);
        
        
        CategoryArray = [[NSMutableArray alloc] initWithCapacity:[SingleLine count]];
        for (NSDictionary * dict in SingleLine) {
            NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
            [CategoryArray addObject:username];
        }
        NSLog(@"CategoryArray is %@",CategoryArray);
        CategoryIDArray = [[NSMutableArray alloc]init];
        for (int z = 0; z < [CategoryArray count]; z++) {
            NSString *TempGetSelectString = [[NSString alloc]initWithFormat:@"%@",[CategoryArray objectAtIndex:z]];
            // [CategoryIDArray addObject:TempGetSelectString];
            NSLog(@"TempGetSelectString is %@",TempGetSelectString);
            if ([TempGetSelectString isEqualToString:@"Food & Drink"]) {
                [CategoryIDArray addObject:@"6"];
            }
            if ([TempGetSelectString isEqualToString:@"Outdoor & Sport"]) {
                [CategoryIDArray addObject:@"9"];
            }
            if ([TempGetSelectString isEqualToString:@"Culture & Landmark"] || [TempGetSelectString isEqualToString:@"Culture & Attraction"]) {
                [CategoryIDArray addObject:@"12"];
            }
            if ([TempGetSelectString isEqualToString:@"Staycation"]) {
                [CategoryIDArray addObject:@"15"];
            }
            if ([TempGetSelectString isEqualToString:@"Nightlife"]) {
                [CategoryIDArray addObject:@"13"];
            }
            if ([TempGetSelectString isEqualToString:@"Art & Entertainment"]) {
                [CategoryIDArray addObject:@"1"];
            }
            if ([TempGetSelectString isEqualToString:@"Beauty & Fashion"]) {
                [CategoryIDArray addObject:@"2"];
            }
            if ([TempGetSelectString isEqualToString:@"Product"]) {
                [CategoryIDArray addObject:@"14"];
            }
            if ([TempGetSelectString isEqualToString:@"Kitchen Recipe"]) {
                [CategoryIDArray addObject:@"11"];
            }
        }
        
        NSLog(@"CategoryIDArray is %@",CategoryIDArray);
        
        TitleArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
        LangArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
//        for (NSDictionary * dict in titleData) {
//            if ([titleData count] == 0) {
//                [TitleArray addObject:@"nil"];
//                [LangArray addObject:@"English"];
//            }else{
//                NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
//                NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
//                    [TitleArray addObject:Title2];
//                    [LangArray addObject:@"中文"];
//                }else{
//                    [TitleArray addObject:Title1];
//                    [LangArray addObject:@"English"];
//                }
//            }
//            //
//            
//        }
        for (NSDictionary * dict in titleData) {
            if ([titleData count] == 0) {
                [TitleArray addObject:@"nil"];
                [LangArray addObject:@"English"];
            }else{
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
                                    [LangArray addObject:@"Filipino"];
                                }
                            }else{
                                [TitleArray addObject:IndonesianTitle];
                                [LangArray addObject:@"Bahasa Indonesia"];
                            }
                        }else{
                            [TitleArray addObject:ThaiTitle];
                            [LangArray addObject:@"ภาษาไทย"];
                        }
                    }else{
                        [TitleArray addObject:Title2];
                        [LangArray addObject:@"English"];
                    }
                    
                }else{
                    [TitleArray addObject:Title1];
                    [LangArray addObject:@"中文"];
                    
                }
            }
        }
        NSLog(@"TitleArray is %@",TitleArray);
        NSLog(@"LangArray is %@",LangArray);
        
        MessageArray = [[NSMutableArray alloc]initWithCapacity:[messageData count]];
        NSLog(@"messageData is %@",messageData);
        for (NSDictionary * dict in messageData) {
            if ([messageData count] == 0) {
                [MessageArray addObject:@"nil"];
            }else{
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
        NSLog(@"MessageArray is %@",MessageArray);
        
        LocationArray = [[NSMutableArray alloc]init];
        LatArray = [[NSMutableArray alloc]init];
        LongArray = [[NSMutableArray alloc]init];
        LocationArray = [[NSMutableArray alloc]init];
        
        FullAddressJsonArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [locationDataArray count]; i++) {
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[locationDataArray objectAtIndex:i]];
            NSLog(@"TempString is %@",TempString);
            if ([TempString isEqualToString:@""]) {
                [FullAddressJsonArray addObject:@"nil"];
                [LocationArray addObject:@"nil"];
                [LatArray addObject:@"nil"];
                [LongArray addObject:@"nil"];
            }else{
                NSDictionary* person = [locationDataArray objectAtIndex:i];
                NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[person objectForKey:@"address_components"]];
                NSLog(@"%@",[person objectForKey:@"address_components"]);
                [FullAddressJsonArray addObject:TempString];
                //  [TempArray addObject:TempString];
                
                NSString *TempString1 = [[NSString alloc]initWithFormat:@"%@",[person objectForKey:@"formatted_address"]];
                //NSLog(@"%@",[person objectForKey:@"address_components"]);
                [LocationArray addObject:TempString1];
                //[TempArray addObject:TempString];
                
                NSString *TempString2 = [[NSString alloc]initWithFormat:@"%@",[person objectForKey:@"lat"]];
                [LatArray addObject:TempString2];
                
                NSString *TempString3 = [[NSString alloc]initWithFormat:@"%@",[person objectForKey:@"lng"]];
                [LongArray addObject:TempString3];
                
            }
        }
        
        
        
        //            for (NSDictionary * dict in TempArray) {
        //                NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
        //                [LatArray addObject:lat];
        //                NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
        //                [LongArray addObject:lng];
        //                NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"formatted_address"]];
        //                NSLog(@"formatted_address is %@",formatted_address);
        //                [LocationArray addObject:formatted_address];
        //            }
        //            NSLog(@"LocationArray is %@",LocationArray);
        //
        
        
        
        
        
        
        //    NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
        //    NSLog(@"locationData_Address is %@",locationData_Address);
        //    FullAddressJsonArray = [NSMutableArray arrayWithArray:[locationData valueForKey:@"address_components"]];
        NSLog(@"FullAddressJsonArray %@", FullAddressJsonArray);
        
        NSLog(@"LocationArray %@", LocationArray);
        //    for (NSDictionary * dict in locationData_Address) {
        //        NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
        //        NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
        //
        //        NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Address2];
        //        [LocationArray addObject:FullString];
        //    }
        //    NSLog(@"LocationArray is %@",LocationArray);
        //    NSLog(@"LatArray is %@",LatArray);
        //    NSLog(@"LongArray is %@",LongArray);
        
        place_nameArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        LPhotoArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        LikesArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
        PostIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        FullPhotoArray = [[NSMutableArray alloc]init];
        LinkArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        CreatedDateArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
        for (NSDictionary * dict in GetAllData){
            NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
            [place_nameArray addObject:place_name];
            NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
            [LikesArray addObject:total_like];
            NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
            [PostIDArray addObject:post_id];
            NSString *created_at =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"created_at"]];
            [CreatedDateArray addObject:created_at];
            NSString *link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
            [LinkArray addObject:link];
            
            
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
                [FullPhotoArray addObject:GetSplitString];
            }
            
            NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
            //NSLog(@"SplitArray2 is %@",SplitArray2);
            NSString *FinalString = [SplitArray2 objectAtIndex:0];
            
            [LPhotoArray addObject:FinalString];
        }
        NSLog(@"place_nameArray is %@",place_nameArray);
        NSLog(@"LPhotoArray is %@",LPhotoArray);
        NSLog(@"FullPhotoArray is %@",FullPhotoArray);
        [self InitView];
    }


    //NSLog(@"FullPhotoStringArray is %@",FullPhotoStringArray);
    [ShowActivity stopAnimating];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(void)InitView{
    for (int i = 0; i < [LPhotoArray count]; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, 10 + i * 150, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
     //   NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray objectAtIndex:i]];
        //NSLog(@"url is %@",url);
     //   ShowNearbySmallImage.imageURL = url_NearbySmall;
        if ([FullImagesURL1 length] == 0) {
            ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowNearbySmallImage.imageURL = url_UserImage;
        }
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 10 + i * 150, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        NSString *TempLocation = [[NSString alloc]initWithFormat:@"%@",[LocationArray objectAtIndex:i]];
        if ([TempLocation isEqualToString:@"(null)"] || [TempLocation isEqualToString:@"nil"]) {
            TempLocation = @"";
        }
        
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 5 + i * 150, 165, 20);
        ShowLocationLabel.text = TempLocation;
       // ShowLocationLabel.text = @"test";
        ShowLocationLabel.font = [UIFont systemFontOfSize:12];
        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        
        NSString *TempTitle = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
        if ([TempTitle isEqualToString:@"(null)"]) {
            TempTitle = @"";
        }
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 30 + i * 150, 170, 80);
        ShowTitleLabel.text = TempTitle;
        ShowTitleLabel.numberOfLines = 5;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont systemFontOfSize:16];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        UIImageView *ShowUserImage = [[UIImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 110 + i * 150, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        NSString *GetSelectCategoryString = [[NSString alloc]initWithFormat:@"%@",[CategoryArray objectAtIndex:i]];
        if ([GetSelectCategoryString isEqualToString:@"Art & Entertainment"]) {
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Art&Entertainment.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Beauty & Fashion"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Beauty&Fashion.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Food & Drink"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Food&Drink.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Kitchen Recipe"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_KitchenRecipe.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Nightlife"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Nightlife.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Outdoor & Sport"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Outdoor&Sport.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Product"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Product.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Staycation"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Staycation.png"];
        }else if([GetSelectCategoryString isEqualToString:@"Culture & Landmark"]){
            ShowUserImage.image = [UIImage imageNamed:@"Icon_Culture&Attraction.png"];
        }
        

        NSString *ShowDate = [[NSString alloc]initWithFormat:@"Edited %@",[CreatedDateArray objectAtIndex:i]];
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(55, 115 + i * 150, 250, 20);
        ShowUserName.text = ShowDate;
        ShowUserName.font = [UIFont systemFontOfSize:12];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 150 + i * 150, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(0, 0 + i * 150, 320, 150)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [MainScroll addSubview:ShowNearbySmallImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserImage];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:ClickButton];
        
        [MainScroll setScrollEnabled:YES];
        MainScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll setContentSize:CGSizeMake(320, 200 + i * 150)];
    }
    
    
    
}
-(IBAction)ButtonClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
//    
//    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray objectAtIndex:getbuttonIDN] GetLink:[LinkArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray objectAtIndex:getbuttonIDN] GetTitle:[TitleArray objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray objectAtIndex:getbuttonIDN] GetMessage:[MessageArray objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray objectAtIndex:getbuttonIDN] GetLong:[LongArray objectAtIndex:getbuttonIDN] GetLocation:[LocationArray objectAtIndex:getbuttonIDN]];
    GetLang = [[NSString alloc]initWithFormat:@"%@",[LangArray objectAtIndex:getbuttonIDN]];
    
    if ([GetLang isEqualToString:@"English"]) {
        GetLangID = @"530b0ab26424400c76000003";
    }else if([GetLang isEqualToString:@"中文"]){
        GetLangID = @"530b0aa16424400c76000002";
    }if([GetLang isEqualToString:@"Bahasa Indonesia"]){
        GetLangID = @"53672e863efa3f857f8b4ed2";
    }if([GetLang isEqualToString:@"Filipino"]){
        GetLangID = @"539fbb273efa3fde3f8b4567";
    }if([GetLang isEqualToString:@"ภาษาไทย"]){
        GetLangID = @"544481503efa3ff1588b4567";
    }
  //  NSLog(@"GetLangID Done");
    NSString *GetSelectCategoryString = [[NSString alloc]initWithFormat:@"%@",[CategoryArray objectAtIndex:getbuttonIDN]];
//NSLog(@"GetSelectCategoryString Done");
    NSString *GetSelectCategoryIDN = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:getbuttonIDN]];
   // NSLog(@"GetSelectCategoryIDN Done");
    NSString *GetTempTitle = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:getbuttonIDN]];
   // NSLog(@"GetTempTitle Done");
    NSString *GetTempDescription = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:getbuttonIDN]];
  //  NSLog(@"GetTempDescription Done");
    NSString *GetTempPlaceName = [[NSString alloc]initWithFormat:@"%@",[place_nameArray objectAtIndex:getbuttonIDN]];
   // NSLog(@"GetTempPlaceName Done");
    NSString *GetTempAddress = [[NSString alloc]initWithFormat:@"%@",[LocationArray objectAtIndex:getbuttonIDN]];
   // NSLog(@"GetTempAddress Done");
    NSString *GetFullImageString = [[NSString alloc]initWithFormat:@"%@",[FullPhotoArray objectAtIndex:getbuttonIDN]];
    // NSLog(@"GetFullImageString Done");
   // NSLog(@"GetFullImageString is %@",GetFullImageString);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetLang forKey:@"SelectLanguage"];
    [defaults setObject:GetLangID forKey:@"SelectLanguageID"];

    if ([GetSelectCategoryString length] == 0) {
        
    }else{
    [defaults setObject:GetSelectCategoryString forKey:@"CategorySelected"];
    [defaults setObject:GetSelectCategoryIDN forKey:@"CategorySelectedIDN"];
    }
    if ([GetTempTitle length] == 0 || [GetTempTitle isEqualToString:@"(null)"]) {
        
    }else{
        [defaults setObject:GetTempTitle forKey:@"Publish_Title"];
    }
    if ([GetTempDescription length] == 0 || [GetTempDescription isEqualToString:@"(null)"]) {
    }else{
        [defaults setObject:GetTempDescription forKey:@"Publish_Description"];
    }
    if ([GetTempPlaceName length] == 0) {
        
    }else{
        [defaults setObject:GetTempPlaceName forKey:@"Location_PlaceName"];
    }
    if ([GetTempAddress length] == 0) {
        
    }else{
        [defaults setObject:GetTempAddress forKey:@"Location_Address"];
    }

    if ([GetFullImageString length] == 0) {
        
    }else{
        FullPhotoStringArray = [[NSMutableArray alloc]init];
        NSArray *SplitArray = [GetFullImageString componentsSeparatedByString:@","];
        NSLog(@"SplitArray is %@",SplitArray);
        for (int i = 0; i < [SplitArray count]; i++) {
            UIImage *DownloadImage = [[UIImage alloc]init];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[SplitArray objectAtIndex:i]]];
            DownloadImage = [UIImage imageWithData:data];
            //     //   tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            //     //   [ShowImgButton setImage:tempImg forState:UIControlStateNormal];
            NSString *base64 = [self encodeToBase64String:DownloadImage];;
            //        // NSLog(@"base64 is %@",base64);
            //
            [FullPhotoStringArray addObject:base64];
            
        }
        
        [defaults setObject:FullPhotoStringArray forKey:@"SelectImageData"];
    }

//    [defaults setObject:ShowAddress.text forKey:@"Location_Address"];
//    [defaults setObject:ShowPlaceName.text forKey:@"Location_PlaceName"];
    //[defaults setObject:GetSelectCategoryIDN forKey:@"CategorySelectedIDN"];
    [defaults synchronize];

    
    PublishViewController *PublishView = [[PublishViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PublishView animated:NO completion:nil];
    [PublishView GetIsupdatePost:@"YES" GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    

}
@end

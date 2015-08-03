//
//  CollectionsViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "CollectionsViewController.h"
#import "AsyncImageView.h"
#import "FeedDetailViewController.h"
#import "LandingV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
#import "FeedV2DetailViewController.h"
@interface CollectionsViewController ()

@end

@implementation CollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 113);
    
    DataUrl = [[UrlDataClass alloc]init];
    
    MainScroll.delegate = self;
    CheckLoad = NO;
    
    ShowNoDataView.hidden = YES;
    
    ShowTitle.text = CustomLocalisedString(@"MainTab_Like",nil);

    [self GetWhatYourLike];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
    self.screenName = @"IOS Likes Page";
    self.title = CustomLocalisedString(@"MainTab_Like",nil);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckRole = [defaults objectForKey:@"Role"];
    if ([CheckRole isEqualToString:@"user"]) {
    }else{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(135, screenHeight - 49, 50, 49);
        ShowImage.image = [UIImage imageNamed:@"TabBarPublish.png"];
        [self.tabBarController.view addSubview:ShowImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetWhatYourLike{
     [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetPost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetPost start];
    
    
    if( theConnection_GetPost ){
        webData = [NSMutableData data];
    }
}
-(void)GetMoreYourLike{

    if (CurrentPage == TotalPage) {
        
    }else{
        [ShowActivity startAnimating];
    CurrentPage += 1;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,(long)CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_MorePost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_MorePost start];
        
        
        if( theConnection_MorePost ){
            webData = [NSMutableData data];
        }
    }
    

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height)
    {
        // we are at the end
        NSLog(@"we are at the end");
        if (CheckLoad == YES) {
            
        }else{
            [self GetMoreYourLike];
            CheckLoad = YES;
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
    if (connection == theConnection_GetPost) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Likes return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"posts"];
                NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
                NSLog(@"page is %@",page);
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                NSLog(@"total_page is %@",total_page);
                CurrentPage = [page intValue];
                TotalPage = [total_page intValue];
                
                if (TotalPage == 0) {
                    ShowNoDataView.hidden = NO;
                }
                
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
                //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                //  NSLog(@"titleData is %@",titleData);
             //   NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                // NSLog(@"messageData is %@",messageData);
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                //  NSLog(@"locationData is %@",locationData_Nearby);
                NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
                //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
             //   NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
              //  NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
                //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                
                
//                CategoryArray = [[NSMutableArray alloc] initWithCapacity:[SingleLine count]];
//                for (NSDictionary * dict in SingleLine) {
//                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                    [CategoryArray addObject:username];
//                }
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
                    if ([dict count] == 0 || dict == nil || [dict objectForKey:@"530b0ab26424400c76000003"] == nil) {
                        NSLog(@"titleData nil");
                        [TitleArray addObject:@"nil"];
                        //                            [LangArray addObject:@"English"];
                    }else{
                        NSString *ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *EngTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        NSLog(@"Title1 is %@",ChineseTitle);
                        NSLog(@"Title2 is %@",EngTitle);
                        //                if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        //                    [TitleArray_Nearby addObject:Title2];
                        //                    [LangArray_Nearby addObject:@"EN"];
                        //                }else{
                        //                    [TitleArray_Nearby addObject:Title1];
                        //                    [LangArray_Nearby addObject:@"CN"];
                        //                }
                        if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
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
                                [TitleArray addObject:EngTitle];
                            }
                            
                        }else{
                            [TitleArray addObject:ChineseTitle];
                        }

                    }
                                    }
                NSLog(@"TitleArray is %@",TitleArray);
                
//                MessageArray = [[NSMutableArray alloc]initWithCapacity:[messageData count]];
//                for (NSDictionary * dict in messageData) {
//                    
//                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
//                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                    
//                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
//                        [MessageArray addObject:Title2];
//                    }else{
//                        [MessageArray addObject:Title1];
//                    }
//                }
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
                    NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                    NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                    
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Address2];
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
                
                NSLog(@"LikesArray = %@",LikesArray);
                
                DataCount = 0;
                DataTotal = [TitleArray count];
                
                [self InitView];
            }
        }
        
        
       
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get more Likes return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
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
        NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
        NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
        //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);

        for (NSDictionary * dict in SingleLine) {
            NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
            [CategoryArray addObject:username];
        }
        //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);

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

        for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
            NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
            [UserInfo_UrlArray addObject:url];
        }
        //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);

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
        NSLog(@"TitleArray is %@",TitleArray);

        for (NSDictionary * dict in messageData) {
            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
            
            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                [MessageArray addObject:Title2];
            }else{
                [MessageArray addObject:Title1];
            }
        }

        for (NSDictionary * dict in locationData) {
            NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
            [LatArray addObject:lat];
            NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
            [LongArray addObject:lng];
        }
        
        for (NSDictionary * dict in locationData_Address) {
            NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
            NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
            
            NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Address2];
            [LocationArray addObject:FullString];
        }
        // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
        NSLog(@"LatArray_Nearby is %@",LatArray);
        NSLog(@"LongArray_Nearby is %@",LongArray);
        
        
        
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
        
        NSLog(@"LikesArray = %@",LikesArray);
        DataCount = DataTotal;
        DataTotal = [TitleArray count];
        [self InitView];
        CheckLoad = NO;
    }
   
    
    [ShowActivity stopAnimating];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetBackCheckAPI = [defaults objectForKey:@"CheckAPI"];
            NSString *GetBackAPIVersion = [defaults objectForKey:@"APIVersionSet"];
            
            //cancel clicked ...do your action
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
            for (NSString *key in [defaultsDictionary allKeys]) {
                NSLog(@"removing user pref for %@", key);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            //save back
            [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
            [defaults setObject:GetBackAPIVersion forKey:@"APIVersionSet"];
            [defaults synchronize];
            
            
            LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }else{
            //reset clicked
        }
    }
    
}
-(void)InitView{
    
    for (UIView * view in MainScroll.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
        ShowNearbySmallImage.frame = CGRectMake(205, 20 + i * 158, 100 , 100);
        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
        ShowNearbySmallImage.clipsToBounds = YES;
        ShowNearbySmallImage.tag = 99;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
        ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            //NSLog(@"url is %@",url);
            ShowNearbySmallImage.imageURL = url_NearbySmall;
        }
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, 20 + i * 158, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(30, 16 + i * 158, 165, 20);
        ShowLocationLabel.text = [LocationArray objectAtIndex:i];
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, 48 + i * 158, 170, 50);
        ShowTitleLabel.text = [TitleArray objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(15, 118 + i * 158, 30, 30);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=15;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
         ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 118 + i * 158, 250, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 158 + i * 158, 320, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(0, 0 + i * 158, 320, 158)];
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
        [MainScroll setContentSize:CGSizeMake(320, 160 + i * 158)];
    }
    


}
-(IBAction)ButtonClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray objectAtIndex:getbuttonIDN] GetLink:[LinkArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray objectAtIndex:getbuttonIDN] GetTitle:[TitleArray objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray objectAtIndex:getbuttonIDN] GetMessage:[MessageArray objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray objectAtIndex:getbuttonIDN] GetLong:[LongArray objectAtIndex:getbuttonIDN] GetLocation:[LocationArray objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
             DataCount = 0;
            DataTotal = 0;
            [self GetWhatYourLike];
            [refreshControl endRefreshing];
            NSLog(@"refresh end");
        });
    });
}
@end

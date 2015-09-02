//
//  SearchDetailViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/3/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "AsyncImageView.h"
#import "UserProfileV2ViewController.h"
#import "FeedV2DetailViewController.h"
#import "Filter2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "NSString+ChangeAsciiString.h"
@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SortByButton.frame = CGRectMake(screenWidth - 70, 64, 70, 50);
    SortbyFullButton.frame = CGRectMake(0, 64, screenWidth, 50);
    LineButton.frame = CGRectMake(screenWidth - 75, 75, 1, 30);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    Background_Search.frame = CGRectMake(0, 64, screenWidth, 50);
    Background_Search.hidden = YES;
   
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    UserScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64 , screenWidth, screenHeight - 64);
    ShowSearchUserView.frame = CGRectMake(0, 114, screenWidth, screenHeight - 114);
    UserScroll.frame = CGRectMake(0, 0 , ShowSearchUserView.frame.size.width, ShowSearchUserView.frame.size.height);
    StringSortby = @"3";
    CheckInt = 0;
    
    SearchText.delegate = self;
    
    ShowNoDataView.hidden = YES;
    ShowNoDataView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowNoText_1.frame = CGRectMake(15, 169, screenWidth - 30, 40);
    ShowNoText_2.frame = CGRectMake(15, 204, screenWidth - 30, 100);
    ShowNoText_1.text = CustomLocalisedString(@"NoResultFound", nil);
    ShowNoText_2.text = CustomLocalisedString(@"Pleasetryadiffrentsearch", nil);
    
    [SortByButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    
    ShowSearchUserView.hidden = YES;
    [self.view addSubview:ShowSearchUserView];
    
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    heightcheck = 0;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    MainScroll.hidden = YES;
    ShowSearchUserView.hidden = NO;
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Search Detail Page";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        
    }else{
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        [self.view addSubview:MainScroll];
        CheckLoad = NO;
        TotalPage = 1;
        CurrentPage = 0;
        GetHeight = 0;
        CheckFirstTimeLoad = 0;
        DataCount = 0;
        DataTotal = 0;
        heightcheck = 0;

        if (CheckWhichOne == 1) {
            [self SendSearchKeywordData];
        }else{
            [self SendCategoryData];
        }
    }
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetTitle:(NSString *)String{
   // ShowTitle.text = String;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if ([String isEqualToString:@"Results"]) {
        ShowTitle.text = CustomLocalisedString(@"SearchResult", nil);
        SearchText.frame = CGRectMake(43, 74, screenWidth - 103 - 15, 30);
    }else if([String isEqualToString:@"All"]){
        SearchText.frame = CGRectMake(43, 74, screenWidth - 103 - 15, 30);
        ShowTitle.text = CustomLocalisedString(@"NearbyResult", nil);
    }else{
        //ShowTitle.text = CustomLocalisedString(@"findPeople", nil);
        ShowTitle.text = String;
        LineButton.hidden = YES;
        SortByButton.hidden = YES;
        SortbyFullButton.hidden = YES;
        SearchText.frame = CGRectMake(43, 74, screenWidth - 43 - 15, 30);
    }
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
-(void)GetSearchKeyword:(NSString *)Keyword Getlat:(NSString *)lat GetLong:(NSString *)Long{

    GetKeywordText = Keyword;
    GetLat = lat;
    GetLong = Long;
    [self SendSearchKeywordData];
   // ShowSearchText.text = Keyword;
    SearchText.text = Keyword;
    
    CheckInt = 1;
    SearchText.enabled = NO;
}
-(void)SearchCategory:(NSString *)GetCategory Getlat:(NSString *)lat GetLong:(NSString *)Long GetCategoryName:(NSString *)CategoryName{

    CheckInt = 2;
    
    GetCategoryText = GetCategory;
    SearchText.text = CategoryName;
    
    GetLat = lat;
    GetLong = Long;
    [self SendCategoryData];
    

    SearchText.enabled = NO;

}
-(void)GetAllUserSuggestions:(NSString *)Suggestions{
    [self GetAllUserData];
    Background_Search.hidden = NO;
    CheckInt = 3;
    SearchText.enabled = YES;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    SearchText.frame = CGRectMake(43, 74, screenWidth - 43 - 15, 30);
    SearchText.placeholder = CustomLocalisedString(@"Searchpeople", nil);
}
-(void)GetExpertsSearchKeyword:(NSString *)ExpertsKeyword{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    SearchText.frame = CGRectMake(43, 74, screenWidth - 43 - 15, 30);
    CheckInt = 3;
    GetExpertsKeyword = ExpertsKeyword;
   // ShowSearchText.text = ExpertsKeyword;
    SearchText.text = ExpertsKeyword;
    [self SendSearchExpertsData];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchText resignFirstResponder];
    MainScroll.hidden = NO;
    ShowSearchUserView.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    
    if ([SearchText.text length] == 0) {
       [textField resignFirstResponder];
        MainScroll.hidden = NO;
        ShowSearchUserView.hidden = YES;
    }else{
        [textField resignFirstResponder];
        if (CheckInt == 1) {
            //keyword
            GetKeywordText = SearchText.text;
            [self SendSearchKeywordData];
        }else if (CheckInt == 3){
            GetExpertsKeyword = SearchText.text;
            [self SendSearchExpertsData];
        }else{
        
        }
    }
    
    
    
    return YES;
}
-(void)GetAllUserData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@user/suggestions?token=%@&number_of_suggestions=30",DataUrl.UserWallpaper_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetAllUserData check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllUserData start];
    
    
    if( theConnection_GetAllUserData ){
        webData = [NSMutableData data];
    }
}
-(void)SendSearchKeywordData{
    CheckWhichOne = 1;
   [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetSortByString = [defaults objectForKey:@"Filter_Search_SortBy"];
        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@search?token=%@&keyword=%@&sort=%@&lat=%@&lng=%@&page=%li",DataUrl.UserWallpaper_Url,GetExpertToken,GetKeywordText,StringSortby,GetLat,GetLong,(long)CurrentPage];
        
        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
        }
        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
        }
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetSearchKeyword = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetSearchKeyword start];
    
    
    if( theConnection_GetSearchKeyword ){
        webData = [NSMutableData data];
    }
    }
}
-(void)SendCategoryData{
    CheckWhichOne = 2;
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetSortByString = [defaults objectForKey:@"Filter_Search_SortBy"];
        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@search?token=%@&categories=%@&sort=%@&lat=%@&lng=%@&keyword=&page=%li",DataUrl.UserWallpaper_Url,GetExpertToken,GetCategoryText,StringSortby,GetLat,GetLong,(long)CurrentPage];
        
        
        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
        }
        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
        }

        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetSearchCategory = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetSearchCategory start];
        
        
        if( theConnection_GetSearchCategory ){
            webData = [NSMutableData data];
        }
    }

}
-(void)SendSearchExpertsData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@expert/search?token=%@&keyword=%@",DataUrl.UserWallpaper_Url,GetExpertToken,GetExpertsKeyword];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetExpertsSearch = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetExpertsSearch start];
    
    
    if( theConnection_GetExpertsSearch ){
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
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetSearchKeyword) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Feed Json = %@",res);
        
        NSDictionary *ResData = [res valueForKey:@"data"];
        
        NSDictionary *recommendationsData = [ResData valueForKey:@"recommendations"];
        
        NSArray *GetAllData = (NSArray *)[recommendationsData valueForKey:@"posts"];
        NSDictionary *locationData = [GetAllData valueForKey:@"location"];
        NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
        NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
        NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
        if ([GetAllData count] == 0) {
            ShowNoDataView.hidden = NO;
        }else{
        ShowNoDataView.hidden = YES;
        }
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
            CheckFirstTimeLoad = 1;
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
        }
        for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
            NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
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
        
        
        NSDictionary *ResDataUser = [ResData valueForKey:@"experts"];
        Experts_Username_Array = [[NSMutableArray alloc]init];
        Experts_Name_Array = [[NSMutableArray alloc]init];
        Experts_ProfilePhoto_Array = [[NSMutableArray alloc]init];
        Experts_uid_Array = [[NSMutableArray alloc]init];
        Experts_Followed_Array = [[NSMutableArray alloc]init];
        for (NSDictionary * dict in ResDataUser){
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [Experts_uid_Array addObject:uid];
            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [Experts_ProfilePhoto_Array addObject:profile_photo];
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"followed"]];
            [Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
            [Experts_Name_Array addObject:name];
        }
        
        [self InitView];
    }else if(connection == theConnection_GetSearchCategory){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Search Category return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        NSDictionary *ResData = [res valueForKey:@"data"];
        
        NSDictionary *recommendationsData = [ResData valueForKey:@"recommendations"];
        NSLog(@"recommendationsData is %@",recommendationsData);
        NSArray *GetAllData = (NSArray *)[recommendationsData valueForKey:@"posts"];
        NSDictionary *locationData = [GetAllData valueForKey:@"location"];
        NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
        NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
        NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
         NSLog(@"GetAllData ===== %@",GetAllData);
        if ([GetAllData count] == 0) {
            ShowNoDataView.hidden = NO;
        }else{
            ShowNoDataView.hidden = YES;
        }
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
            CheckFirstTimeLoad = 1;
        }else{
            
        }

        //NSDictionary *locationData = [GetAllData valueForKey:@"location"];
   
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
        }

        for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
            NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
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
              //  NSString * result = [testarray componentsJoinedByString:@","];
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
            
//            NSLog(@"Locality is %@",Locality);
//            NSLog(@"Address3 is %@",Address3);
//            NSLog(@"Address2 is %@",Address2);
//            NSLog(@"Address1 is %@",Address1);
//            NSLog(@"Country is %@",Country);
            
            //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
            [LocationArray addObject:FullString];
        }

        DataCount = DataTotal;
        DataTotal = [LPhotoArray count];
        CheckLoad = NO;
        
        [self InitView];
    }else if(connection == theConnection_GetAllUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get All User return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Experts Json = %@",res);
        
        NSDictionary *UserInfoData = [res valueForKey:@"random_users"];
        All_Experts_Username_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_Name_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_ProfilePhoto_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_uid_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        All_Experts_Followed_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        
        for (NSDictionary * dict in UserInfoData){
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [All_Experts_uid_Array addObject:uid];
            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [All_Experts_ProfilePhoto_Array addObject:profile_photo];
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"followed"]];
            [All_Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [All_Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
            [All_Experts_Name_Array addObject:name];
        }
        
        NSLog(@"All_Experts_Name_Array is %@",All_Experts_Name_Array);
        
        [self InitAllUserView];
        
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Search Experts return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Experts Json = %@",res);
        
        NSString *TotalCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_count"]];
        NSLog(@"TotalCount is %@",TotalCount);
        if ([TotalCount isEqualToString:@"0"]) {
            ShowNoDataView.hidden = NO;
            ShowSearchUserView.hidden = YES;
        }else{
            ShowNoDataView.hidden = YES;
            NSDictionary *UserInfoData = [res valueForKey:@"experts"];
            Experts_Username_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            Experts_Name_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            Experts_ProfilePhoto_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            Experts_uid_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            Experts_Followed_Array = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
        for (NSDictionary * dict in UserInfoData){
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [Experts_uid_Array addObject:uid];
            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [Experts_ProfilePhoto_Array addObject:profile_photo];
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"followed"]];
            [Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
            [Experts_Name_Array addObject:name];
        }
            
            
            [self InitExpertsView];
        }
    }
    [ShowActivity stopAnimating];

}
-(void)InitAllUserView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView * view in MainScroll.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [All_Experts_Name_Array count]; i++) {
        AsyncImageView *ShowExpertProfilePhoto = [[AsyncImageView alloc]init];
        ShowExpertProfilePhoto.frame = CGRectMake(10 , 20 + i * 70, 40, 40);
        ShowExpertProfilePhoto.contentMode = UIViewContentModeScaleAspectFill;
        ShowExpertProfilePhoto.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowExpertProfilePhoto.layer.cornerRadius=20;
        ShowExpertProfilePhoto.layer.borderWidth=1;
        ShowExpertProfilePhoto.layer.masksToBounds = YES;
        ShowExpertProfilePhoto.layer.borderColor=[[UIColor clearColor] CGColor];
        ShowExpertProfilePhoto.image = [UIImage imageNamed:@"avatar.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowExpertProfilePhoto];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[All_Experts_ProfilePhoto_Array objectAtIndex:i]];
        
        //NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowExpertProfilePhoto.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowExpertProfilePhoto.imageURL = url_UserImage;
        }
        
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(60, 15 + i * 70, 200, 30);
        ShowName.text = [All_Experts_Name_Array objectAtIndex:i];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 40 + i * 70, 200, 20);
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        NSString *UsernameString = [[NSString alloc]initWithFormat:@"@%@",[All_Experts_Username_Array objectAtIndex:i]];
        ShowUserName.text = UsernameString;
        ShowUserName.textColor = [UIColor grayColor];
        
        UIButton *ViewProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ViewProfileButton setFrame:CGRectMake(0, 20+ i * 70, screenWidth, 70)];
        [ViewProfileButton setTitle:@"" forState:UIControlStateNormal];
        [ViewProfileButton setBackgroundColor:[UIColor clearColor]];
        ViewProfileButton.tag = i;
        [ViewProfileButton addTarget:self action:@selector(AllExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 75 + i * 70, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        [MainScroll addSubview:ShowExpertProfilePhoto];
        [MainScroll addSubview:ShowName];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:ViewProfileButton];
        [MainScroll addSubview:Line01];
        
        
        [MainScroll setScrollEnabled:YES];
        MainScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll setContentSize:CGSizeMake(screenWidth, 75 + i * 70)];
    }
}
-(void)InitExpertsView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView * view in UserScroll.subviews) {
        [view removeFromSuperview];
    }

    for (int i = 0; i < [Experts_Name_Array count]; i++) {
        AsyncImageView *ShowExpertProfilePhoto = [[AsyncImageView alloc]init];
        ShowExpertProfilePhoto.frame = CGRectMake(10 , 20 + i * 70, 40, 40);
        ShowExpertProfilePhoto.contentMode = UIViewContentModeScaleAspectFill;
        ShowExpertProfilePhoto.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowExpertProfilePhoto.layer.cornerRadius=20;
        ShowExpertProfilePhoto.layer.borderWidth=1;
        ShowExpertProfilePhoto.layer.masksToBounds = YES;
        ShowExpertProfilePhoto.layer.borderColor=[[UIColor clearColor] CGColor];
        ShowExpertProfilePhoto.image = [UIImage imageNamed:@"avatar.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowExpertProfilePhoto];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Experts_ProfilePhoto_Array objectAtIndex:i]];

        //NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowExpertProfilePhoto.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowExpertProfilePhoto.imageURL = url_UserImage;
        }
        
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(60, 15 + i * 70, 200, 30);
        ShowName.text = [Experts_Name_Array objectAtIndex:i];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 40 + i * 70, 200, 20);
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        NSString *UsernameString = [[NSString alloc]initWithFormat:@"@%@",[Experts_Username_Array objectAtIndex:i]];
        ShowUserName.text = UsernameString;
        ShowUserName.textColor = [UIColor grayColor];
        
        UIButton *ViewProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ViewProfileButton setFrame:CGRectMake(0, 20+ i * 70, screenWidth, 70)];
        [ViewProfileButton setTitle:@"" forState:UIControlStateNormal];
        [ViewProfileButton setBackgroundColor:[UIColor clearColor]];
        ViewProfileButton.tag = i;
        [ViewProfileButton addTarget:self action:@selector(ExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 75 + i * 70, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        [UserScroll addSubview:ShowExpertProfilePhoto];
        [UserScroll addSubview:ShowName];
        [UserScroll addSubview:ShowUserName];
        [UserScroll addSubview:ViewProfileButton];
        [UserScroll addSubview:Line01];
        
        
        [UserScroll setScrollEnabled:YES];
        UserScroll.backgroundColor = [UIColor whiteColor];
        [UserScroll setContentSize:CGSizeMake(screenWidth, 75 + i * 70)];
    }
}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    
//    for (UIView *subview in MainScroll.subviews) {
//        // if ([subview isKindOfClass:[UIButton class]])
//        [subview removeFromSuperview];
//    }
    heightcheck += 20;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"%lu Posts",(unsigned long)[place_nameArray count]];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"%lu People",(unsigned long)[Experts_Name_Array count]];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringPeople, nil];
    UISegmentedControl *ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, heightcheck, screenWidth - 30, 29);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:ProfileControl];
    
    
    heightcheck += 49;
    
    PostsView = [[UIView alloc]init];
    PostsView.frame = CGRectMake(0, heightcheck, screenWidth, 400);
    PostsView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:PostsView];
    
    PeopleView = [[UIView alloc]init];
    PeopleView.frame = CGRectMake(0, heightcheck, screenWidth, 600);
    PeopleView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:PeopleView];
    
    PeopleView.hidden = YES;
    PostsView.hidden = NO;
    
    [self InitPostsDataView];
    
    
//    for (NSInteger i = DataCount; i < DataTotal; i++) {
//        
//        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
//        ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 245);
//        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowImage.layer.masksToBounds = YES;
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[LPhotoArray objectAtIndex:i]];
//        if ([FullImagesURL_First length] == 0) {
//            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        }else{
//            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//            ShowImage.imageURL = url_NearbySmall;
//        }
//        [MainScroll addSubview:ShowImage];
//        
//        UIImageView *ImageShade = [[UIImageView alloc]init];
//        ImageShade.frame = CGRectMake(0, heightcheck + i, screenWidth, 149);
//        ImageShade.image = [UIImage imageNamed:@"ImageShade.png"];
//        ImageShade.alpha = 0.5;
//        [MainScroll addSubview:ImageShade];
//        
//        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        SelectButton.frame = CGRectMake(0, heightcheck + i, screenWidth, 340);
//        [SelectButton setTitle:@"" forState:UIControlStateNormal];
//        SelectButton.tag = i;
//        [SelectButton setBackgroundColor:[UIColor clearColor]];
//        [SelectButton addTarget:self action:@selector(ProductButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:SelectButton];
//        
//        
//        UIImageView *ShowPin = [[UIImageView alloc]init];
//        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
//        ShowPin.frame = CGRectMake(15, 259 + heightcheck + i, 8, 11);
//        [MainScroll addSubview:ShowPin];
//        
//        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[DistanceArray objectAtIndex:i]];
//        if ([TempDistanceString isEqualToString:@"0"]) {
//            
//        }else{
//            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
//            int x_Nearby = [TempDistanceString intValue] / 1000;
//            // NSLog(@"x_Nearby is %i",x_Nearby);
//            
//            NSString *FullShowLocatinString;
//            if (x_Nearby < 100) {
//                if (x_Nearby <= 1) {
//                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within 1km"];
//                }else{
//                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within %.fkm",strFloat];
//                }
//                
//            }else{
//                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[SearchDisplayNameArray objectAtIndex:i]];
//                
//            }
//            
//            //  NSLog(@"FullShowLocatinString is %@",FullShowLocatinString);
//            
//            UILabel *ShowDistance = [[UILabel alloc]init];
//            ShowDistance.frame = CGRectMake(screenWidth - 115, 254 + heightcheck + i, 100, 20);
//            ShowDistance.text = FullShowLocatinString;
//            ShowDistance.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//            ShowDistance.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//            ShowDistance.textAlignment = NSTextAlignmentRight;
//            ShowDistance.backgroundColor = [UIColor clearColor];
//            [MainScroll addSubview:ShowDistance];
//        }
//        
//        
//        
//        UILabel *ShowAddress = [[UILabel alloc]init];
//        ShowAddress.frame = CGRectMake(30, 254 + heightcheck + i, screenWidth - 150, 20);
//        ShowAddress.text = [place_nameArray objectAtIndex:i];
//        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//        ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//        ShowAddress.backgroundColor = [UIColor clearColor];
//        [MainScroll addSubview:ShowAddress];
//        
//        
//        
//        heightcheck += 284;
//        
//        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[TitleArray objectAtIndex:i]];
//        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
//        }else{
//            UILabel *TempShowTitle = [[UILabel alloc]init];
//            TempShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
//            TempShowTitle.text = TempGetStirng;
//            TempShowTitle.backgroundColor = [UIColor clearColor];
//            TempShowTitle.numberOfLines = 2;
//            TempShowTitle.textAlignment = NSTextAlignmentLeft;
//            TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//            TempShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
//            //            ShowTitle.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetStirng
//            //                                                                                               tracking:100
//            //                                                                                                   font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
//            [MainScroll addSubview:TempShowTitle];
//
//            if([TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=TempShowTitle.frame.size.height)
//            {
//                TempShowTitle.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
//            }
//            heightcheck += TempShowTitle.frame.size.height + 10;
//            
//            //   heightcheck += 30;
//        }
//        
//        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
//        TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
//        if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
//        }else{
//            UILabel *ShowMessage = [[UILabel alloc]init];
//            ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30, 40);
//            //  ShowMessage.text = TempGetMessage;
//            NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
//            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
//            TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
//            UILabel *ShowCaptionText = [[UILabel alloc]init];
//            //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
//            ShowCaptionText.numberOfLines = 0;
//            ShowCaptionText.textColor = [UIColor whiteColor];
//            // ShowCaptionText.text = [captionArray objectAtIndex:i];
//            NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
//            NSString *str = TempGetStirngMessage;
//            NSError *error = nil;
//            
//            //I Use regex to detect the pattern I want to change color
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
//            NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
//            for (NSTextCheckingResult *match in matches) {
//                NSRange wordRange = [match rangeAtIndex:0];
//                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
//            }
//            
//            [ShowMessage setAttributedText:string];
//            
//            ShowMessage.backgroundColor = [UIColor clearColor];
//            ShowMessage.numberOfLines = 3;
//            ShowMessage.textAlignment = NSTextAlignmentLeft;
//            ShowMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//            ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//            //            ShowMessage.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetMessage
//            //                                                                                 tracking:100
//            //                                                                                     font:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//            [MainScroll addSubview:ShowMessage];
//            
//            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
//            {
//                ShowMessage.frame = CGRectMake(15, heightcheck + i, screenWidth - 30,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
//            }
//            heightcheck += ShowMessage.frame.size.height + 10;
//            //   heightcheck += 30;
//        }
//        
//        
//        
//        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
//        ShowUserProfileImage.frame = CGRectMake(15, heightcheck + i , 30, 30);
//        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
//        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//        ShowUserProfileImage.layer.cornerRadius = 15;
//        ShowUserProfileImage.layer.borderWidth=0;
//        ShowUserProfileImage.layer.masksToBounds = YES;
//        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
//        [MainScroll addSubview:ShowUserProfileImage];
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
//        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
//        if ([FullImagesURL length] == 0) {
//            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
//        }else{
//            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
//            //NSLog(@"url is %@",url);
//            ShowUserProfileImage.imageURL = url_NearbySmall;
//        }
//        
//        
//        UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, heightcheck + i , 200, 30)];
//        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
//        OpenProfileButton.tag = i;
//        OpenProfileButton.backgroundColor = [UIColor clearColor];
//        [OpenProfileButton addTarget:self action:@selector(ExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:OpenProfileButton];
//        
//        UILabel *ShowUserName = [[UILabel alloc]init];
//        ShowUserName.frame = CGRectMake(55, heightcheck + i, 200, 30);
//        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
//        ShowUserName.backgroundColor = [UIColor clearColor];
//        ShowUserName.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
//        ShowUserName.textAlignment = NSTextAlignmentLeft;
//        ShowUserName.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:15];
//        [MainScroll addSubview:ShowUserName];
//        
//        NSString *CheckCommentTotal = [[NSString alloc]initWithFormat:@"%@",[TotalCommentArray objectAtIndex:i]];
//        NSString *CheckLikeTotal = [[NSString alloc]initWithFormat:@"%@",[TotalLikeArray objectAtIndex:i]];
//        NSString *CheckSelfLike = [[NSString alloc]initWithFormat:@"%@",[SelfCheckLikeArray objectAtIndex:i]];
//        
//        
//        
//        if ([CheckCommentTotal isEqualToString:@"0"]) {
//            
//            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
//            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
//            ShowCommentIcon.frame = CGRectMake(screenWidth - 23 - 15, heightcheck + i + 6 ,23, 19);
//            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
//            [MainScroll addSubview:ShowCommentIcon];
//            
//            if ([CheckLikeTotal isEqualToString:@"0"]) {
//                
//                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
//                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                ShowLikesIcon.frame = CGRectMake(screenWidth - 23 - 15 - 23 - 20 , heightcheck + i + 6 ,23, 19);
//                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
//                [MainScroll addSubview:ShowLikesIcon];
//            }else{
//                
//                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                }else{
//                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
//                }
//                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                //    ShowLikesIcon.backgroundColor = [UIColor purpleColor];
//                ShowLikesIcon.frame = CGRectMake(screenWidth - 78 - 23, heightcheck + i + 6 ,23, 19);
//                [MainScroll addSubview:ShowLikesIcon];
//                
//                UILabel *ShowLikeCount = [[UILabel alloc]init];
//                ShowLikeCount.frame = CGRectMake(screenWidth - 78, heightcheck + i, 20, 30);
//                ShowLikeCount.text = CheckLikeTotal;
//                ShowLikeCount.textAlignment = NSTextAlignmentRight;
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//                }else{
//                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
//                }
//                //    ShowLikeCount.backgroundColor = [UIColor purpleColor];
//                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//                [MainScroll addSubview:ShowLikeCount];
//            }
//        }else{
//            
//            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
//            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
//            ShowCommentIcon.frame = CGRectMake(screenWidth - 35 - 23 , heightcheck + i + 6 ,23, 19);
//            //  ShowCommentIcon.backgroundColor = [UIColor redColor];
//            [MainScroll addSubview:ShowCommentIcon];
//            
//            UILabel *ShowCommentCount = [[UILabel alloc]init];
//            ShowCommentCount.frame = CGRectMake(screenWidth - 20 - 15, heightcheck + i, 20, 30);
//            ShowCommentCount.text = CheckCommentTotal;
//            ShowCommentCount.textAlignment = NSTextAlignmentRight;
//            //   ShowCommentCount.backgroundColor = [UIColor redColor];
//            ShowCommentCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//            ShowCommentCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//            [MainScroll addSubview:ShowCommentCount];
//            
//            if ([CheckLikeTotal isEqualToString:@"0"]) {
//                
//                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
//                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                ShowLikesIcon.frame = CGRectMake(screenWidth - 101, heightcheck + i + 6 ,23, 19);
//                // ShowLikesIcon.backgroundColor = [UIColor purpleColor];
//                [MainScroll addSubview:ShowLikesIcon];
//            }else{
//                
//                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                }else{
//                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
//                }
//                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
//                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
//                ShowLikesIcon.frame = CGRectMake(screenWidth - 121, heightcheck + i + 6 ,23, 19);
//                [MainScroll addSubview:ShowLikesIcon];
//                
//                UILabel *ShowLikeCount = [[UILabel alloc]init];
//                ShowLikeCount.frame = CGRectMake(screenWidth - 98, heightcheck + i, 20, 30);
//                ShowLikeCount.text = CheckLikeTotal;
//                ShowLikeCount.textAlignment = NSTextAlignmentRight;
//                if ([CheckSelfLike isEqualToString:@"0"]) {
//                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
//                }else{
//                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
//                }
//                // ShowLikeCount.backgroundColor = [UIColor purpleColor];
//                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//                [MainScroll addSubview:ShowLikeCount];
//            }
//            
//            
//        }
//        
//        
//        heightcheck += 55;
//        
//        UIImageView *ShowGradient = [[UIImageView alloc]init];
//        ShowGradient.frame = CGRectMake(0, heightcheck + i, screenWidth, 25);
//        ShowGradient.image = [UIImage imageNamed:@"FeedGradient.png"];
//        [MainScroll addSubview:ShowGradient];
//        heightcheck += 24;
//        
//        [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + i)];
//    }

}
- (void)segmentAction:(UISegmentedControl *)segment
{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"PostView click");
            PostsView.hidden = NO;
            PeopleView.hidden = YES;
            [self InitPostsDataView];
            
            break;
        case 1:
            NSLog(@"PeopleView click");
            PostsView.hidden = YES;
            PeopleView.hidden = NO;
            
            [self initPeopleDataView];
            
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitPostsDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PostGetHeight = 0;
    
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(15, PostGetHeight, screenWidth - 30, 150);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [PostsView addSubview: TempButton];
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(25, PostGetHeight + 10, 30, 30);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=15;
        UserImage.layer.borderWidth=0;
         UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            UserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            UserImage.imageURL = url_NearbySmall;
        }
        [PostsView addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(70, PostGetHeight + 10, 200, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor blackColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostsView addSubview:ShowUserName];
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15, PostGetHeight + 50, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [PostsView addSubview:Line01];
        
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(25, PostGetHeight + 60, 80, 80);
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

        [PostsView addSubview:ShowImage];
        
        
        UILabel *TempShowTitle = [[UILabel alloc]init];
        TempShowTitle.frame = CGRectMake(120, PostGetHeight + 60, screenWidth - 170, 20);
        TempShowTitle.text = [TitleArray objectAtIndex:i];
        TempShowTitle.backgroundColor = [UIColor clearColor];
        TempShowTitle.textAlignment = NSTextAlignmentLeft;
        TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        TempShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostsView addSubview:TempShowTitle];

        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(120, PostGetHeight + 82, 8, 11);
        [PostsView addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(140, PostGetHeight + 80, screenWidth - 190, 20);
        ShowPlaceName.text = [place_nameArray objectAtIndex:i];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [PostsView addSubview:ShowPlaceName];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(120, PostGetHeight + 100, screenWidth - 170, 20);
        ShowLocation.text = @"Kuala Limpur . Open now";
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLocation.textColor = [UIColor grayColor];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [PostsView addSubview:ShowLocation];
        
        
        PostGetHeight += 160;
        
    }
    PostsView.frame = CGRectMake(0, heightcheck, screenWidth, PostGetHeight);
    
    // [MainScroll setContentSize:CGSizeMake(320, PostView.frame.size.height)];
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = heightcheck + PostsView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}
-(void)initPeopleDataView{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PeopleHeight = 0;

    for (int i = 0; i < [Experts_Name_Array count]; i ++) {
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(25, PeopleHeight + 10, 60, 60);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=30;
        UserImage.layer.borderWidth=0;
        UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
       NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[Experts_ProfilePhoto_Array objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            UserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            UserImage.imageURL = url_NearbySmall;
        }
        [PeopleView addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(100, PeopleHeight + 10, 200, 60);
        ShowUserName.text = [Experts_Name_Array objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor blackColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PeopleView addSubview:ShowUserName];
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(100, PeopleHeight + 80, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [PeopleView addSubview:Line01];
        
        PeopleHeight += 80;
        
    }
    PeopleView.frame = CGRectMake(0, heightcheck, screenWidth, PeopleHeight);
    
    // [MainScroll setContentSize:CGSizeMake(320, PostView.frame.size.height)];
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = heightcheck + PeopleView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}


-(IBAction)AllExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[All_Experts_Username_Array objectAtIndex:getbuttonIDN]];
}
-(IBAction)ExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"ExpertsButton button %li",(long)getbuttonIDN);
    
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[Experts_Username_Array objectAtIndex:getbuttonIDN]];
}
-(IBAction)ExpertsButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"ExpertsButton2 button %li",(long)getbuttonIDN);
    
    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUsername:[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ProductButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)SortbyButton:(id)sender{
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:CustomLocalisedString(@"MostRecent", nil),CustomLocalisedString(@"Popular", nil),CustomLocalisedString(@"Distance", nil), nil];
//    [actionSheet showInView:self.view];
//    actionSheet.tag = 100;
    
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    [self presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Search"];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
      //  NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"MostRecent", nil)]) {
            StringSortby = @"1";
            NSLog(@"Most Recent");
            switch (CheckInt) {
                case 0:
                    break;
                case 1:
                    [self SendSearchKeywordData];
                    break;
                case 2:
                    [self SendCategoryData];
                    break;
                    
                default:
                    break;
            }
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Popular", nil)]) {
            StringSortby = @"2";
            NSLog(@"Popular");
            switch (CheckInt) {
                case 0:
                    break;
                case 1:
                    [self SendSearchKeywordData];
                    break;
                case 2:
                    [self SendCategoryData];
                    break;
                    
                default:
                    break;
            }
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Distance", nil)]) {
            StringSortby = @"3";
            NSLog(@"Distance");
            switch (CheckInt) {
                case 0:
                    break;
                case 1:
                    [self SendSearchKeywordData];
                    break;
                case 2:
                    [self SendCategoryData];
                    break;
                    
                default:
                    break;
            }
        }
        
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel", nil)]) {
            NSLog(@"Cancel Button");
        }
    }
    
}

//start scroll end reflash data
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == MainScroll) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            NSLog(@"we are at the end");
                if (CheckLoad == YES) {
                    
                }else{
                    CheckLoad = YES;
                    if (PostsView.hidden == YES) {
                        
                    }else{
                        if (CurrentPage == TotalPage) {
                            
                        }else{
                            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                            
                            [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 50)];
                            // MainScroll.frame = CGRectMake(0, heightcheck, screenWidth, MainScroll.frame.size.height + 20);
                            UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, MainScroll.contentSize.height + 20, 30, 30)];
                            [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                            [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                            [MainScroll addSubview:activityindicator1];
                            [activityindicator1 startAnimating];
                            [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 80)];
                            
                            if (CheckInt == 2) {
                                [self SendCategoryData];
                            }else{
                                [self SendSearchKeywordData];
                            }
                            
                        }
                    }
                    
                    
                }
            
        }
    }
    
}
@end

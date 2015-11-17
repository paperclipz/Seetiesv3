//
//  SearchDetailViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/3/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "AsyncImageView.h"
//#import "NewUserProfileV2ViewController.h"
#import "FeedV2DetailViewController.h"
#import "Filter2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "NSString+ChangeAsciiString.h"
#import "Filter2ViewController.h"
#import "AddCollectionDataViewController.h"
#import "CollectionViewController.h"
@interface SearchDetailViewController ()<CLLocationManagerDelegate>
{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *UserScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIImageView *BarImage;
    IBOutlet UITextField *SearchTextField;
    IBOutlet UITextField *SearchAddressField;
    NSString *GetKeywordText;
    NSString *GetLat;
    NSString *GetLong;
    NSString *GetCategoryText;
    NSString *GetLocationName;
    NSString *GetCurrentLat;
    NSString *GetCurrentLong;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetSearchKeyword;
    NSURLConnection *theConnection_GetSearchCategory;
    NSURLConnection *theConnection_GetExpertsSearch;
    NSURLConnection *theConnection_GetAllUserData;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_QuickCollect;
    NSURLConnection *theConnection_GetCollection;
    NSURLConnection *theConnection_FollowCollect;
    
    NSMutableArray *LPhotoArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *LocationArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    NSMutableArray *DistanceArray;
    NSMutableArray *SearchDisplayNameArray;
    NSMutableArray *TotalCommentArray;
    NSMutableArray *TotalLikeArray;
    NSMutableArray *SelfCheckLikeArray;
    NSMutableArray *UserInfo_FollowArray;
    NSMutableArray *UserInfo_IDArray;
    NSMutableArray *CollectArray;
    
    NSMutableArray *Experts_Username_Array;
    NSMutableArray *Experts_Name_Array;
    NSMutableArray *Experts_ProfilePhoto_Array;
    NSMutableArray *Experts_uid_Array;
    NSMutableArray *Experts_Followed_Array;
    
    NSMutableArray *Collection_arrID;
    NSMutableArray *Collection_arrTitle;
    NSMutableArray *Collection_arrTotalCount;
    NSMutableArray *Collection_arrImageData;
    NSMutableArray *Collection_arrFollowing;
    
    NSMutableArray *Collection_arrUsername;
    NSMutableArray *Collection_arrUserImage;
    NSMutableArray *Collection_arrUserID;
    
    NSInteger CheckInt;
    NSString *StringSortby;
    
    IBOutlet UITextField *SearchText;
    IBOutlet UIView *ShowNoDataView;
    
    IBOutlet UIView *ShowSearchUserView;
    
    IBOutlet UILabel *ShowNoText_1;
    IBOutlet UILabel *ShowNoText_2;
    
    IBOutlet UIButton *Background_Search;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    int CheckWhichOne;
    int heightcheck;
    
    IBOutlet UIButton *SortbyFullButton;
    
    UIView *PostsView;
    UIView *PeopleView;
    UIView *CollectionView;
    
    IBOutlet UIView *ShowSearchLocationView;
    IBOutlet UITableView *LocationTblView;
    
    NSMutableArray *SearchLocationNameArray;
    NSMutableArray *SearchPlaceIDArray;
    NSString *GetSearchPlaceID;
    
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GetSearchPlace;
    NSString *GetUserID;
    NSString *GetFollowString;
    
    NSString *GetPostsFollow;
    NSString *GetCollect;
    NSString *GetPostsUserID;
    
    NSInteger MainGetButtonIDN;
    NSInteger CheckFollowView;
    
    int SelfSearchCurrentLocation;
    NSInteger CheckUserInitView;
    NSInteger CheckPostsInitView;
    NSInteger CheckCollectionInitView;
    NSInteger SegmentedControlCheck;
    
    
    NSString *GetCollectionFollowing;
    NSString *GetCollectID;
    NSString *GetCollectUserID;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation SearchDetailViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 95);
    SearchTextField.frame = CGRectMake(50, 25, screenWidth - 50 - 39, 30);
    SearchAddressField.frame = CGRectMake(50, 58, screenWidth - 50 - 39, 30);
    SearchAddressField.layer.cornerRadius = 5;
    SearchTextField.layer.cornerRadius = 5;
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SortbyFullButton.frame = CGRectMake(screenWidth - 41 , 20, 41, 38);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    Background_Search.frame = CGRectMake(0, 64, screenWidth, 50);
    Background_Search.hidden = YES;
   
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    UserScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 149 , screenWidth, screenHeight - 149 - 50);
    ShowSearchUserView.frame = CGRectMake(0, 114, screenWidth, screenHeight - 114 - 50);
    UserScroll.frame = CGRectMake(0, 0 , ShowSearchUserView.frame.size.width, ShowSearchUserView.frame.size.height);
    StringSortby = @"3";
    CheckInt = 0;
    
    SearchTextField.delegate = self;
    SearchTextField.placeholder = LocalisedString(@"Search");
    SearchAddressField.delegate = self;
    SearchAddressField.placeholder = LocalisedString(@"Add a location?");
    
    ShowNoDataView.hidden = YES;
    ShowNoDataView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowNoText_1.frame = CGRectMake(15, 169, screenWidth - 30, 40);
    ShowNoText_2.frame = CGRectMake(15, 204, screenWidth - 30, 100);
    ShowNoText_1.text = CustomLocalisedString(@"NoResultFound", nil);
    ShowNoText_2.text = LocalisedString(@"Sorry, we couldn't figure out {!keyword}");
    
    ShowSearchUserView.hidden = YES;
    [self.view addSubview:ShowSearchUserView];
    
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    heightcheck = 0;
    SelfSearchCurrentLocation = 0;
    CheckUserInitView = 0;
    SegmentedControlCheck = 0;
    CheckPostsInitView = 0;
    CheckCollectionInitView = 0;
    

    
    SearchLocationNameArray = [[NSMutableArray alloc]init];
    SearchPlaceIDArray = [[NSMutableArray alloc]init];
    
    [SearchLocationNameArray addObject:CustomLocalisedString(@"Currentlocation",nil)];
    [SearchPlaceIDArray addObject:@"0"];
    
    [self InitView];
    
    [self SendSearchKeywordData];
    
    ShowSearchLocationView.frame = CGRectMake(0, 95, screenWidth, screenHeight - 95);
    ShowSearchLocationView.hidden = YES;
    [self.view addSubview:ShowSearchLocationView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Search Detail Page";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
       // [self SendSearchKeywordData];
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
        CheckUserInitView = 0;
        SelfSearchCurrentLocation = 0;
        
        [self SendSearchKeywordData];
    }
    
    SearchTextField.text = GetKeywordText;
    SearchAddressField.text = GetLocationName;
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
}
-(IBAction)BackButton:(id)sender{
  
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:NO completion:nil];

    }
   // [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetSearchKeyword:(NSString *)Keyword Getlat:(NSString *)lat GetLong:(NSString *)Long GetLocationName:(NSString *)LocationName GetCurrentLat:(NSString *)CurrentLat GetCurrentLong:(NSString *)CurrentLong{
    
    GetKeywordText = Keyword;
    GetLat = lat;
    GetLong = Long;
    GetLocationName = LocationName;
    GetCurrentLat = CurrentLat;
    GetCurrentLong = CurrentLong;
    [self SendSearchKeywordData];

    SearchTextField.text = GetKeywordText;
    SearchAddressField.text = GetLocationName;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//  //  NSLog(@"textFieldShouldBeginEditing");
//    NSLog(@"Textfield: %@",textField);
//
//    return YES;
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == SearchAddressField) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        NSLog(@"found");
        if ([newString length] >= 1) {
            NSLog(@"Check server");
            [self performSearch];
            //  [ShowActivity startAnimating];
            // [NSThread detachNewThreadSelector:@selector(SendMentionsToServer) toTarget:self withObject:nil];
        }else{
            
        }
    }else if(textField == SearchTextField){
//        SearchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        // [ShowSearchPPLText setText:newString];
//        if ([SearchString length] > 2) {
//            //start search
//            [self SearchTextInServer];
//        }
    }
    
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"The did begin edit method was called");
    if(textField == SearchTextField){
        NSLog(@"SearchTextField begin");
        MainScroll.hidden = NO;
        ShowSearchLocationView.hidden = YES;
    }
    if (textField == SearchAddressField) {
        NSLog(@"SearchAddressField begin");
        MainScroll.hidden = YES;
        ShowSearchLocationView.hidden = NO;
        [LocationTblView reloadData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchTextField resignFirstResponder];
    [SearchAddressField resignFirstResponder];
    MainScroll.hidden = NO;
    ShowSearchLocationView.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    
    [textField resignFirstResponder];
    if (textField == SearchTextField) {
        if ([SearchTextField.text length] == 0) {
            GetKeywordText = @"";
        }else{
            GetKeywordText = SearchTextField.text;
            if (SegmentedControlCheck == 0) {
                CheckLoad = NO;
                TotalPage = 1;
                CurrentPage = 0;
                CheckFirstTimeLoad = 0;
                DataCount = 0;
                DataTotal = 0;
                CheckUserInitView = 0;
                [self SendSearchKeywordData];
            }else if(SegmentedControlCheck == 2){
                [self GetCollectionData];
            }else{
               // CheckUserInitView = 0;
                for (UIView *subview in PostsView.subviews) {
                    [subview removeFromSuperview];
                }
                CheckLoad = NO;
                TotalPage = 1;
                CurrentPage = 0;
                CheckFirstTimeLoad = 0;
                DataCount = 0;
                DataTotal = 0;
                CheckPostsInitView = 0;
                [self GetAllUserData];
            }
        
            

        }
    }else if(textField == SearchAddressField){
        if (SegmentedControlCheck == 0) {
            CheckLoad = NO;
            TotalPage = 1;
            CurrentPage = 0;
            CheckFirstTimeLoad = 0;
            DataCount = 0;
            DataTotal = 0;
            [self SendSearchKeywordData];
        }else if(SegmentedControlCheck == 2){
            [self GetCollectionData];
        }else{
            [self GetAllUserData];
        }
    }
    ShowSearchLocationView.hidden = YES;
    
//    if ([SearchText.text length] == 0) {
//       [textField resignFirstResponder];
//        MainScroll.hidden = NO;
//        ShowSearchUserView.hidden = YES;
//    }else{
//        [textField resignFirstResponder];
//        if (CheckInt == 1) {
//            //keyword
//            GetKeywordText = SearchText.text;
//            [self SendSearchKeywordData];
//        }else if (CheckInt == 3){
//            GetExpertsKeyword = SearchText.text;
//            [self SendSearchExpertsData];
//        }else{
//        
//        }
//    }
    
    
    
    return YES;
}
-(void)performSearch{
    
    NSString *originalString = SearchAddressField.text;
    NSString *replaced = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"replaced is %@",replaced);
    // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&radius=500&sensor=false&types=geocode&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",replaced];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_SearchLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_SearchLocation start];
    
    
    if( theConnection_SearchLocation ){
        webData = [NSMutableData data];
    }
}
-(void)GetCollectionData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@search/collections?token=%@&keyword=%@&offset=1&limit=30",DataUrl.UserWallpaper_Url,GetExpertToken,GetKeywordText];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetAllUserData check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetCollection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetCollection start];
    
    
    if( theConnection_GetCollection ){
        webData = [NSMutableData data];
    }
}
-(void)GetAllUserData{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@search/user?token=%@&keyword=%@",DataUrl.UserWallpaper_Url,GetExpertToken,GetKeywordText];
    
    
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
    NSLog(@"SendSearchKeywordData");
    CheckWhichOne = 1;
    if (CheckFirstTimeLoad == 0) {
           [ShowActivity startAnimating];
    }

    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetSortByString = [defaults objectForKey:@"Filter_Search_SortBy"];
        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
        
        
        if ([GetCurrentLat length] == 0 || [GetCurrentLat isEqualToString:@"(null)"]) {
            GetCurrentLat = @"";
        }
        if ([GetCurrentLong length] == 0 || [GetCurrentLong isEqualToString:@"(null)"]) {
            GetCurrentLong = @"";
        }
        
        
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@search?token=%@&keyword=%@&sort=%@&lat=%@&lng=%@&current_lat=%@&current_lng=%@&page=%li",DataUrl.UserWallpaper_Url,GetExpertToken,GetKeywordText,StringSortby,GetLat,GetLong,GetCurrentLat,GetCurrentLong,(long)CurrentPage];
        
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
            UserInfo_FollowArray = [[NSMutableArray alloc]init];
            CollectArray = [[NSMutableArray alloc]init];
            UserInfo_IDArray = [[NSMutableArray alloc]init];
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
            NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
            [UserInfo_UrlArray addObject:url];
            NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
            [UserInfo_FollowArray addObject:following];
            NSString *ID_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
            [UserInfo_IDArray addObject:ID_];
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
            NSString *collect =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"collect"]];
            [CollectArray addObject:collect];
            
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
        
        if (CheckPostsInitView == 0) {
           // [self InitView];
            [self InitPostsDataView];
            CheckPostsInitView = 1;
        }else{
            for (UIView *subview in PostsView.subviews) {
                [subview removeFromSuperview];
            }
            [self InitPostsDataView];
        }
        
    }else if(connection == theConnection_GetAllUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Search User return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSDictionary *ResData = [res valueForKey:@"data"];
        
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
            NSString *followed =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"following"]];
            [Experts_Followed_Array addObject:followed];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
            [Experts_Username_Array addObject:username];
            NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
            [Experts_Name_Array addObject:name];
        }

    
        [self initPeopleDataView];
    }else if(connection == theConnection_GetCollection){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"theConnection_GetSuggestedCollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        // NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *AllData = [res valueForKey:@"data"];
            
//            NSDictionary *GetPaging = [AllData valueForKey:@"paging"];
//            GetNextPaging = [[NSString alloc]initWithFormat:@"%@",[GetPaging objectForKey:@"next"]];
//            NSLog(@"GetNextPaging is %@",GetNextPaging);

            Collection_arrID = [[NSMutableArray alloc]init];
            Collection_arrTitle = [[NSMutableArray alloc]init];
            Collection_arrTotalCount = [[NSMutableArray alloc]init];
            Collection_arrImageData = [[NSMutableArray alloc]init];
            Collection_arrUsername = [[NSMutableArray alloc]init];
            Collection_arrUserImage = [[NSMutableArray alloc]init];
            Collection_arrUserID = [[NSMutableArray alloc]init];
            Collection_arrFollowing = [[NSMutableArray alloc]init];
            
            NSDictionary *GetResultData = [AllData valueForKey:@"collections"];
            
            for (NSDictionary * dict in GetResultData) {
                NSString *collectionid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_id"]];
                [Collection_arrID addObject:collectionid];
                NSString *getname = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [Collection_arrTitle addObject:getname];
                NSString *collectioncount = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_posts_count"]];
                [Collection_arrTotalCount addObject:collectioncount];
                NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                [Collection_arrFollowing addObject:following];
            }
            
            NSLog(@"Collection_arrTitle is %@",Collection_arrTitle);
            
            NSDictionary *GetUserData = [GetResultData valueForKey:@"user_info"];
            for (NSDictionary * dict in GetUserData) {
                NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [Collection_arrUsername addObject:Getusername];
                NSString *getUserImage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [Collection_arrUserImage addObject:getUserImage];
                NSString *getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [Collection_arrUserID addObject:getid];
            }
            
            NSLog(@"Collection_arrUsername is %@",Collection_arrUsername);
            
            
            NSDictionary *CollectionPhotoData = [GetResultData valueForKey:@"collection_posts"];
            
            NSDictionary *PhotoData = [CollectionPhotoData valueForKey:@"posts"];
            // NSMutableArray *FullUrlArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSArray *TempPhotoData = [dict_ valueForKey:@"photos"];
                    for (NSDictionary * dict_ in TempPhotoData) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                        
                        [UrlArray addObject:url];
                    }
                }
                NSString *resultImageUrl = [UrlArray componentsJoinedByString:@"^^^"];
                [Collection_arrImageData addObject:resultImageUrl];
            }
            
            NSLog(@"Collection_arrImageData is %@",Collection_arrImageData);
            
            [self InitCollectionDataView];
        }
        
        
    }else if(connection == theConnection_SearchLocation){
        [SearchLocationNameArray removeAllObjects];
        [SearchPlaceIDArray removeAllObjects];
        
        [SearchLocationNameArray addObject:CustomLocalisedString(@"Currentlocation",nil)];
        [SearchPlaceIDArray addObject:@"0"];
        
        
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        // NSLog(@"%@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Json Error." message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetpredictionsData = (NSArray *)[res valueForKey:@"predictions"];
                
                // ReferenceArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in GetpredictionsData){
                    NSString * formattedaddressData = [dict valueForKey:@"description"];
                    NSLog(@"formattedaddressData ===== %@",formattedaddressData);
                    [SearchLocationNameArray addObject:formattedaddressData];
                    NSString * place_id = [dict valueForKey:@"place_id"];
                    [SearchPlaceIDArray addObject:place_id];
                    //            NSString * reference = [dict valueForKey:@"reference"];
                    //            [ReferenceArray addObject:reference];
                }
                NSLog(@"SearchLocationNameArray is %@",SearchLocationNameArray);
                NSLog(@"SearchPlaceIDArray is %@",SearchPlaceIDArray);
                [LocationTblView reloadData];
            }
        }
        
        
    }else if(connection == theConnection_GetSearchPlace){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //  NSLog(@"%@",res);
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Json Error." message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetresultsData = (NSArray *)[res valueForKey:@"result"];
                NSLog(@"GetresultsData ===== %@",GetresultsData);
                NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
                NSLog(@"geometryData ===== %@",geometryData);
                NSDictionary *locationData = [geometryData valueForKey:@"location"];
                
                NSString *formattedaddressData = [GetresultsData valueForKey:@"formatted_address"];
                NSLog(@"formattedaddressData ===== %@",formattedaddressData);
                
                NSString *Getlat_;
                NSString *Getlng_;
                
                Getlat_ = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
                Getlng_ = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
                
                NSLog(@"formattedaddressData is %@",formattedaddressData);
                NSLog(@"Getlat is %@",Getlat_);
                NSLog(@"Getlng is %@",Getlng_);
                
                GetLocationName = formattedaddressData;
                SearchAddressField.text = formattedaddressData;
                GetLat = Getlat_;
                GetLong = Getlng_;
                
                [SearchAddressField resignFirstResponder];
                [SearchTextField resignFirstResponder];
                MainScroll.hidden = NO;
                ShowSearchLocationView.hidden = YES;
                CheckLoad = NO;
                TotalPage = 1;
                CurrentPage = 0;
                GetHeight = 0;
                CheckFirstTimeLoad = 0;
                DataCount = 0;
                DataTotal = 0;
                heightcheck = 0;
                [self SendSearchKeywordData];
                // [MainSearchButton setTitle:CustomLocalisedString(@"Search", nil) forState:UIControlStateNormal];
            }
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
    }else if(connection == theConnection_FollowCollect){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Follow Collection return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            if ([GetCollectionFollowing isEqualToString:@"0"]) {
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success follow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"1";
            }else{
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success unfollow this collection" type:TSMessageNotificationTypeSuccess];
                GetCollectionFollowing = @"0";
            }
            
            
        }
    }else{
            //follow data
            NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
            //     NSLog(@"Get Following return get data to server ===== %@",GetData);
            
            NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
            //    NSLog(@"Expert Json = %@",res);
            
            NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            //    NSLog(@"ResultString is %@",ResultString);
            
            if ([ResultString isEqualToString:@"ok"]) {
                
                //   [self InitView];
                if (CheckFollowView == 0) {
                    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[UserInfo_FollowArray objectAtIndex:MainGetButtonIDN]];
                    if ([GetFollowData isEqualToString:@"1"]) {
                        [UserInfo_FollowArray replaceObjectAtIndex:MainGetButtonIDN withObject:@"0"];
                        
                    }else{
                        [UserInfo_FollowArray replaceObjectAtIndex:MainGetButtonIDN withObject:@"1"];
                    }
                    [self InitPostsDataView];
                }else{
                    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[Experts_Followed_Array objectAtIndex:MainGetButtonIDN]];
                    if ([GetFollowData isEqualToString:@"1"]) {
                        [Experts_Followed_Array replaceObjectAtIndex:MainGetButtonIDN withObject:@"0"];
                        
                    }else{
                        [Experts_Followed_Array replaceObjectAtIndex:MainGetButtonIDN withObject:@"1"];
                    }
                    
                    [self initPeopleDataView];
                }
                
            }
        }
    
    [ShowActivity stopAnimating];

}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *TempStringCollection = [[NSString alloc]initWithFormat:@"%@",LocalisedString(@"Collection")];
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"%@",LocalisedString(@"Posts")];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"%@",LocalisedString(@"Seetizens")];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringPeople, nil];
   // NSArray *itemArray = [NSArray arrayWithObjects:TempStringCollection,TempStringPosts, TempStringPeople, nil];
    UISegmentedControl *ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, 105, screenWidth - 30, 33);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:12];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [ProfileControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:41.0f/255.0f green:182.0f/255.0f blue:246.0f/255.0f alpha:1.0]];
    [self.view addSubview:ProfileControl];
    
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, 105 + 43, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];//238
    [Line01 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
    [self.view addSubview:Line01];
    
    MainScroll.backgroundColor = [UIColor whiteColor];
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }

    heightcheck += 0;
    
    PostsView = [[UIView alloc]init];
    PostsView.frame = CGRectMake(0, heightcheck, screenWidth, 600);
    PostsView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:PostsView];
    
    PeopleView = [[UIView alloc]init];
    PeopleView.frame = CGRectMake(0, heightcheck, screenWidth, 600);
    PeopleView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:PeopleView];
    
    CollectionView = [[UIView alloc]init];
    CollectionView.frame = CGRectMake(0, heightcheck, screenWidth, 600);
    CollectionView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:CollectionView];
    
    PeopleView.hidden = YES;
    PostsView.hidden = NO;
    CollectionView.hidden = YES;

    CheckLoad = 1;

}
- (void)segmentAction:(UISegmentedControl *)segment
{
    
    switch (segment.selectedSegmentIndex) {
//        case 0:
//            SegmentedControlCheck = 2;
//            NSLog(@"CollectionView Click");
//            PostsView.hidden = YES;
//            PeopleView.hidden = YES;
//            CollectionView.hidden = NO;
//            if (CheckCollectionInitView == 0) {
//                CheckCollectionInitView = 1;
//                [self GetCollectionData];
//            }else{
//                CGSize contentSize = MainScroll.frame.size;
//                contentSize.height = heightcheck + CollectionView.frame.size.height;
//                MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//                MainScroll.contentSize = contentSize;
//            }
//            break;
        case 0:
            SegmentedControlCheck = 0;
            NSLog(@"PostView click");
            PostsView.hidden = NO;
            PeopleView.hidden = YES;
            CollectionView.hidden = YES;
           // [self InitPostsDataView];
            
            if (CheckPostsInitView == 0) {
                [self SendSearchKeywordData];
            }else{
                CGSize contentSize = MainScroll.frame.size;
                contentSize.height = heightcheck + PostsView.frame.size.height;
                MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                MainScroll.contentSize = contentSize;
            }
            

            
            break;
        case 1:
            SegmentedControlCheck = 1;
            NSLog(@"PeopleView click");
            PostsView.hidden = YES;
            PeopleView.hidden = NO;
            CollectionView.hidden = YES;
            if (CheckUserInitView == 0) {
                CheckUserInitView = 1;
                //[self initPeopleDataView];
                [self GetAllUserData];
            }else{
                CGSize contentSize = MainScroll.frame.size;
                contentSize.height = heightcheck + PeopleView.frame.size.height;
                MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                MainScroll.contentSize = contentSize;
            }
            
            
            
            
            
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitPostsDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PostGetHeight = 0;
    
    UILabel *ShowResults = [[UILabel alloc]init];
    ShowResults.frame = CGRectMake(0, PostGetHeight, screenWidth, 40);
    ShowResults.text = [NSString stringWithFormat:@"about %ld results",(long)DataTotal];
    ShowResults.backgroundColor = [UIColor clearColor];
    ShowResults.textAlignment = NSTextAlignmentCenter;
    ShowResults.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    ShowResults.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [PostsView addSubview:ShowResults];
    
    PostGetHeight += 40;
    
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10, PostGetHeight, screenWidth - 20, 150);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [PostsView addSubview: TempButton];
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(20, PostGetHeight + 10, 30, 30);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=15;
        UserImage.layer.borderWidth=0;
         UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            UserImage.imageURL = url_NearbySmall;
        }
        [PostsView addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(65, PostGetHeight + 10, 200, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostsView addSubview:ShowUserName];
        
        
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(20, PostGetHeight + 10, 250, 30)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        [ButtonClick addTarget:self action:@selector(ExpertsButton2:) forControlEvents:UIControlEventTouchUpInside];
        [PostsView addSubview:ButtonClick];
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(10, PostGetHeight + 50, screenWidth - 20, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [PostsView addSubview:Line01];
        
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(20, PostGetHeight + 60, 80, 80);
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
        TempShowTitle.frame = CGRectMake(115, PostGetHeight + 60, screenWidth - 200, 20);
        TempShowTitle.text = [TitleArray objectAtIndex:i];
        TempShowTitle.backgroundColor = [UIColor clearColor];
        TempShowTitle.textAlignment = NSTextAlignmentLeft;
        TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        TempShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostsView addSubview:TempShowTitle];

        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"LocationpinIcon"];
        ShowPin.frame = CGRectMake(110, PostGetHeight + 80, 18, 18);
        [PostsView addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(130, PostGetHeight + 80, screenWidth - 200, 20);
        ShowPlaceName.text = [place_nameArray objectAtIndex:i];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [PostsView addSubview:ShowPlaceName];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(115, PostGetHeight + 100, screenWidth - 200, 20);
        ShowLocation.text = [LocationArray objectAtIndex:i];
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLocation.textColor = [UIColor grayColor];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [PostsView addSubview:ShowLocation];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(10, PostGetHeight + 60, screenWidth - 20, 90);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(ProductButton:) forControlEvents:UIControlEventTouchUpInside];
        [PostsView addSubview:SelectButton];
        
        
        GetPostsFollow = [[NSString alloc]initWithFormat:@"%@",[UserInfo_FollowArray objectAtIndex:i]];
        UIButton *UserFollowButton = [[UIButton alloc]init];
        if ([GetPostsFollow isEqualToString:@"0"]) {
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
          //  [UserFollowButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
        }else{
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
          //  [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
        }
        [UserFollowButton setBackgroundColor:[UIColor clearColor]];
        // [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
        UserFollowButton.frame = CGRectMake(screenWidth - 10 - 47, PostGetHeight - 1, 47, 47);
        UserFollowButton.tag = i;
        [UserFollowButton addTarget:self action:@selector(PostsUserOnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [PostsView addSubview:UserFollowButton];
        
        

        
        GetCollect = [[NSString alloc]initWithFormat:@"%@",[CollectArray objectAtIndex:i]];

        UIButton *CollectButton = [[UIButton alloc]init];
        [CollectButton setBackgroundColor:[UIColor clearColor]];
        if ([GetCollect isEqualToString:@"0"]) {
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollect.png"] forState:UIControlStateNormal];
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateSelected];
        }else{
            [CollectButton setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateNormal];
        }
        [CollectButton setBackgroundColor:[UIColor clearColor]];
        // [CollectButton setImage:[UIImage imageNamed:@"collected_icon.png"] forState:UIControlStateNormal];
        CollectButton.frame = CGRectMake(screenWidth - 10 - 57, PostGetHeight + 67, 57, 57);
        CollectButton.tag = i;
        [CollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [PostsView addSubview:CollectButton];
        
        
        
        
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
    
    for (UIView *subview in PeopleView.subviews) {
        // if ([subview isKindOfClass:[UIButton class]])
        [subview removeFromSuperview];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PeopleHeight = 0;
    
    UILabel *ShowResults = [[UILabel alloc]init];
    ShowResults.frame = CGRectMake(0, PeopleHeight, screenWidth, 40);
    ShowResults.text = [NSString stringWithFormat:@"about %ld results",[Experts_Name_Array count]];
    ShowResults.backgroundColor = [UIColor clearColor];
    ShowResults.textAlignment = NSTextAlignmentCenter;
    ShowResults.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    ShowResults.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [PeopleView addSubview:ShowResults];
    
    PeopleHeight += 40;

    for (int i = 0; i < [Experts_Name_Array count]; i ++) {
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(25, PeopleHeight + 15, 50, 50);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=25;
        UserImage.layer.borderWidth=0;
        UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
       NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[Experts_ProfilePhoto_Array objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            UserImage.imageURL = url_NearbySmall;
        }
        [PeopleView addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(100, PeopleHeight + 10, 200, 60);
        ShowUserName.text = [Experts_Name_Array objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PeopleView addSubview:ShowUserName];
        
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(25, PeopleHeight + 10, 60, 60)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        [ButtonClick addTarget:self action:@selector(ExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        [PeopleView addSubview:ButtonClick];
        
        NSString *CheckFollow = [[NSString alloc]initWithFormat:@"%@",[Experts_Followed_Array objectAtIndex:i]];

        UIButton *FollowButton = [[UIButton alloc]init];
        FollowButton.frame = CGRectMake(screenWidth - 10 - 70, PeopleHeight + 12, 70, 48);
        if ([CheckFollow isEqualToString:@"0"]) {
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateNormal];
         //   [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateSelected];
        }else{
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateNormal];
         //   [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateSelected];
        }
        //[FollowButton setImage:[UIImage imageNamed:@"follow_icon.png"] forState:UIControlStateNormal];
        FollowButton.backgroundColor = [UIColor clearColor];
        FollowButton.tag = i;
        [FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [PeopleView addSubview: FollowButton];
        
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
-(void)InitCollectionDataView{

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *ShowResults = [[UILabel alloc]init];
    ShowResults.frame = CGRectMake(0, 0, screenWidth, 40);
    ShowResults.text = [NSString stringWithFormat:@"about %ld results",[Collection_arrTotalCount count]];
    ShowResults.backgroundColor = [UIColor clearColor];
    ShowResults.textAlignment = NSTextAlignmentCenter;
    ShowResults.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    ShowResults.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [CollectionView addSubview:ShowResults];
    
    
    for (int i = 0; i < [Collection_arrTotalCount count]; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10 , 40 + i * 200, screenWidth - 20 ,190);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 10;
        TempButton.layer.borderWidth=1;
        TempButton.layer.masksToBounds = YES;
        TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
        [CollectionView addSubview: TempButton];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[Collection_arrImageData objectAtIndex:i]];
        NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
        
        NSLog(@"TempImage is %@",TempImage);
        NSLog(@"SplitArray_TempImage is %@",SplitArray_TempImage);
        
        if ([SplitArray_TempImage count] == 1) {
            AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
            ShowImage1.frame = CGRectMake(10 , 40 + i * 200 , screenWidth - 20 ,120);
            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
            ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowImage1.layer.cornerRadius= 10;
            ShowImage1.layer.masksToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
            if ([ImageData length] == 0) {
                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                ShowImage1.imageURL = url_NearbySmall;
            }
            [CollectionView addSubview:ShowImage1];
        }else{
            AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
            ShowImage1.frame = CGRectMake(10 , 40 + i * 200 , ((screenWidth - 30) / 2) ,120);
            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
            ShowImage1.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage1.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowImage1.layer.cornerRadius= 10;
            ShowImage1.layer.masksToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage1];
            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:0]];
            if ([ImageData length] == 0) {
                ShowImage1.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData];
                ShowImage1.imageURL = url_NearbySmall;
            }
            [CollectionView addSubview:ShowImage1];
            
            AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
            ShowImage2.frame = CGRectMake(14 + ((screenWidth - 20) / 2), 40 + i * 200 , ((screenWidth - 30) / 2) ,120);
            //ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
            ShowImage2.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage2.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowImage2.layer.cornerRadius=10;
            ShowImage2.layer.masksToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage2];
            NSString *ImageData100 = [[NSString alloc]initWithFormat:@"%@",[SplitArray_TempImage objectAtIndex:1]];
            if ([ImageData100 length] == 0) {
                ShowImage2.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData100];
                ShowImage2.imageURL = url_NearbySmall;
            }
            [CollectionView addSubview:ShowImage2];
        }
        

        
        
        UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
        ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
        ShowOverlayImg.frame = CGRectMake(10 , 40 + i * 200, screenWidth - 20 ,120);
        ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
        ShowOverlayImg.layer.masksToBounds = YES;
        ShowOverlayImg.layer.cornerRadius = 10;
        [CollectionView addSubview:ShowOverlayImg];
        
        UIButton *OpenCollectionButton = [[UIButton alloc]init];
        OpenCollectionButton.frame = CGRectMake(11 , 40 + i * 200 , screenWidth - 22 ,120);
        [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
        OpenCollectionButton.backgroundColor = [UIColor clearColor];
        OpenCollectionButton.layer.cornerRadius = 10;
        OpenCollectionButton.layer.borderWidth=1;
        OpenCollectionButton.layer.masksToBounds = YES;
        OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
        [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        OpenCollectionButton.tag = i;
        [CollectionView addSubview: OpenCollectionButton];
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25 , 50 + i * 200, 40, 40);
        // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=20;
        ShowUserProfileImage.layer.borderWidth=1;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[Collection_arrUserImage objectAtIndex:i]];
        if ([ImageData1 length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        [CollectionView addSubview:ShowUserProfileImage];
        
        UIButton *OpenUserProfileButton = [[UIButton alloc]init];
        [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
        OpenUserProfileButton.backgroundColor = [UIColor clearColor];
        OpenUserProfileButton.frame = CGRectMake(25 , 50 + i * 200, screenWidth - 75 - 100, 40);
        [OpenUserProfileButton addTarget:self action:@selector(CollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
        OpenUserProfileButton.tag = i;
        [CollectionView addSubview:OpenUserProfileButton];
        
        NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[Collection_arrUsername objectAtIndex:i]];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(75 , 50 + i * 200, screenWidth - 75 - 100, 40);
        ShowUserName.text = usernameTemp;
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [CollectionView addSubview:ShowUserName];
        
        UILabel *ShowCollectionTitle = [[UILabel alloc]init];
        ShowCollectionTitle.frame = CGRectMake(25, 170 + i * 200, screenWidth - 190 , 25);
        ShowCollectionTitle.text = [Collection_arrTitle objectAtIndex:i];
        ShowCollectionTitle.backgroundColor = [UIColor clearColor];
        ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
        ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
        [CollectionView addSubview:ShowCollectionTitle];
        
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ recommendations",[Collection_arrTotalCount objectAtIndex:i]];
        
        UILabel *ShowCollectionCount = [[UILabel alloc]init];
        ShowCollectionCount.frame = CGRectMake(25 , 195 + i * 200, screenWidth - 190, 25);
        ShowCollectionCount.text = TempCount;
        ShowCollectionCount.backgroundColor = [UIColor clearColor];
        ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
        ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        [CollectionView addSubview:ShowCollectionCount];
        
        NSString *CheckCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[Collection_arrFollowing objectAtIndex:i]];
        NSLog(@"CheckCollectionFollowing is %@",CheckCollectionFollowing);
        UIButton *CollectionFollowButton = [[UIButton alloc]init];
        if ([CheckCollectionFollowing isEqualToString:@"0"]) {
            [CollectionFollowButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
            [CollectionFollowButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
        }else{
            [CollectionFollowButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
            [CollectionFollowButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateSelected];
        }
       // [CollectionFollowButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
        [CollectionFollowButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [CollectionFollowButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        CollectionFollowButton.backgroundColor = [UIColor clearColor];
        CollectionFollowButton.frame = CGRectMake((screenWidth - 20 - 140), 170 + i * 200, 140, 50);
        [CollectionFollowButton addTarget:self action:@selector(CollectionFollowingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        CollectionFollowButton.tag = i;
        [CollectionView addSubview:CollectionFollowButton];
        
        
        
        
        CollectionView.frame = CGRectMake(0, heightcheck, screenWidth, 230 + i * 200);
        
       // MainScroll.contentSize = CGSizeMake(screenWidth, 200 + i * 200);
    }
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = heightcheck + CollectionView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}

//-(IBAction)AllExpertsButton:(id)sender{
//    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
//    NSLog(@"button %li",(long)getbuttonIDN);
//    
//    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
////    CATransition *transition = [CATransition animation];
////    transition.duration = 0.2;
////    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////    transition.type = kCATransitionPush;
////    transition.subtype = kCATransitionFromRight;
////    [self.view.window.layer addAnimation:transition forKey:nil];
////    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [self.navigationController pushViewController:ExpertsUserProfileView animated:YES];
//    [ExpertsUserProfileView GetUserName:[All_Experts_Username_Array objectAtIndex:getbuttonIDN]];
//}
-(IBAction)ExpertsButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"ExpertsButton button %li",(long)getbuttonIDN);
    
//    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
////    CATransition *transition = [CATransition animation];
////    transition.duration = 0.2;
////    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////    transition.type = kCATransitionPush;
////    transition.subtype = kCATransitionFromRight;
////    [self.view.window.layer addAnimation:transition forKey:nil];
////    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [self.navigationController pushViewController:ExpertsUserProfileView animated:YES];
//    [ExpertsUserProfileView GetUserName:[Experts_Username_Array objectAtIndex:getbuttonIDN]];
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[Experts_uid_Array objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
-(IBAction)ExpertsButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"ExpertsButton2 button %li",(long)getbuttonIDN);
    
//    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
////    CATransition *transition = [CATransition animation];
////    transition.duration = 0.2;
////    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////    transition.type = kCATransitionPush;
////    transition.subtype = kCATransitionFromRight;
////    [self.view.window.layer addAnimation:transition forKey:nil];
////    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [self.navigationController pushViewController:ExpertsUserProfileView animated:YES];
//    [ExpertsUserProfileView GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[UserInfo_IDArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
-(IBAction)ProductButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:FeedDetailView animated:NO completion:nil];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)SortbyButton:(id)sender{
    
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    [self presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Search"];
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

                            [self SendSearchKeywordData];
                            
                        }
                    }
                    
                    
                }
            
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
      return [SearchLocationNameArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(15, 0, 290, 50);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        ShowName.numberOfLines = 5;
        
        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];

    UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
    ShowName.text = [SearchLocationNameArray objectAtIndex:indexPath.row];

     // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == LocationTblView) {
        if (indexPath.row == 0) {
            SelfSearchCurrentLocation = 1;
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = 10;
            if(IS_OS_8_OR_LATER){
                NSUInteger code = [CLLocationManager authorizationStatus];
                if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                    // choose one request according to your business.
                    if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                        [self.locationManager requestAlwaysAuthorization];
                        [self.locationManager startUpdatingLocation];
                    } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                        [self.locationManager  requestWhenInUseAuthorization];
                        [self.locationManager startUpdatingLocation];
                    } else {
                        NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                    }
                }
            }
            [self.locationManager startUpdatingLocation];
            
            MainScroll.hidden = NO;
            ShowSearchLocationView.hidden = YES;
            [SearchAddressField resignFirstResponder];
        }else{
            GetSearchPlaceID = [SearchPlaceIDArray objectAtIndex:indexPath.row];
            NSLog(@"GetSearchPlaceID is %@",GetSearchPlaceID);
            [self GetPlaceDetail];
        }
    }    NSLog(@"Click...");
    
    
    
}
-(void)GetPlaceDetail{
    //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ3WWMjifu0TERagGedoFyKgM&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",GetSearchPlaceID];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetSearchPlace = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetSearchPlace start];
    
    
    if( theConnection_GetSearchPlace ){
        webData = [NSMutableData data];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"didFailWithError: %@", error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        GetCurrentLat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        GetCurrentLong = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSLog(@"Location Get lat is %@ : lon is %@",GetCurrentLat, GetCurrentLong);
        if ([GetCurrentLat length] == 0 || [GetCurrentLong isEqualToString:@"(null)"]) {

        }else{
            if (SelfSearchCurrentLocation == 1) {
                
                GetLat = GetCurrentLat;
                GetLong = GetCurrentLong;
                
                SearchAddressField.text = @"Current Location";
                CheckLoad = NO;
                TotalPage = 1;
                CurrentPage = 0;
                GetHeight = 0;
                CheckFirstTimeLoad = 0;
                DataCount = 0;
                DataTotal = 0;
                heightcheck = 0;
                [self SendSearchKeywordData];
            }

        }
        
       // [self performSearchLatnLong];
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
    }else{
    }
}
-(IBAction)FollowButton:(id)sender{
    CheckFollowView = 1;
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    MainGetButtonIDN = getbuttonIDN;
    
    GetUserID = [Experts_uid_Array objectAtIndex:getbuttonIDN];
    GetFollowString = [Experts_Followed_Array objectAtIndex:getbuttonIDN];
    
    if ([GetFollowString isEqualToString:@"0"]) {
        [self SendFollowingData];
    }else{
        
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"),[Experts_Username_Array objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Unfollow user") message:tempStirng delegate:self cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:LocalisedString(@"Yeah!"), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }
}
-(IBAction)PostsUserOnCLick:(id)sender{
    CheckFollowView = 0;
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    MainGetButtonIDN = getbuttonIDN;
    
    GetUserID = [UserInfo_IDArray objectAtIndex:getbuttonIDN];
    GetFollowString = [UserInfo_FollowArray objectAtIndex:getbuttonIDN];
    
    if ([GetFollowString isEqualToString:@"0"]) {
        [self SendFollowingData];
    }else{
        
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"),[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Unfollow user") message:tempStirng delegate:self cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:LocalisedString(@"Yeah!"), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1200){
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self SendFollowingData];
        }
    }
    
}
-(void)SendFollowingData{
    
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetUserID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSLog(@"GetFollowString is %@",GetFollowString);
    if ([GetFollowString isEqualToString:@"1"]) {
        [request setHTTPMethod:@"DELETE"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    NSLog(@"request is %@",request);
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Following = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Following) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)FilterButtonOnClick:(id)sender{
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    [self presentViewController:FilterView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Search"];
}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    // NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Quick CollectButtonOnClick");
    GetPostsUserID = [[NSString alloc]initWithFormat:@"%@",[PostIDArray objectAtIndex:getbuttonIDN]];
    GetCollect = [[NSString alloc]initWithFormat:@"%@",[CollectArray objectAtIndex:getbuttonIDN]];
    
    if ([GetCollect isEqualToString:@"0"]) {
        [CollectArray replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
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
    
    
    
    NSString *dataString = [[NSString alloc]initWithFormat:@"token=%@&posts[0][id]=%@",GetExpertToken,GetPostsUserID];
    
    NSData *postBodyData = [NSData dataWithBytes: [dataString UTF8String] length:[dataString length]];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)OpenCollectionButtonOnClick:(id)sender{
    
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    CollectionViewController *OpenCollectionView = [[CollectionViewController alloc]init];
    [self.navigationController pushViewController:OpenCollectionView animated:YES];
    [OpenCollectionView GetCollectionID:[Collection_arrID objectAtIndex:getbuttonIDN] GetPermision:@"User"];
}
-(IBAction)CollectionUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
//    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[Collection_arrUsername objectAtIndex:getbuttonIDN]];
//    NSLog(@"CollectionUserProfileOnClick Getname is %@",Getname);
//    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:Getname];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[Collection_arrUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
    }];
}
-(IBAction)CollectionFollowingButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    NSLog(@"Get Collection User ID == %@",[Collection_arrUserID objectAtIndex:getbuttonIDN]);
    NSLog(@"Get Collection Following == %@",[Collection_arrFollowing objectAtIndex:getbuttonIDN]);
    GetCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[Collection_arrFollowing objectAtIndex:getbuttonIDN]];
    GetCollectUserID = [[NSString alloc]initWithFormat:@"%@",[Collection_arrUserID objectAtIndex:getbuttonIDN]];
    GetCollectID = [[NSString alloc]initWithFormat:@"%@",[Collection_arrID objectAtIndex:getbuttonIDN]];
    
    if ([GetCollectionFollowing isEqualToString:@"0"]) {
        [self FollowCollection];
        [Collection_arrFollowing replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
    }else{
        [self DeleteFollowCollection];
        [Collection_arrFollowing replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
    }
}
-(void)FollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID];
    NSLog(@"Send Follow Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)DeleteFollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetCollectUserID,GetCollectID,GetExpertToken];
    NSLog(@"Send Delete Collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_FollowCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_FollowCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
@end

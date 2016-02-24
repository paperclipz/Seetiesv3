//
//  CollectionViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionViewController.h"
#import "FeedV2DetailViewController.h"
#import "ShareViewController.h"
#import "SearchDetailViewController.h"
#import "AddCollectionDataViewController.h"
@interface CollectionViewController (){

    int CheckButtonOnClick;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIButton *MapButton;
    IBOutlet UIButton *MoreButton;
    IBOutlet UIView *DownBarView;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIImageView *ShowBar;
    
    IBOutlet UIButton *TranslateButton;
    IBOutlet UIButton *ShareLinkButton;
    
    NSString *GetID;
    NSString *GetPermisionUser;
    NSString *GetMainUserID;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_CollectionData;
    NSURLConnection *theConnection_GetTranslate;
    NSURLConnection *theConnection_QuickCollect;
    NSURLConnection *theConnection_FollowCollect;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    int TempHeight;
    
    //Collection Data
    NSString *GetTitle;
    NSString *GetDescription;
    NSString *GetUsername;
    NSString *GetUserProfile;
    NSString *GetUserID;
    NSString *GetLocation;
    NSString *GetTags;
    NSMutableArray *ArrHashTag;
    NSMutableArray *GetLanguagesArray;
    NSString *GetIsPrivate;
    NSString *GetFollowing;
    NSString *GetFollowersCount;
    
    //Content Data
    NSMutableArray *Content_arrImage;
    NSMutableArray *Content_arrTitle;
    NSMutableArray *Content_arrMessage;
    NSMutableArray *Content_arrPlaceName;
    NSMutableArray *Content_arrNote;
    NSMutableArray *Content_arrID;
    NSMutableArray *Content_arrID_arrDistance;
    NSMutableArray *Content_arrID_arrDisplayCountryName;
    NSMutableArray *Content_arrUserName;
    NSMutableArray *Content_arrCollect;
    
    UIButton *ListButton;
    UIButton *GridButton;
    
    UIView *ListView;
    UIView *GridView;
    
    int CheckClick;
    int CheckShowMessage;
    
    NSString *GetPostID;
    NSString *CheckCollect;
    int GetCollectionHeight;
    IBOutlet UILabel *ShowTitleInTop;
    
    UIButton *MainEditButton;
    
    //Translate
    NSString *strGetTranslateTitle;
    NSString *strGetTranslateDescription;
    NSMutableArray *Translate_arrNote;
    NSMutableArray *Translate_arrID;
    
    NSString *strOriginalTitle;
    NSString *strOriginalDescription;
    NSMutableArray *Original_arrNote;
    NSMutableArray *Original_arrID;
    BOOL OriginalText;
}

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 50);
    MainScroll.alwaysBounceVertical = YES;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    MoreButton.frame = CGRectMake(screenWidth - 40, 20, 40, 44);
    MapButton.frame = CGRectMake(screenWidth - 80, 20, 40, 44);
    ShowTitleInTop.frame = CGRectMake(42, 32, screenWidth - 47, 20);
    ShowTitleInTop.hidden = YES;
    
    DownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
   // DownBarView.hidden = YES;
    [self.view addSubview:DownBarView];
    ShareButton.frame = CGRectMake(screenWidth - 120, 0, 120, 50);
    [ShareButton setTitle:LocalisedString(@"Share it") forState:UIControlStateNormal];
    TranslateButton.frame = CGRectMake(10, 3, 43, 43);
    ShareLinkButton.frame = CGRectMake(61, 3, 43, 43);
    
    ShowBar.frame = CGRectMake(0, -64, screenWidth, 64);
    
    CheckLoad = NO;
    TotalPage = 1;
    CurrentPage = 0;
    GetHeight = 0;
    CheckFirstTimeLoad = 0;
    GetCollectionHeight = 0;
    CheckShowMessage = 0;
    TempHeight = 0;
    CheckButtonOnClick = 0;
    OriginalText = YES;
    if ([GetID length] ==0) {
        
    }else{
        [self GetCollectionData];
    }
}
- (void)dealloc {
    [MainScroll setDelegate:nil];
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
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_HIDE" object:nil];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
   // self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
}
-(IBAction)BackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetCollectionID:(NSString *)ID_ GetPermision:(NSString *)PermisionUser GetUserUid:(NSString *)UserUid{

    GetID = ID_;
    GetPermisionUser = PermisionUser;
    GetMainUserID = UserUid;
    NSLog(@"Get Collection ID is %@",GetID);
    NSLog(@"Get Permision User is %@",GetPermisionUser);
    [self GetCollectionData];
}
-(void)GetCollectionData{
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
    }else{
        CurrentPage += 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *GetLat = [defaults objectForKey:@"UserCurrentLocation_lat"];
        NSString *Getlng = [defaults objectForKey:@"UserCurrentLocation_lng"];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        
        if ([GetPermisionUser isEqualToString:@"Self"] || [GetPermisionUser isEqualToString:@"self"]) {
            GetMainUserID = [defaults objectForKey:@"Useruid"];
        }else{
            
            
        }
        
        
        
        NSString *FullString;
        if ([GetLat length] == 0 || [GetLat isEqualToString:@""] || [GetLat isEqualToString:@"(null)"] || GetLat == nil) {
            FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/%@?page=%li&token=%@",DataUrl.UserWallpaper_Url,GetMainUserID,GetID,CurrentPage,GetExpertToken];
        }else{
            FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/%@?page=%li&lat=%@&lng=%@&token=%@",DataUrl.UserWallpaper_Url,GetMainUserID,GetID,CurrentPage,GetLat,Getlng,GetExpertToken];
        }

        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"GetCollectionData check postBack URL ==== %@",postBack);
        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_CollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_CollectionData start];
        if( theConnection_CollectionData ){
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
    if (connection == theConnection_CollectionData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"theConnection_CollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *ResData = [res valueForKey:@"data"];
            
            GetTitle = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"name"]];
            GetDescription = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"description"]];
            GetTags = [[NSString alloc]initWithFormat:@"%@",[ResData valueForKey:@"tags"]];
            GetIsPrivate = [[NSString alloc]initWithFormat:@"%@",[ResData valueForKey:@"is_private"]];
            GetFollowing = [[NSString alloc]initWithFormat:@"%@",[ResData valueForKey:@"following"]];
            GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[ResData valueForKey:@"follower_count"]];
            
            strOriginalTitle = GetTitle;
            strOriginalDescription = GetDescription;
            
            NSLog(@"Collection GetFollowing data is %@",GetFollowing);
            NSArray *LanguageData = [ResData valueForKey:@"languages"];
            GetLanguagesArray = [[NSMutableArray alloc]initWithArray:LanguageData];
            
            NSArray *TempGetTags = [ResData objectForKey:@"tags"];
            GetTags = [TempGetTags componentsJoinedByString:@","];
            
            if ([GetTags length] == 0 || [GetTags isEqualToString:@""] || [GetTags isEqualToString:@"(null)"] || GetTags == nil) {
            }else{
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
                GetTags = [[GetTags componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                NSArray *arr = [GetTags componentsSeparatedByString:@","];
                ArrHashTag = [[NSMutableArray alloc]initWithArray:arr];
            }
            
            NSDictionary *UserData = [ResData valueForKey:@"user_info"];
            GetUsername = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"username"]];
            GetLocation = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"location"]];
            GetUserProfile = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"profile_photo"]];
            GetUserID = [[NSString alloc]initWithFormat:@"%@",[UserData objectForKey:@"uid"]];
            NSLog(@"Collection GetUserID data is %@",GetUserID);
            
            NSDictionary *PostsData = [ResData valueForKey:@"collection_posts"];
            NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[PostsData objectForKey:@"page"]];
            NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[PostsData objectForKey:@"total_page"]];
            
            CurrentPage = [Temppage intValue];
            TotalPage = [Temptotal_page intValue];
            
            if (CheckFirstTimeLoad == 0) {
                Content_arrImage = [[NSMutableArray alloc]init];
                Content_arrID = [[NSMutableArray alloc]init];
                Content_arrTitle = [[NSMutableArray alloc]init];
                Content_arrPlaceName = [[NSMutableArray alloc]init];
                Content_arrNote = [[NSMutableArray alloc]init];
                Content_arrID_arrDistance = [[NSMutableArray alloc]init];
                Content_arrID_arrDisplayCountryName = [[NSMutableArray alloc]init];
                Content_arrMessage = [[NSMutableArray alloc]init];
                Content_arrUserName = [[NSMutableArray alloc]init];
                Content_arrCollect = [[NSMutableArray alloc]init];
                
                Original_arrID = [[NSMutableArray alloc]init];
                Original_arrNote = [[NSMutableArray alloc]init];
            }else{
            }
            
            
            NSDictionary *GetData = [PostsData valueForKey:@"posts"];
            
            
            for (NSDictionary * dict in GetData) {
                NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                [Content_arrPlaceName addObject:PlaceName];
                NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [Content_arrID addObject:PlaceID];
                [Original_arrID addObject:PlaceID];
                NSString *notedate = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_note"]];
                [Content_arrNote addObject:notedate];
                [Original_arrNote addObject:notedate];
                NSString *collect = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collect"]];
                [Content_arrCollect addObject:collect];
            }
            
            NSDictionary *titleData = [GetData valueForKey:@"title"];
            for (NSDictionary * dict in titleData) {
                if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    [Content_arrTitle addObject:@""];
                }else{
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                        Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530d5e9b642440d128000018"]];
                    }
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        [Content_arrTitle addObject:@""];
                                    }else{
                                        [Content_arrTitle addObject:PhilippinesTitle];
                                        
                                    }
                                }else{
                                    [Content_arrTitle addObject:IndonesianTitle];
                                    
                                }
                            }else{
                                [Content_arrTitle addObject:ThaiTitle];
                            }
                        }else{
                            [Content_arrTitle addObject:Title2];
                        }
                        
                    }else{
                        [Content_arrTitle addObject:Title1];
                        
                    }
                    
                }
            }
            
            NSDictionary *messageData = [GetData valueForKey:@"message"];
            for (NSDictionary * dict in messageData) {
                if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    [Content_arrMessage addObject:@""];
                }else{
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                        Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530d5e9b642440d128000018"]];
                    }
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        [Content_arrMessage addObject:@""];
                                    }else{
                                        [Content_arrMessage addObject:PhilippinesTitle];
                                        
                                    }
                                }else{
                                    [Content_arrMessage addObject:IndonesianTitle];
                                    
                                }
                            }else{
                                [Content_arrMessage addObject:ThaiTitle];
                            }
                        }else{
                            [Content_arrMessage addObject:Title2];
                        }
                        
                    }else{
                        [Content_arrMessage addObject:Title1];
                        
                    }
                    
                }
            }
            
            NSDictionary *PostUserData = [GetData valueForKey:@"user_info"];
            for (NSDictionary * dict in PostUserData) {
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [Content_arrUserName addObject:username];
            }


            NSDictionary *locationData = [GetData valueForKey:@"location"];
            for (NSDictionary * dict in locationData) {
                NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                [Content_arrID_arrDistance addObject:formatted_address];
                NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                [Content_arrID_arrDisplayCountryName addObject:SearchDisplayName];
            }
            
            
//            NSDictionary *CollectionsData = [GetData valueForKey:@"collections"];
//            for (NSDictionary * dict in CollectionsData) {
//                for (NSDictionary * dict_ in dict) {
//                    NSDictionary *GetPostsData = [dict_ valueForKey:@"posts"];
//                  //  NSLog(@"GetPostsData note is %@",GetPostsData);
//                    for (NSDictionary * dict in GetPostsData) {
//                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"note"]];
//                        [Content_arrNote addObject:url];
//
//                    }
//                }
//            }
            
            
            
            NSArray *PhotoData = [GetData valueForKey:@"photos"];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *captionArray = [[NSMutableArray alloc]init];
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                    [captionArray addObject:caption];
                    NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                    [UrlArray addObject:url];
                }
                NSString *result2 = [UrlArray componentsJoinedByString:@","];
                [Content_arrImage addObject:result2];
            }
//            NSLog(@"Content_arrImage is %@",Content_arrImage);
//            NSLog(@"Content_arrNote is %@",Content_arrNote);
//            NSLog(@"Content_arrTitle is %@",Content_arrTitle);
//            NSLog(@"Content_arrID_arrDistance is %@",Content_arrID_arrDistance);
//            NSLog(@"Content_arrID_arrDisplayCountryName is %@",Content_arrID_arrDisplayCountryName);
//            NSLog(@"Content_arrID is %@",Content_arrID);
//            NSLog(@"Content_arrPlaceName is %@",Content_arrPlaceName);
            
            DataCount = DataTotal;
            DataTotal = [Content_arrImage count];
            if (CheckFirstTimeLoad == 0) {
                CheckFirstTimeLoad = 1;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *GetSystemLanguageCheck = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
                NSLog(@"GetSystemLanguageCheck is %@",GetSystemLanguageCheck);
                
                NSString *GetSystemLanguageCode;

                if ([GetSystemLanguageCheck isEqualToString:@"English"]) {
                   GetSystemLanguageCode = @"530b0ab26424400c76000003";
                }else if([GetSystemLanguageCheck isEqualToString:@"繁體中文"] || [GetSystemLanguageCheck isEqualToString:@"Traditional Chinese"]){
                    GetSystemLanguageCode = @"530b0aa16424400c76000002";
                }else if([GetSystemLanguageCheck isEqualToString:@"简体中文"] || [GetSystemLanguageCheck isEqualToString:@"Simplified Chinese"] || [GetSystemLanguageCheck isEqualToString:@"中文"]){
                    GetSystemLanguageCode = @"530b0aa16424400c76000002";
                }else if([GetSystemLanguageCheck isEqualToString:@"Bahasa Indonesia"]){
                   GetSystemLanguageCode = @"53672e863efa3f857f8b4ed2";
                }else if([GetSystemLanguageCheck isEqualToString:@"Filipino"]){
                    GetSystemLanguageCode = @"539fbb273efa3fde3f8b4567";
                }else if([GetSystemLanguageCheck isEqualToString:@"ภาษาไทย"] || [GetSystemLanguageCheck isEqualToString:@"Thai"]){
                    GetSystemLanguageCode = @"544481503efa3ff1588b4567";
                }else{
                    GetSystemLanguageCode = @"530b0ab26424400c76000003";
                }
                
                BOOL CheckShowLangaugesButton = NO;
                
                if ([GetLanguagesArray count] == 1) {
                    for (int i = 0; i < [GetLanguagesArray count]; i++) {
                        NSString *TempLangauges = [[NSString alloc]initWithFormat:@"%@",[GetLanguagesArray objectAtIndex:i]];
                        
                        if ([TempLangauges isEqualToString:GetSystemLanguageCode]) {
                            CheckShowLangaugesButton = NO;
                            break;
                        }else{
                            CheckShowLangaugesButton = YES;
                        }
                    }
                    
                    
                    if (CheckShowLangaugesButton == NO) {
                        //  TranslateButton.frame = CGRectMake(10, 3, 43, 43);
                        TranslateButton.hidden = YES;
                        ShareLinkButton.frame = CGRectMake(10, 3, 43, 43);
                    }else{
                        
                    }
                }else{
                
                }
                

                
                
                [self InitView];
                
            }else{
              //  GridView.hidden = YES;
                CheckClick = 0;
                if (CheckButtonOnClick == 1) {
                    [self InitGridViewData];
                }else{
                    
                    [self InitContentListView];
                }

            }
            
            CheckLoad = NO;
            
        }
        [ShowActivity stopAnimating];
    }else if (connection == theConnection_GetTranslate){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"theConnection_GetTranslate return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"theConnection_CollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *ResData = [res valueForKey:@"data"];
            
            strGetTranslateTitle = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"name"]];
            strGetTranslateDescription = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"description"]];
            
            NSDictionary *GetData = [ResData valueForKey:@"posts"];
            
            Translate_arrID = [[NSMutableArray alloc]init];
            Translate_arrNote = [[NSMutableArray alloc]init];
            
            for (NSDictionary * dict in GetData) {
                NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [Translate_arrID addObject:PlaceID];
                NSString *notedate = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_note"]];
                [Translate_arrNote addObject:notedate];
            }
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            for (UIView *subview in ListView.subviews) {
                [subview removeFromSuperview];
            }
            for (UIView *subview in GridView.subviews) {
                [subview removeFromSuperview];
            }
            GetHeight = 0;
            CheckFirstTimeLoad = 0;
            GetCollectionHeight = 0;
            CheckShowMessage = 0;
            TempHeight = 0;
            
            GetTitle = strGetTranslateTitle;
            GetDescription = strGetTranslateDescription;
            
            [Content_arrID removeAllObjects];
            [Content_arrNote removeAllObjects];
            
            [Content_arrID addObjectsFromArray:Translate_arrID];
            [Content_arrNote addObjectsFromArray:Translate_arrNote];
            
            OriginalText = NO;
            [self InitView];
            
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
            if (CheckShowMessage == 0) {
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];
            }else{
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Delete Posts" type:TSMessageNotificationTypeSuccess];
            }
            
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
            if ([GetFollowing isEqualToString:@"0"]) {
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success follow this collection" type:TSMessageNotificationTypeSuccess];
                GetFollowing = @"1";
                
                [DataManager setCollectionFollowing:GetID isFollowing:YES];
            }else{
                [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success unfollow this collection" type:TSMessageNotificationTypeSuccess];
                GetFollowing = @"0";
                [DataManager setCollectionFollowing:GetID isFollowing:NO];

            }
            
            
        }
    }
    
    
    [ShowActivity stopAnimating];
}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *WhiteBackground = [[UIButton alloc]init];
    WhiteBackground.frame = CGRectMake(0, 0, screenWidth, 300);
    [WhiteBackground setTitle:@"" forState:UIControlStateNormal];
    WhiteBackground.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:WhiteBackground];

    NSString *ImageData;
    if ([Content_arrImage count] > 0){
        int randomIndex = arc4random()%[Content_arrImage count];
        ImageData = [Content_arrImage objectAtIndex:randomIndex];
    }
    NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
    NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
    AsyncImageView *BackgroundImg = [[AsyncImageView alloc]init];
    BackgroundImg.frame = CGRectMake(0, -20, screenWidth, 140);
  //  BackgroundImg.image = [UIImage imageNamed:@"NoPhotoInCollection.png"];
    NSLog(@"FullImagesURL_First is %@",FullImagesURL_First);
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BackgroundImg];
    if ([FullImagesURL_First length] == 0 || [FullImagesURL_First isEqualToString:@"(null)"] || [FullImagesURL_First isEqualToString:@"<null>"]) {
        BackgroundImg.image = [UIImage imageNamed:@"NoPhotoInCollection.png"];
        BackgroundImg.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        BackgroundImg.contentMode = UIViewContentModeScaleAspectFill;
        BackgroundImg.layer.masksToBounds = YES;
        NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
        BackgroundImg.imageURL = url_NearbySmall;
    }
    [MainScroll addSubview:BackgroundImg];
    
    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
    ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
    ShowOverlayImg.frame = CGRectMake(0, -20, screenWidth, 140);
    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
    ShowOverlayImg.layer.masksToBounds = YES;
    [MainScroll addSubview:ShowOverlayImg];
    
    AsyncImageView *UserImage = [[AsyncImageView alloc]init];
    UserImage.frame = CGRectMake((screenWidth /2) - 30, 90, 60, 60);
    UserImage.contentMode = UIViewContentModeScaleAspectFill;
    UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImage.layer.cornerRadius = 30;
    UserImage.layer.borderWidth = 0;
    UserImage.layer.masksToBounds = YES;
    UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",GetUserProfile];
    if ([FullImagesURL length] == 0) {
        UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
        UserImage.imageURL = url_NearbySmall;
    }
    [MainScroll addSubview:UserImage];

    
    GetHeight += 160;
    
    UILabel *TempShowTitle = [[UILabel alloc]init];
    TempShowTitle.frame = CGRectMake(20, GetHeight, screenWidth - 40, 30);
    TempShowTitle.text = GetTitle;
    TempShowTitle.backgroundColor = [UIColor clearColor];
    TempShowTitle.textAlignment = NSTextAlignmentCenter;
    TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    TempShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
    [MainScroll addSubview:TempShowTitle];
    
    ShowTitleInTop.text = GetTitle;
    
    GetCollectionHeight = GetHeight;
    

    GetHeight += 30;
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"by %@ • %@ %@",GetUsername,GetFollowersCount,LocalisedString(@"Followers")];
    
    UILabel *TempShowUserDetail = [[UILabel alloc]init];
    TempShowUserDetail.frame = CGRectMake(20, GetHeight, screenWidth - 40, 20);
    TempShowUserDetail.text = TempString;
    TempShowUserDetail.backgroundColor = [UIColor clearColor];
    TempShowUserDetail.textAlignment = NSTextAlignmentCenter;
    TempShowUserDetail.textColor = [UIColor colorWithRed:152.0f/255.0f green:152.0f/255.0f blue:152.0f/255.0f alpha:1.0f];
    TempShowUserDetail.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    [MainScroll addSubview:TempShowUserDetail];
    
    UIButton *OpenProfileButton = [[UIButton alloc]init];
    [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
    OpenProfileButton.backgroundColor = [UIColor clearColor];
    OpenProfileButton.frame = CGRectMake(20, GetHeight, (screenWidth / 2), 20);
    [OpenProfileButton addTarget:self action:@selector(OpenProfileButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:OpenProfileButton];
    
    UIButton *OpenFollowersButton = [[UIButton alloc]init];
    [OpenFollowersButton setTitle:@"" forState:UIControlStateNormal];
    OpenFollowersButton.backgroundColor = [UIColor clearColor];
    OpenFollowersButton.frame = CGRectMake((screenWidth / 2), GetHeight, (screenWidth / 2), 20);
    [OpenFollowersButton addTarget:self action:@selector(OpenFollowersButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:OpenFollowersButton];
    
    GetHeight += 30;
    
    if ([GetDescription isEqualToString:@""] || [GetDescription isEqualToString:@"(null)"] || [GetDescription length] == 0) {
        
    }else{
        UILabel *ShowAboutText = [[UILabel alloc]init];
        ShowAboutText.frame = CGRectMake(30, GetHeight, screenWidth - 60, 30);
        ShowAboutText.text = GetDescription;
        ShowAboutText.numberOfLines = 0;
        ShowAboutText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowAboutText.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowAboutText.textAlignment = NSTextAlignmentCenter;
        [MainScroll addSubview:ShowAboutText];
        
        CGSize size = [ShowAboutText sizeThatFits:CGSizeMake(ShowAboutText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAboutText.frame;
        frame.size.height = size.height;
        ShowAboutText.frame = frame;
        
        GetHeight += ShowAboutText.frame.size.height + 10;
    }
    
    if ([GetTags isEqualToString:@""] || [GetTags isEqualToString:@"(null)"] || [GetTags length] == 0) {
        
    }else{
        
        UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
        HashTagScroll.delegate = self;
        HashTagScroll.frame = CGRectMake(0, GetHeight, screenWidth, 50);
        HashTagScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll addSubview:HashTagScroll];
        CGRect frame2 = {0,0};
        for (int i= 0; i < [ArrHashTag count]; i++) {
            UILabel *ShowHashTagText = [[UILabel alloc]init];
            ShowHashTagText.text = [ArrHashTag objectAtIndex:i];
            ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            ShowHashTagText.textAlignment = NSTextAlignmentCenter;
            ShowHashTagText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowHashTagText.layer.cornerRadius = 5;
            ShowHashTagText.layer.borderWidth = 1;
            ShowHashTagText.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
            
            
            NSString *Text = [NSString stringWithCString:[[ArrHashTag objectAtIndex:i] UTF8String] encoding:NSUTF8StringEncoding];
            CGRect r = [Text boundingRectWithSize:CGSizeMake(200, 0)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12]}
                                          context:nil];
            
            //NSLog(@"r ==== %f",r.size.width);
            
            UIButton *TagsButton = [[UIButton alloc]init];
            [TagsButton setTitle:@"" forState:UIControlStateNormal];
            TagsButton.backgroundColor = [UIColor clearColor];
            TagsButton.tag = i;
            TagsButton.frame = CGRectMake(25 + frame2.size.width, 15, r.size.width + 20, 20);
            [TagsButton addTarget:self action:@selector(PersonalTagsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //CGSize textSize = [ShowHashTagText.text sizeWithAttributes:@{NSFontAttributeName:[ShowHashTagText font]}];
            //   CGFloat textSize = ShowHashTagText.intrinsicContentSize.width;
            ShowHashTagText.frame = CGRectMake(30 + frame2.size.width, 15, r.size.width + 20, 20);
            frame2.size.width += r.size.width + 30;
            [HashTagScroll addSubview:ShowHashTagText];
            [HashTagScroll addSubview:TagsButton];
            
            HashTagScroll.contentSize = CGSizeMake(30 + frame2.size.width , 50);
        }
        GetHeight += 50;
    }

    //edit button
    MainEditButton = [[UIButton alloc]init];
    MainEditButton.frame = CGRectMake((screenWidth / 2) - 58, GetHeight, 115, 38);
    MainEditButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [MainEditButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    MainEditButton.backgroundColor = [UIColor clearColor];
    [MainEditButton setTitle:@"" forState:UIControlStateNormal];
    [MainEditButton addTarget:self action:@selector(EditButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([GetPermisionUser isEqualToString:@"Self"] || [GetPermisionUser isEqualToString:@"self"]) {
        [MainEditButton setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
        MainEditButton.layer.cornerRadius= 18;
        MainEditButton.layer.borderWidth = 1;
        MainEditButton.layer.masksToBounds = YES;
        MainEditButton.layer.borderColor=[[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0] CGColor];

    }else{
        if ([GetFollowing isEqualToString:@"0"]) {
//            [MainEditButton setTitle:LocalisedString(@"PFollow") forState:UIControlStateNormal];
//            [MainEditButton setTitle:LocalisedString(@"Unfollow") forState:UIControlStateSelected];
            [MainEditButton setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
            [MainEditButton setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
        }else{
//            [MainEditButton setTitle:LocalisedString(@"Unfollow") forState:UIControlStateNormal];
//            [MainEditButton setTitle:LocalisedString(@"PFollow") forState:UIControlStateSelected];
            [MainEditButton setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateNormal];
            [MainEditButton setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateSelected];
        }

        
    }
    [MainScroll addSubview:MainEditButton];
    
    GetHeight += 45;

    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    Line01.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [MainScroll addSubview:Line01];
    
    GetHeight += 1;
    
    ListButton = [[UIButton alloc]init];
    ListButton.frame = CGRectMake(0, GetHeight, (screenWidth / 2), 50);
    [ListButton setImage:[UIImage imageNamed:@"ListViewActive.png"] forState:UIControlStateNormal];
    ListButton.backgroundColor = [UIColor clearColor];
    [ListButton addTarget:self action:@selector(ListButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:ListButton];
    
    GridButton = [[UIButton alloc]init];
    GridButton.frame = CGRectMake((screenWidth / 2), GetHeight, (screenWidth / 2), 50);
    [GridButton setImage:[UIImage imageNamed:@"GridViewInactive.png"] forState:UIControlStateNormal];
    GridButton.backgroundColor = [UIColor clearColor];
    [GridButton addTarget:self action:@selector(GridButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:GridButton];
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(0, GetHeight + 50, screenWidth, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    Line02.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
    [MainScroll addSubview:Line02];
    
    GetHeight += 51;
    
    WhiteBackground.frame = CGRectMake(0, 0, screenWidth, GetHeight);
    
    ListView = [[UIView alloc]init];
    ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, 400);
    ListView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:ListView];
    
    GridView = [[UIView alloc]init];
    GridView.frame = CGRectMake(0, GetHeight + 10, screenWidth, 600);
    GridView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:GridView];
    
    GridView.hidden = YES;
    CheckClick = 0;
    
    [self InitContentListView];
    
}
-(IBAction)EditButtonOnClick:(id)sender{
    
    
    if ([GetPermisionUser isEqualToString:@"Self"] || [GetPermisionUser isEqualToString:@"self"]) {
        _navEditCollectionViewController = nil;
        _editCollectionViewController = nil;// for the view controller to reinitialize
        
        [LoadingManager show];
        
        [self.editCollectionViewController initData:GetID];
        [LoadingManager show];
        [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
    }else{
        
        
        NSLog(@"follow collection button on click");
        if ([GetFollowing isEqualToString:@"0"]) {
            [self FollowCollection];
           // GetFollowing = @"1";
            MainEditButton.selected = !MainEditButton.selected;
        }else{
            [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == [alertView cancelButtonIndex]) {
                    NSLog(@"Cancelled");
                    
                } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {

                    MainEditButton.selected = !MainEditButton.selected;
                    [self DeleteFollowCollection];

                    
                    
                }
            }];
            
            //GetFollowing = @"0";
        }
        
    }
    

}
#pragma mark - Declaration

-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [[ShareV2ViewController alloc]initWithNibName:@"ShareV2ViewController" bundle:nil];
    }
    
    return _shareV2ViewController;
}

-(EditCollectionViewController*)editCollectionViewController
{
    
    if (!_editCollectionViewController) {
        
        _editCollectionViewController = [EditCollectionViewController new];
        
    }
    return _editCollectionViewController;
}

-(UINavigationController*)navEditCollectionViewController
{
    
    if (!_navEditCollectionViewController) {
        
        _navEditCollectionViewController = [[UINavigationController alloc]initWithRootViewController:self.editCollectionViewController];
        [_navEditCollectionViewController setNavigationBarHidden:YES animated:NO];
        
    }
    return _navEditCollectionViewController;
}
-(IBAction)ListButtonOnClick:(id)sender{
    CheckButtonOnClick = 0;
    [ListButton setImage:[UIImage imageNamed:@"ListViewActive.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"GridViewInactive.png"] forState:UIControlStateNormal];
    
    GridView.hidden = YES;
    ListView.hidden = NO;

    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + ListView.frame.size.height + 50;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}
-(IBAction)GridButtonOnClick:(id)sender{
    CheckButtonOnClick = 1;
    [ListButton setImage:[UIImage imageNamed:@"ListViewInactive.png"] forState:UIControlStateNormal];
    [GridButton setImage:[UIImage imageNamed:@"GridViewActive.png"] forState:UIControlStateNormal];
    
    ListView.hidden = YES;
    
    if (CheckClick == 0) {
        CheckClick = 1;
        GridView.hidden = NO;
        DataCount = 0;
        [self InitGridViewData];
    }else{
        GridView.hidden = NO;
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + GridView.frame.size.height + 50;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;

    }
    
    
}
-(void)InitContentListView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (CheckFirstTimeLoad == 0) {
        TempHeight = 10;
        
    }else{
    }
    
    if (TotalPage == 0) {
        TotalPage = 1;
    }
    
    if (DataTotal == 0) {
       
        
        UIImageView *ShowNoPostsImg = [[UIImageView alloc]init];
        ShowNoPostsImg.frame = CGRectMake((screenWidth / 2) - 48, TempHeight + 30, 95, 65);
        ShowNoPostsImg.image = [UIImage imageNamed:@"CollectionNoPost.png"];
        [ListView addSubview:ShowNoPostsImg];
        
        UILabel *ShowNoDataText1 = [[UILabel alloc]init];
        ShowNoDataText1.frame = CGRectMake(30, TempHeight + 115, screenWidth - 60, 20);
        ShowNoDataText1.text = LocalisedString(@"There's nothing 'ere, yet. Post");
        ShowNoDataText1.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowNoDataText1.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowNoDataText1.textAlignment = NSTextAlignmentCenter;
        [ListView addSubview:ShowNoDataText1];
        
//        UILabel *ShowNoDataText2 = [[UILabel alloc]init];
//        ShowNoDataText2.frame = CGRectMake(30, TempHeight + 145, screenWidth - 60, 20);
//        ShowNoDataText2.text = LocalisedString(@"There's nothing 'ere, yet. Post");
//        ShowNoDataText2.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
//        ShowNoDataText2.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//        ShowNoDataText2.textAlignment = NSTextAlignmentCenter;
//        [ListView addSubview:ShowNoDataText2];
        
        TempHeight += 200;
        ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, TempHeight + 20);
        
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + ListView.frame.size.height;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;
    }else{
        for (NSInteger i = DataCount; i < DataTotal; i++) {
            int CountHeight = TempHeight;
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.frame = CGRectMake(10, TempHeight, screenWidth - 20, 180);
            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage.layer.masksToBounds = YES;
            ShowImage.layer.cornerRadius = 5;
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[Content_arrImage objectAtIndex:i]];
            NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
            if ([FullImagesURL_First length] == 0) {
                ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
                ShowImage.imageURL = url_NearbySmall;
            }
            [ListView addSubview:ShowImage];
            
            UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
            ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
            ShowOverlayImg.frame = CGRectMake(10, TempHeight, screenWidth - 20, 180);
            ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
            ShowOverlayImg.layer.masksToBounds = YES;
            ShowOverlayImg.layer.cornerRadius = 5;
            [ListView addSubview:ShowOverlayImg];
            
            UIButton *ClickToDetailButton = [[UIButton alloc]init];
            ClickToDetailButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, 180);
            [ClickToDetailButton setTitle:@"" forState:UIControlStateNormal];
            ClickToDetailButton.backgroundColor = [UIColor clearColor];
            ClickToDetailButton.tag = i;
            [ClickToDetailButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
            [ListView addSubview:ClickToDetailButton];
            
            CheckCollect = [[NSString alloc]initWithFormat:@"%@",[Content_arrCollect objectAtIndex:i]];
            
            if ([GetPermisionUser isEqualToString:@"self"]) {
                
            }else{
                UIButton *CollectButton = [[UIButton alloc]init];
                [CollectButton setBackgroundColor:[UIColor clearColor]];
                if ([CheckCollect isEqualToString:@"0"]) {
                    [CollectButton setImage:[UIImage imageNamed:@"WhiteCollect.png"] forState:UIControlStateNormal];
                    [CollectButton setImage:[UIImage imageNamed:@"WhiteCollected.png"] forState:UIControlStateSelected];
                }else{
                    [CollectButton setImage:[UIImage imageNamed:@"WhiteCollected.png"] forState:UIControlStateNormal];
                    [CollectButton setImage:[UIImage imageNamed:@"WhiteCollect.png"] forState:UIControlStateSelected];
                }
                CollectButton.frame = CGRectMake(screenWidth - 13 - 57, CountHeight, 57, 57);
                CollectButton.tag = i;
                [CollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [ListView addSubview:CollectButton];
            }
            
            CountHeight += 10;
            
            NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[Content_arrTitle objectAtIndex:i]];
            if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                
            }else{
                UILabel *ShowTitle = [[UILabel alloc]init];
                if ([GetPermisionUser isEqualToString:@"self"]) {
                    ShowTitle.frame = CGRectMake(20, CountHeight, screenWidth - 40, 20);
                }else{
                    ShowTitle.frame = CGRectMake(20, CountHeight, screenWidth - 100, 20);
                }
                
                ShowTitle.text = TempGetStirng;
                ShowTitle.backgroundColor = [UIColor clearColor];
                ShowTitle.textAlignment = NSTextAlignmentLeft;
                ShowTitle.textColor = [UIColor whiteColor];
                ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [ListView addSubview:ShowTitle];
                
                //  TempHeight += ShowTitle.frame.size.height;
                CountHeight += 20;
                
            }
            
            
            UIImageView *ShowPin = [[UIImageView alloc]init];
            ShowPin.image = [UIImage imageNamed:@"PhotoPin.png"];
            ShowPin.frame = CGRectMake(18, CountHeight + 2, 15, 15);
            [ListView addSubview:ShowPin];
            
            NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[Content_arrID_arrDistance objectAtIndex:i]];
            //        NSLog(@"TempDistanceString is %@",TempDistanceString);
            NSString *FullShowLocatinString;
            if ([TempDistanceString isEqualToString:@"-1"]) {
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %@",[Content_arrPlaceName objectAtIndex:i],[Content_arrID_arrDisplayCountryName objectAtIndex:i]];
            }else{
                CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                int x_Nearby = [TempDistanceString intValue] / 1000;
                //            NSLog(@"strFloat is %f",strFloat);
                //            NSLog(@"x_Nearby is %i",x_Nearby);
                //            if (x_Nearby < 100) {
                //                if (x_Nearby <= 1) {
                //                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • 1km",[Content_arrPlaceName objectAtIndex:i]];//within
                //                }else{
                //                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %.fkm",[Content_arrPlaceName objectAtIndex:i],strFloat];
                //                }
                //
                //            }else{
                //                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %@",[Content_arrPlaceName objectAtIndex:i],[Content_arrID_arrDisplayCountryName objectAtIndex:i]];
                //
                //            }
                
                if (x_Nearby < 1) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %.fm",[Content_arrPlaceName objectAtIndex:i],strFloat];
                }else if(x_Nearby > 1000){
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %@",[Content_arrPlaceName objectAtIndex:i],[Content_arrID_arrDisplayCountryName objectAtIndex:i]];
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@ • %.fkm",[Content_arrPlaceName objectAtIndex:i],strFloat];
                }
                
            }
            UILabel *ShowDistance = [[UILabel alloc]init];
            if ([GetPermisionUser isEqualToString:@"self"]) {
                ShowDistance.frame = CGRectMake(40, CountHeight, screenWidth - 100, 20);
            }else{
                ShowDistance.frame = CGRectMake(40, CountHeight, screenWidth - 160, 20);
            }
            
            ShowDistance.text = FullShowLocatinString;
            ShowDistance.textColor = [UIColor whiteColor];
            ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowDistance.textAlignment = NSTextAlignmentLeft;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [ListView addSubview:ShowDistance];
            
            TempHeight += 190;
            
            NSString *TempGetNote = [[NSString alloc]initWithFormat:@"%@",[Content_arrNote objectAtIndex:i]];
            if ([TempGetNote length] == 0 || [TempGetNote isEqualToString:@""] || [TempGetNote isEqualToString:@"(null)"]) {
                NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[Content_arrMessage objectAtIndex:i]];
                if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
                    TempHeight += 20;
                }else{
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@: %@",[Content_arrUserName objectAtIndex:i],TempGetMessage];
                    
                    UILabel *ShowNoteData = [[UILabel alloc]init];
                    ShowNoteData.frame = CGRectMake(15, TempHeight, screenWidth - 50, 40);
                    ShowNoteData.backgroundColor = [UIColor clearColor];
                    ShowNoteData.numberOfLines = 3;
                    ShowNoteData.textAlignment = NSTextAlignmentLeft;
                    ShowNoteData.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                    ShowNoteData.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                    
                    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                    paragraph.minimumLineHeight = 21.0f;
                    paragraph.maximumLineHeight = 21.0f;
                    //                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:FullString attributes:@{NSParagraphStyleAttributeName: paragraph}];
                    //                ShowNoteData.attributedText = attributedString;
                    
                    NSString *FinalString_CheckName = [[NSString alloc] initWithFormat:@"%@:",[Content_arrUserName objectAtIndex:i]];
                    
                    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FullString];
                    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, FullString.length)];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15] range:NSMakeRange(0, FullString.length)];
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] range:NSMakeRange(0, FullString.length)];
                    
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName  options:kNilOptions error:nil];
                    NSRange range = NSMakeRange(0,FullString.length);
                    [regex enumerateMatchesInString:FullString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        NSRange subStringRange = [result rangeAtIndex:0];
                        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15] range:NSMakeRange(0, FinalString_CheckName.length)];
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] range:subStringRange];
                    }];
                    
                    [ShowNoteData setAttributedText:mutableAttributedString];
                    
                    //ShowNoteData.text = FullString;
                    
                    [ListView addSubview:ShowNoteData];
                    
                    if([ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowNoteData.frame.size.height)
                    {
                        ShowNoteData.frame = CGRectMake(15, TempHeight, screenWidth - 50,[ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                    }
                    
                    TempHeight += ShowNoteData.frame.size.height + 20;
                }
                
                
            }else{
                
                NSString *FullString = [[NSString alloc]initWithFormat:@"%@: %@",GetUsername,TempGetNote];
                
                UILabel *ShowNoteData = [[UILabel alloc]init];
                ShowNoteData.frame = CGRectMake(15, TempHeight, screenWidth - 50, 40);
                ShowNoteData.backgroundColor = [UIColor clearColor];
                ShowNoteData.numberOfLines = 3;
                ShowNoteData.textAlignment = NSTextAlignmentLeft;
                ShowNoteData.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                ShowNoteData.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.minimumLineHeight = 21.0f;
                paragraph.maximumLineHeight = 21.0f;
                
                NSString *FinalString_CheckName = [[NSString alloc] initWithFormat:@"%@:",GetUsername];
                
                NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FullString];
                [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, FullString.length)];
                [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15] range:NSMakeRange(0, FullString.length)];
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] range:NSMakeRange(0, FullString.length)];
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName  options:kNilOptions error:nil];
                NSRange range = NSMakeRange(0,FullString.length);
                [regex enumerateMatchesInString:FullString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    NSRange subStringRange = [result rangeAtIndex:0];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15] range:NSMakeRange(0, FinalString_CheckName.length)];
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] range:subStringRange];
                }];
                
                [ShowNoteData setAttributedText:mutableAttributedString];
                
                // ShowNoteData.text = FullString;
                
                [ListView addSubview:ShowNoteData];
                
                if([ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height!=ShowNoteData.frame.size.height)
                {
                    ShowNoteData.frame = CGRectMake(15, TempHeight, screenWidth - 50,[ShowNoteData sizeThatFits:CGSizeMake(screenWidth - 50, CGFLOAT_MAX)].height);
                }
                
                TempHeight += ShowNoteData.frame.size.height + 20;
                
            }
            
            
            
        }
        
        ListView.frame = CGRectMake(0, GetHeight + 10, screenWidth, TempHeight + 20);
        
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + ListView.frame.size.height;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;
    }


    
    
   // [self InitGridViewData];
}
-(void)InitGridViewData{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    int heightcheck = 10;
    
    int TestWidth = screenWidth - 35;
    //NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 5;
    // NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 5;
    
    if (DataTotal == 0) {
        
        UIImageView *ShowNoPostsImg = [[UIImageView alloc]init];
        ShowNoPostsImg.frame = CGRectMake((screenWidth / 2) - 48, heightcheck + 30, 95, 65);
        ShowNoPostsImg.image = [UIImage imageNamed:@"CollectionNoPost.png"];
        [GridView addSubview:ShowNoPostsImg];
        
        UILabel *ShowNoDataText1 = [[UILabel alloc]init];
        ShowNoDataText1.frame = CGRectMake(30, heightcheck + 115, screenWidth - 60, 20);
        ShowNoDataText1.text = LocalisedString(@"There's nothing 'ere, yet. Post");
        ShowNoDataText1.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowNoDataText1.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowNoDataText1.textAlignment = NSTextAlignmentCenter;
        [GridView addSubview:ShowNoDataText1];
        
        heightcheck += 200;
        
        GridView.frame = CGRectMake(0, GetHeight + 10, screenWidth, heightcheck + 20);
        
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + GridView.frame.size.height;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;
    }else{
        for (NSInteger i = DataCount; i < DataTotal; i++) {
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
            ShowImage.frame = CGRectMake(5+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage.layer.masksToBounds = YES;
            ShowImage.layer.cornerRadius = 5;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            NSString *ImageData = [[NSString alloc]initWithFormat:@"%@",[Content_arrImage objectAtIndex:i]];
            NSArray *SplitArray = [ImageData componentsSeparatedByString:@","];
            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
            if ([FullImagesURL_First length] == 0) {
                ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
                ShowImage.imageURL = url_NearbySmall;
            }
            [GridView addSubview:ShowImage];
            
            
            UIButton *ImageButton = [[UIButton alloc]init];
            [ImageButton setBackgroundColor:[UIColor clearColor]];
            [ImageButton setTitle:@"" forState:UIControlStateNormal];
            ImageButton.frame = CGRectMake(5+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
            ImageButton.tag = i;
            [ImageButton addTarget:self action:@selector(ClickToDetailButton:) forControlEvents:UIControlEventTouchUpInside];
            [GridView addSubview:ImageButton];
            
            GridView.frame = CGRectMake(0, GetHeight, screenWidth, heightcheck + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
        }
        if (GridView.frame.size.height < screenHeight) {
            
            GridView.frame = CGRectMake(0, GetHeight, screenWidth, screenHeight);
        }
        
        CGSize contentSize = MainScroll.frame.size;
        contentSize.height = GetHeight + GridView.frame.size.height + FinalWidth;
        MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        MainScroll.contentSize = contentSize;
    }
    

}

-(IBAction)ClickToDetailButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  //  self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
    
    FeedV2DetailViewController *vc = [[FeedV2DetailViewController alloc] initWithNibName:@"FeedV2DetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc GetPostID:[Content_arrID objectAtIndex:getbuttonIDN]];
    
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
                   // GetHeight = 0;
                    [self GetCollectionData];
                    [activityindicator1 stopAnimating];
                }
                
            }
        }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(scrollView == MainScroll){
        //NSLog(@"scrollview run here");
        
        float heightcheck_ = MainScroll.contentOffset.y;
        
        if (heightcheck_ > 64) {
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 ShowBar.frame = CGRectMake(0, 0, screenWidth, 64);
                             }
                             completion:^(BOOL finished) {
                             }];
        }else{
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 ShowBar.frame = CGRectMake(0, -64, screenWidth, 64);
                             }
                             completion:^(BOOL finished) {
                             }];
        }
        
        
        if (heightcheck_ > GetCollectionHeight) {
            ShowTitleInTop.hidden = NO;
        }else{
        
            ShowTitleInTop.hidden = YES;
        }
 
    }
 
}
-(IBAction)ShareButtonOnClick:(id)sender{
    
    if ([GetIsPrivate isEqualToString:@"true"]) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"your collection is set to private." type:TSMessageNotificationTypeError];
    }else{
//        ShareViewController *ShareView = [[ShareViewController alloc]init];
//        [self presentViewController:ShareView animated:YES completion:nil];
//        [ShareView GetCollectionID:GetID GetCollectionTitle:GetTitle];
        
        _shareV2ViewController = nil;
        UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
        [naviVC setNavigationBarHidden:YES animated:NO];
        [self.shareV2ViewController share:@"" title:GetTitle imagURL:@"" shareType:ShareTypeCollection shareID:GetID userID:GetMainUserID];
        MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
        formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
        formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        [self presentViewController:formSheetController animated:YES completion:nil];

    }
    

}
-(IBAction)ShareLinkButtonOnClick:(id)sender{
    if ([GetIsPrivate isEqualToString:@"true"]) {
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"your collection is set to private." type:TSMessageNotificationTypeError];
    }else{
        NSString *message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetID];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = message;
        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Copy Link" type:TSMessageNotificationTypeSuccess];
    }

}
-(IBAction)TranslateButtonOnClick:(id)sender{
    if ([strGetTranslateTitle length] == 0) {
        [self GetTranslateData];
    }else{
        
        if (OriginalText == NO) {
            OriginalText = YES;
            
            GetTitle = strOriginalTitle;
            GetDescription = strOriginalDescription;
            
            [Content_arrID removeAllObjects];
            [Content_arrNote removeAllObjects];
            
            [Content_arrID addObjectsFromArray:Original_arrID];
            [Content_arrNote addObjectsFromArray:Original_arrNote];
            
        }else{
            OriginalText = NO;
            
            GetTitle = strGetTranslateTitle;
            GetDescription = strGetTranslateDescription;
            
            [Content_arrID removeAllObjects];
            [Content_arrNote removeAllObjects];
            
            [Content_arrID addObjectsFromArray:Translate_arrID];
            [Content_arrNote addObjectsFromArray:Translate_arrNote];
        }
        
        GetHeight = 0;
        CheckFirstTimeLoad = 0;
        GetCollectionHeight = 0;
        CheckShowMessage = 0;
        TempHeight = 0;
        [self InitView];
    }
    
}

-(IBAction)PersonalTagsButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetTagsString = [[NSString alloc]initWithFormat:@"#%@",[ArrHashTag objectAtIndex:getbuttonIDN]];
    NSLog(@"ArrHashTag is %@",GetTagsString);
    
    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
    [self.navigationController pushViewController:SearchDetailView animated:YES];
    [SearchDetailView GetSearchKeyword:GetTagsString Getlat:@"" GetLong:@"" GetLocationName:@"" GetCurrentLat:@"" GetCurrentLong:@""];
}
-(void)GetTranslateData{
    [ShowActivity startAnimating];
    //[self.spinnerView startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/collections/%@/translate?token=%@",DataUrl.UserWallpaper_Url,GetMainUserID,GetID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //    NSLog(@"theRequest === %@",theRequest);
    //    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetTranslate = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetTranslate start];
    
    
    if( theConnection_GetTranslate ){
        webData = [NSMutableData data];
    }
}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    // NSLog(@"button %li",(long)getbuttonIDN);
    NSLog(@"Quick CollectButtonOnClick");
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[Content_arrID objectAtIndex:getbuttonIDN]];
    CheckCollect = [[NSString alloc]initWithFormat:@"%@",[Content_arrCollect objectAtIndex:getbuttonIDN]];

    
    if ([CheckCollect isEqualToString:@"0"]) {
        [Content_arrCollect replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        CheckShowMessage = 0;
        
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        [self SendQuickCollect];
    }else{
        [Content_arrCollect replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
        CheckShowMessage = 1;
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
        //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:[Content_arrID objectAtIndex:getbuttonIDN] GetImageData:[Content_arrImage objectAtIndex:getbuttonIDN]];
       // [self SendDeleteCollectPosts];
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
    
    NSData *postBodyData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)SendDeleteCollectPosts{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/posts",DataUrl.UserWallpaper_Url,GetUseruid,GetID];
    NSLog(@"Delete Posts in collection urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSString *dataString = [[NSString alloc]initWithFormat:@"token=%@&post_id=%@",GetExpertToken,GetPostID];
    
    NSData *postBodyData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBodyData];
    
    theConnection_QuickCollect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_QuickCollect) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(void)FollowCollection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow",DataUrl.UserWallpaper_Url,GetUserID,GetID];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@/collections/%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetUserID,GetID,GetExpertToken];
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
-(IBAction)OpenProfileButtonOnClick:(id)sender{
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetUserID];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
-(IBAction)OpenFollowersButtonOnClick:(id)sender{
    NSLog(@"OpenFollowersButtonOnClick");
    _showFollowerAndFollowingViewController = nil;
    [self.navigationController pushViewController:self.showFollowerAndFollowingViewController animated:YES onCompletion:^{
        [self.showFollowerAndFollowingViewController GetToken:GetID GetUID:GetUserID GetType:@"Collection"];
        
    }];
}
-(ShowFollowerAndFollowingViewController*)showFollowerAndFollowingViewController
{
    
    if (!_showFollowerAndFollowingViewController) {
        _showFollowerAndFollowingViewController = [ShowFollowerAndFollowingViewController new];
    }
    
    return _showFollowerAndFollowingViewController;
}
@end

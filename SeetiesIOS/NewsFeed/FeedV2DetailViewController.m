//
//  FeedV2DetailViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "FeedV2DetailViewController.h"
#import "FullImageViewController.h"
#import "NSAttributedString+DVSTracking.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CommentViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "NewUserProfileV2ViewController.h"
#import "LocationFeedDetailViewController.h"
#import "NearByRecommtationViewController.h"

#import "LandingV2ViewController.h"
#import "RecommendV2ViewController.h"
#import "NSString+ChangeAsciiString.h"
#import "AddCollectionDataViewController.h"
#import "LeveyTabBarController.h"
#import "ReportViewController.h"
#import "ShareViewController.h"
#import "SearchDetailViewController.h"
@interface FeedV2DetailViewController (){

    NSMutableArray *arrCollectionID;
    NSMutableArray *arrTitle;
    NSMutableArray *arrTotalCount;
    NSMutableArray *arrImageData;
    NSMutableArray *arrFollowing;
    
    NSMutableArray *arrUsername;
    NSMutableArray *arrUserID;
    NSMutableArray *arrUserImage;
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *MImageScroll;
    //IBOutlet UIPageControl *PageControlOn;
    IBOutlet UILabel *ShowImageCount;
    IBOutlet UIView *ShowbarView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIView *ShowDownBarView;
    IBOutlet UIImageView *ShareIcon;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIButton *ShowBarImg;
    IBOutlet UIButton *LocationButton;
    
    IBOutlet UILabel *ShowTotalLikeCount;
    IBOutlet UILabel *ShowTotalCommentCount;
    
    AsyncImageView *ShowImage;
    UIScrollView *ImageScroll;
    BOOL pageControlBeingUsed;
    
    NSString *GetPostID;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetPostAllData;
    NSURLConnection *theConnection_GetAllUserlikes;
    NSURLConnection *theConnection_GetAllComment;
    NSURLConnection *theConnection_likes;
    NSURLConnection *theConnection_Following;
    NSURLConnection *theConnection_DeletePost;
    NSURLConnection *theConnection_NearbyPost;
    NSURLConnection *theConnection_CollectionSuggestion;
    
    NSMutableArray *captionArray;
    NSMutableArray *UrlArray;
    NSMutableArray *PhotoIDArray;
    
    NSString *GetPlaceName;
    NSString *GetPlaceFormattedAddress;
    NSString *GetLink;
    
    //location inside data
    NSString *GetLat;
    NSString *GetLng;
    NSString *GetContactNo;
    NSString *GetExpense;
    NSString *GetPlaceLink;
    NSString *GetOpeningHourOpen;
    NSString *GetLikeCheck;
    NSString *GetCollectCheck;
    
    NSString *GetPeriods;
    NSString *GetOpenNow;
    
    NSString *TotalLikeCount;
    NSString *totalCommentCount;
    NSString *TotalCollectionCount;
    
    NSString *GetTags;
    
    NSString *GetTitle;
    NSString *GetMessage;
    
    NSString *EngTitle;
    NSString *ChineseTitle;
    NSString *ThaiTitle;
    NSString *IndonesianTitle;
    NSString *PhilippinesTitle;
    
    NSString *EndMessage;//530b0ab26424400c76000003
    NSString *ChineseMessage;//530b0aa16424400c76000002
    NSString *ThaiMessage;//544481503efa3ff1588b4567
    NSString *IndonesianMessage;//53672e863efa3f857f8b4ed2
    NSString *PhilippinesMessage;//539fbb273efa3fde3f8b4567
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *GetCategoryNameArray;
    NSMutableArray *GetCategoryBackgroundColorArray;
    
    NSString *GetPostName;
    NSString *GetPostUserName;
    NSString *GetUserUid;
    NSString *GetFollowing;
    NSString *GetUserProfileUrl;
    NSString *GetPostTime;
    
    NSString *GetlocationType;
    NSString *GetLocationRoute;
    NSString *GetLocationLocality;
    NSString *GetLocationAdministrative_Area_Level_1;
    NSString *GetLocationPostalCode;
    NSString *GetLocationCountry;
    NSString *GetLocationReference;
    NSString *GetLocationPlaceId;
    
    NSString *GetExpense_Show;
    NSString *GetExpense_Code;
    NSString *GetExpense_RealData;
    
    //Seetishop ID
    NSString *GetSeetishopID;
    NSString *GetSeetishopName;
    NSString *GetSeetishopImage;
    NSString *GetSeetishopAddress;
    
    NSMutableArray *ArrHashTag;
    
    NSString *PhotoCount;
    
    NSMutableArray *Like_UseruidArray;
    NSMutableArray *Like_UserProfilePhotoArray;
    NSMutableArray *Like_UsernameArray;
    
    NSMutableArray *CommentIDArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *MessageArray;
    NSMutableArray *User_Comment_uidArray;
    NSMutableArray *User_Comment_nameArray;
    NSMutableArray *User_Comment_usernameArray;
    NSMutableArray *User_Comment_photoArray;
    
    IBOutlet UIButton *LikeButton;
    IBOutlet UIButton *CommentButton;
    IBOutlet UIButton *shareFBButton;
    IBOutlet UIButton *AllCollectButton;
    IBOutlet UIButton *QuickCollectButton;
    
    BOOL CheckLikeInitView;
    
    NSInteger CheckCommentData;
    
    UIButton *ShowFollowButton;
    
    IBOutlet UIButton *LanguageButton;
    NSString *GetLang;
    NSInteger CheckLanguage;
    int CountLanguage;
    int ClickCount;
    NSMutableArray *CountLanguageArray;
    
    UILabel *ShowTitle;
    UITextView *ShowMessage;
    
    NSURLConnection *theConnection_GetTranslate;
    
    IBOutlet UILabel *ShowGoogleTranslateText;
    BOOL TestingUse;
    IBOutlet UIView *ShowLanguageTranslationView;
    IBOutlet UIButton *NewLanguageButton;
    
    NSString *GetENMessageString;
    NSString *GetENTItleStirng;
    NSString *CheckENTranslation;
    
    IBOutlet UIButton *ShowTitleBarColor;
    IBOutlet UILabel *ShareText;
    
    BOOL CheckLoadDone;
    
    UIColor *color;
    
    BOOL ShowGoogleTranslate;
    
    
    IBOutlet UIButton *LineButton;
    
    //IBOutlet UILabel *ShowPlaceNameTop;
    //IBOutlet UILabel *ShowCategoryTop;
    IBOutlet UILabel *ShowTopTitle;
    
    IBOutlet UIImageView *DisplayButton;
    
    CGFloat difference1;
    CGFloat difference2;
    
    NSInteger CheckClickCount;
    
    int GetFinalHeight;
    
    //nearby data array
    NSMutableArray *TitleArray_Nearby;
    NSMutableArray *UserInfo_NameArray_Nearby;
    NSMutableArray *UserInfo_UrlArray_Nearby;
    NSMutableArray *UserInfo_IDArray_Nearby;
    NSMutableArray *PhotoArray_Nearby;
    NSMutableArray *PostIDArray_Nearby;
    NSMutableArray *PlaceNameArray_Nearby;
    NSMutableArray *MessageArray_Nearby;
    NSMutableArray *DistanceArray_Nearby;
    NSMutableArray *SearchDisplayNameArray_Nearby;
    NSMutableArray *TotalCommentArray_Nearby;
    NSMutableArray *TotalLikeArray_Nearby;
    NSMutableArray *SelfCheckLikeArray_Nearby;
    NSMutableArray *SelfCheckCollectArray_Nearby;
    
    //LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    
    UIButton *SeeAllButton_Nearby;
    
    NSString *ViewCountString;
    
    NSURLConnection *theConnection_QuickCollect;
    NSURLConnection *theConnection_FollowCollect;
    
    int CheckLanguagedata;
    NSString *ShowLanguageType;
    
    NSMutableArray *TempGetLanguageArray;
    
    int CheckNearbyPost;
    BOOL isThereAnyCollectionSuggestion;
    int GetPlaceNameHeight;
    
    NSInteger ImageCount;
    
    NSString *GetCollectionFollowing;
    NSString *GetCollectID;
    NSString *GetCollectUserID;
    
    NSString *MessageCount;
    
    
}
@end

@implementation FeedV2DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    pageControlBeingUsed = NO;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ShareButton.frame = CGRectMake(screenWidth - 55, 0, 55, 64);
    ShareIcon.frame = CGRectMake(screenWidth - 38 - 5, 22, 38, 38);
   // PageControlOn.frame = CGRectMake(15, 300, screenWidth - 30, 37);
    ShowImageCount.frame = CGRectMake(15, 300, screenWidth - 30, 30);
    LocationButton.frame = CGRectMake(screenWidth - 85 - 15, 20, 60, 44);
    
    ShowTopTitle.frame = CGRectMake(35, 32, screenWidth - 155, 24);
    ShowTopTitle.hidden = YES;
    
    ShowDownBarView.frame = CGRectMake(0, screenHeight - 62 - 50, screenWidth, 62);
    ShowbarView.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowBarImg.frame = CGRectMake(0, -100, screenWidth, 64);
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MImageScroll.frame = CGRectMake(0, -20, screenWidth, 360);
    ShowLanguageTranslationView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowLanguageTranslationView.hidden = YES;
    

    
    ShowTotalLikeCount.frame = CGRectMake((screenWidth/2) - 100, 15, 40, 21);
    ShowTotalCommentCount.frame = CGRectMake((screenWidth/2), 15, 40, 21);
    ShareText.frame = CGRectMake((screenWidth/2)+100, 15, 90, 21);
    
    LanguageButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
    NewLanguageButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
    DisplayButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
    [self.view addSubview:ShowLanguageTranslationView];
    

    
//    ShowPlaceNameTop.frame = CGRectMake(44, 21, screenWidth - 155, 24);
//    ShowCategoryTop.frame = CGRectMake(44, 38, screenWidth - 155, 21);
//    ShowPlaceNameTop.hidden = YES;
//    ShowCategoryTop.hidden = YES;
    
    [MImageScroll setScrollEnabled:YES];
    MImageScroll.delegate = self;
    [MImageScroll setBounces:NO];
    
    MainScroll.delegate = self;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 1500)];
    //ShowbarView.hidden = YES;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    [MainScroll addSubview:MImageScroll];
   // [MainScroll addSubview:PageControlOn];
    [MainScroll addSubview:ShowImageCount];
    
  //  [self.view addSubview:ShowbarView];
    //ShareButton.hidden = YES;
    //ShareIcon.hidden = YES;
    CheckLikeInitView = NO;
    CheckCommentData = 0;
    CountLanguage = 0;
    CheckNearbyPost = 0;
    isThereAnyCollectionSuggestion = YES;
    GetPlaceNameHeight = 0;
    ImageCount = 0;
    LanguageButton.hidden = YES;
    NewLanguageButton.hidden = YES;
    TestingUse = NO;
    
    ShareText.text = CustomLocalisedString(@"Share",nil);
    
    CheckLoadDone = NO;
    
    LineButton.frame = CGRectMake(screenWidth - 105 - 15, screenHeight - 23, 105, 1);

    LikeButton.frame = CGRectMake(10, 7, 37, 37);
    CommentButton.frame = CGRectMake(60, 7, 37, 37);
    shareFBButton.frame = CGRectMake(110, 7, 37, 37);
    
    
    [AllCollectButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
    [AllCollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [AllCollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    AllCollectButton.backgroundColor = [UIColor clearColor];
    AllCollectButton.frame = CGRectMake(screenWidth - 10 - 140, 0, 140, 50);
    
    QuickCollectButton.frame = CGRectMake(screenWidth - 10 - 60, 7, 60, 37);

    ShowGoogleTranslate = NO;
    CheckClickCount = 0;
    CheckLanguagedata = 0;
    
    UISwipeGestureRecognizer *swipeRight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    


}
- (void)dealloc {
    [MainScroll setDelegate:nil];
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
////    //Do what you want here
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self presentViewController:ListingDetail animated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    ShowDownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.leveyTabBarController.tabBar.frame = CGRectMake(0, 300, 320, 100);
    
   // self.screenName = @"IOS Feed Detail Page";
    self.screenName = @"IOS Feed Detail View V2";
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    ShowDownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight, screenWidth, 50);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_HIDE" object:nil];


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetNearbyIDNString = [defaults objectForKey:@"NearbyRecommendationsIDN"];
    if ([GetNearbyIDNString length] == 0 || [GetNearbyIDNString isEqualToString:@""] || [GetNearbyIDNString isEqualToString:@"(null)"] || GetNearbyIDNString == nil) {
        
        if (CheckCommentData == 1) {
            [self GetAllCommentData];
        }
        
        if (CheckLoadDone == NO) {
            [ShowActivity startAnimating];
        }
        
    }else{
        [MainScroll setContentOffset:CGPointZero animated:YES];
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in MImageScroll.subviews) {
            [subview removeFromSuperview];
        }
        
        //ShareButton.hidden = YES;
       // ShareIcon.hidden = YES;
        CheckLikeInitView = NO;
        CheckCommentData = 0;
        CountLanguage = 0;
        LanguageButton.hidden = YES;
        NewLanguageButton.hidden = YES;
        TestingUse = NO;
        CheckLoadDone = NO;
        CheckClickCount = 0;
        CheckLanguagedata = 0;
        CheckNearbyPost = 0;
        isThereAnyCollectionSuggestion = YES;
        if (CheckLoadDone == NO) {
            [ShowActivity startAnimating];
        }
        
        GetPostID = GetNearbyIDNString;
        [self GetPostAllData];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NearbyRecommendationsIDN"];
    }
    
    
    

    

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_SHOW" object:nil];
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //   MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 114);
                         // ShowbarView.frame = CGRectMake(0, 0, screenWidth, 64);
                         ShowDownBarView.frame = CGRectMake(0, screenHeight - 110, screenWidth, 60);
                         self.leveyTabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self presentViewController:ListingDetail animated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)GetPostID:(NSString *)PostID{
    DataUrl = [[UrlDataClass alloc]init];
    GetPostID = PostID;
    NSLog(@"GetPostID is %@",GetPostID);
    [self GetPostAllData];
}
-(void)GetPostAllData{
   // [spinnerView startAnimating];
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //    NSLog(@"theRequest === %@",theRequest);
    //    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetPostAllData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetPostAllData start];
    
    
    if( theConnection_GetPostAllData ){
        webData = [NSMutableData data];
    }
}
-(void)GetAllUserLikeData{
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,GetPostID];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllUserlikes = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllUserlikes start];
    
    
    if( theConnection_GetAllUserlikes ){
        webData = [NSMutableData data];
    }
}
-(void)GetAllCommentData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/%@/comments?token=%@",DataUrl.GetComment_URl,GetPostID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //    NSLog(@"theRequest === %@",theRequest);
    //    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    
    theConnection_GetAllComment = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllComment start];
    
    
    if( theConnection_GetAllComment ){
        webData = [NSMutableData data];
    }
}

-(void)GetNearbyPostData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/nearbyposts?token=%@",DataUrl.GetNearbyPost_Url,GetPostID,GetExpertToken];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:postBack];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData                                         timeoutInterval:30];
    NSLog(@"theRequest === %@",theRequest);
    theConnection_NearbyPost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_NearbyPost start];
    
    
    if( theConnection_NearbyPost ){
        webData = [NSMutableData data];
    }
}

-(void)GetCollectionSuggestionsData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/collect_suggestions?offset=1&limit=3&token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"Post Detail GetCollectionSuggestionsData check postBack URL ==== %@",postBack);
    
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_CollectionSuggestion = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CollectionSuggestion start];
    if( theConnection_CollectionSuggestion ){
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

   // [spinnerView stopAnimating];
   // [spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetPostAllData) {
        
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"GetPostAllData return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Feed Json = %@",res);
        
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
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                captionArray = [[NSMutableArray alloc]init];
                UrlArray = [[NSMutableArray alloc]init];
                PhotoIDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in PhotoData) {
                    NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"caption"]];
                    NSLog(@"captionata is %@",caption);
                    [captionArray addObject:caption];
                    
                    NSString *photoid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"photo_id"]];
                    NSLog(@"photoid is %@",photoid);
                    [PhotoIDArray addObject:photoid];
                    
                    NSDictionary *UserInfoData = [dict valueForKey:@"l"];
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                    NSLog(@"url is %@",url);
                    [UrlArray addObject:url];
                }
                
                GetPlaceName = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"place_name"]];
                GetPlaceFormattedAddress = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"place_formatted_address"]];
                GetLink = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"link"]];
                totalCommentCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_comments"]];
                TotalLikeCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_like"]];
                GetPostTime = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"updated_at"]];
                GetLikeCheck = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"like"]];
                GetCollectCheck = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"collect"]];
                PhotoCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"photos_count"]];
                ViewCountString = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"view_count"]];
                TotalCollectionCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"collection_count"]];
                GetTags = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"tags"]];
                GetSeetishopID = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"seetishop_id"]];
                
                NSLog(@"TotalCollectionCount is %@",TotalCollectionCount);
                NSLog(@"GetTags is %@",GetTags);
                
                
                if ([GetSeetishopID length] == 0 || [GetSeetishopID isEqualToString:@""] || [GetSeetishopID isEqualToString:@"(null)"]) {
                
                }else{
                
                    NSDictionary *SeetishopInfo = [GetAllData valueForKey:@"seetishop_info"];
                    GetSeetishopName = [[NSString alloc]initWithFormat:@"%@",[SeetishopInfo objectForKey:@"name"]];
                    NSDictionary *SeetishopLocation = [SeetishopInfo valueForKey:@"location"];
                    GetSeetishopAddress = [[NSString alloc]initWithFormat:@"%@",[SeetishopLocation objectForKey:@"formatted_address"]];
                    GetSeetishopImage = [[NSString alloc]initWithFormat:@"%@",[SeetishopInfo objectForKey:@"profile_photo"]];
                }
                
                NSLog(@"GetSeetishopID is %@",GetSeetishopID);
                NSLog(@"GetSeetishopName is %@",GetSeetishopName);
                NSLog(@"GetSeetishopAddress is %@",GetSeetishopAddress);
                NSLog(@"GetSeetishopImage is %@",GetSeetishopImage);

                
                
                if ([GetLikeCheck isEqualToString:@"0"]) {
                    [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
                   // [LikeButton setTitle:CustomLocalisedString(@"Likes", nil) forState:UIControlStateNormal];
                    [LikeButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
                }else{
                    ShowTotalLikeCount.textColor = [UIColor redColor];
                    [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
                   // [LikeButton setTitle:CustomLocalisedString(@"Likes", nil) forState:UIControlStateNormal];
                    [LikeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                
                if ([GetCollectCheck isEqualToString:@"0"]) {
                    [AllCollectButton setImage:[UIImage imageNamed:LocalisedString(@"CollectBtn.png")] forState:UIControlStateNormal];
                    [AllCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateSelected];
                }else{
                    [AllCollectButton setImage:[UIImage imageNamed:@"CollectedBtn.png"] forState:UIControlStateNormal];
                }
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormat dateFromString:GetPostTime];
                NSLog(@"datedata is %@",date);
                
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"yyyy-MM-dd"];
                // NSDate *startDate = [f dateFromString:start];
                NSDate *now = [NSDate date];
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                    fromDate:date
                                                                      toDate:now
                                                                     options:0];
                
                NSString *CheckString = [[NSString alloc]initWithFormat:@"%ld",(long)[components day]];
                if ([CheckString isEqualToString:@"0"]) {
                    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:date];
                    double secondsInAnHour = 3600;
                    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
                    // NSLog(@"%ld", [components day]);
                    NSLog(@"%ld",(long)hoursBetweenDates);
                    NSString *CheckString = [[NSString alloc]initWithFormat:@"%ldh",(long)hoursBetweenDates];
                    GetPostTime = CheckString;
                }else{
                    NSString *CheckString_ = [[NSString alloc]initWithFormat:@"%@d",CheckString];
                    GetPostTime = CheckString_;
                }
 
                NSDictionary *LocationData = [GetAllData valueForKey:@"location"];
                GetLat = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"lat"]];
                GetLng = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"lng"]];
                GetContactNo = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"contact_no"]];
                GetlocationType = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"type"]];
                GetLocationReference = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"reference"]];
                GetLocationPlaceId = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"place_id"]];
                
                NSDictionary *AddressData = [LocationData valueForKey:@"address_components"];
                GetLocationRoute = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"route"]];
                GetLocationLocality = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"locality"]];
                GetLocationAdministrative_Area_Level_1 = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"administrative_area_level_1"]];
                GetLocationPostalCode = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"postal_code"]];
                GetLocationCountry = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"country"]];
                
                
                
                
                NSDictionary *ExpenseData = [LocationData valueForKey:@"expense"];
                GetExpense = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"expense"]];
                    if ([ExpenseData count] == 0 || ExpenseData == nil || [ExpenseData isEqual:[NSNull null]]) {
                        GetExpense = @"";
                        GetExpense_Code = @"";
                        GetExpense_RealData = @"";
                        GetExpense_Show = @"";
                    }else{
                        NSString *TempPrice;
                        NSString *TempPriceCode;
                        NSString *CheckCode001 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"840"]];
                        NSString *CheckCode002 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"458"]];
                        NSString *CheckCode003 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"702"]];
                        NSString *CheckCode004 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"764"]];
                        NSString *CheckCode005 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"360"]];
                        NSString *CheckCode006 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"901"]];
                        NSString *CheckCode007 = [[NSString alloc]initWithFormat:@"%@",[ExpenseData objectForKey:@"608"]];
                        if ([CheckCode001 length] == 0 || CheckCode001 == nil || [CheckCode001 isEqualToString:@"(null)"]) {
                            if ([CheckCode002 length] == 0 || CheckCode002 == nil || [CheckCode002 isEqualToString:@"(null)"]) {
                                if ([CheckCode003 length] == 0 || CheckCode003 == nil || [CheckCode003 isEqualToString:@"(null)"]) {
                                    if ([CheckCode004 length] == 0 || CheckCode004 == nil || [CheckCode004 isEqualToString:@"(null)"]) {
                                        if ([CheckCode005 length] == 0 || CheckCode005 == nil || [CheckCode005 isEqualToString:@"(null)"]) {
                                            if ([CheckCode006 length] == 0 || CheckCode006 == nil || [CheckCode006 isEqualToString:@"(null)"]) {
                                                if ([CheckCode007 length] == 0 || CheckCode007 == nil || [CheckCode007 isEqualToString:@"(null)"]) {
                                                    //GetExpense = @"";
                                                    if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                                        TempPrice = @"";
                                                    }
                                                    GetExpense = [[NSString alloc]initWithFormat:@"USD %@",TempPrice];
                                                    GetExpense_Code = @"840";
                                                    GetExpense_RealData = CheckCode001;
                                                    GetExpense_Show = @"USD";
                                                }else{
                                                    TempPrice = CheckCode007;
                                                    if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                                        TempPrice = @"";
                                                    }
                                                    TempPriceCode = @"608";
                                                    if ([TempPriceCode isEqualToString:@"608"]) {
                                                        //PHP
                                                        GetExpense = [[NSString alloc]initWithFormat:@"PHP %@",TempPrice];
                                                        GetExpense_Code = TempPriceCode;
                                                        GetExpense_RealData = TempPrice;
                                                        GetExpense_Show = @"PHP";
                                                    }
                                                }
                                            }else{
                                                TempPrice = CheckCode006;
                                                if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                                    TempPrice = @"";
                                                }
                                                TempPriceCode = @"901";
                                                if ([TempPriceCode isEqualToString:@"901"]) {
                                                    //TWD
                                                    GetExpense = [[NSString alloc]initWithFormat:@"TWD %@",TempPrice];
                                                    GetExpense_Code = TempPriceCode;
                                                    GetExpense_RealData = TempPrice;
                                                    GetExpense_Show = @"TWD";
                                                }
                                            }
                                        }else{
                                            TempPrice = CheckCode005;
                                            if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                                TempPrice = @"";
                                            }
                                            TempPriceCode = @"360";
                                            if ([TempPriceCode isEqualToString:@"360"]) {
                                                //IDR
                                                GetExpense = [[NSString alloc]initWithFormat:@"IDR %@",TempPrice];
                                                GetExpense_Code = TempPriceCode;
                                                GetExpense_RealData = TempPrice;
                                                GetExpense_Show = @"IDR";
                                            }
                                        }
                                    }else{
                                        TempPrice = CheckCode004;
                                        if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                            TempPrice = @"";
                                        }
                                        TempPriceCode = @"764";
                                        if ([TempPriceCode isEqualToString:@"764"]) {
                                            //THB
                                            GetExpense = [[NSString alloc]initWithFormat:@"THB %@",TempPrice];
                                            GetExpense_Code = TempPriceCode;
                                            GetExpense_RealData = TempPrice;
                                            GetExpense_Show = @"THB";
                                        }
                                    }
                                }else{
                                    TempPrice = CheckCode003;
                                    if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                        TempPrice = @"";
                                    }
                                    TempPriceCode = @"702";
                                    if ([TempPriceCode isEqualToString:@"702"]) {
                                        //SGD
                                        GetExpense = [[NSString alloc]initWithFormat:@"SGD %@",TempPrice];
                                        GetExpense_Code = TempPriceCode;
                                        GetExpense_RealData = TempPrice;
                                        GetExpense_Show = @"SGD";
                                    }
                                }
                            }else{
                                TempPrice = CheckCode002;
                                if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                    TempPrice = @"";
                                }
                                TempPriceCode = @"458";
                                if ([TempPriceCode isEqualToString:@"458"]) {
                                    //MYR
                                    GetExpense = [[NSString alloc]initWithFormat:@"MYR %@",TempPrice];
                                    GetExpense_Code = TempPriceCode;
                                    GetExpense_RealData = TempPrice;
                                    GetExpense_Show = @"MYR";
                                }
                            }
                            
                        }else{
                            TempPrice = CheckCode001;
                            if ([TempPrice isEqualToString:@"(null)"] || [TempPrice isEqualToString:@""] || TempPrice == nil) {
                                TempPrice = @"";
                            }
                            TempPriceCode = @"840";
                            if ([TempPriceCode isEqualToString:@"840"]) {
                                //USD
                                GetExpense = [[NSString alloc]initWithFormat:@"USD %@",TempPrice];
                            }
                            
                        }
                    }
                NSLog(@"Final show GetExpense is %@",GetExpense);
        
                GetPlaceLink = [[NSString alloc]initWithFormat:@"%@",[LocationData objectForKey:@"link"]];
                
                
                NSDictionary *OpeningHourData = [LocationData valueForKey:@"opening_hours"];
                GetOpenNow = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData objectForKey:@"open_now"]];
                GetPeriods = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData objectForKey:@"period_text"]];
                NSLog(@"GetOpenNow is %@",GetOpenNow);
                NSLog(@"GetPeriods is %@",GetPeriods);
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                NSLog(@"titleData is %@",titleData);
                NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                NSLog(@"messageData is %@",messageData);
                
                if (titleData == NULL || [ titleData count ] == 0) {
                    GetTitle = @"";
                }else{
                    ChineseTitle = [[NSString alloc]initWithFormat:@"%@",[titleData objectForKey:@"530b0aa16424400c76000002"]];
                    EngTitle = [[NSString alloc]initWithFormat:@"%@",[titleData objectForKey:@"530b0ab26424400c76000003"]];
                    ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[titleData objectForKey:@"544481503efa3ff1588b4567"]];
                    IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[titleData objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[titleData objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    NSLog(@"ChineseTitle is %@",ChineseTitle);
                    NSLog(@"EngTitle is %@",EngTitle);
                    NSLog(@"ThaiTitle is %@",ThaiTitle);
                    NSLog(@"IndonesianTitle is %@",IndonesianTitle);
                    NSLog(@"PhilippinesTitle is %@",PhilippinesTitle);
                      if ([EngTitle length] == 0 || EngTitle == nil || [EngTitle isEqualToString:@"(null)"]) {
                         if ([ChineseTitle length] == 0 || ChineseTitle == nil || [ChineseTitle isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                    }else{
                                        GetTitle = PhilippinesTitle;
                                        GetLang = @"PH";
                                        [LanguageButton setImage:[UIImage imageNamed:@"LanguagePh.png"] forState:UIControlStateNormal];
                                    }
                                }else{
                                    GetTitle = IndonesianTitle;
                                    GetLang = @"IN";
                                    [LanguageButton setImage:[UIImage imageNamed:@"LanguageInd.png"] forState:UIControlStateNormal];
                                }
                            }else{
                                GetTitle = ThaiTitle;
                                GetLang = @"TH";
                                [LanguageButton setImage:[UIImage imageNamed:@"LanguageTh.png"] forState:UIControlStateNormal];
                            }
                        }else{

                            GetTitle = ChineseTitle;
                            GetLang = @"CN";
                            [LanguageButton setImage:[UIImage imageNamed:@"LanguageChi.png"] forState:UIControlStateNormal];
                        }
                        
                    }else{
                        GetTitle = EngTitle;
                        GetLang = @"EN";
                        [LanguageButton setImage:[UIImage imageNamed:@"LanguageEng.png"] forState:UIControlStateNormal];
                    }
                }
                
                
                if (messageData == NULL || [ messageData count ] == 0) {
                    GetMessage = @"";
                }else{
                    ChineseMessage = [[NSString alloc]initWithFormat:@"%@",[messageData objectForKey:@"530b0aa16424400c76000002"]];
                    EndMessage = [[NSString alloc]initWithFormat:@"%@",[messageData objectForKey:@"530b0ab26424400c76000003"]];
                    ThaiMessage = [[NSString alloc]initWithFormat:@"%@",[messageData objectForKey:@"544481503efa3ff1588b4567"]];
                    IndonesianMessage = [[NSString alloc]initWithFormat:@"%@",[messageData objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    PhilippinesMessage = [[NSString alloc]initWithFormat:@"%@",[messageData objectForKey:@"539fbb273efa3fde3f8b4567"]];
                     if ([EndMessage length] == 0 || EndMessage == nil || [EndMessage isEqualToString:@"(null)"]) {
                         if ([ChineseMessage length] == 0 || ChineseMessage == nil || [ChineseMessage isEqualToString:@"(null)"]) {
                             if ([ThaiMessage length] == 0 || ThaiMessage == nil || [ThaiMessage isEqualToString:@"(null)"]) {
                                if ([IndonesianMessage length] == 0 || IndonesianMessage == nil || [IndonesianMessage isEqualToString:@"(null)"]) {
                                    if ([PhilippinesMessage length] == 0 || PhilippinesMessage == nil || [PhilippinesMessage isEqualToString:@"(null)"]) {
                                    }else{
                                        GetMessage = PhilippinesMessage;
                                    }
                                }else{
                                    GetMessage = IndonesianMessage;
                                }
                            }else{
                                GetMessage = ThaiMessage;
                            }
                            
                        }else{
                            
                            GetMessage = ChineseMessage;
                        }
                        
                    }else{
                        GetMessage = EndMessage;
                    }
                }
                
                CountLanguageArray = [[NSMutableArray alloc]init];
                
                if ([EngTitle isEqualToString:@"(null)"] || [EngTitle length] == 0 ) {
                    if ([EndMessage isEqualToString:@"(null)"] || [EndMessage length] == 0) {
                        
                    }else{
                        CountLanguage++;
                        [CountLanguageArray addObject:@"1"];
                    }
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"1"];
                    //  NSLog(@"EngTitle 2");
                }
                if ([ChineseTitle isEqualToString:@"(null)"] || [ChineseTitle length] == 0) {
                    //   CountLanguage = 0;
                    if ([ChineseMessage isEqualToString:@"(null)"] || [ChineseMessage length] == 0) {
                        
                    }else{
                        CountLanguage++;
                        [CountLanguageArray addObject:@"2"];
                    }
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"2"];
                }
                if ([ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle length] == 0) {
                    //   CountLanguage = 0;
                    if ([ThaiMessage isEqualToString:@"(null)"] || [ThaiMessage length] == 0) {
                        
                    }else{
                        CountLanguage++;
                        [CountLanguageArray addObject:@"3"];
                    }
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"3"];
                }
                if ([IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle length] == 0) {
                    //   CountLanguage = 0;
                    if ([IndonesianMessage isEqualToString:@"(null)"] || [IndonesianMessage length] == 0) {
                        
                    }else{
                        CountLanguage++;
                        [CountLanguageArray addObject:@"4"];
                    }
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"4"];
                }
                if ([PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle length] == 0) {
                    //  CountLanguage = 0;
                    if ([PhilippinesMessage isEqualToString:@"(null)"] || [PhilippinesMessage length] == 0) {
                        
                    }else{
                        CountLanguage++;
                        [CountLanguageArray addObject:@"5"];
                    }
                }else{
                    CountLanguage++;
                    [CountLanguageArray addObject:@"5"];
                }
                NSLog(@"CountLanguage is %li",(long)CountLanguage);
                
                if ([GetTitle length] == 0 || [GetTitle isEqualToString:@""] || [GetTitle isEqualToString:@"(null)"]) {
                    LanguageButton.hidden = YES;
                }else{
                    if (CountLanguage == 1) {
                        LanguageButton.hidden = YES;
                        CheckLanguagedata = 1;
                    }else{
                        LanguageButton.hidden = NO;
                        ClickCount = 0;
                        CheckLanguagedata = 0;
                    }
                }
                
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                NSDictionary *languagesData = [GetAllData valueForKey:@"languages"];
                NSLog(@"languagesData is %@",languagesData);
                TempGetLanguageArray = [[NSMutableArray alloc]init];
                for (NSDictionary* dict in languagesData)
                {
                    [TempGetLanguageArray addObject:dict];
                }
                
//                for (int i = 0; i < [TempGetLanguageArray count]; i++) {
//                    NSString *GetLanguages = [[NSString alloc]initWithFormat:@"%@",[TempGetLanguageArray objectAtIndex:i]];
//                    
//                    
//                    if ([GetLanguages isEqualToString:@"530b0ab26424400c76000003"]) {
//                        ShowLanguageType = @"English";
//                    }else if ([GetLanguages isEqualToString:@"530b0aa16424400c76000002"]){
//                        ShowLanguageType = @"简体中文";
//                    }else if ([GetLanguages isEqualToString:@"544481503efa3ff1588b4567"]){
//                        ShowLanguageType = @"ภาษาไทย";
//                    }else if ([GetLanguages isEqualToString:@"53672e863efa3f857f8b4ed2"]){
//                        ShowLanguageType = @"Bahasa Indonesia";
//                    }else if ([GetLanguages isEqualToString:@"539fbb273efa3fde3f8b4567"]){
//                        ShowLanguageType = @"Filipino";
//                    }
//                    
//                    
//                    if ([GetLanguages isEqualToString:@"530b0ab26424400c76000003"]) {
//                    }else{
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        //  [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
//                        NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]initWithArray:[defaults valueForKey:@"GetUserSelectLanguagesArray"]];
//                        NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
//                        if (CountLanguage == 1) {
//                            NSLog(@"only one lang");
//                            if ([GetUserSelectLanguagesArray count] == 2) {
//                                NSLog(@"2 language");
//                                NSString *TempLanguage1 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:0]];
//                                NSString *TempLanguage2 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:1]];
//                                
//                                if ([GetLanguages isEqualToString:TempLanguage1]) {
//                                    NSLog(@"in here 1111");
//                                    ShowLanguageTranslationView.hidden = YES;
//                                }else if([GetLanguages isEqualToString:TempLanguage2]){
//                                    NSLog(@"in here 2222");
//                                    ShowLanguageTranslationView.hidden = YES;
//                                }else{
//                                    NSLog(@"in here 3333");
//                                    ShowGoogleTranslate = YES;
//                                    
//                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                    NSString *CheckDontShowAgain = [defaults objectForKey:@"DontShowAgainTranslate"];
//                                    if ([CheckDontShowAgain isEqualToString:@"DontShowAgain"]) {
//                                        ShowLanguageTranslationView.hidden = YES;
//                                    }else{
//                                        ShowLanguageTranslationView.hidden = NO;
//                                    }
//                                    // ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
//                                    NewLanguageButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
//                                    DisplayButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
//                                    NewLanguageButton.hidden = NO;
//                                    [ShowbarView addSubview:NewLanguageButton];
//                                    CheckLanguagedata = 2;
//                                }
//                                
//                            }else{
//                                NSLog(@"1 language");
//                                NSString *TempLanguage1 = [[NSString alloc]initWithFormat:@"%@",[GetUserSelectLanguagesArray objectAtIndex:0]];
//                                if ([GetLanguages isEqualToString:TempLanguage1]) {
//                                    ShowLanguageTranslationView.hidden = YES;
//                                }else{
//                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                    NSString *CheckDontShowAgain = [defaults objectForKey:@"DontShowAgainTranslate"];
//                                    if ([CheckDontShowAgain isEqualToString:@"DontShowAgain"]) {
//                                        ShowLanguageTranslationView.hidden = YES;
//                                    }else{
//                                        ShowLanguageTranslationView.hidden = NO;
//                                    }
//                                    ShowGoogleTranslate = YES;
//                                    //    ShowTopTitle.frame = CGRectMake(40, 20, 204, 44);
//                                    NewLanguageButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
//                                    DisplayButton.frame = CGRectMake(screenWidth - 124 - 15, 26, 55, 33);
//                                    NewLanguageButton.hidden = NO;
//                                    [ShowbarView addSubview:NewLanguageButton];
//                                    CheckLanguagedata = 2;
//                                }
//                            }
//                        }
//                    }
//                }
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]initWithArray:[defaults valueForKey:@"GetUserSelectLanguagesArray"]];
//                NSString *GetSystemLanguageCheck = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
//                NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
//                NSLog(@"GetSystemLanguageCheck is %@",GetSystemLanguageCheck);
                
                //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
                NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
                NSString *SystemLangaugeCode;
                if ([GetSystemLanguage isEqualToString:@"English"]) {
                    SystemLangaugeCode = @"530b0ab26424400c76000003";
                }else if([GetSystemLanguage isEqualToString:@"繁體中文"] || [GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
                    SystemLangaugeCode = @"530d5e9b642440d128000018";
                }else if([GetSystemLanguage isEqualToString:@"简体中文"] || [GetSystemLanguage isEqualToString:@"Simplified Chinese"] || [GetSystemLanguage isEqualToString:@"中文"]){
                    SystemLangaugeCode = @"530b0aa16424400c76000002";
                }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
                     SystemLangaugeCode = @"53672e863efa3f857f8b4ed2";
                }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
                     SystemLangaugeCode = @"539fbb273efa3fde3f8b4567";
                }else if([GetSystemLanguage isEqualToString:@"ภาษาไทย"] || [GetSystemLanguage isEqualToString:@"Thai"]){
                     SystemLangaugeCode = @"544481503efa3ff1588b4567";
                }else{
                     SystemLangaugeCode = @"530b0ab26424400c76000003";
                }
                
                if ([TempGetLanguageArray count] > 2) {
                    CheckLanguagedata = 3;
                }else{
                    for (int i = 0; i < [TempGetLanguageArray count]; i++) {
                        NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[TempGetLanguageArray objectAtIndex:i]];
                        
                        if ([GetData isEqualToString:SystemLangaugeCode]) {
                            break;
                        }else{
                            CheckLanguagedata = 3;
                        }
                    }
                }
                

                
                
                
                NSDictionary *CategoryData = [GetAllData valueForKey:@"category_meta"];
                //NSLog(@"CategoryData is %@",CategoryData);
                GetCategoryIDArray = [[NSMutableArray alloc]init];
                GetCategoryNameArray = [[NSMutableArray alloc]init];
                GetCategoryBackgroundColorArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in CategoryData) {
                    NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
                    [GetCategoryIDArray addObject:Getid];
                    NSString *background_color = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"background_color"]];
                    [GetCategoryBackgroundColorArray addObject:background_color];
                    
                    NSDictionary *CategoryNameData = [dict valueForKey:@"single_line"];
                    NSString *name;
                    if ([GetSystemLanguage isEqualToString:@"English"]) {
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"530b0ab26424400c76000003"]];
                    }else if([GetSystemLanguage isEqualToString:@"繁體中文"] || [GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"530d5e9b642440d128000018"]];
                    }else if([GetSystemLanguage isEqualToString:@"简体中文"] || [GetSystemLanguage isEqualToString:@"Simplified Chinese"] || [GetSystemLanguage isEqualToString:@"中文"]){
                       name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"530b0aa16424400c76000002"]];
                    }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    }else if([GetSystemLanguage isEqualToString:@"ภาษาไทย"] || [GetSystemLanguage isEqualToString:@"Thai"]){
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"544481503efa3ff1588b4567"]];
                    }else{
                        name = [[NSString alloc]initWithFormat:@"%@",[CategoryNameData objectForKey:@"530b0ab26424400c76000003"]];
                    }
                    
                     [GetCategoryNameArray addObject:name ];
                }
                
                NSLog(@"GetCategoryNameArray is %@",GetCategoryNameArray);
                
                
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
                GetPostUserName = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"name"]];
                GetPostName = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"username"]];
                GetUserUid = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"uid"]];
                GetFollowing = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"following"]];
                GetUserProfileUrl = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"profile_photo"]];
                
                NSLog(@"GetPostUserName is %@",GetPostUserName);
                NSLog(@"GetUserUid is %@",GetUserUid);
                NSLog(@"GetFollowing is %@",GetFollowing);
                NSLog(@"GetUserProfileUrl is %@",GetUserProfileUrl);
                
                NSLog(@"GetCategoryIDArray is %@",GetCategoryIDArray);
                NSLog(@"GetCategoryBackgroundColorArray is %@",GetCategoryBackgroundColorArray);
                NSLog(@"GetCategoryNameArray is %@",GetCategoryNameArray);
                
                NSLog(@"GetPlaceName is %@",GetPlaceName);
                NSLog(@"GetPlaceFormattedAddress is %@",GetPlaceFormattedAddress);
                NSLog(@"GetLink is %@",GetLink);
                
                NSLog(@"GetLat is %@",GetLat);
                NSLog(@"GetLng is %@",GetLng);
                NSLog(@"GetContactNo is %@",GetContactNo);
                NSLog(@"GetExpense is %@",GetExpense);
                NSLog(@"GetPlaceLink is %@",GetPlaceLink);
                
//                NSLog(@"GetOpeningHourOpen is %@",GetOpeningHourOpen);
                
//                if ([GetExpense isEqualToString:@"(\n)"]) {
//                    GetExpense = @"";
//                }else{
//                GetExpense = @"100";
//                }

               // ShowCategoryTop.text = GetPlaceName;
//                NSString * result = [GetCategoryNameArray componentsJoinedByString:@", "];
//                ShowCategoryTop.text = result;
            //    GetPlaceLink = @"facebook.com/abc";
            //    GetContactNo = @"0168409874";
                ShowTotalCommentCount.text = totalCommentCount;
                ShowTotalLikeCount.text = TotalLikeCount;
                
                
              //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *GetUsername = [defaults objectForKey:@"UserName"];
                if ([GetUsername isEqualToString:GetPostName]) {
                    //self
                    ShareButton.hidden = NO;
                    ShareIcon.hidden = NO;
                }else{
                    //other user
                    // ShareButton.frame = CGRectMake(screenWidth - 55, 0, 55, 64);
                    // ShareIcon.frame = CGRectMake(screenWidth - 22 - 15, 31, 22, 22);
                  //  ShareButton.hidden = YES;
                  //  ShareIcon.hidden = YES;
//                    LocationButton.frame = CGRectMake(screenWidth - 40 - 15, 20, 60, 44);
//                    LanguageButton.frame = CGRectMake(screenWidth - 85 - 15, 26, 55, 33);
//                    NewLanguageButton.frame = CGRectMake(screenWidth - 85 - 15, 26, 55, 33);
//                    DisplayButton.frame = CGRectMake(screenWidth - 85 - 15, 26, 55, 33);
//                    ShowTranslateOverlay.frame = CGRectMake(screenWidth - 85 - 20, 10, 60, 60);
//                    ShowTranslateOverlay.layer.cornerRadius = 30;

                }
                
                
                
                
                
                [self GetAllUserLikeData];
              //  [self InitView];
            }
        }
    }else if(connection == theConnection_GetAllUserlikes){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get likes return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);
            
            NSDictionary *UserInfoData_ = [GetAllData valueForKey:@"like_list"];
            NSLog(@"UserInfoData_ is %@",UserInfoData_);
            
            Like_UseruidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UserProfilePhotoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            Like_UsernameArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ count]];
            for (NSDictionary * dict in UserInfoData_) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [Like_UseruidArray addObject:uid];
                NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [Like_UserProfilePhotoArray addObject:photo];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [Like_UsernameArray addObject:username];
            }
        }
        NSLog(@"Like_UserProfilePhotoArray is %@",Like_UserProfilePhotoArray);
        if (CheckLikeInitView == YES) {
            [self InitView];
        }else{
            if ([totalCommentCount isEqualToString:@"0"]) {
                [self InitView];
            }else{
                [self GetAllCommentData];
            }
        }

        
        
    }else if(connection == theConnection_GetAllComment){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Comment return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Get all comment Json = %@",res);
    
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
        NSLog(@"GetAllData is %@",GetAllData);
        
        NSString *countString = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"count"]];
        NSLog(@"countString is %@",countString);
        NSLog(@"ShowTotalCommentCount.text is %@",ShowTotalCommentCount.text);
        
        
        if ([MessageCount isEqualToString:countString]) {
            
        }else{
            MessageCount = countString;
            ShowTotalCommentCount.text = MessageCount;
            
            NSArray *GetCommentData = (NSArray *)[GetAllData valueForKey:@"comments"];
            NSLog(@"GetCommentData is %@",GetCommentData);
            
            CommentIDArray = [[NSMutableArray alloc] initWithCapacity:[GetCommentData count]];
            PostIDArray = [[NSMutableArray alloc] initWithCapacity:[GetCommentData count]];
            MessageArray = [[NSMutableArray alloc] initWithCapacity:[GetCommentData count]];
            for (NSDictionary * dict in GetCommentData) {
                NSString *comment_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"comment_id"]];
                [CommentIDArray addObject:comment_id];
                NSString *post_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                [PostIDArray addObject:post_id];
                NSString *message = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"message"]];
                [MessageArray addObject:message];
            }
            
            NSDictionary *UserInfoData_ = [GetCommentData valueForKey:@"author_info"];
            NSLog(@"UserInfoData_ is %@",UserInfoData_);
            
            User_Comment_uidArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            User_Comment_nameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            User_Comment_usernameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            User_Comment_photoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData_ count]];
            for (NSDictionary * dict in UserInfoData_) {
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [User_Comment_uidArray addObject:uid];
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [User_Comment_nameArray addObject:name];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [User_Comment_usernameArray addObject:username];
                NSString *photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [User_Comment_photoArray addObject:photo];
            }
            
            [self InitView];
        }
        
        
    }else if(connection == theConnection_likes){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Send post like return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_LIKES object:nil];

            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);
            
            NSString *likeString = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"like"]];
            NSLog(@"likeString is %@",likeString);
            
            NSString *likeStringCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_like"]];
            NSLog(@"likeStringCount is %@",likeStringCount);
            
            ShowTotalLikeCount.text = likeStringCount;
            TotalLikeCount = likeStringCount;
            if ([likeString isEqualToString:@"1"]) {
                [self GetAllUserLikeData];

            }else{
                [self GetAllUserLikeData];
                
            }
            // [self InitView];
        }
    }else if(connection == theConnection_GetTranslate){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Translate return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSLog(@"GetAllData is %@",GetAllData);
            NSDictionary *GetAlltranslation = [GetAllData valueForKey:@"translations"];
            NSLog(@"GetAlltranslation is %@",GetAlltranslation);
//            NSDictionary *GetAllENData = [GetAlltranslation valueForKey:@"530b0ab26424400c76000003"];
//            NSLog(@"GetAllENData is %@",GetAllENData);
//            
//            
//            if ([GetAllENData count] == 0) {
//                GetENMessageString = GetMessage;
//                GetENTItleStirng = GetTitle;
//            }else{
//                GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[GetAllENData objectForKey:@"message"]];
//                NSLog(@"GetENMessageString is %@",GetENMessageString);
//                
//                GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[GetAllENData objectForKey:@"title"]];
//                NSLog(@"GetENTItleStirng is %@",GetENTItleStirng);
//            }
            NSDictionary *EnTranslation = [GetAlltranslation valueForKey:@"530b0ab26424400c76000003"];
            NSDictionary *CnTranslation = [GetAlltranslation valueForKey:@"530b0aa16424400c76000002"];
            NSDictionary *ThaiTranslation = [GetAlltranslation valueForKey:@"544481503efa3ff1588b4567"];
            NSDictionary *IndonesianTranslation = [GetAlltranslation valueForKey:@"53672e863efa3f857f8b4ed2"];
            NSDictionary *PhilippinesTranslation = [GetAlltranslation valueForKey:@"539fbb273efa3fde3f8b4567"];
            if ([EnTranslation count] == 0 || EnTranslation == nil) {
                if ([CnTranslation count] == 0 || CnTranslation == nil) {
                    if ([ThaiTranslation count] == 0 || ThaiTranslation == nil) {
                        if ([IndonesianTranslation count] == 0 || IndonesianTranslation == nil) {
                            if ([PhilippinesTranslation count] == 0 || PhilippinesTranslation == nil) {
                                GetENMessageString = GetMessage;
                                GetENTItleStirng = GetTitle;

                            }else{
                                GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[PhilippinesTranslation objectForKey:@"message"]];
                                GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[PhilippinesTranslation objectForKey:@"title"]];
                                
                            }
                        }else{
                            GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[IndonesianTranslation objectForKey:@"message"]];
                            GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[IndonesianTranslation objectForKey:@"title"]];
                            
                        }
                    }else{
                        GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[ThaiTranslation objectForKey:@"message"]];
                        GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[ThaiTranslation objectForKey:@"title"]];
                    }
                }else{
                    GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[CnTranslation objectForKey:@"message"]];
                    GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[CnTranslation objectForKey:@"title"]];
                }
                
            }else{
                GetENMessageString = [[NSString alloc]initWithFormat:@"%@",[EnTranslation objectForKey:@"message"]];
                GetENTItleStirng = [[NSString alloc]initWithFormat:@"%@",[EnTranslation objectForKey:@"title"]];

                
            }
            
            CheckENTranslation = @"1";
            
            GetMessage = GetENMessageString;
            GetTitle = GetENTItleStirng;
            ShowMessage.text = GetMessage;
            ShowTitle.text = GetTitle;
            ShowLanguageTranslationView.hidden = YES;
            TestingUse = YES;
            [self InitView];
            
            [ShowActivity stopAnimating];
           // [spinnerView stopAnimating];
           // [spinnerView removeFromSuperview];
            [LoadingBlackBackground removeFromSuperview];
        }
        
    }else if(connection == theConnection_DeletePost){
        
        [ShowActivity stopAnimating];
        
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"delete post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"SelfDeletePost"];
            [defaults setObject:@"YES" forKey:@"SelfDeletePost_Profile"];
            [defaults setObject:@"" forKey:@"PostToDetail_like"];
            [defaults setObject:@"" forKey:@"PostToDetail_Collect"];
            [defaults setObject:@"" forKey:@"PostToDetail_IDN"];
            [defaults synchronize];
            
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            //[self presentViewController:ListingDetail animated:NO completion:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_POST object:nil];

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
            

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:GetCollectCheck forKey:@"PostToDetail_Collect"];
            [defaults synchronize];
            [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];
        }
    }else if(connection == theConnection_NearbyPost){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
      //  NSLog(@"Get Nearby Post return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       // NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            if ([GetAllData count] == 0) {
                
                MainScroll.contentSize = CGSizeMake(320, GetFinalHeight + 50);
            }else{
                DistanceArray_Nearby = [[NSMutableArray alloc]init];
                SearchDisplayNameArray_Nearby = [[NSMutableArray alloc]init];
                
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                for (NSDictionary * dict in locationData) {
                    NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                    [DistanceArray_Nearby addObject:formatted_address];
                    NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                    [SearchDisplayNameArray_Nearby addObject:SearchDisplayName];
                }
                
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                
                TitleArray_Nearby = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in titleData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                        [TitleArray_Nearby addObject:@""];
                    }else{
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                if ([ThaiTitle_Nearby length] == 0 || ThaiTitle_Nearby == nil || [ThaiTitle_Nearby isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle_Nearby length] == 0 || IndonesianTitle_Nearby == nil || [IndonesianTitle_Nearby isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle_Nearby length] == 0 || PhilippinesTitle_Nearby == nil || [PhilippinesTitle_Nearby isEqualToString:@"(null)"]) {
                                            [TitleArray_Nearby addObject:@""];
                                        }else{
                                            [TitleArray_Nearby addObject:PhilippinesTitle_Nearby];
                                            
                                        }
                                    }else{
                                        [TitleArray_Nearby addObject:IndonesianTitle_Nearby];
                                        
                                    }
                                }else{
                                    [TitleArray_Nearby addObject:ThaiTitle_Nearby];
                                }
                            }else{
                                [TitleArray_Nearby addObject:Title2];
                            }
                            
                        }else{
                            [TitleArray_Nearby addObject:Title1];
                            
                        }
                        
                    }
                    
                }
                NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                MessageArray_Nearby = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in messageData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                        [MessageArray_Nearby addObject:@""];

                    }else{
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle_Nearby = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                if ([ThaiTitle_Nearby length] == 0 || ThaiTitle_Nearby == nil || [ThaiTitle_Nearby isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle_Nearby length] == 0 || IndonesianTitle_Nearby == nil || [IndonesianTitle_Nearby isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle_Nearby length] == 0 || PhilippinesTitle_Nearby == nil || [PhilippinesTitle_Nearby isEqualToString:@"(null)"]) {
                                            [MessageArray_Nearby addObject:@""];
                                        }else{
                                            [MessageArray_Nearby addObject:PhilippinesTitle_Nearby];
                                            
                                        }
                                    }else{
                                        [MessageArray_Nearby addObject:IndonesianTitle_Nearby];
                                        
                                    }
                                }else{
                                    [MessageArray_Nearby addObject:ThaiTitle_Nearby];
                                }
                            }else{
                                [MessageArray_Nearby addObject:Title2];
                            }
                            
                        }else{
                            [MessageArray_Nearby addObject:Title1];
                            
                        }
                        
                    }
                    
                }
                
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
             //   NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                
                UserInfo_NameArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                UserInfo_UrlArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                UserInfo_IDArray_Nearby = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                for (NSDictionary * dict in UserInfoData) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                    [UserInfo_NameArray_Nearby addObject:username];
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                    [UserInfo_UrlArray_Nearby addObject:url];
                    NSString *userid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    [UserInfo_IDArray_Nearby addObject:userid];
                }

                
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                PhotoArray_Nearby = [[NSMutableArray alloc]init];
                
                for (NSDictionary * dict in PhotoData) {
                    NSMutableArray *UrlArray_ = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict_ in dict) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                        [UrlArray_ addObject:url];
                    }
                    NSString *result2 = [UrlArray_ componentsJoinedByString:@","];
                    [PhotoArray_Nearby addObject:result2];
                }
                
                PostIDArray_Nearby = [[NSMutableArray alloc]init];
                PlaceNameArray_Nearby = [[NSMutableArray alloc]init];
                SelfCheckLikeArray_Nearby = [[NSMutableArray alloc]init];
                TotalLikeArray_Nearby = [[NSMutableArray alloc]init];
                TotalCommentArray_Nearby = [[NSMutableArray alloc]init];
                SelfCheckCollectArray_Nearby = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetAllData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostIDArray_Nearby addObject:PlaceID];
                    NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [PlaceNameArray_Nearby addObject:PlaceName];
                    NSString *SelfCheck = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"like"]];
                    [SelfCheckLikeArray_Nearby addObject:SelfCheck];
                    NSString *total_like = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                    [TotalLikeArray_Nearby addObject:total_like];
                    NSString *total_comments = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                    [TotalCommentArray_Nearby addObject:total_comments];
                    NSString *SelfCollect = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collect"]];
                    [SelfCheckCollectArray_Nearby addObject:SelfCollect];
                }
                
                NSLog(@"PlaceNameArray_Nearby is %@",PlaceNameArray_Nearby);
                CheckNearbyPost = 1;
                [self InitNearbyPostView];
            
            }
            
            
        }else{

        }
        
    }else if(connection == theConnection_CollectionSuggestion){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Search Keyword return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"theConnection_GetSuggestedCollectionData Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        // NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            
            NSDictionary *AllData = [res valueForKey:@"data"];
   
            arrCollectionID = [[NSMutableArray alloc]init];
            arrTitle = [[NSMutableArray alloc]init];
            arrTotalCount = [[NSMutableArray alloc]init];
            arrImageData = [[NSMutableArray alloc]init];
            arrUsername = [[NSMutableArray alloc]init];
            arrUserImage = [[NSMutableArray alloc]init];
            arrUserID = [[NSMutableArray alloc]init];
            arrFollowing = [[NSMutableArray alloc]init];
     
            
            NSDictionary *GetResultData = [AllData valueForKey:@"collections"];
            
            for (NSDictionary * dict in GetResultData) {
                NSString *collectionid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_id"]];
                [arrCollectionID addObject:collectionid];
                NSString *getname = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [arrTitle addObject:getname];
                NSString *collectioncount = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_posts_count"]];
                [arrTotalCount addObject:collectioncount];
                NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                [arrFollowing addObject:following];
            }
            
            NSLog(@"arrTitle is %@",arrTitle);
            
            NSDictionary *GetUserData = [GetResultData valueForKey:@"user_info"];
            for (NSDictionary * dict in GetUserData) {
                NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [arrUsername addObject:Getusername];
                NSString *getUserImage = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [arrUserImage addObject:getUserImage];
                NSString *getuserid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [arrUserID addObject:getuserid];
            }
            
            NSLog(@"arrUsername is %@",arrUsername);
            
            
            NSDictionary *CollectionPhotoData = [GetResultData valueForKey:@"collection_posts"];
            
            NSDictionary *PhotoData = [CollectionPhotoData valueForKey:@"posts"];
            // NSMutableArray *FullUrlArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *TempUrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSArray *TempPhotoData = [dict_ valueForKey:@"photos"];
                    for (NSDictionary * dict_ in TempPhotoData) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData valueForKey:@"url"]];
                        
                        [TempUrlArray addObject:url];
                    }
                }
                NSString *resultImageUrl = [TempUrlArray componentsJoinedByString:@"^^^"];
                [arrImageData addObject:resultImageUrl];
            }
            
            //            NSString *resultImageUrl = [FullUrlArray componentsJoinedByString:@","];
            //            [arrImageData addObject:resultImageUrl];
            
            NSLog(@"arrImageData is %@",arrImageData);
        
        
        
        
        isThereAnyCollectionSuggestion = YES;
        [self InitCollectionSuggestionsView];
        }else{
        
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
        NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            if ([GetFollowing isEqualToString:@"0"]) {
                GetFollowing = @"1";
                [ShowFollowButton setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:204.0f/255.0f blue:101.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [ShowFollowButton setTitle:LocalisedString(@"Following_")  forState:UIControlStateNormal];
                [ShowFollowButton setImage:[UIImage imageNamed:@"ProfileFollowingIcon.png"] forState:UIControlStateNormal];
                [ShowFollowButton setBackgroundImage:[UIImage imageNamed:@"FollowingBtn.png"] forState:UIControlStateNormal];
            }else{
                GetFollowing = @"0";
                [ShowFollowButton setTitle:LocalisedString(@"Follow_") forState:UIControlStateNormal];
                [ShowFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [ShowFollowButton setImage:[UIImage imageNamed:@"ProfileFollowIcon.png"] forState:UIControlStateNormal];
                [ShowFollowButton setBackgroundImage:[UIImage imageNamed:@"FollowBtn.png"] forState:UIControlStateNormal];
            }
            
        }
    }
}

-(void)InitView{
    
  //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    for (UIView *subview in MImageScroll.subviews) {
        [subview removeFromSuperview];
    }
    
//    UIButton *HideButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [HideButton setTitle:@"" forState:UIControlStateNormal];
//    [HideButton setFrame:CGRectMake(0, 340, screenWidth, screenHeight)];
//    [HideButton setBackgroundColor:[UIColor clearColor]];
//    [HideButton addTarget:self action:@selector(HideButton:) forControlEvents:UIControlEventTouchUpInside];
//    [MainScroll addSubview:HideButton];
    
    
    [MainScroll addSubview:MImageScroll];
    //[MainScroll addSubview:PageControlOn];
    
    
    UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
    ShowOverlayImg.image = [UIImage imageNamed:@"PostOverlay.png"];
    ShowOverlayImg.frame = CGRectMake(0, -20, screenWidth , 360);
    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
    ShowOverlayImg.layer.masksToBounds = YES;
    //ShowOverlayImg.layer.cornerRadius = 5;
    [MainScroll addSubview:ShowOverlayImg];
    
    [MainScroll addSubview:ShowImageCount];
    
    for (int i = 0 ; i < [UrlArray count]; i++) {
        ImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0+ i *screenWidth, 0, screenWidth, 360)];
        ImageScroll.delegate = self;
        //  ImageScroll.tag = 50000 + j;
        ImageScroll.minimumZoomScale = 1;
        ImageScroll.maximumZoomScale = 4;
        [ImageScroll setScrollEnabled:YES];
        [ImageScroll setNeedsDisplay];
        [MImageScroll addSubview:ImageScroll];
        
//        UIImageView *PostShade = [[UIImageView alloc]init];
//        PostShade.frame = CGRectMake(0+ i *screenWidth, 308, screenWidth, 96);
//        PostShade.image = [UIImage imageNamed:@"PostShade2.png"];
//        [MImageScroll addSubview:PostShade];
        
        ShowImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 360)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UrlArray objectAtIndex:i]];
        NSLog(@"FullImagesURL ====== %@",FullImagesURL);
        //  NSURL *url = [NSURL URLWithString:FullImagesURL];
        NSURL *theURL = [NSURL URLWithString:FullImagesURL];
        ShowImage.imageURL = theURL;
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.backgroundColor = [UIColor clearColor];
        ShowImage.tag = 6000000;
        [ImageScroll addSubview:ShowImage];
        

        
        UIButton *ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        [ImageButton setFrame:CGRectMake(0, 64, screenWidth, 340)];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [ImageScroll addSubview:ImageButton];

        
        NSLog(@"captionArray is %@",captionArray);
        
        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[captionArray objectAtIndex:i]];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
        UILabel *ShowCaptionText = [[UILabel alloc]init];
      //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
        ShowCaptionText.numberOfLines = 0;
        ShowCaptionText.textColor = [UIColor whiteColor];
       // ShowCaptionText.text = [captionArray objectAtIndex:i];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
        NSString *str = TempGetStirngMessage;
        NSError *error = nil;
        
        //I Use regex to detect the pattern I want to change color
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:0];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
        }
        
        [ShowCaptionText setAttributedText:string];
        
        ShowCaptionText.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:15];
        ShowCaptionText.textAlignment = NSTextAlignmentCenter;
        ShowCaptionText.backgroundColor = [UIColor clearColor];
        ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 301 - [ShowCaptionText sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height , screenWidth - 30,[ShowCaptionText sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
        

       // [MImageScroll addSubview:ShowCaptionText];
    }
    //NSLog(@"start draw title");
    
    UIImageView *ShowMoveIcon = [[UIImageView alloc]init];
    ShowMoveIcon.image = [UIImage imageNamed:@"FullScreenIcon.png"];
    ShowMoveIcon.frame = CGRectMake(screenWidth - 45, 290, 45, 45);
    [MainScroll addSubview:ShowMoveIcon];
    
    NSInteger productcount = [UrlArray count];
    MImageScroll.contentSize = CGSizeMake(productcount * screenWidth, 340);
    
    //PageControlOn.currentPage = 0;
    //PageControlOn.numberOfPages = productcount;
    NSString *TempCount = [[NSString alloc]initWithFormat:@"1 / %li",(long)productcount];
    ImageCount = productcount;
    ShowImageCount.text = TempCount;

    int GetHeightCheck = 363;
    
    if (CheckLanguagedata == 3) {
        UIButton *TanslateButton = [[UIButton alloc]init];
        TanslateButton.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40, 40);
        [TanslateButton setTitle:LocalisedString(@"Translate") forState:UIControlStateNormal];
        [TanslateButton setImage:[UIImage imageNamed:@"TranslateArrow.png"] forState:UIControlStateNormal];
        TanslateButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [TanslateButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
        TanslateButton.layer.cornerRadius = 5;
        TanslateButton.layer.borderWidth=1;
        TanslateButton.layer.masksToBounds = YES;
        TanslateButton.layer.borderColor=[[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f] CGColor];
        [TanslateButton addTarget:self action:@selector(LanguageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:TanslateButton];
        
        GetHeightCheck += 63;
    }
    
//    if (CheckLanguagedata == 2) {
//        //tanslate button here
//        UIButton *TanslateButton = [[UIButton alloc]init];
//        TanslateButton.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40, 40);
//        [TanslateButton setTitle:LocalisedString(@"Translate") forState:UIControlStateNormal];
//        [TanslateButton setImage:[UIImage imageNamed:@"TranslateArrow.png"] forState:UIControlStateNormal];
//        TanslateButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//        [TanslateButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
//        TanslateButton.layer.cornerRadius = 5;
//        TanslateButton.layer.borderWidth=1;
//        TanslateButton.layer.masksToBounds = YES;
//        TanslateButton.layer.borderColor=[[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f] CGColor];
//        [TanslateButton addTarget:self action:@selector(NewLanguageButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:TanslateButton];
//        
//        GetHeightCheck += 63;
//    }else if(CheckLanguagedata == 0){
//        //tanslate button here
//        UIButton *TanslateButton = [[UIButton alloc]init];
//        TanslateButton.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40, 40);
//        [TanslateButton setTitle:LocalisedString(@"Translate") forState:UIControlStateNormal];
//        [TanslateButton setImage:[UIImage imageNamed:@"TranslateArrow.png"] forState:UIControlStateNormal];
//        TanslateButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
//        [TanslateButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
//        TanslateButton.layer.cornerRadius = 5;
//        TanslateButton.layer.borderWidth=1;
//        TanslateButton.layer.masksToBounds = YES;
//        TanslateButton.layer.borderColor=[[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f] CGColor];
//        [TanslateButton addTarget:self action:@selector(LanguageButton:) forControlEvents:UIControlEventTouchUpInside];
//        [MainScroll addSubview:TanslateButton];
//        
//        GetHeightCheck += 63;
//    }

    
    if ([GetTitle length] == 0 || [GetTitle isEqualToString:@""] || [GetTitle isEqualToString:@"(null)"]) {
        GetHeightCheck -= 10;
    }else{
        ShowTitle = [[UILabel alloc]init];
      //  ShowTitle.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40, 40);
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.minimumLineHeight = 21.0f;
        paragraph.maximumLineHeight = 21.0f;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:GetTitle attributes:@{NSParagraphStyleAttributeName: paragraph}];
        ShowTitle.attributedText = attributedString;
       // ShowTitle.text = GetTitle;
        ShowTitle.numberOfLines = 0;
        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
        ShowTitle.textAlignment = NSTextAlignmentLeft;
        ShowTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f  blue:51.0f/255.0f  alpha:1.0f];
        [MainScroll addSubview:ShowTitle];
        
     //   if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
      //  {
            ShowTitle.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
      //  }
        GetHeightCheck += ShowTitle.frame.size.height + 10;
    }
    
    //show location data here.
    UIImageView *ShowPin = [[UIImageView alloc]init];
    ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
    ShowPin.frame = CGRectMake(15, GetHeightCheck, 18, 18);
    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
    [MainScroll addSubview:ShowPin];
    
    UILabel *ShowAddress = [[UILabel alloc]init];
    ShowAddress.frame = CGRectMake(35, GetHeightCheck, screenWidth - 90, 20);
    //ShowAddress.frame = CGRectMake(30, 210 + 3 + heightcheck + i, screenWidth - 150, 20);
    ShowAddress.text = GetPlaceName;
    ShowAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    ShowAddress.backgroundColor = [UIColor clearColor];
    [MainScroll addSubview:ShowAddress];
    
    ShowTopTitle.text = GetPlaceName;
    GetPlaceNameHeight = GetHeightCheck;
    GetPlaceNameHeight -= 20;
    GetHeightCheck += 40;


    GetMessage = [GetMessage stringByDecodingXMLEntities];
    if ([GetMessage length] == 0 || [GetMessage isEqualToString:@""] || [GetMessage isEqualToString:@"(null)"]) {
        GetHeightCheck -= 10;
    }else{
        ShowMessage = [[UITextView alloc]init];
      //  ShowMessage.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40, 100);
        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",GetMessage];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
        UILabel *ShowCaptionText = [[UILabel alloc]init];
        //  ShowCaptionText.frame = CGRectMake(15 + i *screenWidth, 265, screenWidth - 30, 60);
        ShowCaptionText.numberOfLines = 0;
        ShowCaptionText.textColor = [UIColor whiteColor];
        // ShowCaptionText.text = [captionArray objectAtIndex:i];

        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:TempGetStirngMessage];
        NSString *str = TempGetStirngMessage;
        NSError *error = nil;
        
        //I Use regex to detect the pattern I want to change color
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
        NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:0];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
        }
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.minimumLineHeight = 21.0f;
        paragraph.maximumLineHeight = 21.0f;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName: paragraph}];
        ShowMessage.attributedText = attributedString;
        //[ShowMessage setAttributedText:string];
        
       // ShowMessage.text = GetMessage;
        ShowMessage.scrollEnabled = NO;
        ShowMessage.editable = NO;
        ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowMessage.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
        [MainScroll addSubview:ShowMessage];
      //  if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
     //   {
            ShowMessage.frame = CGRectMake(20, GetHeightCheck, screenWidth - 40,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
//            if (ShowMessage.frame.size.height  > 100) {
//                
//            }else{
//                
//            }
//        }
        
        GetHeightCheck += ShowMessage.frame.size.height;
    }
    
    if ([GetTags length] == 0 || [GetTags isEqualToString:@""] || [GetTags isEqualToString:@"(null)"] || [GetTags isEqualToString:@"#[tag:]"]) {
        
    }else{
        NSString *CheckString1 = [GetTags stringByReplacingOccurrencesOfString:@"#[tag:" withString:@""];
        NSLog(@"Tags CheckString1 %@", CheckString1);
        NSString* CheckString2 = [CheckString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        NSLog(@"Tags CheckString2 %@", CheckString2);
        NSArray *TempHashTags = [CheckString2 componentsSeparatedByString: @","];
        NSLog(@"Tags TempHashTags is %@",TempHashTags);
        
        ArrHashTag = [[NSMutableArray alloc]initWithArray:TempHashTags];
        
        // Show link and hash tag
        
        UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
        HashTagScroll.delegate = self;
        HashTagScroll.frame = CGRectMake(0, GetHeightCheck, screenWidth, 50);
        HashTagScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll addSubview:HashTagScroll];
        CGRect frame2 = {0,0};
        for (int i= 0; i < [ArrHashTag count]; i++) {
            UILabel *ShowHashTagText = [[UILabel alloc]init];
            ShowHashTagText.text = [ArrHashTag objectAtIndex:i];
            ShowHashTagText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12];
            ShowHashTagText.textAlignment = NSTextAlignmentCenter;
            ShowHashTagText.backgroundColor = [UIColor whiteColor];
            ShowHashTagText.layer.cornerRadius = 5;
            ShowHashTagText.layer.borderWidth = 1;
            ShowHashTagText.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0 blue:221.0f/255.0 alpha:1.0f] CGColor];
            
            NSString *Text = [ArrHashTag objectAtIndex:i];
            CGRect r = [Text boundingRectWithSize:CGSizeMake(200, 0)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12]}
                                          context:nil];
            
            UIButton *TagsButton = [[UIButton alloc]init];
            [TagsButton setTitle:@"" forState:UIControlStateNormal];
            TagsButton.backgroundColor = [UIColor clearColor];
            TagsButton.tag = i;
            TagsButton.frame = CGRectMake(25 + frame2.size.width, 15, r.size.width + 20, 20);
            [TagsButton addTarget:self action:@selector(PersonalTagsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // CGSize textSize = [ShowHashTagText.text sizeWithAttributes:@{NSFontAttributeName:[ShowHashTagText font]}];
            // CGFloat textSize = ShowHashTagText.intrinsicContentSize.width;
            ShowHashTagText.frame = CGRectMake(20 + frame2.size.width, 15, r.size.width + 20, 20);
            frame2.size.width += r.size.width + 30;
            [HashTagScroll addSubview:ShowHashTagText];
            [HashTagScroll addSubview:TagsButton];
            
            HashTagScroll.contentSize = CGSizeMake(20 + frame2.size.width , 50);
        }
        
        
        GetHeightCheck += 60;
    }
    
    int GetMessageHeight = GetHeightCheck;
    
    if ([GetLink length] == 0 || [GetLink isEqualToString:@""] || [GetLink isEqualToString:@"(null)"]) {
        

    }else{
        UIButton *BlogLinkButton = [[UIButton alloc]init];
        BlogLinkButton.frame = CGRectMake(20, GetMessageHeight + 10, screenWidth - 40, 30);
        [BlogLinkButton setTitle:GetLink forState:UIControlStateNormal];
        [BlogLinkButton setBackgroundColor:[UIColor clearColor]];
        [BlogLinkButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [BlogLinkButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14]];
        [BlogLinkButton addTarget:self action:@selector(BlogLinkButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:BlogLinkButton];
        
        GetMessageHeight += 40;
    }
    

    

    AsyncImageView *UserImage = [[AsyncImageView alloc]init];
    UserImage.frame = CGRectMake(20, GetMessageHeight + 15, 38, 38);
    UserImage.contentMode = UIViewContentModeScaleAspectFill;
    UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImage.layer.cornerRadius= 19;
    UserImage.layer.borderWidth=0;
    UserImage.layer.masksToBounds = YES;
    UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfileUrl];
    NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
    if ([FullImagesURL1 length] == 0) {
        UserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        UserImage.imageURL = url_UserImage;
    }
    [MainScroll addSubview:UserImage];
    
    UILabel *ShowUserName = [[UILabel alloc]init];
    ShowUserName.frame = CGRectMake(72, GetMessageHeight + 10, screenWidth - 140 - 72, 50);
    ShowUserName.text = GetPostName;
    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
   // ShowUserName.textColor = color;
    ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    [MainScroll addSubview:ShowUserName];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:GetPostName]) {
        //follow button

    }else{
        UIButton *OpenProfileButton = [[UIButton alloc]init];
        OpenProfileButton.frame = CGRectMake(20, GetMessageHeight + 10, 250, 50);
        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
        [OpenProfileButton setBackgroundColor:[UIColor clearColor]];
        [OpenProfileButton addTarget:self action:@selector(OpenProfileButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenProfileButton];
        
        ShowFollowButton = [[UIButton alloc]init];
        ShowFollowButton.frame = CGRectMake(screenWidth - 120 - 15, GetMessageHeight + 15, 120, 40);
        if ([GetFollowing isEqualToString:@"0"]) {
            [ShowFollowButton setTitle:LocalisedString(@"Follow_") forState:UIControlStateNormal];
            [ShowFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [ShowFollowButton setImage:[UIImage imageNamed:@"ProfileFollowIcon.png"] forState:UIControlStateNormal];
            [ShowFollowButton setBackgroundImage:[UIImage imageNamed:@"FollowBtn.png"] forState:UIControlStateNormal];
        }else{
            [ShowFollowButton setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:204.0f/255.0f blue:101.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [ShowFollowButton setTitle:LocalisedString(@"Following_") forState:UIControlStateNormal];
            [ShowFollowButton setImage:[UIImage imageNamed:@"ProfileFollowingIcon.png"] forState:UIControlStateNormal];
            [ShowFollowButton setBackgroundImage:[UIImage imageNamed:@"FollowingBtn.png"] forState:UIControlStateNormal];
        }
        ShowFollowButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        ShowFollowButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        ShowFollowButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        ShowFollowButton.backgroundColor = [UIColor clearColor];
        [ShowFollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:ShowFollowButton];
    }
    
    GetMessageHeight += 90;
    
    if ([GetUsername isEqualToString:GetPostName]) {
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15, GetMessageHeight, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line01];
        
        
        UIImageView *ShowViewIcon = [[UIImageView alloc]init];
        ShowViewIcon.image = [UIImage imageNamed:@"PostViewIcon.png"];
        ShowViewIcon.frame = CGRectMake(10, GetMessageHeight, 35, 35);
        [MainScroll addSubview:ShowViewIcon];
        
        NSString *GetFullString = [[NSString alloc]initWithFormat:@"%@ views",ViewCountString];
        
        UILabel *ShowTotalView = [[UILabel alloc]init];
        ShowTotalView.frame = CGRectMake(50, GetMessageHeight + 10, 200, 20);
        ShowTotalView.text = GetFullString;
        ShowTotalView.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        // ShowUserName.textColor = color;
        ShowTotalView.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowTotalView];
        
        GetMessageHeight += 35;
    }
    
    if ([Like_UsernameArray count] == 0 && [CommentIDArray count] == 0 && [TotalCollectionCount isEqualToString:@"0"]) {
        //GetMessageHeight += 20;
    }else{
        if ([GetUsername isEqualToString:GetPostName]) {
            
        }else{
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, GetMessageHeight, screenWidth, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line01];

        GetMessageHeight += 10;
        }
    }
    NSLog(@"TotalCollectionCount is %@",TotalCollectionCount);
    if ([TotalCollectionCount length] == 0 || [TotalCollectionCount isEqualToString:@""] || [TotalCollectionCount isEqualToString:@"(null)"] || [TotalCollectionCount isEqualToString:@"0"]) {
        GetMessageHeight += 10;
    }else{
        //collected show
        UIImageView *ShowCollectionIcon = [[UIImageView alloc]init];
        ShowCollectionIcon.image = [UIImage imageNamed:@"PostCollectedIcon.png"];
        ShowCollectionIcon.frame = CGRectMake(10, GetMessageHeight + 2, 35, 35);
        [MainScroll addSubview:ShowCollectionIcon];
        
        NSString *TempCountString = [[NSString alloc]initWithFormat:@"Collected in %@ %@",TotalCollectionCount,LocalisedString(@"Collections")];
        
        UILabel *ShowCollectionText = [[UILabel alloc]init];
        ShowCollectionText.frame = CGRectMake(50, GetMessageHeight, screenWidth - 69, 40);
        ShowCollectionText.text = TempCountString;
        ShowCollectionText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowCollectionText.backgroundColor = [UIColor clearColor];
        ShowCollectionText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowCollectionText];
        
        GetMessageHeight += 40;
    }
    
    
    NSLog(@"Like_UsernameArray is %@",Like_UsernameArray);
    
    if ([Like_UsernameArray count] == 0) {
        GetMessageHeight += 10;
        
    }else{
        
       // (name) like this
       // (name) and (name) like this
      //  (name) and (number) others like this
        
        UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
        ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeIcon.png"];
        ShowLikesIcon.frame = CGRectMake(10, GetMessageHeight + 5, 35, 35);
        [MainScroll addSubview:ShowLikesIcon];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetUsername = [defaults objectForKey:@"UserName"];
        
        NSString *tempString;
        if ([Like_UsernameArray count] == 1) {

            if ([GetUsername isEqualToString:[Like_UsernameArray objectAtIndex:0]]) {
                tempString = [[NSString alloc]initWithFormat:@"You like this."];
            }else{
                tempString = [[NSString alloc]initWithFormat:@"%@ %@",[Like_UsernameArray objectAtIndex:0],CustomLocalisedString(@"likeText_1", nil)];
            }
            
        }else if([Like_UsernameArray count] == 2){
            if ([GetUsername isEqualToString:[Like_UsernameArray objectAtIndex:0]]) {
                tempString = [[NSString alloc]initWithFormat:@"You ,%@ %@ %@",[Like_UsernameArray objectAtIndex:1],CustomLocalisedString(@"likeText_and", nil),CustomLocalisedString(@"likeText_1", nil)];
            }else{
                tempString = [[NSString alloc]initWithFormat:@"%@ ,%@ %@ %@",[Like_UsernameArray objectAtIndex:0],CustomLocalisedString(@"likeText_and", nil),[Like_UsernameArray objectAtIndex:1],CustomLocalisedString(@"likeText_1", nil)];
            }
        }else{
            int intTotal = [TotalLikeCount intValue];
            if ([GetUsername isEqualToString:[Like_UsernameArray objectAtIndex:0]]) {
                tempString = [[NSString alloc]initWithFormat:@"You %@ %i %@",CustomLocalisedString(@"likeText_and_2", nil),intTotal - 1,CustomLocalisedString(@"likeText_andOther", nil)];
            }else{
                tempString = [[NSString alloc]initWithFormat:@"%@ %@ %i %@",[Like_UsernameArray objectAtIndex:0],CustomLocalisedString(@"likeText_and_2", nil),intTotal - 1,CustomLocalisedString(@"likeText_andOther", nil)];
            }
        }
        
        //"likeText_1" = "liked this";
       // "likeText_and" = "and";
        //"likeText_and_2" = "and";
       // "likeText_andOther" = "other liked this";
        
        UILabel *ShowLikeMessage = [[UILabel alloc]init];
        ShowLikeMessage.frame = CGRectMake(50, GetMessageHeight, screenWidth - 69, 40);
        ShowLikeMessage.text = tempString;
        ShowLikeMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowLikeMessage.backgroundColor = [UIColor clearColor];
        ShowLikeMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowLikeMessage];
        
        UIButton *OpenLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [OpenLikeButton setFrame:CGRectMake(50, GetMessageHeight, screenWidth - 69, 40)];
        [OpenLikeButton setBackgroundColor:[UIColor clearColor]];
        [OpenLikeButton addTarget:self action:@selector(SeeLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenLikeButton];
        
         GetMessageHeight += 40;
    }
    

    if ([CommentIDArray count] == 0) {
        GetMessageHeight += 10;
    }else{
        UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
        ShowCommentIcon.image = [UIImage imageNamed:@"PostCommentIcon.png"];
        ShowCommentIcon.frame = CGRectMake(10, GetMessageHeight + 2, 35, 35);
        [MainScroll addSubview:ShowCommentIcon];
        
        if ([CommentIDArray count] > 4) {
        //    GetMessageHeight += 15;
            
            NSMutableArray *TempCommentIDArray = [[NSMutableArray alloc]init];
            NSMutableArray *TempMessageArray = [[NSMutableArray alloc]init];
            NSMutableArray *TempUser_Comment_usernameArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < 4; i++) {
                
                NSString *GetCommentID = [[NSString alloc]initWithFormat:@"%@",[CommentIDArray objectAtIndex:i]];
                NSString *GetMessage_ = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
                NSString *GetUser_Comment_username = [[NSString alloc]initWithFormat:@"%@",[User_Comment_usernameArray objectAtIndex:i]];
                
                [TempCommentIDArray addObject:GetCommentID];
                [TempMessageArray addObject:GetMessage_];
                [TempUser_Comment_usernameArray addObject:GetUser_Comment_username];
                

            }
            
            TempCommentIDArray = [[[TempCommentIDArray reverseObjectEnumerator] allObjects]mutableCopy];
            TempMessageArray = [[[TempMessageArray reverseObjectEnumerator] allObjects]mutableCopy];
            TempUser_Comment_usernameArray = [[[TempUser_Comment_usernameArray reverseObjectEnumerator] allObjects]mutableCopy];
            
            for (int i = 0; i < 4; i++) {
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(50, GetMessageHeight + 5 + i, 100, 25);
                ShowUserName.text = [TempUser_Comment_usernameArray objectAtIndex:i];
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                ShowUserName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.frame = CGRectMake(50, GetMessageHeight + 5+ i, [ShowUserName sizeThatFits:CGSizeMake(CGFLOAT_MAX, 25)].width,25);
                [MainScroll addSubview:ShowUserName];
                
                UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [OpenExpertsButton setFrame:CGRectMake(50, GetMessageHeight + 5+ i, 100, 25)];
                [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
                OpenExpertsButton.tag = i;
                [OpenExpertsButton addTarget:self action:@selector(OpenProfileButton2:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:OpenExpertsButton];
                
                int TempWidth = 50 + ShowUserName.frame.size.width + 10;
                
                UILabel *Showcomment = [[UILabel alloc]init];
                Showcomment.frame = CGRectMake(TempWidth, GetMessageHeight + 5+ i, screenWidth - TempWidth - 15, 25);
                //  Showcomment.text = [MessageArray objectAtIndex:i];
                Showcomment.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                Showcomment.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                Showcomment.backgroundColor = [UIColor clearColor];
                [MainScroll addSubview:Showcomment];
                
                NSString *TampMessage = [[NSString alloc]initWithFormat:@"%@",[TempMessageArray objectAtIndex:i]];
                NSLog(@"TampMessage is %@",TampMessage);
                NSString *FinalString;
                NSString *FinalString_CheckName;
                
                if ([TampMessage rangeOfString:@"user:"].location == NSNotFound) {
                    NSLog(@"string does not contain user:");
                    FinalString = TampMessage;
                    //  [TagNameArray addObject:@"Null"];
                    Showcomment.text = FinalString;
                } else {
                    NSLog(@"string contains user:!");
                    NSString *CheckString1 = [TampMessage stringByReplacingOccurrencesOfString:@"@[user:" withString:@""];
                    NSLog(@"CheckString1 %@", CheckString1);
                    NSString* CheckString2 = [CheckString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSLog(@"CheckString2 %@", CheckString2);
                    NSArray *SplitArray = [CheckString2 componentsSeparatedByString: @":"];
                    NSLog(@"SplitArray is %@",SplitArray);
                    FinalString = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:1]];
                    NSLog(@"FinalString is %@",FinalString);
                    
                    NSArray *SplitArray2 = [FinalString componentsSeparatedByString:@" "];
                    NSLog(@"SplitArray2 is %@",SplitArray2);
                    FinalString_CheckName = [[NSString alloc]initWithFormat:@"@%@",[SplitArray2 objectAtIndex:0]];
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    //   [TagNameArray addObject:FinalString_CheckName];
                    NSMutableArray *TampArray = [[NSMutableArray alloc]initWithArray:SplitArray2];
                    [TampArray replaceObjectAtIndex:0 withObject:FinalString_CheckName];
                    
                    NSString *FinalResultFullString = [TampArray componentsJoinedByString:@" "];
                    
                    
                    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FinalResultFullString];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14] range:NSMakeRange(0, FinalResultFullString.length)];
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] range:NSMakeRange(0, FinalResultFullString.length)];
                    NSLog(@"mutableAttributedString is %@",mutableAttributedString);
                    NSLog(@"FinalString is %@",FinalString);
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName  options:kNilOptions error:nil];
                    NSRange range = NSMakeRange(0,FinalResultFullString.length);
                    [regex enumerateMatchesInString:FinalResultFullString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        NSRange subStringRange = [result rangeAtIndex:0];
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:subStringRange];
                    }];
                    [Showcomment setAttributedText:mutableAttributedString];
                }
                
                
                GetMessageHeight += 23;
            }
            GetMessageHeight += 20;
            
//            UIButton *Line01 = [[UIButton alloc]init];
//            Line01.frame = CGRectMake(0, GetMessageHeight, screenWidth, 1);
//            [Line01 setTitle:@"" forState:UIControlStateNormal];//238
//            [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
//            [MainScroll addSubview:Line01];
//            
//            UIButton *SeeAllCommentButton = [[UIButton alloc]init];
//            SeeAllCommentButton.frame = CGRectMake(0, GetMessageHeight + 1, screenWidth, 50);
//            [SeeAllCommentButton setTitle:LocalisedString(@"See all activities") forState:UIControlStateNormal];
//            [SeeAllCommentButton setBackgroundColor:[UIColor clearColor]];
//            [SeeAllCommentButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
//            [SeeAllCommentButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
//            [SeeAllCommentButton addTarget:self action:@selector(CommentButton:) forControlEvents:UIControlEventTouchUpInside];
//           // SeeAllCommentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//            [MainScroll addSubview:SeeAllCommentButton];
//            
//            GetMessageHeight += 51;
            
            
        }else{
            
            NSMutableArray *TempCommentIDArray = [[[CommentIDArray reverseObjectEnumerator] allObjects]mutableCopy];
            NSMutableArray *TempMessageArray = [[[MessageArray reverseObjectEnumerator] allObjects]mutableCopy];
            NSMutableArray *TempUser_Comment_usernameArray = [[[User_Comment_usernameArray reverseObjectEnumerator] allObjects]mutableCopy];
            
           // GetMessageHeight += 7;
            for (int i = 0; i < [TempCommentIDArray count]; i++) {
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(50, GetMessageHeight + 5 + i, 100, 25);
                ShowUserName.text = [TempUser_Comment_usernameArray objectAtIndex:i];
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                ShowUserName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.frame = CGRectMake(50, GetMessageHeight + 5 + i, [ShowUserName sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)].width,20);
                [MainScroll addSubview:ShowUserName];
                
                UIButton *OpenExpertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [OpenExpertsButton setFrame:CGRectMake(50, GetMessageHeight + 5 + i, 100, 25)];
                [OpenExpertsButton setBackgroundColor:[UIColor clearColor]];
                OpenExpertsButton.tag = i;
                [OpenExpertsButton addTarget:self action:@selector(OpenProfileButton2:) forControlEvents:UIControlEventTouchUpInside];
                [MainScroll addSubview:OpenExpertsButton];
                
                int TempWidth = 50 + ShowUserName.frame.size.width + 10;
                
                UILabel *Showcomment = [[UILabel alloc]init];
                Showcomment.frame = CGRectMake(TempWidth, GetMessageHeight + 8 + i, screenWidth - TempWidth - 15, 25);
                //  Showcomment.text = [MessageArray objectAtIndex:i];
                Showcomment.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
                Showcomment.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                Showcomment.backgroundColor = [UIColor clearColor];
                Showcomment.numberOfLines = 0;
                [MainScroll addSubview:Showcomment];
                
                NSString *TampMessage = [[NSString alloc]initWithFormat:@"%@",[TempMessageArray objectAtIndex:i]];
                NSLog(@"TampMessage is %@",TampMessage);
                NSString *FinalString;
                NSString *FinalString_CheckName;
                
                if ([TampMessage rangeOfString:@"user:"].location == NSNotFound) {
                    NSLog(@"string does not contain user:");
                    FinalString = TampMessage;
                    //  [TagNameArray addObject:@"Null"];
                    Showcomment.text = FinalString;
                } else {
                    NSLog(@"string contains user:!");
                    NSString *CheckString1 = [TampMessage stringByReplacingOccurrencesOfString:@"@[user:" withString:@""];
                    NSLog(@"CheckString1 %@", CheckString1);
                    NSString* CheckString2 = [CheckString1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    NSLog(@"CheckString2 %@", CheckString2);
                    NSArray *SplitArray = [CheckString2 componentsSeparatedByString: @":"];
                    NSLog(@"SplitArray is %@",SplitArray);
                    FinalString = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:1]];
                    NSLog(@"FinalString is %@",FinalString);
                    
                    NSArray *SplitArray2 = [FinalString componentsSeparatedByString:@" "];
                    NSLog(@"SplitArray2 is %@",SplitArray2);
                    FinalString_CheckName = [[NSString alloc]initWithFormat:@"@%@",[SplitArray2 objectAtIndex:0]];
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    //   [TagNameArray addObject:FinalString_CheckName];
                    NSMutableArray *TampArray = [[NSMutableArray alloc]initWithArray:SplitArray2];
                    [TampArray replaceObjectAtIndex:0 withObject:FinalString_CheckName];
                    
                    NSString *FinalResultFullString = [TampArray componentsJoinedByString:@" "];
                    
                    
                    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:FinalResultFullString];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14] range:NSMakeRange(0, FinalResultFullString.length)];
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] range:NSMakeRange(0, FinalResultFullString.length)];
                    NSLog(@"mutableAttributedString is %@",mutableAttributedString);
                    NSLog(@"FinalString is %@",FinalString);
                    NSLog(@"FinalString_CheckName is %@",FinalString_CheckName);
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FinalString_CheckName  options:kNilOptions error:nil];
                    NSRange range = NSMakeRange(0,FinalResultFullString.length);
                    [regex enumerateMatchesInString:FinalResultFullString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                        NSRange subStringRange = [result rangeAtIndex:0];
                        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:subStringRange];
                    }];
                    [Showcomment setAttributedText:mutableAttributedString];
                }
                if([Showcomment sizeThatFits:CGSizeMake(screenWidth - TempWidth - 15, CGFLOAT_MAX)].height!=Showcomment.frame.size.height)
                {
                Showcomment.frame = CGRectMake(TempWidth, GetMessageHeight+ 8+ i, screenWidth - TempWidth - 15,[Showcomment sizeThatFits:CGSizeMake(screenWidth - TempWidth - 15, CGFLOAT_MAX)].height);
                GetMessageHeight += [Showcomment sizeThatFits:CGSizeMake(screenWidth - TempWidth - 15, CGFLOAT_MAX)].height + 13;
                }else{
                GetMessageHeight += 23;
                }

//                NSLog(@"ShowUserName height === %f",ShowUserName.frame.origin.y);
//                NSLog(@"Showcomment height === %f",Showcomment.frame.origin.y);

              //  GetMessageHeight += 20;
            }
            GetMessageHeight += 20;
        }
    }
    //NSLog(@"GetMessageHeight ==== %i",GetMessageHeight);
    
    if ([Like_UsernameArray count] == 0 && [CommentIDArray count] == 0 && [TotalCollectionCount isEqualToString:@"0"]) {

    }else{
        UIButton *LineFinalAcrivities = [[UIButton alloc]init];
        LineFinalAcrivities.frame = CGRectMake(0, GetMessageHeight, screenWidth, 1);
        [LineFinalAcrivities setTitle:@"" forState:UIControlStateNormal];//238
        [LineFinalAcrivities setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:LineFinalAcrivities];
        
        UIButton *SeeAllCommentButton = [[UIButton alloc]init];
        SeeAllCommentButton.frame = CGRectMake(0, GetMessageHeight + 1, screenWidth, 50);
        [SeeAllCommentButton setTitle:LocalisedString(@"See all activities") forState:UIControlStateNormal];
        [SeeAllCommentButton setBackgroundColor:[UIColor clearColor]];
        [SeeAllCommentButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [SeeAllCommentButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [SeeAllCommentButton addTarget:self action:@selector(CommentButton:) forControlEvents:UIControlEventTouchUpInside];
        // SeeAllCommentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [MainScroll addSubview:SeeAllCommentButton];
        
        GetMessageHeight += 51;
    }
    

    if ([GetSeetishopID isEqualToString:@""] || [GetSeetishopID length] == 0) {
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, GetMessageHeight, screenWidth, 20);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line01];
        
        GetMessageHeight += 20;
        
        UILabel *ShowPlaceInfoText = [[UILabel alloc]init];
        ShowPlaceInfoText.frame = CGRectMake(20, GetMessageHeight, screenWidth - 40, 50);
        ShowPlaceInfoText.text = LocalisedString(@"About the place");
        ShowPlaceInfoText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceInfoText.backgroundColor = [UIColor clearColor];
        ShowPlaceInfoText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowPlaceInfoText];
        
        
        UIButton *DirectionsButton = [[UIButton alloc]init];
        DirectionsButton.frame = CGRectMake(screenWidth - 200 - 20, GetMessageHeight, 200, 50);
        [DirectionsButton setTitle:LocalisedString(@"Getting here") forState:UIControlStateNormal];
        [DirectionsButton setBackgroundColor:[UIColor clearColor]];
        [DirectionsButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [DirectionsButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [DirectionsButton addTarget:self action:@selector(OpenMapButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        DirectionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [MainScroll addSubview:DirectionsButton];
        
        
        GetMessageHeight += 50;
        
        UIButton *Line02 = [[UIButton alloc]init];
        Line02.frame = CGRectMake(0, GetMessageHeight - 1, screenWidth, 1);
        [Line02 setTitle:@"" forState:UIControlStateNormal];//238
        [Line02 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line02];
        
        UIImageView *ShowLocationIcon = [[UIImageView alloc]init];
        ShowLocationIcon.frame = CGRectMake(20, GetMessageHeight + 18, 25, 25);
        ShowLocationIcon.image = [UIImage imageNamed:@"BluePin.png"];
        [MainScroll addSubview:ShowLocationIcon];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(50, GetMessageHeight + 20, screenWidth - 86 - 61 - 5, 21);
        ShowPlaceName.text = GetPlaceName;
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowPlaceName];
        
        GetMessageHeight += 40;
        
        if ([GetPlaceFormattedAddress length] == 0 || [GetPlaceFormattedAddress isEqualToString:@"<null>"]) {
            GetPlaceFormattedAddress = @"";
        }
        
        UILabel *ShowPlaceFormattedAddress = [[UILabel alloc]init];
        ShowPlaceFormattedAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowPlaceFormattedAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowPlaceFormattedAddress.text = GetPlaceFormattedAddress;
        ShowPlaceFormattedAddress.numberOfLines = 0;
        ShowPlaceFormattedAddress.backgroundColor = [UIColor clearColor];
        ShowPlaceFormattedAddress.frame = CGRectMake(50, GetMessageHeight, screenWidth - 152,[ShowPlaceFormattedAddress sizeThatFits:CGSizeMake(screenWidth - 152, CGFLOAT_MAX)].height);
        [MainScroll addSubview:ShowPlaceFormattedAddress];
        
        UIButton *OpenAllInformationButton = [[UIButton alloc]init];
        OpenAllInformationButton.frame = CGRectMake(86, GetMessageHeight - 20, screenWidth - 86 - 61 - 5, 21 + ShowPlaceFormattedAddress.frame.size.height);
        [OpenAllInformationButton setTitle:@"" forState:UIControlStateNormal];
        [OpenAllInformationButton setBackgroundColor:[UIColor clearColor]];
        [OpenAllInformationButton addTarget:self action:@selector(OpenAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenAllInformationButton];
        
        GetMessageHeight += ShowPlaceFormattedAddress.frame.size.height + 20;
        
        
        
        if ([GetPlaceLink length] == 0 || [GetPlaceLink isEqualToString:@"(null)"]) {
        }else{
            UIImageView *ShowLinkIcon = [[UIImageView alloc]init];
            ShowLinkIcon.frame = CGRectMake(20, GetMessageHeight, 25, 25);
            ShowLinkIcon.image = [UIImage imageNamed:@"BlueLink.png"];
            [MainScroll addSubview:ShowLinkIcon];
            
            UILabel *ShowPlacelink = [[UILabel alloc]init];
            ShowPlacelink.frame = CGRectMake(50, GetMessageHeight, screenWidth - 152, 25);
            ShowPlacelink.text = GetPlaceLink;
            ShowPlacelink.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowPlacelink.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowPlacelink];
            
            UIButton *OpenLinkButton = [[UIButton alloc]init];
            OpenLinkButton.frame = CGRectMake(50, GetMessageHeight - 6, screenWidth - 152, 21);
            [OpenLinkButton setTitle:@"" forState:UIControlStateNormal];
            [OpenLinkButton addTarget:self action:@selector(OpenLinkButton:) forControlEvents:UIControlEventTouchUpInside];
            [OpenLinkButton setBackgroundColor:[UIColor clearColor]];
            [MainScroll addSubview:OpenLinkButton];
            
            GetMessageHeight += 50;
        }
        if ([GetContactNo length] == 0 || [GetContactNo isEqualToString:@"(null)"]) {
            
        }else{
            UIImageView *ShowContactIcon = [[UIImageView alloc]init];
            ShowContactIcon.frame = CGRectMake(20, GetMessageHeight, 25, 25);
            ShowContactIcon.image = [UIImage imageNamed:@"BluePhone.png"];
            [MainScroll addSubview:ShowContactIcon];
            
            UILabel *ShowContact = [[UILabel alloc]init];
            ShowContact.frame = CGRectMake(50, GetMessageHeight, screenWidth - 152, 25);
            ShowContact.text = GetContactNo;
            ShowContact.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowContact.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowContact];
            
            UIButton *OpenContactButton = [[UIButton alloc]init];
            OpenContactButton.frame = CGRectMake(50, GetMessageHeight - 6, screenWidth - 152, 21);
            [OpenContactButton setTitle:@"" forState:UIControlStateNormal];
            [OpenContactButton addTarget:self action:@selector(OpenContactButton:) forControlEvents:UIControlEventTouchUpInside];
            [OpenContactButton setBackgroundColor:[UIColor clearColor]];
            [MainScroll addSubview:OpenContactButton];
            
            
            
            GetMessageHeight += 50;
        }
        if ([GetOpeningHourOpen length] == 0 || [GetOpeningHourOpen isEqualToString:@"(null)"]) {
            
        }else{
            UIImageView *ShowOpeningIcon = [[UIImageView alloc]init];
            ShowOpeningIcon.frame = CGRectMake(20, GetMessageHeight, 25, 25);
            ShowOpeningIcon.image = [UIImage imageNamed:@"BlueTime.png"];
            [MainScroll addSubview:ShowOpeningIcon];
            
            if ([GetOpeningHourOpen isEqualToString:@"0"]) {
                GetOpeningHourOpen = @"Close";
            }else{
                
                GetOpeningHourOpen = @"Open";
            }
            
            UILabel *ShowOpeningTExt = [[UILabel alloc]init];
            ShowOpeningTExt.frame = CGRectMake(50, GetMessageHeight, screenWidth - 152, 25);
            ShowOpeningTExt.text = GetOpeningHourOpen;
            ShowOpeningTExt.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowOpeningTExt.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowOpeningTExt];
            
            GetMessageHeight += 50;
        }
        if ([GetExpense length] == 0 || [GetExpense isEqualToString:@"(null)"]) {
            
        }else{
            UIImageView *ShowPriceIcon = [[UIImageView alloc]init];
            ShowPriceIcon.frame = CGRectMake(20, GetMessageHeight, 25, 25);
            ShowPriceIcon.image = [UIImage imageNamed:@"BluePrice.png"];
            [MainScroll addSubview:ShowPriceIcon];
            
            UILabel *ShowPriceTExt = [[UILabel alloc]init];
            ShowPriceTExt.frame = CGRectMake(50, GetMessageHeight, screenWidth - 152, 25);
            ShowPriceTExt.text = GetExpense;
            ShowPriceTExt.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowPriceTExt.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            [MainScroll addSubview:ShowPriceTExt];
            
            GetMessageHeight += 50;
        }
        
        UIButton *Line03 = [[UIButton alloc]init];
        Line03.frame = CGRectMake(0, GetMessageHeight, screenWidth, 1);
        [Line03 setTitle:@"" forState:UIControlStateNormal];//238
        [Line03 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line03];
        
        UIButton *MoreInfoButton = [[UIButton alloc]init];
        MoreInfoButton.frame = CGRectMake(0, GetMessageHeight + 1, screenWidth, 50);
        [MoreInfoButton setTitle:LocalisedString(@"Read more") forState:UIControlStateNormal];
        [MoreInfoButton setBackgroundColor:[UIColor clearColor]];
        [MoreInfoButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [MoreInfoButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [MoreInfoButton addTarget:self action:@selector(OpenAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        // SeeAllCommentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [MainScroll addSubview:MoreInfoButton];
        GetMessageHeight += 50;
        

    }else{
        
        //Seetishop UI
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, GetMessageHeight, screenWidth, 20);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line01];
        
        GetMessageHeight += 20;
        
        UILabel *ShowPlaceInfoText = [[UILabel alloc]init];
        ShowPlaceInfoText.frame = CGRectMake(20, GetMessageHeight, screenWidth - 40, 50);
        ShowPlaceInfoText.text = LocalisedString(@"About the place");
        ShowPlaceInfoText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceInfoText.backgroundColor = [UIColor clearColor];
        ShowPlaceInfoText.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowPlaceInfoText];
        
        
        UIButton *DirectionsButton = [[UIButton alloc]init];
        DirectionsButton.frame = CGRectMake(screenWidth - 200 - 20, GetMessageHeight, 200, 50);
        [DirectionsButton setTitle:LocalisedString(@"Getting here") forState:UIControlStateNormal];
        [DirectionsButton setBackgroundColor:[UIColor clearColor]];
        [DirectionsButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [DirectionsButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [DirectionsButton addTarget:self action:@selector(OpenAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        DirectionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [MainScroll addSubview:DirectionsButton];
        
        
        GetMessageHeight += 50;
        
        UIButton *Line02 = [[UIButton alloc]init];
        Line02.frame = CGRectMake(0, GetMessageHeight - 1, screenWidth, 1);
        [Line02 setTitle:@"" forState:UIControlStateNormal];//238
        [Line02 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line02];
        
        //Shop Icon, Name and Address
        
        AsyncImageView *ShowShopImage = [[AsyncImageView alloc]init];
        ShowShopImage.frame = CGRectMake(20, GetMessageHeight + 20, 50, 50);
        ShowShopImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowShopImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowShopImage.layer.cornerRadius= 25;
        ShowShopImage.layer.borderWidth=1;
        ShowShopImage.layer.masksToBounds = YES;
        ShowShopImage.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowShopImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetSeetishopImage];
        if ([FullImagesURL1 length] == 0) {
            ShowShopImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowShopImage.imageURL = url_UserImage;
        }
        [MainScroll addSubview:ShowShopImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.text = GetSeetishopName;
        ShowUserName.frame = CGRectMake(90, GetMessageHeight + 20, ShowUserName.intrinsicContentSize.width, 20);
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowUserName.backgroundColor = [UIColor clearColor];
        // ShowUserName.textColor = color;
        ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowUserName];
        
        UIImageView *ShowVerifiedImg = [[UIImageView alloc]init];
        ShowVerifiedImg.image = [UIImage imageNamed:@"SSBlueVerifiedIcon.png"];
        ShowVerifiedImg.frame = CGRectMake(90 + ShowUserName.frame.size.width, GetMessageHeight + 21, 18, 18);
        [MainScroll addSubview:ShowVerifiedImg];
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(90, GetMessageHeight + 45, screenWidth - 20 - 90, 30);
        ShowAddress.text = GetSeetishopAddress;
        ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowAddress.numberOfLines = 2;
        // ShowUserName.textColor = color;
        ShowAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        [MainScroll addSubview:ShowAddress];
        
        
        
        GetMessageHeight += 90;
        
        UIButton *Line03 = [[UIButton alloc]init];
        Line03.frame = CGRectMake(0, GetMessageHeight, screenWidth, 1);
        [Line03 setTitle:@"" forState:UIControlStateNormal];//238
        [Line03 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line03];
        
        UIButton *ViewSeetishopButton = [[UIButton alloc]init];
        ViewSeetishopButton.frame = CGRectMake(0, GetMessageHeight + 1, screenWidth, 50);
        [ViewSeetishopButton setTitle:@"View Seetishop" forState:UIControlStateNormal];
        [ViewSeetishopButton setBackgroundColor:[UIColor clearColor]];
        [ViewSeetishopButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [ViewSeetishopButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [ViewSeetishopButton addTarget:self action:@selector(ViewSeetishopButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        // SeeAllCommentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [MainScroll addSubview:ViewSeetishopButton];
        GetMessageHeight += 50;
    
    }
    
    UIButton *Line04 = [[UIButton alloc]init];
    Line04.frame = CGRectMake(0, GetMessageHeight, screenWidth, 20);
    [Line04 setTitle:@"" forState:UIControlStateNormal];//238
    [Line04 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line04];
    
    GetMessageHeight += 20;

    
    MainScroll.contentSize = CGSizeMake(screenWidth, GetMessageHeight + 50);
    CheckLoadDone = YES;
    [ShowActivity stopAnimating];
   // [spinnerView stopAnimating];
    //[spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    GetFinalHeight = 0;
    GetFinalHeight = GetMessageHeight;
    

    
    if (isThereAnyCollectionSuggestion) {
        
        //TODO: Uncomment the following for collecting suggestion
        [self GetCollectionSuggestionsData];
    }else{
        [self InitCollectionSuggestionsView];
    }
    
    
   // [self InitNearbyPostView];

}
-(void)InitCollectionSuggestionsView{
    
    NSLog(@"InitCollectionSuggestionsView");
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([arrCollectionID count] == 0) {
        
    }else{
        UIScrollView *CollectionScrollview = [[UIScrollView alloc]init];
        CollectionScrollview.delegate = self;
        CollectionScrollview.frame = CGRectMake(0, GetFinalHeight, screenWidth, 260);
        CollectionScrollview.backgroundColor = [UIColor whiteColor];
        //CollectionScrollview.pagingEnabled = YES;
        [CollectionScrollview setShowsHorizontalScrollIndicator:NO];
        [CollectionScrollview setShowsVerticalScrollIndicator:NO];
        CollectionScrollview.tag = 10000;
        CollectionScrollview.layer.masksToBounds = YES;
        CollectionScrollview.layer.borderWidth = 1;
        CollectionScrollview.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
        [MainScroll addSubview:CollectionScrollview];
        
        UILabel *ShowSuggestedText = [[UILabel alloc]init];
        ShowSuggestedText.frame = CGRectMake(20, GetFinalHeight, screenWidth - 70, 50);
        ShowSuggestedText.text = LocalisedString(@"Suggested Collections");
        ShowSuggestedText.backgroundColor = [UIColor clearColor];
        ShowSuggestedText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
        ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowSuggestedText];
        
        UIButton *SeeallButton = [[UIButton alloc]init];
        SeeallButton.frame = CGRectMake(screenWidth - 120, GetFinalHeight, 120, 50);
        [SeeallButton setTitle:LocalisedString(@"See all")  forState:UIControlStateNormal];
        [SeeallButton setImage:[UIImage imageNamed:@"ArrowBtn.png"] forState:UIControlStateNormal];
        SeeallButton.backgroundColor = [UIColor clearColor];
        SeeallButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        SeeallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [SeeallButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13]];
        [SeeallButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [SeeallButton addTarget:self action:@selector(SeeAllButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview: SeeallButton];
        
        for (int i = 0; i < [arrCollectionID count]; i++) {
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(10 + i * (screenWidth - 45), 50 , screenWidth - 50 ,190);
            [TempButton setTitle:@"" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor whiteColor];
            TempButton.layer.cornerRadius = 10;
            TempButton.layer.borderWidth=1;
            TempButton.layer.masksToBounds = YES;
            TempButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
            [CollectionScrollview addSubview: TempButton];
            
            
            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImageData objectAtIndex:i]];
            NSArray *SplitArray_TempImage = [TempImage componentsSeparatedByString:@"^^^"];
            if ([SplitArray_TempImage count] == 1) {
                AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,120);
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
                [CollectionScrollview addSubview:ShowImage1];
            }else{
                AsyncImageView *ShowImage1 = [[AsyncImageView alloc]init];
                ShowImage1.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , ((screenWidth - 55) / 2) ,120);
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
                [CollectionScrollview addSubview:ShowImage1];
                
                AsyncImageView *ShowImage2 = [[AsyncImageView alloc]init];
                ShowImage2.frame = CGRectMake(10 + ((screenWidth - 40) / 2) + i * (screenWidth - 40), 50 , ((screenWidth - 60) / 2) ,120);
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
                [CollectionScrollview addSubview:ShowImage2];
            }
            

            
            
            UIImageView *ShowOverlayImg = [[UIImageView alloc]init];
            ShowOverlayImg.image = [UIImage imageNamed:@"DealsAndRecommendationOverlay.png"];
            ShowOverlayImg.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,150);
            ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
            ShowOverlayImg.layer.masksToBounds = YES;
            ShowOverlayImg.layer.cornerRadius = 10;
            [CollectionScrollview addSubview:ShowOverlayImg];
            
            
            
            UIButton *OpenCollectionButton = [[UIButton alloc]init];
            OpenCollectionButton.frame = CGRectMake(10 + i * (screenWidth - 40), 50 , screenWidth - 50 ,190);
            [OpenCollectionButton setTitle:@"" forState:UIControlStateNormal];
            OpenCollectionButton.backgroundColor = [UIColor clearColor];
            OpenCollectionButton.layer.cornerRadius = 10;
            OpenCollectionButton.layer.borderWidth=1;
            OpenCollectionButton.layer.masksToBounds = YES;
            OpenCollectionButton.layer.borderColor=[[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f] CGColor];
            [OpenCollectionButton addTarget:self action:@selector(OpenCollectionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            OpenCollectionButton.tag = i;
            [CollectionScrollview addSubview: OpenCollectionButton];
            
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, 40, 40);
            // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=1;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *ImageData1 = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
            if ([ImageData1 length] == 0) {
                ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:ImageData1];
                ShowUserProfileImage.imageURL = url_NearbySmall;
            }
            [CollectionScrollview addSubview:ShowUserProfileImage];
            
            UIButton *OpenUserProfileButton = [[UIButton alloc]init];
            [OpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
            OpenUserProfileButton.backgroundColor = [UIColor clearColor];
            OpenUserProfileButton.frame = CGRectMake(25 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
            [OpenUserProfileButton addTarget:self action:@selector(CollectionUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
            OpenUserProfileButton.tag = i;
            [CollectionScrollview addSubview:OpenUserProfileButton];
            
            NSString *usernameTemp = [[NSString alloc]initWithFormat:@"%@",[arrUsername objectAtIndex:i]];
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(75 + i * (screenWidth - 40), 51 + 10, screenWidth - 75 - 100, 40);
            ShowUserName.text = usernameTemp;
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor whiteColor];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [CollectionScrollview addSubview:ShowUserName];
            
            UILabel *ShowCollectionTitle = [[UILabel alloc]init];
            ShowCollectionTitle.frame = CGRectMake(25 + i * (screenWidth - 40), 180, screenWidth - 190 , 20);
            ShowCollectionTitle.text = [arrTitle objectAtIndex:i];
            ShowCollectionTitle.backgroundColor = [UIColor clearColor];
            ShowCollectionTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
            ShowCollectionTitle.textAlignment = NSTextAlignmentLeft;
            ShowCollectionTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:16];
            [CollectionScrollview addSubview:ShowCollectionTitle];
            
            
            NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ recommendations",[arrTotalCount objectAtIndex:i]];
            
            UILabel *ShowCollectionCount = [[UILabel alloc]init];
            ShowCollectionCount.frame = CGRectMake(25 + i * (screenWidth - 40), 200, screenWidth - 190, 20);
            ShowCollectionCount.text = TempCount;
            ShowCollectionCount.backgroundColor = [UIColor clearColor];
            ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowCollectionCount.textAlignment = NSTextAlignmentLeft;
            ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
            [CollectionScrollview addSubview:ShowCollectionCount];
            
            
            NSString *CheckCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrFollowing objectAtIndex:i]];
            NSLog(@"CheckCollectionFollowing is %@",CheckCollectionFollowing);
            UIButton *QuickCollectButtonLocalQR = [[UIButton alloc]init];
            if ([CheckCollectionFollowing isEqualToString:@"0"]) {
                [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
                [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
            }else{
                [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateNormal];
                [QuickCollectButtonLocalQR setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateSelected];
            }
            [QuickCollectButtonLocalQR setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [QuickCollectButtonLocalQR.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
            QuickCollectButtonLocalQR.backgroundColor = [UIColor clearColor];
            QuickCollectButtonLocalQR.frame = CGRectMake((screenWidth - 45 - 115) + i * (screenWidth - 40), 186, 115, 38);//115,38
            [QuickCollectButtonLocalQR addTarget:self action:@selector(CollectionFollowingButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            QuickCollectButtonLocalQR.tag = i;
            [CollectionScrollview addSubview:QuickCollectButtonLocalQR];
            CollectionScrollview.contentSize = CGSizeMake(20 + i * (screenWidth - 40) + (screenWidth - 50), 200);
        }
        
        
        GetFinalHeight += 260;
        
        UIButton *Line04 = [[UIButton alloc]init];
        Line04.frame = CGRectMake(0, GetFinalHeight, screenWidth, 20);
        [Line04 setTitle:@"" forState:UIControlStateNormal];//238
        [Line04 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line04];
        
        GetFinalHeight += 20;
    }
    
    
    
    if (CheckNearbyPost == 0) {
        [self GetNearbyPostData];
    }else{
        [self InitNearbyPostView];
    }
}
-(void)InitNearbyPostView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    UILabel *ShowNearbyTitle = [[UILabel alloc]init];
    ShowNearbyTitle.frame = CGRectMake(20, GetFinalHeight, screenWidth - 40, 50);
    ShowNearbyTitle.text = LocalisedString(@"Nearby recommendations");
    ShowNearbyTitle.backgroundColor = [UIColor clearColor];
    ShowNearbyTitle.textAlignment = NSTextAlignmentLeft;
    ShowNearbyTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    ShowNearbyTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [MainScroll addSubview:ShowNearbyTitle];
    NSLog(@"[PhotoArray_Nearby count] is %lu",(unsigned long)[PhotoArray_Nearby count]);
    
    NSInteger GetCount = 0;
    
    if ([PhotoArray_Nearby count] <= 2) {
        GetCount = [PhotoArray_Nearby count];
    }else{
        GetCount = 2;
    }

    
    GetFinalHeight += 50;
    
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetFinalHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];//238
    [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line01];

    
    GetFinalHeight += 21;
    
    //int TempHeight = GetFinalHeight;
    
    int TestWidth = screenWidth - 60;
    //    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 2;
    
    int TitleHeight = 0;
    for (NSInteger i = 0; i < GetCount; i++) {
        
        
        UIButton *Background = [[UIButton alloc]init];
        Background.frame = CGRectMake(19 + (i % 2) * (FinalWidth + 20), GetFinalHeight - 1, FinalWidth + 2, FinalWidth + 2);
        [Background setTitle:@"" forState:UIControlStateNormal];//238
        [Background setBackgroundColor:[UIColor whiteColor]];
        Background.layer.cornerRadius = 5;
        Background.layer.borderWidth=1;
        Background.layer.borderColor=[[UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f] CGColor];
        [MainScroll addSubview:Background];
        
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray_Nearby objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage_Nearby = [[AsyncImageView alloc]init];
        ShowImage_Nearby.frame = CGRectMake(20 + (i % 2) * (FinalWidth + 20), GetFinalHeight, FinalWidth, FinalWidth);
        ShowImage_Nearby.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage_Nearby.layer.masksToBounds = YES;
        ShowImage_Nearby.layer.cornerRadius = 5;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage_Nearby];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage_Nearby.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage_Nearby.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage_Nearby];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"LocationpinIcon.png"];
        ShowPin.frame = CGRectMake(17 + (i % 2) * (FinalWidth + 20), GetFinalHeight + FinalWidth + 10, 18, 18);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [MainScroll addSubview:ShowPin];
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(35 + (i % 2) * (FinalWidth + 20), GetFinalHeight + FinalWidth + 10, FinalWidth - 15, 20);
        ShowAddress.text = [PlaceNameArray_Nearby objectAtIndex:i];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowAddress.backgroundColor = [UIColor clearColor];
        [MainScroll addSubview:ShowAddress];

        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(25 + (i % 2) * (FinalWidth + 20),  GetFinalHeight + FinalWidth + 45 + TitleHeight , 30, 30);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = 15;
        ShowUserProfileImage.layer.borderWidth=0;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [MainScroll addSubview:ShowUserProfileImage];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray_Nearby objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            //NSLog(@"url is %@",url);
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        
        
        UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(25 + (i % 2) * (FinalWidth + 20),  GetFinalHeight + FinalWidth + 45 + TitleHeight , FinalWidth, 30)];
        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
        OpenProfileButton.tag = i;
        OpenProfileButton.backgroundColor = [UIColor clearColor];
        [OpenProfileButton addTarget:self action:@selector(OpenProfileButton3:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenProfileButton];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(65 + (i % 2) * (FinalWidth + 20), GetFinalHeight + FinalWidth + 45+ TitleHeight, FinalWidth - 50, 30);
        ShowUserName.text = [UserInfo_NameArray_Nearby objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowUserName];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(20 + (i % 2) * (FinalWidth + 20), GetFinalHeight, FinalWidth, FinalWidth + 20 + TitleHeight);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:SelectButton];

        
        
         Background.frame = CGRectMake(19 + (i % 2) * (FinalWidth + 20), GetFinalHeight - 1, FinalWidth + 2, FinalWidth + 50+ TitleHeight + 30 + 10);
        
        
        

        if ([UserInfo_NameArray_Nearby count] < 2) {
            GetFinalHeight += 267;
        }else{
            GetFinalHeight += 0 + (i % 2) * (FinalWidth + TitleHeight + 50 + 57);
        }
        

        
        //GetFinalHeight += 20;
        
        
    }
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(0, GetFinalHeight, screenWidth, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];//238
    [Line02 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line02];
    
    if ([PhotoArray_Nearby count] <= 4) {
    }else{
        
        SeeAllButton_Nearby = [[UIButton alloc]init];
        SeeAllButton_Nearby.frame = CGRectMake(0, GetFinalHeight, screenWidth, 50);
        [SeeAllButton_Nearby setTitle:LocalisedString(@"See it all!") forState:UIControlStateNormal];
        [SeeAllButton_Nearby setBackgroundColor:[UIColor clearColor]];
        [SeeAllButton_Nearby.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
        [SeeAllButton_Nearby setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [SeeAllButton_Nearby addTarget:self action:@selector(NearbySeeAllButton:) forControlEvents:UIControlEventTouchUpInside];
        //SeeAllButton_Nearby.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [MainScroll addSubview:SeeAllButton_Nearby];
        
        GetFinalHeight += 51;
    }
    
    

    MainScroll.contentSize = CGSizeMake(screenWidth, GetFinalHeight + 50);
    
}
-(IBAction)SelectButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    [MainScroll setContentOffset:CGPointZero animated:YES];
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    for (UIView *subview in MImageScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    //ShareButton.hidden = YES;
    //ShareIcon.hidden = YES;
    CheckLikeInitView = NO;
    CheckCommentData = 0;
    CountLanguage = 0;
    LanguageButton.hidden = YES;
    NewLanguageButton.hidden = YES;
    TestingUse = NO;
    CheckLoadDone = NO;
    CheckClickCount = 0;
    CheckNearbyPost = 0;
    [CommentIDArray removeAllObjects];
    [MessageArray removeAllObjects];
    [PostIDArray removeAllObjects];
    [User_Comment_uidArray removeAllObjects];
    [User_Comment_nameArray removeAllObjects];
    [User_Comment_usernameArray removeAllObjects];
    [User_Comment_photoArray removeAllObjects];


    if (CheckLoadDone == NO) {
        [ShowActivity startAnimating];
    }
    
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[PostIDArray_Nearby objectAtIndex:getbuttonIDN]];
    [self GetPostAllData];
}
-(IBAction)NearbySeeAllButton:(id)sender{
    NSLog(@"Nearby See all Button");
    
    NearByRecommtationViewController *NearByRecommtationView = [[NearByRecommtationViewController alloc]init];
    [self presentViewController:NearByRecommtationView animated:YES completion:nil];
    [NearByRecommtationView GetLPhoto:PhotoArray_Nearby GetPostID:PostIDArray_Nearby GetPlaceName:PlaceNameArray_Nearby GetUserInfoUrl:UserInfo_UrlArray_Nearby GetUserInfoName:UserInfo_NameArray_Nearby GetTitle:TitleArray_Nearby GetMessage:MessageArray_Nearby GetDistance:DistanceArray_Nearby GetSearchDisplayName:SearchDisplayNameArray_Nearby GetTotalComment:TotalCommentArray_Nearby GetTotalLike:TotalLikeArray_Nearby GetSelfCheckLike:SelfCheckLikeArray_Nearby GetSelfCheckCollect:SelfCheckCollectArray_Nearby];

}
-(IBAction)SelectButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    [MainScroll setContentOffset:CGPointZero animated:YES];
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    for (UIView *subview in MImageScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    //ShareButton.hidden = YES;
    //ShareIcon.hidden = YES;
    CheckLikeInitView = NO;
    CheckCommentData = 0;
    CountLanguage = 0;
    LanguageButton.hidden = YES;
    NewLanguageButton.hidden = YES;
    TestingUse = NO;
    CheckLoadDone = NO;
    CheckClickCount = 0;
    CheckNearbyPost = 0;
    
    [CommentIDArray removeAllObjects];
    [MessageArray removeAllObjects];
    [PostIDArray removeAllObjects];
    [User_Comment_uidArray removeAllObjects];
    [User_Comment_nameArray removeAllObjects];
    [User_Comment_usernameArray removeAllObjects];
    [User_Comment_photoArray removeAllObjects];
    
    if (CheckLoadDone == NO) {

        [ShowActivity startAnimating];
    }
    
    GetPostID = [[NSString alloc]initWithFormat:@"%@",[PostIDArray_Nearby lastObject]];
    [self GetPostAllData];
}
-(IBAction)OpenProfileButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:GetPostName]) {
        NSLog(@"user is self. open profile");
    }else{
//        NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//        [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//        [NewUserProfileV2View GetUserName:GetPostName];
        _profileViewController = nil;
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:GetUserUid];
        [self.navigationController pushViewController:self.profileViewController animated:YES];
    
    }

}

-(IBAction)OpenProfileButton2:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSMutableArray *TempUser_User_Comment_uidArray = [[[User_Comment_uidArray reverseObjectEnumerator] allObjects]mutableCopy];
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[TempUser_User_Comment_uidArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)OpenProfileButton3:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:[UserInfo_NameArray_Nearby objectAtIndex:getbuttonIDN]];
    
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[UserInfo_IDArray_Nearby objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)OpenProfileButton4:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);

//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:[UserInfo_NameArray_Nearby lastObject]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[UserInfo_IDArray_Nearby objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
    
    
}
-(IBAction)FollowButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:GetPostName]) {
        NSLog(@"user is self. follow button click");
    }else{
        if ([GetFollowing isEqualToString:@"1"]) {
            
            NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"),GetPostName];
            
            UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:LocalisedString(@"Unfollow user") message:tempStirng delegate:self cancelButtonTitle:LocalisedString(@"Maybe not.") otherButtonTitles:LocalisedString(@"Yeah!"), nil];
            ShowAlertView.tag = 1200;
            [ShowAlertView show];
        }else{
            [self SendFollowingData];
        }
      //  [self SendFollowingData];
    }

}
-(void)SendFollowingData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetUserUid,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    if ([GetFollowing isEqualToString:@"1"]) {
        [request setHTTPMethod:@"DELETE"];
    }else{
        [request setHTTPMethod:@"POST"];
    }
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
//    //parameter second
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the key name @"parameter_second" to the post body
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Attaching the content to be posted ( ParameterSecond )
//    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_Following = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Following) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    pageControlBeingUsed = NO;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    pageControlBeingUsed = NO;
//}
-(IBAction)HideButton:(id)sender{
    if (CheckClickCount == 0) {
        CheckClickCount = 1;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             ShowbarView.frame = CGRectMake(0, 0, screenWidth, 64);
                             // ShowDownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                         }
                         completion:^(BOOL finished) {
                         }];
    }else{
        CheckClickCount = 0;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             ShowbarView.frame = CGRectMake(0, -64, screenWidth, 64);
                             // ShowDownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                         }
                         completion:^(BOOL finished) {
                         }];
    
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)sender {

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (sender == MImageScroll) {
        // Update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = MImageScroll.frame.size.width;
        int page = floor((MImageScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
      //  PageControlOn.currentPage = page;
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%i / %li",page + 1,(long)ImageCount];
        ShowImageCount.text = TempCount;
    }else{
        
        float HeightCheck = MainScroll.contentOffset.y;
        
        if (HeightCheck > 64) {
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                  ShowBarImg.frame = CGRectMake(0, 0, screenWidth, 64);
                             }
                             completion:^(BOOL finished) {
                             }];
           
        }else{
            [UIView animateWithDuration:0.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 ShowBarImg.frame = CGRectMake(0, -64, screenWidth, 64);
                             }
                             completion:^(BOOL finished) {
                             }];
            

        }
        if (HeightCheck > GetPlaceNameHeight) {
            ShowTopTitle.hidden = NO;
        }else{
            ShowTopTitle.hidden = YES;
        }




    }
    

}
-(IBAction)LikeButton:(id)sender{
    NSLog(@"Like Button Click");
    if ([GetLikeCheck isEqualToString:@"0"]) {
        GetLikeCheck = @"1";
        CheckLikeInitView = YES;
        ShowTotalLikeCount.textColor = [UIColor redColor];
        [LikeButton setImage:[UIImage imageNamed:@"LikedIcon.png"] forState:UIControlStateNormal];
        [LikeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self SendPostLike];
        NSLog(@"like post");
    }else{
        GetLikeCheck = @"0";
        CheckLikeInitView = YES;
        [LikeButton setImage:[UIImage imageNamed:@"LikeIcon.png"] forState:UIControlStateNormal];
        [LikeButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [self GetUnLikeData];
        NSLog(@"unlike post");
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetLikeCheck forKey:@"PostToDetail_like"];
    [defaults synchronize];
    
    
    
}
-(IBAction)CommentButton:(id)sender{
    NSLog(@"Comment Button Click");
    CheckCommentData = 1;
    CommentViewController *CommentView = [[CommentViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:YES completion:nil];
    [CommentView GetCommentIDArray:CommentIDArray GetPostIDArray:PostIDArray GetMessageArray:MessageArray GetUser_Comment_uidArray:User_Comment_uidArray GetUser_Comment_nameArray:User_Comment_nameArray GetUser_Comment_usernameArray:User_Comment_usernameArray GetUser_Comment_photoArray:User_Comment_photoArray];
    [CommentView GetRealPostID:GetPostID];
    [CommentView GetWhatView:@"Comment"];
    
}
-(IBAction)SeeLikeButton:(id)sender{
    CheckCommentData = 1;
    CommentViewController *CommentView = [[CommentViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:CommentView animated:YES completion:nil];
    [CommentView GetCommentIDArray:CommentIDArray GetPostIDArray:PostIDArray GetMessageArray:MessageArray GetUser_Comment_uidArray:User_Comment_uidArray GetUser_Comment_nameArray:User_Comment_nameArray GetUser_Comment_usernameArray:User_Comment_usernameArray GetUser_Comment_photoArray:User_Comment_photoArray];
    [CommentView GetRealPostID:GetPostID];
    [CommentView GetWhatView:@"Like"];
}
-(IBAction)FacebookButton:(id)sender{
    NSLog(@"Facebook Button Click");
    NSString *message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
    NSString *Description = [NSString stringWithFormat:@"%@",GetMessage];
    NSString *caption = [NSString stringWithFormat:@"SEETIES.ME"];
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:message];
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"", @"name",
                                       caption, @"caption",
                                       Description, @"description",
                                       message, @"link",
                                       @"", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

-(void)GetUnLikeData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
    
}
-(void)SendPostLike{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/like",DataUrl.UserWallpaper_Url,GetPostID];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_likes = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_likes) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)ImageButtonClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FullImageViewController *FullImageView = [[FullImageViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FullImageView animated:NO completion:nil];
    [FullImageView GetAllImageArray:UrlArray GetIDN:getbuttonIDN GetAllCaptionArray:captionArray];
    
}
-(IBAction)ShareButton:(id)sender{
    NSLog(@"ShareButton Click.");
    
//    ShareViewController *ShareView = [[ShareViewController alloc]init];
//    [self presentViewController:ShareView animated:YES completion:nil];
//    //[self.view.window.rootViewController presentViewController:ShareView animated:YES completion:nil];
  //  [ShareView GetPostID:GetPostID GetMessage:GetMessage GetTitle:GetTitle GetImageData:[UrlArray objectAtIndex:0]];
    
    _shareV2ViewController = nil;
    UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
    [naviVC setNavigationBarHidden:YES animated:NO];
    [self.shareV2ViewController share:@"" title:GetTitle imagURL:UrlArray[0] shareType:ShareTypePost shareID:GetPostID userID:@""];
      MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    [self presentViewController:formSheetController animated:YES completion:nil];
}

-(IBAction)SettingButton:(id)sender{
    NSLog(@"Setting Button Click.");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:GetPostName]) {
        //self
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:CustomLocalisedString(@"Edit", nil),CustomLocalisedString(@"Delete", nil), nil];
        
        [actionSheet showInView:self.view];
        
        actionSheet.tag = 300;
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:LocalisedString(@"Report"), nil];
        
        [actionSheet showInView:self.view];
        
        actionSheet.tag = 400;
    }
    
    

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"ShareToFacebook", nil)]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
            NSString *Description = [NSString stringWithFormat:@"%@",GetMessage];
            NSString *caption = [NSString stringWithFormat:@"SEETIES.ME"];
            
            // Check if the Facebook app is installed and we can present the share dialog
            FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
            params.link = [NSURL URLWithString:message];
            
            
            // If the Facebook app is installed and we can present the share dialog
            if ([FBDialogs canPresentShareDialogWithParams:params]) {
                
                // Present share dialog
                [FBDialogs presentShareDialogWithLink:params.link
                                              handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                  if(error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      // Success
                                                      NSLog(@"result %@", results);
                                                  }
                                              }];
                
                // If the Facebook app is NOT installed and we can't present the share dialog
            } else {
                // FALLBACK: publish just a link using the Feed dialog
                
                // Put together the dialog parameters
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"", @"name",
                                               caption, @"caption",
                                               Description, @"description",
                                               message, @"link",
                                               @"", @"picture",
                                               nil];
                
                // Show the feed dialog
                [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                       parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              if (error) {
                                                                  // An error occurred, we need to handle the error
                                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                                  NSLog(@"Error publishing story: %@", error.description);
                                                              } else {
                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                  } else {
                                                                      // Handle the publish feed callback
                                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                      
                                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                                          // User canceled.
                                                                          NSLog(@"User cancelled.");
                                                                          
                                                                      } else {
                                                                          // User clicked the Share button
                                                                          NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                          NSLog(@"result %@", result);
                                                                      }
                                                                  }
                                                              }
                                                          }];
            }
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"CopyLink", nil)]) {
            NSLog(@"Copy Link");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"I found %@ on Seeties. Let's try it together.\n\nhttps://seeties.me/post/%@",GetTitle,GetPostID];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
        }
        
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel", nil)]) {
            NSLog(@"Cancel Button");
        }
    }else if(actionSheet.tag == 300){
         NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel", nil)]) {
            NSLog(@"Cancel Button");
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Edit", nil)]) {
            NSLog(@"Edit Click");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [self OpenEdit];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Delete", nil)]) {
            NSLog(@"Delete Click");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"DeletePost", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Delete1", nil), nil];
            alert.tag = 500;
            [alert show];
            
        }
       
    }else if(actionSheet.tag == 400){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel", nil)]) {
            NSLog(@"Cancel Button");
        }
        if ([buttonTitle isEqualToString:LocalisedString(@"Report")]) {
            NSLog(@"Report Click");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [self OpenReport];
        }
    }else if(actionSheet.tag == 5000){
    //google translate
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"No thanks!", nil)]) {
            NSLog(@"Cancel Button");
        }
        if ([buttonTitle isEqualToString:LocalisedString(@"Read Original")]) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            if ([GetENMessageString length] == 0) {
            }else{
            [self CheckGoogleTranslateButton];
            }
            
        }
        if ([buttonTitle isEqualToString:LocalisedString(@"English by Google Translate")]) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [self CheckGoogleTranslateButton];

        }
    }else if(actionSheet.tag == 6000){
    //two language translate
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"No thanks!", nil)]) {
            NSLog(@"Cancel Button");
        }
        if ([buttonTitle isEqualToString:LocalisedString(@"Read Original")]) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [self CheckTwoLanguageButton];
        }
        if ([buttonTitle isEqualToString:ShowLanguageType]) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [self CheckTwoLanguageButton];
        }
        if ([buttonTitle isEqualToString:LocalisedString(@"English by Google Translate")]) {
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            [ShowActivity startAnimating];
            [self GetTranslateData];
        }
    }else if(actionSheet.tag == 80000){
        NSString *latlong = [[NSString alloc]initWithFormat:@"%@,%@",GetLat,GetLng];
                switch (buttonIndex) {
                    case 0:{
                        NSLog(@"Waze");
                        if ([[UIApplication sharedApplication]
                             canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                            
                            // Waze is installed. Launch Waze and start navigation
                            NSString *urlStr =
                            [NSString stringWithFormat:@"waze://?ll=%@&navigate=yes",
                             latlong];
                            
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                            
                        } else {
                            
                            // Waze is not installed. Launch AppStore to install Waze app
                            [[UIApplication sharedApplication] openURL:[NSURL
                                                                        URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
                        }
                    }
                        break;
                    case 1:{
                        NSLog(@"Google Maps");
                        if ([[UIApplication sharedApplication] canOpenURL:
                             [NSURL URLWithString:@"comgooglemaps://"]]) {
                            NSString *url = [NSString stringWithFormat: @"comgooglemaps://?q=%@&zoom=10",
                                             latlong];
                            
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        } else {
                            NSLog(@"Can't use comgooglemaps://");
                            NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                                             [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                    }
                        break;
                    case 2:{
                        NSLog(@"Apple Maps");
                        NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                                         [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                        break;
                    default:
                        break;
                }
        
    }
}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)OpenReport{
    ReportViewController *ReportView = [[ReportViewController alloc]init];
    [self presentViewController:ReportView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:ReportView animated:YES completion:nil];
    [ReportView GetPostID:GetPostID];
}

-(void)OpenEdit{
    
    [self.editPostViewController requestServerForPostInfo:GetPostID completionBLock:^{
        
       DraftModel* editPost = [[ConnectionManager dataManager] editPostModel];
        
        [self.editPostViewController initDataPostEdit:editPost];
        
        [self presentViewController:self.editPostViewController animated:YES completion:nil];

    }];
    

}

#pragma mark - declaration

-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [[ShareV2ViewController alloc]initWithNibName:@"ShareV2ViewController" bundle:nil];
    }
    
    return _shareV2ViewController;
}

-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
-(EditPostViewController*)editPostViewController
{
    if (!_editPostViewController) {
        _editPostViewController = [EditPostViewController new];
        _editPostViewController.editPostDoneBlock = ^(id object)
        {
                //FIXME: To Do write a refresh page for new feed details
        };
    }
    
    return _editPostViewController;
}

- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(IBAction)OpenAddressButton:(id)sender{

    NSLog(@"Open address click");
//    LocationFeedDetailViewController *LocationFeedDetailView = [[LocationFeedDetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:LocationFeedDetailView animated:NO completion:nil];
//    [LocationFeedDetailView GetLat:GetLat GetLong:GetLng GetFirstImage:[UrlArray objectAtIndex:0] GetTitle:GetPlaceName GetLocation:GetPlaceFormattedAddress ];
//    [LocationFeedDetailView GetLink:GetPlaceLink GetContact:GetContactNo GetOpeningHour:GetOpenNow GetPrice:GetExpense GetPeriods:GetPeriods];
    NSLog(@"ViewSeetishopButtonOnClick and SeetishopID = %@",GetSeetishopID);
    NSLog(@"GetPostID is %@ and GetLocationPlaceId is %@",GetPostID,GetLocationPlaceId);
    self.seetiesShopViewController = nil;
    [self.seetiesShopViewController initDataPlaceID:GetLocationPlaceId postID:GetPostID];
   // [self.seetiesShopViewController initDataWithSeetiesID:GetSeetishopID];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self.seetiesShopViewController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
-(IBAction)OpenLinkButton:(id)sender{
    
    NSLog(@"Open link click");
    if ([GetPlaceLink hasPrefix:@"http://"] || [GetPlaceLink hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetPlaceLink]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",GetPlaceLink];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }
}
-(IBAction)OpenContactButton:(id)sender{
    
    NSLog(@"Open contact click");
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:GetContactNo];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
}
-(IBAction)LanguageButton:(id)sender{
    NSLog(@"two language button on click.");
    ClickCount++;
    NSLog(@"ClickCount is %i",ClickCount);
    NSLog(@"[CountLanguageArray count] is %lu",(unsigned long)[CountLanguageArray count]);
    
    
    if ([CountLanguageArray count] == 0) {
        
    }else{
        
        if (ClickCount >= [CountLanguageArray count]) {
            ClickCount = 0;
            NSString *TempGetCount = [[NSString alloc]initWithFormat:@"%@",[CountLanguageArray objectAtIndex:ClickCount]];
            CheckLanguage = [TempGetCount integerValue];
        }else{
            
            NSString *TempGetCount = [[NSString alloc]initWithFormat:@"%@",[CountLanguageArray objectAtIndex:ClickCount]];
            CheckLanguage = [TempGetCount integerValue];
        }
        //
        //
        //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //    NSString *GetSystemLanguageCheck = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
        //    NSLog(@"GetSystemLanguageCheck is %@",GetSystemLanguageCheck);
        
        
        BOOL TranslateCheck = NO;
        for (int i = 0; i < [TempGetLanguageArray count]; i++) {
            NSString *GetLanguages = [[NSString alloc]initWithFormat:@"%@",[TempGetLanguageArray objectAtIndex:i]];
            
            if ([GetLanguages isEqualToString:@"530b0ab26424400c76000003"]) {
                TranslateCheck = NO;
                break;
            }else{
                TranslateCheck = YES;
                
            }
        }
        
        
        NSLog(@"TempGetLanguageArray is %@",TempGetLanguageArray);
        
        if (TranslateCheck == YES) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:CustomLocalisedString(@"No thanks!", nil)
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:CustomLocalisedString(@"Read Original", nil),ShowLanguageType,CustomLocalisedString(@"English by Google Translate", nil), nil];
            
            [actionSheet showInView:self.view];
            
            actionSheet.tag = 6000;
        }else{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:CustomLocalisedString(@"No thanks!", nil)
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:CustomLocalisedString(@"Read Original", nil),ShowLanguageType, nil];
            
            [actionSheet showInView:self.view];
            
            actionSheet.tag = 6000;
        }
        
        //[self InitNearbyPostView];
    }

}

-(void)CheckTwoLanguageButton{
    switch (CheckLanguage) {
        case 0:
            break;
        case 1:
            if ([EngTitle isEqualToString:@"(null)"] || [EngTitle length] == 0) {
                CheckLanguage = 2;
            }else{
                GetTitle = EngTitle;
                GetMessage = EndMessage;
                [LanguageButton setImage:[UIImage imageNamed:@"LanguageEng.png"] forState:UIControlStateNormal];
                CheckLanguage = 2;
            }
            
            break;
        case 2:
            if ([ChineseTitle isEqualToString:@"(null)"] || [ChineseTitle length] == 0) {
                CheckLanguage = 3;
            }else{
                GetTitle = ChineseTitle;
                GetMessage = ChineseMessage;
                [LanguageButton setImage:[UIImage imageNamed:@"LanguageChi.png"] forState:UIControlStateNormal];
                CheckLanguage = 3;
            }
            
            break;
        case 3:
            if ([ThaiTitle isEqualToString:@"(null)"] || [ThaiTitle length] == 0) {
                CheckLanguage = 4;
            }else{
                GetTitle = ThaiTitle;
                GetMessage = ThaiMessage;
                [LanguageButton setImage:[UIImage imageNamed:@"LanguageTh.png"] forState:UIControlStateNormal];
                CheckLanguage = 4;
            }
            
            break;
        case 4:
            if ([IndonesianTitle isEqualToString:@"(null)"] || [IndonesianTitle length] == 0) {
                CheckLanguage = 5;
            }else{
                GetTitle = IndonesianTitle;
                GetMessage = IndonesianMessage;
                [LanguageButton setImage:[UIImage imageNamed:@"LanguageInd.png"] forState:UIControlStateNormal];
                CheckLanguage = 5;
            }
            
            break;
        case 5:
            if ([PhilippinesTitle isEqualToString:@"(null)"] || [PhilippinesTitle length] == 0) {
                CheckLanguage = 1;
            }else{
                GetTitle = PhilippinesTitle;
                GetMessage = PhilippinesMessage;
                [LanguageButton setImage:[UIImage imageNamed:@"LanguagePh.png"] forState:UIControlStateNormal];
                CheckLanguage = 1;
            }
            
            break;
            
        default:
            break;
    }
    ShowMessage.text = GetMessage;
    ShowTitle.text = GetTitle;
    [self InitView];
}

-(IBAction)NewLanguageButton:(id)sender{
    TestingUse = YES;
    //[self InitView];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"No thanks!", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"Read Original", nil),CustomLocalisedString(@"English by Google Translate", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 5000;
    
    

    
}

-(void)CheckGoogleTranslateButton{
    
    if ([GetENMessageString length] == 0) {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        LoadingBlackBackground = [[UIButton alloc]init];
        [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
        LoadingBlackBackground.backgroundColor = [UIColor blackColor];
        LoadingBlackBackground.alpha = 0.5f;
        LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        [self.view addSubview:LoadingBlackBackground];
        [ShowActivity startAnimating];
        [self GetTranslateData];
    }else{
        if ([CheckENTranslation isEqualToString:@"1"]) {
            TestingUse = NO;
            CheckENTranslation = @"2";
            if ([ChineseMessage length] == 0 || ChineseMessage == nil || [ChineseMessage isEqualToString:@"(null)"]) {
                if ([EndMessage length] == 0 || EndMessage == nil || [EndMessage isEqualToString:@"(null)"]) {
                    if ([ThaiMessage length] == 0 || ThaiMessage == nil || [ThaiMessage isEqualToString:@"(null)"]) {
                        if ([IndonesianMessage length] == 0 || IndonesianMessage == nil || [IndonesianMessage isEqualToString:@"(null)"]) {
                            if ([PhilippinesMessage length] == 0 || PhilippinesMessage == nil || [PhilippinesMessage isEqualToString:@"(null)"]) {
                            }else{
                                GetMessage = PhilippinesMessage;
                                GetTitle = PhilippinesTitle;
                            }
                        }else{
                            GetMessage = IndonesianMessage;
                            GetTitle = IndonesianTitle;
                        }
                    }else{
                        GetMessage = ThaiMessage;
                        GetTitle = ThaiTitle;
                    }
                    
                }else{
                    GetMessage = EndMessage;
                    GetTitle = EngTitle;
                }
                
            }else{
                GetMessage = ChineseMessage;
                GetTitle = ChineseTitle;
            }
            ShowMessage.text = GetMessage;
            ShowTitle.text = GetTitle;
            [self InitView];
        }else{
            TestingUse = YES;
            CheckENTranslation = @"1";
            
            GetTitle = GetENTItleStirng;
            GetMessage = GetENMessageString;
            ShowMessage.text = GetMessage;
            ShowTitle.text = GetTitle;
            [self InitView];
        }
    }
}


-(void)GetTranslateData{
    [ShowActivity startAnimating];
//[self.spinnerView startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetSystemLanguageCheck = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
    
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
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@post/%@/translate?token=%@&translate_language_code=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken,GetSystemLanguageCode];
    
    
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
-(IBAction)OpenLikeProfileButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [ExpertsUserProfileView GetUsername:[Like_UsernameArray objectAtIndex:getbuttonIDN]];
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:[Like_UsernameArray objectAtIndex:getbuttonIDN]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[Like_UseruidArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
    
}
-(IBAction)OpenCommentProfileButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
//    UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
//    [ExpertsUserProfileView GetUsername:[User_Comment_usernameArray objectAtIndex:getbuttonIDN]];
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:[User_Comment_usernameArray objectAtIndex:getbuttonIDN]];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[User_Comment_uidArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(void)DeletePost{
    
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@?token=%@",DataUrl.UserWallpaper_Url,GetPostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_DeletePost = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_DeletePost) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //get back
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
    }else if(alertView.tag == 500){
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self DeletePost];
        }
    }else if(alertView.tag == 1200){
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self SendFollowingData];
        }
    }
    
}
-(IBAction)CollectButtonOnClick:(id)sender{
    NSLog(@"Quick CollectButtonOnClick");
    
    
    if ([GetCollectCheck isEqualToString:@"0"]) {
        AllCollectButton.selected = !AllCollectButton.selected;
        GetCollectCheck = @"1";
        [self SendQuickCollect];
    }else{
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        [self presentViewController:AddCollectionDataView animated:YES completion:nil];
       // [self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:GetPostID GetImageData:[UrlArray objectAtIndex:0]];
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
-(IBAction)AddCollectButtonOnClick:(id)sender{
    NSLog(@"Add Collection Button On Click");
    AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
    [self presentViewController:AddCollectionDataView animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
    [AddCollectionDataView GetPostID:GetPostID GetImageData:[UrlArray objectAtIndex:0]];
}
-(IBAction)PersonalTagsButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *GetTagsString = [[NSString alloc]initWithFormat:@"#%@",[ArrHashTag objectAtIndex:getbuttonIDN]];
    NSLog(@"ArrHashTag is %@",GetTagsString);
    
    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
    [self.navigationController pushViewController:SearchDetailView animated:YES];
    [SearchDetailView GetSearchKeyword:GetTagsString Getlat:@"" GetLong:@"" GetLocationName:@"" GetCurrentLat:@"" GetCurrentLong:@""];
}
-(IBAction)BlogLinkButtonOnClick:(id)sender{
    if ([GetLink hasPrefix:@"http://"] || [GetLink hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetLink]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",GetLink];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }
}
-(IBAction)OpenCollectionButtonOnClick:(id)sender{
    
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    
    CollectionViewController *OpenCollectionView = [[CollectionViewController alloc]init];
    [self.navigationController pushViewController:OpenCollectionView animated:YES];
    [OpenCollectionView GetCollectionID:[arrCollectionID objectAtIndex:getbuttonIDN] GetPermision:@"User" GetUserUid:[arrUserID objectAtIndex:getbuttonIDN]];
}
-(IBAction)CollectionUserProfileOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[arrUsername objectAtIndex:getbuttonIDN]];
    NSLog(@"CollectionUserProfileOnClick Getname is %@",Getname);
    
//    NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
//    [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
//    [NewUserProfileV2View GetUserName:Getname];
    _profileViewController = nil;
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[arrUserID objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];

}
-(IBAction)CollectionFollowingButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    

    
    NSLog(@"Get Collection User ID == %@",[arrUserID objectAtIndex:getbuttonIDN]);
    NSLog(@"Get Collection Following == %@",[arrFollowing objectAtIndex:getbuttonIDN]);
    GetCollectionFollowing = [[NSString alloc]initWithFormat:@"%@",[arrFollowing objectAtIndex:getbuttonIDN]];
    GetCollectUserID = [[NSString alloc]initWithFormat:@"%@",[arrUserID objectAtIndex:getbuttonIDN]];
    GetCollectID = [[NSString alloc]initWithFormat:@"%@",[arrCollectionID objectAtIndex:getbuttonIDN]];
    
    if ([GetCollectionFollowing isEqualToString:@"0"]) {
        UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
        buttonWithTag1.selected = !buttonWithTag1.selected;
        [self FollowCollection];
        [arrFollowing replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
    }else{

        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
                buttonWithTag1.selected = !buttonWithTag1.selected;
                [self DeleteFollowCollection];
                [arrFollowing replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
                
                
            }
        }];
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
-(IBAction)SeeAllButtonOnClick:(id)sender{
    NSLog(@"SeeAllButtonOnClick");
    _collectionListingViewController = nil;
    
    ProfileModel* model = [ProfileModel new];
    model.uid = [Utils getUserID];
    [self.collectionListingViewController setType:ProfileViewTypeOthers ProfileModel:model NumberOfPage:1 collectionType:CollectionListingTypeSuggestion];
    [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
}
-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}
-(SeetiesShopViewController*)seetiesShopViewController
{
    
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    return _seetiesShopViewController;
}
-(IBAction)OpenMapButtonOnClick:(id)sender{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalisedString(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:
                            @"Waze",
                            @"Google Maps",
                            @"Apple Maps",
                            nil];
    popup.tag = 80000;
    [popup showInView:self.view];
}
-(IBAction)ViewSeetishopButtonOnClick:(id)sender{

   // NSLog(@"ViewSeetishopButtonOnClick and SeetishopID = %@",GetSeetishopID);
   // NSLog(@"GetPostID is %@ and GetLocationPlaceId is %@",GetPostID,GetLocationPlaceId);
    _seetiesShopViewController = nil;
    [self.seetiesShopViewController initDataWithSeetiesID:GetSeetishopID];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:self.seetiesShopViewController];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
-(IBAction)LanguageButtonOnClick:(id)sender{

    NSLog(@"NEW Language Button On Click");
    TestingUse = YES;
    //[self InitView];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"No thanks!", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"Read Original", nil),CustomLocalisedString(@"English by Google Translate", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 5000;
}

@end

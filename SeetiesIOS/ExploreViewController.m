//
//  ExploreViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ExploreViewController.h"
#import "AsyncImageView.h"
#import "SearchViewController.h"
#import "ExploreCountryViewController.h"
#import "NotificationViewController.h"
#import "LandingViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
#import "SearchViewV2.h"
#import "ExploreCountryV2ViewController.h"
#import "SelectImageViewController.h"
#import "OpenWebViewController.h"
#import "LLARingSpinnerView.h"
#import "NSAttributedString+DVSTracking.h"
#import "SearchDetailViewController.h"
@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 84);
    IconImage.frame = CGRectMake(screenWidth - 22 - 15, 39, 22, 22);
    SearchBox.frame = CGRectMake(15, 27, screenWidth - 70, 44);
    SearchButton.frame = CGRectMake(15, 27, screenWidth - 70, 44);
    FindPPLButton.frame = CGRectMake(screenWidth - 52, 0, 52, 84);
    
    MainScroll.frame = CGRectMake(0, 84, screenWidth, screenHeight - 124);
    
    DataUrl = [[UrlDataClass alloc]init];
    [self GetExploreDataFromServer];
    
    ShowTitle.text = CustomLocalisedString(@"ExplorePage_Title", nil);
    ShowSubTitle.text = CustomLocalisedString(@"ExplorePage_SubTitle", nil);
    SearchLocation.placeholder = CustomLocalisedString(@"Entersearchlocation", nil);
    
//    ShowBadgeText = [[UILabel alloc]init];
//    ShowBadgeText.frame = CGRectMake(26, 22, 20, 20);
//    ShowBadgeText.layer.cornerRadius = 10;
//    ShowBadgeText.layer.masksToBounds = YES;
//    ShowBadgeText.backgroundColor = [UIColor redColor];
//    ShowBadgeText.textAlignment = NSTextAlignmentCenter;
//    ShowBadgeText.textColor = [UIColor whiteColor];
//    ShowBadgeText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
//    ShowBadgeText.hidden = YES;
//    [self.view addSubview:ShowBadgeText];
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    CheckLoadDone = NO;

}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewDidAppear:(BOOL)animated{
    self.screenName = @"IOS Explore Page";
    //self.title = CustomLocalisedString(@"MainTab_Explore",nil);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    if (screenWidth > 320) {
        NSLog(@"iphone 6 / iphone 6 plus");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 175 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed.png"];
        [self.tabBarController.view addSubview:ShowImage_Feed];
        
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 100, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore_on.png"];
        [self.tabBarController.view addSubview:ShowImage_Explore];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake((screenWidth / 2) - 25, screenHeight - 50, 50, 50);
        ShowImage.image = [UIImage imageNamed:@"TabBarNew.png"];
        [self.tabBarController.view addSubview:ShowImage];
        
        UIImageView *ShowImage_Collecation = [[UIImageView alloc]init];
        ShowImage_Collecation.frame = CGRectMake((screenWidth / 2) + 50, screenHeight - 50, 50, 50);
        ShowImage_Collecation.image = [UIImage imageNamed:@"TabBarActivity.png"];
        [self.tabBarController.view addSubview:ShowImage_Collecation];
        
        UIImageView *ShowImage_Profile = [[UIImageView alloc]init];
        ShowImage_Profile.frame = CGRectMake((screenWidth / 2) + 125, screenHeight - 50, 50, 50);
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile.png"];
        [self.tabBarController.view addSubview:ShowImage_Profile];
    }else{
        NSLog(@"iphone 5 / iphone 5s / iphone 4");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 153 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed.png"];
        [self.tabBarController.view addSubview:ShowImage_Feed];
        
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 89, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore_on.png"];
        [self.tabBarController.view addSubview:ShowImage_Explore];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake((screenWidth / 2) - 25, screenHeight - 50, 50, 50);
        ShowImage.image = [UIImage imageNamed:@"TabBarNew.png"];
        [self.tabBarController.view addSubview:ShowImage];
        
        UIImageView *ShowImage_Collecation = [[UIImageView alloc]init];
        ShowImage_Collecation.frame = CGRectMake((screenWidth / 2) + 39, screenHeight - 50, 50, 50);
        ShowImage_Collecation.image = [UIImage imageNamed:@"TabBarActivity.png"];
        [self.tabBarController.view addSubview:ShowImage_Collecation];
        
        UIImageView *ShowImage_Profile = [[UIImageView alloc]init];
        ShowImage_Profile.frame = CGRectMake((screenWidth / 2) + 106, screenHeight - 50, 50, 50);
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile.png"];
        [self.tabBarController.view addSubview:ShowImage_Profile];
    }
    UIButton *BackToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackToTopButton.frame = CGRectMake(0, screenHeight - 50, 80, 50);
    [BackToTopButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [BackToTopButton setBackgroundColor:[UIColor clearColor]];
    [BackToTopButton addTarget:self action:@selector(BackToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:BackToTopButton];
    
    UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SelectButton.frame = CGRectMake((screenWidth/2) - 40, screenHeight - 50, 80, 50);
    [SelectButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [SelectButton setBackgroundColor:[UIColor clearColor]];
    [SelectButton addTarget:self action:@selector(ChangeViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:SelectButton];
    
    if (CheckLoadDone == NO) {
//        spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//        spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//        spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//        spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        spinnerView.lineWidth = 1.0f;
//        [self.view addSubview:spinnerView];
//        [spinnerView startAnimating];
        [ShowActivity startAnimating];
    }

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_Category"];
    //GetNotifactionCountTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(CheckNotificationCount) userInfo:nil repeats:YES];
}
-(IBAction)BackToTopButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}
-(IBAction)ChangeViewButton:(id)sender{
    NSLog(@"ChangeViewButton Click");
    //    SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
    //    [self presentViewController:SelectImageView animated:YES completion:nil];
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
    cont.nMaxCount = 10;
    cont.nColumnCount = 3;
    
    [self presentViewController:cont animated:YES completion:nil];
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    ShowBadgeText.hidden = YES;
    [GetNotifactionCountTimer invalidate];
    GetNotifactionCountTimer = nil;
    
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)SearchButton:(id)sender{
//    SearchViewController *SearchView = [[SearchViewController alloc]init];
//    [self presentViewController:SearchView animated:YES completion:nil];
    SearchViewV2 *SearchView = [[SearchViewV2 alloc]init];
    [self presentViewController:SearchView animated:YES completion:nil];
}
-(void)GetExploreDataFromServer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.Explore_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
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
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Explore return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Explore Json = %@",res);
        
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
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"countries"];
                
                CountryIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                SeqNoArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                ThumbnailArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                for (NSDictionary * dict in GetAllData){
                    NSString *country_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country_id"]];
                    [CountryIDArray addObject:country_id];
                    NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [NameArray addObject:name];
                    NSString *seq_no = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"seq_no"]];
                    [SeqNoArray addObject:seq_no];
                    NSString *thumbnail = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"thumbnail"]];
                    [ThumbnailArray addObject:thumbnail];
                }
                //NSLog(@"NameArray is %@",NameArray);
                
                [self InitView];
            }
        }
        
        
        

    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"GetNotificationCount return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Explore Json = %@",res);
        
        NSString *GetCountString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
        NSLog(@"GetCountString is %@",GetCountString);
        
        if ([GetCountString isEqualToString:@"0"] || [GetCountString isEqualToString:@"(null)"]) {

        }else{
            ShowBadgeText.hidden = NO;
            ShowBadgeText.text = GetCountString;
        }
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetBackCheckAPI = [defaults objectForKey:@"CheckAPI"];

            //cancel clicked ...do your action
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
            for (NSString *key in [defaultsDictionary allKeys]) {
                NSLog(@"removing user pref for %@", key);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            
            //save back
            [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
            [defaults synchronize];
            
            LandingViewController *LandingView = [[LandingViewController alloc]init];
            [self presentViewController:LandingView animated:YES completion:nil];
        }else{
            //reset clicked
        }
    }
    
}
-(IBAction)LetsgoButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"Festival"];
}
-(void)InitView{
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//    UIImage *TempImage = [[UIImage alloc]init];
//    TempImage = [UIImage imageNamed:@"BannerFestival.png"];
//    
//    UIImageView *FestivalImage = [[UIImageView alloc]init];
//    FestivalImage.image = TempImage;
//    FestivalImage.frame = CGRectMake(0, 0, screenWidth, TempImage.size.height);
//    [MainScroll addSubview:FestivalImage];
//    
//    
////    UIImageView *WordImage = [[UIImageView alloc]init];
////    WordImage.image = [UIImage imageNamed:@"BannerWord.png"];
////    WordImage.frame = CGRectMake(39, 20, 241, 72);
////    [MainScroll addSubview:WordImage];
//    
//    UILabel *ShowBigText = [[UILabel alloc]init];
//    ShowBigText.frame = CGRectMake(15, 20, screenWidth - 30, 72);
//    ShowBigText.text = CustomLocalisedString(@"Festival", nil);
//    ShowBigText.textAlignment = NSTextAlignmentCenter;
//    ShowBigText.textColor = [UIColor whiteColor];
//    ShowBigText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:36];
//    [MainScroll addSubview:ShowBigText];
//    
//    UILabel *ShowSubText = [[UILabel alloc]init];
//    ShowSubText.frame = CGRectMake(15, 75, screenWidth - 30, 40);
//    ShowSubText.text = CustomLocalisedString(@"DiscovertheColors", nil);
//    ShowSubText.textAlignment = NSTextAlignmentCenter;
//    ShowSubText.textColor = [UIColor whiteColor];
//    ShowSubText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:18];
//    [MainScroll addSubview:ShowSubText];
//    
//    UIButton *FestivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [FestivalButton setImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
//    [FestivalButton setFrame:CGRectMake((screenWidth/2) - 70, 120, 140, 47)];
//    [FestivalButton setBackgroundColor:[UIColor clearColor]];
//    [FestivalButton addTarget:self action:@selector(LetsgoButton:) forControlEvents:UIControlEventTouchUpInside];
//    [MainScroll addSubview:FestivalButton];
    
//    UILabel *ShowTitleName = [[UILabel alloc]init];
//    ShowTitleName.frame = CGRectMake(15,10, screenWidth - 30, 40);
//    ShowTitleName.text = CustomLocalisedString(@"TopRecommendations", nil);
////    ShowTitleName.attributedText = [NSAttributedString dvs_attributedStringWithString:CustomLocalisedString(@"TopRecommendations", nil)
////                                                                                   tracking:100
////                                                                                       font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
//    
//    ShowTitleName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//    ShowTitleName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
//    ShowTitleName.backgroundColor = [UIColor clearColor];
//    ShowTitleName.textAlignment = NSTextAlignmentCenter;
//    [MainScroll addSubview:ShowTitleName];
    
    int GetHeight = 10;
    NSLog(@"GetHeight is %i",GetHeight);
    int heightGet = 0;
    int TestWidth = screenWidth - 30;
    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 2;
    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 10;
    
    for (int i = 0; i < 6; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        imageView.tag = 99;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[ThumbnailArray objectAtIndex:i]];
        //        //    //  NSLog(@"FullImagesURL ====== %@",FullImagesURL);
        NSURL *url = [NSURL URLWithString:FullImagesURL];
        imageView.imageURL = url;
        
        UIButton *BackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
        [BackgroundButton setFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        [BackgroundButton setBackgroundColor:[UIColor blackColor]];
        BackgroundButton.alpha = 0.5f;
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(((FinalWidth/2) - 50 )+(i % 2)*SpaceWidth, ((FinalWidth/2) - 30 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), 120, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(10+(i % 2)*SpaceWidth, ((FinalWidth/2) - 20 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, 40);
        NSString *uppercase = [[NameArray objectAtIndex:i] uppercaseString];
        ShowUserName.text = uppercase;
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        ShowUserName.textColor = [UIColor whiteColor];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textAlignment = NSTextAlignmentCenter;
        [MainScroll addSubview:ShowUserName];
        
        UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line02 setTitle:@"" forState:UIControlStateNormal];
        [Line02 setFrame:CGRectMake(((FinalWidth/2) - 50 )+(i % 2)*SpaceWidth, ((FinalWidth/2) + 30 + GetHeight) + (SpaceWidth * (CGFloat)(i /2)), 120, 1)];
        [Line02 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(10+(i % 2)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /2)), FinalWidth, FinalWidth)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:imageView];
        [MainScroll addSubview:BackgroundButton];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line02];
        [MainScroll addSubview:ClickButton];
        


        heightGet = GetHeight + (SpaceWidth * (CGFloat)(i /2)) + SpaceWidth;
    }
    
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    imageView.tag = 99;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[ThumbnailArray lastObject]];
    NSURL *url = [NSURL URLWithString:FullImagesURL];
    imageView.imageURL = url;
    
    UIButton *BackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
    [BackgroundButton setFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    [BackgroundButton setBackgroundColor:[UIColor blackColor]];
    BackgroundButton.alpha = 0.5f;
    
    UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setFrame:CGRectMake((screenWidth/2) - 60, heightGet + 40, 120, 1)];
    [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
    
    UILabel *ShowUserName = [[UILabel alloc]init];
    ShowUserName.frame = CGRectMake(15, heightGet + 50, screenWidth - 30, 40);
    NSString *uppercase = [[NameArray lastObject] uppercaseString];
    ShowUserName.text = uppercase;
    ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    ShowUserName.textColor = [UIColor whiteColor];
    ShowUserName.backgroundColor = [UIColor clearColor];
    ShowUserName.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowUserName];
    
    UIButton *Line02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setFrame:CGRectMake((screenWidth/2) - 60, heightGet + 99, 120, 1)];
    [Line02 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:0.3f]];
    
    UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ClickButton setTitle:@"" forState:UIControlStateNormal];
    [ClickButton setFrame:CGRectMake(10, heightGet, screenWidth - 20, 150)];
    [ClickButton setBackgroundColor:[UIColor clearColor]];
    [ClickButton addTarget:self action:@selector(ClickButton2:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainScroll addSubview:imageView];
    [MainScroll addSubview:BackgroundButton];
    [MainScroll addSubview:Line01];
    [MainScroll addSubview:ShowUserName];
    [MainScroll addSubview:Line02];
    [MainScroll addSubview:ClickButton];
    
    heightGet += 160;
    
    
        UIImage *TempImage = [[UIImage alloc]init];
        TempImage = [UIImage imageNamed:@"BannerFestival.png"];
    
        UIImageView *FestivalImage = [[UIImageView alloc]init];
        FestivalImage.image = TempImage;
        FestivalImage.frame = CGRectMake(10, heightGet, screenWidth - 20, TempImage.size.height);
        [MainScroll addSubview:FestivalImage];
    
        UILabel *ShowBigText = [[UILabel alloc]init];
        ShowBigText.frame = CGRectMake(15, heightGet + 20, screenWidth - 30, 72);
        ShowBigText.text = CustomLocalisedString(@"Festival", nil);
        ShowBigText.textAlignment = NSTextAlignmentCenter;
        ShowBigText.textColor = [UIColor whiteColor];
        ShowBigText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:36];
        [MainScroll addSubview:ShowBigText];
    
        UILabel *ShowSubText = [[UILabel alloc]init];
        ShowSubText.frame = CGRectMake(15, heightGet + 75, screenWidth - 30, 40);
        ShowSubText.text = CustomLocalisedString(@"DiscovertheColors", nil);
        ShowSubText.textAlignment = NSTextAlignmentCenter;
        ShowSubText.textColor = [UIColor whiteColor];
        ShowSubText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:18];
        [MainScroll addSubview:ShowSubText];
    
    
        UIButton *FestivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
       // [FestivalButton setImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
        [FestivalButton setBackgroundImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
        [FestivalButton setTitle:CustomLocalisedString(@"Letsgo", nil) forState:UIControlStateNormal];
        [FestivalButton setFrame:CGRectMake((screenWidth/2) - 70, heightGet + 120, 140, 47)];
        [FestivalButton setBackgroundColor:[UIColor clearColor]];
        [FestivalButton addTarget:self action:@selector(LetsgoButton:) forControlEvents:UIControlEventTouchUpInside];
        [FestivalButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [MainScroll addSubview:FestivalButton];
    
    
    [MainScroll setContentSize:CGSizeMake(320, heightGet + TempImage.size.height + 10)];
    
    CheckLoadDone = YES;
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];

}
-(IBAction)ClickButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    ExploreCountryV2ViewController *ExploreCountryView = [[ExploreCountryV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExploreCountryView animated:NO completion:nil];
    [ExploreCountryView GetCountryName:[NameArray objectAtIndex:getbuttonIDN] GetCountryIDN:[CountryIDArray objectAtIndex:getbuttonIDN]];
    
    
}
-(IBAction)ClickButton2:(id)sender{
    ExploreCountryV2ViewController *ExploreCountryView = [[ExploreCountryV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExploreCountryView animated:NO completion:nil];
    [ExploreCountryView GetCountryName:[NameArray lastObject] GetCountryIDN:[CountryIDArray lastObject]];
    
    
}
-(IBAction)NotificationButton:(id)sender{
    NotificationViewController *NotificationView = [[NotificationViewController alloc]init];
    [self presentViewController:NotificationView animated:YES completion:nil];
}
-(void)CheckNotificationCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.GetNotificationCount_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_CheckNotification = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CheckNotification start];
    
    
    if( theConnection_CheckNotification ){
        webData = [NSMutableData data];
    }
}
-(IBAction)FindPPlButton:(id)sender{
    NSLog(@"Find PPl Button Click");
    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.2;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:SearchDetailView animated:YES completion:nil];
    [SearchDetailView GetAllUserSuggestions:@"All"];
    [SearchDetailView GetTitle:@"Find People"];
}
@end

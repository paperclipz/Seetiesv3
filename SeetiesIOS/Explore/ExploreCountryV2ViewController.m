//
//  ExploreCountryV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ExploreCountryV2ViewController.h"
#import "FeedV2DetailViewController.h"
#import "SearchViewV2.h"
#import "UserProfileV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Filter2ViewController.h"
#import "NSAttributedString+DVSTracking.h"
@interface ExploreCountryV2ViewController ()

@end

@implementation ExploreCountryV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     DataUrl = [[ UrlDataClass alloc]init];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SearchButton.frame = CGRectMake(screenWidth - 65 - 15, 20, 65, 44);
    lblTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    MainScroll.delegate = self;
    UserScroll.delegate = self;
   
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    UserScroll.frame = CGRectMake(0, 0, screenWidth, 280);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
   // [SearchButton setTitle:CustomLocalisedString(@"Search", nil) forState:UIControlStateNormal];
    [SearchButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    
    CheckLoad_Explore = NO;
    CheckFirstTimeLoad = 0;
    TotalPage = 1;
    CurrentPage = 0;
    
    CheckLoadDone = NO;
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionRight;
    [MainScroll addGestureRecognizer:swipeleft];
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Explore_Category"];
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        
    }else{
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in UserScroll.subviews) {
            [subview removeFromSuperview];
        }
        
        [MainScroll addSubview:UserScroll];
        TotalPage = 1;
        CurrentPage = 0;
        DataCount = 0;
        DataTotal = 0;
        CheckLoadDone = NO;
       // [self GetFeaturedUserData];
        [self GetFeaturedUserData];
    }
    
    
    if (CheckLoadDone == NO) {

        [ShowActivity startAnimating];
    }else{
    
    }

    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)initData{
    DataUrl = [[UrlDataClass alloc]init];
    
    
    lblTitle.text =  self.model.name;
    
   // [self GetDataFromServer];
   // [self InitView];
    [self GetFeaturedUserData];
}

-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (UIView *subview in UserScroll.subviews) {
        //  [subview removeFromSuperview];
        if ([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }
    
    int GetHeight = 0;
    if ([User_IDArray count] == 0) {
        UserScroll.hidden = YES;
    }else{
        UserScroll.hidden = NO;
        GetHeight = 280;
        
        
        
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",CustomLocalisedString(@"FeaturedUserin", nil)];
        
        UILabel *ShowFeaturedUserTitle = [[UILabel alloc]init];
        ShowFeaturedUserTitle.frame = CGRectMake(15, 0, screenWidth - 30, 60);
        ShowFeaturedUserTitle.text = TempString;
//        ShowFeaturedUserTitle.attributedText = [NSAttributedString dvs_attributedStringWithString:[TempString uppercaseString]
//                                                                                 tracking:100
//                                                                                     font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        
        ShowFeaturedUserTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowFeaturedUserTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowFeaturedUserTitle.textAlignment = NSTextAlignmentCenter;
       // ShowFeaturedUserTitle.backgroundColor = [UIColor redColor];
        [MainScroll addSubview:ShowFeaturedUserTitle];
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, 279, screenWidth, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
        [MainScroll addSubview:Line01];
        
        for (int i = 0; i < [User_IDArray count]; i++) {
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(25 + i * 105, 60, 60, 60);
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=30;
            ShowUserProfileImage.layer.borderWidth=0;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
            [UserScroll addSubview:ShowUserProfileImage];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
            if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            ShowUserProfileImage.imageURL = url_NearbySmall;
            }
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(15 + i * 105, 120, 85, 30);
            ShowUserName.text = [User_UserNameArray objectAtIndex:i];
            ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowUserName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
            ShowUserName.textAlignment = NSTextAlignmentCenter;
            [UserScroll addSubview:ShowUserName];
            
            UILabel *ShowUserLocation = [[UILabel alloc]init];
            ShowUserLocation.frame = CGRectMake(15 + i * 105, 140, 85, 40);
            ShowUserLocation.text = [User_LocationArray objectAtIndex:i];
            ShowUserLocation.backgroundColor = [UIColor clearColor];
            ShowUserLocation.textAlignment = NSTextAlignmentCenter;
            ShowUserLocation.numberOfLines = 2;
            ShowUserLocation.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            [UserScroll addSubview:ShowUserLocation];
            
            //follow button
            ShowFollowButton = [[UIButton alloc]init];
            ShowFollowButton.frame = CGRectMake(35 + i * 105, 200, 40, 40);
            ShowFollowButton.tag = i;
            NSString *GetFollow = [[NSString alloc]initWithFormat:@"%@",[User_FollowArray objectAtIndex:i]];
            if ([GetFollow isEqualToString:@"0"]) {
                [ShowFollowButton setImage:[UIImage imageNamed:@"FollowMini.png"] forState:UIControlStateNormal];
            }else{
                [ShowFollowButton setImage:[UIImage imageNamed:@"FollowingMini.png"] forState:UIControlStateNormal];
            }
            [ShowFollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
            [UserScroll addSubview:ShowFollowButton];
            
            UIButton *OpenProfileButton  = [[UIButton alloc]init];
            OpenProfileButton.frame = CGRectMake(25 + i * 105, 60, 60, 100);
            OpenProfileButton.tag = i;
            [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
            [OpenProfileButton setBackgroundColor:[UIColor clearColor]];
            [OpenProfileButton addTarget:self action:@selector(OpenProfileButton:) forControlEvents:UIControlEventTouchUpInside];
            [UserScroll addSubview:OpenProfileButton];
            
            [UserScroll setContentSize:CGSizeMake(100 + i * 105, 260)];
        }
        [UserScroll setContentOffset:CGPointMake((UserScroll.contentSize.width / 2) / 2, 0) animated:NO];

    }
    
    UILabel *ShowTopRecommendationsLabel = [[UILabel alloc]init];
    ShowTopRecommendationsLabel.frame = CGRectMake(15, GetHeight, screenWidth - 30, 60);
    ShowTopRecommendationsLabel.text = CustomLocalisedString(@"TopRecommendations", nil);
//    ShowTopRecommendationsLabel.attributedText = [NSAttributedString dvs_attributedStringWithString:CustomLocalisedString(@"TopRecommendations", nil)
//                                                                                     tracking:100
//                                                                                         font:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    ShowTopRecommendationsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    ShowTopRecommendationsLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
    ShowTopRecommendationsLabel.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowTopRecommendationsLabel];
    

    
    GetHeight += 60;
    
    int TestWidth = screenWidth - 2;
    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 1;
    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 1;

    for (NSInteger i = DataCount; i < DataTotal; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            //NSLog(@"url is %@",url);
            ShowImage.imageURL = url_NearbySmall;
        }
        [MainScroll addSubview:ShowImage];
        
        
        UIButton *ImageButton = [[UIButton alloc]init];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:ImageButton];
        [MainScroll setContentSize:CGSizeMake(320, GetHeight + FinalWidth + (SpaceWidth * (CGFloat)(i /3)))];
    }
    
    CheckLoadDone = YES;
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];
}
-(IBAction)ImageButtonOnClick:(id)sender{
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
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)FollowButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    GetUserID = [User_IDArray objectAtIndex:getbuttonIDN];
    GetFollowString = [User_FollowArray objectAtIndex:getbuttonIDN];
    
    
    if ([GetFollowString isEqualToString:@"0"]) {
        [User_FollowArray replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        [self SendFollowingData];
    }else{
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",CustomLocalisedString(@"StopFollowing", nil),[User_UserNameArray objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:tempStirng delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Unfollow", nil), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
        [User_FollowArray replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
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
-(void)GetFeaturedUserData{
    //[ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/country/%d/users?token=%@&featured=0",DataUrl.Explore_Url, self.model.countryID,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetUserData start];
    
    
    if( theConnection_GetUserData ){
        webData = [NSMutableData data];
    }
}
-(void)GetDataFromServer{
   // [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *GetSortByString = [defaults objectForKey:@"Filter_Explore_SortBy"];
        NSString *GetCategoryString = [defaults objectForKey:@"Filter_Explore_Category"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@/country/%d/posts?token=%@&featured=0&page=%li",DataUrl.Explore_Url, self.model.countryID,GetExpertToken,CurrentPage];
        
        
        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
        }
        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
        }
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"Explore Country check postBack URL ==== %@",postBack);
        //   NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        theConnection_GetCountryData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetCountryData start];
        
        
        if( theConnection_GetCountryData ){
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
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];
    // [ProgressHUD showError:@"Something went wrong."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetCountryData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"ExploreCountry return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    //    NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"System Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
                NSDictionary *GetAllData = [res valueForKey:@"posts"];
         //       NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"page"]];
                NSLog(@"Temppage is %@",Temppage);
                NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_page"]];
                NSLog(@"Temptotal_page is %@",Temptotal_page);
                NSString *TempCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"list_size"]];
                NSLog(@"TempCount is %@",TempCount);
                CurrentPage = [Temppage intValue];
                TotalPage = [Temptotal_page intValue];
                
                if (CheckFirstTimeLoad == 0) {
                    PostIDArray = [[NSMutableArray alloc]init];
                    PhotoArray = [[NSMutableArray alloc]init];
                    DataCount = 0;
                    
                }else{
                    
                }
                
                NSDictionary *GetPostData = [GetAllData valueForKey:@"posts"];
                // NSLog(@"GetPostData ===== %@",GetPostData);
                
              //  PostIDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetPostData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostIDArray addObject:PlaceID];
                }
      //          NSLog(@"PostIDArray is %@",PostIDArray);
                NSArray *PhotoData = [GetPostData valueForKey:@"photos"];
                //NSLog(@"PhotoData is %@",PhotoData);
                
               // PhotoArray = [[NSMutableArray alloc]init];
                
                for (NSDictionary * dict in PhotoData) {
                    NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict_ in dict) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                        
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                        [UrlArray addObject:url];
                    }
                    NSString *result2 = [UrlArray componentsJoinedByString:@","];
                    [PhotoArray addObject:result2];
                }
                
                DataCount = DataTotal;
                DataTotal = [PostIDArray count];
                
       //         NSLog(@"DataCount in get server data === %li",(long)DataCount);
       //         NSLog(@"DataTotal in get server data === %li",(long)DataTotal);
       //         NSLog(@"CheckFirstTimeLoadLikes === %li",(long)CheckFirstTimeLoad);
                //[self InitView];
                CheckLoad_Explore = NO;
                
                [self InitView];
            }
        }
    }else if(connection == theConnection_GetUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
   //     NSLog(@"ExploreCountry User return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
   //     NSLog(@"Feed Json = %@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"System Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSDictionary *GetAllData = [res valueForKey:@"featured_users"];
          //      NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSArray *UserData = [GetAllData valueForKey:@"users"];
                User_LocationArray = [[NSMutableArray alloc]init];
                User_IDArray = [[NSMutableArray alloc]init];
                User_NameArray = [[NSMutableArray alloc]init];
                User_ProfileImageArray = [[NSMutableArray alloc]init];
                User_FollowArray = [[NSMutableArray alloc]init];
                User_UserNameArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in UserData) {
                    NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"location"]];
                    [User_LocationArray addObject:location];
                    NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"uid"]];
                    [User_IDArray addObject:uid];
                    NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"name"]];
                    [User_NameArray addObject:name];
                    NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"profile_photo"]];
                    [User_ProfileImageArray addObject:profile_photo];
                    NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"followed"]];
                    [User_FollowArray addObject:followed];
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"username"]];
                    [User_UserNameArray addObject:username];
                }
                NSLog(@"User_NameArray is %@",User_NameArray);
                [self GetDataFromServer];
              //  NSLog(@"User_LocationArray is %@",User_LocationArray);
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
            
           [self InitView];
            
        }
    }
    
}
-(IBAction)SearchButton:(id)sender{
    SearchViewV2 *SearchView = [[SearchViewV2 alloc]init];
    [self presentViewController:SearchView animated:YES completion:nil];
}
-(IBAction)OpenProfileButton:(id)sender{
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
    [ExpertsUserProfileView GetUsername:[User_UserNameArray objectAtIndex:getbuttonIDN]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == MainScroll) {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            // we are at the end
            NSLog(@"we are at the end");
            
                    CheckLoad_Explore = YES;
                    if (CurrentPage == TotalPage) {
                        
                    }else{
                        
                        [self GetDataFromServer];
                    }
                    
            
            
            
        }
    }
}
-(IBAction)FilterButton:(id)sender{
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    [self presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Explore"];
}
@end

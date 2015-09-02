//
//  NotificationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "NotificationViewController.h"
#import "AsyncImageView.h"
#import "UserProfileV2ViewController.h"
#import "FeedV2DetailViewController.h"
#import "SelectImageViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowActivity.frame = CGRectMake(screenWidth - 20 - 15, 32, 20, 20);
    
    ShowNoDataText_1.frame = CGRectMake(15, (screenHeight / 2) - 31 - 20 - 21, screenWidth - 30, 21);
    ShowNoDataText_2.frame = CGRectMake((screenWidth/2) - 126, (screenHeight / 2) - 31, 253, 62);
    ShowNoDataText_1.text = CustomLocalisedString(@"NoNotification", nil);
    ShowNoDataText_2.text = CustomLocalisedString(@"NoNotificationDetail", nil);
    
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 104);
    MainScroll.alwaysBounceVertical = YES;
    TitleLabel.text = @"Activity";
    ShowNoDataView.hidden = YES;
    ShowNoDataView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    NoDataImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    DataUrl = [[UrlDataClass alloc]init];
    [self GetNotification];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Notification Page";
    //self.title = CustomLocalisedString(@"MainTab_Feed",nil);
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    UIButton *BackToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackToTopButton.frame = CGRectMake(0, screenHeight - 50, 80, 50);
    [BackToTopButton setTitle:@"" forState:UIControlStateNormal];
    //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
    [BackToTopButton setBackgroundColor:[UIColor clearColor]];
    [BackToTopButton addTarget:self action:@selector(BackToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:BackToTopButton];
    
}
-(IBAction)BackToTopButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetNotification{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.GetNotification_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLConnection *theConnection_GetNotification = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetNotification start];
    
    
    if( theConnection_GetNotification ){
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
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Notification return get data to server ===== %@",GetData);
    if ([GetData length] == 0 || [GetData isEqualToString:@"[]"]) {
        ShowNoDataView.hidden = NO;
    }else{
        //check follow, like, mention, comment
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        
        PostIDArray = [[NSMutableArray alloc]init];
        TypeArray = [[NSMutableArray alloc]init];
        UserThumbnailArray = [[NSMutableArray alloc]init];
        PostThumbnailArray = [[NSMutableArray alloc]init];
        UserNameArray = [[NSMutableArray alloc]init];
        uidArray = [[NSMutableArray alloc]init];
        MessageArray = [[NSMutableArray alloc]init];
        ActionArray = [[NSMutableArray alloc]init];
        
        NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_thumbnail"];
        NSDictionary *PostInfoData = [GetAllData valueForKey:@"post_thumbnail"];
        //NSLog(@"UserInfoData is %@",UserInfoData);
        for (NSDictionary * dict in GetAllData){
            NSString *type =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
            [TypeArray addObject:type];
            NSString *post_id =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"post_id"]];
            [PostIDArray addObject:post_id];
            NSString *username =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
            [UserNameArray addObject:username];
            NSString *uid =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"uid"]];
            [uidArray addObject:uid];
            NSString *message =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]];
            [MessageArray addObject:message];
            NSString *Action =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"action"]];
            [ActionArray addObject:Action];
        }
        for (NSDictionary * dict in UserInfoData){
            if( [dict valueForKey:@"url"] == nil ||
               [[dict valueForKey:@"url"] isEqual:[NSNull null]] || [[dict valueForKey:@"url"] isEqualToString:@"<null>"]){
                [UserThumbnailArray addObject:@"Null"];
            }else{
                NSString *user_thumbnail =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
                [UserThumbnailArray addObject:user_thumbnail];
            }
        }
        for (NSDictionary * dict in PostInfoData){
            if( [dict valueForKey:@"url"] == nil ||
               [[dict valueForKey:@"url"] isEqual:[NSNull null]] || [[dict valueForKey:@"url"] isEqualToString:@"<null>"]){
                [PostThumbnailArray addObject:@"Null"];
            }else{
                NSString *post_thumbnail =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
                [PostThumbnailArray addObject:post_thumbnail];
            }
        }
        NSLog(@"TypeArray is %@",TypeArray);
        NSLog(@"ActionArray is %@",ActionArray);
        NSLog(@"UserThumbnailArray is %@",UserThumbnailArray);
        NSLog(@"PostThumbnailArray is %@",PostThumbnailArray);
        NSLog(@"UserNameArray is %@",UserNameArray);
        [self InitView];
    }
    
    [ShowActivity stopAnimating];
}
-(void)InitView{
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
//    
//   // CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
//
//    for (int i = 0; i < [TypeArray count]; i++) {
//        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [Line01 setTitle:@"" forState:UIControlStateNormal];
//        [Line01 setFrame:CGRectMake(0, 60 + i * 60, screenWidth, 1)];
//        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
//        [MainScroll addSubview:Line01];
//        
//        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
//        ShowUserImage.frame = CGRectMake(5, 9 + i * 60, 40 , 40);
//        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
//        ShowUserImage.layer.cornerRadius=20;
//        ShowUserImage.layer.borderWidth=1;
//        ShowUserImage.layer.masksToBounds = YES;
//        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
//        
//        AsyncImageView *ShowPostImage = [[AsyncImageView alloc]init];
//        ShowPostImage.frame = CGRectMake(screenWidth - 15 - 40, 9 + i * 60, 40 , 40);
//        ShowPostImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowPostImage.backgroundColor = [UIColor clearColor];
//        ShowPostImage.clipsToBounds = YES;
//        ShowPostImage.tag = 99;
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowPostImage];
//
//        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
//        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
//        [ButtonClick setFrame:CGRectMake(0, 0 + i * 60, screenWidth, 60)];
//        [ButtonClick setBackgroundColor:[UIColor clearColor]];
//        ButtonClick.tag = i;
//        [ButtonClick addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
//        
//        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[TypeArray objectAtIndex:i]];
//        if ([GetType isEqualToString:@"follow"]) {
//
//            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
//                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowUserImage.imageURL = url_UserImage;
//            }
//            
//        }else if ([GetType isEqualToString:@"like"]){
//          //  ShowUserImage.image = [UIImage imageNamed:@"Like@3x.png"];
////            NSURL *UrlImageData = [NSURL URLWithString:[PostThumbnailArray objectAtIndex:i]];
////            ShowPostImage.imageURL = UrlImageData;
//            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
//                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowUserImage.imageURL = url_UserImage;
//            }
//            
//            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
//                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowPostImage.imageURL = url_UserImage;
//            }
//            
//        }else if ([GetType isEqualToString:@"mention"]){
//    //        ShowUserImage.image = [UIImage imageNamed:@"Comment@3x.png"];
////            NSURL *UrlImageData = [NSURL URLWithString:[PostThumbnailArray objectAtIndex:i]];
////            ShowPostImage.imageURL = UrlImageData;
//            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
//                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowUserImage.imageURL = url_UserImage;
//            }
//            
//            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
//                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowPostImage.imageURL = url_UserImage;
//            }
//            
//        }else if ([GetType isEqualToString:@"comment"]){
//        //    ShowUserImage.image = [UIImage imageNamed:@"Comment@3x.png"];
////            NSURL *UrlImageData = [NSURL URLWithString:[PostThumbnailArray objectAtIndex:i]];
////            ShowPostImage.imageURL = UrlImageData;
//            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
//                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowUserImage.imageURL = url_UserImage;
//            }
//            
//            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
//                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowPostImage.imageURL = url_UserImage;
//            }
//        }else{ // handle new type
//            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
//            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
//                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
//            }else{
//                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
//                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
//                ShowUserImage.imageURL = url_UserImage;
//            }
//        }
//        
//        
//        
//        UILabel *ShowMessage = [[UILabel alloc]init];
//        ShowMessage.frame = CGRectMake(60, 9 + i * 60, screenWidth - 130, 40);
//        ShowMessage.numberOfLines = 5;
//        ShowMessage.textAlignment = NSTextAlignmentLeft;
//        ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
//        ShowMessage.textColor = [UIColor blackColor];
//        ShowMessage.backgroundColor = [UIColor clearColor];
//        ShowMessage.text = [MessageArray objectAtIndex:i];
//        
//        [MainScroll addSubview:ShowUserImage];
//        [MainScroll addSubview:ShowMessage];
//        [MainScroll addSubview:ShowPostImage];
//        [MainScroll addSubview:ButtonClick];
//        
//        [MainScroll setScrollEnabled:YES];
//        MainScroll.backgroundColor = [UIColor whiteColor];
//        [MainScroll setContentSize:CGSizeMake(screenWidth, 60 + i * 60)];
//    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    
    GetHeight += 20;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"Following"];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"Notifications"];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringPeople, nil];
    UISegmentedControl *ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 29);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:ProfileControl];
    
    
    GetHeight += 49;
    
    FollowingView = [[UIView alloc]init];
    FollowingView.frame = CGRectMake(0, GetHeight, screenWidth, 400);
    FollowingView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:FollowingView];
    
    NotificationsView = [[UIView alloc]init];
    NotificationsView.frame = CGRectMake(0, GetHeight, screenWidth, 600);
    NotificationsView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:NotificationsView];
    
    NotificationsView.hidden = YES;
    FollowingView.hidden = NO;
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Following view click");
            FollowingView.hidden = NO;
            NotificationsView.hidden = YES;
            //[self InitPostsDataView];
            
            break;
        case 1:
            NSLog(@"Notifications view click");
            FollowingView.hidden = YES;
            NotificationsView.hidden = NO;
            
            [self InitNotificationsDataView];
            
            break;
        default:
            break;
    }
    
    //[self InitView];
}


-(void)InitNotificationsDataView{
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < [TypeArray count]; i++) {
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 60 + i * 60, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        [NotificationsView addSubview:Line01];
    
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(5, 9 + i * 60, 40 , 40);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=20;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
    
        AsyncImageView *ShowPostImage = [[AsyncImageView alloc]init];
        ShowPostImage.frame = CGRectMake(screenWidth - 15 - 40, 9 + i * 60, 40 , 40);
        ShowPostImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowPostImage.backgroundColor = [UIColor clearColor];
        ShowPostImage.clipsToBounds = YES;
        ShowPostImage.tag = 99;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowPostImage];
    
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(0, 0 + i * 60, screenWidth, 60)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        [ButtonClick addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[TypeArray objectAtIndex:i]];
        if ([GetType isEqualToString:@"follow"]) {
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
    
        }else if ([GetType isEqualToString:@"like"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
    
        }else if ([GetType isEqualToString:@"mention"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
    
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
    
        }else if ([GetType isEqualToString:@"comment"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
    
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
        }else{ // handle new type
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
                }
            }
    
    
    
        UILabel *ShowMessage = [[UILabel alloc]init];
        ShowMessage.frame = CGRectMake(60, 9 + i * 60, screenWidth - 130, 40);
        ShowMessage.numberOfLines = 5;
        ShowMessage.textAlignment = NSTextAlignmentLeft;
        ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowMessage.textColor = [UIColor blackColor];
        ShowMessage.backgroundColor = [UIColor clearColor];
        ShowMessage.text = [MessageArray objectAtIndex:i];
    
        [NotificationsView addSubview:ShowUserImage];
        [NotificationsView addSubview:ShowMessage];
        [NotificationsView addSubview:ShowPostImage];
        [NotificationsView addSubview:ButtonClick];
        
        NotificationsView.frame = CGRectMake(0, GetHeight, screenWidth, 60 + i * 60);
    }
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + NotificationsView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;

}

-(IBAction)ClickButton:(id)sender{
    SLog(@"ClickButton");
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[TypeArray objectAtIndex:getbuttonIDN]];
    if ([GetType isEqualToString:@"follow"]) {
        UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
        [ExpertsUserProfileView GetUsername:[UserNameArray objectAtIndex:getbuttonIDN]];
        NSLog(@"UserNameArray is %@",[UserNameArray objectAtIndex:getbuttonIDN]);
    }else if ([GetType isEqualToString:@"like"]){
        FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.2;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        [self presentViewController:FeedDetailView animated:NO completion:nil];
//        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
        
        [self.navigationController pushViewController:FeedDetailView animated:YES];
        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    }else if ([GetType isEqualToString:@"mention"]){
        FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.2;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        [self presentViewController:FeedDetailView animated:NO completion:nil];
//        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
        [self.navigationController pushViewController:FeedDetailView animated:YES];
        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    }else if ([GetType isEqualToString:@"comment"]){
        FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.2;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        [self presentViewController:FeedDetailView animated:NO completion:nil];
//        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
        [self.navigationController pushViewController:FeedDetailView animated:YES];
        [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    }else{
    
        NSString *GetAction = [[NSString alloc]initWithFormat:@"%@",[ActionArray objectAtIndex:getbuttonIDN]];
    
        NSLog(@"GetAction is %@",GetAction);
        
        if ([GetAction isEqualToString:@"post"]) {
            FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.2;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self presentViewController:FeedDetailView animated:NO completion:nil];
//            [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
            [self.navigationController pushViewController:FeedDetailView animated:YES];
            [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
        }else if([GetAction isEqualToString:@"none"]){
        
        }else if([GetAction isEqualToString:@"user"]){
            UserProfileV2ViewController *ExpertsUserProfileView = [[UserProfileV2ViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
            [ExpertsUserProfileView GetUsername:[UserNameArray objectAtIndex:getbuttonIDN]];
        }else{
        
        }
    }
}
- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       // [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
          //  NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
           // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
             [self GetNotification];
            [refreshControl endRefreshing];
            NSLog(@"refresh end");
        });
    });
}
@end

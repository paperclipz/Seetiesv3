//
//  NotificationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "NotificationViewController.h"
#import "AsyncImageView.h"
#import "NewUserProfileV2ViewController.h"
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
    MainScroll.backgroundColor = [UIColor whiteColor];
    TitleLabel.text = LocalisedString(@"Activity");
    ShowNoDataView.hidden = YES;
    ShowNoDataView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    NoDataImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    DataUrl = [[UrlDataClass alloc]init];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    CheckClick_Following = 0;
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
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Notification viewDidAppear");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_COUNT" object:nil];
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
    NSLog(@"Get Notification is %@",FullString);
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetNotification = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetNotification start];
    
    
    if( theConnection_GetNotification ){
        webData = [NSMutableData data];
    }
}
-(void)GetFollowing{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/following?token=%@",DataUrl.GetNotification_Url,GetExpertToken];
    NSLog(@"Get Following is %@",FullString);
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetFollowing = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetFollowing start];
    
    
    if( theConnection_GetFollowing ){
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
    if (connection == theConnection_GetNotification) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"Notification return get data to server ===== %@",GetData);
        if ([GetData length] == 0 || [GetData isEqualToString:@"[]"]) {
            ShowNoDataView.hidden = NO;
        }else{
            //check follow, like, mention, comment
            
            NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
          //  NSLog(@"Expert Json = %@",res);
            
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSDictionary *GetNotificationsData = [GetAllData valueForKey:@"notifications"];
            
            PostIDArray = [[NSMutableArray alloc]init];
            TypeArray = [[NSMutableArray alloc]init];
            UserThumbnailArray = [[NSMutableArray alloc]init];
            PostThumbnailArray = [[NSMutableArray alloc]init];
            UserNameArray = [[NSMutableArray alloc]init];
            uidArray = [[NSMutableArray alloc]init];
            MessageArray = [[NSMutableArray alloc]init];
            ActionArray = [[NSMutableArray alloc]init];
            DateArray = [[NSMutableArray alloc]init];
            
            NSDictionary *UserInfoData = [GetNotificationsData valueForKey:@"user_thumbnail"];
            NSDictionary *PostInfoData = [GetNotificationsData valueForKey:@"post_thumbnail"];
            //NSLog(@"UserInfoData is %@",UserInfoData);
            for (NSDictionary * dict in GetNotificationsData){
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
                NSString *Date =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
                [DateArray addObject:Date];
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
//            NSLog(@"TypeArray is %@",TypeArray);
//            NSLog(@"ActionArray is %@",ActionArray);
//            NSLog(@"UserThumbnailArray is %@",UserThumbnailArray);
//            NSLog(@"PostThumbnailArray is %@",PostThumbnailArray);
//            NSLog(@"UserNameArray is %@",UserNameArray);
             [self InitView];
             [self GetFollowing];
        }
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"Following return get data to server ===== %@",GetData);
        
        if ([GetData length] == 0 || [GetData isEqualToString:@"[]"]) {
            ShowNoDataView.hidden = NO;
        }else{
            //check follow, like, mention, comment
            
            NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
            //NSLog(@"Expert Json = %@",res);
            
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            NSDictionary *GetActivitiesData = [GetAllData valueForKey:@"activities"];
            
            Following_PostIDArray = [[NSMutableArray alloc]init];
            Following_TypeArray = [[NSMutableArray alloc]init];
            Following_UserThumbnailArray = [[NSMutableArray alloc]init];
            Following_PostThumbnailArray = [[NSMutableArray alloc]init];
            Following_UserNameArray = [[NSMutableArray alloc]init];
            Following_uidArray = [[NSMutableArray alloc]init];
            Following_MessageArray = [[NSMutableArray alloc]init];
            Following_ActionArray = [[NSMutableArray alloc]init];
            Following_DateArray = [[NSMutableArray alloc]init];
            
            NSDictionary *UserData = [GetActivitiesData valueForKey:@"user"];
            NSDictionary *PostData = [GetActivitiesData valueForKey:@"post"];
            //NSLog(@"UserInfoData is %@",UserInfoData);
            for (NSDictionary * dict in GetActivitiesData){
                NSString *type =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
                [Following_TypeArray addObject:type];
                NSString *post_id =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"post_id"]];
                [Following_PostIDArray addObject:post_id];
                NSString *username =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
                [Following_UserNameArray addObject:username];
                NSString *uid =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"uid"]];
                [Following_uidArray addObject:uid];
                NSString *message =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"message"]];
                [Following_MessageArray addObject:message];
                NSString *Action =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"action"]];
                [Following_ActionArray addObject:Action];
                NSString *Date =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
                [Following_DateArray addObject:Date];
            }
//            NSLog(@"Following_TypeArray is %lu",(unsigned long)[Following_TypeArray count]);
//            NSLog(@"Following_PostIDArray is %lu",(unsigned long)[Following_PostIDArray count]);
//            NSLog(@"Following_UserNameArray is %lu",(unsigned long)[Following_UserNameArray count]);
//            NSLog(@"Following_uidArray is %lu",(unsigned long)[Following_uidArray count]);
//            NSLog(@"Following_MessageArray is %lu",(unsigned long)[Following_MessageArray count]);
//            NSLog(@"Following_ActionArray is %lu",(unsigned long)[Following_ActionArray count]);
//            NSLog(@"Following_DateArray is %lu",(unsigned long)[Following_DateArray count]);

            for (NSDictionary * dict in UserData){
                
                NSDictionary *UserInfoData = [dict valueForKey:@"user_info"];
                for (NSDictionary * dict in UserInfoData){
                    NSString *user_thumbnail =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
                    [Following_UserThumbnailArray addObject:user_thumbnail];
                }
                

            }
//            NSLog(@"Following_UserThumbnailArray is %lu",(unsigned long)[Following_UserThumbnailArray count]);
            for (NSDictionary * dict in PostData){
                
                NSDictionary *PostInfoData = [dict valueForKey:@"post_info"];
                NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in PostInfoData){
                    NSString *post_thumbnail =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"url"]];
                    [TempArray addObject:post_thumbnail];
                    
                }
                NSString * result = [TempArray componentsJoinedByString:@","];
                [Following_PostThumbnailArray addObject:result];
            
            }
//            NSLog(@"Following_PostThumbnailArray is %lu",(unsigned long)[Following_PostThumbnailArray count]);


//            NSLog(@"Following_UserThumbnailArray is %@",Following_UserThumbnailArray);
//            NSLog(@"Following_PostThumbnailArray is %@",Following_PostThumbnailArray);
            [self InitFollowingDataView];
        }
        
        
        
        
        
    }
    
    
    [ShowActivity stopAnimating];
}
-(void)InitView{

    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //MainScroll.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    
    GetHeight += 20;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"%@",LocalisedString(@"Following")];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"%@",LocalisedString(@"Notifications")];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringPeople, nil];
    UISegmentedControl *ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 33);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 1;
    UIFont *font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:12];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [ProfileControl setTitleTextAttributes:attributes
                                  forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:ProfileControl];
    
    GetHeight += 49;
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line01];

    GetHeight += 1;
    
    FollowingView = [[UIView alloc]init];
    FollowingView.frame = CGRectMake(0, GetHeight, screenWidth, 400);
    FollowingView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:FollowingView];
    
    NotificationsView = [[UIView alloc]init];
    NotificationsView.frame = CGRectMake(0, GetHeight, screenWidth, 600);
    NotificationsView.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:NotificationsView];
    
    NotificationsView.hidden = NO;
    FollowingView.hidden = YES;
    
    [self InitNotificationsDataView];
   
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Following view click");
            FollowingView.hidden = NO;
            NotificationsView.hidden = YES;
          //  [self InitFollowingDataView];
            CGSize contentSize = MainScroll.frame.size;
            contentSize.height = GetHeight + FollowingView.frame.size.height;
            MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            MainScroll.contentSize = contentSize;
            break;
        case 1:
            NSLog(@"Notifications view click");
            FollowingView.hidden = YES;
            NotificationsView.hidden = NO;
            CGSize contentSize1 = MainScroll.frame.size;
            contentSize1.height = GetHeight + NotificationsView.frame.size.height;
            MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            MainScroll.contentSize = contentSize1;
          //  [self InitNotificationsDataView];
            
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitFollowingDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < [Following_TypeArray count]; i++) {
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 80 + i * 80, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        [FollowingView addSubview:Line01];
        
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(13, 9 + i * 80, 40 , 40);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=20;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        
        AsyncImageView *ShowPostImage = [[AsyncImageView alloc]init];
        ShowPostImage.frame = CGRectMake(screenWidth - 13 - 40, 9 + i * 80, 40 , 40);
        ShowPostImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowPostImage.backgroundColor = [UIColor clearColor];
        ShowPostImage.clipsToBounds = YES;
        ShowPostImage.tag = 99;
        ShowPostImage.layer.cornerRadius = 5;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowPostImage];
        
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(0, 0 + i * 80, screenWidth, 80)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        //[ButtonClick addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *MiniIcon = [[UIImageView alloc]init];
        MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
       // MiniIcon.contentMode = UIViewContentModeScaleAspectFit;
        MiniIcon.image = [UIImage imageNamed:@"NotificationCollect.png"];
        
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[Following_TypeArray objectAtIndex:i]];
        if ([GetType isEqualToString:@"follow"]) {
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationFollow.png"];
        }else if ([GetType isEqualToString:@"like"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[Following_PostThumbnailArray objectAtIndex:i]];
            NSArray *FirstImgarr = [FullImagesURL2 componentsSeparatedByString:@","];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:[FirstImgarr objectAtIndex:0]];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationLike.png"];
        }else if ([GetType isEqualToString:@"mention"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[Following_PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NoticationComment.png"];
        }else if ([GetType isEqualToString:@"comment"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[Following_PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NoticationComment.png"];
        }else if([GetType isEqualToString:@"collect"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationCollect.png"];
        }else{ // handle new type
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[Following_UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationBySeeties.png"];
        }
        
        
        
        UILabel *ShowMessage = [[UILabel alloc]init];
        ShowMessage.frame = CGRectMake(66, 9 + i * 80, screenWidth - 132, 40);
        ShowMessage.numberOfLines = 5;
        ShowMessage.textAlignment = NSTextAlignmentLeft;
        ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        ShowMessage.textColor = [UIColor blackColor];
        ShowMessage.backgroundColor = [UIColor clearColor];
        NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[Following_MessageArray objectAtIndex:i]];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[GetString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        ShowMessage.attributedText = attrStr;//[self convertHtmlPlainText:GetString]
        NSString *start = [[NSString alloc]initWithFormat:@"%@",[Following_DateArray objectAtIndex:i]];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        f.timeStyle = NSDateFormatterShortStyle;
        f.dateStyle = NSDateFormatterNoStyle;
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate* Now = [NSDate date];
        NSString *end = [f stringFromDate:Now];;
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        NSDateComponents *components;
        NSInteger days;
        NSInteger Hours;
        NSInteger Minutes;
        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                     fromDate: startDate toDate: endDate options: 0];
        days = [components day];
        Hours = [components hour];
        Minutes = [components minute];
        
        NSString *TempShowDate;
        
        if (days == 0) {
            if (Hours == 0) {
                TempShowDate = [[NSString alloc]initWithFormat:@"%li minutes ago",(long)Minutes];
            }else{
                TempShowDate = [[NSString alloc]initWithFormat:@"%li hours ago",(long)Hours];
            }
        }else{
            TempShowDate = [[NSString alloc]initWithFormat:@"%li day ago",(long)days];
        }
        
        UILabel *ShowDate = [[UILabel alloc]init];
        ShowDate.frame = CGRectMake(95, 50 + i * 80, screenWidth - 130, 28);
        ShowDate.text = TempShowDate;
        ShowDate.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        ShowDate.backgroundColor = [UIColor clearColor];
        ShowDate.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12];
        
        [FollowingView addSubview:ShowUserImage];
        [FollowingView addSubview:ShowMessage];
        [FollowingView addSubview:ShowPostImage];
        [FollowingView addSubview:ShowDate];
        [FollowingView addSubview:MiniIcon];
        [FollowingView addSubview:ButtonClick];
        
        FollowingView.frame = CGRectMake(0, GetHeight, screenWidth, 80 + i * 80);
    }
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + FollowingView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
    if (CheckClick_Following == 0) {
        [self InitNotificationsDataView];
        CheckClick_Following = 1;
    }
    
    
    
}

-(void)InitNotificationsDataView{
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < [TypeArray count]; i++) {
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 80 + i * 80, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        [NotificationsView addSubview:Line01];
    
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(13, 9 + i * 80, 40 , 40);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius=20;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
    
        AsyncImageView *ShowPostImage = [[AsyncImageView alloc]init];
        ShowPostImage.frame = CGRectMake(screenWidth - 13 - 40, 9 + i * 80, 40 , 40);
        ShowPostImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowPostImage.backgroundColor = [UIColor clearColor];
        ShowPostImage.clipsToBounds = YES;
        ShowPostImage.tag = 99;
        ShowPostImage.layer.cornerRadius = 5;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowPostImage];
    
        UIButton *ButtonClick = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonClick setTitle:@"" forState:UIControlStateNormal];
        [ButtonClick setFrame:CGRectMake(0, 0 + i * 80, screenWidth, 80)];
        [ButtonClick setBackgroundColor:[UIColor clearColor]];
        ButtonClick.tag = i;
        [ButtonClick addTarget:self action:@selector(ClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
        UIImageView *MiniIcon = [[UIImageView alloc]init];
        MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
        // MiniIcon.contentMode = UIViewContentModeScaleAspectFit;
        MiniIcon.image = [UIImage imageNamed:@"NotificationCollect.png"];
        
        
        
        
        NSString *GetType = [[NSString alloc]initWithFormat:@"%@",[TypeArray objectAtIndex:i]];
        if ([GetType isEqualToString:@"follow"]) {
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationFollow.png"];
        }else if ([GetType isEqualToString:@"like"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationLike.png"];
        }else if ([GetType isEqualToString:@"mention"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationComment.png"];
        }else if ([GetType isEqualToString:@"comment"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            
            NSString *FullImagesURL2 = [[NSString alloc]initWithFormat:@"%@",[PostThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL2 length] == 0 || [FullImagesURL2 isEqualToString:@"Null"]) {
                ShowPostImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL2];
                ShowPostImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationComment.png"];
        }else if([GetType isEqualToString:@"collect"]){
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationCollect.png"];
        }else{ // handle new type
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserThumbnailArray objectAtIndex:i]];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"Null"]) {
                ShowUserImage.image = [UIImage imageNamed:@"Icon.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserImage.imageURL = url_UserImage;
            }
            MiniIcon.frame = CGRectMake(66, 50 + i * 80, 23, 28);
            MiniIcon.image = [UIImage imageNamed:@"NotificationBySeeties.png"];
        }
    
    
    
        UILabel *ShowMessage = [[UILabel alloc]init];
        ShowMessage.frame = CGRectMake(66, 9 + i * 80, screenWidth - 132, 40);
        ShowMessage.numberOfLines = 5;
        ShowMessage.textAlignment = NSTextAlignmentLeft;
        ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        ShowMessage.textColor = [UIColor blackColor];
        ShowMessage.backgroundColor = [UIColor clearColor];

        NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[MessageArray objectAtIndex:i]];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[GetString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        ShowMessage.attributedText = attrStr;//[self convertHtmlPlainText:GetString]
        NSString *start = [[NSString alloc]initWithFormat:@"%@",[DateArray objectAtIndex:i]];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        f.timeStyle = NSDateFormatterShortStyle;
        f.dateStyle = NSDateFormatterNoStyle;
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate* Now = [NSDate date];
        NSString *end = [f stringFromDate:Now];;
         NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:end];
        
//        NSLog(@"startDate is %@",startDate);
//        NSLog(@"endDate is %@",endDate);
        NSDateComponents *components;
        NSInteger days;
        NSInteger Hours;
        NSInteger Minutes;
        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                     fromDate: startDate toDate: endDate options: 0];
        days = [components day];
        Hours = [components hour];
        Minutes = [components minute];
        
//        NSLog(@"days === %li", (long)days);
//        NSLog(@"Hours === %li",(long)Hours);
//        NSLog(@"Minutes === %li",(long)Minutes);
//        NSLog(@"=====================================================");
        
        NSString *TempShowDate;
        
        if (days == 0) {
            if (Hours == 0) {
                  TempShowDate = [[NSString alloc]initWithFormat:@"%li minutes ago",(long)Minutes];
            }else{
                TempShowDate = [[NSString alloc]initWithFormat:@"%li hours ago",(long)Hours];
            }
        }else{
            TempShowDate = [[NSString alloc]initWithFormat:@"%li day ago",(long)days];
        }
        
        UILabel *ShowDate = [[UILabel alloc]init];
        ShowDate.frame = CGRectMake(95, 50 + i * 80, screenWidth - 130, 28);
        ShowDate.text = TempShowDate;
        ShowDate.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        ShowDate.backgroundColor = [UIColor clearColor];
        ShowDate.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:12];
    
        [NotificationsView addSubview:ShowUserImage];
        [NotificationsView addSubview:ShowMessage];
        [NotificationsView addSubview:ShowPostImage];
        [NotificationsView addSubview:ShowDate];
        [NotificationsView addSubview:MiniIcon];
        [NotificationsView addSubview:ButtonClick];
        
        NotificationsView.frame = CGRectMake(0, GetHeight, screenWidth, 80 + i * 80);
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
//        NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.2;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
        NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
        [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
        [NewUserProfileV2View GetUserName:[UserNameArray objectAtIndex:getbuttonIDN]];
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
            NewUserProfileV2ViewController *NewUserProfileV2View = [[NewUserProfileV2ViewController alloc] initWithNibName:@"NewUserProfileV2ViewController" bundle:nil];
            [self.navigationController pushViewController:NewUserProfileV2View animated:YES];
            [NewUserProfileV2View GetUserName:[UserNameArray objectAtIndex:getbuttonIDN]];
        }else{
        
        }
    }
}
- (void)testRefresh:(UIRefreshControl *)refreshControl_
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       // [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
          //  NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
           // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 104);
            MainScroll.alwaysBounceVertical = YES;
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_NOTIFICATION_COUNT" object:nil];
            [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
            [MainScroll addSubview:refreshControl];
            GetHeight = 0;
            CheckClick_Following = 0;
             [self GetNotification];
            [refreshControl endRefreshing];
            NSLog(@"refresh end");
        });
    });
}
@end

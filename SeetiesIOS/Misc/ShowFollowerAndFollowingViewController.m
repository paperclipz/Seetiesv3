//
//  ShowFollowerAndFollowingViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ShowFollowerAndFollowingViewController.h"
#import "NewUserProfileV2ViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface ShowFollowerAndFollowingViewController ()

@end

@implementation ShowFollowerAndFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowActivity.frame = CGRectMake(screenWidth - 35, 32, 20, 20);
    
    GetSelectIDN = 0;
    
    TotalPage = 1;
    CurrentPage = 0;
    DataCount = 0;
    DataTotal = 0;
    CheckFirstTimeLoad = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Follower And Following Page";
    
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
-(void)GetToken:(NSString *)Token GetUID:(NSString *)uid GetType:(NSString *)Type{
    
    GetToken = Token;
    Getuid = uid;
    GetType = Type;
    if ([GetType isEqualToString:@"Follower"]) {
        [self GetFollowerData];
        ShowTitle.text = CustomLocalisedString(@"Followers", nil);
    }else{
        [self GetFollowingData];
        ShowTitle.text = CustomLocalisedString(@"Following", nil);
    }
}
-(void)GetFollowerData{
    
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/follower?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetToken,CurrentPage];
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"Follower Data check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetFollower = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetFollower start];
        
        
        if( theConnection_GetFollower ){
            webData = [NSMutableData data];
        }
        
    }
    
    
}
-(void)GetFollowingData{
    
    [ShowActivity startAnimating];
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/following?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetToken,CurrentPage];
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"Following Data check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetFollowing = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetFollowing start];
        
        
        if( theConnection_GetFollowing ){
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
    if (connection == theConnection_GetFollower) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Follower return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        NSDictionary *resultData = [res valueForKey:@"data"];
        
        NSString *total_followerString = [[NSString alloc]initWithFormat:@"%@",[resultData valueForKey:@"total_follower"]];
        NSLog(@"total_followerString is %@",total_followerString);
        
        if ([total_followerString isEqualToString:0] || [total_followerString length] == 0) {
            
        }else{
            
            NSString *page = [[NSString alloc]initWithFormat:@"%@",[resultData objectForKey:@"page"]];
            NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[resultData objectForKey:@"total_page"]];
            CurrentPage = [page intValue];
            TotalPage = [total_page intValue];
            
            NSLog(@"CurrentPage is %li",(long)CurrentPage);
            NSLog(@"TotalPage is %li",(long)TotalPage);
            
            NSDictionary *resultData = [res valueForKey:@"data"];
            NSDictionary *UserInfoData = [resultData valueForKey:@"follower"];
            
            
            if (CheckFirstTimeLoad == 0) {
                User_UIDArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_LocationArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_NameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_UserNameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_ProfilePhotoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_FollowedArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            }else{
                
            }
            
            
            
            
            for (NSDictionary * dict in UserInfoData) {
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [User_NameArray addObject:name];
                NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                [User_LocationArray addObject:location];
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [User_UIDArray addObject:uid];
                NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [User_ProfilePhotoArray addObject:profile_photo];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [User_UserNameArray addObject:username];
                NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                [User_FollowedArray addObject:followed];
            }
            NSLog(@"User_NameArray is %@",User_NameArray);
            
            //            DataTest = 20;
            //            if ([User_UIDArray count] < DataTest) {
            //                NSLog(@"1");
            //                DataTest = [User_UIDArray count];
            //                NSLog(@"DataTest is %li",(long)DataTest);
            //            }else{
            //                NSLog(@"2");
            //
            //            }
            //
            //            [self InitView];
            
            DataCount = DataTotal;
            DataTotal = [User_NameArray count];
            
            if (CheckFirstTimeLoad == 0) {
                CheckFirstTimeLoad = 1;
            }else{
            }
            
            [self InitView];
            
        }
        
    }else if(connection == theConnection_GetFollowing){
        //get following
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
        NSDictionary *resultData = [res valueForKey:@"data"];
        
        NSString *total_followingString = [[NSString alloc]initWithFormat:@"%@",[resultData objectForKey:@"total_following"]];
        NSLog(@"total_followingString is %@",total_followingString);
        
        if ([total_followingString isEqualToString:0] || [total_followingString length] == 0) {
            
        }else{
            NSString *page = [[NSString alloc]initWithFormat:@"%@",[resultData objectForKey:@"page"]];
            NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[resultData objectForKey:@"total_page"]];
            CurrentPage = [page intValue];
            TotalPage = [total_page intValue];
            
            NSLog(@"CurrentPage is %li",(long)CurrentPage);
            NSLog(@"TotalPage is %li",(long)TotalPage);
            
            NSDictionary *resultData = [res valueForKey:@"data"];
            NSDictionary *UserInfoData = [resultData valueForKey:@"following"];
            
            if (CheckFirstTimeLoad == 0) {
                User_UIDArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_LocationArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_NameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_UserNameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_ProfilePhotoArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                User_FollowedArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData count]];
            }else{
                
            }
            
            
            for (NSDictionary * dict in UserInfoData) {
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [User_NameArray addObject:name];
                NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                [User_LocationArray addObject:location];
                NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                [User_UIDArray addObject:uid];
                NSString *profile_photo = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                [User_ProfilePhotoArray addObject:profile_photo];
                NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                [User_UserNameArray addObject:username];
                NSString *followed = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                [User_FollowedArray addObject:followed];
            }
            NSLog(@"User_NameArray is %@",User_NameArray);
            
            DataCount = DataTotal;
            DataTotal = [User_NameArray count];
            
            if (CheckFirstTimeLoad == 0) {
                CheckFirstTimeLoad = 1;
            }else{
            }
            
            [self InitView];
            
        }
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            //            if ([GetType isEqualToString:@"Follower"]) {
            //                [self GetFollowerData];
            //            }else{
            //                [self GetFollowingData];
            //            }
            //            if([[MainScroll viewWithTag:GetSelectIDN] isKindOfClass:[UIButton class]])
            //            {
            //                UIButton *buttonWithTag1 = (UIButton *)[MainScroll viewWithTag:GetSelectIDN];
            //                NSLog(@"buttonWithTag1 is %@",buttonWithTag1);
            //                buttonWithTag1.selected = !buttonWithTag1.selected;
            //
            //                if (buttonWithTag1.selected) {
            //                }else{
            //                }
            //            }
            
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            
            
            NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[User_FollowedArray objectAtIndex:GetSelectIDN]];
            if ([GetFollowData isEqualToString:@"1"]) {
                [User_FollowedArray replaceObjectAtIndex:GetSelectIDN withObject:@"0"];
            }else{
                [User_FollowedArray replaceObjectAtIndex:GetSelectIDN withObject:@"1"];
            }
            
            [self InitView];
            
        }
    }
    NSString *CheckGetUserProfile = @"Done";
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
    [defaults synchronize];
    
    [ShowActivity stopAnimating];
}
-(void)InitView{
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //    for (UIView *subview in MainScroll.subviews) {
    //        [subview removeFromSuperview];
    //    }
    //    NSInteger tempcountdata = 0;
    //    if (DataTest <= 20) {
    //        tempcountdata = 0;
    //    }else{
    //        tempcountdata = DataTest - 20;
    //    }
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        AsyncImageView *ShowUserImage = [[AsyncImageView alloc]init];
        ShowUserImage.frame = CGRectMake(10, 20 + i * 70, 40, 40);
        ShowUserImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserImage.layer.cornerRadius= 20;
        ShowUserImage.layer.borderWidth=1;
        ShowUserImage.layer.masksToBounds = YES;
        ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[User_ProfilePhotoArray objectAtIndex:i]];
        //NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        if ([FullImagesURL1 length] == 0) {
            ShowUserImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserImage.imageURL = url_UserImage;
        }
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(60, 15 + i * 70, screenWidth - 100, 30);
        ShowTitleLabel.text = [User_NameArray objectAtIndex:i];
        ShowTitleLabel.numberOfLines = 5;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(60, 40 + i * 70, screenWidth - 100, 20);
        NSString *TempString = [[NSString alloc]initWithFormat:@"@%@",[User_UserNameArray objectAtIndex:i]];
        ShowUserName.text = TempString;
        ShowUserName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowUserName.textColor = [UIColor lightGrayColor];
        
        UIButton *ShowFollowerButton = [[UIButton alloc]init];
        [ShowFollowerButton setFrame:CGRectMake(screenWidth - 40 - 15, 20 + i * 70, 40, 40)];
        [ShowFollowerButton setBackgroundColor:[UIColor clearColor]];
        ShowFollowerButton.tag = i;
        [ShowFollowerButton addTarget:self action:@selector(FollowerButton:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *CheckFollower = [[NSString alloc]initWithFormat:@"%@",[User_FollowedArray objectAtIndex:i]];
        if ([CheckFollower isEqualToString:@"0"]) {
            [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
            [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
        }else{
            [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
            [ShowFollowerButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
        }
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, 75 + i * 70, screenWidth, 1)];
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ClickButton setTitle:@"" forState:UIControlStateNormal];
        [ClickButton setFrame:CGRectMake(10, 20 + i * 70, screenWidth - 40 - 15, 60)];
        [ClickButton setBackgroundColor:[UIColor clearColor]];
        ClickButton.tag = i;
        [ClickButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:ShowUserImage];
        //        [MainScroll addSubview:ShowLocationLabel];
        //        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:ShowUserName];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:ShowFollowerButton];
        [MainScroll addSubview:ClickButton];
        //
        [MainScroll setScrollEnabled:YES];
        MainScroll.backgroundColor = [UIColor whiteColor];
        [MainScroll setContentSize:CGSizeMake(screenWidth,140 + i * 70)];
    }
    //    for (int i = 0; i < [User_NameArray count]; i++) {
    //        AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
    //        ShowNearbySmallImage.frame = CGRectMake(200, 10 + i * 120, 100 , 100);
    ////        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
    ////        ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
    ////        ShowNearbySmallImage.clipsToBounds = YES;
    ////        ShowNearbySmallImage.tag = 99;
    ////        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
    ////        NSURL *url_NearbySmall = [NSURL URLWithString:[User_ProfilePhotoArray objectAtIndex:i]];
    ////        //NSLog(@"url is %@",url);
    ////        ShowNearbySmallImage.imageURL = url_NearbySmall;
    //        ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
    //        ShowNearbySmallImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    //        ShowNearbySmallImage.layer.cornerRadius=50;
    //        ShowNearbySmallImage.layer.borderWidth=1;
    //        ShowNearbySmallImage.layer.masksToBounds = YES;
    //        ShowNearbySmallImage.layer.borderColor=[[UIColor clearColor] CGColor];
    //        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
    //        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[User_ProfilePhotoArray objectAtIndex:i]];
    //        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
    //        if ([FullImagesURL1 length] == 0) {
    //            ShowNearbySmallImage.image = [UIImage imageNamed:@"No_image_available.jpg"];
    //        }else{
    //            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
    //            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    //            ShowNearbySmallImage.imageURL = url_UserImage;
    //        }
    //
    //        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
    //        ShowLocationImage.frame = CGRectMake(20, 10 + i * 120, 8, 12);
    //        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
    //
    //        UILabel *ShowLocationLabel = [[UILabel alloc]init];
    //        ShowLocationLabel.frame = CGRectMake(35, 5 + i * 120, 165, 20);
    //        ShowLocationLabel.text = [User_LocationArray objectAtIndex:i];
    //        ShowLocationLabel.font = [UIFont systemFontOfSize:12];
    //        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
    //
    //        UILabel *ShowTitleLabel = [[UILabel alloc]init];
    //        ShowTitleLabel.frame = CGRectMake(20, 25 + i * 120, 170, 50);
    //        ShowTitleLabel.text = [User_NameArray objectAtIndex:i];
    //        ShowTitleLabel.numberOfLines = 5;
    //        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
    //        ShowTitleLabel.font = [UIFont systemFontOfSize:16];
    //        ShowTitleLabel.textColor = [UIColor blackColor];
    //        ShowTitleLabel.backgroundColor = [UIColor clearColor];
    //
    //        UILabel *ShowUserName = [[UILabel alloc]init];
    //        ShowUserName.frame = CGRectMake(10, 75 + i * 120, 250, 20);
    //        NSString *TempString = [[NSString alloc]initWithFormat:@"@%@",[User_UserNameArray objectAtIndex:i]];
    //        ShowUserName.text = TempString;
    //        ShowUserName.font = [UIFont systemFontOfSize:14];
    //        ShowUserName.textColor = [UIColor lightGrayColor];
    //
    //
    //        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [Line01 setTitle:@"" forState:UIControlStateNormal];
    //        [Line01 setFrame:CGRectMake(0, 120 + i * 120, 320, 1)];
    //        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
    //
    //        UIButton *ClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [ClickButton setTitle:@"" forState:UIControlStateNormal];
    //        [ClickButton setFrame:CGRectMake(0, 0 + i * 120, 320, 150)];
    //        [ClickButton setBackgroundColor:[UIColor clearColor]];
    //        ClickButton.tag = i;
    //        [ClickButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //        [MainScroll addSubview:ShowNearbySmallImage];
    //        [MainScroll addSubview:ShowLocationLabel];
    //        [MainScroll addSubview:ShowLocationImage];
    //        [MainScroll addSubview:ShowTitleLabel];
    //        [MainScroll addSubview:ShowUserName];
    //        [MainScroll addSubview:Line01];
    //        [MainScroll addSubview:ClickButton];
    //
    //        [MainScroll setScrollEnabled:YES];
    //        MainScroll.backgroundColor = [UIColor whiteColor];
    //        [MainScroll setContentSize:CGSizeMake(320, 200 + i * 120)];
    //    }
}
-(IBAction)ButtonClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    NewUserProfileV2ViewController *ExpertsUserProfileView = [[NewUserProfileV2ViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertsUserProfileView animated:NO completion:nil];
    [ExpertsUserProfileView GetUserName:[User_UserNameArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)FollowerButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    
    GetSelectIDN = getbuttonIDN;
    
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[User_FollowedArray objectAtIndex:getbuttonIDN]];
    
    if ([GetFollowData isEqualToString:@"1"]) {
        
        //  NSString *tempStirng = [[NSString alloc]initWithFormat:@"Unfollow %@ ?",[User_UserNameArray objectAtIndex:getbuttonIDN]];
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",CustomLocalisedString(@"StopFollowing", nil),[User_UserNameArray objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:tempStirng delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Unfollow", nil), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }else{
        
        [self SendFollowData];
    }
}
-(void)SendFollowData{
    
    //    for (UIView *subview in MainScroll.subviews) {
    //        [subview removeFromSuperview];
    //    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *Getuid_ = [[NSString alloc]initWithFormat:@"%@",[User_UIDArray objectAtIndex:GetSelectIDN]];
    NSString *GetFollowData = [[NSString alloc]initWithFormat:@"%@",[User_FollowedArray objectAtIndex:GetSelectIDN]];
    
    //    if ([GetFollowData isEqualToString:@"0"]) {
    //        GetFollowData = @"0";
    //    }else{
    //        GetFollowData = @"1";
    //    }
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,Getuid_,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    //  [request setHTTPMethod:@"POST"];
    if ([GetFollowData isEqualToString:@"1"]) {
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
    
    //    //parameter first
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the key name @"parameter_first" to the post body
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\":uid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the content to be posted ( ParameterFirst )
    //    [body appendData:[[NSString stringWithFormat:@"%@",GetUserUid] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    //parameter second
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the key name @"parameter_second" to the post body
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the content to be posted ( ParameterSecond )
    //    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    //parameter second
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the key name @"parameter_second" to the post body
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"unfollow\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    //Attaching the content to be posted ( ParameterSecond )
    //    [body appendData:[[NSString stringWithFormat:@"%@",GetFollowData] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    theConnection_SendFollowData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendFollowData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    float endScrolling1 = scrollView.contentOffset.x + scrollView.frame.size.width;
    NSLog(@"endScrolling1 %f ",endScrolling1);
    if (endScrolling >= scrollView.contentSize.height)
    {
        if (CurrentPage == TotalPage) {
            
        }else{
            [ShowActivity startAnimating];
            //            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            //
            //            [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 5)];
            //            // MainScroll.frame = CGRectMake(0, heightcheck, screenWidth, MainScroll.frame.size.height + 20);
            //            UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, MainScroll.contentSize.height + 20, 30, 30)];
            //            [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
            //            [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
            //            [MainScroll addSubview:activityindicator1];
            //            [activityindicator1 startAnimating];
            //            [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 10)];
            
            if ([GetType isEqualToString:@"Follower"]) {
                [self GetFollowerData];
            }else{
                [self GetFollowingData];
            }
            
        }
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1200){
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self SendFollowData];
        }
    }
    
}
@end

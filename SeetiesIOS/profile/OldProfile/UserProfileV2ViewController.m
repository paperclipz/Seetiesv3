//
//  UserProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "UserProfileV2ViewController.h"
#import "ShowFollowerAndFollowingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FullImageViewController.h"
#import "FeedV2DetailViewController.h"
#import "LanguageManager.h"
#import "Locale.h"

#import "NSString+ChangeAsciiString.h"
#import "LLARingSpinnerView.h"
@interface UserProfileV2ViewController ()
//@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation UserProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ShowUserWallpaperImage.frame = CGRectMake(0, 64, screenWidth, 240);
    //ShowUserWallpaperImage.layer.masksToBounds = YES;
    ImgShade.frame = CGRectMake(0, 64, screenWidth, 174);
    TopBarView.frame = CGRectMake(0, 0, screenWidth, 64);
    
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    SettingBarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    segmentActionCheck = 0;
    CheckLoad_Likes = NO;
    CheckLoad_Post = NO;
    CheckFirstTimeLoadLikes = 0;
    CheckFirstTimeLoadPost = 0;
    TotalPage = 1;
    CurrentPage = 0;
    TotalPage_Post = 1;
    CurrentPage_Post = 0;
    ShareButton.frame = CGRectMake(screenWidth - 55, 0, 55, 64);
    ShareIcon.frame = CGRectMake(screenWidth - 17 - 15, 27, 17, 24);
    ShowName.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    FullImageButton.frame = CGRectMake((screenWidth/2) - 50, 226, 100, 100);
    ShowUserProfile.frame = CGRectMake((screenWidth/2) - 50, 226, 100, 100);
    ShowUserProfile.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserProfile.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserProfile.layer.cornerRadius=50;
    ShowUserProfile.layer.borderWidth=2.5;
    ShowUserProfile.layer.masksToBounds = YES;
    ShowUserProfile.layer.borderColor=[[UIColor whiteColor] CGColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"IOS User Profile V2";
    
  //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (CheckLoadDone == NO) {
//        self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//        self.spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
//        self.spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//        //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        self.spinnerView.lineWidth = 1.0f;
//        [self.view addSubview:self.spinnerView];
//        [self.spinnerView startAnimating];
        [ShowActivity startAnimating];
    }
    
    ShowUserWallpaperImage.frame = CGRectMake(0, 64, screenWidth, 240);
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [ShowActivity stopAnimating];
//    [self.spinnerView stopAnimating];
//    [self.spinnerView removeFromSuperview];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat contentOffSet = MainScroll.contentOffset.y;
//    if (contentOffSet == 0) {
//        TopBarView.hidden = NO;
//    }else{
//        CGFloat contentOffSet_ = MainScroll.contentOffset.y;
//        CGFloat contentHeight = MainScroll.contentSize.height;
//        
//        difference1 = contentHeight - contentOffSet_;
//        
//        if (difference1 > difference2) {
//            [UIView animateWithDuration:0.2
//                                  delay:0
//                                options:UIViewAnimationOptionCurveEaseIn
//                             animations:^{
//                                 TopBarView.frame = CGRectMake(0, 0, screenWidth, 64);
//                             }
//                             completion:^(BOOL finished) {
//                             }];
//        }else{
//            [UIView animateWithDuration:0.2
//                                  delay:0
//                                options:UIViewAnimationOptionCurveEaseIn
//                             animations:^{
//                                 TopBarView.frame = CGRectMake(0, -64, screenWidth, 64);
//                             }
//                             completion:^(BOOL finished) {
//                             }];
//        }
//        difference2 = contentHeight - contentOffSet_;
//    }
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         TopBarView.frame = CGRectMake(0, -64, screenWidth, 64);
//                     }
//                     completion:^(BOOL finished) {
//                     }];
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
}
-(void)GetUsername:(NSString *)username{
    
    GetUserName = username;
   // [self InitView];
    [self GetUserData];
}
-(IBAction)HideButton:(id)sender{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         TopBarView.frame = CGRectMake(0, 0, screenWidth, 64);
                         // ShowDownBarView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
                     }
                     completion:^(BOOL finished) {
                     }];
}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
   //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
//    UIButton *HideButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [HideButton setTitle:@"" forState:UIControlStateNormal];
//    [HideButton setFrame:CGRectMake(0, 174, screenWidth, screenHeight)];
//    [HideButton setBackgroundColor:[UIColor clearColor]];
//    [HideButton addTarget:self action:@selector(HideButton:) forControlEvents:UIControlEventTouchUpInside];
//    [MainScroll addSubview:HideButton];
    
    //BackgroundImage.image = [UIImage imageNamed:@"ProfileBlank.png"];
    ImageShade.image = [UIImage imageNamed:@"ImageShade.png"];
    [MainScroll addSubview:BackgroundImage];
    [MainScroll addSubview:ShowUserWallpaperImage];
    [MainScroll addSubview:ImageShade];
    [MainScroll addSubview:ShowUserProfile];
    [MainScroll addSubview:FullImageButton];
    

    
    UILabel *ShowName_ = [[UILabel alloc]init];
    ShowName_.frame = CGRectMake(15, 262 + 64, screenWidth - 30, 30);
    ShowName_.text = GetName;
    ShowName_.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    ShowName_.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
    ShowName_.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowName_];
    
    UILabel *ShowLocation = [[UILabel alloc]init];
    ShowLocation.frame = CGRectMake(15, 287 + 64, screenWidth - 30, 20);
    ShowLocation.text = GetLocation;
    ShowLocation.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowLocation.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowLocation.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowLocation];
    
    
    GetHeight = 322 + 64;
    
    if ([GetAbouts isEqualToString:@""] || [GetAbouts isEqualToString:@"(null)"] || [GetAbouts length] == 0) {
        
    }else{
        UILabel *ShowAboutText = [[UILabel alloc]init];
        ShowAboutText.frame = CGRectMake(15, GetHeight, screenWidth - 30, 30);
        ShowAboutText.text = GetAbouts;
        ShowAboutText.numberOfLines = 0;
        ShowAboutText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        ShowAboutText.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowAboutText.textAlignment = NSTextAlignmentCenter;
        [MainScroll addSubview:ShowAboutText];
        
        CGSize size = [ShowAboutText sizeThatFits:CGSizeMake(ShowAboutText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAboutText.frame;
        frame.size.height = size.height;
        ShowAboutText.frame = frame;
        
        GetHeight += ShowAboutText.frame.size.height + 20;
    }
    
    if ([GetUrl isEqualToString:@""] || [GetUrl isEqualToString:@"(null)"] || [GetUrl length] == 0) {
        
    }else{
        UILabel *ShowLink = [[UILabel alloc]init];
        ShowLink.frame = CGRectMake(15, GetHeight, screenWidth - 30, 30);
        ShowLink.text = GetUrl;
        ShowLink.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        ShowLink.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowLink.textAlignment = NSTextAlignmentCenter;
        [MainScroll addSubview:ShowLink];
        
        UIButton *OpenLinkButton = [[UIButton alloc]init];
        OpenLinkButton.frame = CGRectMake(15, GetHeight, screenWidth - 30, 30);
        [OpenLinkButton setTitle:@"" forState:UIControlStateNormal];
        [OpenLinkButton addTarget:self action:@selector(OpenUrlButton:) forControlEvents:UIControlEventTouchUpInside];
        [MainScroll addSubview:OpenLinkButton];
        
        GetHeight += 60;
    }
    
    if ([AwardCheck isEqualToString:@"no"]) {
        
    }else{
        int TotalWidth = 0;
        int WidthToShow = 0;
        UIScrollView *AwardScroll = [[UIScrollView alloc]init];
        AwardScroll.delegate = self;
        AwardScroll.backgroundColor = [UIColor clearColor];
        AwardScroll.frame = CGRectMake(0, GetHeight, screenWidth, 50);
        [MainScroll addSubview:AwardScroll];
        
        for (int i =0; i < [BadgesImageArray count]; i++) {
            UIImageView *ShowAwardImg = [[UIImageView alloc]init];
            ShowAwardImg.frame = CGRectMake(0 + i * 60 , 0, 50, 50);
            ShowAwardImg.contentMode = UIViewContentModeScaleAspectFill;
            //            ShowAwardImg.layer.backgroundColor=[[UIColor clearColor] CGColor];
            //            ShowAwardImg.layer.cornerRadius=25;
            //            ShowAwardImg.layer.borderWidth=0;
            //            ShowAwardImg.layer.masksToBounds = YES;
            //            ShowAwardImg.layer.borderColor=[[UIColor whiteColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowAwardImg];
            NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[BadgesImageArray objectAtIndex:i]];
            if ([FullImagesURL length] == 0) {
                ShowAwardImg.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
                ShowAwardImg.imageURL = url_NearbySmall;
            }
            [AwardScroll addSubview:ShowAwardImg];
            
            [AwardScroll setContentSize:CGSizeMake(60 + i * 60, 50)];
            TotalWidth = 60 + i * 60;
            WidthToShow = (screenWidth/2) - (TotalWidth / 2);
        }
        
        if (TotalWidth > screenWidth) {
            
        }else{
            AwardScroll.frame = CGRectMake(WidthToShow, GetHeight, TotalWidth, 50);
        }
        
        GetHeight += 70;
    }
    
    //Show followers and following
    UILabel *ShowTextFollowers = [[UILabel alloc]init];
    ShowTextFollowers.text = CustomLocalisedString(@"FOLLOWERS", nil);;
    ShowTextFollowers.frame = CGRectMake((screenWidth/2) - 121, GetHeight, 100, 21);
    ShowTextFollowers.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    ShowTextFollowers.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowTextFollowers.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowTextFollowers];
    
    UILabel *ShowFollowersCount = [[UILabel alloc]init];
    ShowFollowersCount.text = GetFollowersCount;
    ShowFollowersCount.frame = CGRectMake((screenWidth/2) - 121, GetHeight + 20, 100, 21);
    ShowFollowersCount.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    ShowFollowersCount.textColor = [UIColor blackColor];
    ShowFollowersCount.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowFollowersCount];
    
    UIButton *OpenFollowersButton = [[UIButton alloc]init];
    OpenFollowersButton.frame = CGRectMake((screenWidth/2) - 121, GetHeight, 150, 40);
    [OpenFollowersButton setTitle:@"" forState:UIControlStateNormal];
    [OpenFollowersButton addTarget:self action:@selector(ShowAll_FollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:OpenFollowersButton];
    
//    UIImageView *ShowTabDivider = [[UIImageView alloc]init];
//    ShowTabDivider.frame = CGRectMake((screenWidth/2), GetHeight, 1, 40);
//    ShowTabDivider.image = [UIImage imageNamed:@"TabDivider.png"];
//    [MainScroll addSubview:ShowTabDivider];
    
    UIButton *LineCenter = [[UIButton alloc]init];
    LineCenter.frame = CGRectMake((screenWidth/2), GetHeight, 1, 40);
    [LineCenter setTitle:@"" forState:UIControlStateNormal];
    [LineCenter setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:LineCenter];
    
//    UILabel *ShowCenterBar = [[UILabel alloc]init];
//    ShowCenterBar.text = @"|";
//    ShowCenterBar.frame = CGRectMake((screenWidth/2) - 21, GetHeight, 42, 21);
//    ShowCenterBar.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
//    ShowCenterBar.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
//    ShowCenterBar.textAlignment = NSTextAlignmentCenter;
//   [MainScroll addSubview:ShowCenterBar];
    
    UILabel *ShowTextFollowing = [[UILabel alloc]init];
    ShowTextFollowing.text = CustomLocalisedString(@"FOLLOWING", nil);
    ShowTextFollowing.frame = CGRectMake((screenWidth/2) + 21, GetHeight, 100, 21);
    ShowTextFollowing.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    ShowTextFollowing.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowTextFollowing.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowTextFollowing];
    
    UILabel *ShowFollowingCount = [[UILabel alloc]init];
    ShowFollowingCount.text = GetFollowingCount;
    ShowFollowingCount.frame = CGRectMake((screenWidth/2) + 21, GetHeight + 20, 100, 21);
    ShowFollowingCount.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    ShowFollowingCount.textColor = [UIColor blackColor];
    ShowFollowingCount.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowFollowingCount];
    
    UIButton *OpenFollowingButton = [[UIButton alloc]init];
    OpenFollowingButton.frame = CGRectMake((screenWidth/2) + 21, GetHeight, 150, 40);
    [OpenFollowingButton setTitle:@"" forState:UIControlStateNormal];
    [OpenFollowingButton addTarget:self action:@selector(ShowAll_FollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    [MainScroll addSubview:OpenFollowingButton];
    
    GetHeight += 60;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    if ([GetUsername isEqualToString:GetUserName]) {
        //follow button
        
    }else{
        //follow button
        FollowButton = [[UIButton alloc]init];
        FollowButton.frame = CGRectMake((screenWidth/2) - 66, GetHeight, 133, 42);
        [FollowButton setTitle:@"" forState:UIControlStateNormal];
        if ([GetUserFollowing isEqualToString:@"0"]) {
            [FollowButton setImage:[UIImage imageNamed:@"Follow.png"] forState:UIControlStateNormal];
        }else{
            [FollowButton setImage:[UIImage imageNamed:@"Following.png"] forState:UIControlStateNormal];
        }
        [FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [FollowButton setBackgroundColor:[UIColor clearColor]];
        [MainScroll addSubview:FollowButton];
        
        GetHeight += 62;
    }
    
    

    
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, 320, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line01];
    
    GetHeight += 20;
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"%@ %@",GetPostsDataCount,CustomLocalisedString(@"Posts", nil)];
    NSString *TempStringLikes = [[NSString alloc]initWithFormat:@"%@ %@",GetLikesDataCount,CustomLocalisedString(@"MainTab_Like", nil)];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringLikes, nil];
    PostControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    PostControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 29);
    [PostControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    PostControl.selectedSegmentIndex = segmentActionCheck;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:PostControl];
    
    GetHeight += 49;
    
//    if (segmentActionCheck == 0) {
//        for (int i = 0; i < [PostsData_IDArray count]; i++) {
//            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PostsData_PhotoArray objectAtIndex:i]];
//            NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
//            UIImageView *ShowImage = [[UIImageView alloc]init];
//            // ShowImage.image = [UIImage imageNamed:@"Demo001.png"];
//            ShowImage.frame = CGRectMake(1+(i % 3)*106, GetHeight + (106 * (CGFloat)(i /3)), 105, 105);
//            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//            ShowImage.layer.masksToBounds = YES;
//            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
//            if ([FullImagesURL_First length] == 0) {
//                ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//                //NSLog(@"url is %@",url);
//                ShowImage.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage];
//            
//            
//            UIButton *ImageButton = [[UIButton alloc]init];
//            [ImageButton setBackgroundColor:[UIColor clearColor]];
//            [ImageButton setTitle:@"" forState:UIControlStateNormal];
//            ImageButton.frame = CGRectMake(1+(i % 3)*106, GetHeight + (106 * (CGFloat)(i /3)), 105, 105);
//            ImageButton.tag = i;
//            [ImageButton addTarget:self action:@selector(ImageButtonOnClick1:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [MainScroll addSubview:ImageButton];
//            [MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
//        }
//    }else if (segmentActionCheck == 1){
//        for (int i = 0; i < [LikesData_IDArray count]; i++) {
//            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[LikesData_PhotoArray objectAtIndex:i]];
//            NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
//            UIImageView *ShowImage = [[UIImageView alloc]init];
//            ShowImage.image = [UIImage imageNamed:@"Demo001.png"];
//            ShowImage.frame = CGRectMake(1+(i % 3)*106, GetHeight + (106 * (CGFloat)(i /3)), 105, 105);
//            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//            ShowImage.layer.masksToBounds = YES;
//            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
//            if ([FullImagesURL_First length] == 0) {
//                ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//            }else{
//                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//                ShowImage.imageURL = url_NearbySmall;
//            }
//            [MainScroll addSubview:ShowImage];
//            
//            
//            UIButton *ImageButton = [[UIButton alloc]init];
//            [ImageButton setBackgroundColor:[UIColor clearColor]];
//            [ImageButton setTitle:@"" forState:UIControlStateNormal];
//            ImageButton.frame = CGRectMake(1+(i % 3)*106, GetHeight + (106 * (CGFloat)(i /3)), 105, 105);
//            ImageButton.tag = i;
//            [ImageButton addTarget:self action:@selector(ImageButtonOnClick2:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [MainScroll addSubview:ImageButton];
//            [MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
//        }
//    }
    
    
  //  [MainScroll setContentSize:CGSizeMake(320, GetHeight)];
    [self InitPostsData];
    [ShowActivity stopAnimating];
//    [self.spinnerView stopAnimating];
//    [self.spinnerView removeFromSuperview];
    CheckLoadDone = YES;
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Posts");
            segmentActionCheck = 0;
            LikesScroll.hidden = YES;
            PostsScroll.hidden = NO;
            [self InitPostsData];
            break;
        case 1:
            NSLog(@"Likes");
            segmentActionCheck = 1;
            PostsScroll.hidden = YES;
            LikesScroll.hidden = NO;
            [self InitLikeData];
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitPostsData{
    NSLog(@"Init Posts click");
    for (UIView *subview in PostsScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    PostsScroll = [[UIScrollView alloc]init];
    PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, 250);
    PostsScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:PostsScroll];
    
//    int TestWidth = screenWidth - 2;
//    NSLog(@"TestWidth is %i",TestWidth);
//    int FinalWidth = TestWidth / 3;
//    FinalWidth += 1;
//    NSLog(@"FinalWidth is %i",FinalWidth);
//    int SpaceWidth = FinalWidth + 1;
//    
//    for (NSInteger i = 0; i < DataTotal_Post; i++) {
//        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PostsData_PhotoArray objectAtIndex:i]];
//        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
//        UIImageView *ShowImage = [[UIImageView alloc]init];
//        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
//        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowImage.layer.masksToBounds = YES;
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
//        if ([FullImagesURL_First length] == 0) {
//            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        }else{
//            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//            //NSLog(@"url is %@",url);
//            ShowImage.imageURL = url_NearbySmall;
//        }
//        [PostsScroll addSubview:ShowImage];
//        
//        
//        UIButton *ImageButton = [[UIButton alloc]init];
//        [ImageButton setBackgroundColor:[UIColor clearColor]];
//        [ImageButton setTitle:@"" forState:UIControlStateNormal];
//        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
//        ImageButton.tag = i;
//        [ImageButton addTarget:self action:@selector(ImageButtonOnClick1:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [PostsScroll addSubview:ImageButton];
//        PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, 0 + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
//        //[PostsScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
//    }
//    
//    
//    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + PostsScroll.frame.size.height)];
    
    int GetHeight_ = 0;
    for (NSInteger i = 0; i < DataTotal_Post; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PostsData_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(0, GetHeight_ + i, screenWidth, 245);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [PostsScroll addSubview:ShowImage];
        
        UIImageView *ImageShade_ = [[UIImageView alloc]init];
        ImageShade_.frame = CGRectMake(0, GetHeight_ + i, screenWidth, 149);
        ImageShade_.image = [UIImage imageNamed:@"ImageShade.png"];
        ImageShade_.alpha = 0.5;
        [PostsScroll addSubview:ImageShade_];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(0, GetHeight_ + i, screenWidth, 340);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(ImageButtonOnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [PostsScroll addSubview:SelectButton];
        
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(15, 259 + GetHeight_ + i, 8, 11);
        [PostsScroll addSubview:ShowPin];
        
        NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[PostsData_DistanceArray objectAtIndex:i]];
        if ([TempDistanceString isEqualToString:@"0"]) {
            
        }else{
            CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
            int x_Nearby = [TempDistanceString intValue] / 1000;
            // NSLog(@"x_Nearby is %i",x_Nearby);
            
            NSString *FullShowLocatinString;
            if (x_Nearby < 100) {
                if (x_Nearby <= 1) {
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within 1km"];
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"within %.fkm",strFloat];
                }
                
            }else{
                FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[PostsData_SearchDisplayNameArray objectAtIndex:i]];
                
            }
            
            //  NSLog(@"FullShowLocatinString is %@",FullShowLocatinString);
            
            UILabel *ShowDistance = [[UILabel alloc]init];
            ShowDistance.frame = CGRectMake(screenWidth - 115, 254 + GetHeight_ + i, 100, 20);
            ShowDistance.text = FullShowLocatinString;
            ShowDistance.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowDistance.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowDistance.textAlignment = NSTextAlignmentRight;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [PostsScroll addSubview:ShowDistance];
        }
        
        
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(30, 254 + GetHeight_ + i, screenWidth - 150, 20);
        ShowAddress.text = [PostsData_place_nameArray objectAtIndex:i];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowAddress.backgroundColor = [UIColor clearColor];
        [PostsScroll addSubview:ShowAddress];
        
        
        
        GetHeight_ += 284;
        NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[PostsData_TitleArray objectAtIndex:i]];
        if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
        }else{
            UILabel *TempShowTitle = [[UILabel alloc]init];
            TempShowTitle.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30, 40);
            TempShowTitle.text = TempGetStirng;
            TempShowTitle.backgroundColor = [UIColor clearColor];
            TempShowTitle.numberOfLines = 2;
            TempShowTitle.textAlignment = NSTextAlignmentLeft;
            TempShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            TempShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            //            ShowTitle.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetStirng
            //                                                                                               tracking:100
            //                                                                                                   font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            [PostsScroll addSubview:TempShowTitle];
            
            if([TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=TempShowTitle.frame.size.height)
            {
                TempShowTitle.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30,[TempShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            GetHeight_ += TempShowTitle.frame.size.height + 10;
            
            //   heightcheck += 30;
        }
        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[PostsData_MessageArray objectAtIndex:i]];
        TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
        if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
        }else{
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30, 40);
            //  ShowMessage.text = TempGetMessage;
            NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",TempGetMessage];
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
            
            [ShowMessage setAttributedText:string];
            
            ShowMessage.backgroundColor = [UIColor clearColor];
            ShowMessage.numberOfLines = 3;
            ShowMessage.textAlignment = NSTextAlignmentLeft;
            ShowMessage.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            //            ShowMessage.attributedText = [NSAttributedString dvs_attributedStringWithString:TempGetMessage
            //                                                                                 tracking:100
            //                                                                                     font:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [PostsScroll addSubview:ShowMessage];
            
            if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
            {
                ShowMessage.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            GetHeight_ += ShowMessage.frame.size.height + 10;
            //   heightcheck += 30;
        }
        
        
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(15, GetHeight_ + i , 30, 30);
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius = 15;
        ShowUserProfileImage.layer.borderWidth=0;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [PostsScroll addSubview:ShowUserProfileImage];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[PostsData_UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
            //NSLog(@"url is %@",url);
            ShowUserProfileImage.imageURL = url_NearbySmall;
        }
        
        
        UIButton *OpenProfileButton = [[UIButton alloc]initWithFrame:CGRectMake(15, GetHeight_ + i , 200, 30)];
        [OpenProfileButton setTitle:@"" forState:UIControlStateNormal];
        OpenProfileButton.tag = i;
        OpenProfileButton.backgroundColor = [UIColor clearColor];
        //[OpenProfileButton addTarget:self action:@selector(ExpertsButton:) forControlEvents:UIControlEventTouchUpInside];
        [PostsScroll addSubview:OpenProfileButton];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(55, GetHeight_ + i, 200, 30);
        ShowUserName.text = [PostsData_UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:15];
        [PostsScroll addSubview:ShowUserName];
        
        NSString *CheckCommentTotal = [[NSString alloc]initWithFormat:@"%@",[PostsData_TotalCommentArray objectAtIndex:i]];
        NSString *CheckLikeTotal = [[NSString alloc]initWithFormat:@"%@",[PostsData_TotalLikeArray objectAtIndex:i]];
        NSString *CheckSelfLike = [[NSString alloc]initWithFormat:@"%@",[PostsData_SelfCheckLikeArray objectAtIndex:i]];
        
        
        
        if ([CheckCommentTotal isEqualToString:@"0"]) {
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 23 - 15, GetHeight_ + i + 6 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [PostsScroll addSubview:ShowCommentIcon];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 23 - 15 - 23 - 20 , GetHeight_ + i + 6 ,23, 19);
                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [PostsScroll addSubview:ShowLikesIcon];
            }else{
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                //    ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 78 - 23, GetHeight_ + i + 6 ,23, 19);
                [PostsScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 78, GetHeight_ + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
                //    ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [PostsScroll addSubview:ShowLikeCount];
            }
        }else{
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(screenWidth - 35 - 23 , GetHeight_ + i + 6 ,23, 19);
            //  ShowCommentIcon.backgroundColor = [UIColor redColor];
            [PostsScroll addSubview:ShowCommentIcon];
            
            UILabel *ShowCommentCount = [[UILabel alloc]init];
            ShowCommentCount.frame = CGRectMake(screenWidth - 20 - 15, GetHeight_ + i, 20, 30);
            ShowCommentCount.text = CheckCommentTotal;
            ShowCommentCount.textAlignment = NSTextAlignmentRight;
            //   ShowCommentCount.backgroundColor = [UIColor redColor];
            ShowCommentCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowCommentCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            [PostsScroll addSubview:ShowCommentCount];
            
            if ([CheckLikeTotal isEqualToString:@"0"]) {
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 101, GetHeight_ + i + 6 ,23, 19);
                // ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                [PostsScroll addSubview:ShowLikesIcon];
            }else{
                
                UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                }else{
                    ShowLikesIcon.image = [UIImage imageNamed:@"PostLikeRed.png"];
                }
                // ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
                //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
                ShowLikesIcon.frame = CGRectMake(screenWidth - 121, GetHeight_ + i + 6 ,23, 19);
                [PostsScroll addSubview:ShowLikesIcon];
                
                UILabel *ShowLikeCount = [[UILabel alloc]init];
                ShowLikeCount.frame = CGRectMake(screenWidth - 98, GetHeight_ + i, 20, 30);
                ShowLikeCount.text = CheckLikeTotal;
                ShowLikeCount.textAlignment = NSTextAlignmentRight;
                if ([CheckSelfLike isEqualToString:@"0"]) {
                    ShowLikeCount.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                }else{
                    ShowLikeCount.textColor = [UIColor colorWithRed:248.0f/255.0f green:78.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
                }
                // ShowLikeCount.backgroundColor = [UIColor purpleColor];
                ShowLikeCount.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                [PostsScroll addSubview:ShowLikeCount];
            }
            
            
        }
        
        
        GetHeight_ += 55;
        
        UIImageView *ShowGradient = [[UIImageView alloc]init];
        ShowGradient.frame = CGRectMake(0, GetHeight_ + i, screenWidth, 25);
        ShowGradient.image = [UIImage imageNamed:@"FeedGradient.png"];
        [PostsScroll addSubview:ShowGradient];
        GetHeight_ += 24;
        
        // [PostsScroll setContentSize:CGSizeMake(screenWidth, GetHeight + i)];
        
        //[MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight_ + PostsScroll.frame.size.height + 20)];
        
    }
    PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, GetHeight_ + 20);
    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + PostsScroll.frame.size.height)];
}
-(void)InitLikeData{
    for (UIView *subview in LikesScroll.subviews) {
        [subview removeFromSuperview];
    }
    NSLog(@"Init Likes click");
    NSLog(@"init DataCount is %li",(long)DataCount);
    NSLog(@"init DataTotal is %li",(long)DataTotal);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    LikesScroll = [[UIScrollView alloc]init];
    LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, 250);
    LikesScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:LikesScroll];
    
    int TestWidth = screenWidth - 2;
    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 1;
    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 1;
    
    for (NSInteger i = 0; i < DataTotal; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[LikesData_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        ShowImage.frame = CGRectMake(1+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [LikesScroll addSubview:ShowImage];
        
        
        UIButton *ImageButton = [[UIButton alloc]init];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        ImageButton.frame = CGRectMake(1+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ImageButtonOnClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        [LikesScroll addSubview:ImageButton];
        //[MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
        LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, 0 + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }
    
    
    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikesScroll.frame.size.height)];
}
-(void)GetUserWallpaper{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    //https://dev-api.seeties.me/eb2ec552c5b10448c4d447d9beb62743/wallpaper/l?token=JDJ5JDA4JFhCTFhDYVNZZ2xqZElLRXBnRVYya3VwdE00ZkFsWkJSU21SdXU3YUhwYS94SUNJeTU4dzJT
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/wallpaper/l?token=%@",DataUrl.UserWallpaper_Url,GetUID,GetExpertToken];
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
    // NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
    NSLog(@"User Wallpaper FullString ====== %@",FullString);
    NSURL *url_UserImage = [NSURL URLWithString:FullString];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowUserWallpaperImage.imageURL = url_UserImage;
    
    
    [self GetPostsData];
}
-(void)GetUserData{
    
   // [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@expert/%@?token=%@",DataUrl.UserWallpaper_Url,GetUserName,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
-(void)GetPostsData{
    if (CurrentPage_Post == TotalPage_Post) {
        
    }else{
        CurrentPage_Post += 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/posts?token=%@&page=%li",DataUrl.UserWallpaper_Url,GetUID,GetExpertToken,CurrentPage_Post];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetPostsData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetPostsData start];
    
    
    if( theConnection_GetPostsData ){
        webData = [NSMutableData data];
    }
    }
}
-(void)GetLikesData{
    
    ShowActivityLike = [[UIActivityIndicatorView alloc]init];
    ShowActivityLike.frame = CGRectMake((PostControl.frame.size.width /2) + 50, PostControl.frame.origin.y + 5 , 20, 20);
    [ShowActivityLike setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    //[ShowActivityLike setColor:[UIColor redColor]];
    [MainScroll addSubview:ShowActivityLike];
    [ShowActivityLike startAnimating];
    
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@&page=%li",DataUrl.UserWallpaper_Url,GetUID,GetExpertToken,CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetLikesData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetLikesData start];
        
        
        if( theConnection_GetLikesData ){
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
//    [self.spinnerView stopAnimating];
//    [self.spinnerView removeFromSuperview];
    [ShowActivity stopAnimating];
    CheckLoadDone = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetUserData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"User Data return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"res is %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            
            GetName = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
            NSLog(@"GetName is %@",GetName);
            Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            GetEmail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",GetEmail);
            GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
            NSLog(@"GetLocation is %@",GetLocation);
            GetAbouts = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"GetAbouts is %@",GetAbouts);
            GetUrl = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"personal_link"]];
            NSLog(@"GetUrl is %@",GetUrl);
            GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"follower_count"]];
            NSLog(@"GetFollowersCount is %@",GetFollowersCount);
            GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"following_count"]];
            NSLog(@"GetFollowingCount is %@",GetFollowingCount);
            Getcategories = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"categories"]];
            NSLog(@"Getcategories is %@",Getcategories);
            Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            GetGender = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
            NSLog(@"GetGender is %@",GetGender);
            NSDictionary *ProfilePhotoData = [res valueForKey:@"profile_photo_images"];
            Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[ProfilePhotoData objectForKey:@"l"]];
            //Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"profile_photo"]];
            NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            Getrole = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"role"]];
            NSLog(@"Getrole is %@",Getrole);
            GetUID = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"uid"]];
            NSLog(@"GetUID is %@",GetUID);
            GetUserFollowing = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"followed"]];
            NSLog(@"FollowedCheck is %@",GetUserFollowing);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
            
            NSDictionary *WallpaperData = [res valueForKey:@"wallpaper"];
            GetWallpaper = [[NSString alloc]initWithFormat:@"%@",[WallpaperData objectForKey:@"s"]];
            NSLog(@"GetWallpaper is %@",GetWallpaper);
            
//            NSDictionary *LanguageData = [res valueForKey:@"languages"];
//             NSMutableArray *TempArray = [[NSMutableArray alloc]init];
//            if (LanguageData == NULL || [ LanguageData count ] == 0) {
//               GetLanguage_1 = @"English";
//               GetLanguage_2 = @"";
//            }else{
//                for (NSDictionary * dict in LanguageData) {
//                    NSString *GetTempLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
//                    [TempArray addObject:GetTempLanguage_1];
//                }
//                NSLog(@"TempArray is %@",TempArray);
//                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
//                if ([TempArray count] == 1) {
//                    GetLanguage_2 = @"";
//                }else{
//                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
//                }
//            }
//           
//
//            NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
//            NSLog(@"GetLanguage_2 is %@",GetLanguage_2);
            
           // ShowName.text = GetName;
            NSString *TempGetName = [[NSString alloc]initWithFormat:@"@%@",Getusername];
            ShowName.text = TempGetName;
            
            NSDictionary *badgesData = [res valueForKey:@"badges"];
            BadgesNameArray = [[NSMutableArray alloc]init];
            BadgesImageArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in badgesData) {
                NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [BadgesNameArray addObject:Getname];
                NSString *Getpicture = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"picture"]];
                [BadgesImageArray addObject:Getpicture];
            }
            NSLog(@"BadgesNameArray is %@",BadgesNameArray);
            NSLog(@"BadgesImageArray is %@",BadgesImageArray);
            
            if ([BadgesImageArray count] == 0) {
                AwardCheck = @"no";
            }else{
                AwardCheck = @"no";
            }
            
            
            
            ShowUserProfile.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfile.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfile.layer.cornerRadius=50;
            ShowUserProfile.layer.borderWidth=2.5;
            ShowUserProfile.layer.masksToBounds = YES;
            ShowUserProfile.layer.borderColor=[[UIColor whiteColor] CGColor];
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",Getprofile_photo];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
                ShowUserProfile.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                ShowUserProfile.imageURL = url_UserImage;
            }
            [self GetUserWallpaper];
            
          //  [self GetPostsData];
        }
    }else if(connection == theConnection_GetPostsData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"User Post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //  NSLog(@"Feed Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            GetPostsDataCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
            NSLog(@"GetPostsDataCount is %@",GetPostsDataCount);
            if ([GetPostsDataCount isEqualToString:@"0"]) {
                 GetLikesDataCount = @"0";
                [self InitView];
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                //NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
                NSLog(@"page is %@",page);
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                NSLog(@"total_page is %@",total_page);
                CurrentPage_Post = [page intValue];
                TotalPage_Post = [total_page intValue];
                
                if (CheckFirstTimeLoadPost == 0) {
                    PostsData_IDArray = [[NSMutableArray alloc]init];
                    PostsData_PhotoArray = [[NSMutableArray alloc]init];
                    DataCount_Post = 0;
                    PostsData_DistanceArray = [[NSMutableArray alloc]init];
                    PostsData_SearchDisplayNameArray = [[NSMutableArray alloc]init];
                    PostsData_TitleArray = [[NSMutableArray alloc]init];
                    PostsData_MessageArray = [[NSMutableArray alloc]init];
                    PostsData_place_nameArray = [[NSMutableArray alloc]init];
                    PostsData_SelfCheckLikeArray = [[NSMutableArray alloc]init];
                    PostsData_TotalLikeArray = [[NSMutableArray alloc]init];
                    PostsData_TotalCommentArray = [[NSMutableArray alloc]init];
                    PostsData_UserInfo_UrlArray = [[NSMutableArray alloc]init];
                    PostsData_UserInfo_NameArray = [[NSMutableArray alloc]init];
                }else{
                    
                }
                
               // PostsData_IDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetAllData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostsData_IDArray addObject:PlaceID];
                    NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [PostsData_place_nameArray addObject:PlaceName];
                    NSString *SelfCheck = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"like"]];
                    [PostsData_SelfCheckLikeArray addObject:SelfCheck];
                    NSString *total_like = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                    [PostsData_TotalLikeArray addObject:total_like];
                    NSString *total_comments = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                    [PostsData_TotalCommentArray addObject:total_comments];
                }
                NSLog(@"PostsData_IDArray is %@",PostsData_IDArray);
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                //NSLog(@"PhotoData is %@",PhotoData);
                
              //  PostsData_PhotoArray = [[NSMutableArray alloc]init];
                
                for (NSDictionary * dict in PhotoData) {
                    NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict_ in dict) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                        
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                        [UrlArray addObject:url];
                    }
                    NSString *result2 = [UrlArray componentsJoinedByString:@","];
                    [PostsData_PhotoArray addObject:result2];
                }
                NSLog(@"PostsData_PhotoArray is %@",PostsData_PhotoArray);
                GetLikesDataCount = @"0";
//                [self InitView];
//                [self GetLikesData];
                
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                for (NSDictionary * dict in locationData) {
                    NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                    [PostsData_DistanceArray addObject:formatted_address];
                    NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                    [PostsData_SearchDisplayNameArray addObject:SearchDisplayName];
                }
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                
                
                for (NSDictionary * dict in titleData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                        [PostsData_TitleArray addObject:@""];
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
                                            [PostsData_TitleArray addObject:@""];
                                        }else{
                                            [PostsData_TitleArray addObject:PhilippinesTitle_Nearby];
                                            
                                        }
                                    }else{
                                        [PostsData_TitleArray addObject:IndonesianTitle_Nearby];
                                        
                                    }
                                }else{
                                    [PostsData_TitleArray addObject:ThaiTitle_Nearby];
                                }
                            }else{
                                [PostsData_TitleArray addObject:Title2];
                            }
                            
                        }else{
                            [PostsData_TitleArray addObject:Title1];
                            
                        }
                        
                    }
                    
                }
                NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                
                for (NSDictionary * dict in messageData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                        [PostsData_MessageArray addObject:@""];
                        
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
                                            [PostsData_MessageArray addObject:@""];
                                        }else{
                                            [PostsData_MessageArray addObject:PhilippinesTitle_Nearby];
                                            
                                        }
                                    }else{
                                        [PostsData_MessageArray addObject:IndonesianTitle_Nearby];
                                        
                                    }
                                }else{
                                    [PostsData_MessageArray addObject:ThaiTitle_Nearby];
                                }
                            }else{
                                [PostsData_MessageArray addObject:Title2];
                            }
                            
                        }else{
                            [PostsData_MessageArray addObject:Title1];
                            
                        }
                        
                    }
                    
                }
                
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
                NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];

                for (NSDictionary * dict in UserInfoData) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                    [PostsData_UserInfo_NameArray addObject:username];
                }

                for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                    [PostsData_UserInfo_UrlArray addObject:url];
                }
                
                
                DataCount_Post = DataTotal_Post;
                DataTotal_Post = [PostsData_IDArray count];
                
                NSLog(@"DataCount_Post in get server data === %li",(long)DataCount_Post);
                NSLog(@"DataTotal_Post in get server data === %li",(long)DataTotal_Post);
                NSLog(@"CheckFirstTimeLoadPost === %li",(long)CheckFirstTimeLoadPost);
                //[self InitView];
                CheckLoad_Post = NO;
                
                if (CheckFirstTimeLoadPost == 0) {
                    CheckFirstTimeLoadPost = 1;
                    [self InitView];
                    [self GetLikesData];
                }else{
                    [self InitPostsData];
                }
            }
        }
    }else if(connection == theConnection_GetLikesData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Likes return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Feed Json = %@",res);
        
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
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"posts"];
                // NSLog(@"GetAllData ===== %@",GetAllData);
                GetLikesDataCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_posts"]];
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
                NSLog(@"page is %@",page);
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                NSLog(@"total_page is %@",total_page);
                CurrentPage = [page intValue];
                TotalPage = [total_page intValue];
                
                if (CheckFirstTimeLoadLikes == 0) {
                    LikesData_IDArray = [[NSMutableArray alloc]init];
                    LikesData_PhotoArray = [[NSMutableArray alloc]init];
                    DataCount = 0;
                    
                }else{
                    
                }
                //LikesData_IDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetAllData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [LikesData_IDArray addObject:PlaceID];
                }
                NSLog(@"LikesData_IDArray is %@",LikesData_IDArray);
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                //NSLog(@"PhotoData is %@",PhotoData);
                
                //LikesData_PhotoArray = [[NSMutableArray alloc]init];
                
                for (NSDictionary * dict in PhotoData) {
                    NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict_ in dict) {
                        NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                        
                        NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                        [UrlArray addObject:url];
                    }
                    NSString *result2 = [UrlArray componentsJoinedByString:@","];
                    [LikesData_PhotoArray addObject:result2];
                }
                NSLog(@"LikesData_PhotoArray is %@",LikesData_PhotoArray);
                
                
                DataCount = DataTotal;
                DataTotal = [LikesData_IDArray count];
                
                NSLog(@"DataCount in get server data === %li",(long)DataCount);
                NSLog(@"DataTotal in get server data === %li",(long)DataTotal);
                NSLog(@"CheckFirstTimeLoadLikes === %li",(long)CheckFirstTimeLoadLikes);
                //[self InitView];
                CheckLoad_Likes = NO;
                
                if (CheckFirstTimeLoadLikes == 0) {
                    CheckFirstTimeLoadLikes = 1;
                    [self InitView];
                    
                }else{
                    [self InitLikeData];
                }
                [ShowActivityLike stopAnimating];
            }
        }
    }else if(connection == theConnection_SendFollow){
        
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Following return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        NSString *ResultString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"ResultString is %@",ResultString);
        
        if ([ResultString isEqualToString:@"ok"]) {
            FollowButton.userInteractionEnabled = YES;
            if ([GetUserFollowing isEqualToString:@"0"]) {
                GetUserFollowing = @"1";
                [FollowButton setImage:[UIImage imageNamed:@"Following.png"] forState:UIControlStateNormal];
                
            }else{
                GetUserFollowing = @"0";
                [FollowButton setImage:[UIImage imageNamed:@"Follow.png"] forState:UIControlStateNormal];
            }
            
        }
    }
}
-(IBAction)OpenUrlButton:(id)sender{
    NSLog(@"OpenUrlButton Click.");
    if ([GetUrl hasPrefix:@"http://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetUrl]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",GetUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }
    
}
-(IBAction)ShowAll_FollowerButton:(id)sender{
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ShowFollowerAndFollowingView animated:NO completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:GetUID GetType:@"Follower"];
}
-(IBAction)ShowAll_FollowingButton:(id)sender{
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ShowFollowerAndFollowingView animated:NO completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:GetUID GetType:@"Following"];
}
-(IBAction)ShareButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"ShareToFacebook", nil),CustomLocalisedString(@"CopyLink", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 200;
    
}
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
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"Share to Facebook"]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/%@",GetUserName];
            
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
                                               @"", @"caption",
                                               @"", @"description",
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
            
            NSString *message = [NSString stringWithFormat:@"I found this awesome profile on Seeties - check it out! \n\nhttps://seeties.me/%@",GetUserName];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }
    
}
-(IBAction)ClickFullImageButton:(id)sender{
    NSLog(@"Click full image button");
    FullImageViewController *FullImageView = [[FullImageViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FullImageView animated:NO completion:nil];
    [FullImageView GetImageString:Getprofile_photo];
    
}
-(IBAction)FollowButton:(id)sender{
    NSLog(@"FollowingButton Click.");
    FollowButton.userInteractionEnabled = NO;
    
    if ([GetUserFollowing isEqualToString:@"1"]) {
        
      //  NSString *tempStirng = [[NSString alloc]initWithFormat:@"Unfollow %@ ?",GetUserName];
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",CustomLocalisedString(@"StopFollowing", nil),GetUserName];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:tempStirng delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Unfollow", nil), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
    }else{
    [self SendFollowingData];
    }
}
-(void)SendFollowingData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/follow?token=%@",DataUrl.UserWallpaper_Url,GetUID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    if ([GetUserFollowing isEqualToString:@"1"]) {
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
//    [body appendData:[[NSString stringWithFormat:@"%@",GetUserFollowing] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    theConnection_SendFollow = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_SendFollow) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
    
}
-(IBAction)ImageButtonOnClick1:(id)sender{
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
    [FeedDetailView GetPostID:[PostsData_IDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ImageButtonOnClick2:(id)sender{
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
    [FeedDetailView GetPostID:[LikesData_IDArray objectAtIndex:getbuttonIDN]];
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
            
            if (segmentActionCheck == 0) {
                NSLog(@"Post View scroll end");
                if (CheckLoad_Post == YES) {
                    
                }else{
                    CheckLoad_Post = YES;
                    if (CurrentPage_Post == TotalPage_Post) {
                        
                    }else{
                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                        
                        PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, PostsScroll.frame.size.height + 20);
                        UIActivityIndicatorView * activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, PostsScroll.frame.size.height, 30, 30)];
                        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                        [PostsScroll addSubview:activityindicator1];
                        [activityindicator1 startAnimating];
                        PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, PostsScroll.frame.size.height + 70);
                        [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + PostsScroll.frame.size.height)];
                        
                        [self GetPostsData];
                    }
                    
                }
            }else if (segmentActionCheck == 1) {
                NSLog(@"like View scroll end");
                if (CheckLoad_Likes == YES) {
                    
                }else{
                    CheckLoad_Likes = YES;
                    if (CurrentPage == TotalPage) {
                        
                    }else{
                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                        
                        LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, LikesScroll.frame.size.height + 20);
                        UIActivityIndicatorView * activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, LikesScroll.frame.size.height, 30, 30)];
                        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                        [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                        [LikesScroll addSubview:activityindicator1];
                        [activityindicator1 startAnimating];
                        LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, LikesScroll.frame.size.height + 70);
                        [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikesScroll.frame.size.height)];
                        
                        [self GetLikesData];
                    }
                    
                }
            }
            
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1200) {
        if (buttonIndex == [alertView cancelButtonIndex]){
        }else{
            //reset clicked
            [self SendFollowingData];
        }
    }
}
@end

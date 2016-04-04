//
//  ProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "ProfileV2ViewController.h"
#import "ShowFollowerAndFollowingViewController.h"
#import "SubmitProfileViewController.h"
#import "SettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FullImageViewController.h"
#import "FeedV2DetailViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "NSString+ChangeAsciiString.h"

@interface ProfileV2ViewController ()

@end

@implementation ProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    MainScroll.frame = CGRectMake(0, 44, screenWidth, screenHeight - 94);
    ShowUserWallpaperImage.frame = CGRectMake(0, 0, screenWidth, 240);
    ImgShade.frame = CGRectMake(0, 0, screenWidth, 174);
    DataUrl = [[UrlDataClass alloc]init];
    MainScroll.delegate = self;
    SettingBarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    segmentActionCheck = 0;
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    TopBarView.frame = CGRectMake(0, 0, screenWidth, 64);
    ShareButton.frame = CGRectMake(screenWidth - 55, 0, 55, 64);
    ShareIcon.frame = CGRectMake(screenWidth - 17 - 15, 27, 17, 24);
    ShowName.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    FullImageButton.frame = CGRectMake((screenWidth/2) - 50, 162, 100, 100);
    ShowUserProfile.frame = CGRectMake((screenWidth/2) - 50, 162, 100, 100);
    ShowUserProfile.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserProfile.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserProfile.layer.cornerRadius=50;
    ShowUserProfile.layer.borderWidth=2.5;
    ShowUserProfile.layer.masksToBounds = YES;
    ShowUserProfile.layer.borderColor=[[UIColor whiteColor] CGColor];

    ShowKosongData_1.text = CustomLocalisedString(@"Toomuchwhitespacehere", nil);
    ShowKosongData_2.text = CustomLocalisedString(@"Recommendsomethingcoolnow", nil);
    
    ArrowIcon.frame = CGRectMake((screenWidth / 2) - 8, 68, 16, 16);
    ShowKosongData_1.frame = CGRectMake(15, 17, screenWidth - 30, 21);
    ShowKosongData_2.frame = CGRectMake(15, 39, screenWidth - 30, 21);
    
    KosongView.hidden = YES;
    KosongView.frame = CGRectMake(0, screenHeight - 150, screenWidth, 100);
    KosongViewButton.frame = CGRectMake(0, 0, screenWidth, 100);
    CheckLoadDone = NO;
    CheckLoad_Likes = NO;
    CheckFirstTimeLoadLikes = 0;
    CheckFirstTimeLoadPost = 0;
    TotalPage = 1;
    CurrentPage = 0;
    TotalPage_Post = 1;
    CurrentPage_Post = 0;
    [self GetUserWallpaper];
    //[self InitView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.screenName = @"IOS Profile V2";

    if (screenWidth > 320) {
        NSLog(@"iphone 6 / iphone 6 plus");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 175 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed.png"];
      //  [self.tabBarController.view addSubview:ShowImage_Feed];
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 100, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore.png"];
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
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile_on.png"];
        [self.tabBarController.view addSubview:ShowImage_Profile];
    }else{
        NSLog(@"iphone 5 / iphone 5s / iphone 4");
        UIImageView *ShowImage_Feed = [[UIImageView alloc]init];
        ShowImage_Feed.frame = CGRectMake((screenWidth / 2) - 153 , screenHeight - 50, 50, 50);
        ShowImage_Feed.image = [UIImage imageNamed:@"TabBarFeed.png"];
       // [self.tabBarController.view addSubview:ShowImage_Feed];
        
        UIImageView *ShowImage_Explore = [[UIImageView alloc]init];
        ShowImage_Explore.frame = CGRectMake((screenWidth / 2) - 89, screenHeight - 50, 50, 50);
        ShowImage_Explore.image = [UIImage imageNamed:@"TabBarExplore.png"];
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
        ShowImage_Profile.image = [UIImage imageNamed:@"TabBarProfile_on.png"];
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
    // EditProfilePhoto EditCoverPhoto EditSettings
    if ([CheckGoWhere isEqualToString:@"EditProfilePhoto"] || [CheckGoWhere isEqualToString:@"EditCoverPhoto"] || [CheckGoWhere isEqualToString:@"EditSettings"]) {
       // [self GetUserWallpaper];
        for (UIView *subview in MainScroll.subviews) {
            [subview removeFromSuperview];
        }
        [self GetUserData];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckSelfDelete = [defaults objectForKey:@"SelfDeletePost_Profile"];
    if ([CheckSelfDelete isEqualToString:@"YES"]) {
        CheckLoadDone = NO;
        CheckLoad_Likes = NO;
        CheckFirstTimeLoadLikes = 0;
        CheckFirstTimeLoadPost = 0;
        TotalPage = 1;
        CurrentPage = 0;
        TotalPage_Post = 1;
        CurrentPage_Post = 0;
        [self GetUserWallpaper];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"SelfDeletePost_Profile"];
        [defaults synchronize];
    }
    
    
    if (CheckLoadDone == NO) {
//        spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//        spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//        spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//        spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//        spinnerView.lineWidth = 1.0f;
//        [self.view addSubview:spinnerView];
//        [spinnerView startAnimating];
        [ShowActivity startAnimating];
    }else{
        [self ChecklikeCount];
    }
    
    
}
-(IBAction)KosongViewButton:(id)sender{

    KosongView.hidden = YES;
}
-(IBAction)BackToTopButton:(id)sender{
    self.tabBarController.selectedIndex = 0;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ShowActivity stopAnimating];
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
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
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         TopBarView.frame = CGRectMake(0, -64, screenWidth, 64);
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //  [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
            [refreshControl endRefreshing];
            NSLog(@"refresh end");
            for (UIView *subview in MainScroll.subviews) {
                [subview removeFromSuperview];
            }
            CheckLoadDone = NO;
            CheckLoad_Likes = NO;
            CheckFirstTimeLoadLikes = 0;
            CheckFirstTimeLoadPost = 0;
            TotalPage = 1;
            CurrentPage = 0;
            TotalPage_Post = 1;
            CurrentPage_Post = 0;
            

            CheckLoadDone = NO;
            if (CheckLoadDone == NO) {
//                spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
//                spinnerView.bounds = CGRectMake(0, 0, 60, 60);
//                spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
//                spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//                spinnerView.lineWidth = 1.0f;
//                [self.view addSubview:spinnerView];
//                [spinnerView startAnimating];
                [ShowActivity startAnimating];
            }
            [self GetUserWallpaper];
            
        });
    });
}
-(void)InitView{
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  //   CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //BackgroundImage.image = [UIImage imageNamed:@"ProfileBlank.png"];
    
//    UIButton *HideButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [HideButton setTitle:@"" forState:UIControlStateNormal];
//    [HideButton setFrame:CGRectMake(0, 174, screenWidth, screenHeight)];
//    [HideButton setBackgroundColor:[UIColor clearColor]];
//    [HideButton addTarget:self action:@selector(HideButton:) forControlEvents:UIControlEventTouchUpInside];
//    [MainScroll addSubview:HideButton];
    ImageShade.image = [UIImage imageNamed:@"ImageShade.png"];
    [MainScroll addSubview:BackgroundImage];
    [MainScroll addSubview:ShowUserWallpaperImage];
    [MainScroll addSubview:ImageShade];
    [MainScroll addSubview:ShowUserProfile];
    [MainScroll addSubview:FullImageButton];
    

    
    
    
    UILabel *ShowName_ = [[UILabel alloc]init];//getname
    ShowName_.frame = CGRectMake(15, 262, screenWidth - 30, 30);
    ShowName_.text = GetName;
    ShowName_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowName_.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
    ShowName_.textAlignment = NSTextAlignmentCenter;
    ShowName_.backgroundColor = [UIColor clearColor];
    [MainScroll addSubview:ShowName_];
    
    UILabel *ShowLocation = [[UILabel alloc]init];
    ShowLocation.frame = CGRectMake(15, 287, screenWidth - 30, 20);
    ShowLocation.text = GetLocation;
    ShowLocation.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    ShowLocation.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowLocation.textAlignment = NSTextAlignmentCenter;
    ShowLocation.backgroundColor = [UIColor clearColor];
    [MainScroll addSubview:ShowLocation];
    
    
    
    GetHeight = 322;
    
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
        
        GetHeight += ShowAboutText.frame.size.height;
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
        
        GetHeight += 40;
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
            AsyncImageView *ShowAwardImg = [[AsyncImageView alloc]init];
            ShowAwardImg.frame = CGRectMake(0 + i * 60 , 0, 50, 50);
//            ShowAwardImg.image = [UIImage imageNamed:@"Demo001.png"];
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
    ShowTextFollowers.text = CustomLocalisedString(@"FOLLOWERS", nil);
    ShowTextFollowers.frame = CGRectMake((screenWidth/2) - 121, GetHeight, 100, 21);
    ShowTextFollowers.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    ShowTextFollowers.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowTextFollowers.textAlignment = NSTextAlignmentCenter;
    ShowTextFollowers.backgroundColor = [UIColor clearColor];
    [MainScroll addSubview:ShowTextFollowers];
    
//    GetFollowersCount = @"chong chee yong";
//    GetFollowingCount = @"yip how mei";
    
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
    
    UILabel *ShowTextFollowing = [[UILabel alloc]init];
    ShowTextFollowing.text = CustomLocalisedString(@"FOLLOWING", nil);
    ShowTextFollowing.frame = CGRectMake((screenWidth/2) + 21, GetHeight, 100, 21);
    ShowTextFollowing.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    ShowTextFollowing.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowTextFollowing.backgroundColor = [UIColor clearColor];
    ShowTextFollowing.textAlignment = NSTextAlignmentCenter;
    [MainScroll addSubview:ShowTextFollowing];
    
    UILabel *ShowFollowingCount = [[UILabel alloc]init];
    ShowFollowingCount.text = GetFollowingCount;
    ShowFollowingCount.frame = CGRectMake((screenWidth/2) + 21, GetHeight  + 20, 100, 21);
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
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:Line01];
    
    GetHeight += 20;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"%@ %@",GetPostsDataCount,CustomLocalisedString(@"Posts", nil)];
    NSString *TempStringLikes = [[NSString alloc]initWithFormat:@"%@ %@",GetLikesDataCount,CustomLocalisedString(@"MainTab_Like", nil)];
    NSString *TempStringDrafts = [[NSString alloc]initWithFormat:@"%@ %@",GetDraftsDataCount,CustomLocalisedString(@"Drafts", nil)];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringLikes,TempStringDrafts, nil];
    PostControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    PostControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 29);
    [PostControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    PostControl.selectedSegmentIndex = segmentActionCheck;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:41.0f/255.0f green:182.0f/255.0f blue:246.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:PostControl];
    
    GetHeight += 49;
    

    
    [self InitPostsData];
    [ShowActivity stopAnimating];
    //[MainScroll setContentSize:CGSizeMake(320, 100 + i * HeightGet)];
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    CheckLoadDone = YES;
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Posts click");
            segmentActionCheck = 0;
            LikesScroll.hidden = YES;
            DraftScroll.hidden = YES;
            PostsScroll.hidden = NO;
            [self InitPostsData];
            if ([GetPostsDataCount isEqualToString:@"0"]) {
                KosongView.hidden = NO;
            }else{
                KosongView.hidden = YES;
            }
            break;
        case 1:
            NSLog(@"Likes click");
            segmentActionCheck = 1;
            PostsScroll.hidden = YES;
            DraftScroll.hidden = YES;
            LikesScroll.hidden = NO;
            [self InitLikeData];
            if ([GetLikesDataCount isEqualToString:@"0"]) {
                KosongView.hidden = NO;
            }else{
                KosongView.hidden = YES;
            }
            break;
        case 2:
            NSLog(@"Drafts click");
            PostsScroll.hidden = YES;
            LikesScroll.hidden = YES;
            DraftScroll.hidden = NO;
            segmentActionCheck = 2;
            [self InitDraftData];
            if ([GetDraftsDataCount isEqualToString:@"0"]) {
                KosongView.hidden = NO;
            }else{
                KosongView.hidden = YES;
            }
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitPostsData{
NSLog(@"Init Posts click");

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView *subview in PostsScroll.subviews) {
        [subview removeFromSuperview];
    }
    PostsScroll = [[UIScrollView alloc]init];
    PostsScroll.frame = CGRectMake(0, GetHeight, screenWidth, 250);
    PostsScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:PostsScroll];

    NSLog(@"init DataCount_Post is %li",(long)DataCount_Post);
    NSLog(@"init DataTotal_Post is %li",(long)DataTotal_Post);
    
//    int TestWidth = screenWidth - 2;
//    NSLog(@"TestWidth is %i",TestWidth);
//    int FinalWidth = TestWidth / 3;
//    FinalWidth += 1;
//    NSLog(@"FinalWidth is %i",FinalWidth);
//    int SpaceWidth = FinalWidth + 1;
//    
//    for (int i = 0; i < DataTotal_Post; i++) {
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
//    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + PostsScroll.frame.size.height + 20)];
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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView *subview in LikesScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    LikesScroll = [[UIScrollView alloc]init];
    LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, 250);
    LikesScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:LikesScroll];
    
    NSLog(@"Init Likes click");
    NSLog(@"init DataCount is %li",(long)DataCount);
    NSLog(@"init DataTotal is %li",(long)DataTotal);
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
//    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
//    [LikesScroll addSubview:refreshControl];
    
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
        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
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
        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(ImageButtonOnClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        [LikesScroll addSubview:ImageButton];
        //[MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
        LikesScroll.frame = CGRectMake(0, GetHeight, screenWidth, 0 + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }

    
    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikesScroll.frame.size.height + 20)];
}
-(void)InitDraftData{
    for (UIView *subview in DraftScroll.subviews) {
        [subview removeFromSuperview];
    }
NSLog(@"Init Draft click");
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    DraftScroll = [[UIScrollView alloc]init];
    DraftScroll.frame = CGRectMake(0, GetHeight, screenWidth, 250);
    DraftScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll addSubview:DraftScroll];
    int GetHeight_ = 0;
    for (int i = 0; i < [DraftData_UpdateTimeArray count]; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[DraftsData_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
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
        [DraftScroll addSubview:ShowImage];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"InfoLocation.png"];
        ShowPin.frame = CGRectMake(15, 265 + GetHeight_ + i, 13, 17);
        [DraftScroll addSubview:ShowPin];
        
        UILabel *ShowAddress = [[UILabel alloc]init];
        ShowAddress.frame = CGRectMake(35, 264 + GetHeight_ + i, screenWidth - 150, 20);
        ShowAddress.text = [[DraftData_PlaceNameArray objectAtIndex:i]uppercaseString];
        ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowAddress.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        ShowAddress.backgroundColor = [UIColor clearColor];
        [DraftScroll addSubview:ShowAddress];
        
        GetHeight_ += 305;
        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[DraftData_TitleArray objectAtIndex:i]];
        NSArray *SplitArrayTitle = [TempGetStirngMessage componentsSeparatedByString:@","];
        if ([TempGetStirngMessage isEqualToString:@""] || [TempGetStirngMessage length] == 0 || [TempGetStirngMessage isEqualToString:@"(null)"]) {
        }else{
            UILabel *ShowTitle = [[UILabel alloc]init];
            ShowTitle.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30, 40);
            ShowTitle.text = [SplitArrayTitle objectAtIndex:0];
            ShowTitle.backgroundColor = [UIColor clearColor];
            ShowTitle.numberOfLines = 2;
            ShowTitle.textAlignment = NSTextAlignmentLeft;
            ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
            ShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:17];
            [DraftScroll addSubview:ShowTitle];
            
            if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
            {
                ShowTitle.frame = CGRectMake(15, GetHeight_ + i, screenWidth - 30,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height);
            }
            GetHeight_ += ShowTitle.frame.size.height + 20;
        }
        
        UIButton *EditButton = [[UIButton alloc]init];
        EditButton.frame = CGRectMake((screenWidth/2) - 120, GetHeight_ + i, 100, 45);
        [EditButton setTitle:CustomLocalisedString(@"Edit", nil) forState:UIControlStateNormal];
        EditButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        [EditButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:225.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [EditButton setBackgroundImage:[UIImage imageNamed:@"BtnEdit.png"] forState:UIControlStateNormal];
        EditButton.tag = i;
        [EditButton addTarget:self action:@selector(EditButton:) forControlEvents:UIControlEventTouchUpInside];
        [DraftScroll addSubview:EditButton];
        
        UIButton *DeleteButton = [[UIButton alloc]init];
        DeleteButton.frame = CGRectMake((screenWidth/2) + 20, GetHeight_ + i, 100, 45);
        [DeleteButton setTitle:CustomLocalisedString(@"Delete", nil) forState:UIControlStateNormal];
        DeleteButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        [DeleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [DeleteButton setBackgroundImage:[UIImage imageNamed:@"BtnDelete.png"] forState:UIControlStateNormal];
        DeleteButton.tag = i;
        [DeleteButton addTarget:self action:@selector(DeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [DraftScroll addSubview:DeleteButton];
        
        GetHeight_ += 65;
        
    }
  //  [MainScroll setContentSize:CGSizeMake(320, GetHeight + 50)];

    DraftScroll.frame = CGRectMake(0, GetHeight, screenWidth, GetHeight_ + 50);
    
    
    
    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + DraftScroll.frame.size.height)];
}





-(void)GetUserWallpaper{
    //[ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    //https://dev-api.seeties.me/eb2ec552c5b10448c4d447d9beb62743/wallpaper/l?token=JDJ5JDA4JFhCTFhDYVNZZ2xqZElLRXBnRVYya3VwdE00ZkFsWkJSU21SdXU3YUhwYS94SUNJeTU4dzJT
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/wallpaper/l?token=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
    // NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
    NSLog(@"User Wallpaper FullString ====== %@",FullString);
    NSURL *url_UserImage = [NSURL URLWithString:FullString];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowUserWallpaperImage.imageURL = url_UserImage;
    

    [self GetUserData];
}
-(void)GetUserData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@expert/%@",DataUrl.UserWallpaper_Url,GetUsername];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetUserData check postBack URL ==== %@",postBack);
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
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/posts?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,CurrentPage_Post];
    
    
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
-(void)ChecklikeCount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_CheckLikeCountData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_CheckLikeCountData start];
    
    
    if( theConnection_CheckLikeCountData ){
        webData = [NSMutableData data];
    }
}
-(void)GetLikesData{
    
  //  PostControl
    
    ShowActivityLike = [[UIActivityIndicatorView alloc]init];
    ShowActivityLike.frame = CGRectMake(PostControl.frame.origin.x + 125, PostControl.frame.origin.y + 5 , 20, 20);
    [ShowActivityLike setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:ShowActivityLike];
    [ShowActivityLike startAnimating];
    
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,CurrentPage];
        
        
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
-(void)GetDraftsData{
    
    ShowActivityDraft = [[UIActivityIndicatorView alloc]init];
    ShowActivityDraft.frame = CGRectMake(PostControl.frame.size.width - 95, PostControl.frame.origin.y + 5 , 20, 20);
    [ShowActivityDraft setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:ShowActivityDraft];
    [ShowActivityDraft startAnimating];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@?token=%@",DataUrl.GetDrafts_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetDraftsData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetDraftsData start];
    
    
    if( theConnection_GetDraftsData ){
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
    //[MainScroll setContentSize:CGSizeMake(320, 100 + i * HeightGet)];
//    [spinnerView stopAnimating];
//    [spinnerView removeFromSuperview];
    CheckLoadDone = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetUserData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
      //  NSLog(@"User Data return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
     //   NSLog(@"res is %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
     //   NSLog(@"ErrorString is %@",ErrorString);
     //   NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
     //   NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            
            GetName = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
         //   NSLog(@"GetName is %@",GetName);
            Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
        //    NSLog(@"Getusername is %@",Getusername);
            GetEmail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
        //    NSLog(@"Getemail is %@",GetEmail);
            GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
        //    NSLog(@"GetLocation is %@",GetLocation);
            GetAbouts = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
        //    NSLog(@"GetAbouts is %@",GetAbouts);
            GetUrl = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"personal_link"]];
         //   NSLog(@"GetUrl is %@",GetUrl);
            GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"follower_count"]];
          //  NSLog(@"GetFollowersCount is %@",GetFollowersCount);
            GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"following_count"]];
        //    NSLog(@"GetFollowingCount is %@",GetFollowingCount);
            Getcategories = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"categories"]];
        //    NSLog(@"Getcategories is %@",Getcategories);
            Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
        //    NSLog(@"Getdob is %@",Getdob);
            GetGender = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
        //    NSLog(@"GetGender is %@",GetGender);
            
            NSDictionary *ProfilePhotoData = [res valueForKey:@"profile_photo_images"];
            Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[ProfilePhotoData objectForKey:@"l"]];
            
        //    Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"profile_photo"]];
       //     NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            Getrole = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"role"]];
        //    NSLog(@"Getrole is %@",Getrole);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
         //   NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
            
            NSDictionary *WallpaperData = [res valueForKey:@"wallpaper"];
            GetWallpaper = [[NSString alloc]initWithFormat:@"%@",[WallpaperData objectForKey:@"s"]];
          //  NSLog(@"GetWallpaper is %@",GetWallpaper);
            
            NSDictionary *LanguageData = [res valueForKey:@"languages"];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            if (LanguageData == NULL || [ LanguageData count ] == 0) {
                GetLanguage_1 = @"English";
                GetLanguage_2 = @"";
            }else{
                for (NSDictionary * dict in LanguageData) {
                    NSString *GetTempLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                    [TempArray addObject:GetTempLanguage_1];
                }
                //      NSLog(@"TempArray is %@",TempArray);
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                if ([TempArray count] == 1) {
                    GetLanguage_2 = @"";
                }else{
                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                }
            }

      //      NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
      //      NSLog(@"GetLanguage_2 is %@",GetLanguage_2);
            NSString *TempGetName = [[NSString alloc]initWithFormat:@"@%@",Getusername];
            ShowName.text = TempGetName;
        
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
            
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
        //    NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
            NSURL *url_UserImage = [NSURL URLWithString:GetWallpaper];
            ShowUserWallpaperImage.imageURL = url_UserImage;
            
            
            NSDictionary *badgesData = [res valueForKey:@"badges"];
            BadgesNameArray = [[NSMutableArray alloc]init];
            BadgesImageArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in badgesData) {
                NSString *Getname = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [BadgesNameArray addObject:Getname];
                NSString *Getpicture = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"picture"]];
                [BadgesImageArray addObject:Getpicture];
            }
       //     NSLog(@"BadgesNameArray is %@",BadgesNameArray);
      //      NSLog(@"BadgesImageArray is %@",BadgesImageArray);
            
            if ([BadgesImageArray count] == 0) {
                AwardCheck = @"no";
            }else{
                AwardCheck = @"no";
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *CheckGetUserProfile = @"Done";
            // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
            [defaults setObject:Getprofile_photo forKey:@"UserData_ProfilePhoto"];
            [defaults setObject:Getcategories forKey:@"UserData_Categories"];
            [defaults setObject:GetName forKey:@"UserData_Name"];
            [defaults setObject:Getusername forKey:@"UserData_Username"];
            [defaults setObject:GetAbouts forKey:@"UserData_Abouts"];
            [defaults setObject:GetUrl forKey:@"UserData_Url"];
            [defaults setObject:GetEmail forKey:@"UserData_Email"];
            [defaults setObject:GetLocation forKey:@"UserData_Location"];
            [defaults setObject:Getdob forKey:@"UserData_dob"];
            [defaults setObject:GetGender forKey:@"UserData_Gender"];
            [defaults setObject:GetWallpaper forKey:@"UserData_Wallpaper"];
            [defaults setObject:GetSystemLanguage forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults setObject:GetFollowersCount forKey:@"UserData_FollowersCount"];
            [defaults setObject:GetFollowingCount forKey:@"UserData_FollowingCount"];
            [defaults setObject:Getrole forKey:@"Role"];
            [defaults synchronize];
            
            if ([CheckGoWhere isEqualToString:@"EditProfilePhoto"] || [CheckGoWhere isEqualToString:@"EditCoverPhoto"] || [CheckGoWhere isEqualToString:@"EditSettings"]) {
                [self InitView];
            }else{
                [self GetPostsData];
            }
            
            
        }
    }else if(connection == theConnection_GetPostsData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //     NSLog(@"User Post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //  NSLog(@"Feed Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    //    NSLog(@"ErrorString is %@",ErrorString);
     //   NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    //    NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            GetPostsDataCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
      //      NSLog(@"GetPostsDataCount is %@",GetPostsDataCount);
            if ([GetPostsDataCount isEqualToString:@"0"]) {
                GetLikesDataCount = @"0";
                GetDraftsDataCount = @"0";
                KosongView.hidden = NO;
                [self InitView];
                [self GetLikesData];
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                //NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
         //       NSLog(@"page is %@",page);
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
          //      NSLog(@"total_page is %@",total_page);
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
              //  PostsData_IDArray = [[NSMutableArray alloc]init];
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
        //        NSLog(@"PostsData_IDArray is %@",PostsData_IDArray);
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
          //      NSLog(@"PostsData_PhotoArray is %@",PostsData_PhotoArray);
                
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
                
                
                GetLikesDataCount = @"0";
                GetDraftsDataCount = @"0";
                
                DataCount_Post = DataTotal_Post;
                DataTotal_Post = [PostsData_IDArray count];
                
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
    //    NSLog(@"v ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&myError];
    //    NSLog(@"Feed Json = %@",res);
       // if (myError || [res count] == 0) {
        if (myError) {
      //      NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
    //        NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
       //     NSLog(@"ErrorString is %@",ErrorString);
          //  NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
      //      NSLog(@"MessageString is %@",MessageString);
            
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
                    //        NSLog(@"page is %@",page);
                    NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                    //         NSLog(@"total_page is %@",total_page);
                    CurrentPage = [page intValue];
                    TotalPage = [total_page intValue];
                    
                    //         NSLog(@"CurrentPage in get server data === %li",(long)CurrentPage);
                    //         NSLog(@"TotalPage in get server data === %li",(long)TotalPage);
                    if (CheckFirstTimeLoadLikes == 0) {
                        LikesData_IDArray = [[NSMutableArray alloc]init];
                        LikesData_PhotoArray = [[NSMutableArray alloc]init];
                        DataCount = 0;
                        //  [self GetDraftsData];
                    }else{
                        
                    }
                    
                    
                    for (NSDictionary * dict in GetAllData) {
                        NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [LikesData_IDArray addObject:PlaceID];
                    }
                    //        NSLog(@"LikesData_IDArray is %@",LikesData_IDArray);
                    NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                    //NSLog(@"PhotoData is %@",PhotoData);
                    
                    
                    
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
                    // NSLog(@"LikesData_PhotoArray is %@",LikesData_PhotoArray);
                    
                    DataCount = DataTotal;
                    DataTotal = [LikesData_IDArray count];
                    
                    //       NSLog(@"DataCount in get server data === %li",(long)DataCount);
                    //      NSLog(@"DataTotal in get server data === %li",(long)DataTotal);
                    //    NSLog(@"CheckFirstTimeLoadLikes === %li",(long)CheckFirstTimeLoadLikes);
                    //[self InitView];
                    CheckLoad_Likes = NO;
                    
                    if (CheckFirstTimeLoadLikes == 0) {
                        CheckFirstTimeLoadLikes = 1;
                        [self GetDraftsData];
                        
                    }else{
                        [self InitLikeData];
                    }
                    
                
            }
            
                [ShowActivityLike stopAnimating];

        }
    }else if(connection == theConnection_GetDraftsData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Drafts return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&myError];
        if (myError) {
      //  if (myError || [res count] == 0) {
     //       NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        //    NSLog(@"ErrorString is %@",ErrorString);
         //   NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        //    NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlertView.tag = 300;
                [ShowAlertView show];
            }else{
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                NSLog(@"Draft GetAllData is %@",GetAllData);
                GetDraftsDataCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_posts"]];
                NSLog(@"GetDraftsDataCount is %@",GetDraftsDataCount);
                NSInteger TotalPage_ = [GetDraftsDataCount intValue];
                if (TotalPage_ == 0) {
                    [self InitView];
                }else{
                    
                    NSDictionary *GetAllData_1 = [GetAllData valueForKey:@"posts"];
                    NSDictionary *titleData = [GetAllData_1 valueForKey:@"title"];
                    NSDictionary *MessageData = [GetAllData_1 valueForKey:@"message"];
                    //GetDraftsDataCount = @"7";
                    
                    DraftData_TitleArray = [[NSMutableArray alloc]init];
                    DraftData_TitleCodeArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in titleData) {
                        //NSLog(@"titleData dict is %@",dict);
                        if ([dict count] == 0 || dict == nil || [dict isEqual:[NSNull null]]) {
                            NSLog(@"titleData nil");
                            [DraftData_TitleArray addObject:@""];
                            [DraftData_TitleCodeArray addObject:@""];
                        }else{
                   //         NSLog(@"titleData got data");
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        //    NSLog(@"Title1 is %@",Title1);
                        //    NSLog(@"Title2 is %@",Title2);
                            
                            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                            NSMutableArray *TempArrayCode = [[NSMutableArray alloc]init];
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:Title1];
                                [TempArrayCode addObject:@"530b0aa16424400c76000002"];
                            }
                            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:Title2];
                                [TempArrayCode addObject:@"530b0ab26424400c76000003"];
                            }
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:ThaiTitle];
                                [TempArrayCode addObject:@"544481503efa3ff1588b4567"];
                            }
                            if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:IndonesianTitle];
                                [TempArrayCode addObject:@"53672e863efa3f857f8b4ed2"];
                            }
                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:PhilippinesTitle];
                                [TempArrayCode addObject:@"539fbb273efa3fde3f8b4567"];
                            }
                            
                            NSString *result = [TempArray componentsJoinedByString:@","];
                            [DraftData_TitleArray addObject:result];
                            NSString *result1 = [TempArrayCode componentsJoinedByString:@","];
                            [DraftData_TitleCodeArray addObject:result1];
                        }
                    }
                    NSLog(@"DraftData_TitleArray is %@",DraftData_TitleArray);
                    NSLog(@"DraftData_TitleCodeArray is %@",DraftData_TitleCodeArray);
                    
                    DraftData_MessageArray = [[NSMutableArray alloc]init];
                    DraftData_MessageCodeArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in MessageData) {
                        if ([dict count] == 0 || dict == nil || [dict isEqual:[NSNull null]]) {
                       //     NSLog(@"MessageData nil");
                            [DraftData_MessageArray addObject:@""];
                            [DraftData_MessageCodeArray addObject:@""];
                        }else{
                      //      NSLog(@"MessageData got data");
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    //        NSLog(@"Title1 is %@",Title1);
                     //       NSLog(@"Title2 is %@",Title2);
                            
                            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                            NSMutableArray *TempArrayCode = [[NSMutableArray alloc]init];
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:Title1];
                                [TempArrayCode addObject:@"530b0aa16424400c76000002"];
                            }
                            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:Title2];
                                [TempArrayCode addObject:@"530b0ab26424400c76000003"];
                            }
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:ThaiTitle];
                                [TempArrayCode addObject:@"544481503efa3ff1588b4567"];
                            }
                            if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:IndonesianTitle];
                                [TempArrayCode addObject:@"53672e863efa3f857f8b4ed2"];
                            }
                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                            }else{
                                [TempArray addObject:PhilippinesTitle];
                                [TempArrayCode addObject:@"539fbb273efa3fde3f8b4567"];
                            }
                            
                            NSString *result = [TempArray componentsJoinedByString:@","];
                            [DraftData_MessageArray addObject:result];
                            NSString *result1 = [TempArrayCode componentsJoinedByString:@","];
                            [DraftData_MessageCodeArray addObject:result1];
                        }
                    }
                    NSLog(@"DraftData_MessageArray is %@",DraftData_MessageArray);
                    NSLog(@"DraftData_MessageCodeArray is %@",DraftData_MessageCodeArray);
                    
                    NSDictionary *LocationData = [GetAllData_1 valueForKey:@"location"];
                 //   NSLog(@"DraftData_LocationData is %@",LocationData);
                    
                    DraftData_LatArray = [[NSMutableArray alloc]init];
                    DraftData_LngArray = [[NSMutableArray alloc]init];
                    DraftData_LocationContactArray = [[NSMutableArray alloc]init];
                    DraftData_LocationLinkArray = [[NSMutableArray alloc]init];
                    DraftData_LocationReferenceArray = [[NSMutableArray alloc]init];
                    DraftData_LocationTypeArray = [[NSMutableArray alloc]init];
                    DraftData_LocationPlaceIDArray = [[NSMutableArray alloc]init];
                    
                    DraftData_LocationRouteArray = [[NSMutableArray alloc]init];
                    DraftData_LocationLocalityArray = [[NSMutableArray alloc]init];
                    DraftData_LocationAdministrative_Area_Level_1Array = [[NSMutableArray alloc]init];
                    DraftData_LocationPostalCodeArray = [[NSMutableArray alloc]init];
                    DraftData_LocationCountryArray = [[NSMutableArray alloc]init];
                    
                    DraftData_ExpenseArray = [[NSMutableArray alloc]init];
                    DraftData_ExpenseCodeArray = [[NSMutableArray alloc]init];
                    
                    DraftData_OpenNowArray = [[NSMutableArray alloc]init];
                    DraftData_PeriodsArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in LocationData) {
                   //     NSLog(@"dict is %@",dict);
                        if([dict isKindOfClass: [NSString class]])
                        {
                       //     NSLog(@"handle no data");
                            [DraftData_LatArray addObject:@""];
                            [DraftData_LngArray addObject:@""];
                            [DraftData_LocationContactArray addObject:@""];
                            [DraftData_LocationLinkArray addObject:@""];
                            [DraftData_LocationReferenceArray addObject:@""];
                            [DraftData_LocationTypeArray addObject:@""];
                            
                            [DraftData_LocationRouteArray addObject:@""];
                            [DraftData_LocationLocalityArray addObject:@""];
                            [DraftData_LocationAdministrative_Area_Level_1Array addObject:@""];
                            [DraftData_LocationPostalCodeArray addObject:@""];
                            [DraftData_LocationCountryArray addObject:@""];
                            
                            [DraftData_ExpenseArray addObject:@""];
                            [DraftData_ExpenseCodeArray addObject:@""];
                            
                            [DraftData_OpenNowArray addObject:@""];
                            [DraftData_PeriodsArray addObject:@""];
                        }else{
                         //   NSLog(@"handle got data");
                            NSString *tempLat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                            [DraftData_LatArray addObject:tempLat];
                            NSString *tempLng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                            [DraftData_LngArray addObject:tempLng];
                            NSString *reference = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"reference"]];
                            [DraftData_LocationReferenceArray addObject:reference];
                            NSString *link = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"link"]];
                            [DraftData_LocationLinkArray addObject:link];
                            NSString *contact_no = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"contact_no"]];
                            [DraftData_LocationContactArray addObject:contact_no];
                            NSString *type = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"type"]];
                            [DraftData_LocationTypeArray addObject:type];
                            NSString *place_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_id"]];
                            [DraftData_LocationPlaceIDArray addObject:place_id];
                            
                            NSDictionary *AddressData = [dict valueForKey:@"address_components"];
                            NSString *route = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"route"]];
                            [DraftData_LocationRouteArray addObject:route];
                            NSString *locality = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"locality"]];
                            [DraftData_LocationLocalityArray addObject:locality];
                            NSString *administrative_area_level_1 = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"administrative_area_level_1"]];
                            [DraftData_LocationAdministrative_Area_Level_1Array addObject:administrative_area_level_1];
                            NSString *postal_code = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"postal_code"]];
                            [DraftData_LocationPostalCodeArray addObject:postal_code];
                            NSString *country = [[NSString alloc]initWithFormat:@"%@",[AddressData objectForKey:@"country"]];
                            [DraftData_LocationCountryArray addObject:country];
                            
                            NSDictionary *ExpenseData = [dict valueForKey:@"expense"];
                      //      NSLog(@"ExpenseData is %@",ExpenseData);
                            if ([ExpenseData count] == 0 || ExpenseData == nil || [ExpenseData isEqual:[NSNull null]]) {
                                [DraftData_ExpenseArray addObject:@""];
                                [DraftData_ExpenseCodeArray addObject:@""];
                            }else{
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
                                                            [DraftData_ExpenseArray addObject:@""];
                                                            [DraftData_ExpenseCodeArray addObject:@""];
                                                        }else{
                                                            [DraftData_ExpenseArray addObject:CheckCode007];
                                                            [DraftData_ExpenseCodeArray addObject:@"608"];
                                                        }
                                                    }else{
                                                        [DraftData_ExpenseArray addObject:CheckCode006];
                                                        [DraftData_ExpenseCodeArray addObject:@"901"];
                                                    }
                                                }else{
                                                    [DraftData_ExpenseArray addObject:CheckCode005];
                                                    [DraftData_ExpenseCodeArray addObject:@"360"];
                                                }
                                            }else{
                                                [DraftData_ExpenseArray addObject:CheckCode004];
                                                [DraftData_ExpenseCodeArray addObject:@"764"];
                                            }
                                        }else{
                                            [DraftData_ExpenseArray addObject:CheckCode003];
                                            [DraftData_ExpenseCodeArray addObject:@"702"];
                                        }
                                    }else{
                                        [DraftData_ExpenseArray addObject:CheckCode002];
                                        [DraftData_ExpenseCodeArray addObject:@"458"];
                                    }
                                    
                                }else{
                                    [DraftData_ExpenseArray addObject:CheckCode001];
                                    [DraftData_ExpenseCodeArray addObject:@"840"];
                                }
                            }

                        
                        

                            
                            NSDictionary *OpeningHourData = [dict valueForKey:@"opening_hours"];
                            if ([OpeningHourData count] == 0 || OpeningHourData == nil || [OpeningHourData isEqual:[NSNull null]]) {
                                [DraftData_OpenNowArray addObject:@""];
                                [DraftData_PeriodsArray addObject:@""];
                            }else{
                                NSString *open_now = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData objectForKey:@"open_now"]];
                                [DraftData_OpenNowArray addObject:open_now];
                                NSString *periods = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData objectForKey:@"periods"]];
                                [DraftData_PeriodsArray addObject:periods];
                            }

                            
                        }

                        


                    }
                    NSLog(@"DraftData_LatArray is %@",DraftData_LatArray);
                    NSLog(@"DraftData_LngArray is %@",DraftData_LngArray);
                    NSLog(@"DraftData_LocationReferenceArray is %@",DraftData_LocationReferenceArray);
                    NSLog(@"DraftData_LocationLinkArray is %@",DraftData_LocationLinkArray);
                    NSLog(@"DraftData_LocationContactArray is %@",DraftData_LocationContactArray);
                    NSLog(@"DraftData_LocationTypeArray is %@",DraftData_LocationTypeArray);
                    NSLog(@"DraftData_LocationRouteArray is %@",DraftData_LocationRouteArray);
                    NSLog(@"DraftData_LocationLocalityArray is %@",DraftData_LocationLocalityArray);
                    NSLog(@"DraftData_LocationAdministrative_Area_Level_1Array is %@",DraftData_LocationAdministrative_Area_Level_1Array);
                    NSLog(@"DraftData_LocationPostalCodeArray is %@",DraftData_LocationPostalCodeArray);
                    NSLog(@"DraftData_LocationCountryArray is %@",DraftData_LocationCountryArray);
                    
                    NSLog(@"DraftData_OpenNowArray is %@",DraftData_OpenNowArray);
                    NSLog(@"DraftData_PeriodsArray is %@",DraftData_PeriodsArray);
                    
                    NSLog(@"DraftData_ExpenseArray is %@",DraftData_ExpenseArray);
                    NSLog(@"DraftData_ExpenseCodeArray is %@",DraftData_ExpenseCodeArray);
                    
                    NSLog(@"DraftData_LocationPlaceIDArray is %@",DraftData_LocationPlaceIDArray);
                   
                    
                    DraftData_PlaceNameArray = [[NSMutableArray alloc]init];
                    DraftData_UpdateTimeArray = [[NSMutableArray alloc]init];
                    DraftData_IDArray = [[NSMutableArray alloc]init];
                    DraftData_PlaceFormattedAddress = [[NSMutableArray alloc]init];
                    DraftsData_PhotoCountArray = [[NSMutableArray alloc]init];
                    DraftData_BlogLinkArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in GetAllData_1) {
                        NSString *place_name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                        [DraftData_PlaceNameArray addObject:place_name];
                        NSString *post_id = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [DraftData_IDArray addObject:post_id];
                        NSString *place_formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_formatted_address"]];
                        [DraftData_PlaceFormattedAddress addObject:place_formatted_address];
                        NSString *photos_count = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"photos_count"]];
                        [DraftsData_PhotoCountArray addObject:photos_count];
                        NSString *link = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"link"]];
                        [DraftData_BlogLinkArray addObject:link];
                        
                        NSString *updated_at = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"updated_at"]];
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *date = [dateFormat dateFromString:updated_at];
                    //    NSLog(@"datedata is %@",date);
                        
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
                            [DraftData_UpdateTimeArray addObject:CheckString];
                        }else{
                            NSString *CheckString_ = [[NSString alloc]initWithFormat:@"%@d",CheckString];
                            [DraftData_UpdateTimeArray addObject:CheckString_];
                        }
                        
                        
                    }
                  //  NSLog(@"DraftData_PlaceNameArray is %@",DraftData_PlaceNameArray);
                  //  NSLog(@"DraftData_PlaceFormattedAddress is %@",DraftData_PlaceFormattedAddress);
                    NSArray *CategoryData = [GetAllData_1 valueForKey:@"category"];
                    //  NSLog(@"CategoryData is %@",CategoryData);
                    DraftData_CategoryArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [CategoryData count]; i++) {
                        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[CategoryData objectAtIndex:i]];
                        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()\n "];
                        TempString = [[TempString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                      //  NSLog(@"TempString is %@",TempString);
                        if ([TempString length] == 0 || TempString == nil || [TempString isEqualToString:@"(null)"]) {
                            [DraftData_CategoryArray addObject:@""];
                        }else{
                            [DraftData_CategoryArray addObject:TempString];
                        }
                    }

                    
                 //   NSLog(@"DraftData_CategoryArray is %@",DraftData_CategoryArray);
                    
                    NSArray *PhotoData = [GetAllData_1 valueForKey:@"photos"];
                    DraftsData_PhotoArray = [[NSMutableArray alloc]init];
                    DraftData_PhotoCaptionArray = [[NSMutableArray alloc]init];
                    DraftData_PhotoIDArray = [[NSMutableArray alloc]init];
                    for (NSDictionary * dict in PhotoData) {
                        NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                        NSMutableArray *CaptionArray = [[NSMutableArray alloc]init];
                        NSMutableArray *PhotoIDArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict_ in dict) {
                            NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                            //  [UserInfo_NameArray addObject:username];
                      //      NSLog(@"captionata is %@",caption);
                            [CaptionArray addObject:caption];
                            
                            NSString *photo_id = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"photo_id"]];
                            [PhotoIDArray addObject:photo_id];
                            
                            NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                            
                            NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                            [UrlArray addObject:url];
                        }
                        NSString *result = [CaptionArray componentsJoinedByString:@","];
                        [DraftData_PhotoCaptionArray addObject:result];
                        NSString *result2 = [UrlArray componentsJoinedByString:@","];
                        [DraftsData_PhotoArray addObject:result2];
                        NSString *result3 = [PhotoIDArray componentsJoinedByString:@","];
                        [DraftData_PhotoIDArray addObject:result3 ];
                    }
             //       NSLog(@"DraftsData_PhotoArray is %@",DraftsData_PhotoArray);
                    [self InitView];
                    [ShowActivityDraft stopAnimating];
                }
                
            }

        }
               

    }else if(connection == theConnection_DeleteDraftData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"delete post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    //    NSLog(@"Expert Json = %@",res);
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
     //   NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            segmentActionCheck = 0;
            [self GetDraftsData];
        }
    }else if(connection == theConnection_CheckLikeCountData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //    NSLog(@"v ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&myError];
        if (myError) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"An unknown error occurred. Please try again in a while." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            //     NSLog(@"ErrorString is %@",ErrorString);
          //  NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            //      NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"posts"];
                // NSLog(@"GetAllData ===== %@",GetAllData);
                NSString *GetLikesDataCounttemp = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_posts"]];
                
                if ([GetLikesDataCount isEqualToString:GetLikesDataCounttemp]) {
                    
                }else{
                    GetLikesDataCount = GetLikesDataCounttemp;
                    CheckFirstTimeLoadLikes = 1;
                    TotalPage = 1;
                    CurrentPage = 0;
                    NSString *TempStringLikes = [[NSString alloc]initWithFormat:@"%@ %@",GetLikesDataCount,CustomLocalisedString(@"MainTab_Like", nil)];
                    [PostControl setTitle:TempStringLikes forSegmentAtIndex:1];
                    

                    NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
                    NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                    CurrentPage = [page intValue];
                    TotalPage = [total_page intValue];
                    [LikesData_IDArray removeAllObjects];
                    [LikesData_PhotoArray removeAllObjects];
                    LikesData_IDArray = [[NSMutableArray alloc]init];
                    LikesData_PhotoArray = [[NSMutableArray alloc]init];
                    DataCount = 0;
                    for (NSDictionary * dict in GetAllData) {
                        NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                        [LikesData_IDArray addObject:PlaceID];
                    }
                    NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
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
                    DataCount = DataTotal;
                    DataTotal = [LikesData_IDArray count];
                    CheckLoad_Likes = NO;
                    
                    segmentActionCheck = 1;
                    PostControl.selectedSegmentIndex = segmentActionCheck;
                    [self InitLikeData];
                    
                    
                    
                }
                
                
                
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
    CheckGoWhere = @"EditProfilePhoto";
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
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:@"me" GetType:@"Follower"];
}
-(IBAction)ShowAll_FollowingButton:(id)sender{
    CheckGoWhere = @"EditProfilePhoto";
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
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:@"me" GetType:@"Following"];
}
-(IBAction)SettingsButton:(id)sender{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"EditProfilePhoto", nil),CustomLocalisedString(@"EditCoverBackground", nil),CustomLocalisedString(@"SettingsPage_Title", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"EditProfilePhoto", nil)]) {
            NSLog(@"Change profile photo");
            CheckGoWhere = @"EditProfilePhoto";//EditProfilePhoto EditCoverPhoto EditSettings
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SubmitProfileViewController *SubmitProfileView = [[SubmitProfileViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SubmitProfileView animated:NO completion:nil];
            [SubmitProfileView GetType:@"Profile Photo"];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"EditCoverBackground", nil)]) {
            NSLog(@"Change cover photo");
            CheckGoWhere = @"EditCoverPhoto";
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SubmitProfileViewController *SubmitProfileView = [[SubmitProfileViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SubmitProfileView animated:NO completion:nil];
            [SubmitProfileView GetType:@"Cover Photo"];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Title", nil)]) {
            NSLog(@"Settings");
            CheckGoWhere = @"EditSettings";
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SettingsView animated:NO completion:nil];
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }else if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"ShareToFacebook", nil)]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/%@",Getusername];
            NSLog(@"message is %@",message);
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
            NSString *message = [NSString stringWithFormat:@"Check out my profile on Seeties!\n\nhttps://seeties.me/%@",Getusername];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSLog(@"message is %@",message);
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }
    
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
-(IBAction)ClickFullImageButton:(id)sender{
    NSLog(@"Click Full Image Button Click");
    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",Getprofile_photo];
    if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
    }else{
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
    

    
}
-(IBAction)EditButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);

    
    NSString *CheckPhoto = [[NSString alloc]initWithFormat:@"%@",[DraftsData_PhotoArray objectAtIndex:getbuttonIDN]];
    NSString *CheckLocation = [[NSString alloc]initWithFormat:@"%@",[DraftData_LatArray objectAtIndex:getbuttonIDN]];
    if ([CheckPhoto isEqualToString:@""] || [CheckLocation isEqualToString:@""]) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"" message:@"Please edit in website." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        
        NSString *TempAddress = [[NSString alloc]initWithFormat:@"%@",[DraftData_PlaceFormattedAddress objectAtIndex:getbuttonIDN]];
        NSString *TempPlaceName = [[NSString alloc]initWithFormat:@"%@",[DraftData_PlaceNameArray objectAtIndex:getbuttonIDN]];
        //NSString *TempGetPhotoCaption = [[NSString alloc]initWithFormat:@"%@",[DraftData_PhotoCaptionArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetlat = [[NSString alloc]initWithFormat:@"%@",[DraftData_LatArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetlng = [[NSString alloc]initWithFormat:@"%@",[DraftData_LngArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetLink = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationLinkArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetContact = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationContactArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetBlogLink = [[NSString alloc]initWithFormat:@"%@",[DraftData_BlogLinkArray objectAtIndex:getbuttonIDN]];
        NSString *TempPhotoCount = [[NSString alloc]initWithFormat:@"%@",[DraftsData_PhotoCountArray objectAtIndex:getbuttonIDN]];
        
        NSString *TempGetPrice = [[NSString alloc]initWithFormat:@"%@",[DraftData_ExpenseArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetPriceCode = [[NSString alloc]initWithFormat:@"%@",[DraftData_ExpenseCodeArray objectAtIndex:getbuttonIDN]];
        NSString *GetCodeShow;
        if ([TempGetPriceCode isEqualToString:@"840"]) {
            GetCodeShow = @"USD";
        }else if ([TempGetPriceCode isEqualToString:@"458"]){
            GetCodeShow = @"MYR";
        }else if ([TempGetPriceCode isEqualToString:@"702"]){
            GetCodeShow = @"SGD";
        }else if ([TempGetPriceCode isEqualToString:@"764"]){
            GetCodeShow = @"THB";
        }else if ([TempGetPriceCode isEqualToString:@"360"]){
            GetCodeShow = @"IDR";
        }else if ([TempGetPriceCode isEqualToString:@"901"]){
            GetCodeShow = @"TWD";
        }else if ([TempGetPriceCode isEqualToString:@"608"]){
            GetCodeShow = @"PHP";
        }else{
            GetCodeShow = @"";
        }
      //  NSLog(@"TempGetPhotoCaption is %@",TempGetPhotoCaption);
        
        NSString *TempLocation_Address = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationRouteArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_City = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationLocalityArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_Country = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationCountryArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_State = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationAdministrative_Area_Level_1Array objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_PostalCode = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationPostalCodeArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_ReferralId = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationReferenceArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_Type = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationTypeArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_PlaceID = [[NSString alloc]initWithFormat:@"%@",[DraftData_LocationPlaceIDArray objectAtIndex:getbuttonIDN]];
        
        NSString *TempLocation_Period = [[NSString alloc]initWithFormat:@"%@",[DraftData_PeriodsArray objectAtIndex:getbuttonIDN]];
        NSString *TempLocation_OpenNow = [[NSString alloc]initWithFormat:@"%@",[DraftData_OpenNowArray objectAtIndex:getbuttonIDN]];
        
        NSString *TempGetTitle = [[NSString alloc]initWithFormat:@"%@",[DraftData_TitleArray objectAtIndex:getbuttonIDN]];
        NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[DraftData_MessageArray objectAtIndex:getbuttonIDN]];
        
        NSString *GetCategoryID = [[NSString alloc]initWithFormat:@"%@",[DraftData_CategoryArray objectAtIndex:getbuttonIDN]];
      //  NSLog(@"GetCategoryID is %@",GetCategoryID);
        
    //    NSLog(@"TempGetTitle is %@",TempGetTitle);
    //    NSLog(@"TempGetMessage is %@",TempGetMessage);
        
        NSMutableArray *FullPhotoStringArray = [[NSMutableArray alloc]init];
        NSArray *SplitArray = [[DraftsData_PhotoArray objectAtIndex:getbuttonIDN] componentsSeparatedByString:@","];
   //     NSLog(@"SplitArray is %@",SplitArray);
        NSMutableArray *FulPhotoCaptionArray = [[NSMutableArray alloc]init];
        NSArray *SplitArray_PhotoCaption = [[DraftData_PhotoCaptionArray objectAtIndex:getbuttonIDN] componentsSeparatedByString:@","];
    //    NSLog(@"SplitArray_PhotoCaption is %@",SplitArray_PhotoCaption);
        for (int i = 0; i < [SplitArray count]; i++) {
            UIImage *DownloadImage = [[UIImage alloc]init];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[SplitArray objectAtIndex:i]]];
            DownloadImage = [UIImage imageWithData:data];
            NSData *imageData = UIImageJPEGRepresentation(DownloadImage, 1);
            NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
            [imageData writeToFile:imagePath atomically:YES];
            [FullPhotoStringArray addObject:imagePath];
            
            
//            NSString *base64 = [self encodeToBase64String:DownloadImage];;
//            [FullPhotoStringArray addObject:base64];
            
            NSString *TempGetCaption = [[NSString alloc]initWithFormat:@"%@",[SplitArray_PhotoCaption objectAtIndex:i]];
            [FulPhotoCaptionArray addObject:TempGetCaption];
        }
        
        NSString *TempGetPhotoID = [[NSString alloc]initWithFormat:@"%@",[DraftData_PhotoIDArray objectAtIndex:getbuttonIDN]];
        NSLog(@"TempGetPhotoID is %@",TempGetPhotoID);
     //   NSLog(@"FulPhotoCaptionArray is %@",FulPhotoCaptionArray);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:TempAddress forKey:@"PublishV2_Address"];
        [defaults setObject:TempPlaceName forKey:@"PublishV2_Name"];
        [defaults setObject:FullPhotoStringArray forKey:@"selectedIndexArr_Thumbs"];
        [defaults setObject:FulPhotoCaptionArray forKey:@"PublishV2_CaptionArray"];
        [defaults setObject:TempGetlat forKey:@"PublishV2_Lat"];
        [defaults setObject:TempGetlng forKey:@"PublishV2_Lng"];
        [defaults setObject:TempGetLink forKey:@"PublishV2_Link"];
        [defaults setObject:TempGetContact forKey:@"PublishV2_Contact"];
        [defaults setObject:TempGetBlogLink forKey:@"PublishV2_BlogLink"];
        [defaults setObject:TempGetPrice forKey:@"PublishV2_Price"];
        [defaults setObject:GetCodeShow forKey:@"PublishV2_Price_Show"];
        [defaults setObject:TempGetPriceCode forKey:@"PublishV2_Price_NumCode"];
        
        [defaults setObject:TempLocation_Address forKey:@"PublishV2_Location_Address"];
        [defaults setObject:TempLocation_City forKey:@"PublishV2_Location_City"];
        [defaults setObject:TempLocation_Country forKey:@"PublishV2_Location_Country"];
        [defaults setObject:TempLocation_State forKey:@"PublishV2_Location_State"];
        [defaults setObject:TempLocation_PostalCode forKey:@"PublishV2_Location_PostalCode"];
        [defaults setObject:TempLocation_ReferralId forKey:@"PublishV2_Location_ReferralId"];
        [defaults setObject:TempLocation_Type forKey:@"PublishV2_type"];
        [defaults setObject:TempLocation_PlaceID forKey:@"PublishV2_Location_PlaceId"];
        
        [defaults setObject:TempLocation_Period forKey:@"PublishV2_Period"];
        [defaults setObject:TempLocation_OpenNow forKey:@"PublishV2_OpenNow"];
        
        [defaults setObject:TempPhotoCount forKey:@"PublishV2_PhotoCount"];
        [defaults setObject:TempGetPhotoID forKey:@"PublishV2_PhotoID"];
        
        [defaults setObject:TempGetTitle forKey:@"PublishV2_Title"];
        [defaults setObject:TempGetMessage forKey:@"PublishV2_Message"];
        
        [defaults setObject:GetCategoryID forKey:@"PublishV2_Category"];
        [defaults synchronize];
        
       // RecommendV2ViewController *ShowImageView = [[RecommendV2ViewController alloc]init];
      //  [self presentViewController:ShowImageView animated:YES completion:nil];
        //[ShowImageView GetIsupdatePost:@"YES" GetPostID:[DraftData_IDArray objectAtIndex:getbuttonIDN]];
    }

    

    

}
- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
-(IBAction)DeleteButton:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    GetDeletePostID = [[NSString alloc]initWithFormat:@"%@",[DraftData_IDArray objectAtIndex:getbuttonIDN]];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"DeletePost", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Delete1", nil), nil];
    alert.tag = 500;
    [alert show];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            NSLog(@"Cancel");
        }else{
            //send delete data.
            [self DeleteData];
        }
    }
    
}
-(void)DeleteData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@?token=%@",DataUrl.UserWallpaper_Url,GetDeletePostID,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
    
    theConnection_DeleteDraftData = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_DeleteDraftData) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
-(IBAction)ImageButtonOnClick1:(id)sender{
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
//    [FeedDetailView GetPostID:[PostsData_IDArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[PostsData_IDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ImageButtonOnClick2:(id)sender{
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
//    [FeedDetailView GetPostID:[LikesData_IDArray objectAtIndex:getbuttonIDN]];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
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
            }else{
             NSLog(@"draft View scroll end");
            }
            
//            if (CheckLoad == YES) {
//                
//            }else{
//                [self GetMoreYourLike];
 //               CheckLoad = YES;
 //           }
            
        }
    }

}

@end

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
#import "NewUserProfileV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Filter2ViewController.h"
#import "NSAttributedString+DVSTracking.h"
#import "OpenWebViewController.h"
#import "AddCollectionDataViewController.h"
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
   
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 50);
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

    lblTitle.text =  self.model.name;
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
   // NSLog(@"lblTitle is %@",lblTitle);
   // [self GetDataFromServer];
   // [self InitView];
    [self GetFeaturedUserData];
    

}
-(void)GetFestivalUrl:(NSString *)UrlStirng GetFestivalImage:(NSString *)ImageString{

    GetFestivalsUrl = UrlStirng;
    GetFestivalsImage = ImageString;
    
    NSLog(@"GetFestivalsUrl is %@",GetFestivalsUrl);
    NSLog(@"GetFestivalsImage is %@",GetFestivalsImage);
}
-(void)InitView{

    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    GetHeight = 0;
    
    if ([GetFestivalsUrl isEqualToString:@""] || [GetFestivalsUrl length] == 0) {
        
    }else{
        AsyncImageView *FestivalImage = [[AsyncImageView alloc]init];
        FestivalImage.frame = CGRectMake(0, GetHeight -20, screenWidth, 180);
        FestivalImage.contentMode = UIViewContentModeScaleAspectFill;
        FestivalImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:FestivalImage];
        NSURL *url_UserImage = [NSURL URLWithString:GetFestivalsImage];
        FestivalImage.imageURL = url_UserImage;
        [MainScroll addSubview:FestivalImage];
        
        UILabel *ShowBigText = [[UILabel alloc]init];
        ShowBigText.frame = CGRectMake(15, GetHeight + 10, screenWidth - 30, 72);
        ShowBigText.text = CustomLocalisedString(@"Festival", nil);
        ShowBigText.textAlignment = NSTextAlignmentCenter;
        ShowBigText.textColor = [UIColor whiteColor];
        ShowBigText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:36];
        [MainScroll addSubview:ShowBigText];
        
        UILabel *ShowSubText = [[UILabel alloc]init];
        ShowSubText.frame = CGRectMake(15, GetHeight + 65, screenWidth - 30, 40);
        ShowSubText.text = CustomLocalisedString(@"DiscovertheColors", nil);
        ShowSubText.textAlignment = NSTextAlignmentCenter;
        ShowSubText.textColor = [UIColor whiteColor];
        ShowSubText.font = [UIFont fontWithName:@"AdrianeText-BoldItalic" size:18];
        [MainScroll addSubview:ShowSubText];
        
        UIButton *FestivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [FestivalButton setImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
        [FestivalButton setBackgroundImage:[UIImage imageNamed:@"BtnLetsgo.png"] forState:UIControlStateNormal];
        [FestivalButton setTitle:CustomLocalisedString(@"Letsgo", nil) forState:UIControlStateNormal];
        [FestivalButton setFrame:CGRectMake((screenWidth/2) - 70, GetHeight + 110, 140, 47)];
        [FestivalButton setBackgroundColor:[UIColor clearColor]];
        [FestivalButton addTarget:self action:@selector(LetsgoButton:) forControlEvents:UIControlEventTouchUpInside];
        [FestivalButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [MainScroll addSubview:FestivalButton];
        
        GetHeight += 200;
    }
    

    
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"Trending Posts"];
    NSString *TempStringPeople = [[NSString alloc]initWithFormat:@"Discover People"];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringPeople, nil];
    UISegmentedControl *ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 29);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [MainScroll addSubview:ProfileControl];
    
    GetHeight += 29 + 20;
    
    PostView = [[UIView alloc]init];
    PostView.frame = CGRectMake(0, GetHeight, screenWidth, 400);
    PostView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:PostView];
    
    PeopleView = [[UIView alloc]init];
    PeopleView.frame = CGRectMake(0, GetHeight, screenWidth, 600);
    PeopleView.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    [MainScroll addSubview:PeopleView];
    
    PeopleView.hidden = YES;
    PostView.hidden = NO;
    
    [self InitPostDataView];
    

//    int TestWidth = screenWidth - 2;
//    NSLog(@"TestWidth is %i",TestWidth);
//    int FinalWidth = TestWidth / 3;
//    FinalWidth += 1;
//    NSLog(@"FinalWidth is %i",FinalWidth);
//    int SpaceWidth = FinalWidth + 1;
//
//    for (NSInteger i = DataCount; i < DataTotal; i++) {
//        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray objectAtIndex:i]];
//        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
//        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
//        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
//        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
//        ShowImage.layer.masksToBounds = YES;
//        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
//        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
//        if ([FullImagesURL_First length] == 0) {
//            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
//        }else{
//            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
//            //NSLog(@"url is %@",url);
//            ShowImage.imageURL = url_NearbySmall;
//        }
//        [MainScroll addSubview:ShowImage];
//
//        
//        UIButton *ImageButton = [[UIButton alloc]init];
//        [ImageButton setBackgroundColor:[UIColor clearColor]];
//        [ImageButton setTitle:@"" forState:UIControlStateNormal];
//        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, GetHeight + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
//        ImageButton.tag = i;
//        [ImageButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//        [MainScroll addSubview:ImageButton];
//        [MainScroll setContentSize:CGSizeMake(320, GetHeight + FinalWidth + (SpaceWidth * (CGFloat)(i /3)))];
//    }
    
    CheckLoadDone = YES;

    [ShowActivity stopAnimating];
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"PostView click");
            PostView.hidden = NO;
            PeopleView.hidden = YES;
           [self InitPostDataView];
            
            break;
        case 1:
            NSLog(@"PeopleView click");
            PostView.hidden = YES;
            PeopleView.hidden = NO;
            
            [self initPeopleDataView];
            
            break;
        default:
            break;
    }
    
    //[self InitView];
}

-(void)InitPostDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PostGetHeight = 0;
    
    
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(15, PostGetHeight, screenWidth - 30, 150);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [PostView addSubview: TempButton];
        
        AsyncImageView *UserImage = [[AsyncImageView alloc]init];
        UserImage.frame = CGRectMake(25, PostGetHeight + 10, 30, 30);
        UserImage.contentMode = UIViewContentModeScaleAspectFill;
        UserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        UserImage.layer.cornerRadius=15;
        UserImage.layer.borderWidth=0;
        UserImage.layer.masksToBounds = YES;
        UserImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[UserInfo_UrlArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0) {
            UserImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            UserImage.imageURL = url_UserImage;
        }
        [PostView addSubview:UserImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(70, PostGetHeight + 10, screenWidth - 70, 30);
        ShowUserName.text = [UserInfo_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor blackColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostView addSubview:ShowUserName];
        
        

        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15, PostGetHeight + 50, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [PostView addSubview:Line01];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(25, PostGetHeight + 60, 80, 80);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
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
        [PostView addSubview:ShowImage];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(120, PostGetHeight + 82, 8, 11);
        [PostView addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(140, PostGetHeight + 80, screenWidth - 140 - 60, 20);
        ShowPlaceName.text = [place_nameArray objectAtIndex:i];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [PostView addSubview:ShowPlaceName];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(120, PostGetHeight + 100, screenWidth - 120 - 45, 20);
        ShowLocation.text = [LocationArray objectAtIndex:i];
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLocation.textColor = [UIColor grayColor];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [PostView addSubview:ShowLocation];
        
        UIButton *ButtonOnClick = [[UIButton alloc]init];
        [ButtonOnClick setBackgroundColor:[UIColor clearColor]];
        [ButtonOnClick setTitle:@"" forState:UIControlStateNormal];
        ButtonOnClick.frame = CGRectMake(15, PostGetHeight, screenWidth - 30, 150);
        ButtonOnClick.tag = i;
        [ButtonOnClick addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [PostView addSubview:ButtonOnClick];
        
        GetPostsFollow = [[NSString alloc]initWithFormat:@"%@",[UserInfo_FollowArray objectAtIndex:i]];
        UIButton *UserFollowButton = [[UIButton alloc]init];
        if ([GetPostsFollow isEqualToString:@"0"]) {
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
        }else{
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
            [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
        }
        [UserFollowButton setBackgroundColor:[UIColor clearColor]];
        // [UserFollowButton setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
        UserFollowButton.frame = CGRectMake(screenWidth - 15 - 47 - 10, PostGetHeight - 1, 47, 47);
        UserFollowButton.tag = i;
        [UserFollowButton addTarget:self action:@selector(PostsUserOnCLick:) forControlEvents:UIControlEventTouchUpInside];
        [PostView addSubview:UserFollowButton];
        
        
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
        CollectButton.frame = CGRectMake(screenWidth - 15 - 57 - 10, PostGetHeight + 67, 57, 57);
        CollectButton.tag = i;
        [CollectButton addTarget:self action:@selector(CollectButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [PostView addSubview:CollectButton];
        
        
        PostGetHeight += 160;
        
    }
    PostView.frame = CGRectMake(0, GetHeight, screenWidth, PostGetHeight);
    
   // [MainScroll setContentSize:CGSizeMake(320, PostView.frame.size.height)];
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + PostView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
}
-(void)initPeopleDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int PeopleGetHeight = 0;
    
    int TestWidth = screenWidth - 70;
    //    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 4;
    //    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 4;
    
    for (int i = 0; i < [User_NameArray count]; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(15, PeopleGetHeight, screenWidth - 30, FinalWidth + 10 + 70);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
       // TempButton.layer.borderWidth=1;
        TempButton.layer.masksToBounds = YES;
       // TempButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        [PeopleView addSubview: TempButton];
        
        
        AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
        ShowUserProfileImage.frame = CGRectMake(30, PeopleGetHeight + 10, 40, 40);
        ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=20;
        ShowUserProfileImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",[User_ProfileImageArray objectAtIndex:i]];
        if ([FullImagesURL1 length] == 0) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            ShowUserProfileImage.imageURL = url_UserImage;
        }
        [PeopleView addSubview:ShowUserProfileImage];
        
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(80, PeopleGetHeight + 10, 200, 20);
        ShowUserName.text = [User_NameArray objectAtIndex:i];
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PeopleView addSubview:ShowUserName];
        
        UILabel *ShowMessage = [[UILabel alloc]init];
        ShowMessage.frame = CGRectMake(80, PeopleGetHeight + 30, 200, 20);
        ShowMessage.text = [User_LocationArray objectAtIndex:i];
        ShowMessage.backgroundColor = [UIColor clearColor];
        ShowMessage.textColor = [UIColor grayColor];
        ShowMessage.textAlignment = NSTextAlignmentLeft;
        ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        [PeopleView addSubview:ShowMessage];
        
        NSString *CheckFollow = [[NSString alloc]initWithFormat:@"%@",[User_FollowArray objectAtIndex:i]];
        
        UIButton *FollowButton = [[UIButton alloc]init];
        FollowButton.frame = CGRectMake(screenWidth - 30 - 70, PeopleGetHeight + 12, 70, 48);
       // [FollowButton setTitle:@"Icon" forState:UIControlStateNormal];
        if ([CheckFollow isEqualToString:@"0"]) {
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateNormal];
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateSelected];
        }else{
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollowing.png"] forState:UIControlStateNormal];
            [FollowButton setImage:[UIImage imageNamed:@"ExploreFollow.png"] forState:UIControlStateSelected];
        }
        [FollowButton setImage:[UIImage imageNamed:@"follow_icon.png"] forState:UIControlStateNormal];
        FollowButton.backgroundColor = [UIColor clearColor];
        FollowButton.tag = i;
       // FollowButton.layer.cornerRadius = 20;
        [FollowButton addTarget:self action:@selector(FollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [PeopleView addSubview: FollowButton];
        
//        NSMutableArray *DemoArray = [[NSMutableArray alloc]init];
//        [DemoArray addObject:@"DemoBackground.jpg"];
//        [DemoArray addObject:@"UserDemo1.jpg"];
//        [DemoArray addObject:@"UserDemo2.jpg"];
//        [DemoArray addObject:@"UserDemo3.jpg"];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[User_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        for (int z = 0; z < [SplitArray count]; z++) {
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.frame = CGRectMake(30 +(z % 4) * SpaceWidth, PeopleGetHeight + 70, FinalWidth, FinalWidth);
           // ShowImage.image = [UIImage imageNamed:[SplitArray objectAtIndex:z]];
            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowImage.layer.cornerRadius=5;
            ShowImage.layer.masksToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:z]];
            if ([FullImagesURL_First length] == 0) {
                ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url = [NSURL URLWithString:FullImagesURL_First];
                ShowImage.imageURL = url;
            }
            [PeopleView addSubview:ShowImage];
        }
        
        PeopleGetHeight += FinalWidth + 10 + 70 + 10;
        
    }
    PeopleView.frame = CGRectMake(0, GetHeight, screenWidth, PeopleGetHeight);
    
    // [MainScroll setContentSize:CGSizeMake(320, PostView.frame.size.height)];
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + PeopleView.frame.size.height;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;

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
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
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
-(IBAction)PostsUserOnCLick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    GetUserID = [UserInfo_IDArray objectAtIndex:getbuttonIDN];
    GetFollowString = [UserInfo_FollowArray objectAtIndex:getbuttonIDN];
    
    if ([GetFollowString isEqualToString:@"0"]) {
        [UserInfo_FollowArray replaceObjectAtIndex:getbuttonIDN withObject:@"1"];
        [self SendFollowingData];
    }else{
        NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",CustomLocalisedString(@"StopFollowing", nil),[UserInfo_NameArray objectAtIndex:getbuttonIDN]];
        
        UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"" message:tempStirng delegate:self cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil) otherButtonTitles:CustomLocalisedString(@"Unfollow", nil), nil];
        ShowAlertView.tag = 1200;
        [ShowAlertView show];
        [UserInfo_FollowArray replaceObjectAtIndex:getbuttonIDN withObject:@"0"];
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
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            NSLog(@"ErrorString is %@",ErrorString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSDictionary *ResData = [res valueForKey:@"data"];
                
                NSDictionary *GetAllData = [ResData valueForKey:@"posts"];
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
              //  NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
         //       NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"page"]];
                NSLog(@"Temppage is %@",Temppage);
                NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"total_page"]];
                NSLog(@"Temptotal_page is %@",Temptotal_page);
                NSString *TempCount = [[NSString alloc]initWithFormat:@"%@",[ResData objectForKey:@"list_size"]];
                NSLog(@"TempCount is %@",TempCount);
                CurrentPage = [Temppage intValue];
                TotalPage = [Temptotal_page intValue];
                
                if (CheckFirstTimeLoad == 0) {
                    PostIDArray = [[NSMutableArray alloc]init];
                    PhotoArray = [[NSMutableArray alloc]init];
                    UserInfo_UrlArray = [[NSMutableArray alloc]init];
                    UserInfo_NameArray = [[NSMutableArray alloc]init];
                    place_nameArray = [[NSMutableArray alloc]init];
                    LocationArray = [[NSMutableArray alloc]init];
                    DataCount = 0;
                    UserInfo_FollowArray = [[NSMutableArray alloc]init];
                    CollectArray = [[NSMutableArray alloc]init];
                    UserInfo_IDArray = [[NSMutableArray alloc]init];
                }else{
                    
                }
                for (NSDictionary * dict in GetAllData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostIDArray addObject:PlaceID];
                    NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [place_nameArray addObject:place_name];
                    NSString *collect =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"collect"]];
                    [CollectArray addObject:collect];
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
                    [PhotoArray addObject:result2];
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
                for (NSDictionary * dict in locationData_Address) {
                    NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"locality"]];
                    NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"administrative_area_level_3"]];
                    NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"administrative_area_level_2"]];
                    NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"administrative_area_level_1"]];
                    NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"country"]];
                    
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
                DataTotal = [PostIDArray count];

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
                 NSDictionary *ResData = [res valueForKey:@"data"];
                
                 NSDictionary *GetAllData = [ResData valueForKey:@"users"];
          //      NSLog(@"GetAllData ===== %@",GetAllData);
                
               // NSArray *UserData = [GetAllData valueForKey:@"users"];
                User_LocationArray = [[NSMutableArray alloc]init];
                User_IDArray = [[NSMutableArray alloc]init];
                User_NameArray = [[NSMutableArray alloc]init];
                User_ProfileImageArray = [[NSMutableArray alloc]init];
                User_FollowArray = [[NSMutableArray alloc]init];
                User_UserNameArray = [[NSMutableArray alloc]init];
                User_PhotoArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetAllData) {
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
                    
                    NSDictionary *PostsData = [dict valueForKey:@"posts"];
                    NSArray *PhotoData = [PostsData valueForKey:@"photos"];

                    for (NSDictionary * dict in PhotoData) {
                        NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict_ in dict) {
                            NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                            NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                            [UrlArray addObject:url];
                        }
                        NSString *result2 = [UrlArray componentsJoinedByString:@","];
                        [User_PhotoArray addObject:result2];
                    }
                    
                    
                    
                }
               // NSLog(@"User_PhotoArray is %@",User_PhotoArray);
                [self GetDataFromServer];
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
-(IBAction)LetsgoButton:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    //[OpenWebView GetTitleString:@"Festival"];
    [OpenWebView GetTitleString:@"Festival" GetFestivalUrl:GetFestivalsUrl];
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
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PhotoArray objectAtIndex:getbuttonIDN]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        
        AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
        //[self presentViewController:AddCollectionDataView animated:YES completion:nil];
        [self.view.window.rootViewController presentViewController:AddCollectionDataView animated:YES completion:nil];
        [AddCollectionDataView GetPostID:[CollectArray objectAtIndex:getbuttonIDN] GetImageData:[SplitArray objectAtIndex:0]];
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
@end

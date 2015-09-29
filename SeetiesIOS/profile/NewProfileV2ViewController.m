//
//  NewProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "NewProfileV2ViewController.h"
#import "SettingsViewController.h"
#import "SearchViewV2Controller.h"
#import "FeedV2DetailViewController.h"
#import "CollectionViewController.h"
#import "EditProfileV2ViewController.h"
#import "ShowFollowerAndFollowingViewController.h"
#import "FullImageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LandingV2ViewController.h"
@interface NewProfileV2ViewController ()

@end

@implementation NewProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DataUrl = [[UrlDataClass alloc]init];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    SearchBarTemp.delegate = self;
    SearchBarTemp.tintColor = [UIColor redColor];
    SearchBarTemp.barTintColor = [UIColor clearColor];
    [SearchBarTemp setBackgroundImage:[[UIImage alloc]init]];
    
    GetHeight = 0;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = 800;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    MainScroll.alwaysBounceVertical = YES;
    
    //BackgroundImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
    BackgroundImage.frame = CGRectMake(0, -50, screenWidth, 300);
    CGRect headerFrame = BackgroundImage.frame;
    headerFrame.origin.y -= 50.0f;
    BackgroundImage.frame = headerFrame;
    [MainScroll addSubview:BackgroundImage withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    ShowOverlayImg.image = [UIImage imageNamed:@"FeedOverlay.png"];
    ShowOverlayImg.frame = CGRectMake(0, 0, screenWidth, 200);
    ShowOverlayImg.contentMode = UIViewContentModeScaleAspectFill;
    ShowOverlayImg.layer.masksToBounds = YES;
    
    SettingsButton.frame = CGRectMake(screenWidth - 30 - 35, 72, 19, 19);
    ShareButton.frame = CGRectMake(screenWidth - 30, 72, 17, 18);
    
    CheckExpand = YES;
    
    AllContentView.frame = CGRectMake(0, 100, screenWidth, 100);
//    CGRect contentFrame = AllContentView.frame;
//    contentFrame.origin.y += 100.0f;
//    AllContentView.frame = contentFrame;
    [MainScroll addSubview:AllContentView];
    
    CheckLoad_Post = NO;
    CheckLoad_Likes = NO;
    CheckLoad_Collection = NO;
    CheckFirstTimeLoadLikes = 0;
    CheckFirstTimeLoadPost = 0;
    CheckFirstTimeLoadCollection = 0;
    TotalPage_Like = 1;
    CurrentPage_Like = 0;
    TotalPage_Post = 1;
    CurrentPage_Post = 0;
    TotalPage_Collection = 1;
    CurrentPage_Collection = 0;
    
    [self GetUserData];
    
    
   // [self InitContentView];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // accelerate header just with half speed down, but with normal speed up
    if (scrollView.contentOffset.y > 0) {
        [MainScroll setAcceleration:A3DefaultAcceleration forView:BackgroundImage];
    }else{
        [MainScroll setAcceleration:CGPointMake(0.0f, 0.5f) forView:BackgroundImage];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckEdit = [defaults objectForKey:@"CheckEditUserInformation"];
    
    if ([CheckEdit isEqualToString:@"GotEdit"]) {
        NSString *GetWallpaper_ = [defaults objectForKey:@"UserData_Wallpaper"];
        NSString *GetProfileImg_ = [defaults objectForKey:@"UserData_ProfilePhoto"];
        GetUserName = [defaults objectForKey:@"UserData_Username"];
        GetName = [defaults objectForKey:@"UserData_Name"];
        GetLink = [defaults objectForKey:@"UserData_Url"];
        GetDescription = [defaults objectForKey:@"UserData_Abouts"];
        GetPersonalTags = [defaults objectForKey:@"UserData_PersonalTags"];
        GetLocation = [defaults objectForKey:@"UserData_Location"];
        if ([GetPersonalTags length] == 0 || [GetPersonalTags isEqualToString:@""] || [GetPersonalTags isEqualToString:@"(null)"] || GetPersonalTags == nil) {
        }else{
            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
            GetPersonalTags = [[GetPersonalTags componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
            NSArray *arr = [GetPersonalTags componentsSeparatedByString:@","];
            [ArrHashTag removeAllObjects];
            ArrHashTag = [[NSMutableArray alloc]initWithArray:arr];
        }
        
      //  [self InitCollectionView];
        
        NSURL *url_UserImage = [NSURL URLWithString:GetProfileImg_];
        ShowUserProfileImage.imageURL = url_UserImage;
        
        NSURL *url_WallpaperImage = [NSURL URLWithString:GetWallpaper_];
        BackgroundImage.imageURL = url_WallpaperImage;
        
        
        
        CheckEdit = @"NoEdit";
        [defaults setObject:CheckEdit forKey:@"CheckEditUserInformation"];
        [defaults synchronize];
    }

}


-(void)InitContentView{
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *WhiteBackground = [[UIButton alloc]init];
    WhiteBackground.frame = CGRectMake(0, 40, screenWidth, screenHeight);
    [WhiteBackground setTitle:@"" forState:UIControlStateNormal];
    WhiteBackground.backgroundColor = [UIColor whiteColor];
    [AllContentView addSubview:WhiteBackground];

    ShowUserProfileImage = [[AsyncImageView alloc]init];
    ShowUserProfileImage.frame = CGRectMake(20, 0, 100, 100);
    ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserProfileImage.layer.cornerRadius = 50;
    ShowUserProfileImage.layer.borderWidth = 5;
    ShowUserProfileImage.layer.masksToBounds = YES;
    ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
    if ([GetProfileImg length] == 0 || [GetProfileImg isEqualToString:@"null"] || [GetProfileImg isEqualToString:@"<null>"]) {
        ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:GetProfileImg];
        ShowUserProfileImage.imageURL = url_UserImage;
    }
    [AllContentView addSubview:ShowUserProfileImage];
    
    UIButton *ClicktoOpenUserProfileButton = [[UIButton alloc]init];
    ClicktoOpenUserProfileButton.frame = CGRectMake(20, 0, 100, 100);
    [ClicktoOpenUserProfileButton setTitle:@"" forState:UIControlStateNormal];
    ClicktoOpenUserProfileButton.backgroundColor = [UIColor clearColor];
    [ClicktoOpenUserProfileButton addTarget:self action:@selector(OpenUserProfileOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [AllContentView addSubview:ClicktoOpenUserProfileButton];
    
    NSString *TempUsernameString = [[NSString alloc]initWithFormat:@"@%@",GetUserName];
    
    ShowUserName = [[UILabel alloc]init];//getname
    ShowUserName.frame = CGRectMake(130, 10, screenWidth - 130, 30);
    ShowUserName.text = TempUsernameString;
    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
    ShowUserName.textColor = [UIColor whiteColor];
    ShowUserName.textAlignment = NSTextAlignmentLeft;
    ShowUserName.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowUserName];
    
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 106 - 20, 50, 106, 34);
    [EditProfileButton setTitle:@"Edit profile" forState:UIControlStateNormal];
    [EditProfileButton setImage:[UIImage imageNamed:@"edit_profile_btn.png"] forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor clearColor];
    [EditProfileButton addTarget:self action:@selector(EditProfileButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [AllContentView addSubview:EditProfileButton];
    
    ShowName_ = [[UILabel alloc]init];//getname
    ShowName_.frame = CGRectMake(30, 110, screenWidth - 60, 30);
    ShowName_.text = GetName;
    ShowName_.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:22];
    ShowName_.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0];
    ShowName_.textAlignment = NSTextAlignmentLeft;
    ShowName_.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowName_];
    
    GetHeight = 145;

    
    // followers and followings count show
    
    UIImageView *ShowPin = [[UIImageView alloc]init];
    ShowPin.image = [UIImage imageNamed:@"follower_icon.png"];
    ShowPin.frame = CGRectMake(33, GetHeight + 4, 14, 11);
    //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
    [AllContentView addSubview:ShowPin];
    
    if ([GetFollowingCount isEqualToString:@"(null)"]) {
        GetFollowingCount = @"0";
    }
    if ([GetFollowersCount isEqualToString:@"(null)"]) {
        GetFollowersCount = @"0";
    }
    
    NSString *tempFollowers = [[NSString alloc]initWithFormat:@"%@ Followers",GetFollowersCount];
    NSString *tempFollowing = [[NSString alloc]initWithFormat:@"%@ Followings",GetFollowingCount];
    
    UILabel *ShowFollowers = [[UILabel alloc]init];
    ShowFollowers.text = tempFollowers;
    ShowFollowers.frame = CGRectMake(60, GetHeight, 120, 21);
    ShowFollowers.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    ShowFollowers.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowFollowers.textAlignment = NSTextAlignmentLeft;
    ShowFollowers.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowFollowers];
    
    UIButton *OpenFollowersButton = [[UIButton alloc]init];
    OpenFollowersButton.frame = CGRectMake(60, GetHeight, 120, 21);
    [OpenFollowersButton setTitle:@"" forState:UIControlStateNormal];
    [OpenFollowersButton addTarget:self action:@selector(ShowAll_FollowerButton:) forControlEvents:UIControlEventTouchUpInside];
    [AllContentView addSubview:OpenFollowersButton];
    
    UILabel *ShowFollowing = [[UILabel alloc]init];
    ShowFollowing.text = tempFollowing;
    ShowFollowing.frame = CGRectMake(170, GetHeight, 120, 21);
    ShowFollowing.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    ShowFollowing.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    ShowFollowing.textAlignment = NSTextAlignmentLeft;
    ShowFollowing.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowFollowing];
    
    UIButton *OpenFollowingButton = [[UIButton alloc]init];
    OpenFollowingButton.frame = CGRectMake(170, GetHeight, 120, 21);
    [OpenFollowingButton setTitle:@"" forState:UIControlStateNormal];
    [OpenFollowingButton addTarget:self action:@selector(ShowAll_FollowingButton:) forControlEvents:UIControlEventTouchUpInside];
    [AllContentView addSubview:OpenFollowingButton];
    
    GetHeight += 30;
    
    
    if ([GetLocation isEqualToString:@""] || [GetLocation isEqualToString:@"(null)"] || [GetLocation length] == 0) {
        
    }else{
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"location_icon.png"];
        ShowPin.frame = CGRectMake(33, GetHeight + 4, 9, 12);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [AllContentView addSubview:ShowPin];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(60, GetHeight, screenWidth - 120, 20);
        ShowLocation.text = GetLocation;
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLocation.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [AllContentView addSubview:ShowLocation];
        
        GetHeight += 30;
    }
    
    if ([GetDescription isEqualToString:@""] || [GetDescription isEqualToString:@"(null)"] || [GetDescription length] == 0) {
        
    }else{
        ShowAboutText = [[UILabel alloc]init];
        ShowAboutText.frame = CGRectMake(30, GetHeight, screenWidth - 60, 30);
        ShowAboutText.text = GetDescription;
        ShowAboutText.numberOfLines = 0;
        ShowAboutText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowAboutText.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowAboutText.textAlignment = NSTextAlignmentLeft;
        [AllContentView addSubview:ShowAboutText];
        
        CGSize size = [ShowAboutText sizeThatFits:CGSizeMake(ShowAboutText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAboutText.frame;
        frame.size.height = size.height;
        ShowAboutText.frame = frame;
        
        GetHeight += ShowAboutText.frame.size.height + 10;
    }
    
    if ([GetLink isEqualToString:@""] || [GetLink isEqualToString:@"(null)"] || [GetLink length] == 0) {
        
    }else{
        ShowLink = [[UILabel alloc]init];
        ShowLink.frame = CGRectMake(30, GetHeight, screenWidth - 120, 20);
        ShowLink.text = GetLink;
        ShowLink.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLink.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowLink.textAlignment = NSTextAlignmentLeft;
        ShowLink.backgroundColor = [UIColor clearColor];
        [AllContentView addSubview:ShowLink];
        
        UIButton *OpenLinkButton = [[UIButton alloc]init];
        OpenLinkButton.frame = CGRectMake(30, GetHeight, screenWidth - 120, 20);
        [OpenLinkButton setTitle:@"" forState:UIControlStateNormal];
        [OpenLinkButton addTarget:self action:@selector(OpenUrlButton:) forControlEvents:UIControlEventTouchUpInside];
        [AllContentView addSubview:OpenLinkButton];
        
        GetHeight += 30;
    }
    
    NSLog(@"after about us height is ==== %d",GetHeight);

    BOOL CheckShowExpand = false;
    if (CheckExpand == YES) {
        if (GetHeight > 240) {
            CheckExpand = YES;
        }else{
            CheckExpand = NO;
            CheckShowExpand = YES;
        }
    }
    

    
    
    if (CheckExpand == YES) {
        
        GetHeight = 220;
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, GetHeight, screenWidth, 20);
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setBackgroundColor:[UIColor whiteColor]];
        Line01.alpha = 0.8f;
        [AllContentView addSubview:Line01];
        
        GetHeight += 20;
        
        UIButton *WhiteBack = [[UIButton alloc]init];
        WhiteBack.frame = CGRectMake(0, GetHeight, screenWidth, 1000);
        [WhiteBack setTitle:@"" forState:UIControlStateNormal];
        [WhiteBack setBackgroundColor:[UIColor whiteColor]];
        [AllContentView addSubview:WhiteBack];
        
        UIButton *ExpandButton = [[UIButton alloc]init];
        ExpandButton.frame = CGRectMake(0, GetHeight, screenWidth, 50);
        //[ExpandButton setTitle:@"Expand" forState:UIControlStateNormal];
        [ExpandButton setImage:[UIImage imageNamed:@"showmore_btn.png"] forState:UIControlStateNormal];
        ExpandButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [ExpandButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        ExpandButton.backgroundColor = [UIColor whiteColor];
        [ExpandButton addTarget:self action:@selector(ExpandButton:) forControlEvents:UIControlEventTouchUpInside];
        [AllContentView addSubview:ExpandButton];
        
        GetHeight += 50;
        
    }else{
    
        if ([GetPersonalTags isEqualToString:@""] || [GetPersonalTags isEqualToString:@"(null)"] || [GetPersonalTags length] == 0) {
            
        }else{
            
            UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
            HashTagScroll.delegate = self;
            HashTagScroll.frame = CGRectMake(0, GetHeight, screenWidth, 50);
            HashTagScroll.backgroundColor = [UIColor whiteColor];
            [AllContentView addSubview:HashTagScroll];
            CGRect frame2 = {0,0};
            for (int i= 0; i < [ArrHashTag count]; i++) {
                UILabel *ShowHashTagText = [[UILabel alloc]init];
                ShowHashTagText.text = [ArrHashTag objectAtIndex:i];
                ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowHashTagText.textAlignment = NSTextAlignmentCenter;
                ShowHashTagText.backgroundColor = [UIColor whiteColor];
                ShowHashTagText.layer.cornerRadius = 5;
                ShowHashTagText.layer.borderWidth = 1;
                ShowHashTagText.layer.borderColor=[[UIColor grayColor] CGColor];
                
                NSString *Text = [ArrHashTag objectAtIndex:i];
                CGRect r = [Text boundingRectWithSize:CGSizeMake(200, 0)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]}
                                              context:nil];
                
                //NSLog(@"r ==== %f",r.size.width);

                //CGSize textSize = [ShowHashTagText.text sizeWithAttributes:@{NSFontAttributeName:[ShowHashTagText font]}];
             //   CGFloat textSize = ShowHashTagText.intrinsicContentSize.width;
                ShowHashTagText.frame = CGRectMake(30 + frame2.size.width, 15, r.size.width + 20, 20);
                frame2.size.width += r.size.width + 30;
                [HashTagScroll addSubview:ShowHashTagText];

                HashTagScroll.contentSize = CGSizeMake(30 + frame2.size.width , 50);
            }
            
            
            GetHeight += 50;

//
//            CGSize size = [ShowHashTagText sizeThatFits:CGSizeMake(ShowHashTagText.frame.size.width, CGFLOAT_MAX)];
//            CGRect frame = ShowHashTagText.frame;
//            frame.size.height = size.height;
//            ShowHashTagText.frame = frame;
//            
//            GetHeight += ShowHashTagText.frame.size.height + 20;
        }
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        [AllContentView addSubview:Line01];
        
        GetHeight += 1;
        
        if (CheckShowExpand == YES) {
            
        }else{
            UIButton *CollapseButton = [[UIButton alloc]init];
            CollapseButton.frame = CGRectMake(0, GetHeight, screenWidth, 50);
            // [CollapseButton setTitle:@"Collapse" forState:UIControlStateNormal];
            [CollapseButton setImage:[UIImage imageNamed:@"showmore_btn.png"] forState:UIControlStateNormal];
            CollapseButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
            [CollapseButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
            CollapseButton.backgroundColor = [UIColor whiteColor];
            [CollapseButton addTarget:self action:@selector(CollapseButton:) forControlEvents:UIControlEventTouchUpInside];
            [AllContentView addSubview:CollapseButton];
            
            GetHeight += 50;
        }
        

        
      }
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 20);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [AllContentView addSubview:Line01];
    
    GetHeight += 31;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"Post"];
    NSString *TempStringCollection = [[NSString alloc]initWithFormat:@"Collection"];
    NSString *TempStringLike = [[NSString alloc]initWithFormat:@"Like"];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringCollection, TempStringPosts,TempStringLike, nil];
    ProfileControl = [[UISegmentedControl alloc]initWithItems:itemArray];
    ProfileControl.frame = CGRectMake(15, GetHeight, screenWidth - 30, 29);
    [ProfileControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    ProfileControl.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
    [AllContentView addSubview:ProfileControl];
    
    GetHeight += 40;
    
    UIButton *Line02 = [[UIButton alloc]init];
    Line02.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line02 setTitle:@"" forState:UIControlStateNormal];
    [Line02 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [AllContentView addSubview:Line02];
    
    GetHeight += 1;
    
    // start 3 view Post, Collection, Like
    PostView = [[UIView alloc]init];
    PostView.frame = CGRectMake(0, GetHeight - 1, screenWidth, 100);
    PostView.backgroundColor = [UIColor whiteColor];
    [AllContentView addSubview:PostView];
    
    CollectionView = [[UIView alloc]init];
    CollectionView.frame = CGRectMake(0, GetHeight, screenWidth, 100);
    CollectionView.backgroundColor = [UIColor whiteColor];
    [AllContentView addSubview:CollectionView];
    
    LikeView = [[UIView alloc]init];
    LikeView.frame = CGRectMake(0, GetHeight, screenWidth, 100);
    LikeView.backgroundColor = [UIColor whiteColor];
    [AllContentView addSubview:LikeView];
    
    AllContentView.frame = CGRectMake(0, 100 , screenWidth, GetHeight + 100);
    
    LikeView.hidden = YES;
    CollectionView.hidden = NO;
    PostView.hidden = YES;
    
//    CGSize contentSize = MainScroll.frame.size;
//    contentSize.height = GetHeight + PostView.frame.size.height + 200;
//    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    MainScroll.contentSize = contentSize;
    if (CheckFirstTimeLoadCollection == 1) {
         [self InitCollectionView];
    }
   
    
}
- (void)segmentAction:(UISegmentedControl *)segment
{
  //  CGSize contentSize = MainScroll.frame.size;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Collection click");
            PostView.hidden = YES;
            LikeView.hidden = YES;
            CollectionView.hidden = NO;
            [self InitCollectionView];

            break;
        case 1:
            NSLog(@"Posts click");
            LikeView.hidden = YES;
            CollectionView.hidden = YES;
            PostView.hidden = NO;
            [self InitPostsView];
            break;
        case 2:
            NSLog(@"Likes click");
            PostView.hidden = YES;
            CollectionView.hidden = YES;
            LikeView.hidden = NO;
            [self InitLikeData];
            break;
        default:
            break;
    }
    
    //[self InitView];
}
-(IBAction)CollapseButton:(id)sender{
    CheckExpand = YES;
    GetHeight = 0;
    for (UIView *subview in AllContentView.subviews) {
        [subview removeFromSuperview];
    }
    [self InitContentView];
    
}
-(IBAction)ExpandButton:(id)sender{
    CheckExpand = NO;
    GetHeight = 0;
    for (UIView *subview in AllContentView.subviews) {
        [subview removeFromSuperview];
    }
    [self InitContentView];
}

-(void)InitCollectionView{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([GetCollectionDataCount length] == 0) {
        GetCollectionDataCount = @"";
    }
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@ Collection",GetCollectionDataCount];

    UILabel *ShowCollectionCount = [[UILabel alloc]init];
    ShowCollectionCount.frame = CGRectMake(30, 20, 150, 20);
    ShowCollectionCount.text = TempString;
    ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowCollectionCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    [CollectionView addSubview:ShowCollectionCount];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(screenWidth - 30 - 25, 10, 1, 30);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [CollectionView addSubview:Line01];
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 30 - 20, 10, 30, 30);
    //[EditProfileButton setTitle:@"New collection" forState:UIControlStateNormal];
    [EditProfileButton setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor clearColor];
    [CollectionView addSubview:EditProfileButton];
    
    
    int TestWidth = screenWidth - 40;
    //    NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 4;
    //    NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 4;
    
    int heightcheck = 60;
    
    for (NSInteger i = DataCount_Collection; i < DataTotal_Collection; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, FinalWidth + 10 + 70);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [CollectionView addSubview: TempButton];
        
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[CollectionData_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        for (int z = 0; z < [SplitArray count]; z++) {
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.frame = CGRectMake(15 +(z % 4) * SpaceWidth, heightcheck + 5 +i, FinalWidth, FinalWidth);
           // ShowImage.image = [UIImage imageNamed:[DemoArray objectAtIndex:z]];
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
            [CollectionView addSubview:ShowImage];
        }
    
        UILabel *ShowExplore = [[UILabel alloc]init];
        ShowExplore.frame = CGRectMake(30, heightcheck + 5 + FinalWidth + 20 + i, screenWidth - 100, 20);
        ShowExplore.text = [CollectionData_TitleArray objectAtIndex:i];
        ShowExplore.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        ShowExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
        [CollectionView addSubview:ShowExplore];
        
        UILabel *ShowSubExplore = [[UILabel alloc]init];
        ShowSubExplore.frame = CGRectMake(30, heightcheck + 5 + FinalWidth + 40 + i, screenWidth - 100, 20);
        ShowSubExplore.text = [CollectionData_DescriptionArray objectAtIndex:i];
        ShowSubExplore.textColor = [UIColor lightGrayColor];
        ShowSubExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        [CollectionView addSubview:ShowSubExplore];
        
        UIButton *SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, FinalWidth + 10 + 70);
        [SelectButton setTitle:@"" forState:UIControlStateNormal];
        SelectButton.tag = i;
        [SelectButton setBackgroundColor:[UIColor clearColor]];
        [SelectButton addTarget:self action:@selector(OpenCollectionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [CollectionView addSubview:SelectButton];
        
        UIButton *EditButton = [[UIButton alloc]init];
        EditButton.frame = CGRectMake(screenWidth - 80 - 20, heightcheck + 5 + FinalWidth + 20 + i, 80, 40);
        [EditButton setTitle:@"Edit" forState:UIControlStateNormal];
        EditButton.layer.cornerRadius= 15;
        EditButton.layer.borderWidth = 1;
        EditButton.layer.masksToBounds = YES;
        EditButton.layer.borderColor=[[UIColor grayColor] CGColor];
        EditButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [EditButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        EditButton.backgroundColor = [UIColor whiteColor];
        EditButton.tag = i;
        [EditButton addTarget:self action:@selector(CollectionEditButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [CollectionView addSubview:EditButton];
        
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15, heightcheck + 5 + FinalWidth + 70 + i, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [CollectionView addSubview:Line01];
        
        heightcheck += FinalWidth + 10 + 70 + 10 + i ;
    }
    AllContentView.frame = CGRectMake(0, 100 , screenWidth, GetHeight + heightcheck + FinalWidth + 120);
    CollectionView.frame = CGRectMake(0, GetHeight, screenWidth, heightcheck + FinalWidth + 120);
    NSLog(@"GetHeight = %d",GetHeight);
    NSLog(@"heightcheck = %d",heightcheck);
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + CollectionView.frame.size.height + 50;
    //MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
    
}
-(void)InitLikeData{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@ Likes",GetLikesDataCount];
    
    UILabel *ShowLikesCount = [[UILabel alloc]init];
    ShowLikesCount.frame = CGRectMake(30, 20, 150, 20);
    ShowLikesCount.text = TempString;
    ShowLikesCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowLikesCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    [LikeView addSubview:ShowLikesCount];
    
    UIButton *Line011 = [[UIButton alloc]init];
    Line011.frame = CGRectMake(screenWidth - 30 - 25, 10, 1, 30);
    [Line011 setTitle:@"" forState:UIControlStateNormal];
    [Line011 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [LikeView addSubview:Line011];
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 30 - 20, 10, 30, 30);
    [EditProfileButton setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor clearColor];
    [LikeView addSubview:EditProfileButton];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(15, 60, screenWidth - 30, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];//238
    [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [LikeView addSubview:Line01];
    
    
    int heightcheck = 61;
    
    int TestWidth = screenWidth - 2;
    //NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 1;
   // NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 1;
    
    for (NSInteger i = DataCount_Like; i < DataTotal_Like; i++) {
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[LikesData_PhotoArray objectAtIndex:i]];
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            ShowImage.imageURL = url_NearbySmall;
        }
        [LikeView addSubview:ShowImage];
        
        
        UIButton *ImageButton = [[UIButton alloc]init];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, heightcheck + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(LikesButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [LikeView addSubview:ImageButton];
        //[MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
        LikeView.frame = CGRectMake(0, GetHeight, screenWidth, heightcheck + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }
     AllContentView.frame = CGRectMake(0, 100 , screenWidth, GetHeight + LikeView.frame.size.height + FinalWidth + FinalWidth);
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + LikeView.frame.size.height + FinalWidth + FinalWidth;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    //[MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikeView.frame.size.height + LikeView.frame.origin.y)];
}

-(void)InitPostsView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@ Posts",GetPostsDataCount];
    
    UILabel *ShowPostsCount = [[UILabel alloc]init];
    ShowPostsCount.frame = CGRectMake(30, 20, 150, 20);
    ShowPostsCount.text = TempString;
    ShowPostsCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowPostsCount.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    [PostView addSubview:ShowPostsCount];
    
    UIButton *Line011 = [[UIButton alloc]init];
    Line011.frame = CGRectMake(screenWidth - 30 - 25, 10, 1, 30);
    [Line011 setTitle:@"" forState:UIControlStateNormal];
    [Line011 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [PostView addSubview:Line011];
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 30 - 20, 10, 30, 30);
    [EditProfileButton setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor clearColor];
    [PostView addSubview:EditProfileButton];
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(15, 60, screenWidth - 30, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];//238
    [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [PostView addSubview:Line01];
    
    
    int heightcheck = 61;
    
    for (int i = 0; i < [PostsData_IDArray count]; i++) {
        NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[PostsData_PhotoArray objectAtIndex:i]];
        NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(15, heightcheck + 10, 80, 80);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
       // NSString *FullImagesURL_First = @"";
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            //NSLog(@"url is %@",url);
            ShowImage.imageURL = url_NearbySmall;
        }
        [PostView addSubview:ShowImage];
        
        UILabel *ShowTitle = [[UILabel alloc]init];
        ShowTitle.frame = CGRectMake(120, heightcheck + 10, 200, 30);
        ShowTitle.text = [PostsData_TitleArray objectAtIndex:i];
        ShowTitle.backgroundColor = [UIColor clearColor];
        ShowTitle.textColor = [UIColor blackColor];
        ShowTitle.textAlignment = NSTextAlignmentLeft;
        ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostView addSubview:ShowTitle];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(120, heightcheck + 42, 8, 11);
        [PostView addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(140, heightcheck + 40, screenWidth - 140, 20);
        ShowPlaceName.text = [PostsData_place_nameArray objectAtIndex:i];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [PostView addSubview:ShowPlaceName];
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%@ views",[PostsData_TotalCountArray objectAtIndex:i]];
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(120, heightcheck + 60, screenWidth - 120, 20);
        ShowLocation.text = TempCount;
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowLocation.textColor = [UIColor grayColor];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [PostView addSubview:ShowLocation];
        
        UIButton *Line01 = [[UIButton alloc]init];
        Line01.frame = CGRectMake(15, heightcheck + 101, screenWidth - 30, 1);
        [Line01 setTitle:@"" forState:UIControlStateNormal];//238
        [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        [PostView addSubview:Line01];
        
        UIButton *ImageButton = [[UIButton alloc]init];
        [ImageButton setBackgroundColor:[UIColor clearColor]];
        [ImageButton setTitle:@"" forState:UIControlStateNormal];
        ImageButton.frame = CGRectMake(15, heightcheck, screenWidth - 30, 101);
        ImageButton.tag = i;
        [ImageButton addTarget:self action:@selector(PostsButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [PostView addSubview:ImageButton];
        
        heightcheck += 101;
        
        PostView.frame = CGRectMake(0, GetHeight - 1, screenWidth, heightcheck);
    }
         AllContentView.frame = CGRectMake(0, 100 , screenWidth,GetHeight + PostView.frame.size.height + 251);
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + PostView.frame.size.height + 251;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
}


-(IBAction)SettingsButton:(id)sender{

    SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
    //[self.view.window.rootViewController presentViewController:SettingsView animated:YES completion:nil];
    [self presentViewController:SettingsView animated:YES completion:nil];
    
}
-(void)GetUserData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?token=%@",DataUrl.UserWallpaper_Url,GetUseruid,GetExpertToken];
    NSLog(@"urlString is %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
   // NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetUserData start];
    
    
    if( theConnection_GetUserData ){
        webData = [NSMutableData data];
    }
    
}
-(void)GetCollectionData{
    ShowActivityCollection = [[UIActivityIndicatorView alloc]init];
    ShowActivityCollection.frame = CGRectMake(30, ProfileControl.frame.origin.y + 105 , 20, 20);
    [ShowActivityCollection setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:ShowActivityCollection];
    [ShowActivityCollection startAnimating];
    
    if (CurrentPage_Collection == TotalPage_Collection) {
        
    }else{
        CurrentPage_Collection += 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/collections?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,CurrentPage_Collection];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"collection list check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_GetCollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_GetCollectionData start];
        
        
        if( theConnection_GetCollectionData ){
            webData = [NSMutableData data];
        }
    }
}
-(void)GetPostsData{
    ShowActivityPosts = [[UIActivityIndicatorView alloc]init];
    ShowActivityPosts.frame = CGRectMake(ProfileControl.frame.origin.x + 125, ProfileControl.frame.origin.y + 105 , 20, 20);
    [ShowActivityPosts setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:ShowActivityPosts];
    [ShowActivityPosts startAnimating];
    
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
-(void)GetLikesData{
    
    ShowActivityLike = [[UIActivityIndicatorView alloc]init];
    ShowActivityLike.frame = CGRectMake(ProfileControl.frame.size.width - 95, ProfileControl.frame.origin.y + 105 , 20, 20);
    [ShowActivityLike setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [MainScroll addSubview:ShowActivityLike];
    [ShowActivityLike startAnimating];
    
    if (CurrentPage_Like == TotalPage_Like) {
        
    }else{
        CurrentPage_Like += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/likes?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,CurrentPage_Like];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"GetLikesData check postBack URL ==== %@",postBack);
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
//    [ShowActivity stopAnimating];
//    //[MainScroll setContentSize:CGSizeMake(320, 100 + i * HeightGet)];
//    //    [spinnerView stopAnimating];
//    //    [spinnerView removeFromSuperview];
//    CheckLoadDone = YES;
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetUserData) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"GetData is %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            if ([StatusString isEqualToString:@"ok"]) {
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                
                NSDictionary *WallpaperData = [GetAllData valueForKey:@"wallpaper"];
                NSString *GetWallpaper = [[NSString alloc]initWithFormat:@"%@",[WallpaperData objectForKey:@"s"]];
                
                NSDictionary *ProfilePhotoData = [GetAllData valueForKey:@"profile_photo_images"];
                GetProfileImg = [[NSString alloc]initWithFormat:@"%@",[ProfilePhotoData objectForKey:@"l"]];
                
                GetName = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"name"]];
                GetUserName = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
                GetLocation = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"location"]];
                GetLink = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"personal_link"]];
                GetDescription = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
                GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"follower_count"]];
                GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"following_count"]];
                GetCategories = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"categories"]];
                Getdob = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
                GetGender = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"gender"]];
                GetPersonalTags = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"personal_tags"]];
                GetEmail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
                
                NSDictionary *SystemLanguageData = [GetAllData valueForKey:@"system_language"];
                GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
                
                NSDictionary *LanguageData = [res valueForKey:@"languages"];
                NSMutableArray *TempArray = [[NSMutableArray alloc]init];
                if (LanguageData == NULL || [ LanguageData count ] == 0) {
                    GetPrimaryLanguage = @"English";
                    GetSecondaryLanguage = @"";
                }else{
                    for (NSDictionary * dict in LanguageData) {
                        NSString *GetTempLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                        [TempArray addObject:GetTempLanguage_1];
                    }
                    GetPrimaryLanguage = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                    if ([TempArray count] == 1) {
                        GetSecondaryLanguage = @"";
                    }else{
                        GetSecondaryLanguage = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                    }
                }
                
                if ([GetPersonalTags length] == 0 || [GetPersonalTags isEqualToString:@""] || [GetPersonalTags isEqualToString:@"(null)"] || GetPersonalTags == nil) {
                }else{
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
                    GetPersonalTags = [[GetPersonalTags componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                    NSArray *arr = [GetPersonalTags componentsSeparatedByString:@","];
                    ArrHashTag = [[NSMutableArray alloc]initWithArray:arr];
                }
                
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BackgroundImage];
                NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
                NSURL *url_UserImage = [NSURL URLWithString:GetWallpaper];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                BackgroundImage.imageURL = url_UserImage;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:GetCategories forKey:@"UserData_Categories"];
                [defaults setObject:GetProfileImg forKey:@"UserData_ProfilePhoto"];
                [defaults setObject:GetWallpaper forKey:@"UserData_Wallpaper"];
                [defaults setObject:GetName forKey:@"UserData_Name"];
                [defaults setObject:GetUserName forKey:@"UserData_Username"];
                [defaults setObject:GetDescription forKey:@"UserData_Abouts"];
                [defaults setObject:GetLink forKey:@"UserData_Url"];
                [defaults setObject:GetEmail forKey:@"UserData_Email"];
                [defaults setObject:GetLocation forKey:@"UserData_Location"];
                [defaults setObject:Getdob forKey:@"UserData_dob"];
                [defaults setObject:GetGender forKey:@"UserData_Gender"];
                [defaults setObject:GetPersonalTags forKey:@"UserData_PersonalTags"];
                [defaults setObject:GetSystemLanguage forKey:@"UserData_SystemLanguage"];
                [defaults setObject:GetPrimaryLanguage forKey:@"UserData_Language1"];
                [defaults setObject:GetSecondaryLanguage forKey:@"UserData_Language2"];
                [defaults setObject:GetFollowersCount forKey:@"UserData_FollowersCount"];
                [defaults setObject:GetFollowingCount forKey:@"UserData_FollowingCount"];
                [defaults synchronize];
                
                
                [self InitContentView];
                [self GetCollectionData];
            }else{
            
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *GetBackCheckAPI = [defaults objectForKey:@"CheckAPI"];
                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                
                NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                NSLog(@"language is %@",language);
                // zh-Hans - Simplified Chinese
                // zh-Hant - Traditional Chinese
                // en - English
                // th - Thai
                // id - Bahasa Indonesia
                NSInteger CheckSystemLanguage;
                if ([language isEqualToString:@"en"]) {
                    CheckSystemLanguage = 0;
                }else if([language isEqualToString:@"zh-Hans"]){
                    CheckSystemLanguage = 1;
                }else if([language isEqualToString:@"zh-Hant"]){
                    CheckSystemLanguage = 2;
                }else if([language isEqualToString:@"id"]){
                    CheckSystemLanguage = 3;
                }else if([language isEqualToString:@"th"]){
                    CheckSystemLanguage = 4;
                }else if([language isEqualToString:@"tl-PH"]){
                    CheckSystemLanguage = 5;
                }
                LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
                
                Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
                [languageManager setLanguageWithLocale:localeForRow];
                
                
                //save back
                [defaults setObject:GetBackCheckAPI forKey:@"CheckAPI"];
                //[defaults setObject:GetBackAPIVersion forKey:@"APIVersionSet"];
                [defaults synchronize];
                
                
                LandingV2ViewController *LandingView = [[LandingV2ViewController alloc]init];
                [self presentViewController:LandingView animated:YES completion:nil];
                
            }
                
                
            }
            
            
        
        
        

    }else if(connection == theConnection_GetCollectionData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"GetCollectionData is %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        if ([StatusString isEqualToString:@"0"] || [StatusString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSLog(@"Get Collection all list data is %@",res);
            NSDictionary *GetResData = [res valueForKey:@"data"];
            
            GetCollectionDataCount = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_result"]];
            
            NSString *page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"page"]];
            NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_page"]];
            CurrentPage_Collection = [page intValue];
            TotalPage_Collection = [total_page intValue];
            if (CheckFirstTimeLoadCollection == 0) {
                CollectionData_IDArray = [[NSMutableArray alloc]init];
                CollectionData_PhotoArray = [[NSMutableArray alloc]init];
                DataCount_Collection = 0;
                CollectionData_TitleArray = [[NSMutableArray alloc]init];
                CollectionData_DescriptionArray = [[NSMutableArray alloc]init];
            }else{
            }
            
            NSArray *GetAllData = (NSArray *)[GetResData valueForKey:@"result"];
            
            for (NSDictionary * dict in GetAllData) {
                NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"collection_id"]];
                [CollectionData_IDArray addObject:PlaceID];
                NSString *name = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"name"]];
                [CollectionData_TitleArray addObject:name];
                NSString *description = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"description"]];
                [CollectionData_DescriptionArray addObject:description];
            }
            NSDictionary *GetPostsData = [GetAllData valueForKey:@"posts"];
            NSArray *PhotoData = [GetPostsData valueForKey:@"photos"];
            for (NSDictionary * dict in PhotoData) {
                NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict_ in dict) {
                    NSDictionary *UserInfoData = [dict_ valueForKey:@"s"];
                    
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                    [UrlArray addObject:url];
                }
                NSString *result2 = [UrlArray componentsJoinedByString:@","];
                [CollectionData_PhotoArray addObject:result2];
            }
            
            NSLog(@"CollectionData_IDArray is %@",CollectionData_IDArray);
            NSLog(@"CollectionData_TitleArray is %@",CollectionData_TitleArray);
            NSLog(@"CollectionData_DescriptionArray is %@",CollectionData_DescriptionArray);
            NSLog(@"CollectionData_PhotoArray is %@",CollectionData_PhotoArray);
            
            
            DataCount_Collection = DataTotal_Collection;
            DataTotal_Collection = [CollectionData_IDArray count];
            
            CheckLoad_Collection = NO;
            
            if (CheckFirstTimeLoadCollection == 0) {
                CheckFirstTimeLoadCollection = 1;
                [self GetPostsData];
                [self InitCollectionView];
            }else{
                [self InitCollectionView];
            }
        }
        
        [ShowActivityCollection stopAnimating];
        
        
        
    }else if(connection == theConnection_GetPostsData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //     NSLog(@"User Post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //  NSLog(@"Feed Json = %@",res);
        
        NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        
        if ([StatusString isEqualToString:@"0"] || [StatusString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            
             NSDictionary *GetResData = [res valueForKey:@"data"];
            
            GetPostsDataCount = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_posts"]];
            if ([GetPostsDataCount isEqualToString:@"0"]) {
                GetLikesDataCount = @"0";
//                GetDraftsDataCount = @"0";
//                KosongView.hidden = NO;
                [self InitContentView];
                [self GetLikesData];
            }else{
               
                
                NSArray *GetAllData = (NSArray *)[GetResData valueForKey:@"posts"];
                
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"page"]];
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_page"]];
                CurrentPage_Post = [page intValue];
                TotalPage_Post = [total_page intValue];
                
                if (CheckFirstTimeLoadPost == 0) {
                    PostsData_IDArray = [[NSMutableArray alloc]init];
                    PostsData_PhotoArray = [[NSMutableArray alloc]init];
                    DataCount_Post = 0;
                    PostsData_TitleArray = [[NSMutableArray alloc]init];
                    PostsData_place_nameArray = [[NSMutableArray alloc]init];
                    PostsData_TotalCountArray = [[NSMutableArray alloc]init];
                }else{
                }
                //  PostsData_IDArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in GetAllData) {
                    NSString *PlaceID = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostsData_IDArray addObject:PlaceID];
                    NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [PostsData_place_nameArray addObject:PlaceName];
                    NSString *viewcount = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"view_count"]];
                    [PostsData_TotalCountArray addObject:viewcount];
                }
                NSArray *PhotoData = [GetAllData valueForKey:@"photos"];
                
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
                
                DataCount_Post = DataTotal_Post;
                DataTotal_Post = [PostsData_IDArray count];
                
                CheckLoad_Post = NO;
                
                if (CheckFirstTimeLoadPost == 0) {
                    CheckFirstTimeLoadPost = 1;
                    [self GetLikesData];
           
                }else{
                    [self InitPostsView];
                }
                
                
                
            }
            
        }
        [ShowActivityPosts stopAnimating];
    }else if(connection == theConnection_GetLikesData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&myError];
        if (myError) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
            }else{
                NSDictionary *GetResData = [res valueForKey:@"data"];
                
                NSArray *GetAllData = (NSArray *)[GetResData valueForKey:@"posts"];
                GetLikesDataCount = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_posts"]];
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"page"]];
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[GetResData objectForKey:@"total_page"]];
                CurrentPage_Like = [page intValue];
                TotalPage_Like = [total_page intValue];
                if (CheckFirstTimeLoadLikes == 0) {
                    LikesData_IDArray = [[NSMutableArray alloc]init];
                    LikesData_PhotoArray = [[NSMutableArray alloc]init];
                    DataCount_Like = 0;
                }else{
                    
                }
                
                
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

                
                DataCount_Like = DataTotal_Like;
                DataTotal_Like = [LikesData_IDArray count];

                //[self InitView];
//                CheckLoad_Likes = NO;
//                
//                if (CheckFirstTimeLoadLikes == 0) {
//                    CheckFirstTimeLoadLikes = 1;
//                    [self GetDraftsData];
//                    
//                }else{
//                    [self InitLikeData];
//                }
                [self InitLikeData];
                
            }
            
            [ShowActivityLike stopAnimating];
            
        }
    }
}
-(IBAction)SearchButton:(id)sender{
    SearchViewV2Controller *SearchView = [[SearchViewV2Controller alloc]initWithNibName:@"SearchViewV2Controller" bundle:nil];
    [self.navigationController pushViewController:SearchView animated:YES];
    //[self presentViewController:SearchView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:SearchView animated:YES completion:nil];
}
-(IBAction)LikesButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[LikesData_IDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)PostsButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    [self.navigationController pushViewController:FeedDetailView animated:YES];
    [FeedDetailView GetPostID:[PostsData_IDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)OpenCollectionOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"OpenCollectionOnClick button %li",(long)getbuttonIDN);
    
    CollectionViewController *OpenCollectionView = [[CollectionViewController alloc]init];
   // [self.view.window.rootViewController presentViewController:OpenCollectionView animated:YES completion:nil];
    [self.navigationController pushViewController:OpenCollectionView animated:YES];
    [OpenCollectionView GetCollectionID:[CollectionData_IDArray objectAtIndex:getbuttonIDN]];
}

-(IBAction)CollectionEditButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"CollectionEditButtonOnClick button %li",(long)getbuttonIDN);
    
    NSString* collectionID = CollectionData_IDArray[getbuttonIDN];
    
    
    _editCollectionViewController = nil;// for the view controller to reinitialize
    [self.editCollectionViewController requestServerForCollectionDetails:collectionID successBlock:^(id object) {
        
        [self.editCollectionViewController initData:[[ConnectionManager dataManager] collectionModels]];
        [self.navigationController pushViewController:self.editCollectionViewController animated:YES];

    } failBlock:^(id object) {
        [TSMessage showNotificationInViewController:self title:@"System" subtitle:@"Error" type:TSMessageNotificationTypeError duration:1.0f canBeDismissedByUser:YES];
    }];
}

#pragma mark - Declaration
-(EditCollectionViewController*)editCollectionViewController
{
    
    if (!_editCollectionViewController) {
        
        _editCollectionViewController = [EditCollectionViewController new];
    
    }
    return _editCollectionViewController;
}
-(IBAction)EditProfileButtonOnClick:(id)sender{
    EditProfileV2ViewController *EditProfileView = [[EditProfileV2ViewController alloc]init];
    [self presentViewController:EditProfileView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:EditProfileView animated:YES completion:nil];
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
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"ShareToFacebook", nil)]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/%@",GetUserName];
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
            NSString *message = [NSString stringWithFormat:@"Check out my profile on Seeties!\n\nhttps://seeties.me/%@",GetUserName];
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
-(IBAction)ShowAll_FollowerButton:(id)sender{
   
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    [self presentViewController:ShowFollowerAndFollowingView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:ShowFollowerAndFollowingView animated:YES completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
     NSString *Getuid = [defaults objectForKey:@"Useruid"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:Getuid GetType:@"Follower"];
}
-(IBAction)ShowAll_FollowingButton:(id)sender{
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    [self presentViewController:ShowFollowerAndFollowingView animated:YES completion:nil];
   // [self.view.window.rootViewController presentViewController:ShowFollowerAndFollowingView animated:YES completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:Getuid GetType:@"Following"];
}
-(IBAction)OpenUserProfileOnClick:(id)sender{
    NSLog(@"Click Full Image Button Click");
    NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetProfileImg];
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
       // [self.view.window.rootViewController presentViewController:FullImageView animated:YES completion:nil];
        [FullImageView GetImageString:GetProfileImg];
    }
}
-(IBAction)OpenUrlButton:(id)sender{
    NSLog(@"OpenUrlButton Click.");
    if ([GetLink hasPrefix:@"http://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetLink]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",GetLink];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }
    
}
@end

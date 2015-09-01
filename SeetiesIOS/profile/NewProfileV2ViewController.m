//
//  NewProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "NewProfileV2ViewController.h"
#import "SettingsViewController.h"
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
    
    //BackgroundImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
    BackgroundImage.frame = CGRectMake(0, -50, screenWidth, 300);
    CGRect headerFrame = BackgroundImage.frame;
    headerFrame.origin.y -= 50.0f;
    BackgroundImage.frame = headerFrame;
    [MainScroll addSubview:BackgroundImage withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    SettingsButton.frame = CGRectMake(screenWidth - 30 - 35, 72, 19, 19);
    ShareButton.frame = CGRectMake(screenWidth - 30, 67, 17, 24);
    
    CheckExpand = YES;
    
    AllContentView.frame = CGRectMake(0, 100, screenWidth, screenHeight + 50);
//    CGRect contentFrame = AllContentView.frame;
//    contentFrame.origin.y += 100.0f;
//    AllContentView.frame = contentFrame;
    [MainScroll addSubview:AllContentView];
    
    
    
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
    
    NSString *TempUsernameString = [[NSString alloc]initWithFormat:@"@%@",GetUserName];
    
    UILabel *ShowUserName = [[UILabel alloc]init];//getname
    ShowUserName.frame = CGRectMake(130, 10, screenWidth - 130, 30);
    ShowUserName.text = TempUsernameString;
    ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
    ShowUserName.textColor = [UIColor whiteColor];
    ShowUserName.textAlignment = NSTextAlignmentLeft;
    ShowUserName.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowUserName];
    
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 120 - 20, 50, 120, 40);
    [EditProfileButton setTitle:@"Edit profile" forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor whiteColor];
    EditProfileButton.layer.cornerRadius = 20;
    EditProfileButton.layer.borderWidth = 1;
    EditProfileButton.layer.borderColor=[[UIColor grayColor] CGColor];
    [AllContentView addSubview:EditProfileButton];
    
    UILabel *ShowName_ = [[UILabel alloc]init];//getname
    ShowName_.frame = CGRectMake(30, 110, screenWidth - 60, 30);
    ShowName_.text = GetName;
    ShowName_.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:22];
    ShowName_.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0];
    ShowName_.textAlignment = NSTextAlignmentLeft;
    ShowName_.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowName_];
    
    GetHeight = 145;

    NSString *TempHashTag = @"#lucy #malaysiablogger #fashion #beach #ilovesunset #iamlucydiamondinthesky";
    NSMutableArray *ArrHashTag = [[NSMutableArray alloc]init];
    [ArrHashTag addObject:@"#lucy"];
    [ArrHashTag addObject:@"#malaysiablogger"];
    [ArrHashTag addObject:@"#fashion"];
    [ArrHashTag addObject:@"#beach"];
    [ArrHashTag addObject:@"#ilovesunset"];
    [ArrHashTag addObject:@"#iamlucydiamondinthesky"];
    [ArrHashTag addObject:@"#sexy"];
    
    // followers and followings count show
    
    UILabel *ShowFollowers = [[UILabel alloc]init];
    ShowFollowers.text = @"32 Followers";
    ShowFollowers.frame = CGRectMake(50, GetHeight, 120, 21);
    ShowFollowers.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowFollowers.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
    ShowFollowers.textAlignment = NSTextAlignmentLeft;
    ShowFollowers.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowFollowers];
    
    UILabel *ShowFollowing = [[UILabel alloc]init];
    ShowFollowing.text = @"3 Followings";
    ShowFollowing.frame = CGRectMake(170, GetHeight, 120, 21);
    ShowFollowing.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowFollowing.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
    ShowFollowing.textAlignment = NSTextAlignmentLeft;
    ShowFollowing.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowFollowing];
    
    GetHeight += 30;
    
    
    if ([GetLocation isEqualToString:@""] || [GetLocation isEqualToString:@"(null)"] || [GetLocation length] == 0) {
        
    }else{
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(33, GetHeight + 4, 8, 11);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [AllContentView addSubview:ShowPin];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(50, GetHeight, screenWidth - 120, 20);
        ShowLocation.text = GetLocation;
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowLocation.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [AllContentView addSubview:ShowLocation];
        
        GetHeight += 30;
    }
    
    if ([GetDescription isEqualToString:@""] || [GetDescription isEqualToString:@"(null)"] || [GetDescription length] == 0) {
        
    }else{
        UILabel *ShowAboutText = [[UILabel alloc]init];
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
        UILabel *ShowLink = [[UILabel alloc]init];
        ShowLink.frame = CGRectMake(50, GetHeight, screenWidth - 120, 20);
        ShowLink.text = GetLink;
        ShowLink.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowLink.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowLink.textAlignment = NSTextAlignmentLeft;
        ShowLink.backgroundColor = [UIColor clearColor];
        [AllContentView addSubview:ShowLink];
        
        GetHeight += 30;
    }
    
    NSLog(@"after about us height is ==== %d",GetHeight);
    if (CheckExpand == YES) {
        if (GetHeight > 240) {
            CheckExpand = YES;
        }else{
            CheckExpand = NO;
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
        [ExpandButton setTitle:@"Expand" forState:UIControlStateNormal];
        ExpandButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [ExpandButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        ExpandButton.backgroundColor = [UIColor whiteColor];
        [ExpandButton addTarget:self action:@selector(ExpandButton:) forControlEvents:UIControlEventTouchUpInside];
        [AllContentView addSubview:ExpandButton];
        
        GetHeight += 50;
        
    }else{
    
        if ([TempHashTag isEqualToString:@""] || [TempHashTag isEqualToString:@"(null)"] || [TempHashTag length] == 0) {
            
        }else{
            
            UIScrollView *HashTagScroll = [[UIScrollView alloc]init];
            HashTagScroll.delegate = self;
            HashTagScroll.frame = CGRectMake(0, GetHeight, screenWidth, 50);
            HashTagScroll.backgroundColor = [UIColor whiteColor];
            [AllContentView addSubview:HashTagScroll];
            CGRect frame2;
            for (int i= 0; i < [ArrHashTag count]; i++) {
                UILabel *ShowHashTagText = [[UILabel alloc]init];
                ShowHashTagText.text = [ArrHashTag objectAtIndex:i];
                ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowHashTagText.textAlignment = NSTextAlignmentCenter;
                ShowHashTagText.backgroundColor = [UIColor whiteColor];
                ShowHashTagText.layer.cornerRadius = 5;
                ShowHashTagText.layer.borderWidth = 1;
                ShowHashTagText.layer.borderColor=[[UIColor grayColor] CGColor];

                CGSize textSize = [ShowHashTagText.text sizeWithAttributes:@{NSFontAttributeName:[ShowHashTagText font]}];
                ShowHashTagText.frame = CGRectMake(30 + frame2.size.width, 15, textSize.width + 20, 20);
                frame2.size.width += textSize.width + 30;
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
        
        UIButton *CollapseButton = [[UIButton alloc]init];
        CollapseButton.frame = CGRectMake(0, GetHeight, screenWidth, 50);
        [CollapseButton setTitle:@"Collapse" forState:UIControlStateNormal];
        CollapseButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [CollapseButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        CollapseButton.backgroundColor = [UIColor whiteColor];
        [CollapseButton addTarget:self action:@selector(CollapseButton:) forControlEvents:UIControlEventTouchUpInside];
        [AllContentView addSubview:CollapseButton];
        
        GetHeight += 50;
        
      }
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 20);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
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
    PostView.frame = CGRectMake(0, GetHeight - 1, screenWidth, 400);
    PostView.backgroundColor = [UIColor whiteColor];
    [AllContentView addSubview:PostView];
    
    CollectionView = [[UIView alloc]init];
    CollectionView.frame = CGRectMake(0, GetHeight, screenWidth, 600);
    CollectionView.backgroundColor = [UIColor lightGrayColor];
    [AllContentView addSubview:CollectionView];
    
    
    LikeView = [[UIView alloc]init];
    LikeView.frame = CGRectMake(0, GetHeight, screenWidth, 800);
    LikeView.backgroundColor = [UIColor lightGrayColor];
    [AllContentView addSubview:LikeView];
    
    LikeView.hidden = YES;
    CollectionView.hidden = NO;
    PostView.hidden = YES;
    
//    CGSize contentSize = MainScroll.frame.size;
//    contentSize.height = GetHeight + PostView.frame.size.height + 200;
//    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    MainScroll.contentSize = contentSize;
    [self InitCollectionView];
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
            
//            contentSize.height = GetHeight + PostView.frame.size.height + 200;
//            MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            MainScroll.contentSize = contentSize;

            break;
        case 2:
            NSLog(@"Likes click");
            PostView.hidden = YES;
            CollectionView.hidden = YES;
            LikeView.hidden = NO;
            [self InitLikeData];
            
//            contentSize.height = GetHeight + LikeView.frame.size.height + 200;
//            MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            MainScroll.contentSize = contentSize;
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

    UILabel *ShowCollectionCount = [[UILabel alloc]init];
    ShowCollectionCount.frame = CGRectMake(30, 20, 150, 20);
    ShowCollectionCount.text = @"3 Collections";
    ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowCollectionCount.textColor = [UIColor blackColor];
    [CollectionView addSubview:ShowCollectionCount];
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 100 - 20, 20, 100, 20);
    [EditProfileButton setTitle:@"New collection" forState:UIControlStateNormal];
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
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, FinalWidth + 10 + 70);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor whiteColor];
        TempButton.layer.cornerRadius = 5;
        [CollectionView addSubview: TempButton];
        
        NSMutableArray *DemoArray = [[NSMutableArray alloc]init];
        [DemoArray addObject:@"DemoBackground.jpg"];
        [DemoArray addObject:@"UserDemo1.jpg"];
        [DemoArray addObject:@"UserDemo2.jpg"];
        [DemoArray addObject:@"UserDemo3.jpg"];
        
        for (int z = 0; z < [DemoArray count]; z++) {
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.frame = CGRectMake(15 +(z % 4) * SpaceWidth, heightcheck + 5 +i, FinalWidth, FinalWidth);
            ShowImage.image = [UIImage imageNamed:[DemoArray objectAtIndex:z]];
            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowImage.layer.cornerRadius=5;
            ShowImage.layer.masksToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            
            [CollectionView addSubview:ShowImage];
        }
        
        UILabel *ShowExplore = [[UILabel alloc]init];
        ShowExplore.frame = CGRectMake(30, heightcheck + 5 + FinalWidth + 20 + i, screenWidth - 100, 20);
        ShowExplore.text = @"The Good Stuffs";
        ShowExplore.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        ShowExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
        [CollectionView addSubview:ShowExplore];
        
        UILabel *ShowSubExplore = [[UILabel alloc]init];
        ShowSubExplore.frame = CGRectMake(30, heightcheck + 5 + FinalWidth + 40 + i, screenWidth - 100, 20);
        ShowSubExplore.text = @"A collection of products i like.";
        ShowSubExplore.textColor = [UIColor lightGrayColor];
        ShowSubExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
        [CollectionView addSubview:ShowSubExplore];
        
        UIButton *EditButton = [[UIButton alloc]init];
        EditButton.frame = CGRectMake(screenWidth - 80 - 20, heightcheck + 5 + FinalWidth + 20 + i, 80, 40);
        [EditButton setTitle:@"Edit" forState:UIControlStateNormal];
        EditButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [EditButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        EditButton.backgroundColor = [UIColor clearColor];
        [CollectionView addSubview:EditButton];
        
        heightcheck += FinalWidth + 10 + 70 + 10 + i;
    }
    CollectionView.frame = CGRectMake(0, GetHeight, screenWidth, heightcheck + FinalWidth + 120);
    
    NSLog(@"GetHeight = %d",GetHeight);
    NSLog(@"heightcheck = %d",heightcheck);
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + CollectionView.frame.size.height + 50;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
}
-(void)InitLikeData{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSMutableArray *ArrLikeImg = [[NSMutableArray alloc]init];
    [ArrLikeImg addObject:@"https://unsplash.it/200/200/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/210/210/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/220/220/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/230/230/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/240/240/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/250/250/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/260/260/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/270/270/?random"];
    [ArrLikeImg addObject:@"https://unsplash.it/280/280/?random"];
    
    int TestWidth = screenWidth - 2;
    //NSLog(@"TestWidth is %i",TestWidth);
    int FinalWidth = TestWidth / 3;
    FinalWidth += 1;
   // NSLog(@"FinalWidth is %i",FinalWidth);
    int SpaceWidth = FinalWidth + 1;
    
    for (NSInteger i = 0; i < 9; i++) {
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        ShowImage.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[ArrLikeImg objectAtIndex:i]];
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
        ImageButton.frame = CGRectMake(0+(i % 3)*SpaceWidth, 0 + (SpaceWidth * (CGFloat)(i /3)), FinalWidth, FinalWidth);
        ImageButton.tag = i;
      //  [ImageButton addTarget:self action:@selector(ImageButtonOnClick2:) forControlEvents:UIControlEventTouchUpInside];
        
        [LikeView addSubview:ImageButton];
        //[MainScroll setContentSize:CGSizeMake(320, GetHeight + 105 + (106 * (CGFloat)(i /3)))];
        LikeView.frame = CGRectMake(0, GetHeight, screenWidth, 0 + FinalWidth + (SpaceWidth * (CGFloat)(i /3)));
    }
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + LikeView.frame.size.height + FinalWidth + FinalWidth;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    //[MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikeView.frame.size.height + LikeView.frame.origin.y)];
}

-(void)InitPostsView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *ShowCollectionCount = [[UILabel alloc]init];
    ShowCollectionCount.frame = CGRectMake(30, 20, 150, 20);
    ShowCollectionCount.text = @"3 Posts";
    ShowCollectionCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    ShowCollectionCount.textColor = [UIColor blackColor];
    [PostView addSubview:ShowCollectionCount];
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 100 - 20, 20, 100, 20);
    [EditProfileButton setTitle:@"+" forState:UIControlStateNormal];
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
    
    for (int i = 0; i < 5; i++) {
        
        AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
        ShowImage.frame = CGRectMake(15, heightcheck + 10, 80, 80);
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.layer.cornerRadius = 5;
        ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
        NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"https://unsplash.it/200/200/?random"];
       // NSString *FullImagesURL_First = @"";
        if ([FullImagesURL_First length] == 0) {
            ShowImage.image = [UIImage imageNamed:@"NoImage.png"];
        }else{
            NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
            //NSLog(@"url is %@",url);
            ShowImage.imageURL = url_NearbySmall;
        }
        [PostView addSubview:ShowImage];
        
        UILabel *ShowUserName = [[UILabel alloc]init];
        ShowUserName.frame = CGRectMake(120, heightcheck + 10, 200, 30);
        ShowUserName.text = @"A nice sandwich in town";
        ShowUserName.backgroundColor = [UIColor clearColor];
        ShowUserName.textColor = [UIColor blackColor];
        ShowUserName.textAlignment = NSTextAlignmentLeft;
        ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [PostView addSubview:ShowUserName];
        
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(120, heightcheck + 42, 8, 11);
        [PostView addSubview:ShowPin];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(140, heightcheck + 40, screenWidth - 140, 20);
        ShowPlaceName.text = @"Sushi Zen";
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowPlaceName.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowPlaceName.textAlignment = NSTextAlignmentLeft;
        ShowPlaceName.backgroundColor = [UIColor clearColor];
        [PostView addSubview:ShowPlaceName];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(120, heightcheck + 60, screenWidth - 120, 20);
        ShowLocation.text = @"Open now";
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
        
        heightcheck += 101;
        
        PostView.frame = CGRectMake(0, GetHeight - 1, screenWidth, heightcheck);
    }
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + PostView.frame.size.height + 251;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
}


-(IBAction)SettingsButton:(id)sender{

    SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
    [self.view.window.rootViewController presentViewController:SettingsView animated:YES completion:nil];
}
-(void)GetUserData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUseruid = [defaults objectForKey:@"Useruid"];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",DataUrl.UserWallpaper_Url,GetUseruid];
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
    
    theConnection_GetUserData = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection_GetUserData start];
    
    
    if( theConnection_GetUserData ){
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
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BackgroundImage];
                NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
                NSURL *url_UserImage = [NSURL URLWithString:GetWallpaper];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                BackgroundImage.imageURL = url_UserImage;
                
                
                [self InitContentView];
                
            }else{
            
            }
            
            
        }
        
        

    }
}
@end

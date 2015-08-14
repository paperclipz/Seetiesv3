//
//  NewProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "NewProfileV2ViewController.h"
#import "AsyncImageView.h"
#import "SettingsViewController.h"
@interface NewProfileV2ViewController ()

@end

@implementation NewProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    GetHeight = 0;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = 800;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    
    BackgroundImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
    BackgroundImage.frame = CGRectMake(0, -50, screenWidth, 300);
    CGRect headerFrame = BackgroundImage.frame;
    headerFrame.origin.y -= 50.0f;
    BackgroundImage.frame = headerFrame;
    [MainScroll addSubview:BackgroundImage withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    
    
    AllContentView.frame = CGRectMake(0, 100, screenWidth, screenHeight - 100);
//    CGRect contentFrame = AllContentView.frame;
//    contentFrame.origin.y += 100.0f;
//    AllContentView.frame = contentFrame;
    [MainScroll addSubview:AllContentView];
    
    [self InitContentView];
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

    AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
    ShowUserProfileImage.frame = CGRectMake(20, 0, 100, 100);
    ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
    ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserProfileImage.layer.cornerRadius = 50;
    ShowUserProfileImage.layer.borderWidth = 5;
    ShowUserProfileImage.layer.masksToBounds = YES;
    ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
    [AllContentView addSubview:ShowUserProfileImage];
    
    
    UIButton *EditProfileButton = [[UIButton alloc]init];
    EditProfileButton.frame = CGRectMake(screenWidth - 80 - 20, 50, 80, 40);
    [EditProfileButton setTitle:@"Edit profile" forState:UIControlStateNormal];
    EditProfileButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    [EditProfileButton setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    EditProfileButton.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:EditProfileButton];
    
    UILabel *ShowName_ = [[UILabel alloc]init];//getname
    ShowName_.frame = CGRectMake(30, 110, screenWidth - 60, 30);
    ShowName_.text = @"Lucy Jin";
    ShowName_.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:22];
    ShowName_.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0];
    ShowName_.textAlignment = NSTextAlignmentLeft;
    ShowName_.backgroundColor = [UIColor clearColor];
    [AllContentView addSubview:ShowName_];
    
    GetHeight = 145;
    
    NSString *TempLocation = @"Petaling Jaya, Malaysia";//Petaling Jaya, Malaysia
    NSString *TempAbout = @"i love lucy diamond in the sky. the name 'Lucy' stands for bright light in the sky, like the diamond in the sky.";
    NSString *TempHashTag = @"#lucy #malaysiablogger #fashion #beach #ilovesunset #iamlucydiamondinthesky";
    
    if ([TempLocation isEqualToString:@""] || [TempLocation isEqualToString:@"(null)"] || [TempLocation length] == 0) {
        
    }else{
        UIImageView *ShowPin = [[UIImageView alloc]init];
        ShowPin.image = [UIImage imageNamed:@"FeedPin.png"];
        ShowPin.frame = CGRectMake(33, 149, 8, 11);
        //ShowPin.frame = CGRectMake(15, 210 + 8 + heightcheck + i, 8, 11);
        [AllContentView addSubview:ShowPin];
        
        UILabel *ShowLocation = [[UILabel alloc]init];
        ShowLocation.frame = CGRectMake(50, 145, screenWidth - 120, 20);
        ShowLocation.text = TempLocation;
        ShowLocation.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowLocation.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        ShowLocation.textAlignment = NSTextAlignmentLeft;
        ShowLocation.backgroundColor = [UIColor clearColor];
        [AllContentView addSubview:ShowLocation];
        
        GetHeight += 30;
    }
    
    if ([TempAbout isEqualToString:@""] || [TempAbout isEqualToString:@"(null)"] || [TempAbout length] == 0) {
        
    }else{
        UILabel *ShowAboutText = [[UILabel alloc]init];
        ShowAboutText.frame = CGRectMake(30, GetHeight, screenWidth - 60, 30);
        ShowAboutText.text = TempAbout;
        ShowAboutText.numberOfLines = 0;
        ShowAboutText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowAboutText.textColor = [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
        ShowAboutText.textAlignment = NSTextAlignmentLeft;
        [AllContentView addSubview:ShowAboutText];
        
        CGSize size = [ShowAboutText sizeThatFits:CGSizeMake(ShowAboutText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAboutText.frame;
        frame.size.height = size.height;
        ShowAboutText.frame = frame;
        
        GetHeight += ShowAboutText.frame.size.height + 20;
    }
    
    if ([TempHashTag isEqualToString:@""] || [TempHashTag isEqualToString:@"(null)"] || [TempHashTag length] == 0) {
        
    }else{
        UILabel *ShowHashTagText = [[UILabel alloc]init];
        ShowHashTagText.frame = CGRectMake(30, GetHeight, screenWidth - 60, 30);
        ShowHashTagText.text = TempHashTag;
        ShowHashTagText.numberOfLines = 0;
        ShowHashTagText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        ShowHashTagText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        ShowHashTagText.textAlignment = NSTextAlignmentLeft;
        [AllContentView addSubview:ShowHashTagText];
        
        CGSize size = [ShowHashTagText sizeThatFits:CGSizeMake(ShowHashTagText.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowHashTagText.frame;
        frame.size.height = size.height;
        ShowHashTagText.frame = frame;
        
        GetHeight += ShowHashTagText.frame.size.height + 20;
    }
    
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

    GetHeight += 50;
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, GetHeight, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];
    [Line01 setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [AllContentView addSubview:Line01];
    
    GetHeight += 11;
    
    NSString *TempStringPosts = [[NSString alloc]initWithFormat:@"Post"];
    NSString *TempStringCollection = [[NSString alloc]initWithFormat:@"Collection"];
    NSString *TempStringLike = [[NSString alloc]initWithFormat:@"Like"];
    
    NSArray *itemArray = [NSArray arrayWithObjects:TempStringPosts, TempStringCollection,TempStringLike, nil];
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
    PostView.frame = CGRectMake(0, GetHeight, screenWidth, 400);
    PostView.backgroundColor = [UIColor lightGrayColor];
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
    CollectionView.hidden = YES;
    PostView.hidden = NO;
    
    CGSize contentSize = MainScroll.frame.size;
    contentSize.height = GetHeight + PostView.frame.size.height + 200;
    MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    MainScroll.contentSize = contentSize;
    

    
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    CGSize contentSize = MainScroll.frame.size;
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Posts click");
            LikeView.hidden = YES;
            CollectionView.hidden = YES;
            PostView.hidden = NO;
            
            contentSize.height = GetHeight + PostView.frame.size.height + 200;
            MainScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            MainScroll.contentSize = contentSize;
            break;
        case 1:
            NSLog(@"Collection click");
            PostView.hidden = YES;
            LikeView.hidden = YES;
            CollectionView.hidden = NO;
            [self InitCollectionView];

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
    
    for (int i = 0; i < 1; i++) {
        
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
    
    
    [MainScroll setContentSize:CGSizeMake(screenWidth, GetHeight + LikeView.frame.size.height + LikeView.frame.origin.y - FinalWidth)];
}
-(IBAction)SettingsButton:(id)sender{

    SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
    [self.view.window.rootViewController presentViewController:SettingsView animated:YES completion:nil];
}


@end

//
//  TestFeedV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/28/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "TestFeedV2ViewController.h"
#import "AsyncImageView.h"
#import "SearchViewV2Controller.h"
#import "Filter2ViewController.h"
@interface TestFeedV2ViewController ()

@end

@implementation TestFeedV2ViewController

-(void)initSelfView
{
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight);
    MainScroll.delegate = self;
    // MainScroll.alwaysBounceHorizontal = YES;
    MainScroll.alwaysBounceVertical = YES;
    
    ShowFeedText.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SearchButton.frame = CGRectMake(screenWidth - 84 - 15, 27, 84, 30);
    
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
//    ShowFeedText.text = CustomLocalisedString(@"MainTab_Feed",nil);
//    [NearbyButton setTitle:CustomLocalisedString(@"NearBy",nil) forState:UIControlStateNormal];
//    [FilterButton setTitle:CustomLocalisedString(@"Filter", nil) forState:UIControlStateNormal];
    
    heightcheck = 0;
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
                                       0,
                                       refreshControl.bounds.size.width,
                                       refreshControl.bounds.size.height);
   // refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {
        [refreshControl beginRefreshing];
        [self LoadDataView];
    }else{
        [ShowActivity startAnimating];
        [self LoadInitView];
    }

}

-(void)initData
{
    arrAddress = [[NSMutableArray alloc]init];
    [arrAddress addObject:@"Love Hotel, Tapipei City, Taiwan"];
    [arrAddress addObject:@""];
    [arrAddress addObject:@"Setapak, Malaysia"];
    [arrAddress addObject:@"Thailand"];
    [arrAddress addObject:@""];
    [arrAddress addObject:@"ss17, Petaling Jaya"];
    [arrAddress addObject:@"Port Dickson, Malaysia"];
    [arrAddress addObject:@""];
    [arrAddress addObject:@"Port Dickson, Malaysia"];
    
    arrTitle = [[NSMutableArray alloc]init];
    [arrTitle addObject:@"A Good Homestay in Taiwan"];
    [arrTitle addObject:@""];
    [arrTitle addObject:@""];
    [arrTitle addObject:@"A Good Homestay in Taiwan"];
    [arrTitle addObject:@""];
    [arrTitle addObject:@""];
    [arrTitle addObject:@""];
    [arrTitle addObject:@""];
    [arrTitle addObject:@"A Good Homestay in Taiwan"];
    
    arrMessage = [[NSMutableArray alloc]init];
    [arrMessage addObject:@"It's 5 a.m., and although my head hit the pillow, post-nightcap, just a few hours prior, i can't sleep,. As always when i travel, i'm tired to afbhiafnjeafj aefjeajfeaj feajf eajf jnea"];
    [arrMessage addObject:@""];
    [arrMessage addObject:@""];
    [arrMessage addObject:@"It's 5 a.m., and although my head hit the pillow, post-nightcap, just a few hours prior, i can't sleep,. As always when i travel, i'm tired to afbhiafnjeafj aefjeajfeaj feajf eajf jnea"];
    [arrMessage addObject:@""];
    [arrMessage addObject:@"It's 5 a.m., and although my head hit the pillow, post-nightcap, just a few hours prior, i can't sleep,. As always when i travel, i'm tired to afbhiafnjeafj aefjeajfeaj feajf eajf jnea"];
    [arrMessage addObject:@""];
    [arrMessage addObject:@""];
    [arrMessage addObject:@"It's 5 a.m., and although my head hit the pillow, post-nightcap, just a few hours prior, i can't sleep,. As always when i travel, i'm tired to afbhiafnjeafj aefjeajfeaj feajf eajf jnea"];
    
    arrType = [[NSMutableArray alloc]init];
    [arrType addObject:@"Post"];
    [arrType addObject:@"Promotion"];
    [arrType addObject:@"Post"];
    [arrType addObject:@"Post"];
    [arrType addObject:@"User"];
    [arrType addObject:@"Post"];
    [arrType addObject:@"Post"];
    [arrType addObject:@"Promotion"];
    [arrType addObject:@"Post"];
    
    arrImage = [[NSMutableArray alloc]init];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/500/?random"];
    [arrImage addObject:@"https://unsplash.it/375/200/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/450/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/600/?random"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initSelfView];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    


}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testRefresh{

    NSLog(@"testRefresh");
    
    [refreshControl endRefreshing];
}
-(void)LoadDataView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for ( int i = 0; i < 10; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(20, 0 + i * 100, screenWidth - 40, 90);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor purpleColor];
        [MainScroll addSubview: TempButton];
        
        [MainScroll setContentSize:CGSizeMake(screenWidth, 290 + i * 100)];
    }
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"Done" forKey:@"TestLocalData"];
//    [defaults synchronize];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(timerCalled)
                                   userInfo:nil
                                    repeats:NO];
   // [refreshControl endRefreshing];
}
-(void)LoadInitView{
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(StartInit1stView)
                                   userInfo:nil
                                    repeats:NO];

}
-(void)StartInit1stView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake(10, 10, screenWidth - 20, 70);
    [TempButton setTitle:@"" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor whiteColor];
    TempButton.layer.cornerRadius = 5;
    [MainScroll addSubview: TempButton];
    
    UILabel *ShowExplore = [[UILabel alloc]init];
    ShowExplore.frame = CGRectMake(80, 25, screenWidth - 100, 20);
    ShowExplore.text = @"Explore nearby";
    ShowExplore.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
    ShowExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
    [MainScroll addSubview:ShowExplore];
    
    UILabel *ShowSubExplore = [[UILabel alloc]init];
    ShowSubExplore.frame = CGRectMake(80, 45, screenWidth - 100, 20);
    ShowSubExplore.text = @"There is always excitement around you.";
    ShowSubExplore.textColor = [UIColor lightGrayColor];
    ShowSubExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
    [MainScroll addSubview:ShowSubExplore];
    
    heightcheck += 90;
    
    
    for ( int i = 0; i < 9; i++) {
        
        NSString *GetType = [arrType objectAtIndex:i];
        if ([GetType isEqualToString:@"Post"]) {
            int TempHeight = heightcheck + i;
            int TempCountWhiteHeight = 0;
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, 200);
            [TempButton setTitle:@"" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor whiteColor];
            TempButton.layer.cornerRadius = 5;
            [MainScroll addSubview: TempButton];
            
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowImage.layer.masksToBounds = YES;
            ShowImage.layer.cornerRadius = 5;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
            UIImage *image_;
            UIImage *newImage;
            if ([FullImagesURL_First length] == 0) {
                image_ = [UIImage imageNamed:@"NoImage.png"];
                // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, screenWidth);
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
                //   ShowImage.imageURL = url_NearbySmall;
                NSData *data = [[NSData alloc]initWithContentsOfURL:url_NearbySmall];
                image_ = [[UIImage alloc]initWithData:data];
            }
//            UIImage *image_;
//            UIImage *newImage;
//            image_ = [UIImage imageNamed:@"DemoBackground.jpg"];
            float oldWidth = image_.size.width;
            float scaleFactor = screenWidth / oldWidth;
            
            float newHeight = image_.size.height * scaleFactor;
            float newWidth = oldWidth * scaleFactor;
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [image_ drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            ShowImage.image = newImage;
            
            
            ShowImage.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, newImage.size.height);
            // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 200);
            [MainScroll addSubview:ShowImage];
            
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(20, heightcheck + i + 10, 40, 40);
            ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=3;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            [MainScroll addSubview:ShowUserProfileImage];
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(70, heightcheck + i + 10, 200, 40);
            ShowUserName.text = @"ahyongah";
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor whiteColor];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowUserName];
            
            UILabel *ShowDistance = [[UILabel alloc]init];
            ShowDistance.frame = CGRectMake(screenWidth - 135, heightcheck + i + 10, 100, 40);
            // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
            ShowDistance.text = @"7Km";
            ShowDistance.textColor = [UIColor whiteColor];
            ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            ShowDistance.textAlignment = NSTextAlignmentRight;
            ShowDistance.backgroundColor = [UIColor clearColor];
            [MainScroll addSubview:ShowDistance];
            
            heightcheck += newImage.size.height + 5;
            
            UILabel *ShowAddress = [[UILabel alloc]init];
            ShowAddress.frame = CGRectMake(20, heightcheck + i, screenWidth - 40, 20);
            ShowAddress.text = [arrAddress objectAtIndex:i];
            ShowAddress.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowAddress];
            
            heightcheck += 25;
            TempCountWhiteHeight = newImage.size.height + 25;
            
            
            NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"%@",[arrTitle objectAtIndex:i]];
            if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                
            }else{
                UILabel *ShowTitle = [[UILabel alloc]init];
                ShowTitle.frame = CGRectMake(20, heightcheck + i, screenWidth - 40, 40);
                ShowTitle.text = TempGetStirng;
                ShowTitle.backgroundColor = [UIColor clearColor];
                ShowTitle.numberOfLines = 2;
                ShowTitle.textAlignment = NSTextAlignmentLeft;
                ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [MainScroll addSubview:ShowTitle];
                
                if([ShowTitle sizeThatFits:CGSizeMake(screenWidth - 30, CGFLOAT_MAX)].height!=ShowTitle.frame.size.height)
                {
                    ShowTitle.frame = CGRectMake(20, heightcheck + i, screenWidth - 40,[ShowTitle sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
                }
                heightcheck += ShowTitle.frame.size.height + 10;
                
                TempCountWhiteHeight += ShowTitle.frame.size.height + 10;
            }
            
            NSString *TempGetMessage = [[NSString alloc]initWithFormat:@"%@",[arrMessage objectAtIndex:i]];
            //TempGetMessage = [TempGetMessage stringByDecodingXMLEntities];
            if ([TempGetMessage length] == 0 || [TempGetMessage isEqualToString:@""] || [TempGetMessage isEqualToString:@"(null)"]) {
                
            }else{
                UILabel *ShowMessage = [[UILabel alloc]init];
                ShowMessage.frame = CGRectMake(20, heightcheck + i, screenWidth - 40, 40);
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
                ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                [MainScroll addSubview:ShowMessage];
                
                if([ShowMessage sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height!=ShowMessage.frame.size.height)
                {
                    ShowMessage.frame = CGRectMake(20, heightcheck + i, screenWidth - 40,[ShowMessage sizeThatFits:CGSizeMake(screenWidth - 40, CGFLOAT_MAX)].height);
                }
                heightcheck += ShowMessage.frame.size.height + 10;
                TempCountWhiteHeight += ShowMessage.frame.size.height + 10;
                //   heightcheck += 30;
            }
            
            
            UIImageView *ShowLikesIcon = [[UIImageView alloc]init];
            ShowLikesIcon.image = [UIImage imageNamed:@"PostLike.png"];
            ShowLikesIcon.frame = CGRectMake(40 , heightcheck + i + 20 ,23, 19);
            //   ShowLikesIcon.backgroundColor = [UIColor purpleColor];
            [MainScroll addSubview:ShowLikesIcon];
            
            
            UIImageView *ShowCommentIcon = [[UIImageView alloc]init];
            ShowCommentIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowCommentIcon.frame = CGRectMake(120, heightcheck + i + 20 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            heightcheck += 70;
            TempCountWhiteHeight += 70;
            
            
            TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
            
            heightcheck += 10;
        
        }else if([GetType isEqualToString:@"User"]){
            int TestWidth = screenWidth - 40;
            //    NSLog(@"TestWidth is %i",TestWidth);
            int FinalWidth = TestWidth / 4;
            //    NSLog(@"FinalWidth is %i",FinalWidth);
            int SpaceWidth = FinalWidth + 4;
            
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, FinalWidth + 10 + 70);
            [TempButton setTitle:@"" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor whiteColor];
            TempButton.layer.cornerRadius = 5;
            [MainScroll addSubview: TempButton];
            
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(20, heightcheck + 10, 40, 40);
            ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=3;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            [MainScroll addSubview:ShowUserProfileImage];
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(70, heightcheck + 10, 200, 20);
            ShowUserName.text = @"lucydiamond";
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowUserName];
            
            UILabel *ShowMessage = [[UILabel alloc]init];
            ShowMessage.frame = CGRectMake(70, heightcheck + 30, 200, 20);
            ShowMessage.text = @"Based on your interest";
            ShowMessage.backgroundColor = [UIColor clearColor];
            ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            ShowMessage.textAlignment = NSTextAlignmentLeft;
            ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowMessage];
            
            UIButton *FollowButton = [[UIButton alloc]init];
            FollowButton.frame = CGRectMake(screenWidth - 20 - 100, heightcheck + 10, 100, 40);
            [FollowButton setTitle:@"Follow" forState:UIControlStateNormal];
            FollowButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
            FollowButton.layer.cornerRadius = 20;
            [MainScroll addSubview: FollowButton];
            
            NSMutableArray *DemoArray = [[NSMutableArray alloc]init];
            [DemoArray addObject:@"DemoBackground.jpg"];
            [DemoArray addObject:@"UserDemo1.jpg"];
            [DemoArray addObject:@"UserDemo2.jpg"];
            [DemoArray addObject:@"UserDemo3.jpg"];
            
            for (int z = 0; z < [DemoArray count]; z++) {
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.frame = CGRectMake(15 +(z % 4) * SpaceWidth, heightcheck + 70, FinalWidth, FinalWidth);
                ShowImage.image = [UIImage imageNamed:[DemoArray objectAtIndex:z]];
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowImage.layer.cornerRadius=5;
                ShowImage.layer.masksToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];

                [MainScroll addSubview:ShowImage];
            }
            
            heightcheck += 70 + FinalWidth + 20;
        }else if([GetType isEqualToString:@"Promotion"]){
            
            UIImageView *BannerImage = [[UIImageView alloc]init];
            BannerImage.frame = CGRectMake(10, heightcheck, screenWidth - 20, 85);
            BannerImage.image = [UIImage imageNamed:@"Demoanner.jpg"];
            BannerImage.contentMode = UIViewContentModeScaleToFill;
            BannerImage.backgroundColor = [UIColor blackColor];
            BannerImage.layer.cornerRadius = 5;
            BannerImage.layer.masksToBounds = YES;
            [MainScroll addSubview:BannerImage];
            
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(10, heightcheck, screenWidth - 20, 85);
            [TempButton setTitle:@"" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor clearColor];
            TempButton.layer.cornerRadius = 5;
            [MainScroll addSubview: TempButton];
            
            heightcheck += 95;
        }
        
        
    }
        
    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 169 + 50)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Done" forKey:@"TestLocalData"];
    [defaults synchronize];
    
    [ShowActivity stopAnimating];
}
-(void)timerCalled
{
    NSLog(@"Timer Called");
    // Your Code
    [refreshControl endRefreshing];
    
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x - 20,
                                       0,
                                       refreshControl.bounds.size.width,
                                       refreshControl.bounds.size.height);
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [MainScroll addSubview:refreshControl];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for ( int i = 0; i < 10; i++) {
        UIButton *TempButton = [[UIButton alloc]init];
        TempButton.frame = CGRectMake(20, 0 + i * 100, screenWidth - 40, 90);
        [TempButton setTitle:@"" forState:UIControlStateNormal];
        TempButton.backgroundColor = [UIColor blackColor];
        [MainScroll addSubview: TempButton];
        
        [MainScroll setContentSize:CGSizeMake(screenWidth, 290 + i * 100)];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"First" forKey:@"TestLocalData"];
    [defaults synchronize];
}

-(IBAction)SearchButton:(id)sender{
    SearchViewV2Controller *SearchView = [[SearchViewV2Controller alloc]initWithNibName:@"SearchViewV2Controller" bundle:nil];
    //[self presentViewController:SearchView animated:YES completion:nil];
    [self.view.window.rootViewController presentViewController:SearchView animated:YES completion:nil];
}
-(IBAction)FiltersButton:(id)sender{
    NSLog(@"Open Filters Button Click");
    Filter2ViewController *FilterView = [[Filter2ViewController alloc]init];
    //[self presentViewController:FilterView animated:YES completion:nil];
    [self.view.window.rootViewController presentViewController:FilterView animated:YES completion:nil];
    [FilterView GetWhatViewComeHere:@"Feed"];
}
@end

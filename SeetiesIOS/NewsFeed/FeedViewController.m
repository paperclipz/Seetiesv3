//
//  FeedViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/14/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "FeedViewController.h"
#import "AsyncImageView.h"
#import "SearchViewV2Controller.h"
#import "Filter2ViewController.h"
@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    methodStart = [NSDate date];
    NSLog(@"methodStart is %@",methodStart);
    [self initData];
    [self initSelfView];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MainScroll.frame = CGRectMake(0, 44, screenWidth, screenHeight);
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
    
    ShowUpdateText.frame = CGRectMake(0, 44, screenWidth, 20);
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
//    if ([CheckString isEqualToString:@"Done"]) {
//        [refreshControl beginRefreshing];
//        [self LoadDataView];
//    }else{
//        [ShowActivity startAnimating];
//        [self LoadInitView];
//    }
    
    [ShowActivity startAnimating];
    [self LoadInitView];
    
}

-(void)initData
{
    arrAddress = [[NSMutableArray alloc]init];
    [arrAddress addObject:@"Love Hotel, Tapipei City, Taiwan"];
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
    [arrMessage addObject:@""];
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
    [arrType addObject:@"LocalQR"];
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
    [arrImage addObject:@"https://unsplash.it/375/400/?random"];
    [arrImage addObject:@"https://unsplash.it/375/400/?random"];
    [arrImage addObject:@"https://unsplash.it/375/700/?random"];
    [arrImage addObject:@"https://unsplash.it/375/500/?random"];
    [arrImage addObject:@"https://unsplash.it/375/200/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/450/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/375/?random"];
    [arrImage addObject:@"https://unsplash.it/375/600/?random"];
   // TestCheck = 0;
   // TotalCount = 3;

}
- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)testRefresh{
    
    NSLog(@"testRefresh");
    
    [refreshControl endRefreshing];
}
-(void)LoadDataView{

    NSLog(@"Load Local Data");
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    
//    for ( int i = 0; i < 10; i++) {
//        UIButton *TempButton = [[UIButton alloc]init];
//        TempButton.frame = CGRectMake(20, 0 + i * 100, screenWidth - 40, 90);
//        [TempButton setTitle:@"" forState:UIControlStateNormal];
//        TempButton.backgroundColor = [UIColor purpleColor];
//        [MainScroll addSubview: TempButton];
//        
//        [MainScroll setContentSize:CGSizeMake(screenWidth, 290 + i * 100)];
//    }
    

    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                      ShowUpdateText.frame = CGRectMake(0, 64, screenWidth, 20);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
    
    UIButton *TempBackground = [[UIButton alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, 120);
    TempBackground.backgroundColor = [UIColor grayColor];
    [MainScroll addSubview:TempBackground];
    
    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake(10, 0, screenWidth - 20, 70);
    [TempButton setTitle:@"" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor whiteColor];
    TempButton.layer.cornerRadius = 5;
    [MainScroll addSubview: TempButton];
    
//    UILabel *ShowExplore = [[UILabel alloc]init];
//    ShowExplore.frame = CGRectMake(80, 15, screenWidth - 100, 20);
//    ShowExplore.text = @"Explore nearby";
//    ShowExplore.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
//    ShowExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:18];
//    [MainScroll addSubview:ShowExplore];
//    
//    UILabel *ShowSubExplore = [[UILabel alloc]init];
//    ShowSubExplore.frame = CGRectMake(80, 35, screenWidth - 100, 20);
//    ShowSubExplore.text = @"There is always excitement around you.";
//    ShowSubExplore.textColor = [UIColor lightGrayColor];
//    ShowSubExplore.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
//    [MainScroll addSubview:ShowSubExplore];
    
    heightcheck += 130;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalImg"]];
    NSLog(@"TempArray is %@",TempArray);

    for ( int i = 0 ; i < 9; i++) {
        
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
            UIImage *image_;
            UIImage *newImage;
            
            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
            stringPath  = [stringPath stringByAppendingPathComponent:[TempArray objectAtIndex:i]];
            NSLog(@"stringpath %@",stringPath);
            
            
            image_ = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath]];
            //image_ = [UIImage imageNamed:FullImagesURL_First];
            float oldWidth = image_.size.width;
            float scaleFactor = screenWidth / oldWidth;
            
            float newHeight = image_.size.height * scaleFactor;
            float newWidth = oldWidth * scaleFactor;
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [image_ drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            ShowImage.image = newImage;
            
            // NSLog(@"Count timer");
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
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
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
            [TempArray addObject:@""];
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
            [TempArray addObject:@""];
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
    
    
    
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(timerCalled)
                                   userInfo:nil
                                    repeats:NO];
    // [refreshControl endRefreshing];
}
-(void)LoadInitView{
    [NSTimer scheduledTimerWithTimeInterval:0.0
                                     target:self
                                   selector:@selector(StartInit1stView)
                                   userInfo:nil
                                    repeats:NO];
    
 //   [self StartInit1stView];
}
-(void)StartInit1stView{
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *TempBackground = [[UIButton alloc]init];
    TempBackground.frame = CGRectMake(0, 0, screenWidth, 120);
    TempBackground.backgroundColor = [UIColor grayColor];
    [MainScroll addSubview:TempBackground];
    
    UIButton *TempButton = [[UIButton alloc]init];
    TempButton.frame = CGRectMake((screenWidth / 2) - 75, 30, 150, 60);
    [TempButton setTitle:@"Nearby" forState:UIControlStateNormal];
    TempButton.backgroundColor = [UIColor greenColor];
    TempButton.layer.cornerRadius = 20;
    [MainScroll addSubview: TempButton];
    
    
    heightcheck += 130;
    
    [self InitContent];
    

    
    [ShowActivity stopAnimating];
}
-(void)InitContent{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSMutableArray *TempArray = [[NSMutableArray alloc]init];
    for ( int i = 0 ; i < 9; i++) {
        
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
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                image_ = [UIImage imageWithData:data];
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
            
           // NSLog(@"Count timer");
            
//            NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
//            NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"FeedLocalimage_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
//            [imageData writeToFile:imagePath atomically:YES];
            
            
            
            NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
            // Content_ Folder is your folder name
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
            //This will create a new folder if content folder is not exist
            NSString *fileName = [stringPath stringByAppendingFormat:@"/FeedLocalimage_%i.jpg",i];
            [imageData writeToFile:fileName atomically:YES];
            
            NSString *SaveFileName = [[NSString alloc]initWithFormat:@"FeedLocalimage_%i.jpg",i];
            
            
            [TempArray addObject:SaveFileName];
            
            
            
            
            
            
            
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
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
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
            
            [TempArray addObject:@""];
            int TestWidth = screenWidth - 40;
            //    NSLog(@"TestWidth is %i",TestWidth);
            int FinalWidth = TestWidth / 4;
            //    NSLog(@"FinalWidth is %i",FinalWidth);
            int SpaceWidth = FinalWidth + 4;
            
            SUserScrollview = [[UIScrollView alloc]init];
            SUserScrollview.delegate = self;
            SUserScrollview.frame = CGRectMake(0, heightcheck, screenWidth, FinalWidth + 10 + 70 + 50 + 30);
            SUserScrollview.backgroundColor = [UIColor whiteColor];
            SUserScrollview.pagingEnabled = YES;
            [SUserScrollview setShowsHorizontalScrollIndicator:NO];
            [SUserScrollview setShowsVerticalScrollIndicator:NO];
            [MainScroll addSubview:SUserScrollview];
            
            UILabel *ShowSuggestedText = [[UILabel alloc]init];
            ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
            ShowSuggestedText.text = @"Your friends are on Seeties";
            ShowSuggestedText.backgroundColor = [UIColor clearColor];
            ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
            ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
            ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowSuggestedText];
            
            ShowSUserCount = [[UILabel alloc]init];
            ShowSUserCount.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
            ShowSUserCount.text = @"1/3";
            ShowSUserCount.backgroundColor = [UIColor clearColor];
            ShowSUserCount.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
            ShowSUserCount.textAlignment = NSTextAlignmentRight;
            ShowSUserCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowSUserCount];
            
            
            SUserpageControl = [[UIPageControl alloc] init];
            SUserpageControl.frame = CGRectMake(0,heightcheck + FinalWidth + 10 + 70 + 50,screenWidth,30);
            SUserpageControl.numberOfPages = 3;
            SUserpageControl.currentPage = 0;
            SUserpageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
            SUserpageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
            [MainScroll addSubview:SUserpageControl];
            
            
            for (int i = 0; i < 3; i++) {
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10 + i * screenWidth, 50, screenWidth - 20, FinalWidth + 10 + 70);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                TempButton.layer.borderWidth=1;
                TempButton.layer.masksToBounds = YES;
                TempButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                [SUserScrollview addSubview: TempButton];
                
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(20 + i * screenWidth, 60, 40, 40);
                ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=3;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                [SUserScrollview addSubview:ShowUserProfileImage];
                
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(70 + i * screenWidth, 50 + 10, 200, 20);
                ShowUserName.text = @"lucydiamond";
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [SUserScrollview addSubview:ShowUserName];
                
                UILabel *ShowMessage = [[UILabel alloc]init];
                ShowMessage.frame = CGRectMake(70 + i * screenWidth, 50 + 30, 200, 20);
                ShowMessage.text = @"Based on your interest";
                ShowMessage.backgroundColor = [UIColor clearColor];
                ShowMessage.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
                ShowMessage.textAlignment = NSTextAlignmentLeft;
                ShowMessage.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                [SUserScrollview addSubview:ShowMessage];
                
                UIButton *FollowButton = [[UIButton alloc]init];
                FollowButton.frame = CGRectMake(screenWidth - 20 - 100 + i * screenWidth, 60, 100, 40);
                [FollowButton setTitle:@"Follow" forState:UIControlStateNormal];
                FollowButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:152.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
                FollowButton.layer.cornerRadius = 20;
                [SUserScrollview addSubview: FollowButton];
                
                NSMutableArray *DemoArray = [[NSMutableArray alloc]init];
                [DemoArray addObject:@"DemoBackground.jpg"];
                [DemoArray addObject:@"UserDemo1.jpg"];
                [DemoArray addObject:@"UserDemo2.jpg"];
                [DemoArray addObject:@"UserDemo3.jpg"];
                
                for (int z = 0; z < [DemoArray count]; z++) {
                    AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                    ShowImage.frame = CGRectMake(15 + i * screenWidth +(z % 4) * SpaceWidth, 50 + 70, FinalWidth, FinalWidth);
                    ShowImage.image = [UIImage imageNamed:[DemoArray objectAtIndex:z]];
                    ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                    ShowImage.layer.cornerRadius=5;
                    ShowImage.layer.masksToBounds = YES;
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                    
                    [SUserScrollview addSubview:ShowImage];
                }
                
                
                
                SUserScrollview.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 100);
            }

            

            

            

            
            heightcheck += FinalWidth + 10 + 70 + 50 + 30 + 10;
            
        }else if([GetType isEqualToString:@"Promotion"]){
            [TempArray addObject:@""];
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
        }else if([GetType isEqualToString:@"LocalQR"]){
        
            SuggestedScrollview = [[UIScrollView alloc]init];
            SuggestedScrollview.delegate = self;
            SuggestedScrollview.frame = CGRectMake(0, heightcheck, screenWidth, 420);
            SuggestedScrollview.backgroundColor = [UIColor whiteColor];
            SuggestedScrollview.pagingEnabled = YES;
            [SuggestedScrollview setShowsHorizontalScrollIndicator:NO];
            [SuggestedScrollview setShowsVerticalScrollIndicator:NO];
            [MainScroll addSubview:SuggestedScrollview];
            
            UILabel *ShowSuggestedText = [[UILabel alloc]init];
            ShowSuggestedText.frame = CGRectMake(20, heightcheck, 200, 50);
            ShowSuggestedText.text = @"Suggested Local QR";
            ShowSuggestedText.backgroundColor = [UIColor clearColor];
            ShowSuggestedText.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
            ShowSuggestedText.textAlignment = NSTextAlignmentLeft;
            ShowSuggestedText.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowSuggestedText];
            
            ShowSuggestedCount = [[UILabel alloc]init];
            ShowSuggestedCount.frame = CGRectMake(screenWidth - 220, heightcheck, 200, 50);
            ShowSuggestedCount.text = @"1/3";
            ShowSuggestedCount.backgroundColor = [UIColor clearColor];
            ShowSuggestedCount.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
            ShowSuggestedCount.textAlignment = NSTextAlignmentRight;
            ShowSuggestedCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowSuggestedCount];
            
            SuggestedpageControl = [[UIPageControl alloc] init];
            SuggestedpageControl.frame = CGRectMake(0,heightcheck + 390,screenWidth,30);
            SuggestedpageControl.numberOfPages = 3;
            SuggestedpageControl.currentPage = 0;
            SuggestedpageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
            SuggestedpageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
            [MainScroll addSubview:SuggestedpageControl];
           // pageControl.backgroundColor = [UIColor redColor];
            
            
            for (int i = 0; i < 3; i++) {
                UIButton *TempButton = [[UIButton alloc]init];
                TempButton.frame = CGRectMake(10 + i * screenWidth, 50 , screenWidth - 20 ,320);
                [TempButton setTitle:@"" forState:UIControlStateNormal];
                TempButton.backgroundColor = [UIColor whiteColor];
                TempButton.layer.cornerRadius = 5;
                TempButton.layer.borderWidth=1;
                TempButton.layer.masksToBounds = YES;
                TempButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
                [SuggestedScrollview addSubview: TempButton];
                
                AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
                ShowImage.frame = CGRectMake(11 + i * screenWidth, 51 , screenWidth - 22 ,198);
                ShowImage.image = [UIImage imageNamed:@"UserDemo2.jpg"];
                ShowImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowImage.layer.cornerRadius=5;
                ShowImage.layer.masksToBounds = YES;
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
                [SuggestedScrollview addSubview:ShowImage];
                
                
                
                AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
                ShowUserProfileImage.frame = CGRectMake(31 + i * screenWidth, 51 + 10, 40, 40);
                ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
                ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
                ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
                ShowUserProfileImage.layer.cornerRadius=20;
                ShowUserProfileImage.layer.borderWidth=3;
                ShowUserProfileImage.layer.masksToBounds = YES;
                ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
                [SuggestedScrollview addSubview:ShowUserProfileImage];
                
                UILabel *ShowUserName = [[UILabel alloc]init];
                ShowUserName.frame = CGRectMake(81 + i * screenWidth, 51 + 10, 200, 40);
                ShowUserName.text = @"ahyongah";
                ShowUserName.backgroundColor = [UIColor clearColor];
                ShowUserName.textColor = [UIColor whiteColor];
                ShowUserName.textAlignment = NSTextAlignmentLeft;
                ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                [SuggestedScrollview addSubview:ShowUserName];
                
                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 125 + i * screenWidth, 51 + 10, 100, 40);
                // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                ShowDistance.text = @"Melaka";
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [SuggestedScrollview addSubview:ShowDistance];
                
                //  int TempCountWhiteHeight = 51 + 198 + 10;
                
                NSString *TempGetStirng = [[NSString alloc]initWithFormat:@"A Good Homestay in Jonker Street Melaka A Good Homestay in Jonker Stre"];
                if ([TempGetStirng length] == 0 || [TempGetStirng isEqualToString:@""] || [TempGetStirng isEqualToString:@"(null)"]) {
                    
                }else{
                    UILabel *ShowTitle = [[UILabel alloc]init];
                    ShowTitle.frame = CGRectMake(25 + i * screenWidth, 51 + 198 + 10, screenWidth - 50, 40);
                    ShowTitle.text = TempGetStirng;
                    ShowTitle.backgroundColor = [UIColor clearColor];
                    ShowTitle.numberOfLines = 2;
                    ShowTitle.textAlignment = NSTextAlignmentLeft;
                    ShowTitle.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    ShowTitle.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                    [SuggestedScrollview addSubview:ShowTitle];
                }
                
                
                
                
                SuggestedScrollview.contentSize = CGSizeMake(10 + i * screenWidth + screenWidth, 300);
            }
            
            
            
            heightcheck += 430;
            
            
            
        }
        
        
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:TempArray forKey:@"FeedLocalImg"];// image data
    [defaults setObject:@"Done" forKey:@"TestLocalData"];
    [defaults synchronize];
    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 169 + 50)];
//    if (TestCheck == 0) {
//        TestCheck += 3;
//    }else{
//        TestCheck += 1;
//    }
//    
//    TotalCount += 1;
//    
//    if (TotalCount == 10) {
//        
//    }else{
//      NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
//                                         target:self
//                                       selector:@selector(InitContent)
//                                       userInfo:nil
//                                        repeats:NO];
//        
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
////        double delayInSeconds = 1.0;
////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
////        
////        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
////            // Your code here
////            [self InitContent];
////        });
//    }
    
    

    
    
    
    
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"executionTime = %f", executionTime);
    
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == SuggestedScrollview) {
        CGFloat pageWidth = SuggestedScrollview.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SuggestedScrollview.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SuggestedpageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/3",page + 1];
        ShowSuggestedCount.text = TempCount;
    }else{
        CGFloat pageWidth = SUserScrollview.frame.size.width; // you need to have a **iVar** with getter for scrollView
        float fractionalPage = SUserScrollview.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        SUserpageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
        
        NSString *TempCount = [[NSString alloc]initWithFormat:@"%li/3",page + 1];
        ShowSUserCount.text = TempCount;
    }
    

}



-(void)timerCalled
{
    NSLog(@"Timer Called");
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    // Your Code
    [refreshControl endRefreshing];
    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         ShowUpdateText.frame = CGRectMake(0, 20, screenWidth, 20);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
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
    
    heightcheck = 0;
    [ShowActivity startAnimating];
    [self LoadInitView];
    
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    for ( int i = 0; i < 10; i++) {
//        UIButton *TempButton = [[UIButton alloc]init];
//        TempButton.frame = CGRectMake(20, 0 + i * 100, screenWidth - 40, 90);
//        [TempButton setTitle:@"" forState:UIControlStateNormal];
//        TempButton.backgroundColor = [UIColor blackColor];
//        [MainScroll addSubview: TempButton];
//        
//        [MainScroll setContentSize:CGSizeMake(screenWidth, 290 + i * 100)];
//    }
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"First" forKey:@"TestLocalData"];
//    [defaults synchronize];
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

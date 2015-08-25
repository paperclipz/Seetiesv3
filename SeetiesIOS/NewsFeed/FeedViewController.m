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
#import "InviteFrenViewController.h"
@interface FeedViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation FeedViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];

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
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {
        ShowUpdateText.frame = CGRectMake(0, 64, screenWidth, 20);
        [refreshControl beginRefreshing];
        [self LoadDataView];
    }else{
        [ShowActivity startAnimating];
    }
    
    
    //[self LoadInitView];

    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager startUpdatingLocation];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
                [self.locationManager startUpdatingLocation];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
        
        NSLog(@"got location get feed data");

        [self GetExternalIPAddress];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
        if ([CheckString isEqualToString:@"Done"]) {
        }else{
            [self GetFeedDataFromServer];
        }
        
    }else{
        
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
    }
    NSLog(@"no location get feed data");
    [manager stopUpdatingLocation];

    [self GetExternalIPAddress];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {
    }else{
        [self GetFeedDataFromServer];
    }
    
}
-(void)initData
{


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckString = [defaults objectForKey:@"TestLocalData"];
    if ([CheckString isEqualToString:@"Done"]) {

        // put data here
        NSMutableArray *arrImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalImg"]];
        arrImage = [[NSMutableArray alloc]initWithArray:arrImageTemp];
        NSMutableArray *arrAddressTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrAddress"]];
        arrAddress = [[NSMutableArray alloc]initWithArray:arrAddressTemp];
        NSMutableArray *arrTitleTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrTitle"]];
        arrTitle = [[NSMutableArray alloc]initWithArray:arrTitleTemp];
        NSMutableArray *arrMessageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrMessage"]];
        arrMessage = [[NSMutableArray alloc]initWithArray:arrMessageTemp];
        NSMutableArray *arrTypeTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrType"]];
        arrType = [[NSMutableArray alloc]initWithArray:arrTypeTemp];
        NSMutableArray *arrDistanceTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDistance"]];
        arrDistance = [[NSMutableArray alloc]initWithArray:arrDistanceTemp];
        NSMutableArray *arrUserNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserName"]];
        arrUserName = [[NSMutableArray alloc]initWithArray:arrUserNameTemp];
        NSMutableArray *arrUserImageTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrUserImage"]];
        arrUserImage = [[NSMutableArray alloc]initWithArray:arrUserImageTemp];
        NSMutableArray *arrDisplayCountryNameTemp = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"FeedLocalarrDisplayCountryName"]];
        arrDisplayCountryName = [[NSMutableArray alloc]initWithArray:arrDisplayCountryNameTemp];
    }else{
        arrAddress = [[NSMutableArray alloc]init];
        arrTitle = [[NSMutableArray alloc]init];
        arrMessage = [[NSMutableArray alloc]init];
        arrType = [[NSMutableArray alloc]init];
        arrImage = [[NSMutableArray alloc]init];//https://unsplash.it/375/400/?random
        arrDistance = [[NSMutableArray alloc]init];
        arrUserName = [[NSMutableArray alloc]init];
        arrUserImage = [[NSMutableArray alloc]init];
        arrDisplayCountryName = [[NSMutableArray alloc]init];
    }

    TotalPage = 1;
    CurrentPage = 0;
    DataCount = 0;
    DataTotal = 0;
    CheckFirstTimeLoad = 0;
    OnLoad = NO;

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
    
    for (NSInteger i = 0; i < [arrImage count]; i++) {
        
        NSString *GetType = [arrType objectAtIndex:i];
        
        if ([GetType isEqualToString:@"following"]) {
            NSInteger TempHeight = heightcheck + i;
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
            NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
            stringPath  = [stringPath stringByAppendingPathComponent:[arrImage objectAtIndex:i]];
            //NSLog(@"stringpath %@",stringPath);
            UIImage *image_;
            UIImage *newImage;
            image_ = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath]];
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
            // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=3;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *stringPath1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
            stringPath1  = [stringPath1 stringByAppendingPathComponent:[arrUserImage objectAtIndex:i]];
            ShowUserProfileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath1]];
            [MainScroll addSubview:ShowUserProfileImage];
        
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(70, heightcheck + i + 10, 200, 40);
            ShowUserName.text = [arrUserName objectAtIndex:i];
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor whiteColor];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowUserName];
            
            NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
            
            if ([TempDistanceString isEqualToString:@"0"]) {
                
            }else{
                CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                int x_Nearby = [TempDistanceString intValue] / 1000;
                // NSLog(@"x_Nearby is %i",x_Nearby);
                
                NSString *FullShowLocatinString;
                if (x_Nearby < 100) {
                    if (x_Nearby <= 1) {
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else{
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                    }
                    
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];
                    
                }
                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 135, heightcheck + i + 10, 100, 40);
                // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                ShowDistance.text = FullShowLocatinString;
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [MainScroll addSubview:ShowDistance];
            }
            
            
            
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
            ShowCommentIcon.frame = CGRectMake(100, heightcheck + i + 20 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            UIImageView *ShowShareIcon = [[UIImageView alloc]init];
            ShowShareIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowShareIcon.frame = CGRectMake(160, heightcheck + i + 20 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowShareIcon];
            
            
            UIButton *CollectButton = [[UIButton alloc]init];
            [CollectButton setTitle:@"Collect" forState:UIControlStateNormal];
            [CollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [CollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
            CollectButton.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:221.0f/255.0f blue:96.0f/255.0f alpha:1.0f];
            CollectButton.frame = CGRectMake(screenWidth - 20 - 120, heightcheck + i + 10, 120, 40);
            CollectButton.layer.cornerRadius = 20;
            CollectButton.layer.borderWidth= 1;
            CollectButton.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
            [MainScroll addSubview:CollectButton];
            
            
            heightcheck += 70;
            TempCountWhiteHeight += 70;
            
            
            TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
            
            heightcheck += 10;
            
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

-(void)StartInit1stView{
//    heightcheck = 0;
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
    
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
    NSMutableArray *TempArray_FeedImage = [[NSMutableArray alloc]init];
    NSMutableArray *TempArray_FeedUserImage = [[NSMutableArray alloc]init];
    for (NSInteger i = DataCount; i < DataTotal; i++) {
        
        NSString *GetType = [arrType objectAtIndex:i];
        
        if ([GetType isEqualToString:@"following"]) {
            NSInteger TempHeight = heightcheck + i;
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
            NSString *TempImage = [[NSString alloc]initWithFormat:@"%@",[arrImage objectAtIndex:i]];
            NSArray *SplitArray = [TempImage componentsSeparatedByString:@","];
            NSString *FullImagesURL_First = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:0]];
            UIImage *image_;
            UIImage *newImage;
            if ([FullImagesURL_First length] == 0) {
                image_ = [UIImage imageNamed:@"NoImage.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL_First];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                image_ = [UIImage imageWithData:data];
            }
            float oldWidth = image_.size.width;
            float scaleFactor = screenWidth / oldWidth;
            
            float newHeight = image_.size.height * scaleFactor;
            float newWidth = oldWidth * scaleFactor;
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [image_ drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            ShowImage.image = newImage;
            
            if (CheckFirstTimeLoad == 0) {
                NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                // Content_ Folder is your folder name
                NSError *error = nil;
                if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
                //This will create a new folder if content folder is not exist
                NSString *fileName = [stringPath stringByAppendingFormat:@"/FeedLocalimage_%li.jpg",(long)i];
                [imageData writeToFile:fileName atomically:YES];
                NSString *SaveFileName = [[NSString alloc]initWithFormat:@"FeedLocalimage_%li.jpg",(long)i];
                [TempArray_FeedImage addObject:SaveFileName];
            }else{
            }
            

            
            
            
            ShowImage.frame = CGRectMake(10, heightcheck + i, screenWidth - 20, newImage.size.height);
            // ShowImage.frame = CGRectMake(0, heightcheck + i, screenWidth, 200);
            [MainScroll addSubview:ShowImage];
            
            AsyncImageView *ShowUserProfileImage = [[AsyncImageView alloc]init];
            ShowUserProfileImage.frame = CGRectMake(20, heightcheck + i + 10, 40, 40);
           // ShowUserProfileImage.image = [UIImage imageNamed:@"DemoProfile.jpg"];
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=20;
            ShowUserProfileImage.layer.borderWidth=3;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *FullImagesURL = [[NSString alloc]initWithFormat:@"%@",[arrUserImage objectAtIndex:i]];
            UIImage *UserImage;
            if ([FullImagesURL length] == 0) {
                ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
                UserImage = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_NearbySmall = [NSURL URLWithString:FullImagesURL];
                NSData *data = [NSData dataWithContentsOfURL:url_NearbySmall];
                UserImage = [UIImage imageWithData:data];
                //ShowUserProfileImage.imageURL = url_NearbySmall;
            }
            ShowUserProfileImage.image = UserImage;
            [MainScroll addSubview:ShowUserProfileImage];
            
            if (CheckFirstTimeLoad == 0) {
                NSData *imageData = UIImageJPEGRepresentation(UserImage, 1);
                NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Content_Folder"];
                // Content_ Folder is your folder name
                NSError *error = nil;
                if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:stringPath  withIntermediateDirectories:NO attributes:nil error:&error];
                //This will create a new folder if content folder is not exist
                NSString *fileName = [stringPath stringByAppendingFormat:@"/FeedLocalUserImg_%li.jpg",(long)i];
                [imageData writeToFile:fileName atomically:YES];
                NSString *SaveFileName = [[NSString alloc]initWithFormat:@"FeedLocalUserImg_%li.jpg",(long)i];
                [TempArray_FeedUserImage addObject:SaveFileName];
            }else{
            }
            
            UILabel *ShowUserName = [[UILabel alloc]init];
            ShowUserName.frame = CGRectMake(70, heightcheck + i + 10, 200, 40);
            ShowUserName.text = [arrUserName objectAtIndex:i];
            ShowUserName.backgroundColor = [UIColor clearColor];
            ShowUserName.textColor = [UIColor whiteColor];
            ShowUserName.textAlignment = NSTextAlignmentLeft;
            ShowUserName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
            [MainScroll addSubview:ShowUserName];
            
            NSString *TempDistanceString = [[NSString alloc]initWithFormat:@"%@",[arrDistance objectAtIndex:i]];
            
            if ([TempDistanceString isEqualToString:@"0"]) {
                
            }else{
                CGFloat strFloat = (CGFloat)[TempDistanceString floatValue] / 1000;
                int x_Nearby = [TempDistanceString intValue] / 1000;
                // NSLog(@"x_Nearby is %i",x_Nearby);
                
                NSString *FullShowLocatinString;
                if (x_Nearby < 100) {
                    if (x_Nearby <= 1) {
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"1km"];//within
                    }else{
                        FullShowLocatinString = [[NSString alloc]initWithFormat:@"%.fkm",strFloat];
                    }
                    
                }else{
                    FullShowLocatinString = [[NSString alloc]initWithFormat:@"%@",[arrDisplayCountryName objectAtIndex:i]];

                }
                UILabel *ShowDistance = [[UILabel alloc]init];
                ShowDistance.frame = CGRectMake(screenWidth - 135, heightcheck + i + 10, 100, 40);
                // ShowDistance.frame = CGRectMake(screenWidth - 115, 210 + heightcheck + i, 100, 20);
                ShowDistance.text = FullShowLocatinString;
                ShowDistance.textColor = [UIColor whiteColor];
                ShowDistance.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
                ShowDistance.textAlignment = NSTextAlignmentRight;
                ShowDistance.backgroundColor = [UIColor clearColor];
                [MainScroll addSubview:ShowDistance];
            }
            

            
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
            ShowCommentIcon.frame = CGRectMake(100, heightcheck + i + 20 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowCommentIcon];
            
            UIImageView *ShowShareIcon = [[UIImageView alloc]init];
            ShowShareIcon.image = [UIImage imageNamed:@"PostComment.png"];
            ShowShareIcon.frame = CGRectMake(160, heightcheck + i + 20 ,23, 19);
            //    ShowCommentIcon.backgroundColor = [UIColor redColor];
            [MainScroll addSubview:ShowShareIcon];
            
            
            UIButton *CollectButton = [[UIButton alloc]init];
            [CollectButton setTitle:@"Collect" forState:UIControlStateNormal];
            [CollectButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [CollectButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
            CollectButton.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:221.0f/255.0f blue:96.0f/255.0f alpha:1.0f];
            CollectButton.frame = CGRectMake(screenWidth - 20 - 120, heightcheck + i + 10, 120, 40);
            CollectButton.layer.cornerRadius = 20;
            CollectButton.layer.borderWidth= 1;
            CollectButton.layer.borderColor=[[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] CGColor];
            [MainScroll addSubview:CollectButton];
            
            
            heightcheck += 70;
            TempCountWhiteHeight += 70;
            
            
            TempButton.frame = CGRectMake(10, TempHeight, screenWidth - 20, TempCountWhiteHeight);
            
            heightcheck += 10;
            
        }else if([GetType isEqualToString:@"User"]){
            [TempArray_FeedImage addObject:@""];
            [TempArray_FeedUserImage addObject:@""];
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
            [TempArray_FeedImage addObject:@""];
            [TempArray_FeedUserImage addObject:@""];
            UIImageView *BannerImage = [[UIImageView alloc]init];
            BannerImage.frame = CGRectMake(0, heightcheck, screenWidth, 180);
            BannerImage.image = [UIImage imageNamed:@"Demoanner.jpg"];
            BannerImage.contentMode = UIViewContentModeScaleToFill;
            BannerImage.backgroundColor = [UIColor blackColor];
            BannerImage.layer.cornerRadius = 5;
            BannerImage.layer.masksToBounds = YES;
            [MainScroll addSubview:BannerImage];
            
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(0, heightcheck, screenWidth, 180);
            [TempButton setTitle:@"Vouchers Type" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor yellowColor];
           // TempButton.layer.cornerRadius = 5;
            [MainScroll addSubview: TempButton];
            
            heightcheck += 190;
        }else if([GetType isEqualToString:@"LocalQR"]){
            [TempArray_FeedImage addObject:@""];
            [TempArray_FeedUserImage addObject:@""];
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
            
            
            
        }else if([GetType isEqualToString:@"InviteFriends"]){
        
            [TempArray_FeedImage addObject:@""];
            [TempArray_FeedUserImage addObject:@""];
            UIImageView *BannerImage = [[UIImageView alloc]init];
            BannerImage.frame = CGRectMake(0, heightcheck, screenWidth, 150);
            BannerImage.image = [UIImage imageNamed:@"Demoanner.jpg"];
            BannerImage.contentMode = UIViewContentModeScaleToFill;
            BannerImage.backgroundColor = [UIColor blackColor];
            BannerImage.layer.cornerRadius = 5;
            BannerImage.layer.masksToBounds = YES;
            [MainScroll addSubview:BannerImage];
            
            UIButton *TempButton = [[UIButton alloc]init];
            TempButton.frame = CGRectMake(0, heightcheck, screenWidth, 150);
            [TempButton setTitle:@"Invite Friends" forState:UIControlStateNormal];
            TempButton.backgroundColor = [UIColor blueColor];
            [TempButton addTarget:self action:@selector(OpenInviteButton:) forControlEvents:UIControlEventTouchUpInside];
            [MainScroll addSubview: TempButton];
            
            heightcheck += 160;
            
            
            
            
            
            
        }
        
        
    }
    
    

    if (CheckFirstTimeLoad == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:TempArray_FeedImage forKey:@"FeedLocalImg"];// image data
        [defaults setObject:arrAddress forKey:@"FeedLocalarrAddress"];
        [defaults setObject:arrTitle forKey:@"FeedLocalarrTitle"];
        [defaults setObject:arrMessage forKey:@"FeedLocalarrMessage"];
        [defaults setObject:arrType forKey:@"FeedLocalarrType"];
        [defaults setObject:arrDistance forKey:@"FeedLocalarrDistance"];
        [defaults setObject:arrUserName forKey:@"FeedLocalarrUserName"];
        [defaults setObject:TempArray_FeedUserImage forKey:@"FeedLocalarrUserImage"];
        [defaults setObject:arrDisplayCountryName forKey:@"FeedLocalarrDisplayCountryName"];
        [defaults setObject:@"Done" forKey:@"TestLocalData"];
        [defaults synchronize];
    }else{
    }
    [MainScroll setContentSize:CGSizeMake(screenWidth, heightcheck + 169 + 50)];
    
    
    
    
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

-(IBAction)OpenInviteButton:(id)sender{
    InviteFrenViewController *InviteFrenView = [[InviteFrenViewController alloc]init];
    [self presentViewController:InviteFrenView animated:YES completion:nil];
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
                         ShowUpdateText.frame = CGRectMake(0, 0, screenWidth, 20);
                     }
                     completion:^(BOOL finished) {
                         ShowUpdateText.hidden = YES;
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
    
    [arrImage removeAllObjects];
    [arrDisplayCountryName removeAllObjects];
    [arrDistance removeAllObjects];
    [arrMessage removeAllObjects];
    [arrTitle removeAllObjects];
    [arrType removeAllObjects];
    [arrImage removeAllObjects];
    [arrUserImage removeAllObjects];
    [arrUserName removeAllObjects];
    
    [self GetFeedDataFromServer];

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
-(void)GetExternalIPAddress{
    NSURL *iPURL = [NSURL URLWithString:@"https://geoip.seeties.me/geoip/index.php"];
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSData *jsonData = [theIpHtml dataUsingEncoding:NSUTF8StringEncoding];
            NSError *myError = nil;
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
            // NSLog(@"Feed Json = %@",res);
            ExternalIPAddress = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"ip"]];
            NSLog(@"ExternalIPAddress : %@",ExternalIPAddress);
            
        } else {
            ExternalIPAddress = @"";
            
            NSLog(@"Oops... g %ld, %@",
                  (long)[error code],
                  [error localizedDescription]);
        }
    }
}
-(void)GetFeedDataFromServer{
    OnLoad = YES;
    methodStart = [NSDate date];
    NSLog(@"methodStart is %@",methodStart);
    // [ShowActivity startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *GetSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
    NSString *GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
    
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        
        if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] || [ExternalIPAddress isEqualToString:@"(null)"]) {
            ExternalIPAddress = @"";
        }else{
            
        }
        
        
        NSString *FullString;
        if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&ip_address=%@&list_size=9&&page=%li",DataUrl.Feed_Url,GetExpertToken,ExternalIPAddress,CurrentPage];
        }else{//ip_address=119.92.244.146
            FullString = [[NSString alloc]initWithFormat:@"%@?token=%@&follow_suggestions=1&lat=%@&lng=%@&ip_address=%@&list_size=9&&page=%li",DataUrl.Feed_Url,GetExpertToken,latPoint,lonPoint,ExternalIPAddress,CurrentPage];
        }
        
        if ([GetSortByString length] == 0 || [GetSortByString isEqualToString:@""] || [GetSortByString isEqualToString:@"(null)"] || GetSortByString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&sort=%@", FullString, GetSortByString];
        }
        if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
            
        }else{
            FullString = [NSString stringWithFormat:@"%@&categories=%@", FullString, GetCategoryString];
        }
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"MainView check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_All start];
        
        
        if( theConnection_All ){
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [ShowActivity stopAnimating];

}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_All) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"Feed GetData is %@",GetData);
        
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
                
                NSString *Temppage = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"page"]];
                NSString *Temptotal_page = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"total_page"]];
                
                CurrentPage = [Temppage intValue];
                TotalPage = [Temptotal_page intValue];
                
                NSLog(@"CurrentPage is %li",(long)CurrentPage);
                NSLog(@"TotalPage is %li",(long)TotalPage);
                
                 NSArray *PostsData = [GetAllData valueForKey:@"posts"];
                 for (NSDictionary * dict in PostsData) {
                     NSString *posttype = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"post_type"]];
                     [arrType addObject:posttype];
                     NSString *PlaceName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                     [arrAddress addObject:PlaceName];
                 }
                
                
                
                NSDictionary *titleData = [PostsData valueForKey:@"title"];
                for (NSDictionary * dict in titleData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                        [arrTitle addObject:@""];
                    }else{
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                        NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                        NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                    if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                        if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                            [arrTitle addObject:@""];
                                        }else{
                                            [arrTitle addObject:PhilippinesTitle];
                                            
                                        }
                                    }else{
                                        [arrTitle addObject:IndonesianTitle];
                                        
                                    }
                                }else{
                                    [arrTitle addObject:ThaiTitle];
                                }
                            }else{
                                [arrTitle addObject:Title2];
                            }
                            
                        }else{
                            [arrTitle addObject:Title1];
                            
                        }
                        
                    }
                }
                
                    NSDictionary *messageData = [PostsData valueForKey:@"message"];
                    for (NSDictionary * dict in messageData) {
                        if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                            [arrMessage addObject:@""];
                        }else{
                            NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                            NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                            NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                            NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                            NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                            if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                                if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                                    if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                        if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                            if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                                [arrMessage addObject:@""];
                                            }else{
                                                [arrMessage addObject:PhilippinesTitle];
                                                
                                            }
                                        }else{
                                            [arrMessage addObject:IndonesianTitle];
                                            
                                        }
                                    }else{
                                        [arrMessage addObject:ThaiTitle];
                                    }
                                }else{
                                    [arrMessage addObject:Title2];
                                }
                                
                            }else{
                                [arrMessage addObject:Title1];
                                
                            }
                            
                        }
                        
                    }
                    
                    NSArray *PhotoData = [PostsData valueForKey:@"photos"];
                    for (NSDictionary * dict in PhotoData) {
                        NSMutableArray *captionArray = [[NSMutableArray alloc]init];
                        NSMutableArray *UrlArray = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict_ in dict) {
                            NSString *caption = [[NSString alloc]initWithFormat:@"%@",[dict_ objectForKey:@"caption"]];
                            [captionArray addObject:caption];
                            NSDictionary *UserInfoData = [dict_ valueForKey:@"m"];
                            NSString *url = [[NSString alloc]initWithFormat:@"%@",[UserInfoData objectForKey:@"url"]];
                            [UrlArray addObject:url];
                        }
//                        NSString *result = [captionArray componentsJoinedByString:@","];
//                        [PhotoCaptionArray addObject:result];
                        NSString *result2 = [UrlArray componentsJoinedByString:@","];
                        [arrImage addObject:result2];
                    }
                
                
                NSDictionary *locationData = [PostsData valueForKey:@"location"];
                for (NSDictionary * dict in locationData) {
                    NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"distance"]];
                    [arrDistance addObject:formatted_address];
                    NSString *SearchDisplayName = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"search_display_name"]];
                    [arrDisplayCountryName addObject:SearchDisplayName];
                }
                
                NSDictionary *UserInfoData = [PostsData valueForKey:@"user_info"];
                NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                for (NSDictionary * dict in UserInfoData) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                    [arrUserName addObject:username];
                }
                for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                    [arrUserImage addObject:url];
                }
                
                DataCount = DataTotal;
                DataTotal = [arrType count];

//                    NSLog(@"arrType is %@",arrType);
//                    NSLog(@"arrImage is %@",arrImage);
//                    NSLog(@"arrTitle is %@",arrTitle);
//                    NSLog(@"arrMessage is %@",arrMessage);
//                    NSLog(@"arrAddress is %@",arrAddress);
    
                if (CheckFirstTimeLoad == 0) {
                    [self StartInit1stView];
                    CheckFirstTimeLoad = 1;
                }else{
                    [self InitContent];
                }
                
                OnLoad = NO;
            }else{
            
            }
        
        }
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
            if (OnLoad == YES) {
                
            }else{
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                [MainScroll setContentSize:CGSizeMake(screenWidth, MainScroll.contentSize.height + 150)];
                UIActivityIndicatorView *  activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((screenWidth/2) - 15, heightcheck + 40, 30, 30)];
                [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                [activityindicator1 setColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
                [MainScroll addSubview:activityindicator1];
                [activityindicator1 startAnimating];
                [self GetFeedDataFromServer];
            }

            
        }
    }
    
    
}
@end

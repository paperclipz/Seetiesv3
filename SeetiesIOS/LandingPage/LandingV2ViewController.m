//
//  LandingV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "LandingV2ViewController.h"
#import "AppDelegate.h"
#import "ExpertLoginViewController.h"
#import "PTnCViewController.h"
#import "AsyncImageView.h"
#import "WhyWeUseFBViewController.h"
#import "SignupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PTellUsYourCityViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "ProfileV2ViewController.h"
#import "PublishMainViewController.h"
#import "PTellUsYourCityViewController.h"
#import "PSelectYourInterestViewController.h"
#import "PFollowTheExpertsViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import <Parse/Parse.h>
#import "InstagramLoginWebViewController.h"
#import "CRMotionView.h"
#import "RecommendationViewController.h"
#import "PInterestV2ViewController.h"
#import "FeedViewController.h"
#import "OpenWebViewController.h"
#import "NewProfileV2ViewController.h"

#import "CustomPickerViewController.h"
#import "PInterestV2ViewController.h"

@interface LandingV2ViewController ()<UIScrollViewDelegate>
{
    
    IBOutlet UIButton *FBLoginButton;
    IBOutlet UIButton *LogInButton;
    IBOutlet UIButton *WhyWeUseFBButton;
    IBOutlet UIButton *SignUpWithEmailButton;
    IBOutlet UIImageView *ShowBackgroundImage;
    IBOutlet UIView *BackgroundView;
    IBOutlet UILabel *MainText;
    IBOutlet UIImageView *MainLogo;
    IBOutlet UIButton *InstagramButton;
    IBOutlet UILabel *ShowTnCText;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UILabel *ContinueText;
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIPageControl *PageControlOn;
    
    NSMutableArray *ImageArray;
    
    BOOL pageControlBeingUsed;
    int checkauto;
}

@property(nonatomic,strong)CustomPickerViewController* recommendationChooseViewController;
@property(nonatomic,strong)UINavigationController* mainNavigationController;
@property(nonatomic,strong)SignupViewController* signupViewController;

@property(nonatomic,strong)PTnCViewController* pTnCViewController;
@property(nonatomic,strong)PTellUsYourCityViewController* pTellUsYourCityViewController;
@property(nonatomic,strong)PInterestV2ViewController* pInterestV2ViewController;
@property(nonatomic,strong)PFollowTheExpertsViewController* pFollowTheExpertsViewController;

@end

@implementation LandingV2ViewController
@synthesize ShowNotificationCount;


-(void)initSelfView
{
    
    BackgroundView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    ShowBackgroundImage.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    DataUrl = [[UrlDataClass alloc]init];
    FBLoginButton.hidden = YES;
    
    LogInButton.hidden = YES;
    WhyWeUseFBButton.hidden = YES;
    SignUpWithEmailButton.hidden = YES;
    InstagramButton.hidden = YES;
    ContinueText.hidden = YES;
    
    
    InstagramButton.layer.cornerRadius = 5;
    FBLoginButton.layer.cornerRadius = 5;
    InstagramButton.layer.borderWidth = 1;
    InstagramButton.layer.masksToBounds = YES;
    InstagramButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    FBLoginButton.layer.borderWidth = 1;
    FBLoginButton.layer.masksToBounds = YES;
    FBLoginButton.layer.borderColor=[[UIColor whiteColor] CGColor];

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480 || result.height == 568)
        {
            FBLoginButton.frame = CGRectMake((screenWidth/2) - 135, screenHeight - 138, 130, 50);
            InstagramButton.frame = CGRectMake((screenWidth/2) + 5, screenHeight - 138, 130, 50);
            
            LogInButton.frame = CGRectMake((screenWidth/2) + 135 - 74, screenHeight - 85, 74, 34);
            SignUpWithEmailButton.frame = CGRectMake((screenWidth/2) - 135, screenHeight - 85, 125, 34);
            
            MainText.frame = CGRectMake(30, 120, screenWidth - 60, 40);
            MainLogo.frame = CGRectMake((screenWidth/2) - 112, 50, 225, 105);
            PageControlOn.frame = CGRectMake((screenWidth / 2) - 20, 200, 39, 37);
        }else
        {
            FBLoginButton.frame = CGRectMake((screenWidth/2) - 155, screenHeight - 138, 150, 50);
            InstagramButton.frame = CGRectMake((screenWidth/2) + 5, screenHeight - 138, 150, 50);
            
            LogInButton.frame = CGRectMake((screenWidth/2) + 155 - 74, screenHeight - 85, 74, 34);
            SignUpWithEmailButton.frame = CGRectMake((screenWidth/2) - 155, screenHeight - 85, 125, 34);
            
            MainText.frame = CGRectMake(30, 150, screenWidth - 60, 40);
            MainLogo.frame = CGRectMake((screenWidth/2) - 112, 70, 225, 105);
            PageControlOn.frame = CGRectMake((screenWidth / 2) - 20, 220, 39, 37);
        }
    }
    WhyWeUseFBButton.frame = CGRectMake(0, screenHeight - 128, screenWidth, 34);

    ShowBackgroundImage.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    ContinueText.frame = CGRectMake(0, screenHeight - 180, screenWidth, 30);
    MainText.hidden = YES;
    
    ShowTnCText.frame = CGRectMake(30, screenHeight - 40, screenWidth - 60, 30);
    TnCButton.frame = CGRectMake(0, screenHeight - 40, (screenWidth / 2), 30);
    PrivacyButton.frame = CGRectMake((screenWidth / 2), screenHeight - 40,  (screenWidth / 2), 30);
    
    pageControlBeingUsed = NO;
    
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    [MainScroll setScrollEnabled:YES];
    MainScroll.delegate = self;
    [MainScroll setBounces:NO];
    
    ImageArray = [[NSMutableArray alloc] init];
    [ImageArray addObject:@"Walkthrough1.png"];
    [ImageArray addObject:@"Walkthrough2.png"];
    [ImageArray addObject:@"Walkthrough3.png"];
    [ImageArray addObject:@"Walkthrough4.png"];
    
    NSMutableArray *TextArray = [[NSMutableArray alloc]init];
    [TextArray addObject:NSLocalizedString(@"Discover the best places to eat, play, and shop.", nil)];//Discover the city's best places to eat, play & shop
    [TextArray addObject:NSLocalizedString(@"Create your personal collections.", nil)];//Create personal collections for your favourite finds
    [TextArray addObject:NSLocalizedString(@"Recommend your favourite places and best experiences.", nil)];//Recommend your favourite places & best experiences
    [TextArray addObject:NSLocalizedString(@"Share your collections with your buddies.", nil)];//Share your collections with your buddies.

    
    for (int i = 0 ; i < [ImageArray count]; i++) {
        UIImageView *ShowImage = [[UIImageView alloc]initWithFrame:CGRectMake( 0+ i *screenWidth, 0, screenWidth, MainScroll.bounds.size.height)];
        ShowImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowImage.layer.masksToBounds = YES;
        ShowImage.backgroundColor = [UIColor clearColor];
        ShowImage.image = [UIImage imageNamed:[ImageArray objectAtIndex:i]];
        [MainScroll addSubview:ShowImage];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480 || result.height == 568)
            {
                UILabel *ShowUserNameLocalQR = [[UILabel alloc]init];
                ShowUserNameLocalQR.frame = CGRectMake(30+ i *screenWidth, 150, screenWidth - 60, 40);
                ShowUserNameLocalQR.text = [TextArray objectAtIndex:i];
                ShowUserNameLocalQR.backgroundColor = [UIColor clearColor];
                ShowUserNameLocalQR.textColor = [UIColor whiteColor];
                ShowUserNameLocalQR.textAlignment = NSTextAlignmentCenter;
                ShowUserNameLocalQR.numberOfLines = 10;
                ShowUserNameLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:20];
                [MainScroll addSubview:ShowUserNameLocalQR];
            }else
            {
                UILabel *ShowUserNameLocalQR = [[UILabel alloc]init];
                ShowUserNameLocalQR.frame = CGRectMake(30+ i *screenWidth, 170, screenWidth - 60, 40);
                ShowUserNameLocalQR.text = [TextArray objectAtIndex:i];
                ShowUserNameLocalQR.backgroundColor = [UIColor clearColor];
                ShowUserNameLocalQR.textColor = [UIColor whiteColor];
                ShowUserNameLocalQR.textAlignment = NSTextAlignmentCenter;
                ShowUserNameLocalQR.numberOfLines = 10;
                ShowUserNameLocalQR.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:20];
                [MainScroll addSubview:ShowUserNameLocalQR];
            }
        }
        

    }
    NSInteger productcount = [ImageArray count];
    MainScroll.contentSize = CGSizeMake(productcount * screenWidth, [UIScreen mainScreen].bounds.size.height);
    
    PageControlOn.currentPage = 0;
    PageControlOn.numberOfPages = productcount;
    //checkauto = productcount;
    checkauto = 0;
    
    
}

-(void)changeLanguage
{
    MainText.text = NSLocalizedString(@"LandingPage_MainText", nil);
    [FBLoginButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [InstagramButton setTitle:@"Instagram" forState:UIControlStateNormal];
    [LogInButton setTitle:NSLocalizedString(@"Log in",nil) forState:UIControlStateNormal];
    //[WhyWeUseFBButton setTitle:NSLocalizedString(@"LandingPage_WhyUseFacebook",nil) forState:UIControlStateNormal];
    [SignUpWithEmailButton setTitle:NSLocalizedString(@"Sign up",nil) forState:UIControlStateNormal];
    ShowTnCText.text = NSLocalizedString(@"Terms of Use & Privacy Notice.", nil);
    ContinueText.text = NSLocalizedString(@"Continue with",nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSelfView];
    [self changeLanguage];
    [self DeleteAllSaveData];

    count = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DeleteAllSaveData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Feed_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Feed_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Explore_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Search_SortBy"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Filter_Search_Category"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lat"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lng"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Link"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Contact"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Hour"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_City"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Country"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_State"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PostalCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_ReferralId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_type"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_Show"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_NumCode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_BlogLink"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs_Data"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Source"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Period"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_OpenNow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Draft_PhotoCaption"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Title"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Message"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionDataArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringDataArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CheckPhotoCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PlaceId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoPosition"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
    
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

// A validation done on app login before proceeding
-(void)validationBeforeProceed
{

}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self validationBeforeProceed];
    
    
    [self GetAlllanguages];
    
    if ([InstagramOnClickListen isEqualToString:@"YES"]) {
        NSLog(@"need send data to instagram login to server.");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        GetInstagramID = [defaults objectForKey:@"InstagramID"];
        GetInstagramToken = [defaults objectForKey:@"InstagramToken"];
        
        if ([GetInstagramToken length] == 0 || [GetInstagramToken isEqualToString:@""]) {
            
        }else{
            [self UploadINformationToServer_Instagram];
        }
    }else{
    
    }

}
//need to check for all languages before login
-(void)loginChecking
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckProvisioningStatus = [defaults objectForKey:@"CheckProvisioningStatus"];
    NSLog(@"CheckProvisioningStatus is %@",CheckProvisioningStatus);
    NSString *APIVersionSet = [defaults objectForKey:@"APIVersionSet"];
    NSLog(@"APIVersionSet is %@",APIVersionSet);
    NSTimer *RandomTimer;

    if ([Utils isLogin]) {
        MainScroll.hidden = YES;
        PageControlOn.hidden = YES;
        ShowBackgroundImage.image = [UIImage imageNamed:@"HomeBg.png"];
        MainLogo.hidden = YES;
        MainText.hidden = YES;
        ShowTnCText.hidden = YES;
        
        RandomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ChangeView2) userInfo:nil repeats:NO];
    }else{
      //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
      //  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        MainScroll.hidden = NO;
        PageControlOn.hidden = NO;
        ShowBackgroundImage.hidden = YES;
        
        SilderImgMove = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollView) userInfo:nil repeats:YES];
        
//        CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LandingV2.png"]];
//        [motionView setContentView:imageView];
//        [BackgroundView addSubview:motionView];
//        [motionView setScrollDragEnabled:YES];
//        [motionView setScrollBounceEnabled:NO];
        switch ([CheckProvisioningStatus intValue]) {
            case 1:
            {
                self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.pTnCViewController];
                
            }
                
                break;
            case 2:
                self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.pTellUsYourCityViewController];
                
                break;
                
            case 3:
                self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.pInterestV2ViewController];
                
                break;
                
            case 4:
                self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.pFollowTheExpertsViewController];
                
                break;
            default:
                RandomTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeview) userInfo:nil repeats:NO];
                
                return;
                break;
        }
        
        [_mainNavigationController setNavigationBarHidden:YES];
        
        [self presentViewController:self.mainNavigationController animated:YES completion:nil];
        
        
        
    }
}
- (void) scrollView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    checkauto++;
    if (checkauto >= PageControlOn.numberOfPages) {
        PageControlOn.currentPage = 0;
        checkauto = 0;
        [MainScroll setContentOffset:CGPointMake(0,0.0) animated:YES];
    }else{
        CGFloat currentOffset = MainScroll.contentOffset.x;
        CGFloat newOffset = currentOffset + screenWidth;
        [MainScroll setContentOffset:CGPointMake(newOffset,0.0) animated:YES];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = MainScroll.frame.size.width;
    int page = floor((MainScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    PageControlOn.currentPage = page;
}
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = MainScroll.frame.size.width * PageControlOn.currentPage;
    frame.origin.y = 0;
    frame.size = MainScroll.frame.size;
    [MainScroll scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Landing Page";
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ShowActivity stopAnimating];
    [SilderImgMove invalidate];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)changeview{
    
    FBLoginButton.hidden = NO;
    LogInButton.hidden = NO;
    WhyWeUseFBButton.hidden = NO;
    SignUpWithEmailButton.hidden = NO;
    InstagramButton.hidden = NO;
    ContinueText.hidden = NO;
}
-(void)ChangeView2{
    
    [self.view addSubview:self.leveyTabBarController.view];
    //TODO:Delete this . use for development purpose only
    //[self.leveyTabBarController setSelectedIndex:4];
    [self performSelectorOnMainThread:@selector(GetNotificationData) withObject:nil waitUntilDone:NO];
}

- (void)animateImages
{
    
    [UIView transitionWithView:BackgroundView
                      duration:2.0f // animation duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        ShowBackgroundImage.image = [animationImages objectAtIndex:(count % [animationImages count])];
                    } completion:^(BOOL finished) {
                        
                        if (finished) {
                            count++;
                            [self animateImages];
                        }
                        
                    }];
    
}

#pragma mark - Declaration

-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [ProfileViewController new];
        __weak typeof (self)weakSelf = self;
        _profileViewController.btnAddMorePostClickedBlock = ^(void)
        {
            [weakSelf gotoRecommendationPage];

        };
    }
    
    return _profileViewController;
}

-(NewsFeedViewController*)newsFeedViewController
{
    if (!_newsFeedViewController) {
     //   _newsFeedViewController = [NewsFeedViewController new];
    }
    
    return _newsFeedViewController;
}
-(PTnCViewController*)pTnCViewController
{
    if (!_pTnCViewController) {
        _pTnCViewController = [PTnCViewController new];
    }
    return _pTnCViewController;
}
-(PTellUsYourCityViewController*)pTellUsYourCityViewController
{
    if (!_pTellUsYourCityViewController) {
        _pTellUsYourCityViewController = [PTellUsYourCityViewController new];
    }
    return _pTellUsYourCityViewController;
}
-(PInterestV2ViewController*)pInterestV2ViewController
{
    if (!_pInterestV2ViewController) {
        _pInterestV2ViewController = [PInterestV2ViewController new];
    }
    return _pInterestV2ViewController;
}
-(PFollowTheExpertsViewController*)pFollowTheExpertsViewController
{
    if (!_pFollowTheExpertsViewController) {
        _pFollowTheExpertsViewController = [PFollowTheExpertsViewController new];
    }
    return _pFollowTheExpertsViewController;
}

-(SignupViewController*)signupViewController
{
    if (!_signupViewController) {
        _signupViewController = [SignupViewController new];
    }
    return _signupViewController;
}


-(NSArray*)arrTabImages
{
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"FeedIcon.png"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"FeedIconActive.png"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"FeedIconActive.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"ExploreIcon.png"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"ExploreIconActive.png"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"ExploreIconActive.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"RecommendBtn.png"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"CloseBtn.png"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"CloseBtn.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"NotificationIcon.png"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"NotificationIconActive.png"] forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"NotificationIconActive.png"] forKey:@"Seleted"];
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:@"ProfileIcon.png"] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"ProfileIconActive.png"] forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:@"ProfileIconActive.png"] forKey:@"Seleted"];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];

    return imgArr;
}
-(LeveyTabBarController*)leveyTabBarController
{
    
    if(!_leveyTabBarController)
    {
        
         NSArray *arrViewControllers  = [NSArray arrayWithObjects:self.feedViewController.navController,self.explore2ViewController.navController,self.recommendationViewController.navController,self.notificationViewController.navController,self.profileViewController.navController, nil];
        _leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:arrViewControllers imageArray:[self arrTabImages]];
        [_leveyTabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
        [_leveyTabBarController setTabBarTransparent:YES];
        _leveyTabBarController.delegate = self;
        
        CheckNotication = 0;
//        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(CheckNotificationData) userInfo:nil repeats:YES];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        int GetWidth = screenWidth / 5;
        ShowNotificationCount = [[UILabel alloc]init];
        ShowNotificationCount.frame = CGRectMake(screenWidth - GetWidth - 28, screenHeight - 45, 18, 18);
        ShowNotificationCount.text = [NSString stringWithFormat:@"%li",(long)CheckNotication];
        ShowNotificationCount.backgroundColor = [UIColor clearColor];
        ShowNotificationCount.textColor = [UIColor clearColor];
        ShowNotificationCount.layer.cornerRadius = 9;
        ShowNotificationCount.clipsToBounds = YES;
        ShowNotificationCount.textAlignment = NSTextAlignmentCenter;
        ShowNotificationCount.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
        [_leveyTabBarController.view addSubview:ShowNotificationCount];
        
        UIButton *Line = [[UIButton alloc]init];
        Line.frame = CGRectMake(0, screenHeight - 50, screenWidth, 1);
        [Line setTitle:@"" forState:UIControlStateNormal];
        Line.backgroundColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
        [_leveyTabBarController.view addSubview:Line];
        
    }
    
    return _leveyTabBarController;
}
-(void)DrawNotificationData{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateNotificationData) name:@"CHANGE_NOTIFICATION_COUNT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideNotification) name:@"CHANGE_NOTIFICATION_HIDE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideNotification) name:@"CHANGE_NOTIFICATION_SHOW" object:nil];
    
    ShowNotificationCount.text = [NSString stringWithFormat:@"%li",(long)CheckNotication];
    ShowNotificationCount.backgroundColor = [UIColor redColor];
    ShowNotificationCount.textColor = [UIColor whiteColor];
}
-(void)UpdateNotificationData{
    CheckNotication = 0;
    ShowNotificationCount.text = @"";
    ShowNotificationCount.backgroundColor = [UIColor clearColor];
    ShowNotificationCount.textColor = [UIColor clearColor];
}
-(void)HideNotification{
     ShowNotificationCount.hidden = YES;
}
-(void)ShowNotification{
     ShowNotificationCount.hidden = NO;
}

-(void)GetNotificationData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@notifications/count?token=%@",DataUrl.UserWallpaper_Url,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetNotificationData check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    //NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetNotificationCount = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetNotificationCount start];
    
    
    if( theConnection_GetNotificationCount ){
        webData = [NSMutableData data];
    }
}

- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    if ((int)index == 2)
    {
        
        [self.recommendationChooseViewController show];
    
        return NO;
    }
    else if (index == 4)
    {
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOwn UserID:[Utils getUserID]];
    }

    return YES;
}

-(CustomPickerViewController*)recommendationChooseViewController
{
    if (!_recommendationChooseViewController) {
        
        
        // type 1 is draft , default is image picker
        _recommendationChooseViewController = [CustomPickerViewController initializeWithBlock:^(id object) {
            [self gotoDraftPage];
            
        } buttonTwo:^(id object) {
            [self gotoRecommendationPage];
        }cancelBlock:^(id object) {
            [self.leveyTabBarController setSelectedIndex:self.leveyTabBarController.previousIndex];
        }];
        
        [self.leveyTabBarController.view addSubview:_recommendationChooseViewController.view];
        [_recommendationChooseViewController hideWithAnimation:NO];

    }
        
        return _recommendationChooseViewController;
}

-(void)gotoDraftPage
{
    [self.recommendationViewController initData:1 sender:self.leveyTabBarController];
    [self.leveyTabBarController setSelectedIndex:self.leveyTabBarController.previousIndex];
    // go to draft
}

-(void)gotoRecommendationPage
{
    [self.recommendationViewController initData:2 sender:self.leveyTabBarController];
    [self.leveyTabBarController setSelectedIndex:self.leveyTabBarController.previousIndex];

}
-(FeedViewController*)feedViewController
{
    if(!_feedViewController){
        
        _feedViewController = [FeedViewController new];
    }
    return _feedViewController;
}

-(Explore2ViewController*)explore2ViewController
{
    if(!_explore2ViewController){
        
        _explore2ViewController = [Explore2ViewController new];
    }
    return _explore2ViewController;
}

-(RecommendationViewController*)recommendationViewController
{
    if(!_recommendationViewController)
    {
        _recommendationViewController = [RecommendationViewController new];
        __weak typeof (self)weakself = self;
        _recommendationViewController.backBlock = ^(id object)
        {
            [weakself dismissViewControllerAnimated:YES completion:nil];
        };
        _recommendationViewController.donePostBlock = ^(id object)
        {
            
            [TSMessage showNotificationInViewController:weakself title:@"system" subtitle:@"Data Successfully posted" type:TSMessageNotificationTypeSuccess duration:2.0 canBeDismissedByUser:YES];
            
        };
    }
    return _recommendationViewController;
}

-(SelectImageViewController*)selectImageViewController
{
    if(!_selectImageViewController){
        
        _selectImageViewController = [SelectImageViewController new];
    }
    return _selectImageViewController;
}


-(NotificationViewController*)notificationViewController
{
    if(!_notificationViewController){
        
        _notificationViewController = [NotificationViewController new];
    }
    return _notificationViewController;
}

-(NewProfileV2ViewController*)userProfilePageViewController
{
    if(!_userProfilePageViewController){
        
        _userProfilePageViewController = [NewProfileV2ViewController new];
        
        __weak typeof (self)weakSelf = self;
        _userProfilePageViewController.btnRecommendationClickBlock = ^(id object)
        {
            
            [weakSelf gotoRecommendationPage];

            
        };
    }
    return _userProfilePageViewController;
}

#pragma mark - IBAction
-(IBAction)BtnExpertLoginClicked:(id)sender{
    
    ExpertLoginViewController *ExpertLoginView = [[ExpertLoginViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ExpertLoginView animated:NO completion:nil];
    
    
    __weak typeof (self)weakSelf = self;
    ExpertLoginView.backFromExpertLoginBlock = ^(id object)
    {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
}
-(IBAction)btnWhyWeUseFacebookClicked:(id)sender{
    WhyWeUseFBViewController *WhyWeUseFBView = [[WhyWeUseFBViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:WhyWeUseFBView animated:NO completion:nil];
}
-(IBAction)btnSignupWithEmailClicked:(id)sender{
   
    self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.signupViewController];
    [_mainNavigationController setNavigationBarHidden:YES];

    [self presentViewController:self.mainNavigationController animated:YES completion:nil];
}

-(IBAction)btnFacebookClicked:(id)sender{
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         switch (state) {
             case FBSessionStateOpen:{
                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                     if (error) {
                         
                         NSLog(@"error:%@",error);
                         
                         
                     }
                     else
                     {
                         // retrive user's details at here as shown below
                         NSLog(@"all information is %@",user);
                         GetFB_ID = (NSString *)[user valueForKey:@"id"];
                         
                         [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                             if (error) {
                                 // Handle error
                             }else {
                                 Name = [FBuser name];
                                 NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", GetFB_ID];
                                 UserEmail = [user valueForKey:@"email"];
                                 UserGender = [user valueForKey:@"gender"];
                                 Userdob = [user valueForKey:@"birthday"];
                                 UserName = [user valueForKey:@"last_name"];
                                 UserName = [[NSString alloc]initWithFormat:@"%@%@",[user valueForKey:@"first_name"],[user valueForKey:@"last_name"]];
                                 
                                 NSLog(@"name is %@",Name);
                                 NSLog(@"username is %@",UserName);
                                 NSLog(@"Userid is %@",GetFB_ID);
                                 NSLog(@"useremail is %@",UserEmail);
                                 NSLog(@"usergender is %@",UserGender);
                                 NSLog(@"userImageURL is %@",userImageURL);
                                 NSLog(@"userdob is %@",Userdob);
                                 NSLog(@"session is %@",session);
                                 
                                 GetFB_Token = [FBSession activeSession].accessTokenData.accessToken;
                                 NSLog(@"GetToken is %@",GetFB_Token);
                                 
                                 //                                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                 //                                 [defaults setObject:session forKey:@"fbsession"];
                                 //                                 [defaults synchronize];
                                 
                                 [self UploadInformationToServer];
                                 
                             }
                         }];
                         
                     }
                 }];
                 break;
             }
             case FBSessionStateClosed:
             case FBSessionStateClosedLoginFailed:
                 [FBSession.activeSession closeAndClearTokenInformation];
                 break;
                 
             default:
                 break;
         }
         
         // Retrieve the app delegate
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
         
     }];
    //    }
    
}

-(void)UploadINformationToServer_Instagram{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] ||[ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.InstagramRegister_Url];
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
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"insta_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetInstagramID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"insta_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetInstagramToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ip_address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ExternalIPAddress] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}

#pragma mark - Request Server Api
-(void)UploadInformationToServer{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] ||[ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.FacebookRegister_Url];
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
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fb_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetFB_Token] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"role\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"user"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ip_address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ExternalIPAddress] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}
#pragma mark - Connection Delegate
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
    if (connection == theConnection_GetNotificationCount) {
        
    }else{
        [ShowActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }

}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Facebook) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Facebook Register return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Facebook Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            
            NSLog(@"Got Data.");
            NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithArray:[GetAllData valueForKey:@"categories"]];
            NSLog(@"categoriesArray is %@",categoriesArray);
            NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"country"]];
            NSLog(@"GetCountry is %@",GetCountry);
            NSString *Getcrawler = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"crawler"]];
            NSLog(@"Getcrawler is %@",Getcrawler);
            NSString *Getcreated_at = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"created_at"]];
            NSLog(@"Getcreated_at is %@",Getcreated_at);
            NSString *Getdescription = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
            NSLog(@"Getdescription is %@",Getdescription);
            NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"profile_photo"]];
            NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            NSString *Gettoken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"token"]];
            NSLog(@"Gettoken is %@",Gettoken);
            NSString *Getuid = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"uid"]];
            NSLog(@"Getuid is %@",Getuid);
            NSString *Getprovisioning = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"provisioning"]];
            NSLog(@"Getprovisioning is %@",Getprovisioning);
            NSString *Getrole = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"role"]];
            NSLog(@"Getrole is %@",Getrole);
            NSDictionary *SystemLanguage = [GetAllData valueForKey:@"system_language"];
            NSLog(@"SystemLanguage is %@",SystemLanguage);
            NSString *GetCaption;
            if ([SystemLanguage isKindOfClass:[NSNull class]]) {
                GetCaption = @"English";
            }else{
                GetCaption = [[NSString alloc]initWithFormat:@"%@",[SystemLanguage objectForKey:@"caption"]];
                NSLog(@"GetCaption is %@",GetCaption);
            }
            //            NSString *GetCaption = [[NSString alloc]initWithFormat:@"%@",[SystemLanguage objectForKey:@"caption"]];
            //            NSLog(@"GetCaption is %@",GetCaption);
            NSString *GetPasswordCheck = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"has_password"]];
            NSLog(@"GetPasswordCheck is %@",GetPasswordCheck);
            NSString *GetFbExtendedToken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"fb_extended_token"]];
            NSLog(@"GetFbExtendedToken is %@",GetFbExtendedToken);
            
            NSMutableArray *GetUserSelectLanguagesArray = [[NSMutableArray alloc]init];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            NSDictionary *NSDictionaryLanguage = [GetAllData valueForKey:@"languages"];
            NSLog(@"NSDictionaryLanguage is %@",NSDictionaryLanguage);
            NSString *GetLanguage_1;
            NSString *GetLanguage_2;
            if ([NSDictionaryLanguage isKindOfClass:[NSNull class]]) {
                GetLanguage_1 = @"English";
                GetLanguage_2 = @"English";
            }else{
                for (NSDictionary * dict in NSDictionaryLanguage){
                    NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
                    [GetUserSelectLanguagesArray addObject:Getid];
                    NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                    NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                    [TempArray addObject:GetLanguage_1];
                }
                NSLog(@"GetUserSelectLanguagesArray is %@",GetUserSelectLanguagesArray);
                
                
                if ([TempArray count] == 1) {
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                }else{
                    GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                    GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
                }
            }
            
            
            NSInteger CheckSystemLanguage;
            if ([GetCaption isEqualToString:@"English"]) {
                CheckSystemLanguage = 0;
            }else if([GetCaption isEqualToString:@"Simplified Chinese"]){
                CheckSystemLanguage = 1;
            }else if([GetCaption isEqualToString:@"Traditional Chinese"]){
                CheckSystemLanguage = 2;
            }else if([GetCaption isEqualToString:@"Bahasa Indonesia"]){
                CheckSystemLanguage = 3;
            }else if([GetCaption isEqualToString:@"Thai"]){
                CheckSystemLanguage = 4;
            }else if([GetCaption isEqualToString:@"Filipino"]){
                CheckSystemLanguage = 5;
            }
            
            //  NSLog(@"CheckSystemLanguage is %li",(long)CheckSystemLanguage);
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguage];
            
            NSLog(@"Landing Language selected: %@", localeForRow.name);
            
            [languageManager setLanguageWithLocale:localeForRow];
            
            NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:Gettoken forKey:@"ExpertToken"];
            [defaults setObject:Getusername forKey:@"UserName"];
            [defaults setObject:Getprofile_photo forKey:@"UserProfilePhoto"];
            [defaults setObject:Getuid forKey:@"Useruid"];
            [defaults setObject:CheckLogin forKey:@"CheckLogin"];
            [defaults setObject:Getrole forKey:@"Role"];
            [defaults setObject:GetPasswordCheck forKey:@"CheckPassword"];
            [defaults setObject:GetCaption forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetUserSelectLanguagesArray forKey:@"GetUserSelectLanguagesArray"];
            [defaults setObject:GetFbExtendedToken forKey:@"fbextendedtoken"];
            if (NSDictionaryLanguage == NULL) {
                
            }else{
                [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
                [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            }
            
            [defaults synchronize];
            
            //     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *GetDeviceToken = [defaults objectForKey:@"DeviceTokenPush"];
            NSString *GetUserUID = [defaults objectForKey:@"Useruid"];
            NSLog(@"GetDeviceToken is %@",GetDeviceToken);
            NSLog(@"GetUserUID is %@",GetUserUID);
            if ([GetDeviceToken length] == 0 || GetDeviceToken == (id)[NSNull null] || GetDeviceToken.length == 0) {
                
            }else{
                NSString *Check = [defaults objectForKey:@"CheckGetPushToken"];
                if ([Check isEqualToString:@"Done"]) {
                    
                }else{
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setDeviceTokenFromData:GetDeviceToken];
                    NSString *TempTokenString = [[NSString alloc]initWithFormat:@"seeties_%@",GetUserUID];
                    
                    [currentInstallation removeObject:@"all" forKey:@"channels"];
                    [currentInstallation removeObject:TempTokenString forKey:@"channels"];
                    [currentInstallation saveInBackground];
                    
                    currentInstallation.channels = @[TempTokenString,@"all"];
                    [currentInstallation saveInBackground];
                    NSLog(@"work here?");
                    NSString *TempString = @"Done";
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:TempString forKey:@"CheckGetPushToken"];
                    [defaults synchronize];
                }
                
            }
            
            if ([Getprovisioning isEqualToString:@"1"]) {
                [self ChangeView2];
                
                
            }else{
//                PInterestV2ViewController *PInterestV2View = [[PInterestV2ViewController alloc]init];
//                [self presentViewController:PInterestV2View animated:YES completion:nil];
                self.mainNavigationController = [[UINavigationController alloc]initWithRootViewController:self.pInterestV2ViewController];
                [_mainNavigationController setNavigationBarHidden:YES];
                
                [self presentViewController:self.mainNavigationController animated:YES completion:nil];
            }
            
            
            
            
        }
        
        [ShowActivity stopAnimating];
        
        
        
    }else if(connection == theConnection_GetLanguages){
        //get all languages
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //  NSLog(@"All Languages return get data to server ===== %@",GetData);
        
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //NSLog(@"Facebook Json = %@",res);
        
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"languages"];
        //  NSLog(@"GetAllData Json = %@",GetAllData);
        
        NSMutableArray *LanguageID_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *LanguageName_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *LanguageCode_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        NSMutableArray *SystemLanguageID_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *SystemLanguageName_Array = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *id_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [SystemLanguageID_Array addObject:id_];
            if ([id_ isEqualToString:@"530d5e9b642440d128000018"]) {
                
            }else{
                [LanguageID_Array addObject:id_];
            }
            
            NSString *origin_caption = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
            //    NSLog(@"origin_caption is %@",origin_caption);
            [SystemLanguageName_Array addObject:origin_caption];
            if ([origin_caption isEqualToString:@"繁體中文"]) {
                
            }else{
                if ([origin_caption isEqualToString:@"简体中文"]) {
                    origin_caption = @"中文";
                }
                [LanguageName_Array addObject:origin_caption];
            }
            
            NSString *language_code = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"language_code"]];
            if ([language_code isEqualToString:@"zh_TW"]) {
                
            }else{
                [LanguageCode_Array addObject:language_code];
            }
            
        }
        //  NSLog(@"SystemLanguageID_Array is %@",SystemLanguageID_Array);
        // NSLog(@"SystemLanguageName_Array is %@",SystemLanguageName_Array);
        //  NSLog(@"LanguageCode_Array is %@",LanguageCode_Array);
        
        
        NSString *CheckStatus = @"5";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:LanguageID_Array forKey:@"LanguageData_ID"];
        [defaults setObject:LanguageName_Array forKey:@"LanguageData_Name"];
        [defaults setObject:LanguageCode_Array forKey:@"LanguageData_Code"];
        [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
        [defaults setObject:SystemLanguageID_Array forKey:@"SystemLanguageData_ID"];
        [defaults setObject:SystemLanguageName_Array forKey:@"SystemLanguageData_Name"];
        [defaults synchronize];
        
        [self loginChecking];
        [self GetALlCategory];
    }else if(connection == theConnection_GetAllCategory){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        //  NSLog(@"Get All Category return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSArray *GetAllData = (NSArray *)[res valueForKey:@"categories"];
      //  NSLog(@"GetAllData Json = %@",GetAllData);
        
        NSMutableArray *Category_IDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_ImageDefaultArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_ImageSelectedArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_BackgroundImageArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        
        NSMutableArray *Category_NameArray_CN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TW = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_TH = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_IN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        NSMutableArray *Category_NameArray_FN = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
        for (NSDictionary * dict in GetAllData) {
            NSString *id_ = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"id"]];
            [Category_IDArray addObject:id_];
            
            NSDictionary *GetImageData = [dict valueForKey:@"images"];
            
            NSString *DefaultImg = [[NSString alloc]initWithFormat:@"%@",[GetImageData objectForKey:@"default"]];
            NSString *SelectImg = [[NSString alloc]initWithFormat:@"%@",[GetImageData objectForKey:@"selected"]];
            [Category_ImageDefaultArray addObject:DefaultImg];
            [Category_ImageSelectedArray addObject:SelectImg];
            
            
            NSString *background_color = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"background_color"]];
            [Category_BackgroundImageArray addObject:background_color];
            NSDictionary *NameData = [dict valueForKey:@"single_line"];
            NSString *EnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0ab26424400c76000003"]];
            [Category_NameArray addObject:EnData];
            NSString *CnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530b0aa16424400c76000002"]];
            [Category_NameArray_CN addObject:CnData];
            NSString *TwData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"530d5e9b642440d128000018"]];
            [Category_NameArray_TW addObject:TwData];
            NSString *InData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"53672e863efa3f857f8b4ed2"]];
            [Category_NameArray_IN addObject:InData];
            NSString *FnData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"539fbb273efa3fde3f8b4567"]];
            [Category_NameArray_FN addObject:FnData];
            NSString *ThData = [[NSString alloc]initWithFormat:@"%@",[NameData objectForKey:@"544481503efa3ff1588b4567"]];
            [Category_NameArray_TH addObject:ThData];
        }
        
           // NSLog(@"Category_ImageDefaultArray is %@",Category_ImageDefaultArray);
          //  NSLog(@"Category_ImageSelectedArray is %@",Category_ImageSelectedArray);
        //        NSLog(@"Category_ImageArray is %@",Category_ImageArray);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Category_IDArray forKey:@"Category_All_ID"];
        [defaults setObject:Category_NameArray forKey:@"Category_All_Name"];
        [defaults setObject:Category_ImageDefaultArray forKey:@"Category_All_Image_Default"];
        [defaults setObject:Category_ImageSelectedArray forKey:@"Category_All_Image_Selected"];
        [defaults setObject:Category_BackgroundImageArray forKey:@"Category_All_Background"];
        
        [defaults setObject:Category_NameArray_CN forKey:@"Category_All_Name_Cn"];
        [defaults setObject:Category_NameArray_TW forKey:@"Category_All_Name_Tw"];
        [defaults setObject:Category_NameArray_IN forKey:@"Category_All_Name_In"];
        [defaults setObject:Category_NameArray_FN forKey:@"Category_All_Name_Fn"];
        [defaults setObject:Category_NameArray_TH forKey:@"Category_All_Name_Th"];
        [defaults synchronize];
        
        
        [ShowActivity stopAnimating];
    }else if (connection == theConnection_GetNotificationCount){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Get Notification Count return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        
        NSString *GetTotalNewCount = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"total_new_notifications"]];
        NSLog(@"GetTotalNewCount is %@",GetTotalNewCount);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        if ([ErrorString length] == 0 || [ErrorString isEqualToString:@""] || [ErrorString isEqualToString:@"(null)"] || [ErrorString isEqualToString:@"<null>"]) {
            CheckNotication = [GetTotalNewCount integerValue];
            if (CheckNotication == 0) {
                ShowNotificationCount.text = @"";
                ShowNotificationCount.backgroundColor = [UIColor clearColor];
                ShowNotificationCount.textColor = [UIColor clearColor];
            }else{
                [self DrawNotificationData];
            }
            [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(GetNotificationData) userInfo:nil repeats:NO];
        }else{
            [NSTimer scheduledTimerWithTimeInterval:80.0 target:self selector:@selector(GetNotificationData) userInfo:nil repeats:NO];
        }
        

        
    }
    
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(void)GetAlllanguages{
    [ShowActivity startAnimating];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetAlllangauge_Url];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetLanguages = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetLanguages start];
    
    
    if( theConnection_GetLanguages ){
        webData = [NSMutableData data];
    }
}
-(void)GetALlCategory{
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetAllCategory_Url];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetAllCategory = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetAllCategory start];
    
    
    if( theConnection_GetAllCategory ){
        webData = [NSMutableData data];
    }
}
-(IBAction)InstagramButton:(id)sender{
    NSLog(@"Instagram Click");
    InstagramOnClickListen = @"YES";
    InstagramLoginWebViewController *WebViewLogin = [[InstagramLoginWebViewController alloc]init];
    [self presentViewController:WebViewLogin animated:YES completion:nil];
}
-(IBAction)TnCButtonOnClick:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"TermsofUse"];
}
-(IBAction)PrivacyButtonOnClick:(id)sender{
    OpenWebViewController *OpenWebView = [[OpenWebViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:OpenWebView animated:NO completion:nil];
    [OpenWebView GetTitleString:@"PrivacyPolicy"];
}
@end


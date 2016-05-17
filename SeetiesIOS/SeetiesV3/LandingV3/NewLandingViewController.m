//
//  NewLandingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewLandingViewController.h"
#import "UITabBar+Extension.h"
#import "IntroCoverView.h"


@interface NewLandingViewController()<UITabBarControllerDelegate>
{
    
}
/*navigation controller*/
@property (nonatomic)UINavigationController* firstViewController;
@property (nonatomic)UINavigationController* secondViewController;
@property (nonatomic)UINavigationController* thirdViewController;
@property (nonatomic, strong)IntroCoverView* introView;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (nonatomic,strong)NSArray* arryViewController;

@end

@implementation NewLandingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadBadgeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSelfView];
    
    @try {
        [[SearchManager Instance]startSearchGPSLocation];
        [[SearchManager Instance]startGetWifiLocation];

    } @catch (NSException *exception) {
        
        [CrashlyticsKit setObjectValue:exception forKey:@"Location"];
        
    }
    
    //[self requestForApiVersion:nil];

//    if (![Utils getIsDevelopment]) {
//        
//        [self requestForApiVersion:nil];
//        [self initSelfView];
//
//    }
//    else{
//        [self requestForApiVersion:^{
//            [self initSelfView];
//
//        }];
//    }
   // [self showAnimatedSplash];

}

-(void)initSelfView
{
    [self.view addSubview:self.tabBarController.view];
    
    [self changeLanguage];
    
    [self requestServerForLanguageList];
    
    [self registerNotification];
    
    if (![Utils checkUserIsLogin]) {
        
        [Utils showLogin];
    }
    else{
        [Utils startNotification];
        
        [self requestServerForUserInfo];
        
        [Utils reloadAppView:YES];
    }
    
    [self requestServerForCountry];
}

-(void)requestForApiVersion:(VoidBlock)completionBlock{
    
    
    [[ConnectionManager Instance]requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetApiVersion parameter:nil appendString:nil success:^(id object) {
        
        [self processAPIVersion];
        
        if (completionBlock) {
            completionBlock();
        }
        // [self showIntroView];
        
    } failure:^(id object) {


    }];
    
}

#pragma mark -  connection processing

-(void)processAPIVersion
{
    
    ApiVersionModel* model =[[ConnectionManager dataManager] apiVersionModel] ;
    
    
    //[Utils setIsDevelopment:!model.production];
    //Check version if same then proceed, if not same then promp error and also proceed to landing
    if (![model.version isEqualToString:API_VERSION]) {
        
        [UIAlertView showWithTitle:model.title
                           message:model.message
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                  NSString *iTunesLink = @"https://itunes.apple.com/app/seeties-mobile-citypass-for/id956400552?mt=8";
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                              }
                          }];
    }
}
//-(void)showAnimatedSplash
//{
//    
//    [self.view addSubview:self.ibSplashView];
//    self.ibSplashView.frame = self.view.frame;
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.ibLogo.alpha = 0;
//        
//    }completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:1.0 animations:^{
//        
//            self.ibSplashView.alpha = 0;
//        }completion:^(BOOL finished) {
//            [self.ibSplashView removeFromSuperview];
//        }];
//    }];
//}

-(UITabBarController*)tabBarController
{
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc]init];
        _tabBarController.viewControllers = self.arryViewController;
        
        [[UITabBar appearance] setTintColor:DEVICE_COLOR];
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];

        _tabBarController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [_tabBarController.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
        _tabBarController.delegate = self;
        [_tabBarController.tabBar setSquareBorder];

    }
    
    return _tabBarController;
}

-(void)reloadData
{
//    [self.tabBarController.view removeFromSuperview];
//    _arryViewController = nil;
//    [self.view addSubview:self.tabBarController.view];
    
    
    [self.newsFeedViewController reloadData];
    [self.ct3_MoreViewController reloadData];
    [self.ct3MeViewController reloadData];


    
}

-(void)reloadHomeView
{
    [self.newsFeedViewController reloadData];

}

#pragma mark - Declaration

-(UINavigationController*)navLoginViewController
{
    if (!_navLoginViewController) {
        _navLoginViewController = [[UINavigationController alloc]initWithRootViewController:self.loginViewController];
        [_navLoginViewController hideStatusBar];

    }
    
    return _navLoginViewController;
}

-(NSArray*)arryViewController
{
    if (!_arryViewController) {
        _newsFeedViewController = nil;
        _firstViewController = [[UINavigationController alloc]initWithRootViewController:self.newsFeedViewController];
        _firstViewController.navigationBar.hidden = YES;
        _ct3MeViewController = nil;
        _secondViewController = [[UINavigationController alloc]initWithRootViewController:self.ct3MeViewController];
        _secondViewController.navigationBar.hidden = YES;
        _ct3_MoreViewController = nil;
        _thirdViewController = [[UINavigationController alloc]initWithRootViewController:self.ct3_MoreViewController];
        _thirdViewController.navigationBar.hidden = YES;
        
    
        _arryViewController = @[self.firstViewController,self.secondViewController,self.thirdViewController];
    }
    
    return _arryViewController;
}

-(CT3_LoginViewController*)loginViewController
{
    if (!_loginViewController) {
        _loginViewController = [CT3_LoginViewController new];
        
        __weak typeof (self)weakSelf = self;
        _loginViewController.didFinishLoginBlock = ^(void)
        {
            [weakSelf processLogin];
        };
        _loginViewController.continueWithoutLoginBlock = ^(void)
        {
            [weakSelf.newsFeedViewController reloadData];
        };
        
        _loginViewController.didFinishSignupBlock = ^(void)
        {
            
            [weakSelf.navLoginViewController dismissViewControllerAnimated:YES completion:^{
                weakSelf.newsFeedViewController.needShowIntroView = YES;
                [weakSelf processLogin];

            }];
        };
        

    }
    
    return _loginViewController;
}

-(void)processLogin
{
    
    [self.navLoginViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [Utils reloadAppView:YES];
    self.tabBarController.selectedIndex = 0;
    
    [TSMessage showNotificationInViewController:self.newsFeedViewController title:LocalisedString(@"system") subtitle:LocalisedString(@"Login Successfully") type:TSMessageNotificationTypeSuccess duration:1.0f canBeDismissedByUser:YES];
    
    /*send crashlytics user UID to track crashes*/
    ProfileModel* model = [[ConnectionManager dataManager]userLoginProfileModel];
    [CrashlyticsKit setUserIdentifier:model.uid];
    
    [self requestServerForUserInfo];
    [Utils requestServerForNotificationCount];
}

-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [ProfileViewController new];
    }
    return _profileViewController;
}
-(CT3_MoreViewController*)ct3_MoreViewController
{
    if (!_ct3_MoreViewController) {
        _ct3_MoreViewController = [CT3_MoreViewController new];
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"TabBarMoreIcon.png"]
                                                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"TabBarMoreIconActive.png"]];
        _ct3_MoreViewController.tabBarItem = item2;

        _ct3_MoreViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        _ct3_MoreViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -1.0f, -7, 1);

    }
    return _ct3_MoreViewController;
}

-(CT3_NewsFeedViewController*)newsFeedViewController
{
    if (!_newsFeedViewController) {
        _newsFeedViewController = [CT3_NewsFeedViewController new];

        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"TabBarHomeIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"TabBarHomeIconActive.png"]];
        _newsFeedViewController.tabBarItem = item2;
        
        _newsFeedViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);

        _newsFeedViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -1.0f, -7, 1);

        //__weak typeof (self)weakSelf = self;
        _newsFeedViewController.btnLoginClickedBlock = ^(void)
        {
            //[weakSelf showLoginView];
            [Utils showLogin];
        };
    }
    
    return _newsFeedViewController;
}

-(CT3_MeViewController*)ct3MeViewController{
    if (!_ct3MeViewController) {
        _ct3MeViewController = [CT3_MeViewController new];
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"TabBarMeIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"TabBarMeIconActive.png"]];
        _ct3MeViewController.tabBarItem = item2;
        _ct3MeViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
        _ct3MeViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -2.0f, -7, 2);

    }
    return _ct3MeViewController;
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
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,nil];
    
    return imgArr;
}

#pragma mark - Show View

-(void)showLoginView
{
    _navLoginViewController = nil;

    if (!(self.loginViewController.isViewLoaded && self.loginViewController.view.window)) {
        [self presentViewController:self.navLoginViewController animated:YES completion:nil];

    }

}

-(void)showLoginViewWithCompletion:(VoidBlock)completionBlock
{
    _navLoginViewController = nil;
    
    [self presentViewController:self.navLoginViewController animated:YES completion:completionBlock];
    
}

#pragma mark - Request Server

-(void)requestServerForCountry
{
    NSDictionary* dict = @{@"language_code":ENGLISH_CODE};
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetHomeCountry parameter:dict appendString:nil success:^(id object) {
        
        SLog(@"[COUNTRY CODE RETRIEVED]");
        
    } failure:^(id object) {
        
    }];
}


-(void)requestServerForUserInfo
{
    NSString* appendString = [NSString stringWithFormat:@"%@",@"me"];
    
    NSDictionary* dict = @{@"uid":@"me",
                           @"token":[Utils getAppToken]
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserInfo parameter:dict appendString:appendString success:^(id object) {
        
        [Utils reloadProfileView];
        
        DataManager* manager = [ConnectionManager dataManager];
        manager.currentUserProfileModel = [[ConnectionManager dataManager]userProfileModel];
        
        [[LanguageManager sharedLanguageManager]setLanguageCode:manager.currentUserProfileModel.system_language.language_code];
        
    } failure:^(id object) {
        
    }];
}

-(void)requestServerForLanguageList{
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetAllAppInfo parameter:nil appendString:nil success:^(id object) {

        
    } failure:^(id object) {
        
    }];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == tabBarController.selectedViewController) {
        
        [self.newsFeedViewController scrollToTop:YES];
    }
    
    return YES;
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotification:)
                                                 name:@"UpdateNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotification:)
                                                 name:@"updatePhoneVerification"
                                               object:nil];

}

- (void) updateNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"UpdateNotification"])
    {
    
        if (![Utils isGuestMode]) {
            
            @try {
                NSDictionary* dict = notification.userInfo;
                
                int notificationCount = [[dict objectForKey:@"NOTIFICATION_COUNT"] intValue];
                
                if (notificationCount == 0) {
                    
                    self.ct3MeViewController.tabBarItem.badgeValue = nil;
                }
                else{
                    
                    self.ct3MeViewController.tabBarItem.badgeValue = [dict objectForKey:@"NOTIFICATION_COUNT"];

                }
            }
            @catch (NSException *exception) {
                
            }

        }
        else {
            self.ct3MeViewController.tabBarItem.badgeValue = nil;

        }
    }
    else if([[notification name] isEqualToString:@"updatePhoneVerification"])
    {
        [self reloadBadgeView];
    }
}

#pragma mark - Intro View

-(void)showIntroView
{
    CGRect frame = [Utils getDeviceScreenSize];
    
    self.introView = nil;
    self.introView = [IntroCoverView initializeCustomView];
    self.introView.frame = frame;
    
    self.introView.alpha = 0;
    [self.view addSubview:self.introView];
    [self.introView initDataAll];

    [UIView animateWithDuration:1.0 animations:^{
        self.introView.alpha = 1;

    }completion:^(BOOL finished) {
        

    }];
    

    
    __weak IntroCoverView* weakIntroView = self.introView;
    self.introView.didEndClickedBlock = ^(void)
    {
        weakIntroView.alpha = 1;
        [UIView animateWithDuration:1.0 animations:^{
            weakIntroView.alpha = 0;

        }completion:^(BOOL finished) {
            [weakIntroView removeFromSuperview];
        }];
    };
    
}

-(void)reloadBadgeView
{
    
    if ([Utils isGuestMode]) {
        
        self.ct3_MoreViewController.tabBarItem.badgeValue = nil;

    }
    else{
        
        ProfileModel* userProfile = [[ConnectionManager dataManager]currentUserProfileModel];
        
        if ([Utils isStringNull:userProfile.contact_no]) {
            self.ct3_MoreViewController.tabBarItem.badgeValue = @"!";

        }
        else{
            self.ct3_MoreViewController.tabBarItem.badgeValue = nil;

        }

    }

}

-(void)reloadTabbar
{
    [self changeLanguage];
}

-(void)changeLanguage
{
    NSString* strActive1 = @"";
    NSString* inActive1 = @"";
    
    NSString* strActive2 = @"";
    NSString* inActive2 = @"";
    
    NSString* strActive3 = @"";
    NSString* inActive3 = @"";
    
    SWITCH ([Utils getDeviceAppLanguageCode]) {
        
        
        CASE (CHINESE_CODE){
            
            strActive1 = @"CN_TabbarHomeIcon_Active";
            inActive1 = @"CN_TabbarHomeIcon_Inactive";
            strActive2 = @"CN_TabbarMeIcon_Active";
            inActive2 = @"CN_TabbarMeIcon_Inactive";
            strActive3 = @"CN_TabbarMoreIcon_Active";
            inActive3 = @"CN_TabbarMoreIcon_Inactive";
            
            break;
            
        }
        CASE (TAIWAN_CODE){
            
            strActive1 = @"TW_TabbarHomeIcon_Active";
            inActive1 = @"TW_TabbarHomeIcon_Inactive";
            strActive2 = @"CN_TabbarMeIcon_Active";
            inActive2 = @"CN_TabbarMeIcon_Inactive";
            strActive3 = @"CN_TabbarMoreIcon_Active";
            inActive3 = @"CN_TabbarMoreIcon_Inactive";
            
            break;
            
        }
        CASE (INDONESIA_CODE){
            strActive1 = @"ID_TabbarHomeIcon_Active";
            inActive1 = @"ID_TabbarHomeIcon_Inactive";
            strActive2 = @"EN_TabbarMeIcon_Active";
            inActive2 = @"EN_TabbarMeIcon_Inactive";
            strActive3 = @"EN_TabbarMoreIcon_Active";
            inActive3 = @"EN_TabbarMoreIcon_Inactive";
            
            break;
            
        }
        
        CASE (THAI_CODE){
            strActive1 = @"TH_TabbarHomeIcon_Active";
            inActive1 = @"TH_TabbarHomeIcon_Inactive";
            strActive2 = @"TH_TabbarMeIcon_Active";
            inActive2 = @"TH_TabbarMeIcon_Inactive";
            strActive3 = @"TH_TabbarMoreIcon_Active";
            inActive3 = @"TH_TabbarMoreIcon_Inactive";
            break;
            
        }
        
        
        DEFAULT
        CASE (ENGLISH_CODE){
            
            strActive1 = @"EN_TabbarHomeIcon_Active";
            inActive1 = @"EN_TabbarHomeIcon_Inactive";
            strActive2 = @"EN_TabbarMeIcon_Active";
            inActive2 = @"EN_TabbarMeIcon_Inactive";
            strActive3 = @"EN_TabbarMoreIcon_Active";
            inActive3 = @"EN_TabbarMoreIcon_Inactive";
            break;
            
        }
        
    }
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",inActive1]]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strActive1]]];
    _newsFeedViewController.tabBarItem = item1;
    
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",inActive2]]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strActive2]]];
    
    
    _ct3MeViewController.tabBarItem = item2;
    
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",inActive3]]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strActive3]]];
    
    
    _ct3_MoreViewController.tabBarItem = item3;
    
    
    _newsFeedViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
    _newsFeedViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -1.0f, -7, 1);
    
    _ct3_MoreViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    _ct3_MoreViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -1.0f, -7, 1);
    
    _ct3MeViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
    _ct3MeViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, -2.0f, -7, 2);

}

@end

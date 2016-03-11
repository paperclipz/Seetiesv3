//
//  NewLandingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewLandingViewController.h"
#import <ESTabBarController/ESTabBarController.h>
#import "UITabBar+Extension.h"

@interface NewLandingViewController()<UITabBarControllerDelegate>

/*navigation controller*/
@property (nonatomic)UINavigationController* firstViewController;
@property (nonatomic)UINavigationController* secondViewController;
@property (nonatomic)UINavigationController* thirdViewController;
@property (nonatomic, strong)UINavigationController* navLoginViewController;

@property (nonatomic,strong)NSArray* arryViewController;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@end

@implementation NewLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.tabBarController.view];

    [self requestServerForLanguageList];
    
    if (![Utils checkUserIsLogin]) {
        [Utils showLogin];
    }
    else{
        
        [self requestServerForUserInfo];
        [Utils reloadAppView];
    }
    
    [self requestServerForCountry];
}

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
-(void)initSelfView
{
    [self.view addSubview:self.leveyTabBarController.view];
   }

#pragma mark - Declaration

-(UINavigationController*)navLoginViewController
{
    if (!_navLoginViewController) {
        _loginViewController = nil;
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
        

    }
    
    return _loginViewController;
}

-(void)processLogin
{
    
    [self.navLoginViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [Utils reloadAppView];
    self.tabBarController.selectedIndex = 0;
    
    [TSMessage showNotificationInViewController:self.newsFeedViewController title:LocalisedString(@"system") subtitle:LocalisedString(@"Login Successfully") type:TSMessageNotificationTypeSuccess duration:1.0f canBeDismissedByUser:YES];
    
    /*send crashlytics user UID to track crashes*/
    ProfileModel* model = [[ConnectionManager dataManager]userLoginProfileModel];
    [CrashlyticsKit setUserIdentifier:model.uid];
    
    [self requestServerForUserInfo];

}

-(LeveyTabBarController*)leveyTabBarController
{
    
    if(!_leveyTabBarController)
    {
        
        _firstViewController = [[UINavigationController alloc]initWithRootViewController:self.newsFeedViewController];
        _firstViewController.navigationBar.hidden = YES;
        _secondViewController = [[UINavigationController alloc]initWithRootViewController:self.ct3MeViewController];
        _secondViewController.navigationBar.hidden = YES;
        _thirdViewController = [[UINavigationController alloc]initWithRootViewController:self.ct3_MoreViewController];
        _thirdViewController.navigationBar.hidden = YES;


        NSArray *arrViewControllers  = [NSArray arrayWithObjects:self.firstViewController,
                                        self.secondViewController,self.thirdViewController, nil];
        
        _leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:arrViewControllers imageArray:[self arrTabImages]];
        [_leveyTabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
        [_leveyTabBarController setTabBarTransparent:YES];
        _leveyTabBarController.delegate = self;
        
    }
    
    return _leveyTabBarController;
}
-(Explore2ViewController*)explore2ViewController
{
    if (!_explore2ViewController) {
        _explore2ViewController = [Explore2ViewController new];
    }
    
    return _explore2ViewController;
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
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"BlueTime.png"] selectedImage:[UIImage imageNamed:@"BlueTime.png"]];
        _ct3_MoreViewController.tabBarItem = item2;

        _ct3_MoreViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        _ct3_MoreViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -1.0f, 0, 1);

    }
    return _ct3_MoreViewController;
}

-(CT3_NewsFeedViewController*)newsFeedViewController
{
    if (!_newsFeedViewController) {
        _newsFeedViewController = [CT3_NewsFeedViewController new];

        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"BlueTime.png"] selectedImage:[UIImage imageNamed:@"BlueTime.png"]];
        _newsFeedViewController.tabBarItem = item2;
        
        _newsFeedViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);

        _newsFeedViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -1.0f, 0, 1);

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
        UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:[UIImage imageNamed:@"ProfileIcon"] selectedImage:[UIImage imageNamed:@"ProfileIcon"]];
        _ct3MeViewController.tabBarItem = item2;

        _ct3MeViewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        _ct3MeViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, -2.0f, 0, 2);

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

- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    
//    if (index == 1)
//    {
//        [self.profileViewController requestAllDataWithType:ProfileViewTypeOwn UserID:[Utils getUserID]];
//    }
    
    return YES;
}


#pragma mark - Show View

-(void)showLoginView
{
    _navLoginViewController = nil;

    [self presentViewController:self.navLoginViewController animated:YES completion:nil];


}


#pragma mark - Request Server

-(void)requestServerForCountry
{
    NSDictionary* dict = @{@"language_code":ENGLISH_CODE};
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHomeCountry param:dict appendString:nil completeHandler:^(id object) {
        
        
        SLog(@"[COUNTRY CODE RETRIEVED]");
        
    } errorBlock:^(id object) {
        
    }];
}


-(void)requestServerForUserInfo
{
    NSString* appendString = [NSString stringWithFormat:@"%@",@"me"];
    
    NSDictionary* dict = @{@"uid":@"me",
                           @"token":[Utils getAppToken]
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserInfo param:dict appendString:appendString completeHandler:^(id object) {
        
        [Utils reloadProfileView];
        SLog(@"Sucess Retreive User Data");
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForLanguageList{
    
    [LoadingManager show];
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetLanguage param:nil appendString:nil completeHandler:^(id object) {
        
        
    } errorBlock:^(id object) {
        
        
    }];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == tabBarController.selectedViewController) {
        
        [self.newsFeedViewController scrollToTop:YES];
    }
    
    return YES;
}


@end

//
//  NewLandingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/29/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewLandingViewController.h"
#import <ESTabBarController/ESTabBarController.h>

@interface NewLandingViewController()

/*navigation controller*/
@property (strong)UINavigationController* firstViewController;
@property (strong)UINavigationController* secondViewController;
@property (strong)UINavigationController* thirdViewController;



@end

@implementation NewLandingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self requestServerForLanguageList];
    
    
    // Do any additional setup after loading the view.
}
-(void)initSelfView
{
    [self.view addSubview:self.leveyTabBarController.view];
}



#pragma mark - Declaration

-(CT3_LoginViewController*)loginViewController
{
    if (!_loginViewController) {
        _loginViewController = [CT3_LoginViewController new];
        
        __weak typeof (self)weakSelf = self;
        _loginViewController.didFinishLoginBlock = ^(void)
        {
            [weakSelf.newsFeedViewController refreshViewAfterLogin];
        };
    }
    
    return _loginViewController;
}

-(LeveyTabBarController*)leveyTabBarController
{
    
    if(!_leveyTabBarController)
    {
        
        _firstViewController = [[UINavigationController alloc]initWithRootViewController:self.newsFeedViewController];
        _firstViewController.navigationBar.hidden = YES;
        _secondViewController = [[UINavigationController alloc]initWithRootViewController:self.explore2ViewController];
        _secondViewController.navigationBar.hidden = YES;
        _thirdViewController = [[UINavigationController alloc]initWithRootViewController:self.profileViewController];
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

-(CT3_NewsFeedViewController*)newsFeedViewController
{
    if (!_newsFeedViewController) {
        _newsFeedViewController = [CT3_NewsFeedViewController new];
        
        __weak typeof (self)weakSelf = self;
        _newsFeedViewController.btnLoginClickedBlock = ^(void)
        {
            [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
        };

    }
    return _newsFeedViewController;
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
    
    if (index == 2)
    {
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOwn UserID:[Utils getUserID]];
    }
    
    return YES;
}

-(void)requestServerForLanguageList{
    
    [LoadingManager show];
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetLanguage param:nil appendString:nil completeHandler:^(id object) {
        
        
    } errorBlock:^(id object) {
        
        
    }];
    
}

@end

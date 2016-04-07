//
//  ConnectionsViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "CAPSPageMenu.h"

@interface ConnectionsViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)InitSelfView{
    //self.ibScrollView.contentSize = CGSizeMake(850, 50);
    
    [self.ibContentView adjustToScreenWidth];

    [self.ibContentView addSubview:self.cAPSPageMenu.view];
    
    
}
- (IBAction)ConnectionsSegmentedControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"Follower was selected");
            [self.ibScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            NSLog(@"Following was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - Declaration

-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.FollowerConnectionsTabViewController,self.FollowingConnectionsTabViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/2 - 20),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                     };
        
        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
        //_cAPSPageMenu.delegate = self;
    }
    return _cAPSPageMenu;
}



-(ConnectionsTabViewController*)FollowerConnectionsTabViewController{
    if(!_FollowerConnectionsTabViewController)
    {
        _FollowerConnectionsTabViewController = [ConnectionsTabViewController new];
        _FollowerConnectionsTabViewController.usersListingType = UsersListingTypeFollower;
        _FollowerConnectionsTabViewController.userID = self.userID;
        _FollowerConnectionsTabViewController.title = LocalisedString(@"Follower");
        __weak typeof (self)weakSelf = self;
        
        _FollowerConnectionsTabViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES onCompletion:^{
                [weakSelf.profileViewController initDataWithUserID:userid];
            }];

        };
    }
    return _FollowerConnectionsTabViewController;
}
-(ConnectionsTabViewController*)FollowingConnectionsTabViewController{
    if(!_FollowingConnectionsTabViewController)
    {
        _FollowingConnectionsTabViewController = [ConnectionsTabViewController new];
        _FollowingConnectionsTabViewController.usersListingType = UsersListingTypeFollowing;
        _FollowingConnectionsTabViewController.userID = self.userID;
        _FollowingConnectionsTabViewController.title = LocalisedString(@"Following");

        __weak typeof (self)weakSelf = self;
        
        _FollowingConnectionsTabViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            
           
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES onCompletion:^{
                [weakSelf.profileViewController initDataWithUserID:userid];
            }];

        };
    }
    return _FollowingConnectionsTabViewController;
}
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
}
@end

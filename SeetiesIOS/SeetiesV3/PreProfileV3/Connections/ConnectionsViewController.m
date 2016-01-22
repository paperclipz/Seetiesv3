//
//  ConnectionsViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ConnectionsViewController.h"

@interface ConnectionsViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;

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
    
    CGRect frame = [Utils getDeviceScreenSize];
    [self.ibScrollView setWidth:frame.size.width];
    [self.FollowerConnectionsTabViewController.view setWidth:frame.size.width];
    [self.FollowerConnectionsTabViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.FollowerConnectionsTabViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);
    
    [self.FollowingConnectionsTabViewController.view setWidth:frame.size.width];
    [self.FollowingConnectionsTabViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.FollowingConnectionsTabViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.FollowingConnectionsTabViewController.view setX:self.FollowerConnectionsTabViewController.view.frame.size.width];
    
    
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
-(ConnectionsTabViewController*)FollowerConnectionsTabViewController{
    if(!_FollowerConnectionsTabViewController)
    {
        _FollowerConnectionsTabViewController = [ConnectionsTabViewController new];
        _FollowerConnectionsTabViewController.TabType = @"Follower";
        _FollowerConnectionsTabViewController.userID = self.userID;
        __weak typeof (self)weakSelf = self;
        
        _FollowerConnectionsTabViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:userid];
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES];

        };
    }
    return _FollowerConnectionsTabViewController;
}
-(ConnectionsTabViewController*)FollowingConnectionsTabViewController{
    if(!_FollowingConnectionsTabViewController)
    {
        _FollowingConnectionsTabViewController = [ConnectionsTabViewController new];
        _FollowingConnectionsTabViewController.TabType = @"Following";
        _FollowingConnectionsTabViewController.userID = self.userID;
        
        __weak typeof (self)weakSelf = self;
        
        _FollowingConnectionsTabViewController.didSelectUserRowBlock = ^(NSString* userid)
        {
            _profileViewController = nil;
            [weakSelf.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:userid];
            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES];
            
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

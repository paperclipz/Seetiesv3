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
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UIView *ibSegmentedView;
@property(nonatomic) HMSegmentedControl *segmentedControl;
@property(nonatomic) NSArray *arrViewControllers;
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
    
    self.ibHeaderTitle.text = LocalisedString(@"Connections");
    [self initSegmentedControlViewInView:self.ibScrollView ContentView:self.ibSegmentedView ViewControllers:self.arrViewControllers];
}

-(void)initSegmentedControlViewInView:(UIScrollView*)view ContentView:(UIView*)contentView ViewControllers:(NSArray*)arryViewControllers
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    view.delegate = self;
    
    
    NSMutableArray* arrTitles = [NSMutableArray new];
    
    for (int i = 0; i<arryViewControllers.count; i++) {
        
        UIViewController* vc = arryViewControllers[i];
        [view addSubview:vc.view];
        [arrTitles addObject:vc.title];
        vc.view.frame = CGRectMake(i*frame.size.width, 0, view.frame.size.width, view.frame.size.height);
    }
    
    view.contentSize = CGSizeMake(frame.size.width*arryViewControllers.count , view.frame.size.height);
    
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : TEXT_GRAY_COLOR,
                                                  NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ONE_ZERO_TWO_COLOR,
                                                          NSFontAttributeName : [UIFont fontWithName:CustomFontNameBold size:14.0f]};
    
    self.segmentedControl.sectionTitles = arrTitles;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.selectionIndicatorColor = DEVICE_COLOR;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [contentView addSubview:self.segmentedControl];
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [view scrollRectToVisible:CGRectMake(view.frame.size.width * index, 0, view.frame.size.width, view.frame.size.height) animated:YES];
    }];
    
}

#pragma mark - Declaration

-(ConnectionsTabViewController*)FollowerConnectionsTabViewController{
    if(!_FollowerConnectionsTabViewController)
    {
        _FollowerConnectionsTabViewController = [ConnectionsTabViewController new];
        _FollowerConnectionsTabViewController.usersListingType = UsersListingTypeFollower;
        _FollowerConnectionsTabViewController.userID = self.userID;
        _FollowerConnectionsTabViewController.title = LocalisedString(@"Followers");
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
        _FollowingConnectionsTabViewController.title = LocalisedString(@"Following");
        _FollowingConnectionsTabViewController.usersListingType = UsersListingTypeFollowing;
        _FollowingConnectionsTabViewController.userID = self.userID;

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

-(NSArray *)arrViewControllers{
    if (!_arrViewControllers) {
        _arrViewControllers = @[self.FollowerConnectionsTabViewController, self.FollowingConnectionsTabViewController];
    }
    return _arrViewControllers;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}
@end

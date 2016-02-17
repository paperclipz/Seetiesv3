//
//  CT3_NotificationViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "CAPSPageMenu.h"
#import "NotificationTableViewController.h"

@interface CT3_NotificationViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;
@property (nonatomic, strong) NotificationTableViewController *followingTableViewController;
@property (nonatomic, strong) NotificationTableViewController *notificationTableViewController;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@end

@implementation CT3_NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
   [[Crashlytics sharedInstance] crash];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initSelfView
{
 
      [self.ibContentView addSubview:self.cAPSPageMenu.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Declaration

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.followingTableViewController.tableView) {
        return 2;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DealType_mainTblCell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.followingTableViewController.tableView) {
        return 81;
    }
    else if (tableView == self.notificationTableViewController.tableView){
        return 81;

    }
    else
    {
        return 100;

    }

}
-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.notificationTableViewController, self.followingTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/2),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                     };
        
        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
    }
    return _cAPSPageMenu;
}


-(NotificationTableViewController*)followingTableViewController
{
    if (!_followingTableViewController) {
        _followingTableViewController = [NotificationTableViewController new];
        _followingTableViewController.tableView.delegate = self;
        _followingTableViewController.tableView.dataSource = self;

    }
    
    return _followingTableViewController;
}

-(NotificationTableViewController*)notificationTableViewController
{
    if (!_notificationTableViewController) {
        _notificationTableViewController = [NotificationTableViewController new];
        _notificationTableViewController.tableView.dataSource = self;
        _notificationTableViewController.tableView.dataSource = self;

    }
    
    return _notificationTableViewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

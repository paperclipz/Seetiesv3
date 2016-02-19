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

#import "FeedV2DetailViewController.h"
#import "SeetiesShopViewController.h"

@interface CT3_NotificationViewController () 
@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;
@property (nonatomic, strong) NotificationTableViewController *followingTableViewController;
@property (nonatomic, strong) NotificationTableViewController *notificationTableViewController;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@property(nonatomic,strong)FeedV2DetailViewController* feedDetailViewCOntroller;
/*model*/

@property (nonatomic, strong) NotificationModels *notificationsModels;
@property (nonatomic, strong) NotificationModels *followingNotificationsModels;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) SeetiesShopViewController *seetiesShopViewController;

@end

@implementation CT3_NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
   // [self requestServerForFollowingNotifications];
    [self.followingTableViewController requestServer:1];
    [self.notificationTableViewController requestServer:2];
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

-(SeetiesShopViewController*)seetiesShopViewController
{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    
    return _seetiesShopViewController;
}
-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [ProfileViewController new];
    }
    return _profileViewController;
}

-(FeedV2DetailViewController*)feedDetailViewCOntroller
{
    if (!_feedDetailViewCOntroller) {
        _feedDetailViewCOntroller = [FeedV2DetailViewController new];
    }
    return _feedDetailViewCOntroller;
}
-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.followingTableViewController,self.notificationTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/2 - 30),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                     CAPSPageMenuOptionMenuItemSeparatorColor: LINE_COLOR,
                                     };
        
        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
        _cAPSPageMenu.controllerScrollView.scrollEnabled = NO;
    }
    return _cAPSPageMenu;
}


-(NotificationTableViewController*)followingTableViewController
{
    if (!_followingTableViewController) {
        _followingTableViewController = [NotificationTableViewController new];
        _followingTableViewController.title = LocalisedString(@"Following");
        
        __weak typeof (self)weakself = self;
        _followingTableViewController.didSelectNotificationBlock = ^(NotificationModel* model)
        {
            [weakself processView:model Type:1];
        };

    }
    
    return _followingTableViewController;
}

-(NotificationTableViewController*)notificationTableViewController
{
    if (!_notificationTableViewController) {
        _notificationTableViewController = [NotificationTableViewController new];
        _notificationTableViewController.title = LocalisedString(@"Notifications");
        
        __weak typeof (self)weakself = self;
        _notificationTableViewController.didSelectNotificationBlock = ^(NotificationModel* model)
        {
            [weakself processView:model Type:2];
        };

    }
    
    return _notificationTableViewController;
}

-(void)processView:(NotificationModel*)model Type:(int)type
{
    //            FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    //            [self.navigationController pushViewController:FeedDetailView animated:YES];
    //            [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    //        }else if ([GetType isEqualToString:@"mention"]){
    //            FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController alloc]init];
    //            [self.navigationController pushViewController:FeedDetailView animated:YES];
    //            [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
    //        }else if ([GetType isEqualToString:@"comment"]){
    //            FeedV2DetailViewController *FeedDetailView = [[FeedV2DetailViewController a
    //                                                           }else if([GetType isEqualToString:@"post_shared"]){

    
    if (type == 1) {
        
        
        [self showProfileView:model];
        
        return;
    }
    switch (model.notType) {
        case NotificationType_Mention:
        case NotificationType_Comment:
        case NotificationType_PostShared:
        case NotificationType_Like:
        {
            [self showPostDetailView:model.post_id];

        }
            break;
            
        case NotificationType_Follow:
        case NotificationType_Collect:
        case NotificationType_CollectionShared:
        case NotificationType_CollectionFollow:

            [self showProfileView:model];

            break;
        case NotificationType_SeetiesShared:
            
            [self showSeetiShopView:model.seetishop];
            
            break;
            
        case NotificationType_Seeties:
        {
           
            if ([model.action isEqualToString:@"user"]) {
                
                [self showProfileView:model];

            }
            else if ([model.action isEqualToString:@"post"]) {
                
                [self showPostDetailView:model.post_id];

            }
        }
            
            break;

        default:
            break;
    }

}
                                                           
-(void)showPostDetailView:(NSString*)postID
{
    
    if (![Utils isStringNull:postID]) {
        _feedDetailViewCOntroller = nil;
        [self.navigationController pushViewController:self.feedDetailViewCOntroller animated:YES];
        [self.feedDetailViewCOntroller GetPostID:postID];
    }
   
}

-(void)showProfileView:(NotificationModel*)model
{
    NSString* userID;
    if (![Utils isStringNull:model.uid]) {

        userID = model.uid;
    }
    else{
        userID = model.userProfile.uid;

    }
    
    
    if (![Utils isStringNull:userID]) {
        _profileViewController = nil;
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:userID];
        [self.navigationController pushViewController:self.profileViewController animated:YES];

    }
    
}

-(void)showSeetiShopView:(SeShopDetailModel*)model
{
    _seetiesShopViewController = nil;
    
    if (![Utils isStringNull:model.seetishop_id]) {
        [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id];
    }
    else{
        [self.seetiesShopViewController initDataPlaceID:model.place_id postID:model.post_id];

    }
    
    [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
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

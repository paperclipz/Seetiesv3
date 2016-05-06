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
#import "CollectionViewController.h"
#import "CollectionListingSinglePageViewController.h"
#import "DealDetailsViewController.h"
#import "CTWebViewController.h"
#import "VoucherListingViewController.h"


@interface CT3_NotificationViewController () 
@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;
@property (nonatomic, strong) NotificationTableViewController *followingTableViewController;
@property (nonatomic, strong) NotificationTableViewController *notificationTableViewController;
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;

@property(nonatomic,strong)FeedV2DetailViewController* feedDetailViewCOntroller;
/*model*/

@property (nonatomic, strong) NotificationModels *notificationsModels;
@property (nonatomic, strong) NotificationModels *followingNotificationsModels;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) SeetiesShopViewController *seetiesShopViewController;
@property (nonatomic, strong) CollectionViewController *collectionViewController;
@property(nonatomic)CollectionListingSinglePageViewController* collectionListingVC;
@property(nonatomic)DealDetailsViewController* dealDetailsViewController;
@property(nonatomic)CTWebViewController* ctWebViewController;
@property(nonatomic)VoucherListingViewController* voucherListingViewController;

@end

@implementation CT3_NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [self initSelfView];
    
   

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Notification");
}

-(void)initSelfView
{
    
    [self.followingTableViewController requestServer:1];
    [self.notificationTableViewController requestServer:2];
    [self.ibContentView addSubview:self.cAPSPageMenu.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Declaration

-(VoucherListingViewController*)voucherListingViewController
{
    if (!_voucherListingViewController) {
        _voucherListingViewController = [VoucherListingViewController new];
    }
    
    return _voucherListingViewController;
}

-(CTWebViewController*)ctWebViewController
{
    if (!_ctWebViewController) {
        _ctWebViewController = [CTWebViewController new];
    }
    
    return _ctWebViewController;
}

-(DealDetailsViewController*)dealDetailsViewController
{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    
    return _dealDetailsViewController;
}

-(CollectionListingSinglePageViewController*)collectionListingVC
{
    if (!_collectionListingVC) {
        _collectionListingVC = [CollectionListingSinglePageViewController new];
    }
    return _collectionListingVC;
}

-(CollectionViewController*)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [CollectionViewController new];
    }
    return _collectionViewController;
}

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
        
        NSArray *controllerArray = @[self.notificationTableViewController, self.followingTableViewController];
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
        _followingTableViewController.title = LocalisedString(@"Activity");
        
        __weak typeof (self)weakself = self;
        _followingTableViewController.didSelectNotificationBlock = ^(NotificationModel* model)
        {
            [weakself processView:model Type:1];

        };
        
        _followingTableViewController.didSelectPostBlock = ^(NSString* postID)
        {
            [weakself showPostDetailView:postID];
            
        };
        
        _followingTableViewController.didSelectProfileBlock = ^(NotificationModel* model)
        {
            [weakself showProfileView:model];
            
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
        
        _notificationTableViewController.didSelectPostBlock = ^(NSString* postID)
        {
            [weakself showPostDetailView:postID];
        };
        
        _notificationTableViewController.didSelectProfileBlock = ^(NotificationModel* model)
        {
            [weakself showProfileView:model];
            
        };

    }
    
    return _notificationTableViewController;
}

-(void)processView:(NotificationModel*)model Type:(int)type
{
    
//    if (type == 1) {
//        
//        [self showProfileView:model];
//        
//        return;
//    }
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
        {
            
            if (type == 1) {
                
                @try {
                    [self showProfileView:model.arrFollowingUsers[0]];

                }
                @catch (NSException *exception) {
                    
                    SLog(@"No array of following user given");
                }

            }
            else{
                [self showProfileView:model];

            }

        }
            break;
            
        case NotificationType_Collect:
        {
            [self showProfileView:model];
            break;
        }
        case NotificationType_CollectionShared:
        case NotificationType_CollectionFollow:

            
            if (type == 1) {
                
                [self showCollectionListingView:model.arrCollections];
               
            }
            else{
                
                
                [self showCollectionView:model.collectionInfo userID:model.collectionInfo.user_info.uid];
                

            }

            break;
        case NotificationType_SeetiesShared:
            
            [self showSeetiShopView:model.seetishop];
            
            break;
            
            
        case NotificationType_ReferralReward:
            
            [self showVoucherListingReferralView:model.deal_collection.deal_collection_id ReferralID:model.referral_u_id];
            
            break;

            
        case NotificationType_Seeties:
        {
           
            if ([model.action isEqualToString:@"user"]) {
                
                [self showProfileView:model];

            }
            else if ([model.action isEqualToString:@"post"]) {
                
                [self showPostDetailView:model.post_id];

            }
            else if ([model.action isEqualToString:@"collection"]) {
                
                CollectionModel* cModel = [CollectionModel new];
                cModel.collection_id = model.collection_id;
                [self showCollectionView:cModel userID:model.uid];
            }
            else if ([model.action isEqualToString:@"seetishop"]) {
                
                SeShopDetailModel* sModel = [SeShopDetailModel new];
                sModel.seetishop_id = model.seetishop_id;
                [self showSeetiShopView:sModel];
            }
            else if ([model.action isEqualToString:@"url"]) {
                
                [self showWebViewWithURL:model.url];
            }
            
            else if ([model.action isEqualToString:@"deal"]) {
                
                DealModel* dModel = [DealModel new];
                dModel.dID = model.deal_id;
                [self showDealDetailView:dModel];
            }
            else if ([model.action isEqualToString:@"deal_collection"]) {
                
             
                [self showVoucherListingView:model.deal_collection_id];
            }
            
            
        }
            break;

        case NotificationType_DealShared:
        {
            if (model.deal) {
                [self showDealDetailView:model.deal];
            }
        }
            break;

        default:
            break;
    }

}

-(void)showCollectionListingView:(NSArray*)array
{
    
    if (array.count >1) {
        _collectionListingVC = nil;
        [self.navigationController pushViewController:self.collectionListingVC animated:YES];
        [self.collectionListingVC initData:array];

    }
    else{

        @try {
            CollectionModel* cModel = array[0];

            [self showCollectionView:cModel userID:cModel.user_info.uid];

        }
        @catch (NSException *exception) {

            SLog(@"Fail To Load Collection Info");

        }

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

-(void)showCollectionView:(CollectionModel*)model userID:(NSString*)uID
{
    CollectionModel* colModel = model;

    if (![Utils isStringNull:colModel.collection_id]) {
        
        _collectionViewController = nil;

        if ([uID isEqualToString:[Utils getUserID]]) {
            
            [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"self" GetUserUid:uID];
            [self.navigationController pushViewController:self.collectionViewController animated:YES];

        }
        else{
            
            [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"Others" GetUserUid:uID];
            [self.navigationController pushViewController:self.collectionViewController animated:YES];

        }
        
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
        [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
            [self.profileViewController initDataWithUserID:userID];

        }];

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

-(void)showDealDetailView:(DealModel*)model
{
    _dealDetailsViewController = nil;
    
    [self.dealDetailsViewController initDealModel:model];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        
        [self.dealDetailsViewController setupView];
    }];
}

-(void)showWebViewWithURL:(NSString*)url
{
    if (![Utils isStringNull:url]) {
        
        _ctWebViewController = nil;
        [self.navigationController pushViewController:self.ctWebViewController animated:YES onCompletion:^{
            [self.ctWebViewController initDataWithURL:url andTitle:@""];
        }];
    }
    
}

-(void)showVoucherListingView:(NSString*)dealCollectionID
{
    if (![Utils isStringNull:dealCollectionID]) {
        
        DealCollectionModel* cModel = [DealCollectionModel new];
        cModel.deal_collection_id = dealCollectionID;
        
        _voucherListingViewController = nil;
        [self.voucherListingViewController initData:cModel withLocation:nil];
        [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
    }
}

-(void)showVoucherListingReferralView:(NSString*)dealCollectionID ReferralID:(NSString*)refID
{
    if (![Utils isStringNull:dealCollectionID]) {
        
     
        DealCollectionModel* cModel = [DealCollectionModel new];
        cModel.deal_collection_id = dealCollectionID;
        
        _voucherListingViewController = nil;
        
        [self.voucherListingViewController initWithDealCollectionModel:cModel ReferralID:refID];
        
        [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
    }
}

@end

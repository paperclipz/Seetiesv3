//
//  CT3_NewsFeedViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CT3_NewsFeedViewController.h"

#import "FeedType_FollowingPostTblCell.h"
#import "FeedType_CountryPromotionTblCell.h"
#import "FeedType_InviteFriendTblCell.h"
#import "FeedType_AnnouncementWelcomeTblCell.h"
#import "FeedType_CollectionSuggestedTblCell.h"
#import "FeedType_AbroadQualityPostTblCell.h"
#import "FeedType_SuggestionFetureTblCell.h"
#import "FeedType_FollowingCollectionTblCell.h"
#import "DealType_ReferFriendTblCell.h"

#import "AddCollectionDataViewController.h"
#import "FeedV2DetailViewController.h"
#import "CollectionListingViewController.h"
#import "CollectionViewController.h"
#import "InviteFrenViewController.h"
#import "ProfileViewController.h"
#import "CTWebViewController.h"
#import "CT3_EnableLocationViewController.h"

#import "DealType_mainTblCell.h"
#import "DealType_QuickBrowseTblCell.h"
#import "DealType_DealOTDTblCell.h"
#import "DealType_YourWalletTblCell.h"
#import "FeedType_headerTblCell.h"

#import "AppDelegate.h"
#import "SeetiesShopViewController.h"
#import "DealRedeemViewController.h"
#import "CT3_MeViewController.h"
#import "VoucherListingViewController.h"
#import "SearchLocationViewController.h"
#import "CT3_AnnouncementViewController.h"

#import "UITableView+Extension.h"

#import "SelectCategoryViewController.h"
#import "WalletListingViewController.h"

#import "SearchQuickBrowseListingController.h"
#import "CT3_SearchListingViewController.h"
#import "DealDetailsViewController.h"
#import "CT3_ReferalViewController.h"
#import "CT3_InviteFriendViewController.h"

#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"

#import "UITableView+emptyState.h"
#import "UIButton+Activity.h"
#import "UIImageView+Extension.h"

static NSCache* heightCache = nil;
#define TopBarHeight 64.0f
#define NUMBER_OF_SECTION 2

#define LOCATION_INSTANT @"instant"
#define LOCATION_PROMPT @"prompt"
#define LOCATION_NONE @"update"

@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isMiddleOfLoadingServer;
    BOOL isMiddleOfLoadingHome;

    __weak IBOutlet UIActivityIndicatorView *ibActivityIndicator;
    __weak IBOutlet UIImageView *ibHeaderBackgroundView;
    __weak IBOutlet NSLayoutConstraint *constTopScrollView;
    BOOL isFirstLoad;
    
    NSString* lastUpdatedLocation;
    NSString* lastUpdatedDateTime;
    BOOL updateData;
    NSString* update_location_method;

    BOOL isDealCollectionShown;
    
    BOOL isLoadingLocation;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentLocation;
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (strong, nonatomic) IBOutlet UIView *ibFooterView;

/* Model */
@property(nonatomic,strong)NSMutableArray* arrayNewsFeed;
@property(nonatomic,strong)NewsFeedModels* newsFeedModels;
@property(nonatomic,strong)HomeModel* homeModel;
@property(nonatomic,strong)NSMutableArray* arrHomeDeal;

@property(nonatomic,strong)HomeLocationModel* currentHomeLocationModel;

@property(nonatomic,strong)NSString* locationName;
@property (nonatomic, strong) SearchManager *searchManager;
@property (nonatomic) DealManager *dealManager;


/* Model */

/*Controller*/
@property(nonatomic,strong)AddCollectionDataViewController* collectPostToCollectionVC;
@property(nonatomic,strong)FeedV2DetailViewController* feedV2DetailViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)CollectionViewController* displayCollectionViewController;
@property(nonatomic,strong)InviteFrenViewController* inviteFrenViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CTWebViewController* ctWebViewController;
@property(nonatomic,strong)VoucherListingViewController* voucherListingViewController;

@property(nonatomic)DealRedeemViewController* dealRedeemViewController;
@property(nonatomic,strong)CT3_MeViewController* meViewController;
@property(nonatomic, strong) SearchLocationViewController *searchLocationViewController;
@property(nonatomic, strong) CT3_AnnouncementViewController *announcementViewController;
@property(nonatomic)WalletListingViewController* walletListingViewController;
@property(nonatomic)SearchQuickBrowseListingController* searchQuickBrowseListingController;

@property(nonatomic)CT3_SearchListingViewController* ct3_SearchListingViewController;
@property(nonatomic)PromoPopOutViewController *promoPopoutViewController;
@property(nonatomic)DealDetailsViewController *dealDetailsViewController;
@property(nonatomic)CT3_ReferalViewController *referralViewController;
@property(nonatomic)CT3_InviteFriendViewController *inviteFriendViewController;
@property(nonatomic)CT3_EnableLocationViewController* enableLocationViewController;

/*Controller*/

@end

@implementation CT3_NewsFeedViewController

#pragma mark -IBACTION

- (IBAction)btnutoDetectClicked:(id)sender {
    
    if ([SearchManager isDeviceGPSTurnedOn]) {
        
        
        if (isLoadingLocation) {
            return;
        }
        
        self.btnCurrentLocation.enabled = NO;

        isLoadingLocation = YES;
        
        [[SearchManager Instance]startSearchGPSLocation:^(CLLocation *location) {
            
            self.btnCurrentLocation.enabled = NO;

            [self getCurrentLocationGoogleGeoCode:location];
        }];
        
//        [UIAlertView showWithTitle:LocalisedString(@"Couldn't get your location now") message:LocalisedString(@"try again later") cancelButtonTitle:LocalisedString(@"OK") otherButtonTitles:nil tapBlock:nil];
    }
    else{
        
        [self presentViewController:self.enableLocationViewController animated:YES completion:nil];
    }
}


- (IBAction)btnSearchLocationClicked:(id)sender {
    
    _searchLocationViewController = nil;
    [self.navigationController pushViewController:self.searchLocationViewController animated:YES];
}

- (IBAction)btnSearchClicked:(id)sender {
    
    _ct3_SearchListingViewController = nil;
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}

- (IBAction)btnGrabNowClicked:(id)sender {
    _voucherListingViewController = nil;
    [self.voucherListingViewController initWithLocation:self.currentHomeLocationModel];
    [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
    
}
- (IBAction)btnLoginClicked:(id)sender {
    
    //use this block if feeds api return token session over or app not login
    if (self.btnLoginClickedBlock) {
        self.btnLoginClickedBlock();
    }
    
}
- (IBAction)btnTestCliked:(id)sender {
    
//    SelectCategoryViewController* asd = [SelectCategoryViewController new];
//    [self presentViewController:asd animated:YES completion:nil];
    SeetiesShopViewController* temp = [SeetiesShopViewController new];
   
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:temp];
    
    [nav.navigationBar setHidden:YES];
    [temp initDataWithSeetiesID:@"56ab441c15772b70418b45e0"];
    [self presentViewController:nav animated:YES completion:nil];
    
   // _dealRedeemViewController = nil;
  //  [self.navigationController pushViewController:self.dealRedeemViewController animated:YES];

}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DelegateImplementation
-(void)viewDealDetailsClicked:(DealsModel*)dealsModel{
    if (dealsModel.arrDeals.count == 1) {
        self.dealDetailsViewController = nil;
        [self.dealDetailsViewController initDealModel:dealsModel.arrDeals[0]];
        [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
            [self.dealDetailsViewController setupView];
        }];
    }
    else{
        self.voucherListingViewController = nil;
        [self.voucherListingViewController initWithDealsModel:dealsModel];
        [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
    }
}

-(void)promoHasBeenRedeemed:(DealsModel *)dealsModel{
    [self.ibTableView reloadData];
}

#pragma mark - Declaration

-(CT3_EnableLocationViewController*)enableLocationViewController
{
    if (!_enableLocationViewController) {
        _enableLocationViewController = [CT3_EnableLocationViewController new];
    }
    
    return _enableLocationViewController;
}

-(DealManager *)dealManager{
    if(!_dealManager)
    {
        _dealManager = [DealManager Instance];
    }
    return _dealManager;
}

-(CT3_SearchListingViewController*)ct3_SearchListingViewController
{
    if (!_ct3_SearchListingViewController) {
        _ct3_SearchListingViewController = [CT3_SearchListingViewController new];
    }
    
    return _ct3_SearchListingViewController;
}
-(void)setLocationName:(NSString *)locationName
{
    _locationName = locationName;
    [self.btnLocation setTitle:_locationName forState:UIControlStateNormal];
}
-(SearchManager*)searchManager{
    if (!_searchManager) {
        _searchManager = [[SearchManager Instance] init];
    }
    return _searchManager;
}

-(SearchQuickBrowseListingController*)searchQuickBrowseListingController
{
    if(!_searchQuickBrowseListingController)
    {
        _searchQuickBrowseListingController = [SearchQuickBrowseListingController new];
        
        __weak typeof (self)weakSelf = self;
        _searchQuickBrowseListingController.didSelectHomeLocationBlock = ^(HomeLocationModel* model)
        {
            
            if (![model isEqual:weakSelf.currentHomeLocationModel]) {
                
                [weakSelf locationDidChange:model];
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
              
                [weakSelf requestServerForHomeUpdate:weakSelf.currentHomeLocationModel];
            }
         
        };
        
    }
    
    return _searchQuickBrowseListingController;
}
-(WalletListingViewController*)walletListingViewController
{
    if (!_walletListingViewController) {
        _walletListingViewController = [WalletListingViewController new];
    }
    
    return _walletListingViewController;
}

-(CT3_AnnouncementViewController*)announcementViewController
{
    if (!_announcementViewController) {
        _announcementViewController = [CT3_AnnouncementViewController new];
    }
    
    return _announcementViewController;
}

-(NSMutableArray*)arrHomeDeal
{
    if (!_arrHomeDeal) {
        _arrHomeDeal = [NSMutableArray new];
    }
    
    return _arrHomeDeal;
}
-(DealRedeemViewController*)dealRedeemViewController
{
    if (!_dealRedeemViewController) {
        _dealRedeemViewController = [DealRedeemViewController new];
    }
    return _dealRedeemViewController;
}

-(VoucherListingViewController*)voucherListingViewController
{
    if (!_voucherListingViewController) {
        _voucherListingViewController = [VoucherListingViewController new];
        
        __weak typeof (self)weakSelf = self;
        _voucherListingViewController.didSelectHomeLocationBlock = ^(HomeLocationModel* model)
        {
            if (![model isEqual:weakSelf.currentHomeLocationModel]) {
               
                [weakSelf locationDidChange:model];

            }
            else{
                [weakSelf requestServerForHomeUpdate:weakSelf.currentHomeLocationModel];
            }
        };
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

-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        _profileViewController =[ProfileViewController new];
    }
    return _profileViewController;
}

-(InviteFrenViewController*)inviteFrenViewController
{
    if (!_inviteFrenViewController) {
        _inviteFrenViewController = [InviteFrenViewController new];
    }
    
    return _inviteFrenViewController;
}
-(CollectionViewController*)displayCollectionViewController
{
    if (!_displayCollectionViewController) {
        _displayCollectionViewController = [CollectionViewController new];
    }
    
    return _displayCollectionViewController;
}

-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}

-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if (!_feedV2DetailViewController) {
        _feedV2DetailViewController = [FeedV2DetailViewController new];

    }
    
    return _feedV2DetailViewController;
}

-(AddCollectionDataViewController*)collectPostToCollectionVC
{
    if (!_collectPostToCollectionVC) {
        _collectPostToCollectionVC = [AddCollectionDataViewController new];
    }
    return _collectPostToCollectionVC;
}

-(NSMutableArray*)arrayNewsFeed
{
    if (!_arrayNewsFeed) {
        _arrayNewsFeed = [NSMutableArray new];
    }
    
    return _arrayNewsFeed;
}
-(CT3_MeViewController*)meViewController
{
    if (!_meViewController) {
        _meViewController = [CT3_MeViewController new];
    }
    return _meViewController;
}


-(NSString*)getDisplayLocation:(HomeLocationModel*)model
{
    
    return nil;
}

-(SearchLocationViewController*)searchLocationViewController{
 
    if (!_searchLocationViewController) {
        _searchLocationViewController = [SearchLocationViewController new];
        __weak typeof (self)weakself = self;
        
        _searchLocationViewController.homeLocationRefreshBlock = ^(HomeLocationModel* model)
        {
            
            isFirstLoad = YES;

            [weakself locationDidChange:model];
            
            [weakself.searchLocationViewController.navigationController popViewControllerAnimated:YES];

        };
    
    }
    
    return _searchLocationViewController;
}

-(PromoPopOutViewController *)promoPopoutViewController{
    if (!_profileViewController) {
        _promoPopoutViewController = [PromoPopOutViewController new];
        _promoPopoutViewController.promoPopOutDelegate = self;
    }
    return _promoPopoutViewController;
}

-(DealDetailsViewController *)dealDetailsViewController{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    return _dealDetailsViewController;
}

-(CT3_ReferalViewController *)referralViewController{
    if (!_referralViewController) {
        _referralViewController = [CT3_ReferalViewController new];
    }
    return _referralViewController;
}

-(CT3_InviteFriendViewController *)inviteFriendViewController{
    if (!_inviteFriendViewController) {
        _inviteFriendViewController = [CT3_InviteFriendViewController new];
    }
    return _inviteFriendViewController;
}

#pragma mark - DEFAULT
- (void)viewDidLoad {
    
    isFirstLoad = YES;
    
    isLoadingLocation = NO;
    
    [super viewDidLoad];
    
    lastUpdatedDateTime = @"";
    
    lastUpdatedLocation = @"";
    
    update_location_method = @"";
    
    [self initSelfView];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.ibTableView showLoading];
    
    
    if (self.needShowIntroView) {
        
        AppDelegate *appdelegate;
        
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appdelegate.landingViewController showIntroView];
        
        self.needShowIntroView = NO;
    }
    
    [self.btnLocation setTitle:self.locationName forState:UIControlStateNormal];

    if (!isFirstLoad) {
        [self requestServerForHomeUpdate:self.currentHomeLocationModel];
        [self.ibTableView showEmptyState];

    }
    
    
    if (![Utils isGuestMode]) {
        [self RequestServerForVouchersCount];
    }
    
//    @try {
//        [self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationNone];
//
//    } @catch (NSException *exception) {
//        
//    }
}

-(void)initSelfView
{
    [self.btnCurrentLocation useActivityIndicator:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    constTopScrollView.constant = TopBarHeight;

    ibHeaderBackgroundView.alpha = 0;
    [self initTableViewDelegate];
    
    isMiddleOfLoadingServer = NO;
    isMiddleOfLoadingHome = NO;
    
    [self initFooterView];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.ibTableView.estimatedRowHeight = [FeedType_FollowingPostTblCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    [self.ibTableView setupCustomEmptyView];
    self.ibTableView.customEmptyStateView.emptyStateDesc.text = LocalisedString(@"No Internet Connection");
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ADJUST VIEW

//-(void)adjustView
//{
//    
//    self.constantQuickBrowseHeight.constant = 42 + 105*(2);
//    [self.ibHeaderView refreshConstraint];
//    [self.ibHeaderView setHeight:(self.lastView.frame.size.height + self.lastView.frame.origin.y)];
//    [self.ibTableView reloadData];
//  // CGSize apple = [self.ibTableView intrinsicContentSize];
//    
//}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return self.arrHomeDeal.count;
    }
    else{// this is newsfeed row count
        
        if (self.arrayNewsFeed.count == 0) {
            return 0;
        }
        else{
            return self.arrayNewsFeed.count + 1;//add 1 for feed header

        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  

    if (indexPath.section == 0) {
        DealType type = [self.arrHomeDeal[indexPath.row] intValue];

        switch (type) {
            case DealType_Collection:
                return [DealType_mainTblCell getHeight];
                break;
                
            case DealType_QuickBrowse:
            {
                CGRect frame = [Utils getDeviceScreenSize];
                
                float cellWidth = ((frame.size.width - 16)/3);
                
                float titleHeight = 55.0f;
                
                return cellWidth + titleHeight + 10;
            }
                break;
                
            case DealType_SuperDeal:
            {
                return [DealType_DealOTDTblCell getHeight];
            }
                break;
                
            case DealType_Wallet:
            {
                return [DealType_YourWalletTblCell getHeight];
            }
                break;
            case DealType_Announcement:
            {
                return UITableViewAutomaticDimension;
            }
                break;

            case DealType_ReferFriends:
            {
                return [DealType_ReferFriendTblCell getHeight];
            }
                break;

            default:
                return 100;
                break;
        }
     
    }
    
    else{
        NSNumber* heightValue = [heightCache objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
        if (heightValue != 0) {
            return [heightValue floatValue];
        }
        //    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
        //    float height = frame.size.height;
        //  NSLog(@"row height (bbb) : %f", height);
        
        
        if (indexPath.row == 0) {
            return [FeedType_headerTblCell getHeight];
        }
        
        CTFeedTypeModel* typeModel;
        @try {
            
            typeModel = self.arrayNewsFeed[indexPath.row-1];

        }
        @catch (NSException *exception) {
            SLog(@"CTFeedTypeModel error in height for row");
        }
    
        
        switch (typeModel.feedType) {
            case FeedType_Collect_Suggestion:
                return [FeedType_CollectionSuggestedTblCell getHeight];
                break;
                
            case FeedType_Abroad_Quality_Post:
                return [FeedType_AbroadQualityPostTblCell getHeight];
                break;
                
            case FeedType_Suggestion_Featured:
            case FeedType_Suggestion_Friend:
            {
                
                
                return [FeedType_SuggestionFetureTblCell getHeight];
                // CGRect frame = [Utils getDeviceScreenSize];
                //return (frame.size.width/4) + 58 + 60;
                
            }
                break;
            case FeedType_Country_Promotion:
            {
                int cellheight = [FeedType_CountryPromotionTblCell getHeight];
                return cellheight;
            }
                break;
                
            case FeedType_Following_Post:
            case FeedType_Announcement_Welcome:
            case FeedType_Announcement_Campaign:
                
                return UITableViewAutomaticDimension;
                break;
            case FeedType_Following_Collection:
                
                return [FeedType_FollowingCollectionTblCell getHeight];
                break;
            case FeedType_Invite_Friend:
                return [FeedType_InviteFriendTblCell getHeight];
                break;
 //           case FeedType_Deal:
 //               return 0;
            default:
                return UITableViewAutomaticDimension;
                break;
        }

    }
  }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        DealType type = [self.arrHomeDeal[indexPath.row] intValue];
        switch (type) {
            default:
            case DealType_Collection:
            {
                static NSString *CellIdentifier = @"DealType_mainTblCell";
                DealType_mainTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DealType_mainTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:self.homeModel];
                 __weak typeof (self)weakSelf = self;
                cell.didSelectDealCollectionBlock = ^(DealCollectionModel* model)
                {
                    _voucherListingViewController = nil;
                    [self.voucherListingViewController initData:model withLocation:weakSelf.currentHomeLocationModel];
                   
                    [self.navigationController pushViewController:self.voucherListingViewController animated:YES onCompletion:^{
                        

                    }];
                };
                
                return cell;
            }
            case DealType_QuickBrowse:
            {
                static NSString *CellIdentifier = @"DealType_QuickBrowseTblCell";
                DealType_QuickBrowseTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DealType_QuickBrowseTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:self.homeModel.quick_browse];
                
                cell.didSelectDealBlock = ^(QuickBrowseModel* model)
                {
                    [self showSearchView:model];
                };
                return cell;

            }
                break;
            case DealType_SuperDeal:
            {
                static NSString *CellIdentifier = @"DealType_DealOTDTblCell";
                DealType_DealOTDTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DealType_DealOTDTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                if (self.homeModel) {
                    [cell initData:self.homeModel];

                }
                
               
                
                return cell;
                
            }
                break;
            case DealType_Wallet:
            {
                static NSString *CellIdentifier = @"DealType_YourWalletTblCell";
                DealType_YourWalletTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DealType_YourWalletTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                if (self.homeModel) {
                    
                    [cell initData];

                }
                return cell;
                
            }
                break;
            case DealType_Announcement:
            {
                static NSString *CellIdentifier = @"FeedType_CountryPromotionTblCell";
                FeedType_CountryPromotionTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_CountryPromotionTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initDataForHome:self.homeModel.announcements[0]];
                
                return cell;
                
            }

                break;
                
            case DealType_ReferFriends:
            {
                static NSString *CellIdentifier = @"DealType_ReferFriendTblCell";
                DealType_ReferFriendTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[DealType_ReferFriendTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData];
                
                return cell;
                
            }
                
                break;
        }
    }
    
    else{
        
        if (indexPath.row == 0) {
            /*Following Post*/
            static NSString *CellIdentifier = @"FeedType_headerTblCell";
            FeedType_headerTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[FeedType_headerTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            [cell initData];
            [cell setUserInteractionEnabled:NO];
            return cell;
        }
        
        CTFeedTypeModel* typeModel;
        @try {
            
            typeModel = self.arrayNewsFeed[indexPath.row - 1];

        }
        @catch (NSException *exception) {
            SLog(@"CTFeedTypeModel in section 1 error");
        }
        
        switch (typeModel.feedType) {
            case FeedType_Following_Post:
            case FeedType_Local_Quality_Post:
            {
                /*Following Post*/
                static NSString *CellIdentifier = @"FeedType_FollowingPostTblCell";
                FeedType_FollowingPostTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_FollowingPostTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel];
                cell.btnProfileClickedBlock = ^(ProfileModel* pModel)
                {
                    [self showProfilePageView:pModel];
                    
                };
                
                DraftModel* feedModel = typeModel.newsFeedData;
                __weak typeof (self)weakSelf = self;
                cell.btnCollectionDidClickedBlock = ^(void)
                {
                    
                    [weakSelf showCollectToCollectionView:feedModel];
                };
                
                cell.btnCollectionQuickClickedBlock = ^(void)
                {
                    [weakSelf requestServerForQuickCollection:feedModel];
                };
                
                cell.btnPostShareClickedBlock = ^(void)
                {
                    
                    NSString* imageURL;
                    
                    if (![Utils isArrayNull:feedModel.arrPhotos]) {
                        PhotoModel* pModel = feedModel.arrPhotos[0];
                        imageURL = pModel.imageURL;
                    }
                   
                    //New Sharing Screen
                    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
                    
                    dataToPost.title = [feedModel getPostTitle];
                    dataToPost.shareID = feedModel.post_id;
                    dataToPost.userID = feedModel.user_info.uid;
                    dataToPost.shareType = ShareTypePost;
                    dataToPost.postImageURL = imageURL;
                    
                    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];

                };
                
                [cell refreshConstraint];
                
                
                //Configure cell
                return cell;
                
            }
                break;
        
                
            default:
            case FeedType_Country_Promotion:
            {
                static NSString *CellIdentifier = @"FeedType_CountryPromotionTblCell";
                FeedType_CountryPromotionTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_CountryPromotionTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                [cell initData:typeModel];
                //Configure cell
                return cell;
                
            }
                break;
                
            case FeedType_Invite_Friend:
            {
                static NSString *CellIdentifier = @"FeedType_InviteFriendTblCell";
                FeedType_InviteFriendTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_InviteFriendTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel.dictData];
                return cell;
                break;
                
            }
            case FeedType_Announcement_Welcome:
            case FeedType_Announcement_Campaign:
            case FeedType_Announcement:
                
            {
                static NSString *CellIdentifier = @"FeedType_AnnouncementWelcomeTblCell";
                FeedType_AnnouncementWelcomeTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_AnnouncementWelcomeTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel];
                [cell refreshConstraint];
                
                return cell;
                break;
                
            }
                
            case FeedType_Collect_Suggestion:
            {
                static NSString *CellIdentifier = @"FeedType_CollectionSuggestedTblCell";
                FeedType_CollectionSuggestedTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_CollectionSuggestedTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel.arrCollections];
                
                __weak typeof(self) weakSelf = self;
                cell.btnSeeAllSuggestedCollectionClickBlock = ^(void)
                {
                    
                    
                    ProfileModel* model = [ProfileModel new];
                    model.uid = [Utils getUserID];
                    [weakSelf showCollectionListingView:model];
                };
                
                cell.didSelectCollectionBlock = ^(CollectionModel* model)
                {
                    [weakSelf showCollectioPageView:model];
                };
                
                return cell;
                break;
                
            }
            case FeedType_Abroad_Quality_Post:
            {
                
                static NSString *CellIdentifier = @"FeedType_AbroadQualityPostTblCell";
                FeedType_AbroadQualityPostTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_AbroadQualityPostTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel.arrPosts];
                cell.didSelectPostBlock = ^(DraftModel* model)
                {
                    [self showPostDetailView:model];
                };
                
                cell.btnProfileClickedBlock = ^(ProfileModel* model)
                {
                    [self showProfilePageView:model];
                };
                
                return cell;
                break;
                
            }
            case FeedType_Suggestion_Featured:
            case FeedType_Suggestion_Friend:
            {
                static NSString *CellIdentifier = @"FeedType_SuggestionFetureTblCell";
                FeedType_SuggestionFetureTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_SuggestionFetureTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                [cell initData:typeModel.arrSuggestedFeature];
                cell.didSelectprofileBlock = ^(ProfileModel* model)
                {
                    [self showProfilePageView:model];
                };
                return cell;
                break;
                
            }
                
            case FeedType_Following_Collection:
            {
                static NSString *CellIdentifier = @"FeedType_FollowingCollectionTblCell";
                FeedType_FollowingCollectionTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_FollowingCollectionTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                
                CollectionModel* collModel = typeModel.followingCollectionData;
                [cell initData:collModel];
                cell.btnShareCollectionClickedBlock = ^(void)
                {
                
                    NSString* imageURL;
                    if ([Utils isArrayNull:collModel.arrayFollowingCollectionPost]) {
                        
                        DraftModel* postModel = collModel.arrayFollowingCollectionPost[0];
                        
                        if ([Utils isArrayNull:postModel.arrPhotos]) {
                            PhotoModel* pModel = postModel.arrPhotos[0];
                            imageURL = pModel.imageURL;
                            
                        }
                    }
                    
//
                    //New Sharing Screen
                    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
                    
                    dataToPost.title = typeModel.followingCollectionData.name;
                    dataToPost.shareID = collModel.collection_id;
                    dataToPost.userID = collModel.user_info.uid;
                    dataToPost.shareType = ShareTypeCollection;
                    dataToPost.postImageURL = imageURL;
                    
                    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];

                    
                };
                
                return cell;
                break;
                
            }
                
        }
    }
   
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return self.ibHeaderView.frame.size.height;
//    }
//    else{
//        return 0;
//    }
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return self.ibHeaderView;
//    }
//    else{
//        return nil;
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTION;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        DealType type = [self.arrHomeDeal[indexPath.row] intValue];

        switch (type) {
            case DealType_SuperDeal:
            {
                _voucherListingViewController = nil;
                [self.voucherListingViewController initWithLocation:self.currentHomeLocationModel];
                [self.navigationController pushViewController:self.voucherListingViewController animated:YES onCompletion:^{
                    
                }];
            }
                break;
                
            case DealType_Wallet:
            {
                _walletListingViewController = nil;
                [self.navigationController pushViewController:self.walletListingViewController animated:YES];
            }
                break;
            case DealType_Announcement:
            {
                CTFeedTypeModel* typeModel = [CTFeedTypeModel new];
                typeModel.feedType = FeedType_Announcement;
                typeModel.announcementData = self.homeModel.announcements[0];
                
                switch (typeModel.announcementData.annType) {
                    case AnnouncementType_Promo:
                    {
                        if ([Utils isGuestMode]) {
                            [UIAlertView showWithTitle:LocalisedString(@"Please Login First") message:@"" cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                
                                if (buttonIndex == 1) {
                                    [Utils showLogin];
                                    
                                }
                            }];
                            return;
                        }
                        
                        if ([Utils isPhoneNumberVerified]) {
                            self.promoPopoutViewController = nil;
                            [self.promoPopoutViewController setViewType:PopOutViewTypeEnterPromo];
                            
                            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopoutViewController];
                            popupController.containerView.backgroundColor = [UIColor clearColor];
                            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
                            [popupController presentInViewController:self];
                            [popupController setNavigationBarHidden:YES];
                        }
                        else{
                            [Utils showVerifyPhoneNumber:self];
                        }
                    }
                        break;
                        
                    case AnnouncementType_Referral:
                    {
                        [self showReferralInvite];
                    }
                        break;
                        
                    default:
                        [self showNewAnnouncementView:typeModel];
                        break;
                }
            }
                break;
            
            case DealType_QuickBrowse:
            {
//                SLog(@"index == %ld",indexPath.row);
//                QuickBrowseModel* model = self.homeModel.quick_browse[indexPath.row];
//                [self showSearchView:model];

            }
            break;
                
            case DealType_ReferFriends:
            {
                [self showReferralInvite];
            }
                break;
            
            default:
                break;
        }
    }
    else
    {
        
        if (indexPath.row == 0) {
            return;
        }
        CTFeedTypeModel* feedTypeModel;
        FeedType type;
        @try {
            feedTypeModel = self.arrayNewsFeed[indexPath.row - 1];
            type = feedTypeModel.feedType;
        }
        @catch (NSException *exception) {
            
        }
       
        
        switch (type) {
            case FeedType_Following_Post:
            case FeedType_Local_Quality_Post:

            {
                [self showPostDetailView:feedTypeModel.newsFeedData];
              
            }
                break;
            case FeedType_Invite_Friend:
                [self showInvitefriendView];
                break;
                
            case FeedType_Announcement_Welcome:
                
                break;
                
            case FeedType_Following_Collection:
            {
                CollectionModel* collModel = feedTypeModel.followingCollectionData;
                [self showCollectioPageView:collModel];
                
            }
                break;
                
            case FeedType_Announcement:
            case FeedType_Announcement_Campaign:
            {
                AnnouncementModel* aModel = feedTypeModel.announcementData;
                
                switch (aModel.annType) {
                    case AnnouncementType_User:
                    {
                        ProfileModel* model = [ProfileModel new];
                        model.uid = aModel.relatedID;
                        [self showProfilePageView:model];

                    }
                        break;
                        
                    case AnnouncementType_Post:
                    {
                        DraftModel* dModel = [DraftModel new];
                        dModel.post_id = aModel.relatedID;
                        [self showPostDetailView:dModel];
                    }
                        break;
                        
                    case AnnouncementType_Promo:
                    {
                        if ([Utils isGuestMode]) {
                            [UIAlertView showWithTitle:LocalisedString(@"Please Login First") message:@"" cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                
                                if (buttonIndex == 1) {
                                    [Utils showLogin];
                                    
                                }
                            }];
                            return;
                        }
                        
                        if ([Utils isPhoneNumberVerified]) {
                            self.promoPopoutViewController = nil;
                            [self.promoPopoutViewController setViewType:PopOutViewTypeEnterPromo];
                            
                            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopoutViewController];
                            popupController.containerView.backgroundColor = [UIColor clearColor];
                            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
                            [popupController presentInViewController:self];
                            [popupController setNavigationBarHidden:YES];
                        }
                        else{
                            [Utils showVerifyPhoneNumber:self];
                        }
                    }
                        break;
                        
                    case AnnouncementType_NA:
                        
                        [self showNewAnnouncementView:feedTypeModel];
                        
                        break;
                   
                    default:
                    case AnnouncementType_URL:
                    {
                        [self showWebView:aModel];
                    }
                        break;
                }
               
            }
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == 0) {
        
        if ([cell isKindOfClass:[DealType_DealOTDTblCell class]]) {
            DealType_DealOTDTblCell *tempCell = (DealType_DealOTDTblCell*)cell;

            [tempCell stopAnimationScrolling];

        }
    }
   
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        heightCache = [NSCache new];
    });
    
    NSAssert(heightCache, @"Height cache must exist");
    
    NSString* key = [NSString stringWithFormat:@"%@",indexPath]; //Create a unique key here
    NSNumber* cachedValue = [heightCache objectForKey: key];
    
    if(!cachedValue)
    {
        CGSize size = cell.frame.size;
        [heightCache setObject: [NSNumber numberWithFloat: size.height] forKey: key];
    }
}


#pragma mark - SHOW OTHER VIEW


-(void)showSearchView:(QuickBrowseModel*)model
{
    _searchQuickBrowseListingController = nil;
    self.searchQuickBrowseListingController.selectedQuickBrowse = model;
    self.searchQuickBrowseListingController.quickBrowseModels = self.homeModel.quick_browse;
    self.searchQuickBrowseListingController.homeLocationModel = self.currentHomeLocationModel;
    [self.navigationController pushViewController:self.searchQuickBrowseListingController animated:YES];
}

-(void)showWebView:(AnnouncementModel*)model
{
    _ctWebViewController = nil;

    [self.navigationController pushViewController:self.ctWebViewController animated:YES onCompletion:^{
        [self.ctWebViewController initData:model];
    }];
     
    
}
-(void)showProfilePageView:(ProfileModel*)pModel
{
    _profileViewController = nil;
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
        
        if ([pModel.uid isEqualToString:[Utils getUserID]]) {
            [self.profileViewController initDataWithUserID:[Utils getUserID]];

        }
        else{
            [self.profileViewController initDataWithUserID:pModel.uid];
            
        }

    }];

}
-(void)showInvitefriendView
{
    self.inviteFriendViewController = nil;
    [self.navigationController pushViewController:self.inviteFriendViewController animated:YES];
}

-(void)showReferralInvite{
    self.referralViewController = nil;
    [self.navigationController pushViewController:self.referralViewController animated:YES];
}

-(void)showNewAnnouncementView:(CTFeedTypeModel*)model
{
    _announcementViewController = nil;
    
    [self.navigationController pushViewController:self.announcementViewController animated:YES onCompletion:^{
        
        [self.announcementViewController initData:model];
    }];
}

-(void)showPostDetailView:(DraftModel*)draftModel
{
    _feedV2DetailViewController = nil;
    [self.navigationController pushViewController:self.feedV2DetailViewController animated:YES onCompletion:^{
        
        [self.feedV2DetailViewController GetPostID:draftModel.post_id];
    }];
}
-(void)showCollectioPageView:(CollectionModel*)model
{
    
    _displayCollectionViewController = nil;
    [self.navigationController pushViewController:self.displayCollectionViewController animated:YES onCompletion:^{
        [self.displayCollectionViewController GetCollectionID:model.collection_id GetPermision:@"Others" GetUserUid:model.user_info.uid];
    }];

}

-(void)showCollectionListingView:(ProfileModel*)model
{
    
    _collectionListingViewController = nil;
    
    [self.collectionListingViewController setType:ProfileViewTypeOthers ProfileModel:model NumberOfPage:1 collectionType:CollectionListingTypeSuggestion];

    [self.navigationController pushViewController:self.collectionListingViewController animated:YES onCompletion:^{
        
      
    }];
}
-(void)showCollectToCollectionView:(DraftModel*)model
{
    
    if ([Utils isGuestMode]) {
        
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To Collect") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];

            }
        }];
        return;
    }
    _collectPostToCollectionVC = nil;
    [self.navigationController presentViewController:self.collectPostToCollectionVC animated:YES completion:^{
        PhotoModel*pModel;
        if (![Utils isArrayNull:model.arrPhotos]) {
            pModel = model.arrPhotos[0];
        }
        [self.collectPostToCollectionVC GetPostID:model.post_id GetImageData:pModel.imageURL];
    }];
    
}
#pragma mark - Request Server

-(void)RequestServerForVouchersCount{
    NSDictionary *dict = @{@"token": [Utils getAppToken]};
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers/count", [Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserVouchersCount parameter:dict appendString:appendString success:^(id object) {

        NSDictionary *dict = object[@"data"];
        int count = (int)[dict[@"count"] integerValue];
        [self.dealManager setWalletCount:count];
        
        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        
    }];
}

-(void)requestServerForQuickCollection:(DraftModel*)model
{
    
    NSDictionary* dictPost =  @{@"id": model.post_id};

    
    NSArray* array = @[dictPost];
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/0/collect",[Utils getUserID]];
    NSDictionary* dict = @{@"collection_id" : @"0",
                           @"token" : [Utils getAppToken],
                           @"posts" : array,
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_PUT serverRequestType:ServerRequestTypePutCollectPost parameter:dict appendString:appendString success:^(id object) {

        model.collect = @"1";
        [TSMessage showNotificationInViewController:self title:LocalisedString(@"System") subtitle:LocalisedString(@"Successfully collected to default Collection") type:TSMessageNotificationTypeSuccess];
        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        
    }];
}

-(void)requestServerForNewsFeed:(NSString*)latitude Longtitude:(NSString*)longtitude
{
    
    if (!isMiddleOfLoadingServer) {
        SLog(@"token :%@",[Utils getAppToken]);
        NSDictionary* dict;
        
        @try {
            
            dict = @{@"token" : [Utils getAppToken],
                                   @"offset":@(self.newsFeedModels.offset + self.newsFeedModels.limit),
                                   @"limit" : @(30),
                                   @"lat" : latitude,
                                   @"lng" : longtitude,
                                   };
        }
        @catch (NSException *exception) {
            
        }
        
        [self.ibTableView showLoading];

        isMiddleOfLoadingServer = YES;
        
        [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetNewsFeed parameter:dict appendString:nil success:^(id object) {
            isMiddleOfLoadingServer = NO;
            isFirstLoad = NO;
            NewsFeedModels* model = [[ConnectionManager dataManager] newsFeedModels];
            self.newsFeedModels = model;
            [self.arrayNewsFeed addObjectsFromArray:model.items];
            
            
            [self.ibTableView reloadData];
//            [self.ibTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

            [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] stopAnimating];
            [self.ibTableView hideAll];
            
            
            // ========== Offline ========== //
          //  [OfflineManager saveNewsfeed:self.arrayNewsFeed];
            // ========== Offline ========== //

            
        } failure:^(id object) {
            
            isFirstLoad = NO;

            [self.ibTableView.pullToRefreshView stopAnimating];
            isMiddleOfLoadingServer = NO;
            
            if ([Utils isArrayNull:self.arrayNewsFeed]) {
                [self.ibTableView showEmptyState];

            }
            else{
                [self.ibTableView hideAll];

            }
            
//            // ========== Offline ========== //
//
//            if ([Utils isArrayNull:self.arrayNewsFeed]) {
//                
//                self.arrayNewsFeed =[OfflineManager getNewsFeed];
//                
//                [self.ibTableView reloadData];
//
//            }
//            // ========== Offline ========== //

        }];

    }
    
}

-(void)requestServerForHome:(HomeLocationModel*)model
{
    
    if (isMiddleOfLoadingHome) {
        return;
    }
    NSDictionary* dict = @{@"timezone_offset" : [Utils getTimeZone],
                           @"type" : model.type?model.type:@"none",
                           @"lat" : model.latitude?model.latitude:@"",
                           @"lng" : model.longtitude?model.longtitude:@"",
                           @"place_id" : model.place_id?model.place_id:@"",
                           @"token" : [Utils getAppToken],
                           @"address_components" : model.dictAddressComponent?[Utils convertToJsonString:model.dictAddressComponent]:@"",
                           };
    [self.ibTableView showLoading];

    isMiddleOfLoadingHome = YES;

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetHome parameter:dict appendString:nil success:^(id object) {

        isFirstLoad = NO;
        isMiddleOfLoadingHome = NO;
        
        [self.ibTableView.pullToRefreshView stopAnimating];
        self.homeModel = [[ConnectionManager dataManager]homeModel];
        
        BOOL needToShowWallet = NO;
        DealManager* dealManager = [DealManager Instance];
        [dealManager setWalletCount:self.homeModel.wallet_count];
        [self.arrHomeDeal removeAllObjects];
        self.arrHomeDeal = nil;

        
        if (![Utils isArrayNull:self.homeModel.deal_collections]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Collection]];
            isDealCollectionShown = YES;
            ibHeaderBackgroundView.alpha = 0;
            constTopScrollView.constant = 0;
            needToShowWallet = YES;

        }
        else{
            isDealCollectionShown = NO;
            ibHeaderBackgroundView.alpha = 1;
            constTopScrollView.constant = TopBarHeight;
        }

        
        if (![Utils isArrayNull:self.homeModel.featured_deals]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_SuperDeal]];
            needToShowWallet = YES;

        }
        
        if (![Utils isGuestMode]) {
            if (needToShowWallet) {
                [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Wallet]];
            }
        }
        
        if (![Utils isGuestMode]) {
            if ([Utils hasReferralCampaign]) {
                [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_ReferFriends]];
            }
        }
        
        if (![Utils isArrayNull:self.homeModel.quick_browse]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_QuickBrowse]];
        }
       
        if (![Utils isArrayNull:self.homeModel.announcements]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Announcement]];

        }
        
       
        
        [self.ibTableView reloadData];

        [self.ibTableView hideAll];
        // [self.ibTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        //[self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationNone];
        
       // [self.ibTableView reloadData];
  
    } failure:^(id object) {
        
        isFirstLoad = NO;

        [self.ibTableView.pullToRefreshView stopAnimating];
        
        [self.ibTableView showEmptyState];

        isMiddleOfLoadingHome = NO;

    }];
}

-(void)requestServerForHomeUpdate:(HomeLocationModel*)model
{
    
    CLLocation* location  = [[SearchManager Instance]getAppLocation];
    
    NSDictionary* dict = @{@"lat" : model.latitude,
                           @"lng" : model.longtitude,
                           @"place_id" : model.place_id,
                           @"current_lat" : @(location.coordinate.latitude),
                           @"current_lng" : @(location.coordinate.longitude),
                           @"last_updated" : lastUpdatedDateTime,
                           @"last_location_updated" : lastUpdatedLocation,
                           @"token" : [Utils getAppToken],
                           @"type" : model.type?model.type:@"",
                           
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetHomeUpdater parameter:dict appendString:nil success:^(id object) {

        
        NSDictionary* returnDict = object[@"data"];
        
        lastUpdatedLocation = returnDict[@"last_location_updated"];
        lastUpdatedDateTime = returnDict[@"last_updated"];
        
        update_location_method = returnDict[@"update_location_method"];
        
        updateData = [returnDict[@"update_data"] boolValue];
        
        int type = 3;
        if ([update_location_method isEqualToString:LOCATION_INSTANT]) {
            type = 1;
        }
        else if ([update_location_method isEqualToString:LOCATION_PROMPT])
        {
            type = 2;

        }
        else
        {
            type = 3;
        }
        
        [self processUpdater:type];

        
    } failure:^(id object) {
        
    }];
}

-(void)processUpdater:(int)type//1 = instant || 2 = prompt || 3 = none
{

    switch (type) {
        case 1://instant
        {
            [self getGoogleGeoCode:^(HomeLocationModel *model) {
                
                [self locationDidChange:model];
                
            }];
        
        }
            
            break;
            
        case 2://prompt
        {
            [self getGoogleGeoCode:^(HomeLocationModel *model) {
                
                [UIAlertView showWithTitle:LocalisedString(@"system") message:[NSString stringWithFormat:@"%@ %@",LocalisedString(@"Do You want to update your location to"),model.locationName] cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        
                        [self locationDidChange:model];
                        
                    }
                    else{
                        
                        if (updateData) {
                            [self requestServerForHome:self.currentHomeLocationModel];
                            [self reloadNewsFeed];
                        }
                        
                        
                    }
                }];
                
                
            }];
        }
            
            break;

            
        case 3://none
        {
            
            if (updateData) {
                [self reloadNewsFeed];
                [self requestServerForHome:self.currentHomeLocationModel];
            }

                  }
            break;

            
        default:
            break;
    }
    
}

-(void)getGoogleGeoCode:(HomeLocationBlock)completionBlock
{
    
    CLLocation* location  = [[SearchManager Instance]getAppLocation];

    [self.searchManager getGoogleGeoCode:location completionBlock:^(id object) {
        
        NSDictionary* temp = [[NSDictionary alloc]initWithDictionary:object];
        NSArray* arrayLocations = [temp valueForKey:@"results"];
        
        if (![Utils isArrayNull:arrayLocations]) {
            NSDictionary* tempLocation = arrayLocations[0];
            
            SearchLocationDetailModel* model = [[SearchLocationDetailModel alloc]initWithDictionary:tempLocation error:nil];
            [model process];
            
            HomeLocationModel* hModel = [HomeLocationModel new];
            hModel.timezone = @"";
            hModel.type = Type_Current;
            hModel.latitude = model.lat;
            hModel.longtitude = model.lng;
            hModel.place_id = @"";
            hModel.address_components.country = model.country;
            hModel.address_components.route = model.route;
            hModel.address_components.locality = model.city;
            hModel.address_components.administrative_area_level_1 = model.state;
            hModel.address_components.political = model.political;
            hModel.locationName = model.locationName;
            
            if (completionBlock) {
                completionBlock(hModel);
            }
           
        }
        
    }Error:nil];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    
//    float reload_distance = 100;
//    if (bottomEdge >= scrollView.contentSize.height -  reload_distance) {
//        
//        if(![Utils isStringNull:self.newsFeedModels.paging.next])
//        {
//            [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] startAnimating];
//
//            [self requestServerForNewsFeed];
//        }
//      
//    }
//}

#pragma mark - View Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.view.frame.size.height/2) {
       
        if(![Utils isStringNull:self.newsFeedModels.paging.next])
        {
            [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] startAnimating];
            
            [self requestServerForNewsFeed:self.currentHomeLocationModel.latitude Longtitude:self.currentHomeLocationModel.longtitude];
        }
    }
    
    
    if (!isDealCollectionShown) {
        ibHeaderBackgroundView.alpha = 1;
        
        return;
    }
    /*for top navigation bar alpha setting*/
    int profileBackgroundHeight = TopBarHeight;
    
    if (scrollView.contentOffset.y > profileBackgroundHeight)
    {
        ibHeaderBackgroundView.alpha = 1;
                
    }
    else{
        float adjustment = (scrollView.contentOffset.y
                            )/(profileBackgroundHeight);
        // SLog(@"adjustment : %f",adjustment);
        ibHeaderBackgroundView.alpha = adjustment;
    }

}

-(void)initFooterView
{
    ibActivityIndicator.tag = 10;
    ibActivityIndicator.hidesWhenStopped = YES;
    self.ibTableView.tableFooterView = self.ibFooterView;

}

-(void)scrollToTop:(BOOL)animation
{
    @try {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.ibTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    @catch (NSException *exception) {
        
    }
   
}

#pragma mark - Reload

-(void)reloadNewsFeed
{
    self.newsFeedModels = nil;
    
    if (![Utils isArrayNull:self.arrayNewsFeed]) {
        [self.arrayNewsFeed removeAllObjects];
        [self.ibTableView reloadData];
    }
    [heightCache removeAllObjects];
    heightCache = nil;
    heightCache = [NSCache new];
    [self requestServerForNewsFeed:self.currentHomeLocationModel.latitude Longtitude:self.currentHomeLocationModel.longtitude];
}


-(void)reloadData
{
    
    if ([self validateLocalLocation]) {
        
        [self loadHomeData];
        
    }
    
    else{
    
        
        if (![[self.navigationController viewControllers] containsObject:self.searchLocationViewController]) {
            _searchLocationViewController = nil;
            
            
            [self.navigationController pushViewController:self.searchLocationViewController animated:NO onCompletion:^{
                [self.searchLocationViewController hideBackButton];
            }];
        }
        
    }
}

-(void)loadHomeData
{
    [self scrollToTop:NO];
    
    if (![Utils isStringNull:[Utils getAppToken]]) {
        
        NSDictionary* dict = [Utils getSavedUserLocation];
        
        HomeLocationModel* model = [HomeLocationModel new];
        model.type = @"none";
        model.latitude = dict[KEY_LATITUDE];
        model.longtitude = dict[KEY_LONGTITUDE];
        model.place_id = dict[KEY_PLACE_ID];
        model.countryId = [dict[KEY_COUNTRY_ID] intValue];
        model.locationName = dict[KEY_LOCATION];
        model.type = dict[KEY_SOURCE_TYPE];
        model.locationName = dict[KEY_LOCATION];
        
        self.locationName = model.locationName;

        self.currentHomeLocationModel = model;
        
        [self reloadNewsFeed];

        [self requestServerForHome:model];

    }
    else
    {
        NSDictionary* dict = [Utils getSavedUserLocation];
        
        
        HomeLocationModel* model = [HomeLocationModel new];
        model.type = @"none";
        model.latitude = dict[KEY_LATITUDE];
        model.longtitude = dict[KEY_LONGTITUDE];
        model.place_id = dict[KEY_PLACE_ID];
        model.countryId = [dict[KEY_COUNTRY_ID] intValue];
        model.locationName = dict[KEY_LOCATION];
        self.locationName = dict[KEY_LOCATION];
        
        self.currentHomeLocationModel = model;
        [self requestServerForHome:model];
        [self reloadNewsFeed];

    }

}

#pragma mark - Validation
-(BOOL)validateLocalLocation
{
    
    NSDictionary* dict = [Utils getSavedUserLocation];
    
    
    @try {
        if (dict) {
            
            NSString* latitude = dict[KEY_LATITUDE];
            NSString* location = dict[KEY_LOCATION];
            
            if (![Utils isStringNull:location]) {
                return YES;
            }
            else if(![Utils isStringNull:latitude])
            {
                return YES;
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        return NO;
        
    }
    
    return NO;
    
}
#pragma mark - Location
-(void)getCurrentLocationGoogleGeoCode:(CLLocation*)location
{
    self.btnCurrentLocation.enabled = NO;

    [self.searchManager getGoogleGeoCode:location completionBlock:^(id object) {
        
        [LoadingManager hide];

        self.btnCurrentLocation.enabled = YES;

        NSDictionary* temp = [[NSDictionary alloc]initWithDictionary:object];
        NSArray* arrayLocations = [temp valueForKey:@"results"];
        
        if (![Utils isArrayNull:arrayLocations]) {
            NSDictionary* tempLocation = arrayLocations[0];
            
            SearchLocationDetailModel* model = [[SearchLocationDetailModel alloc]initWithDictionary:tempLocation error:nil];
            [model process];
            
            HomeLocationModel* hModel = [HomeLocationModel new];
            hModel.timezone = @"";
            hModel.type = Type_Current;
            hModel.latitude = model.lat;
            hModel.longtitude = model.lng;
            hModel.place_id = @"";
            
            
            AppInfoModel* appInfo = [[ConnectionManager dataManager]appInfoModel];
            hModel.locationName = [model locationNameWithCustomKey:appInfo.countries.current_country.place_display_fields];
            hModel.countryId = appInfo.countries.current_country.country_id;
            
            
            isLoadingLocation = NO;

            [UIAlertView showWithTitle:[LanguageManager stringForKey:@"Are you in {!location name}?" withPlaceHolder:@{@"{!location name}":hModel.locationName?hModel.locationName:@""}]  message:LocalisedString(@"Would you like to set this as your current location?") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    [self locationDidChange:hModel];
                    
                }
            }];
            
        }
    }Error:^{
        
        self.btnCurrentLocation.enabled = YES;

    }];
}

//for updater
-(void)locationDidChange:(HomeLocationModel*)model
{
    self.currentHomeLocationModel = model;
    
    [Utils saveUserLocation:self.currentHomeLocationModel.locationName Longtitude:self.currentHomeLocationModel.longtitude Latitude:self.currentHomeLocationModel.latitude PlaceID:self.currentHomeLocationModel.place_id CountryID:self.currentHomeLocationModel.countryId SourceType:self.currentHomeLocationModel.type];
    self.locationName = self.currentHomeLocationModel.locationName;
    [self reloadNewsFeed];
    [self requestServerForHome:model];
}

@end

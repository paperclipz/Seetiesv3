//
//  CT3_NewsFeedViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CT3_NewsFeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedSquareCollectionViewCell.h"
#import "QuickBrowserCollectionTableViewCell.h"

#import "FeedType_FollowingPostTblCell.h"
#import "FeedType_Two_TableViewCell.h"
#import "FeedType_CountryPromotionTblCell.h"
#import "FeedType_InviteFriendTblCell.h"
#import "FeedType_AnnouncementWelcomeTblCell.h"
#import "FeedType_CollectionSuggestedTblCell.h"
#import "FeedType_AbroadQualityPostTblCell.h"
#import "FeedType_SuggestionFetureTblCell.h"

#import "FeedType_FollowingCollectionTblCell.h"

#import "AddCollectionDataViewController.h"
#import "FeedV2DetailViewController.h"
#import "CollectionListingViewController.h"
#import "CollectionViewController.h"
#import "InviteFrenViewController.h"
#import "ProfileViewController.h"
#import "AnnounceViewController.h"
#import "CTWebViewController.h"

#import "DealType_mainTblCell.h"
#import "DealType_QuickBrowseTblCell.h"
#import "DealType_DealOTDTblCell.h"
#import "DealType_YourWalletTblCell.h"
#import "SearchViewV2Controller.h"
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

static NSCache* heightCache = nil;
#define TopBarHeight 64.0f
#define NUMBER_OF_SECTION 2
@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isMiddleOfLoadingServer;
    __weak IBOutlet UIActivityIndicatorView *ibActivityIndicator;
    __weak IBOutlet UIImageView *ibHeaderBackgroundView;
    __weak IBOutlet NSLayoutConstraint *constTopScrollView;
    BOOL isFirstLoad;
    
    NSString* lastUpdatedLocation;
    NSString* lastUpdatedDateTime;
    BOOL updateLocation;
    BOOL updateData;


    BOOL isDealCollectionShown;

    
}
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibIntroCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantQuickBrowseHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *ibQuickBrowseCollectionView;

@property(nonatomic,strong)NSMutableArray* arrCacheHeight;
@property (strong, nonatomic) IBOutlet UIView *ibFooterView;

/* Model */
@property(nonatomic,strong)NSMutableArray* arrayNewsFeed;
@property(nonatomic,strong)NewsFeedModels* newsFeedModels;
@property(nonatomic,strong)HomeModel* homeModel;
@property(nonatomic,strong)NSMutableArray* arrHomeDeal;

@property(nonatomic,strong)HomeLocationModel* currentHomeLocationModel;

@property(nonatomic,strong)NSString* locationName;
@property (nonatomic, strong) SearchManager *searchManager;


/* Model */

/*Controller*/
@property(nonatomic,strong)AddCollectionDataViewController* collectPostToCollectionVC;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@property(nonatomic,strong)FeedV2DetailViewController* feedV2DetailViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)CollectionViewController* displayCollectionViewController;
@property(nonatomic,strong)InviteFrenViewController* inviteFrenViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)AnnounceViewController* announceViewController;
@property(nonatomic,strong)CTWebViewController* ctWebViewController;
@property(nonatomic,strong)SearchViewV2Controller* searchViewV2Controller;
@property(nonatomic,strong)VoucherListingViewController* voucherListingViewController;

@property(nonatomic)DealRedeemViewController* dealRedeemViewController;
@property(nonatomic,strong)CT3_MeViewController* meViewController;
@property(nonatomic, strong) SearchLocationViewController *searchLocationViewController;
@property(nonatomic, strong) CT3_AnnouncementViewController *announcementViewController;
@property(nonatomic)WalletListingViewController* walletListingViewController;
@property(nonatomic)SearchQuickBrowseListingController* searchQuickBrowseListingController;

@property(nonatomic)CT3_SearchListingViewController* ct3_SearchListingViewController;
/*Controller*/

@end

@implementation CT3_NewsFeedViewController

#pragma mark -IBACTION

- (IBAction)btnSearchLocationClicked:(id)sender {
    
    _searchLocationViewController = nil;
    [self.navigationController pushViewController:self.searchLocationViewController animated:YES];
}

- (IBAction)btnSearchClicked:(id)sender {
    
 //   _searchViewV2Controller = nil;
 //   [self.navigationController pushViewController:self.searchViewV2Controller animated:YES];
    
    _ct3_SearchListingViewController = nil;
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}

- (IBAction)btnGrabNowClicked:(id)sender {
    _voucherListingViewController = nil;
    [self.voucherListingViewController initWithLocation:self.currentHomeLocationModel filterCurrency:self.homeModel.filter_currency quickBrowseModel:[self.homeModel.quick_browse mutableCopy]];
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

#pragma mark - Declaration

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
            weakSelf.currentHomeLocationModel = model;
            weakSelf.locationName = weakSelf.currentHomeLocationModel.locationName;
            [weakSelf requestServerForHome:weakSelf.currentHomeLocationModel];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
    }
    
    return _voucherListingViewController;
}
-
(SearchViewV2Controller*)searchViewV2Controller
{
    if (!_searchViewV2Controller) {
        _searchViewV2Controller = [SearchViewV2Controller new];
    }
    
    return _searchViewV2Controller;
}

-(NSMutableArray*)arrCacheHeight
{
    if (!_arrCacheHeight) {
        _arrCacheHeight = [NSMutableArray new];
    }
    return _arrCacheHeight;
}
-(CTWebViewController*)ctWebViewController
{
    if (!_ctWebViewController) {
        _ctWebViewController = [CTWebViewController new];
    }
    
    return _ctWebViewController;
}

-(AnnounceViewController*)announceViewController
{
    if (!_announceViewController) {
        _announceViewController = [AnnounceViewController new];
    }
    
    return _announceViewController;
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
-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [ShareV2ViewController new];
    }
    return _shareV2ViewController;
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

            weakself.currentHomeLocationModel = model;
            
            [Utils saveUserLocation:weakself.currentHomeLocationModel.locationName Longtitude:weakself.currentHomeLocationModel.longtitude Latitude:weakself.currentHomeLocationModel.latitude PlaceID:weakself.currentHomeLocationModel.place_id];
            weakself.locationName = weakself.currentHomeLocationModel.locationName;
            [weakself.searchLocationViewController.navigationController popViewControllerAnimated:YES];
            
            [weakself reloadNewsFeed];
            [weakself requestServerForHome:model];

        };
    
    }
    
    return _searchLocationViewController;
}

#pragma mark - DEFAULT
- (void)viewDidLoad {
    
    isFirstLoad = YES;
    [super viewDidLoad];
    
    lastUpdatedDateTime = @"";
    
    lastUpdatedLocation = @"";
    
    [self initSelfView];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.btnLocation setTitle:self.locationName forState:UIControlStateNormal];

    if (!isFirstLoad) {
        [self requestServerForHomeUpdate:self.currentHomeLocationModel];
    }
}

-(void)initSelfView
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    constTopScrollView.constant = TopBarHeight;

    ibHeaderBackgroundView.alpha = 0;
    [self initTableViewDelegate];
    [self initCollectionViewDelegate];
    
    isMiddleOfLoadingServer = NO;
    
    [self initFooterView];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.ibTableView.estimatedRowHeight = [FeedType_FollowingPostTblCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)initCollectionViewDelegate
{

    self.ibIntroCollectionView.delegate = self;
    self.ibIntroCollectionView.dataSource = self;
    [self.ibIntroCollectionView registerClass:[FeedSquareCollectionViewCell class] forCellWithReuseIdentifier:@"FeedSquareCollectionViewCell"];
    
    [self.ibQuickBrowseCollectionView registerClass:[QuickBrowserCollectionTableViewCell class] forCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell"];
    self.ibQuickBrowseCollectionView.delegate = self;
    self.ibQuickBrowseCollectionView.dataSource = self;
    self.ibQuickBrowseCollectionView.backgroundColor = [UIColor clearColor];
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
                return [FeedType_CountryPromotionTblCell getHeight];
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
            case FeedType_Deal:
                return 0;
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
                    [self.voucherListingViewController initData:model withLocation:weakSelf.currentHomeLocationModel filterCurrency:self.homeModel.filter_currency quickBrowseModel:[self.homeModel.quick_browse mutableCopy]];
                   
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
                    [cell initData:self.homeModel.superdeals];

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
                    [cell initData:self.homeModel.wallet_count];

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
        }
    }
    
    else{
        
        if (indexPath.row == 0) {
            /*Following Post*/
            static NSString *CellIdentifier = @"FeedType_headerTblCell";
            FeedType_headerTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_headerTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
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
                    
                    _shareV2ViewController = nil;
                    UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
                    [naviVC setNavigationBarHidden:YES animated:NO];
                    
                    NSString* imageURL;
                    
                    if (![Utils isArrayNull:feedModel.arrPhotos]) {
                        PhotoModel* pModel = feedModel.arrPhotos[0];
                        imageURL = pModel.imageURL;
                    }
                    
                    [self.shareV2ViewController share:@"" title:[feedModel getPostTitle] imagURL:imageURL shareType:ShareTypePost shareID:feedModel.post_id userID:feedModel.user_info.uid];
                    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
                    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
                    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
                    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
                    [self presentViewController:formSheetController animated:YES completion:nil];
                    
                };
                
                [cell refreshConstraint];
                
                
                //Configure cell
                return cell;
                
            }
                break;
            case FeedType_Deal:
            {
                /*Following Post*/
                static NSString *CellIdentifier = @"FeedType_Two_TableViewCell";
                FeedType_Two_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[FeedType_Two_TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
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
                    _shareV2ViewController = nil;
                    UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
                    [naviVC setNavigationBarHidden:YES animated:NO];
                    
                    NSString* imageURL;
                    if ([Utils isArrayNull:collModel.arrayFollowingCollectionPost]) {
                        
                        DraftModel* postModel = collModel.arrayFollowingCollectionPost[0];
                        
                        if ([Utils isArrayNull:postModel.arrPhotos]) {
                            PhotoModel* pModel = postModel.arrPhotos[0];
                            imageURL = pModel.imageURL;
                            
                        }
                    }
                    
                    [self.shareV2ViewController share:@"" title:typeModel.followingCollectionData.name imagURL:imageURL shareType:ShareTypeCollection shareID:collModel.collection_id userID:collModel.user_info.uid];
                    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
                    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
                    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
                    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
                    [self presentViewController:formSheetController animated:YES completion:nil];
                    
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
                [self.voucherListingViewController initWithLocation:self.currentHomeLocationModel filterCurrency:self.homeModel.filter_currency quickBrowseModel:[self.homeModel.quick_browse mutableCopy]];
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
                [self showNewAnnouncementView:typeModel];

            }
                break;
            
            case DealType_QuickBrowse:
            {
//                SLog(@"index == %ld",indexPath.row);
//                QuickBrowseModel* model = self.homeModel.quick_browse[indexPath.row];
//                [self showSearchView:model];

            }
            break;
            
            default:
                break;
        }
    }
    else
    {
        CTFeedTypeModel* feedTypeModel = self.arrayNewsFeed[indexPath.row];
        FeedType type = feedTypeModel.feedType;
        
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


#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.ibIntroCollectionView) {
        return 1;

    }
    else{
        return 6;
    
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.ibIntroCollectionView) {
        FeedSquareCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedSquareCollectionViewCell" forIndexPath:indexPath];
        return cell;

    }
    else{
    
        QuickBrowserCollectionTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
}


#pragma mark - SHOW OTHER VIEW


-(void)showSearchView:(QuickBrowseModel*)model
{
    _searchQuickBrowseListingController = nil;
    self.searchQuickBrowseListingController.keyword = model.name;
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
            [self.profileViewController requestAllDataWithType:ProfileViewTypeOwn UserID:[Utils getUserID]];

        }
        else{
            [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:pModel.uid];

        }

    }];

}
-(void)showInvitefriendView
{
    _inviteFrenViewController  = nil;
    [self.navigationController pushViewController:self.inviteFrenViewController animated:YES];
}

-(void)showNewAnnouncementView:(CTFeedTypeModel*)model
{
    _announcementViewController = nil;
    
    [self.navigationController pushViewController:self.announcementViewController animated:YES onCompletion:^{
        
        [self.announcementViewController initData:model];
    }];
}
-(void)showAnnouncementView:(CTFeedTypeModel*)model
{
    _announceViewController = nil;
    
    [self.navigationController pushViewController:self.announceViewController animated:YES onCompletion:^{
    
        [self.announceViewController initData:model];
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
        
        [MessageManager showMessageWithCallBack:LocalisedString(@"system") SubTitle:LocalisedString(@"Please Login to Collect") Type:TSMessageNotificationTypeWarning ButtonOnClick:^{
            
            [Utils showLogin];
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

-(void)requestServerForQuickCollection:(DraftModel*)model
{

    NSDictionary* dictPost =  @{@"id": model.post_id};

    
    NSArray* array = @[dictPost];
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/0/collect",[Utils getUserID]];
    NSDictionary* dict = @{@"collection_id" : @"0",
                           @"token" : [Utils getAppToken],
                           @"posts" : array,
                           };
    
    [[ConnectionManager Instance]requestServerWithPut:ServerRequestTypePutCollectPost param:dict appendString:appendString completeHandler:^(id object) {

        model.collect = @"1";
        [TSMessage showNotificationInViewController:self title:LocalisedString(@"System") subtitle:LocalisedString(@"Successfully collected to default Collection") type:TSMessageNotificationTypeSuccess];
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
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
                                   @"limit" : @(5),
                                   @"lat" : latitude,
                                   @"lng" : longtitude,
                                   };

        }
        @catch (NSException *exception) {
            
        }
        
        isMiddleOfLoadingServer = YES;
        [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNewsFeed param:dict appendString:nil completeHandler:^(id object) {
            isMiddleOfLoadingServer = NO;
            isFirstLoad = NO;
            NewsFeedModels* model = [[ConnectionManager dataManager] newsFeedModels];
            self.newsFeedModels = model;
            [self.arrayNewsFeed addObjectsFromArray:model.items];
            [self.ibTableView reloadData];
            
            [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] stopAnimating];
        } errorBlock:^(id object) {
            isMiddleOfLoadingServer = NO;

        }];

    }
    
}

-(void)requestServerForHome:(HomeLocationModel*)model
{
    
    NSDictionary* dict = @{@"timezone_offset" : [Utils getTimeZone],
                           @"type" : model.type,
                           @"lat" : model.latitude?model.latitude:@"",
                           @"lng" : model.longtitude?model.longtitude:@"",
                           @"place_id" : model.place_id?model.place_id:@"",
                           @"token" : [Utils getAppToken],
                           @"address_components" : model.dictAddressComponent?[Utils convertToJsonString:model.dictAddressComponent]:@"",
                           };
    
  

    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHome param:dict appendString:nil completeHandler:^(id object) {
        
        self.homeModel = [[ConnectionManager dataManager]homeModel];
        [self.arrHomeDeal removeAllObjects];
        self.arrHomeDeal = nil;

        
        if (![Utils isArrayNull:self.homeModel.deal_collections]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Collection]];
            isDealCollectionShown = YES;
            ibHeaderBackgroundView.alpha = 0;
            constTopScrollView.constant = 0;


        }
        else{
            isDealCollectionShown = NO;
            ibHeaderBackgroundView.alpha = 1;
            constTopScrollView.constant = TopBarHeight;
        }

        if (![Utils isArrayNull:self.homeModel.superdeals]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_SuperDeal]];
 
        }
        
        if (![Utils isGuestMode]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Wallet]];
        }
        
        if (![Utils isArrayNull:self.homeModel.quick_browse]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_QuickBrowse]];
        }
       
        if (![Utils isArrayNull:self.homeModel.announcements]) {
            [self.arrHomeDeal addObject:[NSNumber numberWithInt:DealType_Announcement]];

        }
        
        [self.ibTableView reloadData];
        //[self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationNone];
        
       // [self.ibTableView reloadData];
  
    } errorBlock:^(id object) {
        
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
                           @"token" : [Utils getAppToken]};
    
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetHomeUpdater param:dict appendString:nil completeHandler:^(id object) {
        
        NSDictionary* returnDict = object[@"data"];
        
        lastUpdatedLocation = returnDict[@"last_location_updated"];
        lastUpdatedDateTime = returnDict[@"last_updated"];
        
        
        updateLocation = [returnDict[@"update_location"] boolValue];
        updateData = [returnDict[@"update_data"] boolValue];
        [self processUpdater];

        
    } errorBlock:^(id object) {
        
    }];
}

-(void)processUpdater
{
    //updateLocation = YES;
    //updateData = YES;
    if (updateLocation) {
        
        [self getGoogleGeoCode:^(HomeLocationModel *model) {
            
            [UIAlertView showWithTitle:LocalisedString(@"system") message:[NSString stringWithFormat:@"%@ %@",LocalisedString(@"Do You want to update your location to"),model.locationName] cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
                SLog(@"buttonIndex = %ld",(long)buttonIndex);
                if (buttonIndex == 1) {
                    
                    self.currentHomeLocationModel = model;
                    
                    [Utils saveUserLocation:self.currentHomeLocationModel.locationName Longtitude:self.currentHomeLocationModel.longtitude Latitude:self.currentHomeLocationModel.latitude PlaceID:self.currentHomeLocationModel.place_id];
                    self.locationName = self.currentHomeLocationModel.locationName;
                    [self reloadNewsFeed];
                    [self requestServerForHome:model];

                    
                    
                }
                else{
                    
                    if (updateData) {
                        [self requestServerForHome:self.currentHomeLocationModel];
                        
                    }
                    
                    
                }
            }];

            
        }];
        
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
            hModel.type = @"current";
            hModel.latitude = model.lat;
            hModel.longtitude = model.lng;
            hModel.place_id = @"";
            hModel.address_components.country = model.country;
            hModel.address_components.route = model.route;
            hModel.address_components.locality = model.city;
            hModel.address_components.administrative_area_level_1 = model.state;
            hModel.address_components.political = model.political;
            
            if (![Utils isStringNull:model.subLocality]) {
                hModel.locationName = model.subLocality;

            }
            else{
                hModel.locationName = model.subLocality_lvl_1;

            }
            
            if (completionBlock) {
                completionBlock(hModel);
            }
           
        }
        
    }];
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
    [self.ibTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animation];
    [self.ibTableView reloadData];
}


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
        model.locationName = dict[KEY_LOCATION];
        self.locationName = dict[KEY_LOCATION];

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
        model.locationName = dict[KEY_LOCATION];
        self.locationName = dict[KEY_LOCATION];
        
        self.currentHomeLocationModel = model;
        [self requestServerForHome:model];
        [self reloadNewsFeed];

    }

}

@end

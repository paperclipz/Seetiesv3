//
//  SeetiesShopViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiesShopViewController.h"

#import "SeShopDetailView.h"
#import "SeDealsView.h"
#import "MapViewController.h"

#import "SeCollectionView.h"
#import "SeRecommendations.h"
#import "SeNearbySeetishop.h"
#import "UINavigationController+Transition.h"
#import "LikesListingViewController.h"
#import "PhotoListViewController.h"
#import "SeetiesMoreInfoViewController.h"
#import "SeetiShopListingViewController.h"
#import "FeedV2DetailViewController.h"
#import "CollectionViewController.h"
#import "CollectionListingViewController.h"
#import "SeRecommendationsSeeAllViewController.h"
#import "ProfileViewController.h"

#import "SeetiesProfileView.h"
#import "BranchOutletTblCell.h"
#import "DealDetailsViewController.h"
#import "VoucherListingViewController.h"
#import "ReportProblemViewController.h"

#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"

@interface SeetiesShopViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UIView *ibBranchView;
    __weak IBOutlet UIButton *btnTranslate;
    BOOL branchIsShow;

    __weak IBOutlet UIButton *btnOutlet;
    __weak IBOutlet UILabel *lblSelectOutlet;
}


@property (weak, nonatomic)IBOutlet UITableView *ibTblSelectOutletView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgDropDownIndicator;

@property (weak, nonatomic) IBOutlet UILabel *lblBigShopName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTranslateWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnShareWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
//================ CONTROLLERS ====================//
@property (nonatomic,strong)SeetiesShopViewController* seetiesShopViewController;

@property (nonatomic,strong)MapViewController* mapViewController;
@property (nonatomic,strong)PhotoListViewController* photoListViewController;
@property (nonatomic,strong)SeetiesMoreInfoViewController* seetiesMoreInfoViewController;
@property (nonatomic,strong)SeetiShopListingViewController* seetiShopListingViewController;
@property (nonatomic,strong)FeedV2DetailViewController* PostDetailViewController;
@property (nonatomic,strong)CollectionViewController* CollectionDetailViewController;
@property (nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property (nonatomic,strong)SeRecommendationsSeeAllViewController* seRecommendationsSeeAllViewController;
@property (nonatomic,strong)ProfileViewController* profileViewController;
@property (nonatomic,strong)VoucherListingViewController* voucherListingViewController;
@property (nonatomic)ReportProblemViewController* reportProblemViewController;


//$$============== CONTROLLERS ==================$$//
@property (weak, nonatomic) IBOutlet UIImageView *ibTopPaddingOverlay;

@property (weak, nonatomic) IBOutlet UIImageView *ibImgViewTopPadding;
@property (nonatomic,strong)SeShopDetailView* seShopDetailView;
@property (nonatomic,strong)SeDealsView* seDealsView;
@property (nonatomic,strong)SeCollectionView* seCollectionView;
@property (nonatomic,strong)SeRecommendations* seRecommendations;
@property (nonatomic,strong)SeNearbySeetishop* seNearbySeetishop;
@property (nonatomic,strong)SeetiesProfileView* seProfileView;

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property(nonatomic,assign)SeetiesShopType seetiesType;
@property(nonatomic, strong)NSMutableArray* arrViews;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgViewOtherPadding;
@property(nonatomic,assign)MKCoordinateRegion region;
@property (weak, nonatomic) IBOutlet UILabel *lblShopGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UIView *ibReportShopView;
@property (weak, nonatomic) IBOutlet UILabel *lblReportTitle;

@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;
@property(nonatomic,assign)float shopLat;
@property(nonatomic,assign)float shopLng;

@property(nonatomic,strong)SeShopDetailModel* seShopModel;

@property(nonatomic)DealDetailsViewController* dealDetailsViewController;
@end

@implementation SeetiesShopViewController

#pragma mark - IBACTION
- (IBAction)btnReportShopClicked:(id)sender {
    
    _reportProblemViewController = nil;
    
    [self.reportProblemViewController initDataReportShop:self.seShopModel];
    [self.navigationController pushViewController:self.reportProblemViewController animated:YES];
}


- (IBAction)btnCloseBranchClicked:(id)sender {
    
    [self showBranchView:NO withAnimation:YES];

}
- (IBAction)btnBranchClicked:(id)sender {
    
    [self showBranchView:!branchIsShow withAnimation:YES];
}

-(void)showBranchView:(BOOL)isShow withAnimation:(BOOL)animated
{
    
    [UIView animateWithDuration:animated?.5:0 animations:^{
        branchIsShow = isShow;
        if (isShow) {
            
            ibBranchView.alpha = 1;
        }
        else{
            ibBranchView.alpha = 0;
            
        }}];
   
}
- (IBAction)btnShareClicked:(id)sender {
    
    [self showShareView:self.seShopModel];
}
- (IBAction)btnTransalateClicked:(id)sender {
    
    [self.seShopDetailView getTranslation];
}

-(void)initDataWithSeetiesID:(NSString*)seetiesID
{
    self.seetiesID = seetiesID;
    
}
-(void)initDataWithSeetiesID:(NSString*)seetiesID Latitude:(float)lat Longitude:(float)lng
{
    self.shopLat = lat;
    self.shopLng = lng;
    self.seetiesID = seetiesID;
    
    
}

-(void)initDataPlaceID:(NSString*)placeID postID:(NSString*)postID
{
    self.placeID = placeID;
    self.postID = postID;
    
}

-(void)initDataPlaceID:(NSString*)placeID postID:(NSString*)postID Latitude:(float)lat Longitude:(float)lng
{
    self.shopLat = lat;
    self.shopLng = lng;
    self.placeID = placeID;
    self.postID = postID;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [LoadingManager show];
    [self initSelfView];

}

-(void)initSelfView
{
    [self changeLanguage];
    self.ibScrollView.delegate = self;
    
    btnOutlet.hidden = YES;
    _arrViews = [NSMutableArray new];
    //self.ibImgViewOtherPadding.alpha = 0;
    [self.view addSubview:ibBranchView];

    ibBranchView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self showBranchView:NO withAnimation:NO];
   
    
    [self setupViews];
    [self addViews];
    [self rearrangeView];
    [self setupViewData];
   
    
    _ibTblSelectOutletView.delegate = self;
    _ibTblSelectOutletView.dataSource = self;
    [_ibTblSelectOutletView registerClass:[BranchOutletTblCell class] forCellReuseIdentifier:@"BranchOutletTblCell"];
}
-(void)setupViews
{
    [self.arrViews addObject:self.seShopDetailView];
    [self.arrViews addObject:self.seCollectionView];
    [self.arrViews addObject:self.seRecommendations];
    
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
        [self.arrViews addObject:self.seNearbySeetishop];

    }
    [self.ibReportShopView adjustToScreenWidth];
    [self.arrViews addObject:self.ibReportShopView];

  
}
-(void)setupViewData
{
    [self.seShopDetailView initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    [self.seCollectionView initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    [self.seRecommendations initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    
    if (![Utils stringIsNilOrEmpty:self.seetiesID]) {
       [self.seNearbySeetishop initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    }
}
-(void)addViews
{
    for (int i = 0; i< self.arrViews.count; i++) {
        UIView* view = self.arrViews[i];
        [self.ibScrollView addSubview:view];
        
    }

}

-(void)rearrangeView
{
    [self adjustView:self.arrViews[self.arrViews.count-1] :(int)(self.arrViews.count - 1)];
    UIView* lastView = [self.arrViews lastObject];
    self.ibScrollView.contentSize = CGSizeMake( self.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);
    
}

// readjust view from top to bottom
-(UIView*)adjustView:(UIView*)view :(int)count
{
    
    if (count <=0) {
        return view;

    }
    else{
        count--;

        UIView *previousView = [self adjustView:self.arrViews[count] :count];
        float height = previousView.frame.origin.y + previousView.frame.size.height;
        [view setY:height];
        return view;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Declaration

-(ReportProblemViewController*)reportProblemViewController
{
    if (!_reportProblemViewController) {
        _reportProblemViewController = [ReportProblemViewController new];
    }
    
    return _reportProblemViewController;
}
-(VoucherListingViewController*)voucherListingViewController
{
    if (!_voucherListingViewController) {
        _voucherListingViewController = [VoucherListingViewController new];
    }
    
    return _voucherListingViewController;
}

-(DealDetailsViewController*)dealDetailsViewController
{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    
    return _dealDetailsViewController;
}

-(SeetiesProfileView*)seProfileView
{
    if (!_seProfileView) {
        _seProfileView = [SeetiesProfileView initializeCustomView];
        [_seProfileView setWidth:self.view.frame.size.width];
        [_seProfileView setNeedsUpdateConstraints];
        [_seProfileView layoutIfNeeded];

    }
    
    return _seProfileView;
}

-(SeetiesShopViewController*)seetiesShopViewController
{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    return _seetiesShopViewController;
}

-(SeetiShopListingViewController*)seetiShopListingViewController
{
    if (!_seetiShopListingViewController) {
        _seetiShopListingViewController = [SeetiShopListingViewController new];
    }
    
    return _seetiShopListingViewController;
}

-(SeetiesMoreInfoViewController*)seetiesMoreInfoViewController
{
    if (!_seetiesMoreInfoViewController) {
        _seetiesMoreInfoViewController = [SeetiesMoreInfoViewController new];
    }
    return _seetiesMoreInfoViewController;
}
-(FeedV2DetailViewController*)PostDetailViewController
{
    if (!_PostDetailViewController) {
        _PostDetailViewController = [FeedV2DetailViewController new];
    }
    return _PostDetailViewController;
}
-(CollectionViewController*)CollectionDetailViewController
{
    if (!_CollectionDetailViewController) {
        _CollectionDetailViewController = [CollectionViewController new];
    }
    return _CollectionDetailViewController;
}
-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    return _collectionListingViewController;
}
-(SeRecommendationsSeeAllViewController*)seRecommendationsSeeAllViewController
{
    if (!_seRecommendationsSeeAllViewController) {
        _seRecommendationsSeeAllViewController = [SeRecommendationsSeeAllViewController new];
    }
    return _seRecommendationsSeeAllViewController;
}
-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [ProfileViewController new];
    }
    return _profileViewController;
}
-(PhotoListViewController*)photoListViewController
{
    if (!_photoListViewController) {
        _photoListViewController = [PhotoListViewController new];
    }
    
    return _photoListViewController;
}

-(MapViewController*)mapViewController
{
    if (!_mapViewController) {
        _mapViewController = [MapViewController new];
    }

    return _mapViewController;
}

-(SeShopDetailView*)seShopDetailView
{
    if (!_seShopDetailView)
    {
        
        _seShopDetailView = [SeShopDetailView initializeCustomView];
        [_seShopDetailView setWidth:self.view.frame.size.width];
        [_seShopDetailView setNeedsUpdateConstraints];
        [_seShopDetailView layoutIfNeeded];
        
        __weak typeof (self)weakSelf = self;

        _seShopDetailView.didSelectDealSeeAllBlock = ^(void)
        {
            
            [weakSelf showDealListingView];
        };
        
        _seShopDetailView.btnMapClickedBlock = ^(SeShopDetailModel* model)
        {
            _mapViewController = nil;
            _region.center.latitude = [model.location.lat doubleValue];
            _region.center.longitude = [model.location.lng doubleValue];
            [weakSelf.mapViewController initData:weakSelf.region EnableRePin:NO];
            [weakSelf.navigationController pushViewController:weakSelf.mapViewController animated:YES onCompletion:^{
                weakSelf.mapViewController.lblTitle.text = LocalisedString(@"MAP");
            }];
        };
        
        _seShopDetailView.imageDidFinishLoadBlock = ^(UIImage* image)
        {
            if (image) {
                
              //  weakSelf.ibTopPaddingOverlay.hidden = NO;
              //  weakSelf.ibImgViewTopPadding.image = image;

//                weakSelf.ibTopPaddingOverlay.alpha = 0;
//                [UIView animateWithDuration:.5f animations:^{
//                    weakSelf.ibTopPaddingOverlay.alpha = 1;
//                    weakSelf.ibImgViewTopPadding.image = image;
//
//                }];
            }
        };
    
//        _seShopDetailView.didSelectInformationAtRectBlock=^(UIView* fromView, CGRect rect)
//        {
//       
//        };
        
        _seShopDetailView.didSelectMorePhotosBlock = ^(SeShopPhotoModel* model)
        {
            
            _photoListViewController = nil;
            [weakSelf.photoListViewController initData:weakSelf.seetiesID PlaceID:weakSelf.placeID PostID:weakSelf.postID];
            [weakSelf.navigationController pushViewController:weakSelf.photoListViewController animated:YES];
        };
        
        _seShopDetailView.viewDidFinishLoadBlock = ^(SeShopDetailModel* model)
        {
            weakSelf.seShopModel = model;
            [weakSelf setHiddenVisible];
            [weakSelf rearrangeView];
            [weakSelf refreshBranchView];
            [weakSelf.ibTblSelectOutletView sizeToFit];
            
        };
        
        _seShopDetailView.btnMoreInfoClickedBlock = ^(SeShopDetailModel* model)
        {
            _seetiesMoreInfoViewController = nil;
            [weakSelf.seetiesMoreInfoViewController initData:model];
            [weakSelf.navigationController pushViewController:weakSelf.seetiesMoreInfoViewController animated:YES];

        };
        
        _seShopDetailView.didSelectDealBlock = ^(DealModel* model)
        {
            [weakSelf showDealDetailView:model];
        };
    }
    
    return _seShopDetailView;
}

-(void)refreshBranchView
{
    
    @try {
        if (self.seShopModel.shop_group_info &&  ![Utils isArrayNull:self.seShopModel.shop_group_info.other_branches]) {
            btnOutlet.hidden = NO;
            self.lblShopGroupName.text = self.seShopModel.shop_group_info.name;
            self.lblShopName.text = self.seShopModel.name;
            self.lblBigShopName.hidden = YES;
        }
        else{
            btnOutlet.hidden = YES;
            self.lblShopGroupName.hidden = YES;
            self.lblShopName.hidden = YES;
            self.lblBigShopName.text = self.seShopModel.name;
             self.ibImgDropDownIndicator.hidden = YES;

        }
        
        
       // SeShopDetailModel* model = self.seShopModel.shop_group_info.other_branches[0];
        self.lblShopName.text = self.seShopModel.name;
    }
    
    @catch (NSException *exception) {
        
    }
    [_ibTblSelectOutletView reloadData];
    


}

-(void)setHiddenVisible
{
    [UIView transitionWithView:self.btnShare duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
       

        if ([self.seShopModel.language isEqualToString:[Utils getDeviceAppLanguageCode]]) {
            self.btnTranslateWidthConstraint.constant = 0;

        }
        else
        {
            self.btnTranslateWidthConstraint.constant = 40;

        }
        
        
        btnTranslate.hidden = [Utils isStringNull:self.seShopModel.seetishop_id];
        
        self.btnShareWidthConstraint.constant = 40;
        [btnTranslate setNeedsUpdateConstraints];
        [btnTranslate layoutIfNeeded];
        [self.btnShare setNeedsUpdateConstraints];
        [self.btnShare layoutIfNeeded];
    } completion:nil];
   

}
-(SeDealsView*)seDealsView
{
    if (!_seDealsView) {
        _seDealsView = [SeDealsView initializeCustomView];
        [_seDealsView adjustToScreenWidth];
        [_seDealsView setNeedsUpdateConstraints];
        [_seDealsView layoutIfNeeded];
    }
    return _seDealsView;
}
-(SeCollectionView*)seCollectionView
{
    if (!_seCollectionView) {
        _seCollectionView = [SeCollectionView initializeCustomView];
        __weak typeof (self)weakSelf = self;
        _seCollectionView.viewDidFinishLoadBlock = ^(BOOL isDeleteView)
        {
            if (isDeleteView) {
                
                [weakSelf.arrViews removeObject:weakSelf.seCollectionView];
                [weakSelf.seCollectionView removeFromSuperview];
            }
            
            [weakSelf rearrangeView];
            
        };
        _seCollectionView.btnCollectionDetailClickedBlock = ^(NSString* idn,NSString* userid)
        {
            _CollectionDetailViewController = nil;
            [weakSelf.CollectionDetailViewController GetCollectionID:idn GetPermision:@"User" GetUserUid:userid];
            [weakSelf.navigationController pushViewController:weakSelf.CollectionDetailViewController animated:YES];
            
        };
        _seCollectionView.btnCollectionSeeAllClickedBlock = ^(NSString* idn)
        {
            _collectionListingViewController = nil;
    
            [weakSelf.collectionListingViewController setTypeSeeties:idn];
            [weakSelf.navigationController pushViewController:weakSelf.collectionListingViewController animated:YES];
            
        };
    }
    return _seCollectionView;
}
-(SeRecommendations*)seRecommendations
{
    if (!_seRecommendations) {
        _seRecommendations = [SeRecommendations initializeCustomView];
        __weak typeof (self)weakSelf = self;
        _seRecommendations.viewDidFinishLoadBlock = ^(BOOL isDeleteView)
        {
            
            if (isDeleteView) {
                
                [weakSelf.arrViews removeObject:weakSelf.seRecommendations];
                [weakSelf.seRecommendations removeFromSuperview];
                
            }

            [weakSelf rearrangeView];

        };
        
        _seRecommendations.btnPostsDetailClickedBlock = ^(NSString* idn)
        {
            _PostDetailViewController = nil;
            [weakSelf.PostDetailViewController GetPostID:idn];
            [weakSelf.navigationController pushViewController:weakSelf.PostDetailViewController animated:YES];
            
        };
        _seRecommendations.btnPostsSeeAllClickedBlock = ^(NSString* idn)
        {

            // see all recommendation view
            _seRecommendationsSeeAllViewController = nil;
            [weakSelf.seRecommendationsSeeAllViewController initData:weakSelf.seetiesID PlaceID:weakSelf.placeID PostID:weakSelf.postID];
            [weakSelf.navigationController pushViewController:weakSelf.seRecommendationsSeeAllViewController animated:YES];
        };
        _seRecommendations.btnPostsOpenProfileClickedBlock = ^(NSString* idn)
        {
            
            _profileViewController = nil;

            [weakSelf.navigationController pushViewController:weakSelf.profileViewController animated:YES onCompletion:^{
                [weakSelf.profileViewController initDataWithUserID:idn];
            }];
        };
    }
    return _seRecommendations;
}
-(SeNearbySeetishop*)seNearbySeetishop
{
    if (!_seNearbySeetishop) {
        _seNearbySeetishop = [SeNearbySeetishop initializeCustomView];
        
        __weak typeof (self)weakSelf = self;
        _seNearbySeetishop.btnSelectSeetiShopListBlock = ^(void)
        {
            _seetiShopListingViewController = nil;
            weakSelf.seetiShopListingViewController.title = LocalisedString(@"Shops nearby");
            [weakSelf.navigationController pushViewController:weakSelf.seetiShopListingViewController animated:YES onCompletion:^{
                [weakSelf.seetiShopListingViewController initData:weakSelf.seetiesID PlaceID:nil PostID:nil];
            }];
            
        };
        
        _seNearbySeetishop.btnSeetiShopClickedBlock = ^(NSString* idn)
        {
            _seetiesShopViewController = nil;
            SLog(@"seeties shop ID: %@",idn);
            [weakSelf.seetiesShopViewController initDataWithSeetiesID:idn];
            [weakSelf.navigationController pushViewController:weakSelf.seetiesShopViewController animated:YES];
            // open nearby seetiShop
        
        };
    
        
    }
    return _seNearbySeetishop;
}

#pragma mark - Show View

-(void)showDealDetailView:(DealModel*)model
{
    
    _dealDetailsViewController = nil;
    [self.dealDetailsViewController initDealModel:model];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        [self.dealDetailsViewController setupView];
    }];

}

-(void)showDealListingView
{
    if (![Utils isStringNull:self.seShopModel.seetishop_id]) {
        
        [self.voucherListingViewController initDataWithShopID:self.seShopModel.seetishop_id];
        [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
    }
}
-(void)showShareView:(SeShopDetailModel*)shopModel
{    
    //New Sharing Screen
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    
    dataToPost.title = shopModel.name;
    
    if (![Utils isStringNull:shopModel.seetishop_id]) {
        dataToPost.shareID = shopModel.seetishop_id;
        dataToPost.shareType = ShareTypeSeetiesShop;
    }
    else {
        dataToPost.shareID = self.placeID;
        dataToPost.shareType = ShareTypeNonSeetiesShop;
        dataToPost.postID = self.postID;
    }
    
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
    
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.seShopModel.shop_group_info.other_branches.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BranchOutletTblCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BranchOutletTblCell"];
    
    @try {
        SeShopDetailModel* model = self.seShopModel.shop_group_info.other_branches[indexPath.row];
        cell.lblTitle.text = model.name;
        
        if (![Utils isStringNull:model.location.country]) {
            
            
            if (![Utils isStringNull:model.location.locality]) {
                cell.lblDesc.text = [NSString stringWithFormat:@"%@,%@",model.location.locality,model.location.country];

            }else{
                cell.lblDesc.text = model.location.country;

            }

        }
        else{
            cell.lblDesc.text = model.location.locality;

        }

    }
    @catch (NSException *exception) {
        SLog(@"parsing seetiesshop id fail in cellForRowAtIndexPath");

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _seetiesShopViewController = nil;
    @try {
        SeShopDetailModel* model = self.seShopModel.shop_group_info.other_branches[indexPath.row];
        [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];

    }
    @catch (NSException *exception) {
        SLog(@"parsing seetiesshop id fail in didSelectRowAtIndexPath");
    }
    
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    if (scrollView == self.ibScrollView) {
//        int profileBackgroundHeight = 210;
//        if (scrollView.contentOffset.y <= profileBackgroundHeight) {
//            
//            float adjustment = (scrollView.contentOffset.y
//                                )/(profileBackgroundHeight);
//            self.ibImgViewOtherPadding.alpha = adjustment;
//            
//        }
//        else if (scrollView.contentOffset.y > profileBackgroundHeight)
//        {
//            self.ibImgViewOtherPadding.alpha = 1;
//            
//            
//            
//        }
//
//    }
   
}
#pragma  mark - Change Language
-(void)changeLanguage
{
    lblSelectOutlet.text = LocalisedString(@"Select Outlet");
    self.lblReportTitle.text = LocalisedString(@"Report this shop");
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

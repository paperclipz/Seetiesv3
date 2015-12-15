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

@interface SeetiesShopViewController ()<UIScrollViewDelegate>

//================ CONTROLLERS ====================//
@property (nonatomic,strong)MapViewController* mapViewController;
@property (nonatomic,strong)PhotoListViewController* photoListViewController;
@property (nonatomic,strong)SeetiesMoreInfoViewController* seetiesMoreInfoViewController;
@property (nonatomic,strong)SeetiShopListingViewController* seetiShopListingViewController;
@property (nonatomic,strong)FeedV2DetailViewController* PostDetailViewController;
@property (nonatomic,strong)CollectionViewController* CollectionDetailViewController;
@property (nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property (nonatomic,strong)SeRecommendationsSeeAllViewController* seRecommendationsSeeAllViewController;
//$$============== CONTROLLERS ==================$$//

@property (weak, nonatomic) IBOutlet UIImageView *ibImgViewTopPadding;
@property (nonatomic,strong)SeShopDetailView* seShopDetailView;
@property (nonatomic,strong)SeDealsView* seDealsView;
@property (nonatomic,strong)SeCollectionView* seCollectionView;
@property (nonatomic,strong)SeRecommendations* seRecommendations;
@property (nonatomic,strong)SeNearbySeetishop* seNearbySeetishop;

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property(nonatomic,assign)SeetiesShopType seetiesType;
@property(nonatomic, strong)NSMutableArray* arrViews;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgViewOtherPadding;
@property(nonatomic,assign)MKCoordinateRegion region;

@property(nonatomic,strong)NSString* seetiesID;
@property(nonatomic,strong)NSString* placeID;
@property(nonatomic,strong)NSString* postID;

@end

@implementation SeetiesShopViewController

-(void)initDataWithSeetiesID:(NSString*)seetiesID
{
    self.seetiesID = seetiesID;
}

-(void)initDataPlaceID:(NSString*)placeID postID:(NSString*)postID
{
    self.placeID = placeID;
    self.postID = postID;

}

#pragma mark - IBACTION
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    [self.seShopDetailView initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    [self.seCollectionView initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    [self.seRecommendations initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
    [self.seNearbySeetishop initData:self.seetiesID PlaceID:self.placeID PostID:self.postID];
}

-(void)initSelfView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ibScrollView.delegate = self;
    _arrViews = [NSMutableArray new];
    
    [self setupViews];
    [self addViews];
    [self rearrangeView];
}
-(void)setupViews
{
    [self.arrViews addObject:self.seShopDetailView];
    [self.arrViews addObject:self.seCollectionView];
    [self.arrViews addObject:self.seRecommendations];
    [self.arrViews addObject:self.seNearbySeetishop];

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
        [_seShopDetailView adjustToScreenWidth];
        [_seShopDetailView setNeedsUpdateConstraints];
        [_seShopDetailView layoutIfNeeded];
        
        __weak typeof (self)weakSelf = self;

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
            weakSelf.ibImgViewTopPadding.image = image;
        };
    
        _seShopDetailView.didSelectInformationAtRectBlock=^(UIView* fromView, CGRect rect)
        {
       
        };
        
        _seShopDetailView.didSelectMorePhotosBlock = ^(SeShopPhotoModel* model)
        {
            
            _photoListViewController = nil;
            [weakSelf.navigationController pushViewController:weakSelf.photoListViewController animated:YES];
        };
        
        _seShopDetailView.viewDidFinishLoadBlock = ^(void)
        {
           // [weakSelf.arrViews removeObject:weakSelf.seDealsView];
           // [weakSelf.seDealsView removeFromSuperview];
          
            [weakSelf rearrangeView];
//            [UIView animateWithDuration:1.0 animations:^{
//                
//            }completion:^(BOOL finished) {
//                
//    
//            }];
        };
        
        _seShopDetailView.btnMoreInfoClickedBlock = ^(SeShopDetailModel* model)
        {
            _seetiesMoreInfoViewController = nil;
            weakSelf.seetiesMoreInfoViewController.seShopModel = model;
            [weakSelf.navigationController pushViewController:weakSelf.seetiesMoreInfoViewController animated:YES];

        };
    
    }
    
    return _seShopDetailView;
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
        _seCollectionView.viewDidFinishLoadBlock = ^(void)
        {
            [weakSelf rearrangeView];
            
        };
        _seCollectionView.btnCollectionDetailClickedBlock = ^(NSString* idn)
        {
            _CollectionDetailViewController = nil;
            [weakSelf.CollectionDetailViewController GetCollectionID:idn GetPermision:@"User"];
            [weakSelf.navigationController pushViewController:weakSelf.CollectionDetailViewController animated:YES];
            
        };
        _seCollectionView.btnCollectionSeeAllClickedBlock = ^(NSString* idn)
        {
            _collectionListingViewController = nil;
            ProfileModel* model = [ProfileModel new];
            model.uid = [Utils getUserID];
            [weakSelf.collectionListingViewController setType:ProfileViewTypeOthers ProfileModel:model NumberOfPage:1 collectionType:CollectionListingTypeSuggestion];
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
        _seRecommendations.viewDidFinishLoadBlock = ^(void)
        {
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
            [weakSelf.navigationController pushViewController:weakSelf.seRecommendationsSeeAllViewController animated:YES];
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
            [weakSelf.seetiShopListingViewController initData];
            [weakSelf.navigationController pushViewController:weakSelf.seetiShopListingViewController animated:YES];
            
        };
    }
    return _seNearbySeetishop;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int profileBackgroundHeight = 200;
    if (scrollView.contentOffset.y > -profileBackgroundHeight && scrollView.contentOffset.y <= 5) {
        
        float adjustment = (profileBackgroundHeight + scrollView.contentOffset.y
                            )/(profileBackgroundHeight);
        // SLog(@"adjustment : %f",adjustment);
        self.ibImgViewOtherPadding.alpha = adjustment;
        
    }
    else if (scrollView.contentOffset.y > profileBackgroundHeight)
    {
        self.ibImgViewOtherPadding.alpha = 1;
        
        
        
    }
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

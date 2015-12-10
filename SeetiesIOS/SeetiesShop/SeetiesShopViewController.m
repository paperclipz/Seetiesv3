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

@interface SeetiesShopViewController ()<UIScrollViewDelegate>

//================ CONTROLLERS ====================//
@property (nonatomic,strong)MapViewController* mapViewController;
@property (nonatomic,strong)PhotoListViewController* photoListViewController;
@property (nonatomic,strong)SeetiesMoreInfoViewController* seetiesMoreInfoViewController;

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

@end

@implementation SeetiesShopViewController

#pragma mark - IBACTION
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
   // [self.seShopDetailView initData];
   // [self.seCollectionView initData];
    [self.seNearbySeetishop initData];
}

-(void)initSelfView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ibScrollView.delegate = self;
    _arrViews = [NSMutableArray new];
    
    [self setupViews];
    [self addViews];
    [self adjustView:self.arrViews[self.arrViews.count-1] :(int)(self.arrViews.count - 1)];
    UIView* lastView = [self.arrViews lastObject];
    self.ibScrollView.contentSize = CGSizeMake( self.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);
}
-(void)setupViews
{
    [self.arrViews addObject:self.seShopDetailView];
    [self.arrViews addObject:self.seCollectionView];
  //  [self.arrViews addObject:self.seCollectionView];
    //[self.arrViews addObject:self.seRecommendations];
    [self.arrViews addObject:self.seNearbySeetishop];

}
-(void)addViews
{
    for (int i = 0; i< self.arrViews.count; i++) {
        UIView* view = self.arrViews[i];
        [self.ibScrollView addSubview:view];
        
    }

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

-(SeetiesMoreInfoViewController*)seetiesMoreInfoViewController
{
    if (!_seetiesMoreInfoViewController) {
        _seetiesMoreInfoViewController = [SeetiesMoreInfoViewController new];
    }
    return _seetiesMoreInfoViewController;
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

        _seShopDetailView.btnMapClickedBlock = ^(void)
        {
            
            [weakSelf.navigationController pushViewController:weakSelf.mapViewController animated:YES];
            
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
            [weakSelf adjustView:weakSelf.arrViews[self.arrViews.count-1] :(int)(weakSelf.arrViews.count - 1)];
            UIView* lastView = [weakSelf.arrViews lastObject];
            weakSelf.ibScrollView.contentSize = CGSizeMake( weakSelf.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);
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
    }
    return _seCollectionView;
}
-(SeRecommendations*)seRecommendations
{
    if (!_seRecommendations) {
        _seRecommendations = [SeRecommendations initializeCustomView];
    }
    return _seRecommendations;
}
-(SeNearbySeetishop*)seNearbySeetishop
{
    if (!_seNearbySeetishop) {
        _seNearbySeetishop = [SeNearbySeetishop initializeCustomView];
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

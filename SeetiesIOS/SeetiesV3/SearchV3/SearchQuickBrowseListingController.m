//
//  SearchQuickBrowseListingController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchQuickBrowseListingController.h"
#import "SearchLTabViewController.h"
#import "SearchLocationViewController.h"
@interface SearchQuickBrowseListingController ()

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property(nonatomic,strong)SearchLTabViewController *shopListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *collectionListingTableViewController;
@property(nonatomic,strong)CollectionViewController* collectionViewController;

@property(nonatomic)EditCollectionViewController* editCollectionViewController;
@property(nonatomic)SeetiesShopViewController* seetiesShopViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property(nonatomic, strong) SearchLocationViewController *searchLocationViewController;
@property(nonatomic, strong) SearchViewV2Controller *searchViewV2Controller;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@end

@implementation SearchQuickBrowseListingController
- (IBAction)btnSearchClicked:(id)sender {
    
    _searchViewV2Controller = nil;
    [self.navigationController pushViewController:self.searchViewV2Controller animated:YES];
}
- (IBAction)btnBackClicked:(id)sender {
    
    if (self.didSelectHomeLocationBlock) {
        self.didSelectHomeLocationBlock(self.homeLocationModel);
    }
}

- (IBAction)btnLocationClicked:(id)sender {
    
    _searchLocationViewController = nil;
    
    [self.navigationController pushViewController:self.searchLocationViewController animated:YES];
}

- (IBAction)btnSegmentedControlClicked:(UISegmentedControl *)sender
{
    [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width * sender.selectedSegmentIndex, 0) animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    self.lblCategory.text = self.keyword;
    self.lblLocation.text = self.homeLocationModel.locationName;
    
    [self refreshView];
}

-(void)refreshView
{
    [self.collectionListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.keyword];
    [self.shopListingTableViewController refreshRequestWithModel:self.homeLocationModel Keyword:self.keyword];
}

-(void)initSelfView
{

    CGRect frame = [Utils getDeviceScreenSize];
    [self.ibScrollView setWidth:frame.size.width];
    [self.shopListingTableViewController.view setWidth:frame.size.width];
    [self.shopListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.shopListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);
    self.shopListingTableViewController.constFilterHeight.constant = 0;

    
    [self.collectionListingTableViewController.view setWidth:frame.size.width];
    [self.collectionListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.collectionListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.collectionListingTableViewController.view setX:self.shopListingTableViewController.view.frame.size.width];
    self.collectionListingTableViewController.constFilterHeight.constant = 0;

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Declaration
-
(SearchViewV2Controller*)searchViewV2Controller
{
    if (!_searchViewV2Controller) {
        _searchViewV2Controller = [SearchViewV2Controller new];
    }
    
    return _searchViewV2Controller;
}
-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
    }
    
    return _editCollectionViewController;
}

-(SearchLTabViewController*)shopListingTableViewController{
    if(!_shopListingTableViewController)
    {
        _shopListingTableViewController = [SearchLTabViewController new];
        _shopListingTableViewController.searchListingType = SearchListingTypeShop;
        
        __weak typeof (self)weakSelf = self;
        _shopListingTableViewController.didSelectShopBlock = ^(SeShopDetailModel* model)
        {
            [weakSelf showSeetieshopView:model];
        };
    }
    return _shopListingTableViewController;
}
-(SearchLTabViewController*)collectionListingTableViewController{
    if(!_collectionListingTableViewController)
    {
        _collectionListingTableViewController = [SearchLTabViewController new];
        _collectionListingTableViewController.searchListingType = SearchsListingTypeCollections;
        // [_collectionListingTableViewController refreshRequestWithText:self.ibSearchText.text];

        __weak typeof (self)weakSelf = self;
        
        _collectionListingTableViewController.didSelectDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
            // [weakSelf showCollectionDisplayViewWithCollectionID:model.collection_id ProfileType:ProfileViewTypeOthers];
            _collectionViewController = nil;
            [weakSelf.collectionViewController GetCollectionID:model.collection_id GetPermision:@"Others" GetUserUid:model.user_info.uid];
            [weakSelf.navigationController pushViewController:weakSelf.collectionViewController animated:YES];
        };
        _collectionListingTableViewController.didSelectEditDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
            
            [weakSelf showEditCollectionViewWithCollection:model];
        };
        
        
    }
    return _collectionListingTableViewController;
}

-(CollectionViewController*)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController = [CollectionViewController new];
    }
    
    return _collectionViewController;
}

-(SearchLocationViewController*)searchLocationViewController{
    
    if (!_searchLocationViewController) {
        _searchLocationViewController = [SearchLocationViewController new];
        __weak typeof (self)weakself = self;
        
        _searchLocationViewController.homeLocationRefreshBlock = ^(HomeLocationModel* model)
        {
            
            weakself.homeLocationModel = model;
            
            [Utils saveUserLocation:weakself.homeLocationModel.locationName Longtitude:weakself.homeLocationModel.longtitude Latitude:weakself.homeLocationModel.latitude PlaceID:model.place_id];
            
            
            weakself.lblLocation.text = weakself.homeLocationModel.locationName;
            
            [weakself.searchLocationViewController.navigationController popViewControllerAnimated:YES];
            
            [weakself refreshView];
            
        };
        
        
    }
    
    return _searchLocationViewController;
}
#pragma mark - Show View

-(void)showSeetieshopView:(SeShopDetailModel*)model
{
    _seetiesShopViewController = nil;
    
    if (![Utils isStringNull:model.seetishop_id]) {
        [self.seetiesShopViewController initDataWithSeetiesID:model.seetishop_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
        
    }
    else if(![Utils isStringNull:model.post_id] && ![Utils isStringNull:model.place_id]){
        [self.seetiesShopViewController initDataPlaceID:model.place_id postID:model.post_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
        
    }
}

-(void)showCollectionDisplayViewWithCollectionID:(CollectionModel*)colModel ProfileType:(ProfileViewType)profileType
{
    _collectionViewController = nil;
    if ([colModel.user_info.uid isEqualToString:[Utils getUserID]]) {
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"self" GetUserUid:colModel.user_info.uid];
        
    }
    else{
        
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"Others" GetUserUid:colModel.user_info.uid];
    }
    
    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}

-(void)showEditCollectionViewWithCollection:(CollectionModel*)model
{
    _editCollectionViewController = nil;
    
    [self.editCollectionViewController initData:model.collection_id];
    
    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
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

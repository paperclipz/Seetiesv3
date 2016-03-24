//
//  SearchQuickBrowseListingController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchQuickBrowseListingController.h"
#import "SearchLTabViewController.h"
#import "CT3_SearchListingViewController.h"
#import "SearchLocationViewController.h"
#import "DealDetailsViewController.h"
#import "CAPSPageMenu.h"

@interface SearchQuickBrowseListingController ()<CAPSPageMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *ibCotentView;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@property(nonatomic,strong)SearchLTabViewController *shopListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *collectionListingTableViewController;
@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic) GeneralFilterViewController *shopFilterViewController;
@property(nonatomic) GeneralFilterViewController *collectionFilterViewController;

@property(nonatomic)EditCollectionViewController* editCollectionViewController;
@property(nonatomic)SeetiesShopViewController* seetiesShopViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property(nonatomic, strong) SearchLocationViewController *searchLocationViewController;
@property(nonatomic, strong) CT3_SearchListingViewController *searchListingViewController;
@property(nonatomic, strong) DealDetailsViewController *dealDetailsViewController;
@property (nonatomic, strong) CAPSPageMenu *cAPSPageMenu;


@property(nonatomic) FiltersModel *shopFilterModel;
@property(nonatomic) FiltersModel *collectionFilterModel;

@end

@implementation SearchQuickBrowseListingController
- (IBAction)btnSearchClicked:(id)sender {
    
    _searchListingViewController = nil;
    [self.navigationController pushViewController:self.searchListingViewController animated:YES];
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


- (IBAction)btnFilterClicked:(id)sender {
    if (self.cAPSPageMenu.currentPageIndex == 0) {
        [self presentViewController:self.shopFilterViewController animated:YES completion:nil];
    }
    else if (self.cAPSPageMenu.currentPageIndex == 1){
        [self presentViewController:self.collectionFilterViewController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    self.lblCategory.text = self.selectedQuickBrowse.name;
    self.lblLocation.text = self.homeLocationModel.locationName;
    
    [self refreshView];
}

-(void)refreshView
{
    [self refreshCategoryLbl];
    
    [self.collectionListingTableViewController refreshRequestWithHomeLocation:self.homeLocationModel filterDictionary:[self getCollectionFilter]];
    [self.shopListingTableViewController refreshRequestWithHomeLocation:self.homeLocationModel filterDictionary:[self getShopFilter]];
}

-(void)refreshCategoryLbl{
    if (self.cAPSPageMenu.currentPageIndex == 0) {
        NSString *categories = [self getShopFilterCategories];
        self.lblCategory.text = categories;
    }
    else if (self.cAPSPageMenu.currentPageIndex == 1){
        NSString *categories = [self getCollectionFilterCategories];
        self.lblCategory.text = categories;
    }
}


-(void)initSelfView
{

    //CGRect frame = [Utils getDeviceScreenSize]
    [self.ibCotentView adjustToScreenWidth];

    [self.ibCotentView addSubview:self.cAPSPageMenu.view];
    
    self.shopListingTableViewController.constFilterHeight.constant = 0;
    self.collectionListingTableViewController.constFilterHeight.constant = 0;

    
      [self formatShopFilter];
    [self formatCollectionFilter];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatShopFilter{
    self.shopFilterModel = [[FiltersModel alloc] init];
    self.shopFilterModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.shopFilterModel.filterViewType = FilterViewTypeShop;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort By");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Latest");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostRecent;
    
    FilterModel *distance = [[FilterModel alloc] init];
    distance.name = LocalisedString(@"Distance");
    distance.isSelected = NO;
    distance.sortType = SortTypeNearest;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:distance];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Deals by Category");
    catCategory.filterCategoryType = FilterTypeCat;
    
    for (QuickBrowseModel *quickBrowse in self.quickBrowseModels) {
        FilterModel *filter = [[FilterModel alloc] init];
        filter.name = quickBrowse.name;
        filter.filterId = quickBrowse.category_group_id;
        filter.isSelected = [quickBrowse.category_group_id isEqualToString:self.selectedQuickBrowse.category_group_id]? YES : NO;
        [catCategory.filtersArray addObject:filter];
    }
    
    //IsOpen
    FilterCategoryModel *isOpenCategory = [[FilterCategoryModel alloc] init];
    isOpenCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    isOpenCategory.categoryName = LocalisedString(@"Now Open");
    isOpenCategory.filterCategoryType = FilterTypeIsOpen;
    
    FilterModel *isOpenFilter = [[FilterModel alloc] init];
    isOpenFilter.name = LocalisedString(@"Now Open");
    isOpenFilter.isSelected = NO;
    [isOpenCategory.filtersArray addObject:isOpenFilter];
    
    [self.shopFilterModel.filterCategories addObject:sortCategory];
    [self.shopFilterModel.filterCategories addObject:catCategory];
    [self.shopFilterModel.filterCategories addObject:isOpenCategory];
}

-(NSDictionary*)getShopFilter{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    int isOpen = 0;
    for (FilterCategoryModel *filterCategory in self.shopFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        sort = (int)filter.sortType;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                BOOL isFirst = YES;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@","];
                        }
                        
                        [catString appendString:filter.filterId];
                    }
                }
            }
                break;
                
            case FilterTypeIsOpen:
            {
                FilterModel *isOpenModel = filterCategory.filtersArray[0];
                isOpen = isOpenModel.isSelected? 1 : 0;
            }
                break;
                
            default:
                break;
        }
    }
    
    return @{@"sort": @(sort),
             @"category_group": catString,
             @"opening_now": @(isOpen)};
}

-(NSString*)getShopFilterCategories{
    NSMutableString *catString = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    for (FilterCategoryModel *filterCategory in self.shopFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@", "];
                        }
                    
                        [catString appendString:filter.name];
                    }
                }
            }
                
            default:
                break;
        }
    }
    return catString;
}

-(void)formatCollectionFilter{
    self.collectionFilterModel = [[FiltersModel alloc] init];
    self.collectionFilterModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.collectionFilterModel.filterViewType = FilterViewTypeCollection;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort By");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Latest");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostRecent;
    
    FilterModel *popular = [[FilterModel alloc] init];
    popular.name = LocalisedString(@"Popular");
    popular.isSelected = NO;
    popular.sortType = SortTypeMostPopular;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:popular];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Deals by Category");
    catCategory.filterCategoryType = FilterTypeCat;
    
    for (QuickBrowseModel *quickBrowse in self.quickBrowseModels) {
        FilterModel *filter = [[FilterModel alloc] init];
        filter.name = quickBrowse.name;
        filter.filterId = quickBrowse.category_group_id;
        filter.isSelected = [quickBrowse.category_group_id isEqualToString:self.selectedQuickBrowse.category_group_id]? YES : NO;
        [catCategory.filtersArray addObject:filter];
    }
    
    [self.collectionFilterModel.filterCategories addObject:sortCategory];
    [self.collectionFilterModel.filterCategories addObject:catCategory];
}

-(NSDictionary*)getCollectionFilter{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    for (FilterCategoryModel *filterCategory in self.collectionFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeSort:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        sort = (int)filter.sortType;
                    }
                }
            }
                break;
                
            case FilterTypeCat:
            {
                BOOL isFirst = YES;
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@","];
                        }
                        
                        [catString appendString:filter.filterId];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return @{@"sort": @(sort),
             @"category_group": catString};
}

-(NSString*)getCollectionFilterCategories{
    NSMutableString *catString = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    for (FilterCategoryModel *filterCategory in self.collectionFilterModel.filterCategories) {
        switch (filterCategory.filterCategoryType) {
            case FilterTypeCat:
            {
                for (FilterModel *filter in filterCategory.filtersArray) {
                    if (filter.isSelected) {
                        if (isFirst) {
                            isFirst = NO;
                        }
                        else{
                            [catString appendString:@", "];
                        }
                        
                        [catString appendString:filter.name];
                    }
                }
            }
                
            default:
                break;
        }
    }
    return catString;
}

-(void)applyFilterClicked:(FiltersModel *)filtersModel{
    if (filtersModel.filterViewType == FilterViewTypeShop) {
        _shopFilterModel = filtersModel;
    }
    else if (filtersModel.filterViewType == FilterViewTypeCollection){
        _collectionFilterModel = filtersModel;
    }
    [self refreshView];
}
#pragma mark - CSMENU DELEGATE
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index
{
    [self refreshCategoryLbl];

}

#pragma mark - Declaration

-(CAPSPageMenu*)cAPSPageMenu
{
    if(!_cAPSPageMenu)
    {
        CGRect deviceFrame = [Utils getDeviceScreenSize];
        
        NSArray *controllerArray = @[self.shopListingTableViewController,self.collectionListingTableViewController];
        NSDictionary *parameters = @{
                                     CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0],
                                     CAPSPageMenuOptionSelectionIndicatorColor: DEVICE_COLOR,
                                     CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                     CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0],
                                     CAPSPageMenuOptionMenuHeight: @(40.0),
                                     CAPSPageMenuOptionMenuItemWidth: @(deviceFrame.size.width/2 - 20),
                                     CAPSPageMenuOptionCenterMenuItems: @(YES),
                                     CAPSPageMenuOptionUnselectedMenuItemLabelColor:TEXT_GRAY_COLOR,
                                     CAPSPageMenuOptionSelectedMenuItemLabelColor:DEVICE_COLOR,
                                     };
        
        _cAPSPageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.ibCotentView.frame.size.width, self.ibCotentView.frame.size.height) options:parameters];
        _cAPSPageMenu.view.backgroundColor = [UIColor whiteColor];
        _cAPSPageMenu.delegate = self;
    }
    return _cAPSPageMenu;
}

-(SeetiesShopViewController*)seetiesShopViewController
{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    
    return _seetiesShopViewController;
}

-(DealDetailsViewController*)dealDetailsViewController
{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    
    return _dealDetailsViewController;
}

-(CT3_SearchListingViewController*)searchListingViewController
{
    if (!_searchListingViewController) {
        _searchListingViewController = [CT3_SearchListingViewController new];
    }
    return _searchListingViewController;
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
        _shopListingTableViewController.title = LocalisedString(@"Shop");

        __weak typeof (self)weakSelf = self;
        _shopListingTableViewController.didSelectShopBlock = ^(SeShopDetailModel* model)
        {
            [weakSelf showSeetieshopView:model];
        };
        
        _shopListingTableViewController.didSelectDealBlock = ^(DealModel* model)
        {
            [weakSelf showDealDetailView:model];
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
        _collectionListingTableViewController.title = LocalisedString(@"Collection");

        __weak typeof (self)weakSelf = self;
        
        _collectionListingTableViewController.didSelectDisplayCollectionRowBlock = ^(CollectionModel* model)
        {
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

-(GeneralFilterViewController *)shopFilterViewController{
    if (!_shopFilterViewController) {
        _shopFilterViewController = [GeneralFilterViewController new];
        [_shopFilterViewController initWithFilter:self.shopFilterModel];
        _shopFilterViewController.delegate = self;
    }
    return _shopFilterViewController;
}

-(GeneralFilterViewController *)collectionFilterViewController{
    if ((!_collectionFilterViewController)) {
        _collectionFilterViewController = [GeneralFilterViewController new];
        [_collectionFilterViewController initWithFilter:self.collectionFilterModel];
        _collectionFilterViewController.delegate = self;
    }
    return _collectionFilterViewController;
}

#pragma mark - Show View

-(void)showDealDetailView:(DealModel*)model
{
    _dealDetailsViewController = nil;
        [self.dealDetailsViewController setDealModel:model];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        
        [self.dealDetailsViewController setupView];
    }];
}

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

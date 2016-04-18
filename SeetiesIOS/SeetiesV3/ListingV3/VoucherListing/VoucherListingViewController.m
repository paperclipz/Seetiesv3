//
//  VoucherListingViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherListingViewController.h"
#import "CT3_SearchListingViewController.h"


@interface VoucherListingViewController ()
@property (nonatomic) DealsModel *dealsModel;
@property (nonatomic) DealCollectionModel *dealCollectionModel;
@property (nonatomic) HomeLocationModel *locationModel;
@property (nonatomic) NSArray<QuickBrowseModel> *quickBrowseModels;
@property (nonatomic) FiltersModel *filtersModel;

@property (nonatomic) NSMutableArray<DealModel> *dealsArray;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL  isCollecting;
@property (nonatomic) DealManager *dealManager;
@property (nonatomic) NSString *shopID;
@property (nonatomic) NSString *dealId;
@property (nonatomic,assign) int dealViewType;// 1 == seetiesshop id

@property (weak, nonatomic) IBOutlet UILabel *ibUserLocationLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibAltTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibSearchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ibDropDownIcon;
@property (weak, nonatomic) IBOutlet UIButton *ibLocationBtn;
@property (weak, nonatomic) IBOutlet UITableView *ibVoucherTable;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibFooterHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibEmptyStateView;
@property (weak, nonatomic) IBOutlet UIView *ibEmptyView;;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyDesc;
@property (weak, nonatomic) IBOutlet UIView *ibLoadingView;
@property (weak, nonatomic) IBOutlet YLImageView *ibLoadingImg;
@property (weak, nonatomic) IBOutlet UILabel *ibLoadingTxt;

@property (strong, nonatomic) IBOutlet UIView *ibFooterView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ibActivityIndicatorView;

@property (strong, nonatomic)GeneralFilterViewController* filterController;
@property (nonatomic) DealDetailsViewController *dealDetailsViewController;
@property (nonatomic) WalletListingViewController *walletListingViewController;
@property (nonatomic) PromoPopOutViewController *promoPopOutViewController;
@property (nonatomic) DealRedeemViewController *dealRedeemViewController;
@property (nonatomic) SearchLocationViewController *searchLocationViewController;
@property (nonatomic) CT3_SearchListingViewController *ct3_SearchListingViewController;
@property (nonatomic) RedemptionHistoryViewController *redemptionHistoryViewController;

@end

@implementation VoucherListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isLoading = NO;
    self.isCollecting = NO;
    [self.ibVoucherTable registerNib:[UINib nibWithNibName:@"VoucherCell" bundle:nil] forCellReuseIdentifier:@"VoucherCell"];
    
    self.ibVoucherTable.estimatedRowHeight = [VoucherCell getHeight];
    self.ibVoucherTable.rowHeight = UITableViewAutomaticDimension;
    [Utils setRoundBorder:self.ibWalletCountLbl color:OUTLINE_COLOR borderRadius:self.ibWalletCountLbl.frame.size.width/2];
  
    self.ibLoadingImg.image = [YLGIFImage imageNamed:@"Loading.gif"];
    
    if (self.locationModel) {
        self.ibUserLocationLbl.text = self.locationModel.locationName;
    }
    
    switch (self.dealViewType) {
        //Shop deals listing
        case 1:
            self.ibAltTitle.text = LocalisedString(@"Shop Deals");
            self.ibAltTitle.hidden = NO;
            self.ibTitle.hidden = YES;
            self.ibUserLocationLbl.hidden = YES;
            self.ibDropDownIcon.hidden = YES;
            self.ibFilterBtn.hidden = YES;
            self.ibSearchBtn.hidden = YES;
            self.ibLocationBtn.enabled = NO;
            self.ibSearchBtn.enabled = NO;
            self.ibFilterBtn.enabled = NO;
            [self.dealManager removeAllCollectedDeals];
            [self requestServerForShopDeal];
            break;
        
        //Collection deals listing
        case 2:
            if (self.dealCollectionModel) {
                NSDictionary *collectionDict = self.dealCollectionModel.content[0];
                self.ibTitle.text = collectionDict[@"title"];
            }
            [self.dealManager removeAllCollectedDeals];
            [self requestServerForDealListing];
            break;
        
        //Featured deals listing
        case 3:
            self.ibTitle.text = LocalisedString(@"Deals of the day");
            [self.dealManager removeAllCollectedDeals];
            [self requestServerForSuperDealListing];
            break;
          
        //Relevant deals listing
        case 4:
            self.ibAltTitle.text = LocalisedString(@"Relevant Deals");
            self.ibAltTitle.hidden = NO;
            self.ibTitle.hidden = YES;
            self.ibUserLocationLbl.hidden = YES;
            self.ibDropDownIcon.hidden = YES;
            self.ibFilterBtn.hidden = YES;
            self.ibSearchBtn.hidden = YES;
            self.ibLocationBtn.enabled = NO;
            self.ibSearchBtn.enabled = NO;
            self.ibFilterBtn.enabled = NO;
            [self.dealManager removeAllCollectedDeals];
            [self requestServerForDealRelevantDeals];
            break;
         
        //Voucher listing from promo code
        case 5:
            self.ibAltTitle.text = LocalisedString(@"Vouchers");
            self.ibAltTitle.hidden = NO;
            self.ibTitle.hidden = YES;
            self.ibUserLocationLbl.hidden = YES;
            self.ibDropDownIcon.hidden = YES;
            self.ibFilterBtn.hidden = YES;
            self.ibSearchBtn.hidden = YES;
            self.ibLocationBtn.enabled = NO;
            self.ibSearchBtn.enabled = NO;
            self.ibFilterBtn.enabled = NO;
            self.ibFooterHeightConstraint.constant = 0;
            [self.ibVoucherTable reloadData];
            break;
            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self changeLanguage];
    
    
    if (![Utils isGuestMode]) {
        [self RequestServerForVouchersCount];
        
        if (self.dealViewType == 5) {
            self.ibFooterHeightConstraint.constant = 0;
        }
        else{
            self.ibFooterHeightConstraint.constant = 50;
        }
    }
    else{
        self.ibFooterHeightConstraint.constant = 0;
    }
    
    [self.ibVoucherTable reloadData];
}

-(void)changeLanguage{
    self.ibWalletLbl.text = LocalisedString(@"Voucher Wallet");
    self.ibEmptyTitle.text = LocalisedString(@"Oops...");
    self.ibEmptyDesc.text = LocalisedString(@"This feature is temporarily unavailable in your country.");
    self.ibLoadingTxt.text = [NSString stringWithFormat:@"%@\n%@", LocalisedString(@"Collect Now"), LocalisedString(@"Pay Later")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatFiltersModel{
    //reset filter page
    self.filterController = nil;
    
    self.filtersModel = [[FiltersModel alloc] init];
    self.filtersModel.filterCategories = [[NSMutableArray<FilterCategoryModel> alloc] init];
    self.filtersModel.filterViewType = FilterViewTypeVoucher;
    
    //Sort
    FilterCategoryModel *sortCategory = [[FilterCategoryModel alloc] init];
    sortCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    sortCategory.categoryName = LocalisedString(@"Sort by");
    sortCategory.filterCategoryType = FilterTypeSort;
    
    FilterModel *latest = [[FilterModel alloc] init];
    latest.name = LocalisedString(@"Latest");
    latest.isSelected = YES;
    latest.sortType = SortTypeMostRecent;
    
    FilterModel *distance = [[FilterModel alloc] init];
    distance.name = LocalisedString(@"Distance");
    distance.isSelected = NO;
    distance.sortType = SortTypeNearest;
    
    FilterModel *popular = [[FilterModel alloc] init];
    popular.name = LocalisedString(@"Popular");
    popular.isSelected = NO;
    popular.sortType = SortTypeMostPopular;
    
    [sortCategory.filtersArray addObject:latest];
    [sortCategory.filtersArray addObject:distance];
    [sortCategory.filtersArray addObject:popular];
    
    [self.filtersModel.filterCategories addObject:sortCategory];
    
    //Category
    FilterCategoryModel *catCategory = [[FilterCategoryModel alloc] init];
    catCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    catCategory.categoryName = LocalisedString(@"Deals by Category");
    catCategory.filterCategoryType = FilterTypeCat;
    
    for (QuickBrowseModel *quickBrowse in self.quickBrowseModels) {
        FilterModel *filter = [[FilterModel alloc] init];
        filter.name = quickBrowse.name;
        filter.filterId = quickBrowse.category_group_id;
        filter.isSelected = NO;
        [catCategory.filtersArray addObject:filter];
    }
    
    [self.filtersModel.filterCategories addObject:catCategory];
    
    //Price
    FilterCategoryModel *priceCategory = [[FilterCategoryModel alloc] init];
    priceCategory.filtersArray = [[NSMutableArray<FilterModel> alloc] init];
    priceCategory.categoryName = LocalisedString(@"Deals by Budget");
    priceCategory.filterCategoryType = FilterTypePrice;
    
    FilterModel *filter = [[FilterModel alloc] init];
    FilterPriceModel *filterPrice = [[FilterPriceModel alloc] init];
    FilterCurrencyModel *filterCurrencyModel = [self getSelectedCountryFilterCurrencyModel];
    
    if (filterCurrencyModel) {
        filterPrice.currency = filterCurrencyModel.currency_symbol;
        filterPrice.min = filterCurrencyModel.min;
        filterPrice.max = filterCurrencyModel.max;
        filterPrice.interval = filterCurrencyModel.interval;
        filterPrice.selectedMin = filterCurrencyModel.min;
        filterPrice.selectedMax = filterCurrencyModel.max;
        filter.filterPrice = filterPrice;
        [priceCategory.filtersArray addObject:filter];
        [self.filtersModel.filterCategories addObject:priceCategory];
    }
}

-(NSDictionary*)getFilterDict{
    int sort = 1;
    NSMutableString *catString = [[NSMutableString alloc] init];
    int minPrice = 0;
    int maxPrice = 0;
    BOOL priceChanges = NO;
    
    for (FilterCategoryModel *filterCategory in self.filtersModel.filterCategories) {
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
                if (![Utils isStringNull:catString]) {
                    [catString substringToIndex:[catString length]-1];
                }
            }
                break;
                
            case FilterTypePrice:
            {
                FilterModel *priceModel = filterCategory.filtersArray[0];
                minPrice = priceModel.filterPrice.selectedMin;
                maxPrice = priceModel.filterPrice.selectedMax;
        
                if (priceModel.filterPrice.selectedMin != priceModel.filterPrice.min || priceModel.filterPrice.selectedMax != priceModel.filterPrice.max) {
                    priceChanges = YES;
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"sort": @(sort),
                                                                                       @"category_group": catString}];
    
    if (priceChanges) {
        [finalDict addEntriesFromDictionary:@{@"min_price": @(minPrice),
                                              @"max_price": @(maxPrice)}];
    }
    
    return finalDict;
}

-(FilterCurrencyModel*)getSelectedCountryFilterCurrencyModel{
    CountriesModel *countries = [[DataManager Instance] appInfoModel].countries;
    int selectedCountryId = self.locationModel.countryId;
    
    if (selectedCountryId == 0) {
        selectedCountryId = countries.current_country.country_id;   //Default country id set to current_country
    }
    for (CountryModel *country in countries.countries) {
        if (selectedCountryId == country.country_id) {
            return country.filter_currency;
        }
    }
    
    return nil;
}

-(void)toggleEmptyView:(BOOL)shouldShow{
    self.ibEmptyView.hidden = !shouldShow;
    self.ibLoadingView.hidden = shouldShow;
}

#pragma mark - Initialization

-(void)initDataWithShopID:(NSString*)shopID
{
    self.shopID = shopID;
    self.dealViewType = 1;
}

-(void)initWithLocation:(HomeLocationModel*)locationModel quickBrowseModel:(NSArray<QuickBrowseModel>*)quickBrowseModel{
    _locationModel = locationModel;
    _quickBrowseModels = quickBrowseModel;
    self.dealViewType = 3;
    [self formatFiltersModel];
}

-(void)initData:(DealCollectionModel*)model withLocation:(HomeLocationModel*)locationModel quickBrowseModel:(NSArray<QuickBrowseModel>*)quickBrowseModel
{
    self.dealViewType = 2;
    self.dealCollectionModel = model;
    _locationModel = locationModel;
    _quickBrowseModels = quickBrowseModel;
    [self formatFiltersModel];
}

-(void)initWithDealId:(NSString*)dealId{
    self.dealId = dealId;
    self.dealViewType = 4;
}

-(void)initWithDealsModel:(DealsModel *)dealsModel{
    _dealsModel = dealsModel;
    [self.dealsArray removeAllObjects];
    [self.dealsArray addObjectsFromArray:self.dealsModel.arrDeals];
    self.dealViewType = 5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - IBAction

- (IBAction)btnBackClicked:(id)sender {
    
    if (self.didSelectHomeLocationBlock) {
        self.didSelectHomeLocationBlock(self.locationModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSearchLocationClicked:(id)sender {
    _ct3_SearchListingViewController = nil;
    
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}

- (IBAction)filterClicked:(id)sender {
    [self presentViewController:self.filterController animated:YES completion:^{}];
}

- (IBAction)footerBtnClicked:(id)sender {
    self.walletListingViewController = nil;
    [self.navigationController pushViewController:self.walletListingViewController animated:YES];
}

- (IBAction)locationBtnClicked:(id)sender {
    self.searchLocationViewController = nil;
    [self presentViewController:self.searchLocationViewController animated:YES completion:nil];
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Declaration

-(CT3_SearchListingViewController*)ct3_SearchListingViewController
{
    if (!_ct3_SearchListingViewController) {
        _ct3_SearchListingViewController = [CT3_SearchListingViewController new];
    }
    
    return _ct3_SearchListingViewController;
}
-(GeneralFilterViewController*)filterController
{
    if (!_filterController) {
        _filterController = [GeneralFilterViewController new];
        _filterController.delegate = self;
        [_filterController initWithFilter:self.filtersModel];
    }
    
    return _filterController;
}

-(DealDetailsViewController*)dealDetailsViewController{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    return _dealDetailsViewController;
}

-(WalletListingViewController*)walletListingViewController{
    if(!_walletListingViewController){
        _walletListingViewController = [WalletListingViewController new];
    }
    return _walletListingViewController;
}

-(PromoPopOutViewController *)promoPopOutViewController{
    if (!_promoPopOutViewController) {
        _promoPopOutViewController = [PromoPopOutViewController new];
    }
    return _promoPopOutViewController;
}

-(DealManager *)dealManager{
    if(!_dealManager)
    {
        _dealManager = [DealManager Instance];
    }
    return _dealManager;
}

-(NSMutableArray<DealModel> *)dealsArray{
    if (!_dealsArray) {
        _dealsArray = [[NSMutableArray<DealModel> alloc] init];
    }
    return _dealsArray;
}

-(DealRedeemViewController *)dealRedeemViewController{
    if (!_dealRedeemViewController) {
        _dealRedeemViewController = [DealRedeemViewController new];
    }
    return _dealRedeemViewController;
}

-(SearchLocationViewController *)searchLocationViewController{
    if (!_searchLocationViewController) {
        _searchLocationViewController = [SearchLocationViewController new];
        
        __weak VoucherListingViewController *weakSelf = self;
        _searchLocationViewController.homeLocationRefreshBlock = ^(HomeLocationModel *hModel, CountryModel *countryModel){
            weakSelf.locationModel = hModel;
            weakSelf.locationModel.countryId = countryModel.country_id;
            
            [Utils saveUserLocation:weakSelf.locationModel.locationName Longtitude:weakSelf.locationModel.longtitude Latitude:weakSelf.locationModel.latitude PlaceID:weakSelf.locationModel.place_id CountryID:countryModel.country_id SourceType:weakSelf.locationModel.type];
            
            weakSelf.ibUserLocationLbl.text = weakSelf.locationModel.locationName;
            [weakSelf.dealsArray removeAllObjects];
            weakSelf.dealsModel = nil;
            weakSelf.ibVoucherTable.tableFooterView = nil;
            [weakSelf toggleEmptyView:NO];
            if (weakSelf.dealCollectionModel) {
                [weakSelf requestServerForDealListing];
            }
            else{
                [weakSelf requestServerForSuperDealListing];
            }
            
            [weakSelf formatFiltersModel];
            [weakSelf.searchLocationViewController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _searchLocationViewController;
}

-(RedemptionHistoryViewController *)redemptionHistoryViewController{
    if (!_redemptionHistoryViewController) {
        _redemptionHistoryViewController = [RedemptionHistoryViewController new];
    }
    return _redemptionHistoryViewController;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Utils isArrayNull:self.dealsArray]) {
        self.ibVoucherTable.backgroundView = self.ibEmptyStateView;
        self.view.backgroundColor = [UIColor whiteColor];
        return 0;
    }
    else{
        self.ibVoucherTable.backgroundView = nil;
        self.view.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dealsArray) {
        return self.dealsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell"];
    voucherCell.voucherCellDelegate = self;
    
    
    voucherCell.constUpperContentHeight.constant = tableView.frame.size.width/2;
    if (![Utils isArrayNull:self.dealsArray]) {
        DealModel *deal = [self.dealsArray objectAtIndex:indexPath.row];
        
        if ([self.dealManager checkIfDealIsCollected:deal.dID]) {
            deal.voucher_info.voucher_id = [self.dealManager getCollectedDealVoucherId:deal.dID];
            [voucherCell setDealModel:deal];
        }
        else{
            deal.voucher_info.voucher_id = nil;
            [voucherCell setDealModel:deal];
        }
    }  
    
    return voucherCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DealModel *dealModel = [self.dealsArray objectAtIndex:indexPath.row];
    self.dealDetailsViewController = nil;
    [self.dealDetailsViewController setDealModel:dealModel];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        [self.dealDetailsViewController setupView];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - DelegateImplemention
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = self.ibVoucherTable.contentOffset.y;
    CGFloat maximumOffset = self.ibVoucherTable.contentSize.height - self.ibVoucherTable.frame.size.height;
    
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.ibVoucherTable.frame.size.height/2) {
        
        if(![Utils isStringNull:self.dealsModel.paging.next] && !self.isLoading)
        {
            [self.ibActivityIndicatorView startAnimating];
            
            switch (self.dealViewType) {
                case 1:
                    [self requestServerForShopDeal];
                    break;
                case 2:
                    [self requestServerForDealListing];

                    break;
                    
                case 3:
                    [self requestServerForSuperDealListing];

                    break;
                    
                case 4:
                    [self requestServerForDealRelevantDeals];
                    
                default:
                    break;
            }
            
        }
    }
}

-(void)voucherCollectRedeemClicked:(DealModel *)dealModel{
    if ([Utils isGuestMode]) {
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login First") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }
    else{
        if (![Utils isPhoneNumberVerified]) {
            [Utils showVerifyPhoneNumber:self];
            return;
        }
    }
    
    if ([Utils isStringNull:dealModel.voucher_info.voucher_id]) {
        if (dealModel.total_available_vouchers == 0) {
            return;
        }
        
        if (dealModel.shops.count == 1) {
            SeShopDetailModel *shopModel = [dealModel.shops objectAtIndex:0];
            [self requestServerToCollectVoucher:dealModel fromShop:shopModel];
        }
        else if(dealModel.shops.count > 1){
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:PopOutViewTypeChooseShop];
            [self.promoPopOutViewController setPopOutCondition:PopOutConditionChooseShopOnly];
            [self.promoPopOutViewController setDealModel:dealModel];
            [self.promoPopOutViewController setShopArray:dealModel.shops];
            self.promoPopOutViewController.promoPopOutDelegate = self;
            
            STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:self.promoPopOutViewController];
            popOutController.containerView.backgroundColor = [UIColor clearColor];
            [popOutController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popOutController presentInViewController:self];
            [popOutController setNavigationBarHidden:YES];
        }
    }
    else{
        if (dealModel.voucher_info.redeem_now) {
            self.dealRedeemViewController = nil;
            [self.dealRedeemViewController setDealModel:dealModel];
            self.dealRedeemViewController.dealRedeemDelegate = self;
            [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
        }
        else{
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:PopOutViewTypeError];
            [self.promoPopOutViewController setDealModel:dealModel];
            
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopOutViewController];
            popupController.containerView.backgroundColor = [UIColor clearColor];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController presentInViewController:self];
            [popupController setNavigationBarHidden:YES];
        }
    }
}

-(void)chooseShopConfirmClicked:(DealModel *)dealModel forShop:(SeShopDetailModel *)shopModel{
    [self requestServerToCollectVoucher:dealModel fromShop:shopModel];
}

-(void)applyFilterClicked:(FiltersModel *)filtersModel{
    _filtersModel = filtersModel;
    
    self.dealsModel = nil;
    [self.dealsArray removeAllObjects];
    self.ibVoucherTable.tableFooterView = nil;
    [self toggleEmptyView:NO];
    if (self.dealViewType == 2) {
        [self requestServerForDealListing];
    }
    else if (self.dealViewType == 3){
        [self requestServerForSuperDealListing];
    }
}

-(void)onDealRedeemed:(DealModel*)dealModel{
    self.redemptionHistoryViewController = nil;
    [self.navigationController pushViewController:self.redemptionHistoryViewController animated:YES];
}

#pragma mark - RequestServer

-(void)requestServerForSuperDealListing{
    
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *fixedDict;
    
    if ([Utils isGuestMode]) {
       fixedDict = @{@"guest_id":[Utils getUniqueDeviceIdentifier],
                                    @"timezone_offset":[Utils getTimeZone],
                                    @"type":@"search",
                                    @"offset":@(self.dealsModel.offset + self.dealsModel.limit),
                                    @"limit":@(ARRAY_LIST_SIZE)
                                    };

    }
    else{
        fixedDict = @{@"token":[Utils getAppToken],
                                    @"timezone_offset":[Utils getTimeZone],
                                    @"type":@"search",
                                    @"offset":@(self.dealsModel.offset + self.dealsModel.limit),
                                    @"limit":@(ARRAY_LIST_SIZE)
                                    };

    }
    
    NSDictionary *placeDict = @{@"place_id": self.locationModel.place_id? self.locationModel.place_id : @"",
                                @"lat": self.locationModel.latitude? self.locationModel.latitude : @"",
                                @"lng": self.locationModel.longtitude? self.locationModel.longtitude : @"",
                                @"address_components": self.locationModel.dictAddressComponent? [Utils convertToJsonString:self.locationModel.dictAddressComponent] : @""
                                };
    
    [finalDict addEntriesFromDictionary:fixedDict];
    [finalDict addEntriesFromDictionary:placeDict];
    
    if (self.filtersModel) {
        [finalDict addEntriesFromDictionary:[self getFilterDict]];
    }
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSuperDeals param:finalDict appendString:nil completeHandler:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealsArray addObjectsFromArray:self.dealsModel.arrDeals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];
        
        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibVoucherTable.tableFooterView = nil;
        }
        else{
            self.ibVoucherTable.tableFooterView = self.ibFooterView;
        }
        
        if ([Utils isArrayNull:self.dealsArray]) {
            [self toggleEmptyView:YES];
        }
        else{
            [self toggleEmptyView:NO];
        }
        
    } errorBlock:^(id object) {
        self.isLoading = NO;
        self.ibVoucherTable.tableFooterView = nil;
        [self toggleEmptyView:YES];
    }];
}

-(void)requestServerForDealListing{
    
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
    @try {
        NSDictionary *fixedDict = @{@"token":[Utils getAppToken],
                                    @"deal_collection_id" : self.dealCollectionModel.deal_collection_id,
                                    @"offset":@(self.dealsModel.offset + self.dealsModel.limit),
                                    @"limit":@(ARRAY_LIST_SIZE),
                                    };
        
        NSDictionary *placeDict = @{@"place_id": self.locationModel.place_id? self.locationModel.place_id : @"",
                                    @"lat": self.locationModel.latitude? self.locationModel.latitude : @"",
                                    @"lng": self.locationModel.longtitude? self.locationModel.longtitude : @"",
                                    @"address_components": self.locationModel.dictAddressComponent? [Utils convertToJsonString:self.locationModel.dictAddressComponent] : @""
                                    };
        
        [finalDict addEntriesFromDictionary:fixedDict];
        [finalDict addEntriesFromDictionary:placeDict];
        
        if (self.filtersModel) {
            [finalDict addEntriesFromDictionary:[self getFilterDict]];
        }

    }
    @catch (NSException *exception) {
        SLog(@"error passing model in requestServerForDealListing");
        self.isLoading = NO;
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/deals",self.dealCollectionModel.deal_collection_id];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetDealCollectionDeals param:finalDict appendString:appendString completeHandler:^(id object) {
        
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealsArray addObjectsFromArray:self.dealsModel.arrDeals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];
        
        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibVoucherTable.tableFooterView = nil;
        }
        else{
            self.ibVoucherTable.tableFooterView = self.ibFooterView;
        }
        
        if ([Utils isArrayNull:self.dealsArray]) {
            [self toggleEmptyView:YES];
        }
        else{
            [self toggleEmptyView:NO];
        }
    } errorBlock:^(id object) {
        self.isLoading = NO;
        self.ibVoucherTable.tableFooterView = nil;
        [self toggleEmptyView:YES];
    }];
}

-(void)requestServerForShopDeal
{
    
    
    if (self.isLoading) {
        return;
    }
    NSDictionary* dict;
    @try {
        
        dict = @{@"seetishop_id" : self.shopID,
                 @"token" : [Utils getAppToken],
                 @"offset":@(self.dealsModel.offset + self.dealsModel.limit),
                 @"limit":@(ARRAY_LIST_SIZE),
                 };
        
    }
    @catch (NSException *exception) {
        
    }
    
    self.isLoading = YES;

    
    NSString* appendString = [NSString stringWithFormat:@"%@/deals",self.shopID];
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetSeetiShopDeal param:dict appendString:appendString completeHandler:^(id object) {
    
        
        DealsModel* model = [[ConnectionManager dataManager]dealsModel];
        self.dealsModel = model;
        [self.dealsArray addObjectsFromArray:self.dealsModel.arrDeals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];

        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibVoucherTable.tableFooterView = nil;
        }
        else{
            self.ibVoucherTable.tableFooterView = self.ibFooterView;
        }
        
        if ([Utils isArrayNull:self.dealsArray]) {
            [self toggleEmptyView:YES];
        }
        else{
            [self toggleEmptyView:NO];
        }
    } errorBlock:^(id object) {
        self.isLoading = NO;
        self.ibVoucherTable.tableFooterView = nil;
        [self toggleEmptyView:YES];
    }];
    
}

-(void)requestServerForDealRelevantDeals{
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    
    NSString* appendString = [NSString stringWithFormat:@"%@/relevent-deals", self.dealId];
    
    NSDictionary* dict = @{@"limit": @(ARRAY_LIST_SIZE),
                           @"offset": @(self.dealsModel.offset + self.dealsModel.limit),
                           @"deal_id" : self.dealId,
                           @"token" : [Utils getAppToken]
                           };
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetDealRelevantDeals param:dict appendString:appendString completeHandler:^(id object) {
        DealsModel *deals = [[ConnectionManager dataManager]dealsModel];
        self.dealsModel = deals;
        [self.dealsArray addObjectsFromArray:self.dealsModel.arrDeals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];
        
        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibVoucherTable.tableFooterView = nil;
        }
        else{
            self.ibVoucherTable.tableFooterView = self.ibFooterView;
        }
        
        if ([Utils isArrayNull:self.dealsArray]) {
            [self toggleEmptyView:YES];
        }
        else{
            [self toggleEmptyView:NO];
        }
    } errorBlock:^(id object) {
        self.isLoading = NO;
        self.ibVoucherTable.tableFooterView = nil;
        [self toggleEmptyView:YES];
    }];
}

-(void)requestServerToCollectVoucher:(DealModel*)model fromShop:(SeShopDetailModel*)shopModel{
    if (self.isCollecting) {
        return;
    }
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *coreDict = @{@"deal_id":model.dID,
                           @"shop_id":shopModel.seetishop_id,
                           @"token": [Utils getAppToken]};
    
    CLLocation *userLocation = [[SearchManager Instance] getAppLocation];
    
    NSDictionary *locationDict = @{@"lat": @(userLocation.coordinate.latitude),
                                   @"lng": @(userLocation.coordinate.longitude)};
    
    [finalDict addEntriesFromDictionary:coreDict];
    [finalDict addEntriesFromDictionary:locationDict];
    
    self.isCollecting = YES;
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostCollectDeals param:finalDict completeHandler:^(id object) {
        DealModel *dealModel = [[ConnectionManager dataManager] dealModel];
        model.voucher_info = dealModel.voucher_info;
        model.total_available_vouchers = dealModel.total_available_vouchers;
        
        [self.dealManager setCollectedDeal:dealModel.dID withVoucherId:dealModel.voucher_info.voucher_id];
        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Collected in Voucher Wallet") Type:TSMessageNotificationTypeSuccess];
        [self RequestServerForVouchersCount];
        [self.ibVoucherTable reloadData];
        self.isCollecting = NO;
    } errorBlock:^(id object) {
        self.isCollecting = NO;
    }];
}

-(void)RequestServerForVouchersCount{
    NSDictionary *dict = @{@"token": [Utils getAppToken]};
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers/count", [Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetUserVouchersCount param:dict appendString:appendString completeHandler:^(id object) {
        NSDictionary *dict = object[@"data"];
        int count = (int)[dict[@"count"] integerValue];
        self.ibWalletCountLbl.text = [NSString stringWithFormat:@"%d", count];
        [self.dealManager setWalletCount:count];
    } errorBlock:^(id object) {
        
    }];
}

@end

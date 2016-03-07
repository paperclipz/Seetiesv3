//
//  VoucherListingViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherListingViewController.h"

@interface VoucherListingViewController ()
@property (nonatomic) DealsModel *dealsModel;
@property (nonatomic) DealCollectionModel *dealCollectionModel;
@property (nonatomic) HomeLocationModel *locationModel;

@property (nonatomic) NSMutableArray<DealModel> *dealsArray;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL  isCollecting;
@property (nonatomic) DealManager *dealManager;

@property (weak, nonatomic) IBOutlet UILabel *ibUserLocationLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibVoucherTable;
@property (weak, nonatomic) IBOutlet UIView *ibFilterView;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletCountLbl;

@property (strong, nonatomic)GeneralFilterViewController* filterController;
@property (nonatomic) DealDetailsViewController *dealDetailsViewController;
@property (nonatomic) WalletListingViewController *walletListingViewController;
@property (nonatomic) PromoPopOutViewController *promoPopOutViewController;
@property (nonatomic) DealRedeemViewController *dealRedeemViewController;
@property (nonatomic) SearchLocationViewController *searchLocationViewController;
@end

@implementation VoucherListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isLoading = NO;
    self.isCollecting = NO;
    [self.dealManager removeAllCollectedDeals];
    [self.ibVoucherTable registerNib:[UINib nibWithNibName:@"VoucherCell" bundle:nil] forCellReuseIdentifier:@"VoucherCell"];
    
    self.ibVoucherTable.estimatedRowHeight = [VoucherCell getHeight];
    self.ibVoucherTable.rowHeight = UITableViewAutomaticDimension;
    [Utils setRoundBorder:self.ibWalletCountLbl color:OUTLINE_COLOR borderRadius:self.ibWalletCountLbl.frame.size.width/2];
    
    if (self.locationModel) {
        self.ibUserLocationLbl.text = self.locationModel.locationName;
    }
    
    if (self.dealCollectionModel) {
        NSDictionary *collectionDict = self.dealCollectionModel.content[0];
        self.ibTitle.text = collectionDict[@"title"];
    }
    else{
        self.ibTitle.text = LocalisedString(@"Deal of the day");
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self RequestServerForVouchersCount];
    [self.ibVoucherTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithLocation:(HomeLocationModel*)locationModel{
    _locationModel = locationModel;
    
    [self requestServerForSuperDealListing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filterClicked:(id)sender {
  
    GeneralFilterViewController *filterController = [[GeneralFilterViewController alloc] initWithFilter:[self getDummy]];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:filterController];
    nav.navigationBarHidden =  YES;
    [self presentViewController:nav animated:YES completion:nil];
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

-(NSArray*)getDummy{
    NSDictionary *catFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Category", @"type",
                               @[@"1", @"2", @"3", @"4", @"5"], @"array", nil];
    NSDictionary *sortFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Sort", @"type",
                               @[@"1", @"2", @"3"], @"array", nil];
    NSDictionary *priceFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"Price", @"type",
                               @"0", @"min",
                               @"100", @"max", nil];
    
    NSDictionary *availabilityFilter = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Availability", @"type",
                                 @"0", @"min",
                                 @"100", @"max", nil];

    
    NSArray *filterArray = @[sortFilter, catFilter, priceFilter,availabilityFilter];
    return filterArray;
}

#pragma mark - Declaration
-(GeneralFilterViewController*)filterController
{
    if (!_filterController) {
        _filterController = [GeneralFilterViewController new];
        
        [self.view addSubview:_filterController.view];
        
        _filterController.view.hidden = YES;
        CGFloat yOrigin = self.ibFilterView.frame.origin.y + self.ibFilterView.frame.size.height;
        [_filterController.view setY:yOrigin];
        [_filterController.view setHeight:self.view.frame.size.height - yOrigin];        
        [_filterController.view setWidth:self.view.frame.size.width];

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
    return [DealManager Instance];
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
        _searchLocationViewController.homeLocationRefreshBlock = ^(HomeLocationModel *hModel){
            weakSelf.locationModel = hModel;
            
            weakSelf.ibUserLocationLbl.text = weakSelf.locationModel.locationName;
            [weakSelf.dealsArray removeAllObjects];
            weakSelf.dealsModel = nil;
            if (weakSelf.dealCollectionModel) {
                [weakSelf requestServerForDealListing];
            }
            else{
                [weakSelf requestServerForSuperDealListing];
            }
            
            [weakSelf.searchLocationViewController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _searchLocationViewController;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dealsArray) {
        return self.dealsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell"];
    voucherCell.voucherCellDelegate = self;
    
    if (![Utils isArrayNull:self.dealsArray]) {
        DealModel *deal = [self.dealsArray objectAtIndex:indexPath.row];
        
        if ([self.dealManager checkIfDealIsCollected:deal.dID]) {
            [voucherCell setDealModel:[self.dealManager getCollectedDeal:deal.dID]];
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
//            [(UIActivityIndicatorView *)self.ibVoucherTable startAnimating];
            if (self.dealCollectionModel) {
                [self requestServerForDealListing];
            }
            else{
                [self requestServerForSuperDealListing];
            }
            
        }
    }
}

-(void)voucherCollectRedeemClicked:(DealModel *)dealModel{
    if ([Utils isStringNull:dealModel.voucher_info.voucher_id]) {
        if (dealModel.shops.count == 1) {
            SeShopDetailModel *shopModel = [dealModel.shops objectAtIndex:0];
            [self requestServerToCollectVoucher:dealModel fromShop:shopModel];
        }
        else if(dealModel.shops.count > 1){
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:ChooseShopViewType];
            [self.promoPopOutViewController setPopOutCondition:ChooseShopOnlyPopOutCondition];
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
        self.dealRedeemViewController = nil;
        [self.dealRedeemViewController setDealModel:dealModel];
        [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
    }
}

-(void)chooseShopConfirmClicked:(DealModel *)dealModel forShop:(SeShopDetailModel *)shopModel{
    [self requestServerToCollectVoucher:dealModel fromShop:shopModel];
}

#pragma mark - RequestServer

-(void)requestServerForSuperDealListing{
    
    if (self.isLoading) {
        return;
    }
    
    [LoadingManager show];
    self.isLoading = YES;
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *fixedDict = @{@"token":[Utils getAppToken],
                                @"timezone_offset":[Utils getTimeZone],
                                @"type":@"search",
                                @"offset":@(self.dealsModel.offset + self.dealsModel.limit),
                                @"limit":@(ARRAY_LIST_SIZE)
                                };
    
    NSDictionary *placeDict = @{@"place_id": self.locationModel.place_id? self.locationModel.place_id : @"",
                                @"lat": self.locationModel.latitude? self.locationModel.latitude : @"",
                                @"lng": self.locationModel.longtitude? self.locationModel.longtitude : @"",
                                @"address_components": self.locationModel.dictAddressComponent? [Utils convertToJsonString:self.locationModel.dictAddressComponent] : @""
                                };
    
    [finalDict addEntriesFromDictionary:fixedDict];
    [finalDict addEntriesFromDictionary:placeDict];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSuperDeals param:finalDict appendString:nil completeHandler:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealsArray addObjectsFromArray:self.dealsModel.deals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];
        self.isLoading = NO;
        [LoadingManager hide];
    } errorBlock:^(id object) {
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}

-(void)initData:(DealCollectionModel*)model withLocation:(HomeLocationModel*)locationModel
{
    self.dealCollectionModel = model;
    _locationModel = locationModel;
    
    [self requestServerForDealListing];
    
}

-(void)requestServerForDealListing{
    
    if (self.isLoading) {
        return;
    }
    
    [LoadingManager show];
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

    }
    @catch (NSException *exception) {
        SLog(@"error passing model in requestServerForDealListing");
        [LoadingManager hide];
        self.isLoading = NO;
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/deals",self.dealCollectionModel.deal_collection_id];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetDealCollectionDeals param:finalDict appendString:appendString completeHandler:^(id object) {
        
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealsArray addObjectsFromArray:self.dealsModel.deals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        [self.ibVoucherTable reloadData];
        self.isLoading = NO;
        [LoadingManager hide];
        
    } errorBlock:^(id object) {
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}

-(void)requestServerToCollectVoucher:(DealModel*)model fromShop:(SeShopDetailModel*)shopModel{
    if (self.isCollecting) {
        return;
    }
    
    NSDictionary *dict = @{@"deal_id":model.dID,
                           @"shop_id":shopModel.seetishop_id,
                           @"token": [Utils getAppToken]};
    
    self.isCollecting = YES;
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostCollectDeals param:dict completeHandler:^(id object) {
        DealModel *dealModel = [[ConnectionManager dataManager] dealModel];
        [self.dealManager setCollectedDeal:dealModel.dID forDeal:dealModel];
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

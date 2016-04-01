//
//  WalletListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletListingViewController.h"

@protocol DealExpiryDateModel

@end

@interface WalletListingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibWalletHeader;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterLbl;
@property (strong, nonatomic) IBOutlet UIView *ibEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibEmptyBtn;

@property (strong, nonatomic) IBOutlet UIView *ibTableFooterView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ibActivityIndicatorView;

@property (nonatomic)PromoPopOutViewController *promoPopOutViewController;
@property(nonatomic)RedemptionHistoryViewController *redemptionHistoryViewController;
@property (nonatomic) DealDetailsViewController *dealDetailsViewController;
@property (nonatomic)DealRedeemViewController *dealRedeemViewController;
@property (nonatomic) VoucherListingViewController *voucherListingViewController;

@property(nonatomic) NSMutableArray<DealExpiryDateModel> *voucherArray;
@property(nonatomic) DealsModel *dealsModel;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) DealManager *dealManager;
@end

@implementation WalletListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"WalletVoucherCell" bundle:nil] forCellReuseIdentifier:@"WalletVoucherCell"];
    self.ibTableView.estimatedRowHeight = [WalletVoucherCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    [Utils setRoundBorder:self.ibEmptyBtn color:DEVICE_COLOR borderRadius:self.ibEmptyBtn.frame.size.height/2 borderWidth:1.0f];
    
    self.ibTableView.tableFooterView = self.ibTableFooterView;
    
    [self.ibTableView addPullToRefreshWithActionHandler:^{
        self.dealsModel = nil;
        self.ibTableView.tableFooterView = self.ibTableFooterView;
        [self requestServerForVoucherListing];
    }];
    
    self.isLoading = NO;
    [LoadingManager show];
    [self requestServerForVoucherListing];
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibWalletHeader.text = LocalisedString(@"Voucher Wallet");
    self.ibFooterLbl.text = LocalisedString(@"Enter a promo code");
    self.ibEmptyTitle.text = LocalisedString(@"Start filling your voucher wallet now!");
    self.ibEmptyDesc.text = LocalisedString(@"You currently do not have any vouchers. Start collecting now!");
    [self.ibEmptyBtn setTitle:LocalisedString(@"See Deals of the Day") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rearrangeVoucherList{
    NSDateFormatter *fullFormatter = [[NSDateFormatter alloc] init];
    [fullFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    [monthYearFormatter setDateFormat:@"MMMM yyyy"];
    
    if (self.dealsModel != nil) {
        NSMutableArray<DealModel> *tempNewArray = [[NSMutableArray<DealModel> alloc] init];
        NSMutableArray<DealModel> *tempDateArray = [[NSMutableArray<DealModel> alloc] init];
        NSString *previousGroup = @"";
        
        for (DealModel *dealModel in self.dealsModel.arrDeals) {
            if (dealModel.voucher_info.is_new) {
                [tempNewArray addObject:dealModel];
            }
            else{
                if (![Utils isArrayNull:tempNewArray]) {
                    DealExpiryDateModel *dealExpirtyDateModel = [[DealExpiryDateModel alloc] init];
                    dealExpirtyDateModel.expiryDate = @"new";
                    dealExpirtyDateModel.dealModelArray = tempNewArray;
                    [self addToVoucherArray:dealExpirtyDateModel];
                    tempNewArray = [[NSMutableArray<DealModel> alloc] init];
                }
                
                NSString *expiryString = dealModel.voucher_info.expired_at;
                NSString *formattedExpiryString;
                if ([Utils isValidDateString:expiryString]) {
                    NSDate *expiryDate = [fullFormatter dateFromString:expiryString];
                    formattedExpiryString = [monthYearFormatter stringFromDate:expiryDate];
                }
                else{
                    formattedExpiryString = LocalisedString(@"noDate");
                }
                
                if ([previousGroup isEqualToString:formattedExpiryString]) {
                    [tempDateArray addObject:dealModel];
                }
                else{
                    if (![Utils isArrayNull:tempDateArray]) {
                        DealExpiryDateModel *dealExpirtyDateModel = [[DealExpiryDateModel alloc] init];
                        dealExpirtyDateModel.expiryDate = previousGroup;
                        dealExpirtyDateModel.dealModelArray = tempDateArray;
                        
                        [self addToVoucherArray:dealExpirtyDateModel];
                        
                        tempDateArray = [[NSMutableArray<DealModel> alloc] init];
                    }
                    
                    [tempDateArray addObject:dealModel];
                }
                previousGroup = formattedExpiryString;
            }
            
        }
        
        //Check for leftover array that has not been added to voucher array
        if (![Utils isArrayNull:tempNewArray]) {
            DealExpiryDateModel *dealExpirtyDateModel = [[DealExpiryDateModel alloc] init];
            dealExpirtyDateModel.expiryDate = @"new";
            dealExpirtyDateModel.dealModelArray = tempNewArray;
            [self addToVoucherArray:dealExpirtyDateModel];
        }
        if (![Utils isArrayNull:tempDateArray]) {
            DealExpiryDateModel *dealExpirtyDateModel = [[DealExpiryDateModel alloc] init];
            dealExpirtyDateModel.expiryDate = previousGroup;
            dealExpirtyDateModel.dealModelArray = tempDateArray;
            [self addToVoucherArray:dealExpirtyDateModel];
        }
    }
}

-(void)addToVoucherArray:(DealExpiryDateModel*)expiryModel{
    if ([self.voucherArray containsObject:expiryModel]) {
        for (DealExpiryDateModel *existngExpiryModel in self.voucherArray) {
            if ([existngExpiryModel isEqual:expiryModel]) {
                [existngExpiryModel.dealModelArray addObjectsFromArray:expiryModel.dealModelArray];
                break;
            }
        }
    }
    else{
        [self.voucherArray addObject:expiryModel];
    }
}

-(void)removeDealFromVoucherArray:(DealModel*)dealModel{
    NSMutableArray<DealExpiryDateModel> *toBeDiscardedArray = [[NSMutableArray<DealExpiryDateModel> alloc] init];
    for (DealExpiryDateModel *expiryModel in self.voucherArray) {
        if([expiryModel.dealModelArray containsObject:dealModel]){
            [expiryModel.dealModelArray removeObject:dealModel];
            
            if ([Utils isArrayNull:expiryModel.dealModelArray]) {
                DealExpiryDateModel *toBeDiscardedModel = [[DealExpiryDateModel alloc] init];
                toBeDiscardedModel.expiryDate = expiryModel.expiryDate;
                [toBeDiscardedArray addObject:toBeDiscardedModel];
            }
        }
    }
    
    if (![Utils isArrayNull:toBeDiscardedArray]) {
        [self.voucherArray removeObjectsInArray:toBeDiscardedArray];
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

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Utils isArrayNull:self.voucherArray]) {
        [self.ibEmptyBtn setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
        self.ibTableView.backgroundView = self.ibEmptyView;
        self.view.backgroundColor = [UIColor whiteColor];
        return 0;
    }
    else{
        self.ibTableView.backgroundView = nil;
        self.view.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
        return self.voucherArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Utils isArrayNull:self.voucherArray]) {
        DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
        return expiryModel.dealModelArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletVoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"WalletVoucherCell"];
    voucherCell.walletVoucherDelegate = self;
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    [voucherCell setDealModel:voucher];
        
    return voucherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
//    return [WalletVoucherCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    
    UIView *contentView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    contentView.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 15, tableView.frame.size.width, 21)];
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
    if ([expiryModel.expiryDate isEqualToString:@"new"]) {
        label.text = LocalisedString(@"New Deals");
    }
    else if ([expiryModel.expiryDate isEqualToString:@"noDate"]){
        label.text = LocalisedString(@"No expiry");
    }
    else{
        label.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expired on"), expiryModel.expiryDate];
    }
    
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    self.dealDetailsViewController = nil;
    [self.dealDetailsViewController setDealModel:voucher];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        [self.dealDetailsViewController setupView];
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    
    if ([voucher.voucher_type isEqualToString:VOUCHER_TYPE_PUBLIC]) {
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:LocalisedString(@"Remove Voucher") message:LocalisedString(@"Are you sure you want to delete this voucher?") cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
                DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
                [self requestServerToDeleteVoucher:voucher withIndexPath:indexPath];
            }
            
        }];
    }
}

#pragma mark - IBAction
- (IBAction)footerBtnClicked:(id)sender {
    if (![Utils isPhoneNumberVerified]) {
        [Utils showVerifyPhoneNumber:self];
        return;
    }
    
    self.promoPopOutViewController = nil;
    [self.promoPopOutViewController setViewType:PopOutViewTypeEnterPromo];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopOutViewController];
    popupController.containerView.backgroundColor = [UIColor clearColor];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [popupController presentInViewController:self];
    [popupController setNavigationBarHidden:YES];
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)historyBtnClicked:(id)sender {
    self.redemptionHistoryViewController = nil;
    [self.navigationController pushViewController:self.redemptionHistoryViewController animated:YES];
}

-(void)redeemVoucherClicked:(DealModel*)deal{
//    To do more checking whether voucher can be redeemed
    if (![Utils isPhoneNumberVerified]) {
        [Utils showVerifyPhoneNumber:self];
        return;
    }
    
    if (deal.voucher_info.redeem_now) {
        self.dealRedeemViewController = nil;
        [self.dealRedeemViewController setDealModel:deal];
        self.dealRedeemViewController.dealRedeemDelegate = self;
        [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
    }
    else{
        self.promoPopOutViewController = nil;
        [self.promoPopOutViewController setViewType:PopOutViewTypeError];
        [self.promoPopOutViewController setDealModel:deal];
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopOutViewController];
        popupController.containerView.backgroundColor = [UIColor clearColor];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        [popupController presentInViewController:self];
        [popupController setNavigationBarHidden:YES];
    }

}

-(void)onDealRedeemed:(DealModel *)dealModel{
    [self removeDealFromVoucherArray:dealModel];
    [self.ibTableView reloadData];
}

- (IBAction)emptyBtnClicked:(id)sender {
    self.voucherListingViewController = nil;
    HomeModel *homeModel = [[DataManager Instance] homeModel];
    NSDictionary *locationDict = [Utils getSavedUserLocation];
    HomeLocationModel *locationModel = [[HomeLocationModel alloc] init];
    @try {
        locationModel.latitude = locationDict[KEY_LATITUDE];
        locationModel.longtitude = locationDict[KEY_LONGTITUDE];
        locationModel.place_id = locationDict[KEY_PLACE_ID];
        locationModel.locationName = locationDict[KEY_LOCATION];
    } @catch (NSException *exception) {
        SLog(@"Wallet location exception: %@", exception);
    }
    
    [self.voucherListingViewController initWithLocation:locationModel filterCurrency:homeModel.filter_currency quickBrowseModel:[homeModel.quick_browse mutableCopy]];
    [self.navigationController pushViewController:self.voucherListingViewController animated:YES onCompletion:^{
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = self.ibTableView.contentOffset.y;
    CGFloat maximumOffset = self.ibTableView.contentSize.height - self.ibTableView.frame.size.height;
    
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.ibTableView.frame.size.height/2) {
        if(![Utils isStringNull:self.dealsModel.paging.next] && !self.isLoading)
        {
            [self.ibActivityIndicatorView startAnimating];
            [self requestServerForVoucherListing];
        }
    }
}

-(void)viewDealDetailsClicked:(DealsModel *)dealsModel{
    if (dealsModel.arrDeals.count == 1) {
        self.dealDetailsViewController = nil;
        [self.dealDetailsViewController setDealModel:dealsModel.arrDeals[0]];
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
    self.dealsModel = nil;
    [self requestServerForVoucherListing];
}

/* ADJUST TABLEVIEW HEIGHT CODE
- (void)adjustHeightOfFilterTable
{
    CGFloat height = self.ibFilterTable.contentSize.height;
    CGFloat maxHeight = self.ibFilterTable.superview.frame.size.height - self.ibFilterTable.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.ibFilterTableHeightConstraint.constant = height;
        [self.view setNeedsUpdateConstraints];
    }];
}
 */

#pragma mark - Declaration
-(PromoPopOutViewController*)promoPopOutViewController{
    if (!_promoPopOutViewController) {
        _promoPopOutViewController = [PromoPopOutViewController new];
        _promoPopOutViewController.promoPopOutDelegate = self;
    }
    return _promoPopOutViewController;
}

-(RedemptionHistoryViewController*)redemptionHistoryViewController{
    if (!_redemptionHistoryViewController) {
        _redemptionHistoryViewController = [RedemptionHistoryViewController new];
    }
    return _redemptionHistoryViewController;
}

-(DealDetailsViewController *)dealDetailsViewController{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    return _dealDetailsViewController;
}

-(DealManager *)dealManager{
    if (!_dealManager) {
        _dealManager = [DealManager Instance];
    }
    return _dealManager;
}

-(NSMutableArray<DealExpiryDateModel> *)voucherArray{
    if (!_voucherArray) {
        _voucherArray = [[NSMutableArray<DealExpiryDateModel> alloc] init];
    }
    return _voucherArray;
}

-(DealRedeemViewController *)dealRedeemViewController{
    if (!_dealRedeemViewController) {
        _dealRedeemViewController = [DealRedeemViewController new];
    }
    return _dealRedeemViewController;
}

-(VoucherListingViewController *)voucherListingViewController{
    if (!_voucherListingViewController) {
        _voucherListingViewController = [VoucherListingViewController new];
    }
    return _voucherListingViewController;
}

#pragma mark - RequestServer
-(void)requestServerForVoucherListing{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"offset":@(self.dealsModel.offset+self.dealsModel.limit),
                           @"limit":@(20)};
    
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers", [Utils getUserID]];
    
    self.isLoading = YES;
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetUserVouchersList param:dict appendString:appendString completeHandler:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        if (self.dealsModel.offset == 1) {
            [self.voucherArray removeAllObjects];
        }
        [self rearrangeVoucherList];
        [self.ibTableView reloadData];
        [LoadingManager hide];
        [self.ibTableView.pullToRefreshView stopAnimating];
        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibTableView.tableFooterView = nil;
        }
    } errorBlock:^(id object) {
        [LoadingManager hide];
        self.isLoading = NO;
        [self.ibTableView.pullToRefreshView stopAnimating];
        self.ibTableView.tableFooterView = nil;
    }];
}

-(void)requestServerToDeleteVoucher:(DealModel*)deal withIndexPath:(NSIndexPath*)indexPath{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"voucher_id":deal.voucher_info.voucher_id,
                           @"token": [Utils getAppToken]
                           };
    
    NSString *appendString = deal.voucher_info.voucher_id;
    
    [LoadingManager show];
    self.isLoading = YES;
    [[ConnectionManager Instance] requestServerWithDelete:ServerRequestTypeDeleteVoucher param:dict appendString:appendString completeHandler:^(id object) {
        [self.ibTableView beginUpdates];
        DealExpiryDateModel *expiryModel = self.voucherArray[indexPath.section];
        BOOL deleteRow = expiryModel.dealModelArray.count > 1? YES : NO;
        [self removeDealFromVoucherArray:deal];
        [self.dealManager removeCollectedDeal:deal.dID];
        if (deleteRow) {
            [self.ibTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else{
            [self.ibTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }
        [self.ibTableView endUpdates];
        [LoadingManager hide];
        self.isLoading = NO;
    } errorBlock:^(id object) {
        [LoadingManager hide];
        self.isLoading = NO;
    }];
}

@end

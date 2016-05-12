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
{
    BOOL isOfflineData;

}
@property (weak, nonatomic) IBOutlet UILabel *ibWalletHeader;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterLbl;

@property (strong, nonatomic) IBOutlet UIView *ibEmptyStateView;
@property (strong, nonatomic) IBOutlet UIView *ibEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibEmptyBtn;
@property (weak, nonatomic) IBOutlet UIView *ibLoadingView;
@property (weak, nonatomic) IBOutlet UILabel *ibLoadingTxt;
@property (weak, nonatomic) IBOutlet YLImageView *ibLoadingImg;

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

- (IBAction)btnUploadClicked:(id)sender {
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // upload offline deal data
//    if ([ConnectionManager isNetworkAvailable]) {
//        [[OfflineManager Instance]uploadDealToRedeem:^{
//            
//            self.dealsModel = nil;
//            [self requestServerForVoucherListing];
//            
//        }];
//    }
    
    // Do any additional setup after loading the view from its nib.
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"WalletVoucherCell" bundle:nil] forCellReuseIdentifier:@"WalletVoucherCell"];
    self.ibTableView.estimatedRowHeight = [WalletVoucherCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    [Utils setRoundBorder:self.ibEmptyBtn color:DEVICE_COLOR borderRadius:self.ibEmptyBtn.frame.size.height/2 borderWidth:1.0f];
    
    self.ibLoadingImg.image = [YLGIFImage imageNamed:@"Loading.gif"];
    
    [self.ibTableView addPullToRefreshWithActionHandler:^{
        self.ibTableView.tableFooterView = self.ibTableFooterView;
        [self requestServerForVoucherListing];
    }];
    
    self.isLoading = NO;
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
    self.ibLoadingTxt.text = [NSString stringWithFormat:@"%@\n%@", LocalisedString(@"Collect Now"), LocalisedString(@"Pay Later")];
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
    for (DealExpiryDateModel *expiryModel in self.voucherArray) {
        if([expiryModel.dealModelArray containsObject:dealModel]){
            [expiryModel.dealModelArray removeObject:dealModel];
            
            if ([Utils isArrayNull:expiryModel.dealModelArray]) {
                DealExpiryDateModel *toBeDiscardedModel = [[DealExpiryDateModel alloc] init];
                toBeDiscardedModel.expiryDate = expiryModel.expiryDate;
                [self.voucherArray removeObjectsInArray:@[toBeDiscardedModel]];
            }
            break;
        }
    }
}

-(void)toggleEmptyView:(BOOL)hidden{
    self.ibEmptyView.hidden = !hidden;
    self.ibLoadingView.hidden = hidden;
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
        self.ibTableView.backgroundView = self.ibEmptyStateView;
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
    
    
    @try {
        DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
        if ([expiryModel.expiryDate isEqualToString:@"new"]) {
            label.text = LocalisedString(@"New Deals");
        }
        else if ([expiryModel.expiryDate isEqualToString:@"noDate"]){
            label.text = LocalisedString(@"No expiry");
        }
        else{
            label.text = [LanguageManager stringForKey:@"Expires {!date}" withPlaceHolder:@{@"{!date}": expiryModel.expiryDate}];
        }

    } @catch (NSException *exception) {
        
    }
    
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    self.dealDetailsViewController = nil;
    [self.dealDetailsViewController initDealModel:voucher];
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

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    
    if ([voucher.voucher_type isEqualToString:VOUCHER_TYPE_PUBLIC]) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LocalisedString(@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [UIAlertView showWithTitle:LocalisedString(@"Delete Voucher") message:LocalisedString(@"Are you sure you want to delete this voucher?") cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
                    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
                    [self requestServerToDeleteVoucher:voucher withIndexPath:indexPath];
                }
                
            }];
        }];
        deleteAction.backgroundColor = [UIColor colorWithHexValue:@"#ef5e41"];
        return @[deleteAction];
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [UIAlertView showWithTitle:LocalisedString(@"Delete Voucher") message:LocalisedString(@"Are you sure you want to delete this voucher?") cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
//                DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
//                [self requestServerToDeleteVoucher:voucher withIndexPath:indexPath];
//            }
//            
//        }];
//    }
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

    BOOL isRedeemable = false;
    
    if ([Utils isRedeemable:deal]) {
        
        if ([Utils isWithinOperationHour:deal.period]) {
            
            isRedeemable = true;
            
        }
    }
    
    if (isRedeemable) {
        self.dealRedeemViewController = nil;
        [self.dealRedeemViewController initWithDealModel:deal];
        self.dealRedeemViewController.dealRedeemDelegate = self;
      //  self.dealRedeemViewController.isOffline = isOfflineData;
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
    if (dealModel.voucher_info.total_redeemable_count == 1) {
        [self removeDealFromVoucherArray:dealModel];
        
        //comment : save wallet offline listing
        //[DealExpiryDateModel saveWalletList:self.voucherArray];

    }
    
    [self.ibTableView reloadData];
    
    self.redemptionHistoryViewController = nil;
    
    if ([ConnectionManager isNetworkAvailable]) {
        [self.navigationController pushViewController:self.redemptionHistoryViewController animated:YES];

    }
    else{
    
        [self.dealRedeemViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)emptyBtnClicked:(id)sender {
    self.voucherListingViewController = nil;
    NSDictionary *locationDict = [Utils getSavedUserLocation];
    HomeLocationModel *locationModel = [[HomeLocationModel alloc] init];
    @try {
        locationModel.latitude = locationDict[KEY_LATITUDE];
        locationModel.longtitude = locationDict[KEY_LONGTITUDE];
        locationModel.place_id = locationDict[KEY_PLACE_ID];
        locationModel.locationName = locationDict[KEY_LOCATION];
        locationModel.countryId = (int)[locationDict[KEY_COUNTRY_ID] integerValue];
    } @catch (NSException *exception) {
        SLog(@"Wallet location exception: %@", exception);
    }
    
    [self.voucherListingViewController initWithLocation:locationModel];
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
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserVouchersList parameter:dict appendString:appendString success:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.dealManager setAllCollectedDeals:self.dealsModel];
        if (self.dealsModel.offset == 1) {
            [self.voucherArray removeAllObjects];
        }
        isOfflineData = NO;
        [self rearrangeVoucherList];
        
        
//        //comment for offline mode
//        [DealExpiryDateModel saveWalletList:self.voucherArray];
        
        [self.ibTableView reloadData];
        [self.ibTableView.pullToRefreshView stopAnimating];
        self.isLoading = NO;
        [self.ibActivityIndicatorView stopAnimating];
        if ([Utils isStringNull:self.dealsModel.paging.next]) {
            self.ibTableView.tableFooterView = nil;
        }
        else{
            self.ibTableView.tableFooterView = self.ibTableFooterView;
        }
        if ([Utils isArrayNull:self.voucherArray]) {
            [self toggleEmptyView:YES];
        }
        else{
            [self toggleEmptyView:NO];
        }
    } failure:^(id object) {
        
        isOfflineData = YES;
        
        self.isLoading = NO;
        [self.ibTableView.pullToRefreshView stopAnimating];
        self.ibTableView.tableFooterView = nil;
        
//        //comment for offline mode
//
//        if ([Utils isArrayNull:self.voucherArray]) {
//            self.voucherArray = [[NSMutableArray<DealExpiryDateModel> alloc]initWithArray:[DealExpiryDateModel getWalletList]];
//            [self.ibTableView reloadData];
//
//        }
        
        if ([Utils isArrayNull:self.voucherArray]) {
            [self toggleEmptyView:YES];
        }

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
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_DELETE serverRequestType:ServerRequestTypeDeleteVoucher parameter:dict appendString:appendString success:^(id object)
    {

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
        if ([Utils isArrayNull:self.voucherArray]) {
            [self toggleEmptyView:YES];
        }
    } failure:^(id object) {
        [LoadingManager hide];
        self.isLoading = NO;
    }];
}


-(void)requestServerToRedeemVouchers:(NSArray<DealModel>*)array{
   
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{
                           @"token": [Utils getAppToken]
                           };
    
//    user location     //
    CLLocation *userLocation = [[SearchManager Instance] getAppLocation];
//    user location     //

    NSMutableArray* dictDeals = [NSMutableArray new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    for (int i = 0; i < array.count; i++) {
        
        DealModel* model = array[i];
        NSDictionary *voucherDict = @{@"deal_id": model.dID?model.dID:@"",
                                      @"voucher_id": model.voucher_info.voucher_id?model.voucher_info.voucher_id:@"",
                                      @"datetime": [formatter stringFromDate:[[NSDate alloc] init]],
                                      @"lat": @(userLocation.coordinate.latitude),
                                      @"lng": @(userLocation.coordinate.longitude)
                                      };
        
        [dictDeals addObject:voucherDict];

    }
    
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    
    for (int i = 0; i<dictDeals.count; i++) {
        
        NSDictionary* tempDict = dictDeals[i];
        
        NSDictionary* appendDict = @{[NSString stringWithFormat:@"voucher_info[%d]",i] : tempDict};
        
        [finalDict addEntriesFromDictionary:appendDict];
        
    }
    
    self.isLoading = YES;

    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_PUT serverRequestType:ServerRequestTypePutRedeemVoucher parameter:finalDict appendString:nil success:^(id object) {
        
        //Remove voucher from deal manager if it is not reusable
        
        self.isLoading = NO;
        [LoadingManager hide];
        
    } failure:^(id object) {
        self.isLoading = NO;
        [LoadingManager hide];
    }];
}
@end

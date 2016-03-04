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
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterLbl;
@property (strong, nonatomic) IBOutlet UIView *ibEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibEmptyDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibEmptyBtn;

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
    [self.ibTableView registerNib:[UINib nibWithNibName:@"WalletHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"WalletHeaderCell"];
    self.ibTableView.estimatedRowHeight = [WalletVoucherCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    [Utils setRoundBorder:self.ibEmptyBtn color:DEVICE_COLOR borderRadius:self.ibEmptyBtn.frame.size.height/2 borderWidth:1.0f];
    
    self.isLoading = NO;
    [self requestServerForVoucherListing];
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
        
        for (DealModel *dealModel in self.dealsModel.deals) {
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
                NSDate *expiryDate = [fullFormatter dateFromString:expiryString];
                NSString *formattedExpiryString = [monthYearFormatter stringFromDate:expiryDate];
                
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
        self.ibEmptyTitle.text = LocalisedString(@"Collect some voucher now!");
        self.ibEmptyDesc.text = LocalisedString(@"You don't have any voucher, go and collect some now!");
        [self.ibEmptyBtn setTitle:LocalisedString(@"Check Deals of the Day") forState:UIControlStateNormal];
        [self.ibEmptyBtn setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
        self.ibTableView.backgroundView = self.ibEmptyView;
        self.view.backgroundColor = [UIColor whiteColor];
        return 0;
    }
    else{
        self.ibTableView.backgroundView = nil;
        self.view.backgroundColor = [UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1];
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
    WalletHeaderCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WalletHeaderCell"];
    
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
    if ([expiryModel.expiryDate isEqualToString:@"new"]) {
        [header setHeaderTitle:LocalisedString(@"New!")];
    }
    else{
        [header setHeaderTitle:[NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expired on"), expiryModel.expiryDate]];
    }
    
    return header;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:LocalisedString(@"Remove Voucher") message:LocalisedString(@"Are you sure you want to remove this voucher?") cancelButtonTitle:LocalisedString(@"Maybe not!") otherButtonTitles:@[LocalisedString(@"Yes, sure!")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
                DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
                [self requestServerToDeleteVoucher:voucher];
            }
            
        }];
    }
}

#pragma mark - IBAction
- (IBAction)footerBtnClicked:(id)sender {
    [self.promoPopOutViewController setViewType:EnterPromoViewType];
    
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
    
    if (deal.voucher_info.redeem_now) {
        self.dealRedeemViewController = nil;
        [self.dealRedeemViewController setDealModel:deal];
        self.dealRedeemViewController.dealRedeemDelegate = self;
        [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
    }
    else{
        [self.promoPopOutViewController setViewType:ErrorViewType];
        
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
            //            [(UIActivityIndicatorView *)self.ibVoucherTable startAnimating];
            [self requestServerForVoucherListing];
        }
    }
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
        [self rearrangeVoucherList];
        [self.ibTableView reloadData];
        self.isLoading = NO;
    } errorBlock:^(id object) {
        self.isLoading = NO;
    }];
}

-(void)requestServerToDeleteVoucher:(DealModel*)deal{
    NSDictionary *dict = @{@"voucher_id":deal.voucher_info.voucher_id,
                           @"token": [Utils getAppToken]
                           };
    
    NSString *appendString = deal.voucher_info.voucher_id;
    
    [[ConnectionManager Instance] requestServerWithDelete:ServerRequestTypeDeleteVoucher param:dict appendString:appendString completeHandler:^(id object) {
        [self removeDealFromVoucherArray:deal];
        [self.dealManager removeCollectedDeal:deal.dID];
        [self.ibTableView  reloadData];
    } errorBlock:^(id object) {
        
    }];
}

@end

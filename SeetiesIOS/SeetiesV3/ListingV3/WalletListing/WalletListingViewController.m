//
//  WalletListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletListingViewController.h"

@interface WalletListingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterLbl;

@property (nonatomic)PromoPopOutViewController *promoPopOutViewController;
@property(nonatomic)RedemptionHistoryViewController *redemptionHistoryViewController;
@property (nonatomic) DealDetailsViewController *dealDetailsViewController;

@property(nonatomic) NSMutableArray<DealModel*> *voucherArray;
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
    
    self.isLoading = NO;
    [self requestServerForVoucherListing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Utils isArrayNull:self.voucherArray]) {
        return self.voucherArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletVoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"WalletVoucherCell"];
    voucherCell.walletVoucherDelegate = self;
    [voucherCell setDealModel:[self.voucherArray objectAtIndex:indexPath.row]];
        
    return voucherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    WalletHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    
    if (!header) {
        [tableView registerNib:[UINib nibWithNibName:@"WalletHeaderCell" bundle:nil] forCellReuseIdentifier:@"WalletHeaderCell"];
        header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    }
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DealModel *dealModel = [self.voucherArray objectAtIndex:indexPath.row];
    self.dealDetailsViewController = nil;
    [self.dealDetailsViewController setDealModel:dealModel];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:LocalisedString(@"Remove Voucher") message:LocalisedString(@"Are you sure you want to remove this voucher?") cancelButtonTitle:LocalisedString(@"Maybe not!") otherButtonTitles:@[LocalisedString(@"Yes, sure!")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                DealModel *deal = [self.voucherArray objectAtIndex:indexPath.row];
                [self requestServerToDeleteVoucher:deal];
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
    [self.navigationController pushViewController:self.redemptionHistoryViewController animated:YES];
}

-(void)redeemVoucherClicked:(DealModel*)deal{
    //To do checking whether voucher can be redeemed
//    if (YES) {
//        
//    }
//    else{
        [self.promoPopOutViewController setViewType:ErrorViewType];
        
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopOutViewController];
        popupController.containerView.backgroundColor = [UIColor clearColor];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        [popupController presentInViewController:self];
        [popupController setNavigationBarHidden:YES];
//    }
    
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

-(NSMutableArray<DealModel *> *)voucherArray{
    if (!_voucherArray) {
        _voucherArray = [[NSMutableArray alloc] init];
    }
    return _voucherArray;
}

#pragma mark - RequestServer
-(void)requestServerForVoucherListing{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"offset":@(self.dealsModel.offset),
                           @"limit":@(self.dealsModel.limit)};
    
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers", [Utils getUserID]];
    
    self.isLoading = YES;
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetUserVouchersList param:dict appendString:appendString completeHandler:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self.voucherArray addObjectsFromArray:self.dealsModel.deals];
        [self.dealManager setAllCollectedDeals:self.dealsModel];
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
        [self.voucherArray removeObject:deal];
        [self.dealManager removeCollectedDeal:deal.dID];
        [self.ibTableView  reloadData];
    } errorBlock:^(id object) {
        
    }];
}

@end

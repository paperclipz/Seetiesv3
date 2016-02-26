//
//  RedemptionHistoryViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 05/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "RedemptionHistoryViewController.h"

@interface RedemptionHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibHistoryTable;

@property(nonatomic) BOOL isLoading;
@property(nonatomic) DealsModel *dealsModel;
@property(nonatomic) NSMutableArray<DealExpiryDateModel*> *voucherArray;
@property(nonatomic) DealDetailsViewController *dealDetailsViewController;

@end

@implementation RedemptionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isLoading = NO;
    
    [self.ibHistoryTable registerNib:[UINib nibWithNibName:@"RedemptionHistoryCell" bundle:nil] forCellReuseIdentifier:@"RedemptionHistoryCell"];
    [self.ibHistoryTable registerNib:[UINib nibWithNibName:@"WalletHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"WalletHeaderCell"];
    self.ibHistoryTable.estimatedRowHeight = [RedemptionHistoryCell getHeight];
    self.ibHistoryTable.rowHeight = UITableViewAutomaticDimension;
    
    [self requestServerForVouchersHistoryList];
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
        NSMutableArray<DealModel*> *tempDateArray = [[NSMutableArray alloc] init];
        NSString *previousGroup = @"";
        
        for (DealModel *dealModel in self.dealsModel.deals) {
            
            NSString *redemptionString = dealModel.voucher_info.redeemed_at;
            NSDate *redemptionDate = [fullFormatter dateFromString:redemptionString];
            NSString *formattedRedemptionString = [monthYearFormatter stringFromDate:redemptionDate];
            
            if ([previousGroup isEqualToString:formattedRedemptionString]) {
                [tempDateArray addObject:dealModel];
            }
            else{
                if (![Utils isArrayNull:tempDateArray]) {
                    DealExpiryDateModel *dealExpirtyDateModel = [[DealExpiryDateModel alloc] init];
                    dealExpirtyDateModel.expiryDate = previousGroup;
                    dealExpirtyDateModel.dealModelArray = tempDateArray;
                    
                    [self addToVoucherArray:dealExpirtyDateModel];
                    
                    tempDateArray = [[NSMutableArray alloc] init];
                }
                
                [tempDateArray addObject:dealModel];
            }
            previousGroup = formattedRedemptionString;
            
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

#pragma mark - DelegateImplementation
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = self.ibHistoryTable.contentOffset.y;
    CGFloat maximumOffset = self.ibHistoryTable.contentSize.height - self.ibHistoryTable.frame.size.height;
    
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.ibHistoryTable.frame.size.height/2) {
        if(![Utils isStringNull:self.dealsModel.paging.next])
        {
            //            [(UIActivityIndicatorView *)self.ibVoucherTable startAnimating];
            [self requestServerForVouchersHistoryList];
        }
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

#pragma mark - Declaration
-(NSMutableArray<DealExpiryDateModel *> *)voucherArray{
    if (!_voucherArray) {
        _voucherArray = [[NSMutableArray alloc] init];
    }
    return _voucherArray;
}

-(DealDetailsViewController *)dealDetailsViewController{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    return _dealDetailsViewController;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Utils isArrayNull:self.voucherArray]) {
        return 0;
    }
    else{
        SLog(@"number of section:%ld", self.voucherArray.count);
        return self.voucherArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Utils isArrayNull:self.voucherArray]) {
        DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
        SLog(@"number of row: %ld", expiryModel.dealModelArray.count);
        return expiryModel.dealModelArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedemptionHistoryCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"RedemptionHistoryCell"];
    
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:indexPath.section];
    DealModel *voucher = [expiryModel.dealModelArray objectAtIndex:indexPath.row];
    [voucherCell setVoucher:voucher];
    
    return voucherCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    WalletHeaderCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WalletHeaderCell"];
    
    DealExpiryDateModel *expiryModel = [self.voucherArray objectAtIndex:section];
    [header setHeaderTitle:[NSString stringWithFormat:@"%@ %@", LocalisedString(@"Redeemed on"), expiryModel.expiryDate]];
    
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

#pragma mark - RequestServer
-(void)requestServerForVouchersHistoryList{
    if (self.isLoading) {
        return;
    }
    
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"offset":@(self.dealsModel.offset+self.dealsModel.limit),
                           @"limit":@(20)};
    
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers/history", [Utils getUserID]];
    
    self.isLoading = YES;
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetUserVouchersHistoryList param:dict appendString:appendString completeHandler:^(id object) {
        DealsModel *model = [[ConnectionManager dataManager] dealsModel];
        self.dealsModel = model;
        [self rearrangeVoucherList];
        [self.ibHistoryTable reloadData];
        self.isLoading = NO;
    } errorBlock:^(id object) {
        self.isLoading = NO;
    }];
}

@end

//
//  WalletListingViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletListingViewController.h"

@interface WalletListingViewController ()
@property NSArray *voucherArray;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *ibFooterBtn;

@property (nonatomic)PromoPopOutViewController *promoPopOutViewController;
@property(nonatomic)RedemptionHistoryViewController *redemptionHistoryViewController;
@end

@implementation WalletListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"WalletVoucherCell" bundle:nil] forCellReuseIdentifier:@"WalletVoucherCell"];
    self.ibTableView.estimatedRowHeight = [WalletVoucherCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    NSArray *dummyArray = @[@"",@"",@"",@"",@"",@"",@""];
    
    _voucherArray = @[dummyArray, dummyArray, dummyArray, dummyArray];
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
    if (tableView == self.ibTableView) {
        return ((NSArray*)[self.voucherArray objectAtIndex:section]).count;

    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibTableView) {
        WalletVoucherCell *voucherCell = [tableView dequeueReusableCellWithIdentifier:@"WalletVoucherCell"];
        voucherCell.delegate = self;
        return voucherCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.voucherArray.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    WalletHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    
    if (!header) {
        [tableView registerNib:[UINib nibWithNibName:@"WalletHeaderCell" bundle:nil] forCellReuseIdentifier:@"WalletHeaderCell"];
        header = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCell"];
    }
    
    return header;
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
@end

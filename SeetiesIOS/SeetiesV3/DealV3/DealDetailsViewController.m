//
//  DealDetailsViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealDetailsViewController.h"

@interface DealDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderSubTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibMainContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibMainContentHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderDealExpiryLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderImageCountLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibHeaderImageScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderImageContentView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderBlackShadeView;
@property (weak, nonatomic) IBOutlet UIImageView *ibHeaderBlackShadeIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderBlackShadeStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibHeaderImageContentWidthConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibDealDetailsView;
@property (weak, nonatomic) IBOutlet UIView *ibDealDetailsContentView;
@property (weak, nonatomic) IBOutlet UIView *ibTagContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsDescLbl;
@property (weak, nonatomic) IBOutlet UIView *ibDealDetailsRedemptionContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTagContentViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibRedemptionContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTagScrollViewHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibAvailabilityView;
@property (weak, nonatomic) IBOutlet UIView *ibAvailabilityContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibAvailabilityTable;
@property (weak, nonatomic) IBOutlet UILabel *ibAvailabilityTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibAvailabilityDesc;

@property (strong, nonatomic) IBOutlet UIView *ibShopView;
@property (weak, nonatomic) IBOutlet UIView *ibShopContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibShopTable;
@property (weak, nonatomic) IBOutlet UILabel *ibShopTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibShopSeeMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibShopSeeMoreHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibTnCView;
@property (weak, nonatomic) IBOutlet UIView *ibTnCContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibTnCTable;
@property (weak, nonatomic) IBOutlet UILabel *ibTnCTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibTnCReadMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTnCSeeMoreHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibDealsView;
@property (weak, nonatomic) IBOutlet UIView *ibDealsContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibDealsTable;
@property (weak, nonatomic) IBOutlet UIView *ibDealsTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibDealsSeeMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *ibNearbyShopView;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibNearbyShopCollection;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibNearbyShopSeeMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *ibReportView;
@property (weak, nonatomic) IBOutlet UIView *ibReportContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibReportLbl;

@property (weak, nonatomic) IBOutlet UIView *ibFooterView;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibFooterIcon;

@property(nonatomic) NSArray *viewArray;
@property(nonatomic) DealModel *dealModel;
@property(nonatomic) BOOL isProcessing;
@property(nonatomic) DealManager *dealManager;
@property(nonatomic) NSMutableArray<SeShopDetailModel> *nearbyShopArray;
@property(nonatomic) PromoPopOutViewController *promoPopOutViewController;
@property(nonatomic) DealRedeemViewController *dealRedeemViewController;
@property(nonatomic) SeetiesShopViewController *seetiesShopViewController;
@property(nonatomic) SeetiShopListingViewController *seetieShopListingViewController;
@end

@implementation DealDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isProcessing = NO;
    
    [self.ibAvailabilityTable registerNib:[UINib nibWithNibName:@"DealDetailsAvailabilityCell" bundle:nil] forCellReuseIdentifier:@"DealDetailsAvailabilityCell"];
    [self.ibShopTable registerNib:[UINib nibWithNibName:@"PromoOutletCell" bundle:nil] forCellReuseIdentifier:@"PromoOutletCell"];
    [self.ibDealsTable registerNib:[UINib nibWithNibName:@"SeDealsFeaturedTblCell" bundle:nil] forCellReuseIdentifier:@"SeDealsFeaturedTblCell"];
    [self.ibNearbyShopCollection registerNib:[UINib nibWithNibName:@"NearbyShopsCell" bundle:nil] forCellWithReuseIdentifier:@"NearbyShopsCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupView
{
    [self initViewArray];
    [self initSelfView];
    if ([Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
        [self requestServerForDealInfo];
    }
    else{
        [self requestServerForVoucherInfo];
        
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

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)initSelfView{
    
    if (![Utils isArrayNull:self.viewArray]) {
        for (UIView *view in self.viewArray) {
//            [view setHeight:0];
            [self.ibMainContentView addSubview:view];
        }
        [self updateViewFrame];
    }
    
    [self updateViewFrame];
    
}

-(void)initViewArray{
    _viewArray = @[self.ibHeaderView, self.ibDealDetailsView, self.ibAvailabilityView, self.ibShopView, self.ibTnCView, self.ibDealsView , self.ibNearbyShopView, self.ibReportView];
  
}

#pragma mark - IBAction
- (IBAction)shopSeeMoreBtnClicked:(id)sender {
    self.seetieShopListingViewController = nil;
    [self.navigationController pushViewController:self.seetieShopListingViewController animated:YES onCompletion:^{
        NSMutableArray *copyOfShopModel = [[NSMutableArray alloc] initWithArray:self.dealModel.shops];
        [self.seetieShopListingViewController initWithArray:copyOfShopModel];
    }];
}

- (IBAction)nearbyShopSeeMoreBtnClicked:(id)sender {
    self.seetieShopListingViewController = nil;
    [self.navigationController pushViewController:self.seetieShopListingViewController animated:YES onCompletion:^{
        [self.seetieShopListingViewController initWithArray:self.nearbyShopArray];
    }];
}

#pragma mark - Declaration
-(DealManager *)dealManager{
    return [DealManager Instance];
}

-(PromoPopOutViewController *)promoPopOutViewController{
    if (!_promoPopOutViewController) {
        _promoPopOutViewController = [PromoPopOutViewController new];
    }
    return _promoPopOutViewController;
}

-(DealRedeemViewController *)dealRedeemViewController{
    if (!_dealRedeemViewController) {
        _dealRedeemViewController = [DealRedeemViewController new];
    }
    return _dealRedeemViewController;
}

-(NSMutableArray<SeShopDetailModel> *)nearbyShopArray{
    if (!_nearbyShopArray) {
        _nearbyShopArray = [[NSMutableArray<SeShopDetailModel> alloc] init];
    }
    return _nearbyShopArray;
}

-(SeetiesShopViewController *)seetiesShopViewController{
    if (!_seetiesShopViewController) {
        _seetiesShopViewController = [SeetiesShopViewController new];
    }
    return _seetiesShopViewController;
}

-(SeetiShopListingViewController *)seetieShopListingViewController{
    if (!_seetieShopListingViewController) {
        _seetieShopListingViewController = [SeetiShopListingViewController new];
    }
    
    return _seetieShopListingViewController;
}

#pragma mark - UpdateView
-(void)updateViewFrame{
    float yAxis = self.ibMainContentView.frame.origin.y;
    float totalHeight = 0;
    for (UIView *view in self.viewArray) {
        [view setFrame:CGRectMake(0, yAxis, self.ibMainContentView.frame.size.width, view.frame.size.height)];
        yAxis = view.frame.origin.y + view.frame.size.height;
        totalHeight += view.frame.size.height;
    }
    
    self.ibMainContentHeightConstraint.constant = totalHeight;
    [self.view refreshConstraint];
    
    [self drawBorders];
}

-(void)updateViews{
    [self updateHeaderView];
    [self updateDetailsView];
    [self updateAvailabilityView];
    [self updateShopView];
    [self updateTnCView];
    [self updateNearbyShopView];
    [self updateViewFrame];
}

-(void)updateHeaderView{
    self.ibHeaderSubTitleLbl.text = self.dealModel.title;
    
    if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE]) {
        if (![Utils isStringNull:self.dealModel.shop_group_name]) {
            self.ibHeaderTitleLbl.text = self.dealModel.shop_group_name;
        }
        else{
            SeShopDetailModel *shopModel = self.dealModel.shops[0];
            self.ibHeaderTitleLbl.text = shopModel.name;
        }
    }
    else{
        self.ibHeaderTitleLbl.text = self.dealModel.voucher_info.shop_info.name;
    }
    
    CGFloat imageXOrigin = 0;
    if (![Utils isArrayNull:self.dealModel.photos]) {
        [self.ibHeaderImageScrollView refreshConstraint];
        for (PhotoModel *photo in self.dealModel.photos) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageXOrigin, 0, self.ibHeaderImageScrollView.frame.size.width, self.ibHeaderImageContentView.frame.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageCroppedWithURL:[NSURL URLWithString:photo.imageURL] completed:nil];
            [self.ibHeaderImageContentView addSubview:imageView];
            imageXOrigin += imageView.frame.size.width;
        }
        self.ibHeaderImageContentWidthConstraint.constant = imageXOrigin;
        self.ibHeaderImageCountLbl.text = [NSString stringWithFormat:@"%d/%lu", 1, (unsigned long)self.dealModel.photos.count];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [dateFormatter dateFromString:self.dealModel.expired_at];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.ibHeaderDealExpiryLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expires"), [dateFormatter stringFromDate:expireDate]];
    
    if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_REDEEMED]) {
        self.ibHeaderBlackShadeView.hidden = NO;
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Redeemed");
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_EXPIRED]){
        self.ibHeaderBlackShadeView.hidden = NO;
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Expired");
    }
    else{
        self.ibHeaderBlackShadeView.hidden = YES;
    }
}

-(void)updateDetailsView{
    self.ibDealDetailsTitleLbl.text = self.dealModel.title;
    self.ibDealDetailsDesc.text = self.dealModel.deal_desc;
    
    CGFloat tagHeight = 20.0f;
    CGFloat spacing = 10.0f;
    CGFloat fontSize = 15.0f;
    CGFloat padding = 20.0f;
    CGFloat xOrigin = 0;
    if (self.dealModel.is_feature) {
        NSString *tag = [NSString stringWithFormat:@"%@", LocalisedString(@"FEATURED")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont systemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:232/255.0f green:86/255.0f blue:99/255.f alpha:1]];
        [tagLbl setSideCurveBorder];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    if (self.dealModel.total_available_vouchers <= 10 && self.dealModel.total_available_vouchers > 0) {
        NSString *tag = [NSString stringWithFormat:@"%ld %@", self.dealModel.total_available_vouchers, LocalisedString(@"Vouchers Left")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont systemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:253/255.0f green:175/255.0f blue:23/255.0f alpha:1]];
        [tagLbl setSideCurveBorder];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_FREE]) {
        NSString *tag = [NSString stringWithFormat:@"%@", LocalisedString(@"FREE")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont systemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:DEVICE_COLOR];
        [tagLbl setSideCurveBorder];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_DISCOUNT] || [self.dealModel.deal_type isEqualToString:DEAL_TYPE_PACKAGE]) {
        NSString *tag = [NSString stringWithFormat:@"%@%% %@", self.dealModel.discount_percentage, LocalisedString(@"OFF")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont systemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:191/255.0f green:214/255.0f blue:48/255.0f alpha:1]];
        [tagLbl setSideCurveBorder];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    self.ibTagContentViewWidthConstraint.constant = xOrigin;
    if (xOrigin == 0) {
        self.ibTagScrollViewHeightConstraint.constant = 0;
    }
    
    float redemptionYOrigin = 0;
    self.ibRedemptionContentViewHeightConstraint.constant = 0;
    for (NSString *type in self.dealModel.redemption_type) {
        RedemptionTypeView *redemptionTypeView = [RedemptionTypeView initializeCustomView];
        if ([type isEqualToString:REDEMPTION_TYPE_DINE_IN]) {
            redemptionTypeView.ibRedemptionTypeLbl.text = LocalisedString(@"Dine in");
        }
        else if ([type isEqualToString:REDEMPTION_TYPE_TAKE_AWAY]){
            redemptionTypeView.ibRedemptionTypeLbl.text = LocalisedString(@"Take away");
        }
        else{
            redemptionTypeView.ibRedemptionTypeLbl.text = type;
        }
        redemptionTypeView.frame = CGRectMake(0, redemptionYOrigin, self.ibDealDetailsRedemptionContentView.frame.size.width, redemptionTypeView.frame.size.height);
        [self.ibDealDetailsRedemptionContentView addSubview:redemptionTypeView];
        redemptionYOrigin += redemptionTypeView.frame.size.height;
    }
    self.ibRedemptionContentViewHeightConstraint.constant = redemptionYOrigin;
    
    CGFloat contentHeight = self.ibDealDetailsRedemptionContentView.frame.origin.y + self.ibRedemptionContentViewHeightConstraint.constant + 15;
    [self.ibDealDetailsView setHeight:contentHeight];
}


-(void)updateAvailabilityView{
    [self.ibAvailabilityTable reloadData];
    
    float cellHeight = [DealDetailsAvailabilityCell getHeight];
    NSInteger numberOfDays = self.dealModel.redemption_period_in_hour_text.allKeys.count;
    float tableHeight = cellHeight * numberOfDays;
    CGFloat totalHeight = self.ibAvailabilityTable.frame.origin.y + tableHeight + 15;
    
    [self.ibAvailabilityView setHeight:totalHeight];
}

-(void)updateShopView{
    self.ibShopTitle.text = [NSString stringWithFormat:@"%@ (%ld)", LocalisedString(@"Participate Shop"), self.dealModel.shops.count];
    
    [self.ibShopTable reloadData];
    
    float cellHeight = [PromoOutletCell getHeight];
    NSInteger numberOfShop = self.dealModel.shops.count;
    float tableHeight = cellHeight * numberOfShop;
    CGFloat totalHeight = self.ibShopTable.frame.origin.y + tableHeight + 15;
    
//    if (self.dealModel.shops.count > 3) {
        self.ibShopSeeMoreHeightConstraint.constant = 40;
        self.ibShopSeeMoreBtn.hidden = NO;
        totalHeight += self.ibShopSeeMoreHeightConstraint.constant;
//    }
//    else{
//        self.ibShopSeeMoreHeightConstraint.constant = 0;
//        self.ibShopSeeMoreBtn.hidden = YES;
//        totalHeight += self.ibShopSeeMoreHeightConstraint.constant;
//    }
    
    [self.ibShopView setHeight:totalHeight];
}

-(void)updateTnCView{
    [self.ibTnCTable reloadData];
    
    float cellHeight = 44;
    NSInteger numberOfTerms = self.dealModel.terms.count;
    float tableHeight = cellHeight * numberOfTerms;
    CGFloat totalHeight = self.ibTnCTable.frame.origin.y + tableHeight + 15;
    
    if (self.dealModel.terms.count > 5) {
        self.ibTnCSeeMoreHeightConstraint.constant = 40;
        self.ibTnCReadMoreBtn.hidden = NO;
        totalHeight += self.ibTnCSeeMoreHeightConstraint.constant;
    }
    else{
        self.ibTnCSeeMoreHeightConstraint.constant = 0;
        self.ibTnCReadMoreBtn.hidden = YES;
        totalHeight += self.ibTnCSeeMoreHeightConstraint.constant;
    }
    
    [self.ibTnCView setHeight:totalHeight];
}

-(void)updateNearbyShopView{
    
    if (self.nearbyShopArray.count > 0) {
        [self.ibNearbyShopView setHeight:265];
    }
    else{
        [self.ibNearbyShopView setHeight:0];
    }
}

-(void)updateFooterView{
    NSString *voucherStatus = self.dealModel.voucher_info.status;
    if ([voucherStatus isEqualToString:VOUCHER_STATUS_NONE]) {
        [self.ibFooterView setBackgroundColor:DEVICE_COLOR];
        self.ibFooterTitle.text = LocalisedString(@"Collect This Voucher");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_COLLECTED]){
        [self.ibFooterView setBackgroundColor:[UIColor colorWithRed:239/255.0 green:83/255.0 blue:105/255.0 alpha:1]];
        self.ibFooterTitle.text = LocalisedString(@"Redeem Now");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_REDEEMED]){
        [self.ibFooterView setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        self.ibFooterTitle.text = LocalisedString(@"Redeem Now");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_EXPIRED]){
        [self.ibFooterView setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        self.ibFooterTitle.text = LocalisedString(@"Redeem Now");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_CANCELLED]){
        [self.ibFooterView setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        self.ibFooterTitle.text = LocalisedString(@"Collect This Voucher");
    }
    else{
        [self.ibFooterView setBackgroundColor:[UIColor whiteColor]];
        self.ibFooterTitle.text = @"";
    }
}

-(void)drawBorders{
    [self.ibHeaderContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibDealDetailsContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibDealDetailsContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibAvailabilityContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibAvailabilityContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibShopContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibShopContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibTnCContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibTnCContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibDealsContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibDealsContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibNearbyShopContentView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibNearbyShopContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
}

#pragma mark - Delegate
- (IBAction)buttonShareClicked:(id)sender {
}

- (IBAction)buttonTranslateClicked:(id)sender {
}

- (IBAction)footerBtnClicked:(id)sender {
    NSString *voucherStatus = self.dealModel.voucher_info.status;
    if ([voucherStatus isEqualToString:VOUCHER_STATUS_NONE]) {
        if (self.dealModel.shops.count == 1) {
            SeShopDetailModel *shopModel = [self.dealModel.shops objectAtIndex:0];
            [self requestServerToCollectVoucher:shopModel];
        }
        else if(self.dealModel.shops.count > 1){
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:ChooseShopViewType];
            [self.promoPopOutViewController setPopOutCondition:ChooseShopOnlyPopOutCondition];
            [self.promoPopOutViewController setDealModel:self.dealModel];
            [self.promoPopOutViewController setShopArray:self.dealModel.shops];
            self.promoPopOutViewController.promoPopOutDelegate = self;
            
            STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:self.promoPopOutViewController];
            popOutController.containerView.backgroundColor = [UIColor clearColor];
            [popOutController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popOutController presentInViewController:self];
            [popOutController setNavigationBarHidden:YES];
        }
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_COLLECTED]){
        self.dealRedeemViewController = nil;
        [self.dealRedeemViewController setDealModel:self.dealModel];
        self.dealRedeemViewController.dealRedeemDelegate = self;
        [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_REDEEMED]){
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_EXPIRED]){
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_CANCELLED]){
    }
    else{
    }
}

-(void)chooseShopConfirmClicked:(DealModel *)dealModel forShop:(SeShopDetailModel *)shopModel{
    [self requestServerToCollectVoucher:shopModel];
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onDealRedeemed:(DealModel *)dealModel{
    [self requestServerForVoucherInfo];
    
}

#pragma mark - TablewView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ibAvailabilityTable) {
        return self.dealModel.redemption_period_in_hour_text.allKeys.count;
    }
    else if (tableView == self.ibShopTable){
        if (self.dealModel.shops.count > 3) {
            return 3;
        }
        else{
            return self.dealModel.shops.count;
        }
        
    }
    else if (tableView == self.ibDealsTable){
        return 3;
    }
    else if (tableView == self.ibTnCTable){
        if (self.dealModel.terms.count > 5) {
            return 5;
        }
        else{
            return self.dealModel.terms.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibAvailabilityTable) {
        DealDetailsAvailabilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealDetailsAvailabilityCell"];
        NSString *day = [self.dealModel.redemption_period_in_hour_text.allKeys objectAtIndex:indexPath.row];
        NSString *time = [self.dealModel.redemption_period_in_hour_text objectForKey:day];
        cell.ibDayLbl.text = day;
        cell.ibTimeLbl.text = time;
        return cell;
    }
    else if (tableView == self.ibShopTable){
        PromoOutletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
        [cell setCellType:NonSelectionOutletCellType];
        [cell setShopModel:self.dealModel.shops[indexPath.row]];
        return cell;
    }
    else if (tableView == self.ibDealsTable){
        return [tableView dequeueReusableCellWithIdentifier:@"SeDealsFeaturedTblCell"];
    }
    else if (tableView == self.ibTnCTable){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [self.dealModel.terms objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibAvailabilityTable) {
        return [DealDetailsAvailabilityCell getHeight];
    }
    else if (tableView == self.ibShopTable){
        return [PromoOutletCell getHeight];
    }
    else if (tableView == self.ibDealsTable){
        return [SeDealsFeaturedTblCell getHeight];
    }
    else if (tableView == self.ibTnCTable){
        return 44;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibShopTable){
        SeShopDetailModel *shopModel = self.dealModel.shops[indexPath.row];
        self.seetiesShopViewController = nil;
        [self.seetiesShopViewController initDataWithSeetiesID:shopModel.seetishop_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
    }
    else if (tableView == self.ibDealsTable){
    }
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.ibNearbyShopCollection){
        if (self.nearbyShopArray) {
            NSInteger count = self.nearbyShopArray.count;
            return count;
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ibNearbyShopCollection){
        NearbyShopsCell *shopCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NearbyShopsCell" forIndexPath:indexPath];
        SeShopDetailModel *shopModel = [self.nearbyShopArray objectAtIndex:indexPath.row];
        [shopCell setShopModel:shopModel];
        return shopCell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width-20)/3, 200);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ibNearbyShopCollection) {
        SeShopDetailModel *shopModel = self.nearbyShopArray[indexPath.row];
        self.seetiesShopViewController = nil;
        [self.seetiesShopViewController initDataWithSeetiesID:shopModel.seetishop_id];
        [self.navigationController pushViewController:self.seetiesShopViewController animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    if (scrollView == self.ibHeaderImageScrollView) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.ibHeaderImageCountLbl.text = [NSString stringWithFormat:@"%d/%lu", page+1, (unsigned long)self.dealModel.photos.count];
    }
}

#pragma mark - RequestServer
-(void)requestServerForDealInfo{
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"deal_id": self.dealModel.dID};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetDealInfo param:dict appendString:self.dealModel.dID completeHandler:^(id object) {
        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        [self updateViews];
        [self updateFooterView];
        
        if (self.dealModel.shops.count == 1) {
            [self requestServerForSeetiShopNearbyShop:self.dealModel.shops[0]];
        }
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForVoucherInfo{
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"voucher_id": self.dealModel.voucher_info.voucher_id};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetVoucherInfo param:dict appendString:self.dealModel.voucher_info.voucher_id completeHandler:^(id object) {
        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        [self updateViews];
        [self updateFooterView];
        
        [self requestServerForSeetiShopNearbyShop:self.dealModel.voucher_info.shop_info];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerToCollectVoucher:(SeShopDetailModel*)shopModel{
    if (self.isProcessing) {
        return;
    }
    
    NSDictionary *dict = @{@"deal_id":self.dealModel.dID,
                           @"shop_id":shopModel.seetishop_id,
                           @"token": [Utils getAppToken]};
    
    self.isProcessing = YES;
    [[ConnectionManager Instance] requestServerWithPost:ServerRequestTypePostCollectDeals param:dict completeHandler:^(id object) {
        DealModel *dealModel = [[ConnectionManager dataManager] dealModel];
        self.dealModel = dealModel;
        [self.dealManager setCollectedDeal:dealModel.dID forDeal:dealModel];
        [self updateFooterView];
        self.isProcessing = NO;
    } errorBlock:^(id object) {
        self.isProcessing = NO;
    }];
}

-(void)requestServerForSeetiShopNearbyShop:(SeShopDetailModel*)shopModel
{
    NSString* appendString = [NSString stringWithFormat:@"%@/nearby/shops", shopModel.seetishop_id];
    
    NSDictionary* dict = @{@"limit":@"3",
                           @"offset":@"1",
                           @"lat" : shopModel.location.lat,
                           @"lng" : shopModel.location.lng
                           };
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSeetoShopNearbyShop param:dict appendString:appendString completeHandler:^(id object) {
        SeetiShopsModel *seetieShopModel = [[ConnectionManager dataManager]seNearbyShopModel];
        [self copyShopData:seetieShopModel.userPostData.shops];
        [self updateViews];
        [self.ibNearbyShopCollection reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)copyShopData:(NSArray<ShopModel>*)shopsModel{
    for (ShopModel *shopModel in shopsModel) {
        SeShopDetailModel *newShopModel = [[SeShopDetailModel alloc] init];
        newShopModel.seetishop_id = shopModel.seetishop_id;
        newShopModel.name = shopModel.name;
        newShopModel.profile_photo = @{@"picture": shopModel.profile_photo};
        [self.nearbyShopArray addObject:newShopModel];
    }
}

@end

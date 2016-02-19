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
@property (weak, nonatomic) IBOutlet UIImageView *ibHeaderDealImage;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderDealExpiryLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderImageCountLbl;

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

@property (strong, nonatomic) IBOutlet UIView *ibTnCView;
@property (weak, nonatomic) IBOutlet UIView *ibTnCContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibTnCTable;
@property (weak, nonatomic) IBOutlet UILabel *ibTnCTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibTnCReadMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *ibDealsView;
@property (weak, nonatomic) IBOutlet UIView *ibDealsContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibDealsTable;
@property (weak, nonatomic) IBOutlet UIView *ibDealsTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibDealsSeeMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *ibNearbyShopView;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibNearbyShopCollection;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibNearbyShopSeeMoreLbl;

@property (strong, nonatomic) IBOutlet UIView *ibReportView;
@property (weak, nonatomic) IBOutlet UIView *ibReportContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibReportLbl;

@property(nonatomic, assign) DealDetailsViewType viewType;
@property(nonatomic) NSArray *viewArray;
@property(nonatomic) DealModel *dealModel;
@end

@implementation DealDetailsViewController

-(instancetype)init{
    self = [super self];
    
    if (self) {
        _viewType = UncollectedDealDetailsView;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.ibAvailabilityTable registerNib:[UINib nibWithNibName:@"DealDetailsAvailabilityCell" bundle:nil] forCellReuseIdentifier:@"DealDetailsAvailabilityCell"];
    [self.ibShopTable registerNib:[UINib nibWithNibName:@"PromoOutletCell" bundle:nil] forCellReuseIdentifier:@"PromoOutletCell"];
    [self.ibDealsTable registerNib:[UINib nibWithNibName:@"SeDealsFeaturedTblCell" bundle:nil] forCellReuseIdentifier:@"SeDealsFeaturedTblCell"];
    [self.ibNearbyShopCollection registerNib:[UINib nibWithNibName:@"NearbyShopsCell" bundle:nil] forCellWithReuseIdentifier:@"NearbyShopsCell"];
    
    [self requestServerForDealInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self initViewArray];
    [self initSelfView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setDealDetailsViewType:(DealDetailsViewType)viewType{
    _viewType = viewType;
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
}

-(void)initSelfView{
    
    switch (self.viewType) {
        case UncollectedDealDetailsView:
            
            break;
            
        case CollectedDealDetailsView:
            break;
            
        case RedeemedDealDetailsView:
            break;
            
        case ExpiredDealDetailsView:
            break;
            
        default:
            break;
    }
    
//    self.ibAvailabilityTable.estimatedRowHeight = [DealDetailsAvailabilityCell getHeight];
//    self.ibAvailabilityTable.rowHeight = UITableViewAutomaticDimension;
    self.ibShopTable.estimatedRowHeight = [PromoOutletCell getHeight];
    self.ibShopTable.rowHeight = UITableViewAutomaticDimension;
    self.ibDealsTable.estimatedRowHeight = [SeDealsFeaturedTblCell getHeight];
    self.ibDealsTable.rowHeight = UITableViewAutomaticDimension;
    
    if (self.viewArray && self.viewArray.count > 0) {
        for (UIView *view in self.viewArray) {
//            [view setHeight:0];
            [self.ibMainContentView addSubview:view];
        }
        [self updateViewFrame];
    }
    
    [self updateViewFrame];
    
    [self drawBorders];
}

-(void)initViewArray{
    _viewArray = @[self.ibHeaderView, self.ibDealDetailsView, self.ibAvailabilityView, self.ibShopView, self.ibTnCView, self.ibDealsView , self.ibNearbyShopView, self.ibReportView];
    
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
}

-(void)updateViews{
    [self updateHeaderView];
    [self updateDetailsView];
    [self updateAvailabilityView];
    [self updateShopView];
    [self updateViewFrame];
    
}

-(void)updateHeaderView{
    self.ibHeaderSubTitleLbl.text = self.dealModel.title;
    
    ShopModel *shopModel = self.dealModel.shops[0];
    self.ibHeaderTitleLbl.text = shopModel.name;
    
    if (![Utils isArrayNull:self.dealModel.photos]) {
        PhotoModel *photoModel = [self.dealModel.photos objectAtIndex:0];
        [self.ibHeaderDealImage sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel.imageURL] completed:^(UIImage *image) {
            self.ibHeaderImageCountLbl.text = [NSString stringWithFormat:@"%d/%lu", 1, (unsigned long)self.dealModel.photos.count];
        }];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *expireDate = [dateFormatter dateFromString:self.dealModel.expired_at];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.ibHeaderDealExpiryLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expires"), [dateFormatter stringFromDate:expireDate]];
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
    
//    CGFloat contentHeight = self.ibDealDetailsRedemptionContentView.frame.origin.y + self.ibRedemptionContentViewHeightConstraint.constant + 15;
//    SLog(@"%f = %f + %f", contentHeight, self.ibDealDetailsRedemptionContentView.frame.origin.y, self.ibRedemptionContentViewHeightConstraint.constant);
//    self.ibDealDetailsView.frame = CGRectMake(self.ibDealDetailsView.frame.origin.x, self.ibDealDetailsView.frame.origin.y, self.ibDealDetailsView.frame.size.width, contentHeight);
}

-(void)updateAvailabilityView{
    [self.ibAvailabilityTable reloadData];
    
    float cellHeight = [DealDetailsAvailabilityCell getHeight];
    NSInteger numberOfDays = self.dealModel.redemption_period_in_hour_text.allKeys.count;
    float tableHeight = cellHeight * numberOfDays;
    CGFloat totalHeight = self.ibAvailabilityTable.frame.origin.y + tableHeight + 20;
    
    [self.ibAvailabilityView setHeight:totalHeight];
}

-(void)updateShopView{
    self.ibShopTitle.text = [NSString stringWithFormat:@"%@ (%ld)", LocalisedString(@"Participate Shop"), self.dealModel.shops.count];
    
    [self.ibShopTable reloadData];
    
    float cellHeight = [PromoOutletCell getHeight];
    NSInteger numberOfShop = self.dealModel.shops.count;
    float tableHeight = cellHeight * numberOfShop;
    CGFloat totalHeight = self.ibShopTable.frame.origin.y + tableHeight + self.ibShopSeeMoreBtn.frame.size.height + 20;
    
    [self.ibShopView setHeight:totalHeight];
}

-(void)drawBorders{
    [self.ibMainContentView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
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

- (IBAction)buttonShareClicked:(id)sender {
}
- (IBAction)buttonTranslateClicked:(id)sender {
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
        return 5;
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
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibAvailabilityTable) {
        return [DealDetailsAvailabilityCell getHeight];
    }
    else if (tableView == self.ibShopTable){
        return UITableViewAutomaticDimension;
    }
    else if (tableView == self.ibDealsTable){
        return UITableViewAutomaticDimension;
    }
    else if (tableView == self.ibTnCTable){
        return UITableViewAutomaticDimension;
    }
    
    return 40;
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.ibNearbyShopCollection){
        return 3;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ibNearbyShopCollection){
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"NearbyShopsCell" forIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - RequestServer
-(void)requestServerForDealInfo{
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"deal_id": self.dealModel.dID};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetDealInfo param:dict appendString:self.dealModel.dID completeHandler:^(id object) {
        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        [self updateViews];
    } errorBlock:^(id object) {
        
    }];
}

@end

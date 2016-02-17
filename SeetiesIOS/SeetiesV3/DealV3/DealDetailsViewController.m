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
@property (weak, nonatomic) IBOutlet UICollectionView *ibTagCollection;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsDesc;
@property (weak, nonatomic) IBOutlet UILabel *ibDealDetailsDescLbl;
@property (weak, nonatomic) IBOutlet UIView *ibDealDetailsRedemptionContentView;

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
    
    [self.ibTagCollection registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil] forCellWithReuseIdentifier:@"TagCell"];
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
    
    self.ibAvailabilityTable.estimatedRowHeight = [DealDetailsAvailabilityCell getHeight];
    self.ibAvailabilityTable.rowHeight = UITableViewAutomaticDimension;
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
    _viewArray = @[self.ibHeaderView, self.ibDealDetailsView, self.ibAvailabilityView, self.ibShopView, self.ibDealsView , self.ibNearbyShopView, self.ibReportView];
    
}

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
    if ([Utils stringIsNilOrEmpty:self.dealModel.cover_title]) {
        self.ibHeaderTitleLbl.text = self.dealModel.title;
    }
    else{
        self.ibHeaderTitleLbl.text = self.dealModel.cover_title;
    }
    
    if (![Utils isArrayNull:self.dealModel.photos]) {
        PhotoModel *photoModel = [self.dealModel.photos objectAtIndex:0];
        [self.ibHeaderDealImage sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel.imageURL] completed:^(UIImage *image) {
            
        }];
    }
    
    [self updateViewFrame];
    
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
        return 2;
    }
    else if (tableView == self.ibShopTable){
        return 3;
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
        return [tableView dequeueReusableCellWithIdentifier:@"DealDetailsAvailabilityCell"];
    }
    else if (tableView == self.ibShopTable){
        return [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
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
        return UITableViewAutomaticDimension;
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
    if (collectionView == self.ibTagCollection) {
        return 2;
    }
    else if (collectionView == self.ibNearbyShopCollection){
        return 3;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ibTagCollection) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    }
    else if (collectionView == self.ibNearbyShopCollection){
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"NearbyShopsCell" forIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - RequestServer
-(void)requestServerForDealInfo{
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"deal_id": self.dealModel.dID};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetSuperDeals param:dict appendString:self.dealModel.dID completeHandler:^(id object) {
        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        [self updateViews];
    } errorBlock:^(id object) {
        
    }];
}

@end

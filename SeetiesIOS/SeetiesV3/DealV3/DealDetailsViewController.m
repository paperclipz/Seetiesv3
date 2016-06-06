//
//  DealDetailsViewController.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealDetailsViewController.h"
#import "UILabel+Exntension.h"
#import "PhotoViewController.h"
#import "IDMPhotoBrowser.h"
#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"
#import "UIView+Toast.h"

@interface DealDetailsViewController (){
    float contentHeightPadding;
    float footerHeight;
    int photoPage;
}

@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderSubTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibMainContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibMainContentHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderImageCountLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibHeaderImageScrollView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderImageContentView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderBlackShadeView;

@property (weak, nonatomic) IBOutlet UIImageView *ibHeaderBlackShadeIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderBlackShadeStatus;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderNormalExpiryView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderRedeemExpiryView;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderExpiryView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderNormalExpiryLbl;
@property (weak, nonatomic) IBOutlet UIImageView *ibHeaderNormalExpiryIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderRedeemExpiryTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderRedeemExpiryDescLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibHeaderImageContentWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibHeaderExpiryHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibHeaderScrollviewHeightConstraint;

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
@property (weak, nonatomic) IBOutlet UILabel *ibAvailabilityEmptyTxt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibAvailabiltyEmptyTxtHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibShopView;
@property (weak, nonatomic) IBOutlet UIView *ibShopContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibShopTable;
@property (weak, nonatomic) IBOutlet UILabel *ibShopTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibShopSeeMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibShopSeeMoreHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibTnCView;
@property (weak, nonatomic) IBOutlet UIView *ibTnCContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibTnCTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibTnCReadMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *ibTnCReadMoreLbl;
@property (weak, nonatomic) IBOutlet UIView *ibTnCContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTnCSeeMoreHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibTnCContentHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibDealsView;
@property (weak, nonatomic) IBOutlet UILabel *ibDealsTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *ibDealsContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibDealsTable;
@property (weak, nonatomic) IBOutlet UIView *ibDealsTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibDealsSeeMoreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibDealsSeeMoreHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *ibNearbyShopView;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibNearbyShopCollection;
@property (weak, nonatomic) IBOutlet UIView *ibNearbyShopHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *ibNearbyShopTitle;
@property (weak, nonatomic) IBOutlet UIButton *ibNearbyShopSeeMoreBtn;

@property (strong, nonatomic) IBOutlet UIView *ibReportView;
@property (weak, nonatomic) IBOutlet UIView *ibReportContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibReportLbl;

@property (weak, nonatomic) IBOutlet UIView *ibFooterView;
@property (weak, nonatomic) IBOutlet UIView *ibInnerFooterView;
@property (weak, nonatomic) IBOutlet UILabel *ibFooterTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibFooterIcon;

@property(nonatomic) NSArray *viewArray;
@property(nonatomic) DealModel *dealModel;
@property(nonatomic) DealsModel *dealsModel;
@property(nonatomic, strong) NSString *referralID;
@property(nonatomic) DealCollectionModel *dealCollectionModel;
@property(nonatomic, assign) BOOL isProcessing;
@property(nonatomic) DealManager *dealManager;
@property(nonatomic) BOOL fromHistory;
@property(nonatomic) NSMutableArray<SeShopDetailModel> *nearbyShopArray;
@property(nonatomic) NSMutableArray<NSDictionary> *dealAvailabilityArray;
@property(nonatomic) NSUserDefaults *userDefaults;

@property(nonatomic) PromoPopOutViewController *promoPopOutViewController;
@property(nonatomic) DealRedeemViewController *dealRedeemViewController;
@property(nonatomic) SeetiesShopViewController *seetiesShopViewController;
@property(nonatomic) SeetiShopListingViewController *seetieShopListingViewController;
@property(nonatomic) DealDetailsViewController *dealDetailsViewController;
@property(nonatomic) VoucherListingViewController *voucherListingViewController;
@property(nonatomic) TermsViewController *termsViewController;
@property(nonatomic) ReportProblemViewController *reportProblemViewController;
@property(nonatomic) PhotoViewController *photoViewController;
@property(nonatomic) RedemptionHistoryViewController *redemptionHistoryViewController;
@property(nonatomic) HowToRedeemViewController *howToRedeemViewController;

@end

@implementation DealDetailsViewController

- (void)tapImage:(UITapGestureRecognizer*)sender {

//    _photoViewController = nil;
//    
//    NSMutableArray* arrImages = [NSMutableArray new];
//    for (int i = 0; i<self.dealModel.photos.count; i++) {
//        
//        [arrImages addObject:self.dealModel.photos[i]];
//    }
//    
//    [self.photoViewController initData:arrImages scrollToIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    CATransition* transition = [CATransition animation];
//    
//    transition.duration = 0.3;
//    transition.type = kCATransitionFade;
//    
//    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
//    
//    [self.navigationController pushViewController:self.photoViewController animated:NO onCompletion:^{
//        
//    }];
    
    [self showPhotoViewer:self.ibHeaderImageScrollView Index:photoPage];
}

-(void)showPhotoViewer:(UIView*)view Index:(int)index
{
    
    NSMutableArray *photos = [NSMutableArray new];
    
    for (PhotoModel* photo in self.dealModel.photos) {
        
        NSURL *url  = [NSURL URLWithString:photo.imageURL];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:view];
    [self presentViewController:browser animated:YES completion:nil];
    [browser setInitialPageIndex:index];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tabImagesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [self.ibHeaderImageScrollView addGestureRecognizer:tabImagesture];
    
    // Do any additional setup after loading the view from its nib.
    self.isProcessing = NO;
    contentHeightPadding = 10.0;
    footerHeight = 50.0;
    
    [self.ibAvailabilityTable registerNib:[UINib nibWithNibName:@"DealDetailsAvailabilityCell" bundle:nil] forCellReuseIdentifier:@"DealDetailsAvailabilityCell"];
    [self.ibShopTable registerNib:[UINib nibWithNibName:@"PromoOutletCell" bundle:nil] forCellReuseIdentifier:@"PromoOutletCell"];
    [self.ibDealsTable registerNib:[UINib nibWithNibName:@"SeDealsFeaturedTblCell" bundle:nil] forCellReuseIdentifier:@"SeDealsFeaturedTblCell"];
    [self.ibNearbyShopCollection registerNib:[UINib nibWithNibName:@"NearbyShopsCell" bundle:nil] forCellWithReuseIdentifier:@"NearbyShopsCell"];
    
    
//    __weak typeof (self)weakSelf = self;
//    
//    self.btnBackBlock = ^(id object)
//    {
//    
//        if (weakSelf.dealModelBlock) {
//            weakSelf.dealModelBlock(weakSelf.dealModel);
//        }
//
//    };
}

-(void)viewDidAppear:(BOOL)animated{
    self.ibReportLbl.text = LocalisedString(@"Report this deal");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupView
{
    
//    [LoadingManager show];
    [self initViewArray];
    [self initSelfView];
    [self updateViews];
    if (!self.fromHistory) {
        if ([Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
            [self requestServerForDealInfo];
        }
        else{
            [self requestServerForVoucherInfo];
            
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

-(void)initDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    _referralID = nil;
    _dealCollectionModel = nil;
}

-(void)initDealModel:(DealModel *)dealModel withReferral:(NSString*)referralId withDealCollectionInfo:(DealCollectionModel *)dealCollectionModel{
    _dealModel = dealModel;
    _referralID = referralId;
    _dealCollectionModel = dealCollectionModel;
}

-(void)setFromHistory:(BOOL)fromHistory{
    _fromHistory = fromHistory;
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

-(void)formatDealAvailability{
    if (self.dealModel.redemption_period_in_hour_text) {
        [self.dealAvailabilityArray removeAllObjects];
        for (int i=0 ; i<7; i++) {
            NSString *day;
            switch (i) {
                case 0:
                    day = @"Sunday";
                    break;
                    
                case 1:
                    day = @"Monday";
                    break;
                    
                case 2:
                    day = @"Tuesday";
                    break;
                    
                case 3:
                    day = @"Wednesday";
                    break;
                    
                case 4:
                    day = @"Thursday";
                    break;
                    
                case 5:
                    day = @"Friday";
                    break;
                    
                case 6:
                    day = @"Saturday";
                    break;
                    
                default:
                    day = @"";
                    break;
            }
            
            NSString *time = [self.dealModel.redemption_period_in_hour_text objectForKey:day];
            if (time) {
                NSDictionary *period = @{@"day" : LocalisedString(day),
                                         @"time" : time};
                [self.dealAvailabilityArray addObject:period];
            }
        }
    }
}

#pragma mark - IBAction
- (IBAction)shopSeeMoreBtnClicked:(id)sender {
    self.seetieShopListingViewController = nil;
    self.seetieShopListingViewController.title = LocalisedString(@"Participating outlets");
    [self.navigationController pushViewController:self.seetieShopListingViewController animated:YES onCompletion:^{
        NSMutableArray *copyOfShopModel = [[NSMutableArray alloc] initWithArray:self.dealModel.shops];
        [self.seetieShopListingViewController initWithArray:copyOfShopModel];
    }];
}

- (IBAction)nearbyShopSeeMoreBtnClicked:(id)sender {
    self.seetieShopListingViewController = nil;
    self.seetieShopListingViewController.title = LocalisedString(@"Shops nearby");
    SeShopDetailModel *shopModel;
    if (![Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
        shopModel = self.dealModel.voucher_info.shop_info;
    }
    else{
        shopModel = self.dealModel.shops[0];
    }
    [self.navigationController pushViewController:self.seetieShopListingViewController animated:YES onCompletion:^{
        
        [self.seetieShopListingViewController initData:shopModel.seetishop_id PlaceID:nil PostID:nil];
    }];
}

- (IBAction)relatedDealsSeeMoreBtnClicked:(id)sender {
    self.voucherListingViewController = nil;
    [self.voucherListingViewController initWithDealId:self.dealModel.dID];
    [self.navigationController pushViewController:self.voucherListingViewController animated:YES];
}

- (IBAction)tnCReadMoreBtnClicked:(id)sender {
    self.termsViewController = nil;
    [self.termsViewController initData:self.dealModel.terms];
    [self.navigationController pushViewController:self.termsViewController animated:YES];
}

- (IBAction)reportBtnClicked:(id)sender {
    self.reportProblemViewController = nil;
    [self.reportProblemViewController initDataReportDeal:self.dealModel.dID];
    [self.navigationController pushViewController:self.reportProblemViewController animated:YES];
}

#pragma mark - Declaration

-(PhotoViewController*)photoViewController
{
    if (!_photoViewController) {
        _photoViewController = [PhotoViewController new];
    }
    
    return _photoViewController;
}

-(DealManager *)dealManager{
    if(!_dealManager)
    {
        _dealManager = [DealManager Instance];
    }
    return _dealManager;
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

-(NSMutableArray<NSDictionary> *)dealAvailabilityArray{
    if (!_dealAvailabilityArray) {
        _dealAvailabilityArray = [[NSMutableArray<NSDictionary> alloc] init];
    }
    return _dealAvailabilityArray;
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

-(DealDetailsViewController *)dealDetailsViewController{
    if (!_dealDetailsViewController) {
        _dealDetailsViewController = [DealDetailsViewController new];
    }
    return _dealDetailsViewController;
}

-(VoucherListingViewController *)voucherListingViewController{
    if (!_voucherListingViewController) {
        _voucherListingViewController = [VoucherListingViewController new];
    }
    return _voucherListingViewController;
}

-(TermsViewController *)termsViewController{
    if (!_termsViewController) {
        _termsViewController = [TermsViewController new];
    }
    return _termsViewController;
}

-(ReportProblemViewController *)reportProblemViewController{
    if (!_reportProblemViewController) {
        _reportProblemViewController = [ReportProblemViewController new];
    }
    return _reportProblemViewController;
}

-(RedemptionHistoryViewController *)redemptionHistoryViewController{
    if (!_redemptionHistoryViewController) {
        _redemptionHistoryViewController = [RedemptionHistoryViewController new];
    }
    return _redemptionHistoryViewController;
}

-(HowToRedeemViewController *)howToRedeemViewController{
    if (!_howToRedeemViewController) {
        _howToRedeemViewController = [HowToRedeemViewController new];
    }
    return _howToRedeemViewController;
}

-(NSUserDefaults *)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
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
    
    self.ibMainContentHeightConstraint.constant = totalHeight + self.ibFooterView.frame.size.height/2;
    [self.view refreshConstraint];
    
}

-(void)updateViews{
    [self updateHeaderView];
    [self updateDetailsView];
    [self updateAvailabilityView];
    [self updateShopView];
    [self updateTnCView];
    [self updateDealsView];
    [self updateNearbyShopView];
    [self updateFooterView];
    [self updateViewFrame];
}

-(void)updateHeaderView{
    self.ibHeaderScrollviewHeightConstraint.constant = self.ibHeaderImageScrollView.frame.size.width/2;
    [self.ibHeaderView layoutIfNeeded];
    
    self.ibHeaderSubTitleLbl.text = self.dealModel.title;
    
    if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE]) {
        if (![Utils isStringNull:self.dealModel.shop_group_info.name]) {
            self.ibHeaderTitleLbl.text = self.dealModel.shop_group_info.name;
        }
        else{
            SeShopDetailModel *shopModel = self.dealModel.shops[0];
            self.ibHeaderTitleLbl.text = shopModel.name;
        }
    }
    else{
        self.ibHeaderTitleLbl.text = self.dealModel.voucher_info.shop_info.name;
    }
    
    //Set image scrollview
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
    
    self.ibHeaderExpiryView.hidden = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString *status = self.dealModel.voucher_info.status;
    
    //Set header overlay
    self.ibHeaderBlackShadeView.hidden = NO;
    if (self.dealCollectionModel && [self.dealCollectionModel isCampaignExpired]) {
        [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsListingCampaignEnd.png"]];
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Campaign End");
    }
    else if ([status isEqualToString:VOUCHER_STATUS_EXPIRED]){
        [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsExpiredIcon.png"]];
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Expired");
    }
    else if ([status isEqualToString:VOUCHER_STATUS_REDEEMED]){
        [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsRedeemedIcon.png"]];
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Redeemed");
    }
    else if ([status isEqualToString:VOUCHER_STATUS_NONE]){
        if ([Utils isValidDateString:self.dealModel.collection_expired_at] && self.dealModel.collectionDaysLeft <= 0) {
            [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsExpiredIcon.png"]];
            self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Expired");
        }
        else if (self.dealModel.total_available_vouchers == 0){
            [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsListingSoldOutIcon.png"]];
            self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Sold Out");
        }
        else{
            self.ibHeaderBlackShadeView.hidden = YES;
        }
    }
    else if ([status isEqualToString:VOUCHER_STATUS_DELETED]){
        [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsDeletedIcon.png"]];
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Deleted");
    }
    else if ([status isEqualToString:VOUCHER_STATUS_CANCELLED]){
        [self.ibHeaderBlackShadeIcon setImage:[UIImage imageNamed:@"DealsCancelledIcon.png"]];
        self.ibHeaderBlackShadeStatus.text = LocalisedString(@"Cancelled");
    }
    else{
        self.ibHeaderBlackShadeView.hidden = YES;
    }
    
    //Set expiry banner
    if (self.dealCollectionModel && [self.dealCollectionModel isCampaignExpired]) {
        if ([status isEqualToString:VOUCHER_STATUS_NONE]) {
            self.ibHeaderRedeemExpiryView.hidden = YES;
            self.ibHeaderNormalExpiryView.hidden = YES;
            self.ibHeaderExpiryHeightConstraint.constant = 0;
        }
        else if ([status isEqualToString:VOUCHER_STATUS_COLLECTED]){
            self.ibHeaderRedeemExpiryView.hidden = YES;
            self.ibHeaderNormalExpiryView.hidden = NO;
            self.ibHeaderExpiryHeightConstraint.constant = 50;
            [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsVoucherExpireIcon.png"]];
            self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
            self.ibHeaderNormalExpiryLbl.font = [UIFont systemFontOfSize:14.0f];
            
            if ([Utils isValidDateString:self.dealModel.voucher_info.expired_at]) {
                NSInteger numberOfDaysLeft = self.dealModel.redemptionDaysLeft;
                if (numberOfDaysLeft < 8 && numberOfDaysLeft > 0){
                    [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsVoucherExpireIconRed.png"]];
                    self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Voucher ends in {!days} days" withPlaceHolder:@{@"{!days}": @(numberOfDaysLeft)}];
                    self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:232/255.0f green:86/255.0f blue:100/255.0f alpha:1];
                    self.ibHeaderNormalExpiryLbl.font = [UIFont boldSystemFontOfSize:14.0f];
                }
                else{
                    NSDate *expiredDate = [dateFormatter dateFromString:self.dealModel.expired_at];
                    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                    [dateFormatter setDateFormat:@"dd MMM yyyy"];
                    self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Voucher ends: {!date}" withPlaceHolder:@{@"{!date}": [dateFormatter stringFromDate:expiredDate]?[dateFormatter stringFromDate:expiredDate]:@""}];
                }
            }
            else{
                self.ibHeaderNormalExpiryLbl.text = LocalisedString(@"This deal has no expiry");
            }
        }
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_EXPIRED]){
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = NO;
        self.ibHeaderExpiryHeightConstraint.constant = 50;
        
        NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.voucher_info.expired_at];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:expiryDate];
        
        NSString *displayString = [LanguageManager stringForKey:@"Expired on {!date}" withPlaceHolder:@{@"{!date}":dateString?dateString:@""}];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:displayString];
        NSRange dateRange = [displayString rangeOfString:dateString];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:dateRange];
        [attrString addAttribute:NSForegroundColorAttributeName value:DEVICE_COLOR range:dateRange];
        [attrString endEditing];
        self.ibHeaderNormalExpiryLbl.attributedText = attrString;
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_REDEEMED]){
        self.ibHeaderRedeemExpiryView.hidden = NO;
        self.ibHeaderNormalExpiryView.hidden = YES;
        self.ibHeaderExpiryHeightConstraint.constant = 100;
        
        self.ibHeaderRedeemExpiryDescLbl.text = LocalisedString(@"Voucher redemptions must be made in front of shop staff");
        
        NSDate *redeemDate = [dateFormatter dateFromString:self.dealModel.voucher_info.redeemed_at];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *date = [dateFormatter stringFromDate:redeemDate];
        [dateFormatter setDateFormat:@"hh:mmaa"];
        NSString *time = [dateFormatter stringFromDate:redeemDate];
        
        NSString *displayString = [LanguageManager stringForKey:@"Redeemed on {!date}, {!time}" withPlaceHolder:@{@"{!date}":date?date:@"", @"{!time}":time?time:@""}];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:displayString];
        NSRange dateRange = [displayString rangeOfString:date];
        NSRange timeRange = [displayString rangeOfString:time];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:dateRange];
        [attrString addAttribute:NSForegroundColorAttributeName value:DEVICE_COLOR range:dateRange];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:timeRange];
        [attrString addAttribute:NSForegroundColorAttributeName value:DEVICE_COLOR range:timeRange];
        [attrString endEditing];
        
        self.ibHeaderRedeemExpiryTitleLbl.attributedText = attrString;
    }
    else if ([status isEqualToString:VOUCHER_STATUS_DELETED]){
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = NO;
        self.ibHeaderExpiryHeightConstraint.constant = 50;
        
        NSDate *deletedDate = [dateFormatter dateFromString:self.dealModel.voucher_info.status_history_datetime];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:deletedDate];
        
        NSString *displayString = [LanguageManager stringForKey:@"Deleted on {!date}" withPlaceHolder:@{@"{!date}":dateString?dateString:@""}];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:displayString];
        NSRange dateRange = [displayString rangeOfString:dateString];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:dateRange];
        [attrString addAttribute:NSForegroundColorAttributeName value:DEVICE_COLOR range:dateRange];
        [attrString endEditing];
        self.ibHeaderNormalExpiryLbl.attributedText = attrString;
    }
    else if ([status isEqualToString:VOUCHER_STATUS_CANCELLED]){
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = NO;
        self.ibHeaderExpiryHeightConstraint.constant = 50;
        
        NSDate *cancelledDate = [dateFormatter dateFromString:self.dealModel.voucher_info.status_history_datetime];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:cancelledDate];
        
        NSString *displayString = [LanguageManager stringForKey:@"Cancelled on {!date}" withPlaceHolder:@{@"{!date}":dateString?dateString:@""}];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:displayString];
        NSRange dateRange = [displayString rangeOfString:dateString];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0f] range:dateRange];
        [attrString addAttribute:NSForegroundColorAttributeName value:DEVICE_COLOR range:dateRange];
        [attrString endEditing];
        self.ibHeaderNormalExpiryLbl.attributedText = attrString;
    }
    else if([status isEqualToString:VOUCHER_STATUS_COLLECTED]){
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = NO;
        self.ibHeaderExpiryHeightConstraint.constant = 50;
        [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsVoucherExpireIcon.png"]];
        self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        self.ibHeaderNormalExpiryLbl.font = [UIFont systemFontOfSize:14.0f];
        
        if ([Utils isValidDateString:self.dealModel.voucher_info.expired_at]) {
            NSInteger numberOfDaysLeft = self.dealModel.redemptionDaysLeft;
            if (numberOfDaysLeft < 8 && numberOfDaysLeft > 0){
                [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsVoucherExpireIconRed.png"]];
                self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Voucher ends in {!days} days" withPlaceHolder:@{@"{!days}": @(numberOfDaysLeft)}];
                self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:232/255.0f green:86/255.0f blue:100/255.0f alpha:1];
                self.ibHeaderNormalExpiryLbl.font = [UIFont boldSystemFontOfSize:14.0f];
            }
            else{
                NSDate *expiredDate = [dateFormatter dateFromString:self.dealModel.voucher_info.expired_at];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Voucher ends: {!date}" withPlaceHolder:@{@"{!date}": [dateFormatter stringFromDate:expiredDate]?[dateFormatter stringFromDate:expiredDate]:@""}];
            }
        }
        else{
            self.ibHeaderNormalExpiryLbl.text = LocalisedString(@"This deal has no expiry");
        }
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE]){
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = NO;
        self.ibHeaderExpiryHeightConstraint.constant = 50;
        [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsDealEndIcon.png"]];
        self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        self.ibHeaderNormalExpiryLbl.font = [UIFont systemFontOfSize:14.0f];
        
        if ([Utils isValidDateString:self.dealModel.collection_expired_at]) {
            NSInteger numberOfDaysLeft = self.dealModel.collectionDaysLeft;
            if (numberOfDaysLeft < 8 && numberOfDaysLeft > 0){
                [self.ibHeaderNormalExpiryIcon setImage:[UIImage imageNamed:@"DealsDealEndIconRed.png"]];
                self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Deals ends in {!days} days" withPlaceHolder:@{@"{!days}": @(numberOfDaysLeft)}];
                self.ibHeaderNormalExpiryLbl.textColor = [UIColor colorWithRed:232/255.0f green:86/255.0f blue:100/255.0f alpha:1];
                self.ibHeaderNormalExpiryLbl.font = [UIFont boldSystemFontOfSize:14.0f];
            }
            else{
                NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.collection_expired_at];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"dd MMM yyyy"];
                self.ibHeaderNormalExpiryLbl.text = [LanguageManager stringForKey:@"Deals ends: {!date}" withPlaceHolder:@{@"{!date}": [dateFormatter stringFromDate:expiryDate]?[dateFormatter stringFromDate:expiryDate]:@""}];
                
            }
        }
        else{
            self.ibHeaderNormalExpiryLbl.text = LocalisedString(@"This deal has no expiry");
        }
    }
    else{
        self.ibHeaderRedeemExpiryView.hidden = YES;
        self.ibHeaderNormalExpiryView.hidden = YES;
        self.ibHeaderExpiryHeightConstraint.constant = 0;
    }
    
    CGFloat contentHeight = self.ibHeaderExpiryHeightConstraint.constant + self.ibHeaderImageScrollView.frame.size.height + contentHeightPadding;
    [self.ibHeaderView setHeight:contentHeight];
}

-(void)updateDetailsView{
    self.ibDealDetailsTitleLbl.text = self.dealModel.title;
    [self.ibDealDetailsDesc setStandardText:self.dealModel.deal_desc numberOfLine:0];
    self.ibDealDetailsDescLbl.text = LocalisedString(@"Deal description");
    
    CGFloat tagHeight = 20.0f;
    CGFloat spacing = 10.0f;
    CGFloat fontSize = 11.0f;
    CGFloat padding = 20.0f;
    CGFloat xOrigin = 0;
    CGFloat yOrigin = (self.ibTagContentView.frame.size.height-tagHeight)/2;
    //Clear all subiviews before adding in new subview
    for (UIView *subview in [self.ibTagContentView subviews]) {
        [subview removeFromSuperview];
    }
    if (self.dealModel.is_feature) {
        NSString *tag = [NSString stringWithFormat:@"%@", LocalisedString(@"FEATURED")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont boldSystemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:232/255.0f green:86/255.0f blue:100/255.f alpha:1]];
        [Utils setRoundBorder:tagLbl color:[UIColor clearColor] borderRadius:tagLbl.frame.size.height/2];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    if (self.dealModel.total_available_vouchers <= 10 && self.dealModel.total_available_vouchers > 0) {
        NSString *tag = [LanguageManager stringForKey:@"{!number} voucher(s) left" withPlaceHolder:@{@"{!number}": @(self.dealModel.total_available_vouchers)}];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont boldSystemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:253/255.0f green:175/255.0f blue:23/255.0f alpha:1]];
        [Utils setRoundBorder:tagLbl color:[UIColor clearColor] borderRadius:tagLbl.frame.size.height/2];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_FREE]) {
        NSString *tag = [NSString stringWithFormat:@"%@", LocalisedString(@"FREE")];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont boldSystemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:DEVICE_COLOR];
        [Utils setRoundBorder:tagLbl color:[UIColor clearColor] borderRadius:tagLbl.frame.size.height/2];
        [self.ibTagContentView addSubview:tagLbl];
        xOrigin += tagLbl.frame.size.width + spacing;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_DISCOUNT] || [self.dealModel.deal_type isEqualToString:DEAL_TYPE_PACKAGE]) {
        NSString *tag = [LanguageManager stringForKey:@"{!number}% off" withPlaceHolder:@{@"{!number}": self.dealModel.discount_percentage?self.dealModel.discount_percentage:@""}];
        CGSize lblSize = [tag sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
        UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, lblSize.width+padding, tagHeight)];
        [tagLbl setFont:[UIFont boldSystemFontOfSize:fontSize]];
        tagLbl.textAlignment = NSTextAlignmentCenter;
        tagLbl.text = tag;
        [tagLbl setTextColor:[UIColor whiteColor]];
        [tagLbl setBackgroundColor:[UIColor colorWithRed:191/255.0f green:214/255.0f blue:48/255.0f alpha:1]];
        [Utils setRoundBorder:tagLbl color:[UIColor clearColor] borderRadius:tagLbl.frame.size.height/2];
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
            redemptionTypeView.ibRedemptionTypeLbl.text = LocalisedString(@"Takeaway");
        }
        else{
            redemptionTypeView.ibRedemptionTypeLbl.text = type;
        }
        redemptionTypeView.frame = CGRectMake(0, redemptionYOrigin, self.ibDealDetailsRedemptionContentView.frame.size.width, redemptionTypeView.frame.size.height);
        [self.ibDealDetailsRedemptionContentView addSubview:redemptionTypeView];
        redemptionYOrigin += redemptionTypeView.frame.size.height;
    }
    self.ibRedemptionContentViewHeightConstraint.constant = redemptionYOrigin;
    
    [self.ibDealDetailsView layoutIfNeeded];
    CGFloat contentHeight = self.ibDealDetailsRedemptionContentView.frame.origin.y + self.ibRedemptionContentViewHeightConstraint.constant + contentHeightPadding;
    [self.ibDealDetailsView setHeight:contentHeight];
}


-(void)updateAvailabilityView{
    [self formatDealAvailability];
    [self.ibAvailabilityTable reloadData];
    self.ibAvailabilityTitle.text = LocalisedString(@"Deal availability");
    self.ibAvailabilityDesc.text = LocalisedString(@"This deal can only be redeemed at time as stated below:");
    
    NSString *emptyText = LocalisedString(@"This voucher is only applicable based on outlet operating hours.");
    CGRect rect = [emptyText boundingRectWithSize:CGSizeMake(self.ibAvailabilityEmptyTxt.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    self.ibAvailabilityEmptyTxt.text = emptyText;
    
    [self.ibAvailabilityView layoutIfNeeded];
    if (self.dealAvailabilityArray.count == 0) {
        self.ibAvailabiltyEmptyTxtHeightConstraint.constant = rect.size.height;
        [self.ibAvailabilityView setHeight:self.ibAvailabilityEmptyTxt.frame.origin.y + self.ibAvailabiltyEmptyTxtHeightConstraint.constant + contentHeightPadding + 24];
    }
    else{
        self.ibAvailabiltyEmptyTxtHeightConstraint.constant = 0;
        float cellHeight = [DealDetailsAvailabilityCell getHeight];
        NSInteger numberOfDays = self.dealAvailabilityArray.count;
        float tableHeight = cellHeight * numberOfDays;
        CGFloat totalHeight = self.ibAvailabilityTable.frame.origin.y + tableHeight + 16 + contentHeightPadding;
        
        [self.ibAvailabilityView setHeight:totalHeight];
    }
}

-(void)updateShopView{
    self.ibShopTitle.text = [LanguageManager stringForKey:@"Participating outlets ({!number})" withPlaceHolder:@{@"{!number}": @(self.dealModel.shops.count)}];
    [self.ibShopSeeMoreBtn setTitle:LocalisedString(@"See more") forState:UIControlStateNormal];
    [self.ibShopTable reloadData];
    
    float cellHeight = [PromoOutletCell getHeight];
    NSInteger numberOfShop = self.dealModel.shops.count > 3? 3 : self.dealModel.shops.count;
    float tableHeight = cellHeight * numberOfShop;
    [self.ibShopView layoutIfNeeded];
    CGFloat totalHeight = self.ibShopTable.frame.origin.y + tableHeight + contentHeightPadding;
    
    if (self.dealModel.shops.count > 3) {
        self.ibShopSeeMoreHeightConstraint.constant = footerHeight;
        self.ibShopSeeMoreBtn.hidden = NO;
        totalHeight += self.ibShopSeeMoreHeightConstraint.constant;
    }
    else{
        self.ibShopSeeMoreHeightConstraint.constant = 0;
        self.ibShopSeeMoreBtn.hidden = YES;
        totalHeight += self.ibShopSeeMoreHeightConstraint.constant;
    }
    
    [self.ibShopView setHeight:totalHeight];
}

-(void)updateTnCView{
    self.ibTnCTitle.text = LocalisedString(@"Terms & Conditions");
    self.ibTnCReadMoreLbl.text = LocalisedString(@"Read the full T&Cs here");
    
    if ([Utils isArrayNull:self.dealModel.terms]) {
        [self.ibTnCView setHeight:0];
    }
    else{
        float yOrigin = 0;
        int count = 0;
        float fontSize = 15.0f;
        
        //Clear all subviews before adding in new subview
        for (UIView *subview in [self.ibTnCContent subviews]) {
            [subview removeFromSuperview];
        }
        
        self.ibTnCContentHeightConstraint.constant = 0;
        NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        for (NSString *term in self.dealModel.terms) {
            if (count >= 5) {
                break;
            }
            
            UILabel *bulletPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin+3, 16, 7)];
            bulletPoint.font = [UIFont systemFontOfSize:fontSize];
            bulletPoint.textColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
            bulletPoint.text = [NSString stringWithFormat:@"\u2022"];
            
            NSString *formattedTerm = [NSString stringWithFormat:@"%@", term];
            if (count == 4 && self.dealModel.terms.count > 5) {
                formattedTerm = [NSString stringWithFormat:@"%@ ...", term];
            }
            CGRect rect = [formattedTerm boundingRectWithSize:CGSizeMake(self.ibTnCContent.frame.size.width-bulletPoint.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            UILabel *tncLbl = [[UILabel alloc]initWithFrame:CGRectMake(bulletPoint.frame.size.width, yOrigin, ceilf(rect.size.width), ceilf(rect.size.height))];
            tncLbl.font = [UIFont systemFontOfSize:fontSize];
            tncLbl.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            tncLbl.numberOfLines = 0;
            tncLbl.text = formattedTerm;
            
            [self.ibTnCContent addSubview:bulletPoint];
            [self.ibTnCContent addSubview:tncLbl];
            yOrigin += tncLbl.frame.size.height + 10;
            count++;
        }
        self.ibTnCContentHeightConstraint.constant = yOrigin;
        
        if (self.dealModel.terms.count > 5) {
            self.ibTnCSeeMoreHeightConstraint.constant = footerHeight;
            self.ibTnCReadMoreBtn.enabled = YES;
            self.ibTnCReadMoreLbl.hidden = NO;
        }
        else{
            self.ibTnCSeeMoreHeightConstraint.constant = 0;
            self.ibTnCReadMoreBtn.enabled = NO;
            self.ibTnCReadMoreLbl.hidden = NO;
        }
        
        [self.ibTnCView layoutIfNeeded];
        [self.ibTnCView setHeight:self.ibTnCReadMoreLbl.frame.origin.y + self.ibTnCSeeMoreHeightConstraint.constant + contentHeightPadding];
    }
}

-(void)updateNearbyShopView{
    self.ibNearbyShopTitle.text = LocalisedString(@"Shops nearby");
    [self.ibNearbyShopSeeMoreBtn setTitle:LocalisedString(@"See more") forState:UIControlStateNormal];
    [self.ibNearbyShopCollection reloadData];
    
    if (self.nearbyShopArray.count > 0) {
        [self.ibNearbyShopView layoutIfNeeded];
        CGFloat contentHeight = self.ibNearbyShopCollection.frame.origin.y + 132 + 16 + contentHeightPadding;
        [self.ibNearbyShopView setHeight:contentHeight];
    }
    else{
        [self.ibNearbyShopView setHeight:0];
    }
}

-(void)updateDealsView{
    self.ibDealsTitleLbl.text = [NSString stringWithFormat:@"%@ (%d)", LocalisedString(@"Deals"), self.dealsModel.total_count];
    [self.ibDealsSeeMoreBtn setTitle:LocalisedString(@"See more") forState:UIControlStateNormal];
    [self.ibDealsTable reloadData];
    
    NSArray<DealModel> *dealsArray = self.dealsModel.arrDeals;
    int totalDeals = self.dealsModel.total_count;
    if(totalDeals > 0){
        float cellHeight = [SeDealsFeaturedTblCell getHeight];
        NSInteger numberOfDeals = totalDeals > 3? 3 : dealsArray.count;
        float tableHeight = cellHeight * numberOfDeals;
        [self.ibDealsView layoutIfNeeded];
        CGFloat totalHeight = self.ibDealsTable.frame.origin.y + tableHeight + contentHeightPadding;
        
        if (totalDeals > 3) {
            self.ibDealsSeeMoreHeightConstraint.constant = footerHeight;
            self.ibDealsSeeMoreBtn.hidden = NO;
            totalHeight += self.ibDealsSeeMoreHeightConstraint.constant;
        }
        else{
            self.ibDealsSeeMoreHeightConstraint.constant = 0;
            self.ibDealsSeeMoreBtn.hidden = YES;
            totalHeight += self.ibDealsSeeMoreHeightConstraint.constant;
        }
        
        [self.ibDealsView setHeight:totalHeight];
    }
    else{
        [self.ibDealsView setHeight:0];
    }
    
}

-(void)updateFooterView{
    self.ibFooterView.hidden = NO;
    NSString *voucherStatus = self.dealModel.voucher_info.status;
    
    if ([voucherStatus isEqualToString:VOUCHER_STATUS_NONE]) {
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"CollectIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Collect this deal");
        
        if ([self.dealModel.voucher_type isEqualToString:VOUCHER_TYPE_REFERRAL]) {
            if (self.dealCollectionModel && ([self.dealCollectionModel isCampaignExpired] || [self.dealCollectionModel isExceedNumberOfCollectable])) {
                [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
                return;
            }
        }
        
        if (self.dealModel.total_available_vouchers == 0) {
            [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        }
        else{
            [self.ibInnerFooterView setBackgroundColor:DEVICE_COLOR];
        }
        
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_COLLECTED]){
        if ([self.dealModel isRedeemable]) {
            [self.ibInnerFooterView setBackgroundColor:BUTTON_REDEEM_ACTIVE_COLOR];
        }
        else{
            [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        }
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"DealsNextIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Next");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_REDEEMED]){
        [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"DealsRedeemedIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Redeemed");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_EXPIRED]){
        [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"DealsExpiredIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Expired");
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_CANCELLED]){
        [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"DealsCancelledIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Cancelled");
    }
    else if ([voucherStatus isEqualToString:VOUCHER_STATUS_DELETED]){
        [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        [self.ibFooterIcon setImage:[UIImage imageNamed:@"DealsDeletedIcon.png"]];
        self.ibFooterTitle.text = LocalisedString(@"Deleted");
    }
    else{
        self.ibFooterView.hidden = YES;
        [self.ibInnerFooterView setBackgroundColor:BUTTON_DISABLED_COLOR];
        self.ibFooterTitle.text = @"";
    }
    
    [Utils setRoundBorder:self.ibInnerFooterView color:[UIColor clearColor] borderRadius:5.0f];
}

#pragma mark - Delegate
- (IBAction)buttonShareClicked:(id)sender {

    
    PhotoModel *photo = self.dealModel.photos[0];
    NSString *shareTitle = [Utils isStringNull:self.dealModel.title]? self.dealModel.cover_title : self.dealModel.title;

    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    
    dataToPost.title = shareTitle;
    dataToPost.shareID = self.dealModel.dID;
    dataToPost.userID = [Utils getUserID];
    dataToPost.shareType = ShareTypeDeal;
    dataToPost.postImageURL = photo.imageURL;
    
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];

}

- (IBAction)buttonTranslateClicked:(id)sender {
}

- (IBAction)footerBtnClicked:(id)sender {
    if ([Utils isGuestMode]) {
        [UIAlertView showWithTitle:LocalisedString(@"Please Login First") message:@"" cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }
    else{
        if (![Utils isPhoneNumberVerified]) {
            [Utils showVerifyPhoneNumber:self];
            return;
        }
    }
    
    NSString *voucherStatus = self.dealModel.voucher_info.status;
    if ([voucherStatus isEqualToString:VOUCHER_STATUS_NONE]) {
        //Referral type specific checking
        if ([self.dealModel.voucher_type isEqualToString:VOUCHER_TYPE_REFERRAL]) {
            if (self.dealCollectionModel && [self.dealCollectionModel isCampaignExpired]) {
                return;
            }
            // checking for referral redeem state. from deal collection model whether exceed the number of allowed count
            if (self.dealCollectionModel && [self.dealCollectionModel isExceedNumberOfCollectable]) {
                // create a new style
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                
                // this is just one of many style options
                style.messageColor = [UIColor whiteColor];
                
                style.messageFont = [UIFont fontWithName:CustomFontNameBold size:10];
                style.cornerRadius = 12;
                
                // present the toast with the new style
                [self.view makeToast:LocalisedString(@"You Have Exceed The Number To Collect")
                            duration:3.0
                            position:CSToastPositionBottom
                               style:style];
                return;
            }
        }
        
        if (self.dealModel.total_available_vouchers == 0) {
            return;
        }
        if (self.dealModel.shops.count == 1) {
            SeShopDetailModel *shopModel = [self.dealModel.shops objectAtIndex:0];
            [self requestServerToCollectVoucher:shopModel];
        }
        else if(self.dealModel.shops.count > 1){
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:PopOutViewTypeChooseShop];
            [self.promoPopOutViewController setPopOutCondition:PopOutConditionChooseShopOnly];
            [self.promoPopOutViewController setDealModel:self.dealModel];
            [self.promoPopOutViewController setShopArray:self.dealModel.available_shops];
            self.promoPopOutViewController.promoPopOutDelegate = self;
            
            STPopupController *popOutController = [[STPopupController alloc]initWithRootViewController:self.promoPopOutViewController];
            popOutController.containerView.backgroundColor = [UIColor clearColor];
            [popOutController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popOutController presentInViewController:self];
            [popOutController setNavigationBarHidden:YES];
        }
    }
    else if([voucherStatus isEqualToString:VOUCHER_STATUS_COLLECTED]){
        if ([self.dealModel isRedeemable]) {
            self.dealRedeemViewController = nil;
            if ([self.dealModel.voucher_type isEqualToString:VOUCHER_TYPE_REFERRAL] && self.referralID) {
                [self.dealRedeemViewController initWithDealModel:self.dealModel referralID:self.referralID];
            }
            else{
                [self.dealRedeemViewController initWithDealModel:self.dealModel];
            }
            self.dealRedeemViewController.dealRedeemDelegate = self;
            [self presentViewController:self.dealRedeemViewController animated:YES completion:nil];
        }
        else{
            self.promoPopOutViewController = nil;
            [self.promoPopOutViewController setViewType:PopOutViewTypeError];
            [self.promoPopOutViewController setDealModel:self.dealModel];
            
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.promoPopOutViewController];
            popupController.containerView.backgroundColor = [UIColor clearColor];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController presentInViewController:self];
            [popupController setNavigationBarHidden:YES];
        }
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
    [self requestServerForDealInfo];
    
    self.redemptionHistoryViewController = nil;
    [self.navigationController pushViewController:self.redemptionHistoryViewController animated:YES];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.ibAvailabilityTable) {
        return self.dealAvailabilityArray.count;
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
        if (self.dealsModel.arrDeals.count > 3) {
            return 3;
        }
        else{
            return self.dealsModel.arrDeals.count;
        }
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ibAvailabilityTable) {
        DealDetailsAvailabilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealDetailsAvailabilityCell"];
        NSDictionary *availabilityDict = self.dealAvailabilityArray[indexPath.row];
        NSString *day = availabilityDict[@"day"];
        NSString *time = availabilityDict[@"time"];
        cell.ibDayLbl.text = day;
        cell.ibTimeLbl.text = time;
        return cell;
    }
    else if (tableView == self.ibShopTable){
        PromoOutletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromoOutletCell"];
        [cell setCellType:PromoOutletCellTypeNonSelection];
        [cell setShopModel:self.dealModel.shops[indexPath.row]];
        return cell;
    }
    else if (tableView == self.ibDealsTable){
        SeDealsFeaturedTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeDealsFeaturedTblCell"];
        [cell initData:self.dealsModel.arrDeals[indexPath.row]];
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
        DealModel *selectedDeal = self.dealsModel.arrDeals[indexPath.row];
        self.dealDetailsViewController = nil;
        [self.dealDetailsViewController initDealModel:selectedDeal];
        [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
            [self.dealDetailsViewController setupView];
        }];
    }
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.ibNearbyShopCollection){
        if (![Utils isArrayNull:self.nearbyShopArray]) {
            NSInteger count = self.nearbyShopArray.count;
            return count > 3? 3 : count;
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
    return CGSizeMake((collectionView.frame.size.width-20)/3, 132);
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
        
        photoPage = page;
        self.ibHeaderImageCountLbl.text = [NSString stringWithFormat:@"%d/%lu", photoPage + 1, (unsigned long)self.dealModel.photos.count];
    }
}

#pragma mark - RequestServer

-(void)requestServerForDealInfo{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":[Utils getAppToken],
                                                                                  @"deal_id": self.dealModel.dID}];
    
    if (self.referralID) {
        [dict setObject:self.referralID forKey:@"referral_u_id"];
    }
    
    NSString* appendString = self.dealModel.dID;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetDealInfo parameter:dict appendString:appendString success:^(id object) {

        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dealUpdated:)]) {
            [self.delegate dealUpdated:self.dealModel];
        }
        
        [self updateViews];
        
        [self requestServerForDealRelevantDeals];
        
    } failure:^(id object) {
        [self updateViews];

    }];
}

-(void)requestServerForVoucherInfo{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: @{@"token":[Utils getAppToken],
                                                                                   @"voucher_id": self.dealModel.voucher_info.voucher_id}];
    
    if (self.referralID) {
        [dict setObject:self.referralID forKey:@"referral_u_id"];
    }
    
    NSString* appendString = self.dealModel.voucher_info.voucher_id;

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetVoucherInfo parameter:dict appendString:appendString success:^(id object) {

        DealModel *model = [[ConnectionManager dataManager] dealModel];
        self.dealModel = model;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dealUpdated:)]) {
            [self.delegate dealUpdated:self.dealModel];
        }
        [self updateViews];
        
        [self requestServerForDealRelevantDeals];
        
    } failure:^(id object) {
        [self updateViews];

    }];
}

-(void)requestServerToCollectVoucher:(SeShopDetailModel*)shopModel{
    if (self.isProcessing) {
        return;
    }
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *coreDict = @{@"deal_id":self.dealModel.dID,
                           @"shop_id":shopModel.seetishop_id,
                           @"token": [Utils getAppToken]};
    
    CLLocation *userLocation = [[SearchManager Instance] getAppLocation];
    
    NSDictionary *locationDict = @{@"lat": @(userLocation.coordinate.latitude),
                                   @"lng": @(userLocation.coordinate.longitude)};
    
    [finalDict addEntriesFromDictionary:coreDict];
    [finalDict addEntriesFromDictionary:locationDict];
    
    if (self.referralID) {
        [finalDict setObject:self.referralID forKey:@"referral_u_id"];
    }
    
    self.isProcessing = YES;
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostCollectDeals parameter:finalDict appendString:nil success:^(id object) {

        DealModel *dealModel = [[ConnectionManager dataManager] dealModel];
        self.dealModel = dealModel;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dealUpdated:)]) {
            [self.delegate dealUpdated:self.dealModel];
        }
        
        [MessageManager showMessage:LocalisedString(@"system") SubTitle:LocalisedString(@"Collected in Voucher Wallet") Type:TSMessageNotificationTypeSuccess];
        int walletCount = [self.dealManager getWalletCount];
        [self.dealManager setWalletCount:walletCount+1];
        [self updateViews];
        self.isProcessing = NO;
        
        BOOL shownFirstCollectMsg = [self.userDefaults boolForKey:@"ShownFirstCollectMessage"];
        if (!shownFirstCollectMsg) {
            [UIAlertView showWithTitle:LocalisedString(@"Great!") message:LocalisedString(@"You have collected your first voucher! Would you like to know how to redeem it?") cancelButtonTitle:LocalisedString(@"No") otherButtonTitles:@[LocalisedString(@"Yes")] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    self.howToRedeemViewController = nil;
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.howToRedeemViewController];
                    [self presentViewController:navController animated:YES completion:nil];
                }
            }];
            [self.userDefaults setBool:YES forKey:@"ShownFirstCollectMessage"];
        }
        
    } failure:^(id object) {
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
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetSeetoShopNearbyShop parameter:dict appendString:appendString success:^(id object) {

        SeShopsModel *seetieShopModel = [[ConnectionManager dataManager]seNearbyShopModel];
        [self.nearbyShopArray addObjectsFromArray:seetieShopModel.shops];
        [self updateViews];
        [LoadingManager hide];
    } failure:^(id object) {
        [self updateViews];
        [LoadingManager hide];
    }];
}

-(void)requestServerForDealRelevantDeals{
    NSString* appendString = [NSString stringWithFormat:@"%@/relevent-deals", self.dealModel.dID];
    
    NSDictionary* dict = @{@"limit":@"3",
                           @"offset":@"1",
                           @"deal_id" : self.dealModel.dID,
                           @"token" : [Utils getAppToken]
                           };
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetDealRelevantDeals parameter:dict appendString:appendString success:^(id object) {
        DealsModel *deals = [[ConnectionManager dataManager]dealsModel];
        self.dealsModel = deals;
        
        if ([Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
            if (self.dealModel.shops.count == 1) {
                [self requestServerForSeetiShopNearbyShop:self.dealModel.shops[0]];
            }
            else{
                [self updateViews];
                [LoadingManager hide];
            }
        }
        else{
            [self requestServerForSeetiShopNearbyShop:self.dealModel.voucher_info.shop_info];
        }
        
    } failure:^(id object) {
        if ([Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
            if (self.dealModel.shops.count == 1) {
                [self requestServerForSeetiShopNearbyShop:self.dealModel.shops[0]];
            }
            else{
                [self updateViews];
                [LoadingManager hide];
            }
        }
        else{
            [self requestServerForSeetiShopNearbyShop:self.dealModel.voucher_info.shop_info];
        }
    }];
}

@end

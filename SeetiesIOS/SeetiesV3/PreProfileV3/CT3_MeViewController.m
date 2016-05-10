//
//  CT3_MeViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MeViewController.h"
#import "CT3_NotificationViewController.h"
#import "CT3_ReferalViewController.h"

@interface CT3_MeViewController ()
{
    int notification_Count;
}

@property(nonatomic)CT3_NotificationViewController* ct3_notificationViewController;
@property (weak, nonatomic) IBOutlet UIScrollView *ibMainScrollView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *ibProfileName;
@property (weak, nonatomic) IBOutlet UILabel *ibViewProfileLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibCollectionTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibCollectionCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibInviteLbl;
@property (weak, nonatomic) IBOutlet UIImageView *ibInviteIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibPromoLbl;
@property (weak, nonatomic) IBOutlet UIView *ibProfileView;
@property (weak, nonatomic) IBOutlet UIView *ibWalletView;
@property (weak, nonatomic) IBOutlet UIView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UIView *ibInviteFriendsView;
@property (weak, nonatomic) IBOutlet UIView *ibPromoCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *ibWalletIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ibCollectionIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibNotificationCountLbl;
@property (weak, nonatomic) IBOutlet UIView *ibFriendsPromoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibWalletCollectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibContentHeightConstraint;

@property(nonatomic)STPopupController *popupCTController;
@property(nonatomic)DealDetailsViewController *dealDetailsViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic, strong)WalletListingViewController *walletListingViewController;
@property(nonatomic, strong)CollectionListingViewController *collectionListingViewController;
@property(nonatomic)PromoPopOutViewController *promoCodeViewController;
@property(nonatomic)VoucherListingViewController * voucherListingViewController;
@property(nonatomic)CT3_InviteFriendViewController *ct3InviteFriendViewController;
@property(nonatomic)CT3_ReferalViewController *ct3referalViewController;


@property (weak, nonatomic) IBOutlet UIView *ibHeaderView;

@property (strong, nonatomic) IBOutlet UIView *ibGuestView;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;
@property (weak, nonatomic) IBOutlet UILabel *ibGuestViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibGuestViewLoginLbl;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic) ProfileModel* profileModel;

@end

@implementation CT3_MeViewController

#pragma mark IBAction

- (IBAction)btnTestClicked:(id)sender {

    _ct3referalViewController = nil;
    [self.navigationController pushViewController:self.ct3referalViewController animated:YES];
}

- (IBAction)btnWalletListingClicked:(id)sender {
    self.walletListingViewController = nil;
    [self.navigationController pushViewController:self.walletListingViewController animated:YES];
}
- (IBAction)btnLoginClicked:(id)sender {
    
    [Utils showLogin];
}

- (IBAction)btnCollectionListingClicked:(id)sender {
    
    _collectionListingViewController = nil;
    ProfileModel* pModel = [ProfileModel new];
    pModel.uid = [Utils getUserID];
    [self.collectionListingViewController setType:ProfileViewTypeOwn ProfileModel:pModel NumberOfPage:2];
    [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
}

- (IBAction)btnProfileClicked:(id)sender {
    
    _profileViewController = nil;
    [self.navigationController pushViewController:self.profileViewController animated:YES onCompletion:^{
        [self.profileViewController initDataWithUserID:[Utils getUserID]];

    }];

}

- (IBAction)btnNotificationClicked:(id)sender {
  //  [self.navigationController pushViewController:self.notificationViewController animated:YES];
    
    _ct3_notificationViewController = nil;
    [self.navigationController pushViewController:self.ct3_notificationViewController animated:YES];
}

- (IBAction)btnInviteClicked:(id)sender {
    if ([Utils hasReferralCampaign]) {
        self.ct3referalViewController = nil;
        [self.navigationController pushViewController:self.ct3referalViewController animated:YES];
    }
    else{
        self.ct3InviteFriendViewController = nil;
        [self.navigationController pushViewController:self.ct3InviteFriendViewController animated:YES];
    }
    
}

- (IBAction)btnPromoClicked:(id)sender {
    if (![Utils isPhoneNumberVerified]) {
        [Utils showVerifyPhoneNumber:self];
        return;
    }
    
    self.promoCodeViewController = nil;
    [self.promoCodeViewController setViewType:PopOutViewTypeEnterPromo];
    
    _popupCTController = [[STPopupController alloc]initWithRootViewController:self.promoCodeViewController];
    _popupCTController.containerView.backgroundColor = [UIColor clearColor];
    [_popupCTController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [_popupCTController presentInViewController:self];
    [_popupCTController setNavigationBarHidden:YES];
   
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self requestServerForVouchersCount];
}

#pragma mark InitMethod

-(instancetype)init{
    self = [super init];
    if(self) {
        [self registerNotification];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.profileModel = [[DataManager Instance] currentUserProfileModel];
    self.ibProfileName.text = self.profileModel.username;

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

-(void)initSelfView{
    CGFloat screenHeight = [Utils getDeviceScreenSize].size.height;
    self.ibWalletCollectionHeightConstraint.constant = screenHeight/3;
    [self.view layoutIfNeeded];
    CGFloat contentHeight = self.ibFriendsPromoView.frame.origin.y + self.ibFriendsPromoView.frame.size.height;
    self.ibContentHeightConstraint.constant = contentHeight;
    
    [self.ibProfileImg setRoundedBorder];
    [self.ibWalletIcon setRoundedBorder];
    [self.ibCollectionIcon setRoundedBorder];
    [Utils setRoundBorder:self.ibNotificationCountLbl color:[UIColor clearColor] borderRadius:self.ibNotificationCountLbl.frame.size.width/2];
    
    [self.ibProfileView prefix_addLowerBorder:OUTLINE_COLOR];
    [Utils setRoundBorder:self.ibWalletView color:[UIColor clearColor] borderRadius:5.0f];
    [Utils setRoundBorder:self.ibCollectionView color:[UIColor clearColor] borderRadius:5.0f];
    
    if ([Utils hasReferralCampaign]) {
        CountriesModel *countries = [[DataManager Instance] appInfoModel].countries;
        CountryModel *currentCountry = countries.current_country;
        InviteFriendModel *inviteFriend = currentCountry.invite_friend_banner;
        [self.ibInviteIcon sd_setImageCroppedWithURL:[NSURL URLWithString:inviteFriend.image] completed:nil];
        
        self.ibInviteLbl.text = LocalisedString(inviteFriend.title);
        self.ibInviteLbl.textColor = DEVICE_COLOR;
        self.ibInviteLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    else{
        [self.ibInviteIcon setImage:[UIImage imageNamed:@"MeInviteFriendsIcon.png"]];
        
        self.ibInviteLbl.text = LocalisedString(@"Invite your buddies");
        self.ibInviteLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        self.ibInviteLbl.font = [UIFont systemFontOfSize:15.0f];
    }
    
    [self.ibInviteFriendsView prefix_addUpperBorder:OUTLINE_COLOR];
    [self.ibInviteFriendsView prefix_addLowerBorder:OUTLINE_COLOR];
    
    [self.ibPromoCodeView prefix_addUpperBorder:OUTLINE_COLOR];
    [self.ibPromoCodeView prefix_addLowerBorder:OUTLINE_COLOR];
    
    [self.view addSubview:self.ibGuestView];
    self.ibGuestView.frame = CGRectMake(0, self.ibHeaderView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.ibHeaderView.frame.size.height);
    [self.ibGuestView adjustToScreenWidth];
    
    [self.btnLogin setSideCurveBorder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self changeLanguage];
    [self initSelfView];

    [self reloadData];
    self.ibGuestView.hidden = ![Utils isGuestMode];
    
    if ([Utils isGuestMode]) {
        self.btnNotification.hidden = YES;
        self.ibNotificationCountLbl.hidden = YES;
    }
    else{
        if (![Utils isStringNull:self.profileModel.username]) {
            self.ibProfileName.text = self.profileModel.username;
            
        }
        else{
            self.ibProfileName.text = self.profileModel.name;
        }
        
        if (![Utils isStringNull:self.profileModel.profile_photo_images]) {
            [self.ibProfileImg sd_setImageCroppedWithURL:[NSURL URLWithString:self.profileModel.profile_photo_images] completed:nil];
        }
        else{
            [self.ibProfileImg setImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];
        }
        
        [self setNotificationCount:notification_Count];
        self.btnNotification.hidden = NO;
        
        [self requestServerForVouchersCount];
        [self requestServerForUserCollection];
    }
    
    self.ibWalletCountLbl.text = [LanguageManager stringForKey:@"{!number} Voucher(s)" withPlaceHolder:@{@"{!number}" : @([[DealManager Instance] getWalletCount])}];

    
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Me");
    self.ibViewProfileLbl.text = LocalisedString(@"View Profile");
    self.ibWalletTitleLbl.text = LocalisedString(@"Voucher Wallet");
    self.ibCollectionTitleLbl.text = LocalisedString(@"Collection");
    self.ibPromoLbl.text = LocalisedString(@"Enter a promo code");
    
    self.ibGuestViewTitle.text = LocalisedString(@"Join us to enjoy more exciting features!");
    self.ibGuestViewLoginLbl.text = LocalisedString(@"Log in or Sign up to get started");
    [self.btnLogin setTitle:LocalisedString(@"Get me started!") forState:UIControlStateNormal];
}

#pragma mark Declaration

-(CT3_ReferalViewController*)ct3referalViewController
{
    if (!_ct3referalViewController) {
        _ct3referalViewController = [CT3_ReferalViewController new];
    }
    
    return _ct3referalViewController;
}
-(CT3_NotificationViewController*)ct3_notificationViewController
{
    if (!_ct3_notificationViewController) {
        _ct3_notificationViewController = [CT3_NotificationViewController new];
    }
    return _ct3_notificationViewController;
}
-(ProfileViewController*)profileViewController{
    
    if (!_profileViewController) {
        _profileViewController = [ProfileViewController new];
    }
    return _profileViewController;
}

-(WalletListingViewController*)walletListingViewController{
    if (!_walletListingViewController) {
        _walletListingViewController = [WalletListingViewController new];
    }
    return _walletListingViewController;
}

-(CollectionListingViewController*)collectionListingViewController{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    return _collectionListingViewController;
}

-(PromoPopOutViewController*)promoCodeViewController{
    if (!_promoCodeViewController) {
        _promoCodeViewController = [PromoPopOutViewController new];
        _promoCodeViewController.promoPopOutDelegate = self;
    }
    return _promoCodeViewController;
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

-(CT3_InviteFriendViewController *)ct3InviteFriendViewController{
    if (!_ct3InviteFriendViewController) {
        _ct3InviteFriendViewController = [CT3_InviteFriendViewController new];
    }
    return _ct3InviteFriendViewController;
}

-(void)reloadData
{
    ProfileModel* model = [[DataManager Instance] currentUserProfileModel];
    self.profileModel = model;
}

#pragma mark - Request Server

-(void)setNotificationCount:(int)count
{
    if (count == 0) {
        self.ibNotificationCountLbl.hidden = YES;
    }
    else{
        self.ibNotificationCountLbl.hidden = NO;
        self.ibNotificationCountLbl.text = [NSString stringWithFormat:@"%d",count];
    }
}

-(void)requestServerForVouchersCount{
    NSDictionary *dict = @{@"token": [Utils getAppToken]};
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers/count", [Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserVouchersCount parameter:dict appendString:appendString success:^(id object) {

        NSDictionary *dict = object[@"data"];
        int count = (int)[dict[@"count"] integerValue];
        
        [[DealManager Instance] setWalletCount:count];
        
        self.ibWalletCountLbl.text = [LanguageManager stringForKey:@"{!number} Voucher(s)" withPlaceHolder:@{@"{!number}" : @(count)}];
    } failure:^(id object) {
        
    }];
}

-(void)requestServerForUserCollection
{
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",self.profileModel.uid];
 
    NSDictionary* dict;
    @try {
        dict = @{@"page":@(1),
                 @"list_size":@(ARRAY_LIST_SIZE),
                 @"token":[Utils getAppToken],
                 @"uid":self.profileModel.uid
                 };
    }
    @catch (NSException *exception) {
    }

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserCollections parameter:dict appendString:appendString success:^(id object) {

        NSDictionary *dict = object[@"data"];
        NSInteger collectionCount = [dict[@"total_result"] integerValue];
        self.ibCollectionCountLbl.text = [LanguageManager stringForKey:@"{!number} Collection(s)" withPlaceHolder:@{@"{!number}" : @(collectionCount)}];
        
    } failure:^(id object) {
        
    }];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationCount:)
                                                 name:@"UpdateNotification"
                                               object:nil];
    
}

- (void) updateNotificationCount:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"UpdateNotification"])
    {
        if (![Utils isGuestMode]) {
            
            @try {
                NSDictionary* dict = notification.userInfo;
                
                NSString* count = [dict objectForKey:@"NOTIFICATION_COUNT"];
                notification_Count = [count intValue];
                [self setNotificationCount:notification_Count];
            }
            @catch (NSException *exception) {
                
            }
            
        }

    }
}

@end

//
//  CT3_MeViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MeViewController.h"
#import "CT3_NotificationViewController.h"

@interface CT3_MeViewController ()

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
@property(nonatomic)NotificationViewController *notificationViewController;
@property(nonatomic)InviteFrenViewController *inviteFriendViewController;
@property(nonatomic)PromoPopOutViewController *promoCodeViewController;
@property (weak, nonatomic) IBOutlet UIView *ibHeaderView;

@property (strong, nonatomic) IBOutlet UIView *ibGuestView;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic) ProfileModel* profileModel;

@end

@implementation CT3_MeViewController

#pragma mark IBAction

- (IBAction)btnTestClicked:(id)sender {

    _ct3_notificationViewController = nil;
    [self.navigationController pushViewController:self.ct3_notificationViewController animated:YES];
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
        [self.profileViewController requestAllDataWithType:ProfileViewTypeOwn UserID:[Utils getUserID]];

    }];

}

- (IBAction)btnNotificationClicked:(id)sender {
  //  [self.navigationController pushViewController:self.notificationViewController animated:YES];
    
    _ct3_notificationViewController = nil;
    [self.navigationController pushViewController:self.ct3_notificationViewController animated:YES];
}

- (IBAction)btnInviteClicked:(id)sender {
    [self.navigationController pushViewController:self.inviteFriendViewController animated:YES];
}

- (IBAction)btnPromoClicked:(id)sender {
    if (!self.profileModel.phone_verified) {
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

-(void)viewDealDetailsClicked:(DealModel *)dealModel{
    self.dealDetailsViewController = nil;
    [self.dealDetailsViewController setDealModel:dealModel];
    [self.navigationController pushViewController:self.dealDetailsViewController animated:YES onCompletion:^{
        [self.dealDetailsViewController setupView];
    }];
}

-(void)promoHasBeenRedeemed:(DealModel *)dealModel{
    [self requestServerForVouchersCount];
}

#pragma mark InitMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    ProfileModel* model = [[ConnectionManager dataManager]userLoginProfileModel];
    self.ibProfileName.text = model.username;

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
    
    [self.ibInviteFriendsView prefix_addUpperBorder:OUTLINE_COLOR];
    [self.ibInviteFriendsView prefix_addLowerBorder:OUTLINE_COLOR];
    
    [self.ibPromoCodeView prefix_addUpperBorder:OUTLINE_COLOR];
    [self.ibPromoCodeView prefix_addLowerBorder:OUTLINE_COLOR];
    
    [self.view addSubview:self.ibGuestView];
    self.ibGuestView.frame = CGRectMake(0, self.ibHeaderView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.ibHeaderView.frame.size.height);
    [self.ibGuestView adjustToScreenWidth];
    
    [self.btnLogin setSideCurveBorder];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initSelfView];
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
        
        [self requestServerForNotificationCount];
        self.btnNotification.hidden = NO;
        self.ibNotificationCountLbl.hidden = NO;
        
        [self requestServerForVouchersCount];
        [self requestServerForUserCollection];
    }
    
  
}

#pragma mark Declaration

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

-(NotificationViewController*)notificationViewController{
    if (!_notificationViewController) {
        _notificationViewController = [NotificationViewController new];
    }
    return _notificationViewController;
}

-(InviteFrenViewController*)inviteFriendViewController{
    if (!_inviteFriendViewController) {
        _inviteFriendViewController = [InviteFrenViewController new];
    }
    return _inviteFriendViewController;
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

-(void)reloadData
{
    
    DataManager* dataManager = [ConnectionManager dataManager];
    ProfileModel* model = dataManager.userProfileModel;
    self.profileModel = model;
}

#pragma mark - Request Server
-(void)requestServerForNotificationCount
{

    NSString* token = [Utils getAppToken];
    NSDictionary* dict = @{@"token" : token};

    if (![Utils isStringNull:token]) {
        
        [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNotificationCount param:dict appendString:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = object[@"data"];
            
            @try {
                int notCount = [returnDict[@"total_new_notifications"] intValue];
                
                [self setNotificationCount:notCount];
                
            }
            @catch (NSException *exception) {
                SLog(@"server count not found");
            }
            
        } errorBlock:^(id object) {
            
        }];
    }
    
}

-(void)setNotificationCount:(int)count
{
    if (count == 0) {
        self.ibCollectionCountLbl.hidden = YES;
    }
    else{
        self.ibCollectionCountLbl.hidden = NO;
        self.ibNotificationCountLbl.text = [NSString stringWithFormat:@"%d",count];
    }
}

-(void)changeLanguage
{
    self.ibHeaderTitle.text = LocalisedString(@"Me");
}
-(void)requestServerForVouchersCount{
    NSDictionary *dict = @{@"token": [Utils getAppToken]};
    NSString *appendString = [NSString stringWithFormat:@"%@/vouchers/count", [Utils getUserID]];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetUserVouchersCount param:dict appendString:appendString completeHandler:^(id object) {
        NSDictionary *dict = object[@"data"];
        int count = (int)[dict[@"count"] integerValue];
        self.ibWalletCountLbl.text = [NSString stringWithFormat:@"%d %@", count, LocalisedString(@"vouchers")];
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserCollection
{
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",self.profileModel.uid];
    
    NSDictionary* dict = @{@"page":@(1),
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.profileModel.uid
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserCollections param:dict appendString:appendString completeHandler:^(id object) {
        NSDictionary *dict = object[@"data"];
        self.ibCollectionCountLbl.text = [NSString stringWithFormat:@"%ld %@", [dict[@"total_result"] integerValue], LocalisedString(@"collections")];
        
    } errorBlock:^(id object) {
        
    }];
}

@end

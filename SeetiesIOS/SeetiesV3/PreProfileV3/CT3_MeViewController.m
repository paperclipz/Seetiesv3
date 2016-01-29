//
//  CT3_MeViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MeViewController.h"

@interface CT3_MeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ibMainScrollView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImg;
@property (weak, nonatomic) IBOutlet UILabel *ibProfileName;
@property (weak, nonatomic) IBOutlet UILabel *ibViewProfileLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibWalletLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibCollectionLbl;
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

@property(nonatomic)STPopupController *popupCTController;
@end

@implementation CT3_MeViewController

#pragma mark IBAction
- (IBAction)btnWalletListingClicked:(id)sender {
    [self.navigationController pushViewController:self.walletListingViewController animated:YES];
}

- (IBAction)btnCollectionListingClicked:(id)sender {
    
    _collectionListingViewController = nil;
    ProfileModel* pModel = [ProfileModel new];
    pModel.uid = [Utils getUserID];
    [self.collectionListingViewController setType:ProfileViewTypeOwn ProfileModel:pModel NumberOfPage:2];
    [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
}

- (IBAction)btnProfileClicked:(id)sender {
    [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:[Utils getUserID]];
    [self.navigationController pushViewController:self.profileViewController animated:YES];
}

- (IBAction)btnNotificationClicked:(id)sender {
    [self.navigationController pushViewController:self.notificationViewController animated:YES];
}

- (IBAction)btnInviteClicked:(id)sender {
    [self.navigationController pushViewController:self.inviteFriendViewController animated:YES];
}

- (IBAction)btnPromoClicked:(id)sender {
    
    PromoPopOutViewController* promoPopoutVC = [PromoPopOutViewController new];
    [promoPopoutVC setViewType:EnterPromoViewType];
    
    _popupCTController = [[STPopupController alloc]initWithRootViewController:promoPopoutVC];
    _popupCTController.containerView.backgroundColor = [UIColor clearColor];
    [_popupCTController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [_popupCTController presentInViewController:self];
    [_popupCTController setNavigationBarHidden:YES];
   
}

-(IBAction)backgroundViewDidTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark InitMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];

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
    
    [self.ibProfileImg setRoundedBorder];
    [self.ibWalletIcon setRoundedBorder];
    [self.ibCollectionIcon setRoundedBorder];
    [Utils setRoundBorder:self.ibNotificationCountLbl color:[UIColor clearColor] borderRadius:self.ibNotificationCountLbl.frame.size.width/2];
    
    [self.ibProfileView prefix_addLowerBorder:[UIColor lightGrayColor]];
    [Utils setRoundBorder:self.ibWalletView color:[UIColor redColor] borderRadius:5.0f];
    
    [self.ibWalletView setStandardBorder];
    [self.ibCollectionView setStandardBorder];
    
    [self.ibInviteFriendsView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibInviteFriendsView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibPromoCodeView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibPromoCodeView prefix_addLowerBorder:[UIColor lightGrayColor]];
}

#pragma mark Declaration

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
    }
    return _promoCodeViewController;
}

-(void)reloadData
{
    
}
@end

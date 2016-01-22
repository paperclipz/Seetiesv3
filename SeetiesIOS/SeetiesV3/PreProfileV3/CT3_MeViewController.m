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

@end

@implementation CT3_MeViewController
- (IBAction)btnTestWalletListingClicked:(id)sender {
    [self.navigationController pushViewController:self.walletListingViewController animated:YES];
}

- (IBAction)btnTestShopListingClicked:(id)sender {
    [self.navigationController pushViewController:self.shopListingViewController animated:YES];
}

-(IBAction)btnTestSearchListingCliked:(id)sender{
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}

-(IBAction)btnTestConnectionsClicked:(id)sender{

    self.connectionsViewController.userID = [Utils getUserID];
    [self.navigationController pushViewController:self.connectionsViewController animated:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
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
    [self.ibMainScrollView addSubview:self.ibContentView];
    [self.ibContentView adjustToScreenWidth];

}

#pragma mark Declaration
-(ShopListingViewController*)shopListingViewController
{
    if (!_shopListingViewController) {
        _shopListingViewController = [ShopListingViewController new];
    }
    return _shopListingViewController;
}

-(CT3_SearchListingViewController*)ct3_SearchListingViewController
{
    if (!_ct3_SearchListingViewController) {
        _ct3_SearchListingViewController = [CT3_SearchListingViewController new];
    }
    return _ct3_SearchListingViewController;
}

-(ConnectionsViewController*)connectionsViewController
{
    if (!_connectionsViewController) {
        _connectionsViewController = [ConnectionsViewController new];
    }
    return _connectionsViewController;
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
@end

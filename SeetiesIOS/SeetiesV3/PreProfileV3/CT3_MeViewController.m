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

@end

@implementation CT3_MeViewController
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
}

- (IBAction)btnInviteClicked:(id)sender {
}

- (IBAction)btnPromoClicked:(id)sender {
}

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
    
    [self.ibMainScrollView addSubview:self.ibContentView];
    
//    self.ibContentView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.ibMainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.ibContentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.ibMainScrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.ibContentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.ibMainScrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.ibContentView attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.ibMainScrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.ibContentView attribute:NSLayoutAttributeBottom relatedBy:0 toItem:self.ibMainScrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.ibMainScrollView addConstraints:@[leading, trailing, top, bottom]];
//    [self.ibMainScrollView setContentSize:CGSizeMake(self.ibMainScrollView.frame.size.width, self.ibMainScrollView.frame.size.height)];
    
    SLog(@"scrollview width: %f", self.ibMainScrollView.frame.size.width);
    SLog(@"contentview width: %f", self.ibContentView.frame.size.width);
    
    [self.ibProfileView prefix_addLowerBorder:[UIColor lightGrayColor]];

    [self.ibWalletView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibWalletView prefix_addRightBorder:[UIColor lightGrayColor]];
    [self.ibWalletView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibCollectionView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibCollectionView prefix_addLeftBorder:[UIColor lightGrayColor]];
    [self.ibCollectionView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibInviteFriendsView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibInviteFriendsView prefix_addLowerBorder:[UIColor lightGrayColor]];
    
    [self.ibPromoCodeView prefix_addUpperBorder:[UIColor lightGrayColor]];
    [self.ibPromoCodeView prefix_addLowerBorder:[UIColor lightGrayColor]];
}

-(void)viewDidAppear:(BOOL)animated{
//    [self.view layoutIfNeeded];
//    [self initSelfView];
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
@end

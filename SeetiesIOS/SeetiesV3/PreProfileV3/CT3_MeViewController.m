//
//  CT3_MeViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_MeViewController.h"

@interface CT3_MeViewController ()

@end

@implementation CT3_MeViewController
- (IBAction)btnTestWalletListingClicked:(id)sender {
    WalletListingViewController *walletController = [WalletListingViewController new];
    [self.navigationController pushViewController:walletController animated:YES];
}
- (IBAction)btnTestShopListingClicked:(id)sender {
    [self.navigationController pushViewController:self.shopListingViewController animated:YES];
}
-(IBAction)btnTestSearchListingCliked:(id)sender{
[self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}
-(IBAction)btnTestConnectionsClicked:(id)sender{
[self.navigationController pushViewController:self.connectionsViewController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
@end

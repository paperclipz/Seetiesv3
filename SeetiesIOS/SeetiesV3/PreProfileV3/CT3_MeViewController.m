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
- (IBAction)btnTestClicked:(id)sender {
}
- (IBAction)btnTestShopListingClicked:(id)sender {
    [self.navigationController pushViewController:self.shopListingViewController animated:YES];
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
@end

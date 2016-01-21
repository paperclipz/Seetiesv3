//
//  CT3_MeViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "ShopListingViewController.h"
#import "CT3_SearchListingViewController.h"
#import "Connections/ConnectionsViewController.h"
#import "WalletListingViewController.h"
#import "ProfileViewController.h"
#import "CollectionListingViewController.h"

@interface CT3_MeViewController : BaseViewController
@property(nonatomic,strong)ShopListingViewController* shopListingViewController;
@property(nonatomic,strong)CT3_SearchListingViewController* ct3_SearchListingViewController;
@property(nonatomic,strong)ConnectionsViewController* connectionsViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic, strong)WalletListingViewController *walletListingViewController;
@property(nonatomic, strong)CollectionListingViewController *collectionListingViewController;
@end

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
@interface CT3_MeViewController : CommonViewController
@property(nonatomic,strong)ShopListingViewController* shopListingViewController;
@property(nonatomic,strong)CT3_SearchListingViewController* ct3_SearchListingViewController;
@property(nonatomic,strong)ConnectionsViewController* connectionsViewController;
@end

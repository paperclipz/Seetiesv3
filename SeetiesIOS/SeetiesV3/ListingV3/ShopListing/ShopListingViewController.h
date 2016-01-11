//
//  ShopListingViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 06/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "ShopListingTableViewController.h"
@interface ShopListingViewController : CommonViewController
@property(nonatomic,strong)ShopListingTableViewController *shopListingTableViewController;
@property(nonatomic,strong)ShopListingTableViewController *collectionListingTableViewController;
@end

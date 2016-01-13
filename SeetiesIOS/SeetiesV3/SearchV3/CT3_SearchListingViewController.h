//
//  CT3_SearchListingViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLTabViewController.h"
@interface CT3_SearchListingViewController : CommonViewController
@property(nonatomic,strong)SearchLTabViewController *shopListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *collectionListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *PostsListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *SeetizensListingTableViewController;
@end

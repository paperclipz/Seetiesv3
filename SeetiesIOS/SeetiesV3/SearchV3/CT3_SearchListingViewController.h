//
//  CT3_SearchListingViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLTabViewController.h"
#import "ProfileViewController.h"
@interface CT3_SearchListingViewController : CommonViewController
@property(nonatomic,strong)SearchLTabViewController *shopListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *collectionListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *PostsListingTableViewController;
@property(nonatomic,strong)SearchLTabViewController *SeetizensListingTableViewController;

@property(nonatomic,strong)ProfileViewController* profileViewController;

@property(nonatomic,strong)NSString* SearchText;
@property(nonatomic,strong)NSString* LocationName;

@property(nonatomic,strong)NSString* Getlat;
@property(nonatomic,strong)NSString* Getlong;

@property(nonatomic,strong)NSString* GetCurrentlat;
@property(nonatomic,strong)NSString* GetCurrentLong;

@end

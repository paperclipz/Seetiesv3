//
//  ShopListingTableViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListingTableViewController : CommonViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString* TabType;
@end

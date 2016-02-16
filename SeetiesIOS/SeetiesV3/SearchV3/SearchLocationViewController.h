//
//  SearchLocationViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 19/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLocationAreaCell.h"
#import "SearchManager.h"
#import "SearchModel.h"

typedef void (^HomeLocationRefreshBlock)(HomeLocationModel* model);
typedef void (^AreaLocationREfreshBlock)(PlaceModel* model);

@interface SearchLocationViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy)AreaLocationREfreshBlock refreshAreaLocation;

@property(nonatomic,copy)HomeLocationRefreshBlock homeLocationRefreshBlock;
@end

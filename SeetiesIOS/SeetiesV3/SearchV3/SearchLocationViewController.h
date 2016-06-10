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
#import "SearchLocationCountryCell.h"
#import "SearchLocationResultCell.h"

typedef void (^HomeLocationRefreshBlock)(HomeLocationModel* model);// include country ID inside already
typedef void (^AreaLocationREfreshBlock)(PlaceModel* model, NSString* locationName);
typedef void (^SearchLocationRefreshBlock)(RecommendationVenueModel* model, NSString* locationName);

@interface SearchLocationViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic,copy)HomeLocationRefreshBlock homeLocationRefreshBlock;

-(void)hideBackButton;
@end

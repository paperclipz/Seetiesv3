//
//  SearchViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "LPGoogleFunctions.h"
#import "SearchTableViewController.h"
#import "CAPSPageMenu.h"

typedef void(^SearchResultBlock) (Location* model);

@interface STSearchViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPGoogleFunctionsDelegate>
-(void)initWithLocation:(CLLocation*)location;

@property(nonatomic,strong)SearchTableViewController* googleSearchTableViewController;

@property(nonatomic,strong)SearchTableViewController* fourSquareSearchTableViewController;

@property(nonatomic,strong)SearchTableViewController* seetiesSearchTableViewController;

@property(nonatomic,copy)SearchResultBlock didSelectOnLocationBlock;

@property(nonatomic,copy)IDBlock btnAddNewPlaceBlock;

@property(nonatomic,assign)SearchType searchType;

@property(nonatomic,assign)PlaceViewType placeViewType;
-(void)setViewEdit;
-(void)setViewNew;

@end

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

typedef void(^IndexBlock) (NSIndexPath* indexPath,SearchType type);

@interface STSearchViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,LPGoogleFunctionsDelegate>
-(void)initWithLocation:(CLLocation*)location;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property(nonatomic,strong)SearchTableViewController* googleSearchTableViewController;

@property(nonatomic,strong)SearchTableViewController* fourSquareSearchTableViewController;

@property(nonatomic,copy)IndexBlock didSelectRowAtIndexPathBlock;

@property(nonatomic,copy)IDBlock btnAddNewPlaceBlock;

@end

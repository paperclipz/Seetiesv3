//
//  SearchQuickBrowseListingController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralFilterViewController.h"

typedef void (^HomeModelBlock)(HomeLocationModel* model);

@interface SearchQuickBrowseListingController : CommonViewController <FilterViewControllerDelegate>

@property(nonatomic, strong) HomeLocationModel *homeLocationModel;
@property(nonatomic) QuickBrowseModel *selectedQuickBrowse;
@property(nonatomic) NSArray<QuickBrowseModel> *quickBrowseModels;
@property(nonatomic,copy)HomeModelBlock didSelectHomeLocationBlock;
@property(nonatomic,strong)NSString* category_group_id;

@end

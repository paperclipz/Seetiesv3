//
//  GeneralFilterViewController.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCategoryCollectionCell.h"
#import "FilterBudgetCell.h"
#import "FilterHeaderCollectionReusableView.h"
#import "FilterAvailabilityCell.h"
#import "FiltersModel.h"

@protocol FilterViewControllerDelegate <NSObject>
-(void)applyFilterClicked:(FiltersModel*)filtersModel;

@end

@interface GeneralFilterViewController : CommonViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FilterBudgetCellDelegate, FilterAvailabilityCellDelegate>
@property id<FilterViewControllerDelegate> delegate;
-(void)initWithFilter:(FiltersModel*)filtersModel;
@end

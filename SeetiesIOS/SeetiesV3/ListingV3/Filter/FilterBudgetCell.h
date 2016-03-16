//
//  FilterBudgetCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "FilterModel.h"

@protocol FilterBudgetCellDelegate <NSObject>

-(void)sliderChangedValue:(FilterModel*)filterModel;

@end

@interface FilterBudgetCell : CommonCollectionViewCell
@property id<FilterBudgetCellDelegate> delegate;
-(void)initCellData:(FilterModel*)filterModel;

@end

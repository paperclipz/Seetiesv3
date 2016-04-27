//
//  FilterAvailabilityCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 12/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"

@protocol FilterAvailabilityCellDelegate <NSObject>

-(void)switchValueChanged:(FilterModel*)filterModel;

@end

@interface FilterAvailabilityCell : CommonCollectionViewCell
@property id<FilterAvailabilityCellDelegate> delegate;
-(void)initCellData:(FilterModel*)filterModel;
@end

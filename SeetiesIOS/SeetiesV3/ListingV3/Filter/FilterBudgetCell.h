//
//  FilterBudgetCell.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface FilterBudgetCell : CommonCollectionViewCell
-(void)configureSliderWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue stepValueContinuously:(BOOL)continuous;
-(void)setLowerValue:(NSInteger)lowerValue;
-(void)setUpperValue:(NSInteger)upperValue;

@end

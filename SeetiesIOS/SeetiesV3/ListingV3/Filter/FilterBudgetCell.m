//
//  FilterBudgetCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterBudgetCell.h"

@interface FilterBudgetCell()
@property (weak, nonatomic) IBOutlet NMRangeSlider *ibRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *ibMinLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibMaxLbl;
@property(nonatomic) FilterModel *filter;
@end

@implementation FilterBudgetCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(void)initCellData:(FilterModel*)filterModel{
    _filter = filterModel;
    FilterPriceModel *priceFilter = self.filter.filterPrice;
    
    self.ibRangeSlider.minimumValue = priceFilter.min;
    self.ibRangeSlider.maximumValue = priceFilter.max;
    self.ibRangeSlider.stepValue = priceFilter.interval;
    
    self.ibRangeSlider.lowerValue = priceFilter.min;
    self.ibMinLbl.text = [NSString stringWithFormat:@"%@ %d", priceFilter.currency, priceFilter.selectedMin];
    
    self.ibRangeSlider.upperValue = priceFilter.max;
    self.ibMaxLbl.text = [NSString stringWithFormat:@"%@ %d", priceFilter.currency, priceFilter.selectedMax];
    
    self.ibRangeSlider.stepValueContinuously = YES;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
//    CGPoint lowerCenter;
//    lowerCenter.x = (self.ibRangeSlider.lowerCenter.x + self.ibRangeSlider.frame.origin.x);
//    lowerCenter.x = (self.ibRangeSlider.lowerCenter.x + self.ibRangeSlider.frame.origin.x);
//    lowerCenter.y = (self.ibRangeSlider.center.y + 10.0f);
//    self.ibMinLbl.center = lowerCenter;
    self.ibMinLbl.text = [NSString stringWithFormat:@"%@ %d", self.filter.filterPrice.currency, (int)self.ibRangeSlider.lowerValue];
    
//    CGPoint upperCenter;
//    upperCenter.x = (self.ibRangeSlider.upperCenter.x + self.ibRangeSlider.frame.origin.x);
//    upperCenter.y = (self.ibRangeSlider.center.y + 10.0f);
//    self.ibMaxLbl.center = upperCenter;
    self.ibMaxLbl.text = [NSString stringWithFormat:@"%@ %d", self.filter.filterPrice.currency, (int)self.ibRangeSlider.upperValue];
    
}

- (IBAction)sliderValueChanged:(NMRangeSlider*)sender {
    self.filter.filterPrice.selectedMin = sender.lowerValue;
    self.filter.filterPrice.selectedMax = sender.upperValue;
    [self updateSliderLabels];
    if(self.delegate){
        [self.delegate sliderChangedValue:self.filter];
    }
}

@end

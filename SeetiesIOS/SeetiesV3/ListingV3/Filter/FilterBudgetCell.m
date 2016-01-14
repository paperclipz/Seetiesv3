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

@end

@implementation FilterBudgetCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)configureSliderWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue stepValue:(NSInteger)stepValue stepValueContinuously:(BOOL)continuous{
    self.ibRangeSlider.minimumValue = minValue;
    self.ibRangeSlider.maximumValue = maxValue;
    self.ibRangeSlider.stepValue = stepValue;
    [self setLowerValue:minValue];
    [self setUpperValue:maxValue];
    self.ibRangeSlider.stepValueContinuously = continuous;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
//    CGPoint lowerCenter;
//    lowerCenter.x = (self.ibRangeSlider.lowerCenter.x + self.ibRangeSlider.frame.origin.x);
//    lowerCenter.x = (self.ibRangeSlider.lowerCenter.x + self.ibRangeSlider.frame.origin.x);
//    lowerCenter.y = (self.ibRangeSlider.center.y + 10.0f);
//    self.ibMinLbl.center = lowerCenter;
    self.ibMinLbl.text = [NSString stringWithFormat:@"%d", (int)self.ibRangeSlider.lowerValue];
    
//    CGPoint upperCenter;
//    upperCenter.x = (self.ibRangeSlider.upperCenter.x + self.ibRangeSlider.frame.origin.x);
//    upperCenter.y = (self.ibRangeSlider.center.y + 10.0f);
//    self.ibMaxLbl.center = upperCenter;
    self.ibMaxLbl.text = [NSString stringWithFormat:@"%d", (int)self.ibRangeSlider.upperValue];
}

- (IBAction)sliderValueChanged:(NMRangeSlider*)sender {
    [self updateSliderLabels];
}

-(void)setLowerValue:(NSInteger)lowerValue{
    self.ibRangeSlider.lowerValue = lowerValue;
    self.ibMinLbl.text = [NSString stringWithFormat:@"%d", (int)self.ibRangeSlider.lowerValue];
}

-(void)setUpperValue:(NSInteger)upperValue{
    self.ibRangeSlider.upperValue = upperValue;
    self.ibMaxLbl.text = [NSString stringWithFormat:@"%d", (int)self.ibRangeSlider.upperValue];
}

@end

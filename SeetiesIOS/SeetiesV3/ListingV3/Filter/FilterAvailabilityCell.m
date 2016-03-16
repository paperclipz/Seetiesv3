//
//  FilterAvailabilityCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 12/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterAvailabilityCell.h"

@interface FilterAvailabilityCell()
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLbl;
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;
@property(nonatomic) FilterModel *filter;
@end

@implementation FilterAvailabilityCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initCellData:(FilterModel*)filterModel{
    _filter = filterModel;
    
    [self.ibSwitch setOn:self.filter.isSelected animated:YES];
    [self.ibSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchChanged:(UISwitch*)swt{
    self.filter.isSelected = swt.isOn;
    if (self.delegate) {
        [self.delegate switchValueChanged:self.filter];
    }
}

@end

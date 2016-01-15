//
//  FilterCategoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterCategoryCollectionCell.h"
@interface FilterCategoryCollectionCell()
@property (weak, nonatomic) IBOutlet UIButton *ibCategoryBtn;

@end

@implementation FilterCategoryCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setButtonText:(NSString *)text{
    [self.ibCategoryBtn setTitle:text forState:UIControlStateNormal];
}
@end

//
//  FilterHeaderCollectionReusableView.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 12/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterHeaderCollectionReusableView.h"

@interface FilterHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibCheckbox;
@property(nonatomic) FilterCategoryModel *filterCategory;
@end

@implementation FilterHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}

-(void)initHeaderData:(FilterCategoryModel*)filterCategory{
    _filterCategory = filterCategory;
    
    self.ibHeaderLbl.text = self.filterCategory.categoryName;
}

@end

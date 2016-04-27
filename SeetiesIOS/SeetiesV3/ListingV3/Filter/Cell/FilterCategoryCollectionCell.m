//
//  FilterCategoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FilterCategoryCollectionCell.h"
@interface FilterCategoryCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *ibCell;
@property (weak, nonatomic) IBOutlet UILabel *ibCellTitle;
@property(nonatomic) FilterModel *filter;
@end

@implementation FilterCategoryCollectionCell

- (void)awakeFromNib {
    // Initialization code
    [Utils setRoundBorder:self.ibCell color:OUTLINE_COLOR borderRadius:self.ibCell.frame.size.height/2];
    [self.ibCell setBackgroundColor:[UIColor whiteColor]];
    self.ibCellTitle.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
}

-(void)initCellData:(FilterModel*)filterModel{
    _filter = filterModel;
    
    self.ibCellTitle.text = self.filter.name;
    if (self.filter.isSelected) {
        [Utils setRoundBorder:self.ibCell color:[UIColor clearColor] borderRadius:self.ibCell.frame.size.height/2];
        [self.ibCell setBackgroundColor:DEVICE_COLOR];
        self.ibCellTitle.textColor = [UIColor whiteColor];
        [self.ibCellTitle setFont:[UIFont boldSystemFontOfSize:15.0f]];
    }
    else{
        [Utils setRoundBorder:self.ibCell color:OUTLINE_COLOR borderRadius:self.ibCell.frame.size.height/2];
        [self.ibCell setBackgroundColor:[UIColor whiteColor]];
        self.ibCellTitle.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
        [self.ibCellTitle setFont:[UIFont systemFontOfSize:15.0f]];
    }
}

@end

//
//  PostFilterSortCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 14/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PostFilterSortCell.h"

@interface PostFilterSortCell()
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibCheckImg;
@property (nonatomic) FilterModel *filterModel;
@end

@implementation PostFilterSortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = nil;
    // Configure the view for the selected state
}

-(void)initFilter:(FilterModel*)filterModel{
    _filterModel = filterModel;
    
    self.ibTitle.text = filterModel.name;
    self.ibCheckImg.hidden = !filterModel.isSelected;
    
}

@end

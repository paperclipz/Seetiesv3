//
//  PostFilterCategoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 14/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PostFilterCategoryCell.h"

@interface PostFilterCategoryCell()
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibCategoryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ibCheckIcon;

@property (nonatomic) FilterModel *filterModel;
@end

@implementation PostFilterCategoryCell

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
    
    self.ibTitle.text = self.filterModel.name;
    self.ibCheckIcon.hidden = !self.filterModel.isSelected;
    self.ibCategoryIcon.backgroundColor = [UIColor colorWithHexValue:self.filterModel.bgColorHexValue];
    
    if (![Utils isStringNull:self.filterModel.imageUrl]) {
        [self.ibCategoryIcon sd_setImageCroppedWithURL:[NSURL URLWithString:self.filterModel.imageUrl] completed:^(UIImage *image) {
        }];
    }
    [Utils setRoundBorder:self.ibCategoryIcon color:[UIColor clearColor] borderRadius:self.ibCategoryIcon.frame.size.height/2];
    
}

@end

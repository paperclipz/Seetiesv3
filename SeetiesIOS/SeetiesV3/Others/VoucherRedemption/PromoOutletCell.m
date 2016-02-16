//
//  PromoOutletCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 28/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PromoOutletCell.h"

@interface PromoOutletCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibOutletImg;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibOutletAddress;
@property (weak, nonatomic) IBOutlet UIImageView *ibIsSelectedImg;
@property (weak, nonatomic) IBOutlet UIImageView *ibArrowImg;

@property(nonatomic, assign) PromoOutletCellType cellType;

@end

@implementation PromoOutletCell

- (void)awakeFromNib {
    // Initialization code
    if (self.cellType == SelectionOutletCellType) {
        _ibArrowImg.hidden = YES;
    }
    else{
        _ibArrowImg.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.ibIsSelectedImg.hidden = !selected;
}

-(void)setOutletImage:(UIImage*)image{
    [_ibOutletImg setImage:image];
}

-(void)setOutletTitle:(NSString*)title{
    _ibOutletTitle.text = title;
}

-(void)setOutletAddress:(NSString*)address{
    _ibOutletAddress.text = address;
}

-(void)setOutletIsChecked:(BOOL)isChecked{
    _ibIsSelectedImg.hidden = !isChecked;
}

-(void)setOutletCellType:(PromoOutletCellType)cellType{
    _cellType = cellType;
}

@end

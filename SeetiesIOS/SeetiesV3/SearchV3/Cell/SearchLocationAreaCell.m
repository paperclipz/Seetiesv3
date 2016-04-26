//
//  SearchLocationAreaCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 20/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLocationAreaCell.h"

@interface SearchLocationAreaCell()
@property (weak, nonatomic) IBOutlet UILabel *ibAreaTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibDealsIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibDealsIconWidthConstraint;

@property(nonatomic) PlaceModel *place;

@end

@implementation SearchLocationAreaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)initCellWithPlace:(PlaceModel *)placeModel{
    _place = placeModel;
    
    self.ibAreaTitle.text = self.place.name;
    self.ibDealsIcon.hidden = !self.place.has_featured_deals;
    self.ibDealsIconWidthConstraint.constant = self.place.has_featured_deals? 25 : 0;
}

@end

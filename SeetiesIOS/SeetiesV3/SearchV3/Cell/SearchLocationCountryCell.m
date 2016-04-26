//
//  SearchLocationCountryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 21/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLocationCountryCell.h"

@interface SearchLocationCountryCell()
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibFeaturedDealIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibCountryLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibDealIconWidthConstraint;

@property(nonatomic) CountryModel *country;

@end

@implementation SearchLocationCountryCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
    myBackView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = myBackView;
    self.ibCountryLbl.highlightedTextColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)initCellWithData:(CountryModel*)countryModel{
    _country = countryModel;
    
    self.ibCountryLbl.text = self.country.name;
    self.ibFeaturedDealIcon.hidden = !self.country.has_featured_deals;
    self.ibDealIconWidthConstraint.constant = self.country.has_featured_deals? 25 : 0;
}

@end

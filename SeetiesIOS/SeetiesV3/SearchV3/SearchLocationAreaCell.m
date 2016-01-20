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

@end

@implementation SearchLocationAreaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setAreaTitle:(NSString*)title{
    self.ibAreaTitle.text = title;
}

-(void)setHasDeals:(BOOL)hasDeals{
    self.ibDealsIcon.hidden = !hasDeals;
}

@end

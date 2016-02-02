//
//  SeDealsFeaturedTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/28/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeDealsFeaturedTblCell.h"
@interface SeDealsFeaturedTblCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblFeatured;
@end
@implementation SeDealsFeaturedTblCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    [self.lblFeatured setSideCurveBorder];
    [self.ibImageView setStandardBorder];
}
@end

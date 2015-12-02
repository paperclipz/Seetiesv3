//
//  SeDealsTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/2/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeDealsTableViewCell.h"

@implementation SeDealsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    [self.ibImageView setStandardBorder];
    [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:@"http://i0.wp.com/teaser-trailer.com/wp-content/uploads/Star-Wars-7-New-Banner.jpg"] completed:nil];
}

+(float)getHeight
{

    return 100.0f;
}
@end

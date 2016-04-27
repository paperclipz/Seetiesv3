//
//  FeaturedTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeaturedTableViewCell.h"
@interface FeaturedTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@end
@implementation FeaturedTableViewCell

- (void)awakeFromNib {
    // Initialization code

    [Utils setRoundBorder:self.lblValue color:[UIColor clearColor] borderRadius:self.lblValue.frame.size.height/2];
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    self.selectedBackgroundView = nil;
}

-(void)initData:(DealModel*)model
{
    self.lblDesc.text = model.title;
    self.lblValue.text = LocalisedString(@"FEATURED");
    self.lblValue.hidden = !model.is_feature;
    
    if (model.is_feature) {
        [self.lblDesc setFont:[UIFont fontWithName:CustomFontNameBold size:14]];
    }
    else
    {
        [self.lblDesc setFont:[UIFont fontWithName:CustomFontName size:14]];

    }
}

@end

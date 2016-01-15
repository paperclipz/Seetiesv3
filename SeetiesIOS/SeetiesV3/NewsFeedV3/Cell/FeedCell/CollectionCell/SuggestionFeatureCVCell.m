//
//  SuggestionFeatureCVCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SuggestionFeatureCVCell.h"
@interface SuggestionFeatureCVCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)ProfileModel* profileModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@end

@implementation SuggestionFeatureCVCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)initData:(ProfileModel*)model
{
    self.profileModel = model;
    self.lblTitle.text = self.profileModel.name;
    [self.ibProfilePhoto sd_setImageWithURL:[NSURL URLWithString:self.profileModel.profile_photo_images]];
    
    
    
    
}
@end

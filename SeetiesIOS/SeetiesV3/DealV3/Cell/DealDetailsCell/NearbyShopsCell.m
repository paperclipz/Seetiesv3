//
//  NearbyShopsCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 01/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NearbyShopsCell.h"

@interface NearbyShopsCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibShopImage;
@property (weak, nonatomic) IBOutlet UILabel *ibShopName;

@property(nonatomic) SeShopDetailModel *shopModel;

@end

@implementation NearbyShopsCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setShopModel:(SeShopDetailModel *)shopModel{
    _shopModel = shopModel;
    
    if (![Utils isStringNull:self.shopModel.profile_photo[@"picture"]]) {
        [self.ibShopImage sd_setImageCroppedWithURL:[NSURL URLWithString:self.shopModel.profile_photo[@"picture"]] completed:nil];
    }
    else{
        [self.ibShopImage setImage:[UIImage imageNamed:@"SsDefaultDisplayPhoto.png"]];
    }
    
    [Utils setRoundBorder:self.ibShopImage color:OUTLINE_COLOR borderRadius:self.ibShopImage.frame.size.width/2];
    self.ibShopName.text = self.shopModel.name;
}

@end

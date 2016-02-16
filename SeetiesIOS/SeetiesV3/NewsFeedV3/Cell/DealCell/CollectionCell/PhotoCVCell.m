//
//  PhotoCVCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PhotoCVCell.h"

@interface PhotoCVCell()

@property(nonatomic)DealModel* dealModel;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblViewAll;
@end
@implementation PhotoCVCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initSelfView
{
    self.lblViewAll.textColor = [UIColor whiteColor];
    [self.lblViewAll setSideCurveBorder];

}

-(void)initData:(DealModel*)model
{
    self.dealModel = model;
    
    PhotoModel* pModel = self.dealModel.cover_photo;
    if (pModel.image) {
        self.ibImageView.image = pModel.image;
    }
    else{
        
        [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:^(UIImage *image) {
            
            pModel.image = image;
        }];
    }
    
    self.lblDescription.text = self.dealModel.title;
    self.lblName.text = self.dealModel.seetishop_name;
    
}
@end

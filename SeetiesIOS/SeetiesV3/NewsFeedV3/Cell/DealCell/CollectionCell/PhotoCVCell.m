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
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibCoverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgCoverTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblViewAllTwo;
@end
@implementation PhotoCVCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initSelfView
{
    self.lblViewAll.textColor = [UIColor whiteColor];
    [self.lblViewAll setSideCurveBorder];
    [self.lblTitle setFont:[UIFont fontWithName:@"olivier" size:25.0f]];
    [self.lblViewAllTwo setSideCurveBorder];

    

}

-(void)initData:(DealModel*)model
{
    
    self.ibCoverPhotoView.hidden = YES;

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
    
    self.lblDescription.text = self.dealModel.cover_title;
    self.lblName.text = self.dealModel.shop.name;
    
}

-(void)initCoverTitle:(NSString*)title CoverImage:(NSString*)coverImage
{
    
    @try {
        [self.ibCoverPhoto sd_setImageWithURL:[NSURL URLWithString:coverImage]];
        [self.ibImgCoverTitle sd_setImageWithURL:[NSURL URLWithString:title]];
    }
    @catch (NSException *exception) {
        
    }
   
    
    self.ibCoverPhotoView.hidden = NO;
}

@end

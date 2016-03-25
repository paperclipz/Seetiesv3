//
//  SelectCategoryCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SelectCategoryCollectionViewCell.h"
#import "UIColor+Extension.h"

@interface SelectCategoryCollectionViewCell()
@property(nonatomic)CategoryModel* categoryModel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ibBackgroundImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lblImgLogoView;
@end

@implementation SelectCategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [Utils setRoundBorder:self.ibBackgroundImgView color:[UIColor clearColor] borderRadius:5.0];
}

-(void)setCustomSelected:(BOOL)selected
{
    
    self.categoryModel.isSelected = selected;
    if (selected) {
        self.ibBackgroundImgView.backgroundColor = [UIColor colorWithHexValue:self.categoryModel.background_color];
        
        if (self.categoryModel.selectedImage) {
            self.lblImgLogoView.image = self.categoryModel.selectedImage;
        }
        else{
            [self.lblImgLogoView sd_setImageWithURL:[NSURL URLWithString:self.categoryModel.selectedImageUrl]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.categoryModel.selectedImage = image;
            }];
        }
    }
    else{
        self.ibBackgroundImgView.backgroundColor = OUTLINE_COLOR;

        if (self.categoryModel.defaultImage) {
            self.lblImgLogoView.image = self.categoryModel.defaultImage;
        }
        else{
            [self.lblImgLogoView sd_setImageWithURL:[NSURL URLWithString:self.categoryModel.defaultImageUrl]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.categoryModel.defaultImage = image;
            }];
        }

    }
}

-(void)initData:(CategoryModel*)model
{
    [self refreshConstraint];
    self.categoryModel = model;
    [self setCustomSelected:self.categoryModel.isSelected];
    
    NSString* defaultLangCode = [Utils getDeviceDefaultLanguageCode];
    SLog(@"aaa: %@",model.single_line[defaultLangCode]);
    self.lblTitle.text = model.single_line[defaultLangCode];

}

@end

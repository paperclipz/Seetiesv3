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
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrIBImages;
@end

@implementation SuggestionFeatureCVCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.ibProfilePhoto setRoundedBorder];
}


-(void)initData:(ProfileModel*)model
{
    self.profileModel = model;
    self.lblTitle.text = self.profileModel.name;
    
    if (![Utils isStringNull:self.profileModel.profile_photo_images]) {
        [self.ibProfilePhoto sd_setImageWithURL:[NSURL URLWithString:self.profileModel.profile_photo_images]];

    }
    else{
        //self.ibProfilePhoto.image = [UIImage imageNamed:@"NoImage.png"];
    }
    
    self.lblDescription.text = LocalisedString(@"Follow this Seetizen for more");
 
    for (int  i = 0; i<self.arrIBImages.count; i++) {
        
         UIImageView* imgView = self.arrIBImages[i];

        [Utils setRoundBorder:imgView color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];

        if (self.profileModel.posts.count>i) {
            
            DraftModel*dModel = self.profileModel.posts[i];
            


            
            if (![Utils isArrayNull:dModel.arrPhotos]) {
                
                PhotoModel* pModel = dModel.arrPhotos[0];
                UIImageView* imgView = self.arrIBImages[i];
                [imgView setStandardBorder];
              //  [imgView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
                [imgView sd_setImageWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
            }
          
        }
        else
        {
            
           // UIImageView* imgView = self.arrIBImages[i];
            
           // imgView.image = [UIImage imageNamed:@"NoImage.png"];
        }
        
    }
    
 }


@end

//
//  AbroadQualityPostCVCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AbroadQualityPostCVCell.h"
@interface AbroadQualityPostCVCell()
@property(nonatomic,strong)DraftModel* postModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@end

@implementation AbroadQualityPostCVCell

- (IBAction)btnProfileClicked:(id)sender {
    if (self.btnProfileClickedBlock) {
        self.btnProfileClickedBlock(self.postModel.user_info);
    }
}

-(void)initData:(DraftModel*)model
{
    self.postModel = model;
    
    if (![Utils isArrayNull:model.arrPhotos]) {
        PhotoModel* pModel = model.arrPhotos[0];
        [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
        
    }

    self.lblName.text = model.user_info.username;
    
    
    if (model.location.distance <= 0) {
        self.lblDistance.text = @"";
        
    }
    else{
        
        self.lblDistance.text = [Utils getDistance:model.location.distance Locality:model.location.locality];

    }
    
    self.lblTitle.text = model.place_name;
    self.lblLocation.text = [NSString stringWithFormat:@"%@ • %@",model.location.locality,model.location.country];
    
    NSString* contentLanguage = self.postModel.content_languages[0];
    NSString* postDesc;
    
    if (![Utils isStringNull:contentLanguage]) {
        postDesc = self.postModel.contents[contentLanguage][@"title"];
    }

    [self.lblDescription setStandardText:postDesc];

    [self.ibProfileImage sd_setImageWithURL:[NSURL URLWithString:self.postModel.user_info.profile_photo_images]];
}

-(void)initSelfView
{
    [self.ibProfileImage setRoundedBorder];
}


@end

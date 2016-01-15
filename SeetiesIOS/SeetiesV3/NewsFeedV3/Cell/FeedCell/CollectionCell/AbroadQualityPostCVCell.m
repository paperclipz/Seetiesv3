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

- (void)awakeFromNib {
    // Initialization code
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
        self.lblDistance.text = @(model.location.distance).stringValue;

    }
    
    self.lblTitle.text = model.place_name;
    self.lblLocation.text = [NSString stringWithFormat:@"%@ • %@",model.location.locality,model.location.country];
    self.lblDescription.text = model.postDescription;

}



@end

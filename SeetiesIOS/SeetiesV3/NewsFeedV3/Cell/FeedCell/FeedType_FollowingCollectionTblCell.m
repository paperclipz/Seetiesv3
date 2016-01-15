//
//  FeedType_FollowingCollectionTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_FollowingCollectionTblCell.h"

@interface FeedType_FollowingCollectionTblCell()
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImgHeight;
@property (weak, nonatomic) IBOutlet UIView *ibImgContentView;
@property (weak, nonatomic) IBOutlet UIView *ibBorderView;
@property(nonatomic,strong)CollectionModel* collectionModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageThree;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageFour;
@end
@implementation FeedType_FollowingCollectionTblCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initData:(CollectionModel*)model
{
    self.collectionModel = model;
    
    int numberOfPhoto = (int)self.collectionModel.arrayFollowingCollectionPost.count;

    DraftModel* draftModel = self.collectionModel.arrayFollowingCollectionPost[0];
    [Utils setRoundBorder:self.btnShare color:OUTLINE_COLOR borderRadius:self.btnShare.frame.size.height/2];
    

    switch (numberOfPhoto) {
        case 1:
            self.constImgWidth.constant = 0;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/1);
            [self.ibImageOne sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[0]] completed:nil];

            break;
            
        case 2:
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/1);
            [self.ibImageOne sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[0]] completed:nil];
            [self.ibImageTwo sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[1]] completed:nil];

            break;
        case 3:
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/2);
            [self.ibImageOne sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[0]] completed:nil];
            [self.ibImageTwo sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[1]] completed:nil];
            [self.ibImageThree sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[2]] completed:nil];
            

            break;
            
        case 4:
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/3);
            [self.ibImageOne sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[0]] completed:nil];
            [self.ibImageTwo sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[1]] completed:nil];
            [self.ibImageThree sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[2]] completed:nil];
            [self.ibImageFour sd_setImageCroppedWithURL:[NSURL URLWithString:draftModel.arrPhotos[3]] completed:nil];

            break;
            
            
        default:
            break;
    }

}

-(void)initSelfView
{
    
   
   
    [Utils setRoundBorder:self.self.ibImgContentView color:OUTLINE_COLOR borderRadius:5.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

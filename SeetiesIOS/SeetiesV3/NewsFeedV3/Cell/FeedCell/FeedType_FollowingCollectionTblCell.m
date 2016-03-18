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
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectionName;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfRecommendations;
@end
@implementation FeedType_FollowingCollectionTblCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)btnShareClicked:(id)sender {
    
    if (self.btnShareCollectionClickedBlock) {
        self.btnShareCollectionClickedBlock();
    }
    
}

-(void)initData:(CollectionModel*)model
{
    self.collectionModel = model;
    
    int numberOfPhoto = (int)self.collectionModel.arrayFollowingCollectionPost.count;

    [Utils setRoundBorder:self.btnShare color:OUTLINE_COLOR borderRadius:self.btnShare.frame.size.height/2];
    

    self.lblTitle.text = [NSString stringWithFormat:@"%@ %@ %d %@ %@ %@",self.collectionModel.user_info.username,LocalisedString(@"collected"),self.collectionModel.new_collection_posts_count,LocalisedString(@"post"), LocalisedString(@"in"),self.collectionModel.name];
    
    self.lblCollectionName.text = self.collectionModel.name;
    self.lblNoOfRecommendations.text = [NSString stringWithFormat:@"%d %@",self.collectionModel.collection_posts_count,LocalisedString(@"Recommendations")];
    
    switch (numberOfPhoto) {
        case 4:
        {
            DraftModel* draftModelFour = self.collectionModel.arrayFollowingCollectionPost[3];
            PhotoModel* pModel = draftModelFour.arrPhotos[0];
            [self.ibImageFour sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];


        }
        case 3:
        {
            DraftModel* draftModelThree = self.collectionModel.arrayFollowingCollectionPost[2];
            PhotoModel* pModel = draftModelThree.arrPhotos[0];
            [self.ibImageThree sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
            
        }
            
        case 2:
        {
            DraftModel* draftModelTwo = self.collectionModel.arrayFollowingCollectionPost[1];
            PhotoModel* pModel = draftModelTwo.arrPhotos[0];
            [self.ibImageTwo sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
            
            
        }
            
        case 1:
        {
            DraftModel* draftModelOne = self.collectionModel.arrayFollowingCollectionPost[0];
            PhotoModel* pModel = draftModelOne.arrPhotos[0];
            [self.ibImageOne sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
            
            
        }
            break;
            
        default:
            break;
    }
    switch (numberOfPhoto) {
        case 1:
        {
            self.constImgWidth.constant = 0;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/1);
            
        }
            break;
            
        case 2:
        {
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/1);
            
          
        }
            break;
        case 3:
        {
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/2);
           
        }

            break;
            
        case 4:
        {
            self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
            self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/3);
        }
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

//
//  ProfilePageCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionTableViewCell.h"
@interface ProfilePageCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@end
@implementation ProfilePageCollectionTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnEditClicked:(id)sender {
    
    if (_btnEditClickedBlock) {
        self.btnEditClickedBlock();
    }
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibInnerContentView color:TWO_ZERO_FOUR_COLOR borderRadius:5.0f];
    [Utils setRoundBorder:self.btnEdit color:TWO_ZERO_FOUR_COLOR borderRadius:self.btnEdit.frame.size.height/2];
}

+(int)getHeight
{
    return 167.0f;
}

-(void)initData:(CollectionModel*)model
{

    self.model = model;
    if (![self.model.arrayPost isNull])
    {
        DraftModel* draftModel = self.model.arrayPost[0];
    
        if (![draftModel.arrPhotos isNull]) {
            
            
            if ([draftModel.arrPhotos count] ==1) {
                PhotoModel* photoModel1 = draftModel.arrPhotos[0];

                [self.ibImageViewA sd_setImageWithURL:[NSURL URLWithString:photoModel1.imageURL]];

            }
            
            if ([draftModel.arrPhotos count] ==2) {
                
                PhotoModel* photoModel2 = draftModel.arrPhotos[1];

                [self.ibImageViewB sd_setImageWithURL:[NSURL URLWithString:photoModel2.imageURL]];
                
            }
            
        }
    }
    
//
//    if (self.model.arrTempFeedsPost>0) {
//        
//        DraftModel* postModel = self.model.arrTempFeedsPost[0];
//        
//        if (postModel.arrPhotos.count>0) {
//            
//        }
//    }
    
}
@end

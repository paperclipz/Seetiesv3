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

@end
@implementation ProfilePageCollectionTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(int)getHeight
{
    return 222.0f;
}

-(void)initData:(CollectionModel*)model
{
//    self.model = model;
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

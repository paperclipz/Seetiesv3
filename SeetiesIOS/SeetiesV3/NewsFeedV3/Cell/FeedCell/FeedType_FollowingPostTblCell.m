//
//  FeedType_FollowingPostTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_FollowingPostTblCell.h"

@interface FeedType_FollowingPostTblCell()
@property (nonatomic,strong)CTFeedModel* newsFeedModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibPostImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImageHeight;
@end
@implementation FeedType_FollowingPostTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initData:(CTFeedModel*)model
{
    
    self.newsFeedModel = model;
    PhotoModel* pModel = self.newsFeedModel.photos[0];
    [self.ibPostImageView sd_setImageWithURL:[NSURL URLWithString:pModel.imageURL]];
    //self.constImageHeight.constant = [self getImageHeight:self.ibPostImageView givenWidth:self.newsFeedModel.photos.imageWidth givenHeight:self.newsFeedModel.photos.imageHeight];
}

@end

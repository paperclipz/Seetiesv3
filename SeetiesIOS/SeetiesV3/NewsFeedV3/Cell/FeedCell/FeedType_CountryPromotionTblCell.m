//
//  FeedType_CountryPromotionTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_CountryPromotionTblCell.h"
@interface FeedType_CountryPromotionTblCell()

@property (nonatomic,strong)DraftModel* newsFeedModel;
@property (nonatomic,strong)AnnouncementModel* announcementModel;

@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end
@implementation FeedType_CountryPromotionTblCell

-(void)initDataForHome:(AnnouncementModel*)model
{
    self.announcementModel = model;
    [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.announcementModel.photo] completed:nil];

}

-(void)initData:(CTFeedTypeModel*)model
{

    self.newsFeedModel = model.newsFeedData;
    [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.newsFeedModel.image] completed:nil];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  FeedType_AnnouncementWelcomeTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_AnnouncementWelcomeTblCell.h"

@interface FeedType_AnnouncementWelcomeTblCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end
@implementation FeedType_AnnouncementWelcomeTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initData:(CTFeedTypeModel*)model
{
    
    if(model.tempType == FeedType_Announcement_Campaign)
    {
     self.lblTitle.text = @"";
    }
    else{
     self.lblTitle.text = @"adasdjadasdjasdoiajdiaosdjsaiodjsaiodjadasdjasdoiajdiaosdjsaiodjsaiodjadasdjasdoiajdiaosdjsaiodjsaiodjadasdjasdoiajdiaosdjsaiodjsaiodjadasdjasdoiajdiaosdjsaiodjsaiodjasdoiajdiaosdjsaiodjsaiodj";
    }
   
}
@end

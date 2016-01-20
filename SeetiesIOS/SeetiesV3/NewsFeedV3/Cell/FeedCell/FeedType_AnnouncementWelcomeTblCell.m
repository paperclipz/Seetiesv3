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
@property (strong, nonatomic)AnnouncementModel* annModel;

@end
@implementation FeedType_AnnouncementWelcomeTblCell

-(void)initData:(CTFeedTypeModel*)model
{
    self.annModel = model.announcementData;
    self.lblTitle.text = self.annModel.title[[Utils getDeviceAppLanguageCode]];
//    if(model.feedType == FeedType_Announcement_Campaign)
//    {
//        self.lblTitle.text = self.annModel.title[[Utils getDeviceAppLanguageCode]];
//    }
//    else{
//     self.lblTitle.text = @"";
//    }
//    
    [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.annModel.photo] withPlaceHolder:[Utils getPlaceHolderImage] completed:nil];
}
@end

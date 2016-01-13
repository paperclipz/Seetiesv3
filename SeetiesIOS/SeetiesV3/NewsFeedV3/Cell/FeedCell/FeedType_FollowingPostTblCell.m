//
//  FeedType_FollowingPostTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_FollowingPostTblCell.h"

@interface FeedType_FollowingPostTblCell()
@property (nonatomic,strong)CTFeedTypeModel* newsFeedTypeModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibPostImageView;
@property (weak, nonatomic) IBOutlet UIView *ibSuggestedView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImageView;

/*constraint*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSuggestViewHeight;

@property (weak, nonatomic) IBOutlet UIView *ibBorderView;

/*Xib outlet*/
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
@implementation FeedType_FollowingPostTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    [Utils setRoundBorder:self.ibBorderView color:[UIColor grayColor] borderRadius:5.0f borderWidth:1.0f];
    [Utils setRoundBorder:self.ibProfileImageView color:[UIColor grayColor] borderRadius:self.ibProfileImageView.frame.size.width/2 borderWidth:1.0f];

}
/*Only Control Promotion uses images, other use photos*/
-(void)initData:(CTFeedTypeModel*)model
{

//    [self.ibPostImageView setStandardBorder];
    self.newsFeedTypeModel = model;
    CTFeedModel* feedModel = self.newsFeedTypeModel.data;
    if (self.newsFeedTypeModel.feedType == FeedType_Country_Promotion) {
        [self.ibPostImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.newsFeedTypeModel.data.image] completed:nil];

    }
    
    else{
        
        if (![Utils isArrayNull:feedModel.photos]) {
            PhotoModel* pModel = self.newsFeedTypeModel.data.photos[0];
            [self.ibPostImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];

        }

    }
    
    if (self.newsFeedTypeModel.tempType == FeedType_Local_Quality_Post) {
        self.constSuggestViewHeight.constant = 44;

    }
    else{
        self.constSuggestViewHeight.constant = 0;
    }
    
    self.lblUsername.text = feedModel.user_info.username;
    self.lblDistance.text = @(feedModel.location.distance).stringValue;
    self.lblTitle.text = feedModel.place_name;
    self.lblLocation.text = feedModel.location.name;
    self.lblDescription.text = feedModel.postDescription;

    [self.ibProfileImageView sd_setImageWithURL:[NSURL URLWithString:feedModel.user_info.profile_photo_images]];
    

}


-(float)getImageHeight:(UIImageView*)imageView givenWidth:(float)width givenHeight:(float)height
{
    
    
    float calcHeight = 0;
    
    calcHeight = imageView.frame.size.width/width * height;
    
    return calcHeight;
}
@end

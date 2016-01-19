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
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

/*constraint*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSuggestViewHeight;

/*Xib outlet*/
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnQuickCollect;

@property (weak, nonatomic) IBOutlet UIImageView *ibCollectionImage;
@end
@implementation FeedType_FollowingPostTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnProfileClicked:(id)sender {
    if (self.btnProfileClickedBlock) {
        self.btnProfileClickedBlock(self.newsFeedTypeModel.newsFeedData.user_info);
    }
}
- (IBAction)btnShareClicked:(id)sender {
    
    if (self.btnPostShareClickedBlock) {
        self.btnPostShareClickedBlock();
    }
}
- (IBAction)btnDirectCollectClicked:(id)sender {
    
    if (self.btnCollectionQuickClickedBlock) {
        self.btnCollectionQuickClickedBlock();
    }
}

- (IBAction)btnCollectToListClicked:(id)sender {
    
    if (self.btnCollectionDidClickedBlock) {
        self.btnCollectionDidClickedBlock(nil);
    }
}

- (IBAction)btnLikeClicked:(id)sender {
    
    if (self.btnLike.selected) {
        [self requestServerToUnlikePost];

    }
    else{
        [self requestServerToLikePost];

    }
}

-(void)initSelfView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [Utils setRoundBorder:self.ibProfileImageView color:[UIColor grayColor] borderRadius:self.ibProfileImageView.frame.size.width/2 borderWidth:1.0f];

}
/*Only Control Promotion uses images, other use photos*/
-(void)initData:(CTFeedTypeModel*)model
{

    self.newsFeedTypeModel = model;
    DraftModel* feedModel = self.newsFeedTypeModel.newsFeedData;
//    if (self.newsFeedTypeModel.feedType == FeedType_Country_Promotion) {
//        [self.ibPostImageView sd_setImageCroppedWithURL:[NSURL URLWithString:self.newsFeedTypeModel.newsFeedData.image] completed:nil];
//
//    }
//    
//    else{
//        
//       
//
//    }
    if (![Utils isArrayNull:feedModel.arrPhotos]) {
        PhotoModel* pModel = self.newsFeedTypeModel.newsFeedData.arrPhotos[0];
        [self.ibPostImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
        
    }
    if (self.newsFeedTypeModel.feedType == FeedType_Local_Quality_Post) {
        self.constSuggestViewHeight.constant = 44;

    }
    else{
        self.constSuggestViewHeight.constant = 0;
    }
    
    self.lblUsername.text = feedModel.user_info.username;
    
    if (feedModel.location.distance <= 0) {
        self.lblDistance.text = @"";

    }
    else{
        self.lblDistance.text = @(feedModel.location.distance).stringValue;

    }
    
    self.lblTitle.text = feedModel.place_name;
    self.lblLocation.text = feedModel.location.locality;
    
    self.lblLocation.text = [NSString stringWithFormat:@"%@ • %@",feedModel.location.locality,feedModel.location.country];

    
 
    [self.lblDescription setStandardText:[feedModel getPostDescription]];

    [self.ibProfileImageView sd_setImageWithURL:[NSURL URLWithString:feedModel.user_info.profile_photo_images]];
    
    [DataManager getPostCollected:feedModel.post_id isCollected:^(BOOL isCollected) {
        
        if (isCollected) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectedBtn.png"];
            self.btnQuickCollect.hidden = isCollected;

        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectBtn.png"];
            self.btnQuickCollect.hidden = !isCollected;

        }
        
    } PostNotCollectedBlock:^{
        if ([feedModel.collect isEqualToString:@"1"]) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectedBtn.png"];
            self.btnQuickCollect.hidden = YES;

        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectBtn.png"];
            self.btnQuickCollect.hidden = NO;

        }

        
    }];
    [self refreshData];
    
}


-(float)getImageHeight:(UIImageView*)imageView givenWidth:(float)width givenHeight:(float)height
{
    
    
    float calcHeight = 0;
    
    calcHeight = imageView.frame.size.width/width * height;
    
    return calcHeight;
}


-(void)refreshData
{
    
    [DataManager getPostLikes:self.newsFeedTypeModel.newsFeedData.post_id isLiked:^(BOOL isCollected) {
        
        self.btnLike.selected = isCollected;
    } NotLikeBlock:^{
        
        self.btnLike.selected = self.newsFeedTypeModel.newsFeedData.like;
    }];
}
-(void)requestServerToLikePost
{
    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.newsFeedTypeModel.newsFeedData.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.newsFeedTypeModel.newsFeedData.post_id,
                           };
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostLikeAPost param:dict appendString:appendString meta:nil completeHandler:^(id object) {
      
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];

        [DataManager setPostLikes:self.newsFeedTypeModel.newsFeedData.post_id isLiked:isLiked];
        [self refreshData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerToUnlikePost
{
    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.newsFeedTypeModel.newsFeedData.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.newsFeedTypeModel.newsFeedData.post_id,
                           };
    
    [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypeDeleteLikeAPost param:dict appendString:appendString completeHandler:^(id object) {
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];
        [DataManager setPostLikes:self.newsFeedTypeModel.newsFeedData.post_id isLiked:isLiked];
        [self refreshData];
        
    } errorBlock:^(id object) {
        
    }];
}
@end

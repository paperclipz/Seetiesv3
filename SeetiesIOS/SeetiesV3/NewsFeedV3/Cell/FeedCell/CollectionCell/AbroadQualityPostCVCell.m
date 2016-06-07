//
//  AbroadQualityPostCVCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AbroadQualityPostCVCell.h"
@interface AbroadQualityPostCVCell()
@property(nonatomic,strong)DraftModel* postModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnQuickCollect;
@property (weak, nonatomic) IBOutlet UIImageView *ibCollectionImage;
@end

@implementation AbroadQualityPostCVCell

- (IBAction)btnDirectCollectClicked:(id)sender {
    
    if (self.btnCollectionQuickClickedBlock) {
        self.btnCollectionQuickClickedBlock(self.postModel);
    }
}

- (IBAction)btnCollectToListClicked:(id)sender {
    
    if (self.btnCollectionDidClickedBlock) {
        self.btnCollectionDidClickedBlock(self.postModel);
    }
}

- (IBAction)btnLikeClicked:(id)sender {
    
    if (self.btnLike.selected) {
        [self requestServerToUnlikePost];
        
    }
    else{
        [self requestServerToLikePost];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.btnLike.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1.0);
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1
                                  delay:0.0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^
             {
                 self.btnLike.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
             }
                             completion:^(BOOL finished) {
                                 
                                 [UIView animateWithDuration:0.1
                                                       delay:0.0
                                      usingSpringWithDamping:0.3
                                       initialSpringVelocity:1.0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^
                                  {
                                      self.btnLike.layer.transform = CATransform3DIdentity;
                                  }
                                                  completion:nil];
                             }];
        }];
        
        
    }
}

- (IBAction)btnProfileClicked:(id)sender {
    if (self.btnProfileClickedBlock) {
        self.btnProfileClickedBlock(self.postModel.user_info);
    }
}

-(void)initData:(DraftModel*)model
{
    self.postModel = model;
    
    if (![Utils isArrayNull:model.arrPhotos]) {
        PhotoModel* pModel = model.arrPhotos[0];
        [self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:nil];
        
    }

    self.lblName.text = model.user_info.username;
    
    
    if (model.location.distance <= 0) {
        self.lblDistance.text = @"";
        
    }
    else{
        
        self.lblDistance.text = [Utils getDistance:model.location.distance Locality:model.location.locality];

    }
    
    self.lblTitle.text = model.place_name;
    self.lblLocation.text = [NSString stringWithFormat:@"%@ • %@",model.location.locality,model.location.country];
    
    NSString* contentLanguage = self.postModel.content_languages[0];
    NSString* postDesc;
    
    if (![Utils isStringNull:contentLanguage]) {
        postDesc = self.postModel.contents[contentLanguage][@"title"];
    }

    [self.lblDescription setStandardText:postDesc];

    [self.ibProfileImage sd_setImageWithURL:[NSURL URLWithString:self.postModel.user_info.profile_photo_images]];
    
    [self refreshData];
    
    [DataManager getPostCollected:self.postModel.post_id isCollected:^(BOOL isCollected) {
        
        if (isCollected) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectedBtn.png"];
            self.btnQuickCollect.hidden = isCollected;
            
        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectBtn.png"];
            self.btnQuickCollect.hidden = !isCollected;
            
        }
        
    } PostNotCollectedBlock:^{
        if ([self.postModel.collect isEqualToString:@"1"]) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectedBtn.png"];
            self.btnQuickCollect.hidden = YES;
            
        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:@"CollectBtn.png"];
            self.btnQuickCollect.hidden = NO;
            
        }
        
    }];

}

-(void)initSelfView
{
    [self.ibProfileImage setRoundedBorder];
}

#pragma mark - Request Server
-(void)requestServerToLikePost
{
    
    if ([Utils isGuestMode]) {
        
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To Like") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.postModel.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postModel.post_id,
                           };
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostLikeAPost parameter:dict appendString:appendString success:^(id object) {
        
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];
        
        [DataManager setPostLikes:self.postModel.post_id isLiked:isLiked];
        [self refreshData];
        
    } failure:^(id object) {
        
    }];
}

-(void)requestServerToUnlikePost
{
    
    if ([Utils isGuestMode]) {
        
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To UnLike") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }
    
    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.postModel.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postModel.post_id,
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_DELETE serverRequestType:ServerRequestTypeDeleteLikeAPost parameter:dict appendString:appendString success:^(id object) {
        
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];
        [DataManager setPostLikes:self.postModel.post_id isLiked:isLiked];
        [self refreshData];
        
    } failure:^(id object) {
        
    }];
}

-(void)refreshData
{
    
    [DataManager getPostLikes:self.postModel.post_id isLiked:^(BOOL isCollected) {
        
        self.btnLike.selected = isCollected;
    } NotLikeBlock:^{
        
        self.btnLike.selected = self.postModel.like;
    }];
}



@end

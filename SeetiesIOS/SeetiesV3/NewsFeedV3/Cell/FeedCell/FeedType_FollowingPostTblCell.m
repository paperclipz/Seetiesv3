//
//  FeedType_FollowingPostTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_FollowingPostTblCell.h"

@interface FeedType_FollowingPostTblCell()
{

    __weak IBOutlet UIView *ibProfileContentView;
    __weak IBOutlet UIImageView *ibImgProfilePadding;
    __weak IBOutlet NSLayoutConstraint *constTitleHeight;
}

@property (weak, nonatomic) IBOutlet UIImageView *ibImgDistance;
@property (nonatomic,strong)CTFeedTypeModel* newsFeedTypeModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibPostImageView;
@property (weak, nonatomic) IBOutlet UIView *ibSuggestedView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

/*constraint*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constSuggestViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblSuggestQR;

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
-(void)awakeFromNib
{
    self.ibPostImageView.backgroundColor = TWO_ZERO_FOUR_COLOR;

}

-(void)initSelfView
{
    ibImgProfilePadding.alpha = 0.3;
    [ibProfileContentView setRoundedBorder];
    ibImgProfilePadding.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [Utils setRoundBorder:self.ibProfileImageView color:[UIColor grayColor] borderRadius:self.ibProfileImageView.frame.size.width/2 borderWidth:1.0f];
    
    [Utils setRoundBorder:self.ibSuggestedView color:OUTLINE_COLOR borderRadius:0];
    
    [self changLanguage];

}
/*Only Control Promotion uses images, other use photos*/
-(void)initData:(CTFeedTypeModel*)model
{

    self.newsFeedTypeModel = model;
    DraftModel* feedModel = self.newsFeedTypeModel.newsFeedData;

    
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
        
        self.lblDistance.text = [Utils getDistance:feedModel.location.distance Locality:feedModel.location.locality];
//        self.lblDistance.text = @(feedModel.location.distance).stringValue;

    }
    
    if ([Utils isStringNull:[feedModel getPostTitle]]) {
        constTitleHeight.constant = 0;
    }
    else {
        constTitleHeight.constant = 30;
    }
    
    self.lblTitle.text = [feedModel getPostTitle];
    
    //check whether is seetishop
    if (feedModel.seetishop_info.name) {
        
        self.lblLocation.text = feedModel.seetishop_info.name;

    }
    else{
        self.lblLocation.text = feedModel.location.name;

    }
    
    [self.lblDescription setStandardText:[feedModel getPostDescription]];

    
    [self.ibProfileImageView sd_setImageWithURL:[NSURL URLWithString:feedModel.user_info.profile_photo_images] placeholderImage:[Utils getProfilePlaceHolderImage]];

    [DataManager getPostCollected:feedModel.post_id isCollected:^(BOOL isCollected) {
        
        if (isCollected) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"Collected_Btn.png"];
            self.btnQuickCollect.hidden = isCollected;

        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:[self getCollectIconName]];
            self.btnQuickCollect.hidden = !isCollected;

        }
        
    } PostNotCollectedBlock:^{
        if ([feedModel.collect isEqualToString:@"1"]) {
            self.ibCollectionImage.image = [UIImage imageNamed:@"Collected_Btn.png"];
            self.btnQuickCollect.hidden = YES;

        }
        else{
            self.ibCollectionImage.image = [UIImage imageNamed:[self getCollectIconName]];
            self.btnQuickCollect.hidden = NO;

        }
        
    }];
    
//    if (feedModel.location.distance <=3) {
//        self.ibImgDistance.image = [UIImage imageNamed:@"Distance1Icon.png"];
//    }
//    else if(feedModel.location.distance<=15)
//    {
//        self.ibImgDistance.image = [UIImage imageNamed:@"Distance2Icon.png"];
//
//    }
//    else if(feedModel.location.distance<=300)
//    {
//        self.ibImgDistance.image = [UIImage imageNamed:@"Distance3Icon.png"];
//        
//    }
//    else if(feedModel.location.distance<=1500)
//    {
//        self.ibImgDistance.image = [UIImage imageNamed:@"Distance4Icon.png"];
//        
//    }
    
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
    
    if ([Utils isGuestMode]) {
        
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To Like") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }

    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.newsFeedTypeModel.newsFeedData.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.newsFeedTypeModel.newsFeedData.post_id,
                           };
    
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostLikeAPost parameter:dict appendString:appendString success:^(id object) {
      
        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];

        [DataManager setPostLikes:self.newsFeedTypeModel.newsFeedData.post_id isLiked:isLiked];
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
    
    NSString* appendString = [NSString stringWithFormat:@"%@/like",self.newsFeedTypeModel.newsFeedData.post_id];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.newsFeedTypeModel.newsFeedData.post_id,
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_DELETE serverRequestType:ServerRequestTypeDeleteLikeAPost parameter:dict appendString:appendString success:^(id object) {

        NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
        
        
        BOOL isLiked = [returnDict[@"data"][@"like"] boolValue];
        [DataManager setPostLikes:self.newsFeedTypeModel.newsFeedData.post_id isLiked:isLiked];
        [self refreshData];
        
    } failure:^(id object) {
        
    }];
}

-(void)changLanguage
{
    self.lblSuggestQR.text = LocalisedString(@"Suggested local QR");
}

-(NSString*)getCollectIconName
{

    NSString* str = [LanguageManager getDeviceAppLanguageCode];

   
    if ([str isEqualToString:CHINESE_CODE]) {
        return @"CollectSimplifiedChineseBtn.png";
    }
    else if ([str isEqualToString:TAIWAN_CODE]) {
        return @"CollectTraditonalChineseBtn.png";

    }
    else if ([str isEqualToString:INDONESIA_CODE]) {
        return @"CollectIndoBtn.png";
 
    }
    
    else if ([str isEqualToString:THAI_CODE]) {
        return @"CollectThaiBtn.png";
        
    }
    else
    {
        return @"CollectBtn.png";

    }

}
@end

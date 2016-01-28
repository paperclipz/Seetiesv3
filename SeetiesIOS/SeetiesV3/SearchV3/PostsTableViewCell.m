//
//  PostsTableViewCell.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PostsTableViewCell.h"
@interface PostsTableViewCell(){

    BOOL IsQuickCollect;
}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageNoViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageUser;
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;

@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIButton *btnCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnUserProfile;

@property(nonatomic,strong)DraftModel* model;

@end
@implementation PostsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    IsQuickCollect = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnFollowClicked:(id)sender {
    
    if (_btnFollowBlock) {
        self.btnFollowBlock();
    }
}
- (IBAction)btnCollectionClicked:(id)sender {
    if (IsQuickCollect == YES) {
        if (_btnCollectionBlock) {
            self.btnCollectionBlock();
        }
    }else{
        if (_btnCollectionOpenViewBlock) {
            self.btnCollectionOpenViewBlock();
        }
    }

}
- (IBAction)btnUserProfileClicked:(id)sender {
    
    if (_btnUserProfileBlock) {
        self.btnUserProfileBlock();
    }
}
-(void)initData:(DraftModel*)model
{
    
    [self.ibImageUser setSideCurveBorder];
    [self.ibImageView setImagePlaceHolder];
    [Utils setRoundBorder:self.ibImageView color:LINE_COLOR borderRadius:5.0f];
    [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
    
    NSString* currentlangCode = [Utils getLanguageCodeFromLocale:[[LanguageManager sharedLanguageManager]getSelectedLocale].languageCode];
    self.model = model;
    
    
    if (![self.model.arrPost isNull]) {
        
        Post* postModel;
        for (int i = 0 ; i< self.model.arrPost.count; i++) {
            postModel = self.model.arrPost[i];
            
            if ([postModel.language isEqualToString:currentlangCode]) {
                self.lblTitle.text = self.model.contents[currentlangCode][@"title"];
                
                break;
            }
        }
        postModel = self.model.arrPost[0];
        
        self.lblTitle.text  = postModel.title;
        
    }
    
    if (model.user_info.following == YES) {
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
    }else{
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
    }
    
    if ([model.collect isEqualToString:@"1"]) {
        [self.btnCollection setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateNormal];
        [self.btnCollection setImage:[UIImage imageNamed:@"YellowCollect.png"] forState:UIControlStateSelected];
        IsQuickCollect = NO;
    }else{
        [self.btnCollection setImage:[UIImage imageNamed:@"YellowCollect.png"] forState:UIControlStateNormal];
        [self.btnCollection setImage:[UIImage imageNamed:@"YellowCollected.png"] forState:UIControlStateSelected];
        IsQuickCollect = YES;
    }
    
    
    self.lblLocation.text = self.model.place_name;
    self.lblUsername.text = self.model.user_info.name;
    
    //    if (self.profileViewType != ProfileViewTypeOthers) {
    //        [self requestServerForUserLikes];
    //
    //    }
    if (![self.model.user_info.profile_photo_images isNull]) {
        [self.ibImageUser sd_setImageWithURL:[NSURL URLWithString:self.model.user_info.profile_photo_images] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.ibImageUser.image = [image imageCroppedAndScaledToSize:self.ibImageUser.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
            
        }];
    }
    
    if (![self.model.arrPhotos isNull]) {
        
        
        PhotoModel* photoModel = self.model.arrPhotos[0];
        
        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
            
        }];
        
    }
    else{
        SLog(@"NO Images");
    }
}

@end

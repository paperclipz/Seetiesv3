//
//  PostListingTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "PostListingTableViewCell.h"
@interface PostListingTableViewCell()
@property(nonatomic,strong)DraftModel* model;
@property (assign, nonatomic) ProfileViewType profileType;
@end
@implementation PostListingTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initSelfView
{
    [self.ibImageView setImagePlaceHolder];
    [Utils setRoundBorder:self.ibImageView color:LINE_COLOR borderRadius:5.0f];
   
}
-(void)ProfileViewType:(ProfileViewType)type
{
    self.profileType = type;
    
    if (self.profileType == ProfileViewTypeOthers) {
        self.lblNoView.hidden = YES;
        self.ibImageNoViewIcon.hidden = YES;
    }
    
}
-(void)initData:(DraftModel*)model
{
    
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
  
    
    self.lblLocation.text = self.model.place_name;
    self.lblNoView.text = self.model.view_count;
    
//    if (self.profileViewType != ProfileViewTypeOthers) {
//        [self requestServerForUserLikes];
//        
//    }
    
    if (![self.model.arrPhotos isNull]) {
        

        PhotoModel* photoModel = self.model.arrPhotos[0];
        SLog(@"Images : %@",photoModel.imageURL);

        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
            
        }];

    }
    else{
        SLog(@"NO Images");
    }
}

@end

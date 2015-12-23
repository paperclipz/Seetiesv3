//
//  LikeListingCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "LikeListingCollectionViewCell.h"
@interface LikeListingCollectionViewCell()

@end
@implementation LikeListingCollectionViewCell

-(void)initSelfView
{
    [self.ibImageView setImagePlaceHolder];
    [Utils setRoundBorder:self.ibImageView color:LINE_COLOR borderRadius:5.0f];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    
}

-(void)setNoRoundBorder
{
    [Utils setRoundBorder:self.ibImageView color:[UIColor clearColor] borderRadius:0];

}
-(void)initData:(PhotoModel*)model
{
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
}

@end

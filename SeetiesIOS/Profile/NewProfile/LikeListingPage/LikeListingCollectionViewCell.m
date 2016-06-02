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

-(void)awakeFromNib
{
    [self layoutIfNeeded];
}

-(void)initSelfView
{
    [self.ibImageView setImagePlaceHolder];
    [Utils setRoundBorder:self.ibImageView color:LINE_COLOR borderRadius:5.0f];
  
    
}

-(void)setNoRoundBorder
{
    [Utils setRoundBorder:self.ibImageView color:LINE_COLOR borderRadius:0];

}
-(void)initData:(PhotoModel*)model
{
    
    //[self.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:model.imageURL] withPlaceHolder:[Utils getPlaceHolderImage] completed:nil];
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    
    //cropped image may lead to size not adjust to autolayout
}

@end

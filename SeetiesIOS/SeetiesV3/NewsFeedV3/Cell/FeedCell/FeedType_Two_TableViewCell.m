//
//  FeedType_Two_TableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/7/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_Two_TableViewCell.h"

@interface FeedType_Two_TableViewCell()
@property (nonatomic,strong)DraftModel* newsFeedModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibPostImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImageHeight;
@end

@implementation FeedType_Two_TableViewCell

-(void)initData:(DraftModel*)model
{
   
    self.newsFeedModel = model;
    //[self.ibPostImageView sd_setImageWithURL:[NSURL URLWithString:self.newsFeedModel.photos.imageURL]];
    //self.constImageHeight.constant = [self getImageHeight:self.ibPostImageView givenWidth:self.newsFeedModel.photos.imageWidth givenHeight:self.newsFeedModel.photos.imageHeight];
}


@end

//
//  MainTableViewCell.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/6/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell
@synthesize ShowImage,ShowUserImage;
- (void)awakeFromNib {
    // Initialization code
    // Configure the view for the selected state
    ShowImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowImage.layer.cornerRadius=10;
    ShowImage.layer.borderWidth=1;
    ShowImage.layer.masksToBounds = YES;
    ShowImage.layer.borderColor=[[UIColor clearColor] CGColor];
    
    ShowUserImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    ShowUserImage.layer.cornerRadius=25;
    ShowUserImage.layer.borderWidth=1;
    ShowUserImage.layer.masksToBounds = YES;
    ShowUserImage.layer.borderColor=[[UIColor clearColor] CGColor];
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end

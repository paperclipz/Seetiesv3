//
//  FeedType_FollowingCollectionTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_FollowingCollectionTblCell.h"

@interface FeedType_FollowingCollectionTblCell()
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constImgHeight;
@property (weak, nonatomic) IBOutlet UIView *ibImgContentView;
@property (weak, nonatomic) IBOutlet UIView *ibBorderView;
@end
@implementation FeedType_FollowingCollectionTblCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.btnShare color:OUTLINE_COLOR borderRadius:self.btnShare.frame.size.height/2];
    
    self.constImgWidth.constant = self.ibImgContentView.frame.size.width/5*2;
    self.constImgHeight.constant = (self.ibImgContentView.frame.size.height/1);
    [Utils setRoundBorder:self.self.ibImgContentView color:OUTLINE_COLOR borderRadius:5.0f];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

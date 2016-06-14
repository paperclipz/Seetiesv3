//
//  FeedType_InviteFriendTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_InviteFriendTblCell.h"
@interface FeedType_InviteFriendTblCell()

@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end

@implementation FeedType_InviteFriendTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initData:(NSDictionary*)data
{
    NSString* imageURL = data[@"image"];
    
    if (imageURL) {
        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[Utils getBlueBackgroundImage]];
    }
}

@end

//
//  SuggestedCollectionPostTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/11/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SuggestedCollectionPostTableViewCell.h"

@interface SuggestedCollectionPostTableViewCell()

@end
@implementation SuggestedCollectionPostTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(float)getHeight
{
    return 220.0f;
}

-(void)initSelfView
{
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.hdwallpaperbackgrounds.org/photo/1366685048731_[hdwallpaperbackgrounds.org].jpg"]];
   // [Utils setRoundBorder:self.ibImageView color:[UIColor clearColor] borderRadius:DEFAULT_BORDER_RADIUS borderWidth:0];
}
@end

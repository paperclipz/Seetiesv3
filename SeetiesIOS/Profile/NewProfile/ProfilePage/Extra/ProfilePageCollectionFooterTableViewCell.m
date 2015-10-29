
//
//  ProfilePageCollectionFooterTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionFooterTableViewCell.h"

@implementation ProfilePageCollectionFooterTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnSeeAllClicked:(id)sender {
    
    if (_btnSeeAllClickedBlock) {
        self.btnSeeAllClickedBlock();
    }
    
}
-(void)adjustRoundedEdge:(CGRect)frame
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10.0f];
    
}

+(int)getHeight
{
    return 44.0f;
}
@end

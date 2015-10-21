//
//  ProfilePageCollectionHeaderView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionHeaderView.h"
@interface ProfilePageCollectionHeaderView()
@end
@implementation ProfilePageCollectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnSeeAllClicked:(id)sender {
    
    if (self.btnSeeAllClickedBlock) {
        self.btnSeeAllClickedBlock(nil);
    }
}

-(void)initSelfView
{
  

}
+(int)getHeight
{
    return 71.0f;
}

-(void)adjustRoundedEdge:(CGRect)frame
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);

    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.ibBackgroundView setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:10.0f];
    
}
@end

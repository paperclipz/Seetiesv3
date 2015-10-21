//
//  ProfileNoItemTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileNoItemTableViewCell.h"

@implementation ProfileNoItemTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(int)getHeight
{
    return 120.0f;
}

-(void)initSelfView
{
    
}


-(void)adjustRoundedEdge:(CGRect)frame
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, self.frame.size.height);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:10.0f];
    
}

@end

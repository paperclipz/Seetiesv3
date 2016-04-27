//
//  DealHeaderView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/7/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealHeaderView.h"

@implementation DealHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnSeeAllClicked:(id)sender {
    
    if (self.seeMoreBlock) {
        self.seeMoreBlock();
    }
}

-(void)initSelfView
{
    [self.btnSeeMore setTitle:LocalisedString(@"see more") forState:UIControlStateNormal];
}
@end

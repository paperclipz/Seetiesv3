//
//  CustomEmptyView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CustomEmptyView.h"

@implementation CustomEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showLoading
{
    @try {
        self.loadingView.hidden = NO;
        self.emptyStateView.hidden = YES;
    } @catch (NSException *exception) {
        
    }
   
}

-(void)showEmptyState
{
    @try {
        self.loadingView.hidden = YES;
        self.emptyStateView.hidden = NO;
    } @catch (NSException *exception) {
        
    }
   
}

-(void)hideAll
{
    @try {
        self.loadingView.hidden = YES;
        self.emptyStateView.hidden = YES;

    } @catch (NSException *exception) {
        
    }
  }
@end

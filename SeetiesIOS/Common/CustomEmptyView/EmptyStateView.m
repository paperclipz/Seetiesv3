//
//  EmptyStateView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "EmptyStateView.h"

@interface EmptyStateView()
@property (weak, nonatomic) IBOutlet UILabel *lblLoading;

@end

@implementation EmptyStateView

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
        self.noResultView.hidden = YES;
        if (self.loadingImage) {
            self.loadingImage.image = [YLGIFImage imageNamed:@"Loading.gif"];
        }
        
    } @catch (NSException *exception) {
        
    }
    
}

-(void)showEmptyState
{
    @try {
        self.loadingView.hidden = YES;
        self.noResultView.hidden = NO;
    } @catch (NSException *exception) {
        
    }
    
}

-(void)hideAll
{
    @try {
        self.loadingView.hidden = YES;
        self.noResultView.hidden = YES;
        
    } @catch (NSException *exception) {
        
    }
}

-(void)awakeFromNib
{
    self.lblLoading.text = LocalisedString(@"Collect Now, Pay at Shop");
    
}
@end

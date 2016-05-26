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
@property (weak, nonatomic) IBOutlet UILabel *lblNoInternet;

@end

@implementation EmptyStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (IBAction)btnRefreshClicked:(id)sender {
//    
//    if (self.refreshClickedBlock) {
//        self.refreshClickedBlock();
//    }
//}

-(void)showLoading
{
    @try {
        
        self.loadingView.hidden = NO;
        self.noResultView.hidden = YES;
        self.noInternetConnectionView.hidden = YES;
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
        self.noInternetConnectionView.hidden = YES;

    } @catch (NSException *exception) {
        
    }
    
}

-(void)showNoInternetConnection
{
    @try {
        self.loadingView.hidden = YES;
        self.noResultView.hidden = YES;
        self.noInternetConnectionView.hidden = NO;

    } @catch (NSException *exception) {
        
    }
    
}

-(void)hideAll
{
    @try {
        self.loadingView.hidden = YES;
        self.noResultView.hidden = YES;
        self.noInternetConnectionView.hidden = YES;

    } @catch (NSException *exception) {
        
    }
}

-(void)awakeFromNib
{
    self.lblLoading.text = LocalisedString(@"Collect Now, Pay at Shop");
    self.lblNoInternet.text = LocalisedString(@"Uh oh. We sense a weak connection and can't refresh.");
    [self.btnRefresh setTitle:LocalisedString(@"Tap to refresh") forState:UIControlStateNormal];
    [Utils setRoundBorder:self.btnRefresh color:LINE_COLOR borderRadius:self.btnRefresh.frame.size.height/2];
    
}
@end

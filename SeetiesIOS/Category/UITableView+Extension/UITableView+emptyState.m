//
//  UITableView+emptyState.m
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UITableView+emptyState.h"
static const NSString *MAIN_VIEW_KEY = @"mainview";

@implementation UITableView(EmptyState)


@dynamic customEmptyStateView;
- (EmptyStateView *)customEmptyStateView;
{
    return objc_getAssociatedObject(self, &MAIN_VIEW_KEY);
}

- (void)setCustomEmptyStateView:(EmptyStateView *)customEmptyStateView
{

    objc_setAssociatedObject(self, &MAIN_VIEW_KEY, customEmptyStateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)setupCustomEmptyView
{
    self.customEmptyStateView = [EmptyStateView initializeCustomView];
    self.backgroundView = self.customEmptyStateView;
}

-(void)showLoading
{
    @try {
        
        self.customEmptyStateView.loadingView.hidden = NO;
        self.customEmptyStateView.noResultView.hidden = YES;
        if (self.customEmptyStateView.loadingImage) {
            self.customEmptyStateView.loadingImage.image = [YLGIFImage imageNamed:@"Loading.gif"];
        }
        
    } @catch (NSException *exception) {
        
    }
    
}

-(void)showEmptyState
{
    @try {
        self.customEmptyStateView.loadingView.hidden = YES;
        self.customEmptyStateView.noResultView.hidden = NO;
    } @catch (NSException *exception) {
        
    }
    
}

-(void)hideAll
{
    @try {
        self.customEmptyStateView.loadingView.hidden = YES;
        self.customEmptyStateView.noResultView.hidden = YES;
        
    } @catch (NSException *exception) {
        
    }
}

@end

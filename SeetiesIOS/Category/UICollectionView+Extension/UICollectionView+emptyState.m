//
//  UICollectionView+emptyState.m
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UICollectionView+emptyState.h"
static const NSString *MAIN_VIEW_KEY = @"mainview";

@implementation UICollectionView(EmptyState)


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
    self.customEmptyStateView.emptyStateDesc.text = LocalisedString(@"There's nothing 'ere, yet.");
    self.customEmptyStateView.emptyStateTitle.text = LocalisedString(@"Oops...");
    self.backgroundView = self.customEmptyStateView;
}

-(void)showLoading
{
    [self.customEmptyStateView showLoading];
}

-(void)showEmptyState
{
    [self.customEmptyStateView showEmptyState];
}

-(void)hideAll
{
    [self.customEmptyStateView hideAll];
}

@end

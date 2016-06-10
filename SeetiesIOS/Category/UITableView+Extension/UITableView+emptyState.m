//
//  UITableView+emptyState.m
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UITableView+emptyState.h"
static const NSString *MAIN_VIEW_KEY = @"mainview";

static const NSString *REFRESH_BLOCK = @"refreshblock";

@implementation UITableView(EmptyState)


@dynamic customEmptyStateView;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(VoidBlock)block {
    
    objc_setAssociatedObject(self, &REFRESH_BLOCK, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.customEmptyStateView.btnRefresh addTarget:self action:@selector(callBlock:) forControlEvents:event];
    
}

- (void)callBlock:(id)sender {
    VoidBlock block = (VoidBlock)objc_getAssociatedObject(self, &REFRESH_BLOCK);
    if (block) block();
}


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
    
    self.backgroundView = nil;
  
}

@end

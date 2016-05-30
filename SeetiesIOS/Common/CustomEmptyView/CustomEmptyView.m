//
//  CustomEmptyView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CustomEmptyView.h"
#import "YLGIFImage.h"
#import "EmptyStateView.h"

@interface CustomEmptyView()
@property (nonatomic, strong) EmptyStateView *customEmptyStateView;
@property (weak, nonatomic) IBOutlet UILabel *lblLoading;

@end

@implementation CustomEmptyView

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

-(void)awakeFromNib
{
    self.lblLoading.text = LocalisedString(@"Collect Now, Pay at Shop");
}
@end

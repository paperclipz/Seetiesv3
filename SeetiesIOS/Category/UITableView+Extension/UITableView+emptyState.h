//
//  UITableView+emptyState.h
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmptyStateView.h"

@interface UITableView(EmptyState)

@property (nonatomic, strong) EmptyStateView *customEmptyStateView;


-(void)showLoading;
-(void)showEmptyState;
-(void)hideAll;

-(void)setupCustomEmptyView;
@end

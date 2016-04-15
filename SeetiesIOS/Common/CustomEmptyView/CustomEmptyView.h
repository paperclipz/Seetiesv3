//
//  CustomEmptyView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLImageView.h"
@interface CustomEmptyView : UITableView

@property(nonatomic,weak)IBOutlet UIView* loadingView;
@property(nonatomic,weak)IBOutlet UIView* emptyStateView;
@property (weak, nonatomic) IBOutlet YLImageView *ibLoadingImg;
@property (weak, nonatomic) IBOutlet UIView *selfView;

-(void)showLoading;
-(void)showEmptyState;
-(void)hideAll;
-(void)setupEmptyState;


@end

//
//  CustomEmptyView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomEmptyView : UIView

@property(nonatomic,weak)IBOutlet UIView* loadingView;
@property(nonatomic,weak)IBOutlet UIView* emptyStateView;
-(void)showLoading;
-(void)showEmptyState;


@end

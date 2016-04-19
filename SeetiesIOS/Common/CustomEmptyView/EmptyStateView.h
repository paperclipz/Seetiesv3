//
//  EmptyStateView.h
//  SeetiesIOS
//
//  Created by Evan Beh on 19/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface EmptyStateView : CommonView
@property(nonatomic,weak) IBOutlet UIView* loadingView;
@property(nonatomic,weak) IBOutlet UIView* noResultView;
@property (nonatomic, weak)IBOutlet YLImageView *loadingImage;

-(void)showLoading;
-(void)showEmptyState;
-(void)hideAll;

@end

//
//  FeedContentView.h
//  Seeties
//
//  Created by Lai on 09/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

@protocol FeedContentViewDelegate <NSObject>

- (void)alertControllerClickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)tagsLabel:(TLTagsControl *)tagsLabel tappedAtIndex:(NSInteger)index;
- (void)profileButtonClicked:(id)sender;
- (void)FollowingButtonClicked:(id)sender;

@end

@interface FeedContentView : UIView 

@property (strong, nonatomic) NSDictionary *dataDictionary;
@property (weak, nonatomic) id<FeedContentViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary;
- (void)reloadView;

@end

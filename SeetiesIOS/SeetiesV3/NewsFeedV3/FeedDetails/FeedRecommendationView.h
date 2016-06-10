//
//  FeedRecommendationView.h
//  Seeties
//
//  Created by Lai on 08/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDetailModel.h"

@protocol FeedRecommendationViewDelegate <NSObject>

- (void)seeAllButtonClicked:(id)sender;
- (void)openPostDetail:(id)sender withPostID:(NSString *)postID;
- (void)openUserProfile:(id)sender withUserID:(NSString *)userID;

@end

@interface FeedRecommendationView : UIView

@property (strong, nonatomic) NearbyRecommendationModel *model;
@property (weak, nonatomic) id<FeedRecommendationViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withModel:(NearbyRecommendationModel *)model;


@end

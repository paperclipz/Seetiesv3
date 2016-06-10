//
//  FeedRecommendationSubView.h
//  Seeties
//
//  Created by Lai on 08/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedRecommendationSubViewDelegate <NSObject>

- (void)openPostDetail:(id)sender withPostID:(NSString *)postID;
- (void)openUserProfile:(id)sender withUserID:(NSString *)userID;

@end

@interface FeedRecommendationSubView : UIView

@property (strong, nonatomic) NSString *postImageURL;
@property (strong, nonatomic) NSString *postTitle;
@property (strong, nonatomic) NSString *userProfileImageURL;
@property (strong, nonatomic) NSString *userName;

@property (weak, nonatomic) id<FeedRecommendationSubViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame model:(NearbyRecommendationDetailModel *)model;

@end

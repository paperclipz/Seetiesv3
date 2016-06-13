//
//  FeedRecommendationSubView.m
//  Seeties
//
//  Created by Lai on 08/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedRecommendationSubView.h"

static int kConstantMarginSpacing = 10;


@interface FeedRecommendationSubView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *postImageView;
@property (strong, nonatomic) UILabel *postTitleLabel;
@property (strong, nonatomic) UIImageView *userProfileImageView;
@property (strong, nonatomic) UILabel *userNameLabel;

@property (assign, nonatomic) CGFloat currentPointY;
@property (strong, nonatomic) NearbyRecommendationDetailModel *model;

@end

@implementation FeedRecommendationSubView

- (id)initWithFrame:(CGRect)frame model:(NearbyRecommendationDetailModel *)model{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [LINE_COLOR CGColor];
        self.layer.masksToBounds = YES;
        self.currentPointY = 0;
        self.model = model;
        
        [self setupPostImageView];
        [self setupPostTitleLabel];
        [self setupUserProfileImageView];
        [self setupUserNameLabel];
        
        [self implementTapGesture];
    }
    
    return self;
}

- (void)setupPostImageView {
    
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 120)];

    PhotoModel *photo = self.model.photos[0];

    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.layer.masksToBounds = YES;
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:photo.imageURL]];

    [self addSubview:self.postImageView];
    
    self.currentPointY += self.postImageView.frame.size.height + 5;
}

- (void)setupPostTitleLabel {
    
    self.postTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kConstantMarginSpacing, self.currentPointY, CGRectGetWidth(self.frame) - (kConstantMarginSpacing * 2), 18)];
    
    self.postTitleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
    self.postTitleLabel.textColor = ONE_ZERO_TWO_COLOR;
    self.postTitleLabel.text = self.model.place_name;

    [self addSubview:self.postTitleLabel];

    self.currentPointY += self.postTitleLabel.frame.size.height + 5;
}

- (void)setupUserProfileImageView {
    
    self.userProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kConstantMarginSpacing, self.currentPointY, 35, 35)];
    self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.userProfileImageView sd_setImageWithURL:[NSURL URLWithString:self.model.user_info.profile_photo] placeholderImage:[Utils getProfilePlaceHolderImage]];
    
    [Utils setRoundBorder:self.userProfileImageView color:LINE_COLOR borderRadius:self.userProfileImageView.frame.size.width / 2];

    [self addSubview:self.userProfileImageView];

}

- (void)setupUserNameLabel {
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userProfileImageView.frame) + kConstantMarginSpacing, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.userProfileImageView.frame) - (kConstantMarginSpacing * 2), 35)];
    
    self.userNameLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:14];
    self.userNameLabel.textColor = TEXT_GRAY_COLOR;
    self.userNameLabel.text = self.model.user_info.username;

    [self addSubview:self.userNameLabel];
}

- (void)implementTapGesture {
    
    UITapGestureRecognizer *tapRecognizerForPostDetailImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPostDetail:)];
    [tapRecognizerForPostDetailImage setNumberOfTapsRequired:1];
    [tapRecognizerForPostDetailImage setDelegate:self];
    
    [self.postImageView setUserInteractionEnabled:YES];
    [self.postImageView addGestureRecognizer:tapRecognizerForPostDetailImage];
    
    UITapGestureRecognizer *tapRecognizerForPostDetailLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPostDetail:)];
    [tapRecognizerForPostDetailLabel setNumberOfTapsRequired:1];
    [tapRecognizerForPostDetailLabel setDelegate:self];

    [self.postTitleLabel setUserInteractionEnabled:YES];
    [self.postTitleLabel addGestureRecognizer:tapRecognizerForPostDetailLabel];

    UITapGestureRecognizer *tapRecognizerForUserProfileImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserProfile:)];
    [tapRecognizerForUserProfileImage setNumberOfTapsRequired:1];
    [tapRecognizerForUserProfileImage setDelegate:self];
    
    [self.userProfileImageView setUserInteractionEnabled:YES];
    [self.userProfileImageView addGestureRecognizer:tapRecognizerForUserProfileImage];
    
    UITapGestureRecognizer *tapRecognizerForUserProfileLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openUserProfile:)];
    [tapRecognizerForUserProfileLabel setNumberOfTapsRequired:1];
    [tapRecognizerForUserProfileLabel setDelegate:self];
    
    [self.userNameLabel setUserInteractionEnabled:YES];
    [self.userNameLabel addGestureRecognizer:tapRecognizerForUserProfileLabel];
}

- (void)openPostDetail:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openPostDetail:withPostID:)]) {
        [self.delegate openPostDetail:sender withPostID:self.model.post_id];
    }
}

- (void)openUserProfile:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openUserProfile:withUserID:)]) {
        [self.delegate openUserProfile:sender withUserID:self.model.user_info.userUID];
    }
}

@end

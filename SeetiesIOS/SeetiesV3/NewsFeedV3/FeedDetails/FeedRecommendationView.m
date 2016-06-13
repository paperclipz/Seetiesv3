//
//  FeedRecommendationView.m
//  Seeties
//
//  Created by Lai on 08/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedRecommendationView.h"
#import "FeedRecommendationSubView.h"

static int kConstantLeftPadding   = 15;
static int kConstantTopPadding    = 15;

@interface FeedRecommendationView () <FeedRecommendationSubViewDelegate>

@property (assign, nonatomic) CGFloat currentPointY;

@end

@implementation FeedRecommendationView

- (id)initWithFrame:(CGRect)frame withModel:(NearbyRecommendationModel *)model isNeedTop:(BOOL)isNeedTop{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.model = model;
        self.currentPointY = 0;
        
        [self setupTopGrayView:isNeedTop];
        [self setupRecommendationHeader];
        [self setupSeparatorView];
        [self setupRecommendationView];
        [self setupBottomEmptyView];
        
        [self resizeToFitSubviewsHeight];
    }
    
    return self;
}

- (void)setupTopGrayView:(BOOL)isNeedTop {
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), isNeedTop?10:0)];
    
    grayView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:grayView];
    
    self.currentPointY += grayView.frame.size.height + 10;
}

- (void)setupRecommendationHeader {
    
    UILabel *recommendationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - 90, 35)];
    
    recommendationLabel.text = LocalisedString(@"Nearby recommendations");
    recommendationLabel.backgroundColor = [UIColor clearColor];
    recommendationLabel.textColor = ONE_ZERO_TWO_COLOR;
    recommendationLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    
    [self addSubview:recommendationLabel];
    
    if ([self.model.recommendationPosts count] > 1) {

        UIButton *seeAllButton = [[UIButton alloc] init];
        
        [seeAllButton setTitle:LocalisedString(@"See all") forState:UIControlStateNormal];
        [seeAllButton setFrame:CGRectMake(CGRectGetMaxX(recommendationLabel.frame) + 5, self.currentPointY, 70, 35)];
        [seeAllButton setTitleColor:DEVICE_COLOR forState:UIControlStateNormal];
        [seeAllButton addTarget:self action:@selector(seeAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        seeAllButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        
        [self addSubview:seeAllButton];
    }
    
    self.currentPointY += recommendationLabel.frame.size.height + 5;
}

- (void)setupSeparatorView {
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 1)];
    
    separatorView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:separatorView];
    
    self.currentPointY += separatorView.frame.size.height + kConstantTopPadding;
}

- (void)setupRecommendationView {
    
//    UIView *recommendationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 170)];
//    
//    [self addSubview:recommendationView];
    
    if ([self.model.recommendationPosts count] > 1) {
        
        NSArray *array = [self.model.recommendationPosts subarrayWithRange:NSMakeRange(0, 2)];

        int pointX = 0;
        
        for (NearbyRecommendationDetailModel *post in array) {
            
            FeedRecommendationSubView *view = [[FeedRecommendationSubView alloc] initWithFrame:CGRectMake(pointX + kConstantLeftPadding, self.currentPointY, (CGRectGetWidth(self.frame) - (kConstantLeftPadding * 3)) / 2 , 190) model:post];
            
            view.delegate = self;
            [self addSubview:view];
            
            pointX = CGRectGetMaxX(view.frame);
        }
        
        self.currentPointY += 190;
    }
}

- (void)setupBottomEmptyView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), kConstantTopPadding)];
    
    [self addSubview:view];
}

#pragma mark - delegate

- (void)seeAllButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(seeAllButtonClicked:)]) {
        [self.delegate seeAllButtonClicked:sender];
    }
}

- (void)openPostDetail:(id)sender withPostID:(NSString *)postID {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openPostDetail:withPostID:)]) {
        [self.delegate openPostDetail:sender withPostID:postID];
    }
}

- (void)openUserProfile:(id)sender withUserID:(NSString *)userID {
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(openUserProfile:withUserID:)]) {
        [self.delegate openUserProfile:sender withUserID:userID];
    }
}

@end

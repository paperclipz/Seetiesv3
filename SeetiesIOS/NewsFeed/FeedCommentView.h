//
//  FeedCommentView.h
//  Seeties
//
//  Created by Lai on 30/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol FeedCommentViewDelegate <NSObject>

- (void)attributedLabel:(TTTAttributedLabel *)label didClickedLink:(NSURL *)url;
- (void)allActivitiesButtonDidClicked:(id)sender;

@end

@interface FeedCommentView : UIView

@property (strong, nonatomic) NSDictionary *dataDictionary;
@property (weak, nonatomic) id<FeedCommentViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary;
- (void)reloadView;

@end

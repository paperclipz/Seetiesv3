//
//  FeedCommentView.m
//  Seeties
//
//  Created by Lai on 30/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedCommentView.h"
#import "GenericObject.h"

static int kConstantLeftPadding   = 15;
static int kConstantTopPadding    = 15;

@interface FeedCommentView () <TTTAttributedLabelDelegate>

@property (strong, nonatomic) UIView *grayView;

@property (strong, nonatomic) UIImageView *likesImageView;
@property (strong, nonatomic) TTTAttributedLabel *tttLabel;

@property (strong, nonatomic) UIImageView *collectionImageView;
@property (strong, nonatomic) UILabel *collectionLabel;

@property (strong, nonatomic) UIImageView *commentImageView;
@property (strong, nonatomic) UILabel *commentDefaultLabel;
@property (strong, nonatomic) UIView *commentLabelsView;
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIButton *allActivitesButton;

@property (strong, nonatomic) NSMutableArray *linkArray;
@property (strong, nonatomic) NSMutableArray *hashTagLinkArray;

@property (assign, nonatomic) CGFloat currentPointY;

@end

@implementation FeedCommentView

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.linkArray = [NSMutableArray new];
        self.hashTagLinkArray = [NSMutableArray new];
        self.dataDictionary = dataDictionary;
        self.currentPointY = 0;
        
        [self setupTopGrayView];
        [self setupLikesSection];
        [self setupCollectedSection];
        [self setupCommentSection];
        [self setupSeperatorView];
        [self setupAllActivitesButton];
        
        [self reloadView];
//        [self resizeToFitSubviewsHeight];
    }
    
    return self;
}

- (void)setupTopGrayView {
    
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    
    self.grayView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:self.grayView];
    
    self.currentPointY += self.grayView.frame.size.height + kConstantTopPadding + 5;
}

- (void)setupLikesSection {
    
//    if ([self.dataDictionary[@"like_count"] integerValue] < 1) { return; }
    
    //image
    self.likesImageView = [[UIImageView alloc]init];
    self.likesImageView.image = [UIImage imageNamed:@"PostLikeIcon.png"];

    [self addSubview:self.likesImageView];

    //label
    self.tttLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    self.tttLabel.delegate = self;
    
    [self addSubview:self.tttLabel];
}

- (NSString *)formatLikeLabelText {
    
    NSArray *userLikedList = self.dataDictionary[@"like_list"];
    
    [self.linkArray removeAllObjects];
    
    NSInteger totalLike = [self.dataDictionary[@"like_count"] integerValue];
    
    for (LikeDetailModel *user in userLikedList) {

        GenericObject *obj = [[GenericObject alloc] init];
        
        if ([user.uid isEqualToString:[Utils getUserID]]) {
            
            obj.text = @"You";
            obj.value = user.uid;
            
            [self.linkArray addObject:obj];
        }
        else {
            obj.text = user.name;
            obj.value = user.uid;

            [self.linkArray addObject:obj];
        }
        
        if ([self.linkArray count] == 2 && totalLike > 2) {
            [self.linkArray removeLastObject];
            
            obj.text = [NSString stringWithFormat:@"%li other", totalLike - 1];
            obj.value = @"";
            
            [self.linkArray addObject:obj];
            break;
        }
    }
    
    NSString *formattedString;
    GenericObject *obj;
    
    obj = [self.linkArray objectAtIndex:0];

    if (totalLike == 1) {
        
        formattedString = [NSString stringWithFormat:@"%@ like this.", LocalisedString(obj.text)];
    }
    else if (totalLike == 2) {
        
        GenericObject *secondUser = [self.linkArray objectAtIndex:1];
        
        formattedString = [NSString stringWithFormat:@"%@ %@ %@ %@", LocalisedString(obj.text), LocalisedString(@"likeText_and"), secondUser.text, LocalisedString(@"likeText_1")];
    }
    else if (totalLike > 2) {
        
        formattedString = [NSString stringWithFormat:@"%@ %@ %li %@", LocalisedString(obj.text), LocalisedString(@"likeText_and"), totalLike - 1, LocalisedString(@"likeText_andOther")];

    }
    else {
        formattedString = @"";
    }
    
    return formattedString;
}

- (void)setupCollectedSection {
    
//    NSInteger totalNumber = [self.dataDictionary[@"collection_count"] integerValue];
//
//    if (totalNumber < 1 || !totalNumber) { return; }
    
    self.collectionImageView = [[UIImageView alloc]init];
    self.collectionImageView.image = [UIImage imageNamed:@"PostCollectedIcon.png"];
 
    [self addSubview:self.collectionImageView];
    
    self.collectionLabel = [[UILabel alloc]init];
    self.collectionLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    self.collectionLabel.textColor = ONE_ZERO_TWO_COLOR;
    self.collectionLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.collectionLabel];

}

- (void)setupCommentSection {
    
//    NSArray *allComments = self.dataDictionary[@"comments"];
    
//    if (allComments && [allComments count] > 0) {
    
        self.commentImageView = [[UIImageView alloc]init];
        self.commentImageView.image = [UIImage imageNamed:@"PostCommentIcon.png"];
        self.commentImageView.frame = CGRectZero;
        [self addSubview:self.commentImageView];
    
        self.commentDefaultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.commentDefaultLabel.hidden = YES;
        self.commentDefaultLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        self.commentDefaultLabel.textColor = ONE_ZERO_TWO_COLOR;
    
        self.commentLabelsView = [UIView new];
    
        [self addSubview:self.commentDefaultLabel];
        [self addSubview:self.commentLabelsView];
        
//        self.commentTTTLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        self.commentTTTLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
//        self.commentTTTLabel.delegate = self;
//        
//        [self addSubview:self.commentTTTLabel];
        
        //    self.commentTTTLabel = [TEXT_GRAY_COLOR CGColor];
//    }
}

- (void)setupSeperatorView {
    
    //for alignment purpose
    self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 20)];

    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.separatorView.frame) - 1, CGRectGetWidth(self.frame), 1)];
    grayView.backgroundColor = OUTLINE_COLOR;
    self.separatorView.clipsToBounds = YES;
    
    [self.separatorView addSubview:grayView];

    [self addSubview:self.separatorView];
    
    self.currentPointY += self.separatorView.frame.size.height;
}

- (void)setupAllActivitesButton {
    
    self.allActivitesButton = [[UIButton alloc] init];
    self.allActivitesButton.frame = CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 50);
    [self.allActivitesButton setTitle:LocalisedString(@"See all activities") forState:UIControlStateNormal];
    [self.allActivitesButton setBackgroundColor:[UIColor clearColor]];
    [self.allActivitesButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    [self.allActivitesButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.allActivitesButton addTarget:self action:@selector(activitiesButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.allActivitesButton];
}

- (BOOL)isNoDataToDisplay {
    NSInteger totalLike = [self.dataDictionary[@"like_count"] integerValue];
    NSInteger totalCollections = [self.dataDictionary[@"collection_count"] integerValue];
    NSArray *commentList = self.dataDictionary[@"comments"];

    if ((!totalLike || totalLike < 1) && (!totalCollections || totalCollections < 1) && (!commentList || commentList.count < 1)) {
        return YES;
    }
    
    return NO;
}

- (void)reloadView {
    
    self.currentPointY = 0;
    
    [self updateGrayView];
    [self updateLikeSection];
    [self updateCollectionSection];
    [self updateCommentSection];
    [self updateSeparatorView];
    [self updateAllActivitiesButton];
    
    [self resizeToFitSubviewsHeight];
}

- (void)updateGrayView {
    
    self.grayView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);

    if (![self isNoDataToDisplay]) {
        self.currentPointY += self.grayView.frame.size.height + kConstantTopPadding + 5;
    }
}

- (void)updateLikeSection {
    
    NSInteger totalLike = [self.dataDictionary[@"like_count"] integerValue];
    
//    if (!self.likesImageView) { return; }
    
    self.likesImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);
    
    NSString *labelText;
    
    if (!totalLike || totalLike == 0) {
        
        //        self.likesImageView.frame = CGRectZero;
        //        self.tttLabel.frame = CGRectZero;
//        self.tttLabel.text = LocalisedString(@"Be the first to like");
//        
//        self.currentPointY += self.tttLabel.frame.size.height + 10;
        labelText = LocalisedString(@"Be the first to like");
    }
    else {
        labelText = [self formatLikeLabelText];

    }
    
//    NSString *labelText = [self formatLikeLabelText];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15] };
    
    self.tttLabel.text = labelText;
    self.tttLabel.frame = CGRectMake(CGRectGetMaxX(self.likesImageView.frame) + 8, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.likesImageView.frame) - kConstantLeftPadding - 8, 35);
    self.tttLabel.activeLinkAttributes = attributes;
    self.tttLabel.linkAttributes = attributes;
    self.tttLabel.inactiveLinkAttributes = attributes;
    self.tttLabel.userInteractionEnabled = YES;
    self.tttLabel.numberOfLines = 2;
    self.tttLabel.textColor = ONE_ZERO_TWO_COLOR;
    
    NSMutableArray *activeLinkArray = [self.linkArray copy];
    
    [self.tttLabel setText:labelText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange allRange = NSMakeRange(0, mutableAttributedString.length);
        
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:15];
        CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (boldFont) {
            [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:allRange];
            [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:allRange];
            CFRelease(boldFont);
        }
        
        for (GenericObject *obj in activeLinkArray) {
            if ([obj.text isEqualToString:@"You"]) {
                continue;
            }
            
            NSRange range = [labelText rangeOfString:obj.text];
            
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[DEVICE_COLOR CGColor] range:range];
        }
        
        return mutableAttributedString;
    }];
    
    for (GenericObject *obj in activeLinkArray) {
        
        if ([obj.text isEqualToString:@"You"]) {
            continue;
        }
        
        NSRange range = [labelText rangeOfString:obj.text];
        
        NSString *urlPath = [NSString stringWithFormat:@"like://%@", obj.value];
        //        NSString *escapedURLPath = [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.tttLabel addLinkToURL:[NSURL URLWithString:urlPath] withRange:range];
    }
    
    [self.tttLabel sizeToFit];
    [self.tttLabel setNeedsDisplay];
    
    [self.tttLabel setFrame:CGRectMake(self.tttLabel.frame.origin.x, self.currentPointY + CGRectGetHeight(self.likesImageView.frame) / 4, self.tttLabel.frame.size.width, self.tttLabel.frame.size.height)];
    
    self.currentPointY += self.tttLabel.frame.size.height + 28;
}

- (void)updateCollectionSection {
    
//    if (!self.collectionImageView) { return; }
    
    NSInteger totalNumber = [self.dataDictionary[@"collection_count"] integerValue];
    
    self.collectionImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);

    if (!totalNumber || totalNumber == 0) {
        //        self.collectionImageView.frame = CGRectZero;
        self.collectionLabel.text = LocalisedString(@"Aww. No one's collected this.");
        
    }
    else {
        NSString *str = [[NSString alloc] initWithFormat:@"Collected in %li %@", (long)totalNumber, LocalisedString(@"Collections")];
        
        self.collectionLabel.text = str;
    }
    
    self.collectionLabel.frame = CGRectMake(CGRectGetMaxX(self.collectionImageView.frame) + 8, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.collectionImageView.frame) - kConstantLeftPadding - 8, 35);
    
    self.currentPointY += self.collectionImageView.frame.size.height + 10;
}

- (void)updateCommentSection {
    
//    if (!self.commentImageView) { return; }
    
    NSArray *rawCommentList = self.dataDictionary[@"comments"];
    NSArray *commentList;
    
    self.commentImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);
    
    if (!rawCommentList || rawCommentList.count < 1) {
        self.commentDefaultLabel.frame = CGRectMake(CGRectGetMaxX(self.commentImageView.frame) + 8, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.commentImageView.frame) - kConstantLeftPadding - 8, 35);
        self.commentDefaultLabel.hidden = NO;
        self.commentDefaultLabel.text = LocalisedString(@"Be the first to comment");
        
        self.currentPointY += CGRectGetHeight(self.commentDefaultLabel.frame);
        return;
    }
    
    self.commentDefaultLabel.hidden = YES;

    if ([rawCommentList count] > 2) {
        commentList = [[[rawCommentList subarrayWithRange:NSMakeRange(0, 3)] reverseObjectEnumerator] allObjects];
    }
    else {
        commentList = [[rawCommentList reverseObjectEnumerator] allObjects];
    }
    
    if (self.commentLabelsView) {
        [[self.commentLabelsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.commentLabelsView.frame = CGRectMake(CGRectGetMaxX(self.commentImageView.frame) + 8, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.commentImageView.frame) - kConstantLeftPadding - 8, 35);
    
    CGFloat currentPointY = 6;
    
    for (CommentDetailModel *commentDetail in commentList) {
        
        //name label
        TTTAttributedLabel *nameLabel = [self newAttributedLabel];
        
        nameLabel.textColor = ONE_ZERO_TWO_COLOR;
        nameLabel.frame = CGRectMake(0, currentPointY, CGRectGetWidth(self.commentLabelsView.frame), 35);

        [nameLabel setText:commentDetail.author_info.name afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange allRange = NSMakeRange(0, mutableAttributedString.length);
            
            UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:15];
            CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            if (boldFont) {
                [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:allRange];
                [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:allRange];
                CFRelease(boldFont);
            }
            
            return mutableAttributedString;
        }];
        
        NSString *urlPath = [NSString stringWithFormat:@"comment://%@", commentDetail.author_info.userUID];
        [nameLabel addLinkToURL:[NSURL URLWithString:urlPath] withRange:NSMakeRange(0, [nameLabel.text length])];
        [nameLabel sizeToFit];
        
        [self.commentLabelsView addSubview:nameLabel];
        
        currentPointY += nameLabel.frame.size.height + 2;
        
        //message label
        TTTAttributedLabel *messageLabel = [self newAttributedLabel];
        
        messageLabel.frame = CGRectMake(0, currentPointY, CGRectGetWidth(self.commentLabelsView.frame) - kConstantLeftPadding, 35);

        NSString *modifiedString = [self extractUserHashTagInMessage:commentDetail.message];
        
        [messageLabel setText:modifiedString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange allRange = NSMakeRange(0, mutableAttributedString.length);
            
//            CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)systemBoldFont.fontName, systemBoldFont.pointSize, NULL);
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"ProximaNovaSoft-Regular", 15, NULL);

            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:allRange];
                CFRelease(font);
                
            }
            
            
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:allRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[TEXT_GRAY_COLOR CGColor] range:allRange];
            
            for (GenericObject *obj in self.hashTagLinkArray) {
                
                NSRange range = [modifiedString rangeOfString:obj.text];
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[DEVICE_COLOR CGColor] range:range];
            }

            
            return mutableAttributedString;
        }];
        
        for (GenericObject *obj in self.hashTagLinkArray) {
            
            NSRange range = [modifiedString rangeOfString:obj.text];
            
            NSString *urlPath = [NSString stringWithFormat:@"comment://%@", obj.value];
            
            [messageLabel addLinkToURL:[NSURL URLWithString:urlPath] withRange:range];
        }
        
        [messageLabel sizeToFit];
        [messageLabel setNeedsDisplay];
        
        [self.commentLabelsView addSubview:messageLabel];
        
        currentPointY += messageLabel.frame.size.height + 10;
    }
    
    [self.commentLabelsView resizeToFitSubviews];
    
//    [self addSubview:self.commentLabelsView];
    
    self.currentPointY += CGRectGetHeight(self.commentLabelsView.frame);
}

- (void)updateSeparatorView {
    
    if ([self isNoDataToDisplay]) {
        self.separatorView.frame = CGRectZero;
        return;
    }
    
    self.separatorView.frame = CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 20);
    
    self.currentPointY += CGRectGetHeight(self.separatorView.frame);
}

- (void)updateAllActivitiesButton {
    
    self.allActivitesButton.frame = CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 50);
}

- (NSMutableString *)extractUserHashTagInMessage:(NSString *)message {
    
    [self.hashTagLinkArray removeAllObjects];
    
    //Regex for matches "[user:fe1sd243sfe24bfbb3we23]" key words
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[user:[a-zA-Z0-9]*:[a-zA-Z\\d_]*\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:message options:0 range:NSMakeRange(0, [message length])];
    
    NSInteger offset = 0;
    
    NSMutableString* mutableString = [message mutableCopy];

    for (NSTextCheckingResult *match in matches) {
        
        NSRange matchRange = [match range];
        matchRange.location += offset;
        
        NSString *str = [[[regex replacementStringForResult:match inString:message offset:offset template:@"$0"] stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
        
        //separate result will be in this format :-
        // arr[0] = prefix string
        // arr[1] = user id
        // arr[2] = user name
        NSArray *arr = [str componentsSeparatedByString:@":"];

        NSString *replacementString = arr[2];
        
        GenericObject *obj = [[GenericObject alloc] init];
        
        obj.text = [NSString stringWithFormat:@"@%@", replacementString];
        obj.value = arr[1];
        
        [self.hashTagLinkArray addObject:obj];
        
        [mutableString replaceCharactersInRange:matchRange withString:replacementString];
        
        offset += ([replacementString length] - matchRange.length);
    }

    return mutableString;
}

- (TTTAttributedLabel *)newAttributedLabel {
    
    TTTAttributedLabel *attributedLabel = [TTTAttributedLabel new];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15] };
    
    attributedLabel.activeLinkAttributes = attributes;
    attributedLabel.linkAttributes = attributes;
    attributedLabel.inactiveLinkAttributes = attributes;
    attributedLabel.userInteractionEnabled = YES;
    attributedLabel.numberOfLines = 0;
    attributedLabel.delegate = self;
    
    return attributedLabel;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
    if (url.absoluteString && self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didClickedLink:)]) {
        [self.delegate attributedLabel:label didClickedLink:url];
    }
}

#pragma mark - delegate

- (void)activitiesButtonDidClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(allActivitiesButtonDidClicked:)]) {
        [self.delegate allActivitiesButtonDidClicked:sender];
    }
}

@end

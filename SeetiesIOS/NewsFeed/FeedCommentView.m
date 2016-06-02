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
@property (strong, nonatomic) TTTAttributedLabel *commentTTTLabel;

@property (strong, nonatomic) NSMutableArray *linkArray;

@property (assign, nonatomic) CGFloat currentPointY;

@end

@implementation FeedCommentView

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.linkArray = [NSMutableArray new];
        self.dataDictionary = dataDictionary;
        self.currentPointY = 0;
        
        [self setupTopGrayView];
        [self setupLikesSection];
        [self setupCollectedSection];
        [self setupCommentSection];
        
        [self resizeToFitSubviewsHeight];
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
    
    if ([self.dataDictionary[@"like_count"] integerValue] < 1) { return; }
    
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
//    NSMutableArray *excludeLinkArray = [NSMutableArray new];
    
    int totalLike = [self.dataDictionary[@"like_count"] integerValue];
    
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
            
            obj.text = [NSString stringWithFormat:@"%i other", totalLike - 1];
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
        
        formattedString = [NSString stringWithFormat:@"%@ %@ %i %@", LocalisedString(obj.text), LocalisedString(@"likeText_and"), totalLike - 1, LocalisedString(@"likeText_andOther")];

    }
    else {
        formattedString = @"";
    }
    
    return formattedString;
}

- (void)setupCollectedSection {
    
    int totalNumber = [self.dataDictionary[@"collection_count"] integerValue];

    if (totalNumber < 1 || !totalNumber) { return; }
    
    self.collectionImageView = [[UIImageView alloc]init];
    self.collectionImageView.image = [UIImage imageNamed:@"PostCollectedIcon.png"];
 
    [self addSubview:self.collectionImageView];
    
    self.collectionLabel = [[UILabel alloc]init];
    self.collectionLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    self.collectionLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.collectionLabel];

}

- (void)setupCommentSection {
    
    NSArray *allComments = self.dataDictionary[@"comments"];
    
    if (allComments && [allComments count] > 0) {
     
        self.commentImageView = [[UIImageView alloc]init];
        self.commentImageView.image = [UIImage imageNamed:@"PostCommentIcon.png"];
        self.commentImageView.frame = CGRectZero;
        [self addSubview:self.commentImageView];
        
        self.commentTTTLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentTTTLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        self.commentTTTLabel.delegate = self;
        
        [self addSubview:self.commentTTTLabel];
        
        //    self.commentTTTLabel = [TEXT_GRAY_COLOR CGColor];
    }
}

- (void)reloadView {
    
    self.currentPointY = 0;
    
    [self updateGrayView];
    [self updateLikeSection];
    [self updateCollectionSection];
    [self updateCommentSection];
    
    [self resizeToFitSubviewsHeight];
}

- (void)updateGrayView {
    
    self.currentPointY += self.grayView.frame.size.height + kConstantTopPadding + 5;
}

- (void)updateLikeSection {
    
    if (!self.likesImageView) { return; }
    
    self.likesImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);
    
    NSString *labelText = [self formatLikeLabelText];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15] };
    
    self.tttLabel.text = labelText;
    self.tttLabel.frame = CGRectMake(CGRectGetMaxX(self.likesImageView.frame) + kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.likesImageView.frame) - kConstantLeftPadding, 35);
    self.tttLabel.activeLinkAttributes = attributes;
    self.tttLabel.linkAttributes = attributes;
    self.tttLabel.inactiveLinkAttributes = attributes;
    self.tttLabel.userInteractionEnabled=YES;
    
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
    
    [self.tttLabel setNeedsDisplay];
    
    self.currentPointY += self.tttLabel.frame.size.height + 10;
}

- (void)updateCollectionSection {
    
    if (!self.collectionImageView) { return; }
    
    int totalNumber = [self.dataDictionary[@"collection_count"] integerValue];
    
    self.collectionImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);

    
    NSString *str = [[NSString alloc] initWithFormat:@"Collected in %i %@", totalNumber, LocalisedString(@"Collections")];
    
    self.collectionLabel.text = str;
    self.collectionLabel.frame = CGRectMake(CGRectGetMaxX(self.collectionImageView.frame) + kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - 69, 35);
    
    self.currentPointY += self.collectionImageView.frame.size.height + 10;
}

- (void)updateCommentSection {
    
    if (!self.commentImageView) { return; }
    
    self.commentImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 35, 35);
    
//    self.commentTTTLabel.text = @"asdfsaf\n testing!! \n asdfajskldf";
//    
//    [self.commentTTTLabel sizeToFit];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
    if (url.absoluteString && self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:didClickedLink:)]) {
        [self.delegate attributedLabel:label didClickedLink:url];
    }
}

@end

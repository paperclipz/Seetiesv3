//
//  FeedContentView.m
//  Seeties
//
//  Created by Lai on 09/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedContentView.h"
#import "AsyncImageView.h"

static int kConstantLeftPadding   = 15;
static int kConstantTopPadding    = 15;

@interface FeedContentView () <TLTagsControlDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *translateButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *locationPinImage;
@property (strong, nonatomic) UILabel *locationPinLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) TLTagsControl *tagsLabel;
@property (strong, nonatomic) AsyncImageView *profileImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIButton *followButton;
@property (strong, nonatomic) UIView *bottomEmptyView;

@property (assign, nonatomic) CGFloat currentPointY;
@property (assign, nonatomic) BOOL isTranslatedText;

@end

@implementation FeedContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withDataDictionary:(NSDictionary *)dataDictionary{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataDictionary = dataDictionary;
        
        [self setupTranslationButton];
        [self setupCaptionTitle];
        [self setupLocationPin];
        [self setupMessageLabel];
        [self setupTagTextField];
        [self setupProfilePictureImageView];
        [self setupFollowingButton];
        [self setupBottomEmptyView];
        
        [self resizeToFitSubviewsHeight];
    }
    
    return self;
}

- (void)setupTranslationButton {
    self.translateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [self.translateButton setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 40)];
    
    self.translateButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [self.translateButton setImage:[UIImage imageNamed:@"TranslateArrow.png"] forState:UIControlStateNormal];
    [self.translateButton setTitle:LocalisedString(@"Translate") forState:UIControlStateNormal];
    [self.translateButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
    [self.translateButton addTarget:self action:@selector(translateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.translateButton.tintColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
    [Utils setRoundBorder:self.translateButton color:TWO_ZERO_FOUR_COLOR borderRadius:self.translateButton.frame.size.height/2 borderWidth:1.0f];
    
//    self.currentPointY += self.translateButton.frame.size.height + kConstantTopPadding;
    
    [self addSubview:self.translateButton];
}

- (void)setupCaptionTitle {
    
    if (![self.dataDictionary objectForKey:@"title"]) {
        self.currentPointY += 10;
        return;
    }
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f  blue:51.0f/255.0f  alpha:1.0f];
    
    _titleLabel.text = [self.dataDictionary objectForKey:@"title"];
    
//    self.currentPointY += kConstantTopPadding + _titleLabel.frame.size.height;
    
    [self addSubview:_titleLabel];
}

- (void)setupLocationPin {
    
    self.locationPinImage = [[UIImageView alloc]init];
    self.locationPinImage.image = [UIImage imageNamed:@"LocationpinIcon.png"];
//    self.locationPinImage.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 18, 18);
    [self addSubview:self.locationPinImage];
    
    self.locationPinLabel = [[UILabel alloc] init];
//    self.locationPinLabel.frame = CGRectMake(kConstantLeftPadding + self.locationPinImage.frame.size.width + 5, self.currentPointY, CGRectGetWidth(self.frame) - (kConstantLeftPadding * 3) - 18, 20);
    self.locationPinLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.locationPinLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    self.locationPinLabel.backgroundColor = [UIColor clearColor];
    self.locationPinLabel.text = [self.dataDictionary objectForKey:@"place_name"];
    
    [self addSubview:self.locationPinLabel];
    
//    self.currentPointY += kConstantTopPadding + self.locationPinImage.frame.size.height;
    
}

- (void)setupMessageLabel {
    
    if (![self.dataDictionary objectForKey:@"message"]) { return; }
    
    _messageLabel = [[UILabel alloc] init];
//    NSString *messageString = [[self.dataDictionary objectForKey:@"message"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    _messageLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
    
    [self addSubview:_messageLabel];
    
//    self.currentPointY += kConstantTopPadding + _messageLabel.frame.size.height;
}

- (void)setupTagTextField {
    
    if (!self.dataDictionary[@"tags"] || [self.dataDictionary[@"tags"] isEqualToString:@""]) {
        return;
    }
    
    NSString *rawTags = self.dataDictionary[@"tags"];
    
    NSString *tagString = [[rawTags stringByReplacingOccurrencesOfString:@"#[tag:" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];

    NSArray *tags = [tagString componentsSeparatedByString:@","];
    
    if (tags.count < 1) { return; }
    
//    self.tagsLabel = [[TLTagsControl alloc] initWithFrame:CGRectMake(kConstantLeftPadding, 0, 0, 0)];
    
    self.tagsLabel = [[TLTagsControl alloc] initWithFrame:CGRectMake(kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 30) andTags:tags withTagsControlMode:TLTagsControlModeList];
    
    self.tagsLabel.tapDelegate = self;
    self.tagsLabel.tagsBackgroundColor = [UIColor whiteColor];
    self.tagsLabel.tagsDeleteButtonColor = TWO_ZERO_FOUR_COLOR;
    self.tagsLabel.tagsTextColor = TWO_ZERO_FOUR_COLOR;
    
    [self.tagsLabel reloadTagSubviews];
    
    [self addSubview:self.tagsLabel];
    
    self.currentPointY += kConstantTopPadding + self.tagsLabel.frame.size.height;
}

- (void)setupProfilePictureImageView {
    
    self.profileImageView = [[AsyncImageView alloc] init];
//    userProfileImage.frame = CGRectMake(kConstantLeftPadding, self.currentPointY + 20, 38, 38);

    self.profileImageView.layer.backgroundColor = [[UIColor clearColor] CGColor];

    [Utils setRoundBorder:self.profileImageView color:[UIColor whiteColor] borderRadius:19 borderWidth:.0f];

    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDictionary[@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileButtonClicked:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.profileImageView setUserInteractionEnabled:YES];
    [self.profileImageView addGestureRecognizer:tapRecognizer];
    
    [self addSubview:self.profileImageView];
    
    self.usernameLabel = [[UILabel alloc] init];
    
    self.usernameLabel.text = self.dataDictionary[@"username"];
    self.usernameLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    self.usernameLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    [self addSubview:self.usernameLabel];
}

- (void)setupFollowingButton {
    
    self.followButton = [[UIButton alloc] init];
    self.followButton.frame = CGRectMake(0, 0, 120, 40);
    
    [self.followButton addTarget:self action:@selector(followButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.followButton];
}

- (void)setupBottomEmptyView {
    
    //for alignment purpose
    self.bottomEmptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self addSubview:self.bottomEmptyView];
}

- (void)reloadView {
    
    self.currentPointY = 0;
    
    [self updateTranslateButtonFrame];
    [self updateTitleFrame];
    [self updateLocationPin];
    [self updateMessageLabelFrame];
    [self updateTagLabelFrame];
    [self updateProfileViewFrame];
    [self updateFollowingButtonFrame];
    [self updateBottomEmptyView];
    
    [self resizeToFitSubviewsHeight];
}


#pragma mark - set frame method 

- (void)updateTranslateButtonFrame {
    [self.translateButton setFrame:CGRectMake(kConstantLeftPadding, kConstantTopPadding, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 40)];
    
    self.currentPointY += self.translateButton.frame.size.height + kConstantTopPadding;

}

- (void)updateTitleFrame {
    
    if (!self.titleLabel || ![self.dataDictionary objectForKey:@"title"]) {
        self.currentPointY += 10;
        
    }
    else {
        self.titleLabel.text = [self.dataDictionary objectForKey:@"translated_title"] ? [self.dataDictionary objectForKey:@"translated_title"] : [self.dataDictionary objectForKey:@"title"];
        self.titleLabel.frame = CGRectMake(kConstantLeftPadding + 3, self.currentPointY + kConstantTopPadding, (CGRectGetWidth(self.frame) - kConstantLeftPadding * 2), 25);
        self.currentPointY += kConstantTopPadding + _titleLabel.frame.size.height;
    }
}

- (void)updateLocationPin {
    
    self.locationPinImage.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 18, 18);

    self.locationPinLabel.frame = CGRectMake(kConstantLeftPadding + self.locationPinImage.frame.size.width + 5, self.currentPointY, CGRectGetWidth(self.frame) - (kConstantLeftPadding * 3) - 18, 20);

    self.currentPointY += kConstantTopPadding + self.locationPinImage.frame.size.height;

}

- (void)updateMessageLabelFrame {
    NSString *messageString = [self.dataDictionary objectForKey:@"translated_message"] ? [self.dataDictionary objectForKey:@"translated_message"] : [self.dataDictionary objectForKey:@"message"];
    
    [self.messageLabel setStandardText:[messageString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] numberOfLine:0];
    
    self.messageLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
    
    [self.messageLabel setFrame:CGRectMake(kConstantLeftPadding, self.currentPointY, 0, 0)];

    CGRect newRect = self.messageLabel.frame;

    newRect.size = [self.messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, CGFLOAT_MAX)];
    self.messageLabel.frame = newRect;
    
    self.currentPointY +=  CGRectGetHeight(newRect) + kConstantTopPadding;

}

- (void)updateTagLabelFrame {
    
    if (self.tagsLabel) {
        self.tagsLabel.frame = CGRectMake(kConstantLeftPadding, self.currentPointY + 5, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 30);
        [self.tagsLabel reloadTagSubviews];
        
        self.currentPointY += kConstantTopPadding + self.tagsLabel.frame.size.height + 15;
    }

}

- (void)updateProfileViewFrame {

    self.profileImageView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY , 38, 38);
    self.usernameLabel.frame = CGRectMake(CGRectGetMaxX(self.profileImageView.frame) + 10, self.currentPointY , 100, 38);
    
}

- (void)updateFollowingButtonFrame {
    
    BOOL following = [self.dataDictionary[@"following"] boolValue];
    
    if (!following) {
        [self.followButton setTitle:LocalisedString(@"Follow_") forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"ProfileFollowIcon.png"] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"FollowBtn.png"] forState:UIControlStateNormal];
    }
    else {
        [self.followButton setTitle:LocalisedString(@"Following_") forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:204.0f/255.0f blue:101.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"ProfileFollowingIcon.png"] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"FollowingBtn.png"] forState:UIControlStateNormal];
    }
    
    self.followButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 120 - 15, self.currentPointY, 120, 40);
    self.followButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.followButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:14];
    self.followButton.backgroundColor = [UIColor clearColor];

    self.currentPointY += self.followButton.frame.size.height;
}

- (void)updateBottomEmptyView {
    
    self.bottomEmptyView.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 15);
}

#pragma mark - button Event

- (void)translateButtonClicked:(id)sender {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:@"Translation?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    int i = 0;

    for (NSString *str in self.dataDictionary[@"translatable_languages"]) {
        
        UIAlertAction *translateButton = [UIAlertAction actionWithTitle:[Utils getLanguageName:str] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"tranlate!!");
            
            if ([self.delegate respondsToSelector:@selector(alertControllerClickedButtonAtIndex:)]) {
                [self.delegate alertControllerClickedButtonAtIndex:i];
            }
            
            self.isTranslatedText = YES;
        }];
        
        [alertViewController addAction:translateButton];
        
        i++;
    }
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:LocalisedString(@"No thanks!") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    
    [alertViewController addAction:cancelButton];

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

- (void)followButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FollowingButtonClicked:)]) {
        [self.delegate FollowingButtonClicked:sender];
    }
}


#pragma mark - TLTagsControlDelegate

- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagsLabel:tappedAtIndex:)]) {
        [self.delegate tagsLabel:tagsControl tappedAtIndex:index];
    }
}


- (void)profileButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileButtonClicked:)]) {
        [self.delegate profileButtonClicked:sender];
    }
    
}

@end

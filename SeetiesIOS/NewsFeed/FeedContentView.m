//
//  FeedContentView.m
//  Seeties
//
//  Created by Lai on 09/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedContentView.h"
#import "TLTagsControl.h"

static int kConstantLeftPadding   = 15;
static int kConstantTopPadding    = 15;

@interface FeedContentView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

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
    
        [self resizeToFitSubviewsHeight];
    }
    
    return self;
}

- (void)layoutSubviews {
    

}

- (void)setupTranslationButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //    [button setFrame:[self getViewFrameWithWidth:(CGRectGetWidth(self.frame) - 15 * 2) height:40 BesideView:nil]];
    
    [button setFrame:CGRectMake(kConstantLeftPadding, kConstantTopPadding, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, 40)];
    
    button.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [button setImage:[UIImage imageNamed:@"TranslateArrow.png"] forState:UIControlStateNormal];
    [button setTitle:LocalisedString(@"Translate") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(translateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
    [Utils setRoundBorder:button color:TWO_ZERO_FOUR_COLOR borderRadius:button.frame.size.height/2 borderWidth:1.0f];
    
    self.currentPointY += button.frame.size.height + kConstantTopPadding;
    
    [self addSubview:button];
}

- (void)setupCaptionTitle {
    
    if (![self.dataDictionary objectForKey:@"title"]) { return; }
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[self getViewFrameWithWidth:(CGRectGetWidth(self.view.frame) - kConstantLeftPadding * 2) height:25 BesideView:nil]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kConstantLeftPadding + 3, self.currentPointY + kConstantTopPadding, (CGRectGetWidth(self.frame) - kConstantLeftPadding * 2), 25)];
    
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:17];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f  blue:51.0f/255.0f  alpha:1.0f];
    
    _titleLabel.text = [self.dataDictionary objectForKey:@"title"];
    
    self.currentPointY += kConstantTopPadding + _titleLabel.frame.size.height;
    
    [self addSubview:_titleLabel];
}

- (void)setupLocationPin {
    
    UIImageView *locationPinImage = [[UIImageView alloc]init];
    locationPinImage.image = [UIImage imageNamed:@"LocationpinIcon.png"];
    locationPinImage.frame = CGRectMake(kConstantLeftPadding, self.currentPointY, 18, 18);
    [self addSubview:locationPinImage];
    
    UILabel *locationPinLabel = [[UILabel alloc] init];
    locationPinLabel.frame = CGRectMake(kConstantLeftPadding + locationPinImage.frame.size.width + 5, self.currentPointY, CGRectGetWidth(self.frame) - (kConstantLeftPadding * 3) - 18, 20);
    locationPinLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    locationPinLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    locationPinLabel.backgroundColor = [UIColor clearColor];
    locationPinLabel.text = [self.dataDictionary objectForKey:@"place_name"];
    
    [self addSubview:locationPinLabel];
    
    self.currentPointY += kConstantTopPadding + locationPinImage.frame.size.height;
    
}

- (void)setupMessageLabel {
    
    if (![self.dataDictionary objectForKey:@"message"]) { return; }
    
    _messageLabel = [[UILabel alloc] init];
    NSString *messageString = [self.dataDictionary objectForKey:@"message"];
    
    [_messageLabel setStandardText:messageString numberOfLine:0];
    
    _messageLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];

    CGRect labelFrame = CGRectMake(kConstantLeftPadding, self.currentPointY + 5, 0, 0);
    labelFrame.size = [_messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, CGFLOAT_MAX)];
    _messageLabel.frame = labelFrame;
    
    [self addSubview:_messageLabel];
    
    self.currentPointY += kConstantTopPadding + _messageLabel.frame.size.height;
}

- (void)setupTagTextField {
    
    if (!self.dataDictionary[@"tags"]) {
        return;
    }
    
    TLTagsControl *tagControl = [[TLTagsControl alloc] initWithFrame:CGRectMake(kConstantLeftPadding, self.currentPointY + 5, CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, CGFLOAT_MAX) andTags:self.dataDictionary[@"tags"] withTagsControlMode:TLTagsControlModeList];
    
    tagControl.tagsBackgroundColor = [UIColor whiteColor];
    tagControl.tagsDeleteButtonColor = TWO_ZERO_FOUR_COLOR;
    tagControl.tagsTextColor = TWO_ZERO_FOUR_COLOR;

    [self addSubview:tagControl];
}

- (void)reloadView {
    
    self.titleLabel.text = [self.dataDictionary objectForKey:@"translated_title"] ? [self.dataDictionary objectForKey:@"translated_title"] : [self.dataDictionary objectForKey:@"title"];
    
    [self.messageLabel setStandardText:[self.dataDictionary objectForKey:@"translated_message"] ? [self.dataDictionary objectForKey:@"translated_message"] : [self.dataDictionary objectForKey:@"message"] numberOfLine:0];
    
    self.messageLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f  blue:153.0f/255.0f  alpha:1.0f];
    
    CGRect newRect = self.messageLabel.frame;
    
    newRect.size = [self.messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - kConstantLeftPadding * 2, CGFLOAT_MAX)];
    self.messageLabel.frame = newRect;
    
    [self resizeToFitSubviewsHeight];
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
    
//    [alertViewController addAction:translateButton];
    [alertViewController addAction:cancelButton];
    
//    UIAlertAction *cancelButton2 = [UIAlertAction actionWithTitle:LocalisedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        return;
//    }];
//
//    [alertViewController addAction:cancelButton2];

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}



@end

//
//  FeedShopLocationView.m
//  Seeties
//
//  Created by Lai on 06/06/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedShopLocationView.h"

static int kConstantLeftPadding   = 15;
static int kConstantTopPadding    = 15;

@interface FeedShopLocationView ()

@property (assign, nonatomic) CGFloat currentPointY;

@end

@implementation FeedShopLocationView

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
        self.dataDictionary = dataDictionary;
        self.currentPointY = 0;
        
        [self setupTopGrayView];
        [self setupPlaceInfoSection];
        [self setupShopInfoView];
        [self setupViewShopButton];
        [self setupBottomGrayView];
        
        [self resizeToFitSubviewsHeight];
    }
    
    return self;
}

- (void)setupTopGrayView {
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 10)];
    
    
    grayView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:grayView];
    
    self.currentPointY += grayView.frame.size.height + 5;

}

- (void)setupPlaceInfoSection {
    
    UILabel *placeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kConstantLeftPadding, self.currentPointY, CGRectGetWidth(self.frame) - 70, 45)];
    
    placeInfoLabel.text = LocalisedString(@"About the place");
    placeInfoLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    placeInfoLabel.backgroundColor = [UIColor clearColor];
    placeInfoLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    [self addSubview:placeInfoLabel];

    UIButton *directionButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(placeInfoLabel.frame) + 5, self.currentPointY, 45, 45)];
    
    [directionButton setTitle:@"" forState:UIControlStateNormal];
//    [directionButton setBackgroundImage:[UIImage imageNamed:@"DirectionIcon"] forState:UIControlStateNormal];
//    theImageView.image = [theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [theImageView setTintColor:[UIColor redColor]];

//    directionButton.imageView.image = [directionButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [directionButton setTintColor:LINE_COLOR];

    [directionButton setImage:[UIImage imageNamed:@"PostGetDirectionIcon"] forState:UIControlStateNormal];
    [directionButton addTarget:self action:@selector(OpenDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:directionButton];
    
    self.currentPointY += directionButton.frame.size.height;
}

- (void)setupShopInfoView {
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 1)];
    topSeparatorView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:topSeparatorView];
    
    self.currentPointY += topSeparatorView.frame.size.height + 5;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 100)];
    
    UIImageView *shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kConstantLeftPadding, 10, 50, 50)];
    shopImageView.contentMode = UIViewContentModeCenter;
    
    NSString *imageURL = self.dataDictionary[@"shop_photo"];
    
    if ([imageURL length] > 0) {
        [shopImageView sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] completed:nil];
    }
    else {
        shopImageView.image = [UIImage imageNamed:@"SsDefaultDisplayPhoto"];
    }
    
    [Utils setRoundBorder:shopImageView color:OUTLINE_COLOR borderRadius:shopImageView.frame.size.width / 2];
    
    [view addSubview:shopImageView];
    
//    [view resizeToFitSubviews];
    
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shopImageView.frame) + kConstantLeftPadding, 10, CGRectGetWidth(self.frame) - CGRectGetMaxX(shopImageView.frame) - kConstantLeftPadding - 30, 30)];
    
    shopNameLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    shopNameLabel.backgroundColor = [UIColor clearColor];
    // ShowUserName.textColor = color;
    shopNameLabel.textColor = ONE_ZERO_TWO_COLOR;
    shopNameLabel.text = self.dataDictionary[@"shop_name"];
    
    [shopNameLabel sizeToFit];
    [view addSubview:shopNameLabel];
    
    if (![self.dataDictionary[@"seetieshop_id"] isEqualToString:@""]) {
        UIImageView *verifiedImageView = [[UIImageView alloc]init];
        verifiedImageView.image = [UIImage imageNamed:@"SSBlueVerifiedIcon.png"];
        verifiedImageView.frame = CGRectMake(CGRectGetMaxX(shopNameLabel.frame) + 3, 10, 15, 15);
        [view addSubview:verifiedImageView];
    }
    
    UILabel *shopDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(shopNameLabel.frame.origin.x, CGRectGetMaxY(shopNameLabel.frame) + 3, CGRectGetWidth(self.frame) - CGRectGetMaxX(shopImageView.frame) - kConstantLeftPadding - 30, 50)];

    shopDetailLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
    shopDetailLabel.textColor = TEXT_GRAY_COLOR;
    shopDetailLabel.text = self.dataDictionary[@"shop_address"];;
    shopDetailLabel.numberOfLines = 0;
    shopDetailLabel.backgroundColor = [UIColor clearColor];
    
    [shopDetailLabel sizeToFit];

    [view addSubview:shopDetailLabel];
    [view resizeToFitSubviews];

    self.currentPointY += view.frame.size.height + 10;
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 1)];
    
    bottomSeparatorView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:bottomSeparatorView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), view.frame.size.height)];
    
    [button setImage:[UIImage imageNamed:@"ArrowBtn"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:self action:@selector(viewShopButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];

    [self addSubview:view];

}

- (void)setupViewShopButton {
    
    UIButton *viewShopButton = [[UIButton alloc]init];
    viewShopButton.frame = CGRectMake(0, self.currentPointY + 1, CGRectGetWidth(self.frame), 50);
    [viewShopButton setTitle:@"View Seetishop" forState:UIControlStateNormal];
    [viewShopButton setBackgroundColor:[UIColor clearColor]];
    [viewShopButton.titleLabel setFont:[UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15]];
    [viewShopButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [viewShopButton addTarget:self action:@selector(viewShopButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:viewShopButton];
    
    self.currentPointY += viewShopButton.frame.size.height;

}

- (void)setupBottomGrayView {
    UIView *bottomGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.frame), 10)];
    
    bottomGrayView.backgroundColor = OUTLINE_COLOR;
    
    [self addSubview:bottomGrayView];

}

#pragma mark - button events

- (void)OpenDirectionButton:(id)sender {
    
    NSString *latlong = [[NSString alloc]initWithFormat:@"%@,%@",self.dataDictionary[@"lat"], self.dataDictionary[@"lng"]];
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *wazeButton = [UIAlertAction actionWithTitle:LocalisedString(@"Waze") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:@"waze://"]]) {
            
            // Waze is installed. Launch Waze and start navigation
            NSString *urlStr =
            [NSString stringWithFormat:@"waze://?ll=%@&navigate=yes",
             latlong];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            
        } else {
            
            // Waze is not installed. Launch AppStore to install Waze app
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
        }
    }];
    
    [alertViewController addAction:wazeButton];

    
    UIAlertAction *googleMapButton = [UIAlertAction actionWithTitle:LocalisedString(@"Google Maps") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            NSString *url = [NSString stringWithFormat: @"comgooglemaps://?q=%@&zoom=10",
                             latlong];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
            NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                             [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }];
    
    [alertViewController addAction:googleMapButton];
    
    UIAlertAction *appleMapsButton = [UIAlertAction actionWithTitle:LocalisedString(@"Apple Maps") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@", [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];

    [alertViewController addAction:appleMapsButton];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:LocalisedString(@"No thanks!") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    
    [alertViewController addAction:cancelButton];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

- (void)viewShopButtonDidClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewShopDetailButtonDidClicked:)]) {
        [self.delegate viewShopDetailButtonDidClicked:sender];
    }
}

@end

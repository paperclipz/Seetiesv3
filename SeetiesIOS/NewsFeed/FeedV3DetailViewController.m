//
//  FeedV3DetailViewController.m
//  Seeties
//
//  Created by Lai on 29/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedV3DetailViewController.h"
#import "AsyncImageView.h"
#import "iCarousel.h"
#import "DraftModel.h"
#import "FeedContentView.h"
#import "EmptyStateView.h"
#import "TranslationModel.h"
#import "IDMPhotoBrowser.h"
#import "ReportProblemViewController.h"

//static int kConstantLeftPadding   = 15;
//static int kConstantTopPadding    = 15;

@interface FeedV3DetailViewController () <iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, FeedContentViewDelegate, IDMPhotoBrowserDelegate>

//bottom view 
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *quickCollectButton;
@property (weak, nonatomic) IBOutlet UIButton *allCollectionButton;


@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//top view
@property (weak, nonatomic) IBOutlet UIView *topNavBar;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *topNavBarBackgroundImg;
@property (weak, nonatomic) IBOutlet UIButton *navBarMoreButton;


@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) FeedContentView *feedContentView;

@property (strong, nonatomic) EmptyStateView *loadingView;

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) DraftModel *postDetail;

@property (assign, nonatomic) BOOL isTranslatedText;
@property (assign, nonatomic) int currentPointY;

@property (strong, nonatomic) IDMPhotoBrowser *photoBrowser;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end

@implementation FeedV3DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLoadingIndicator];
    
    
    // Do any additional setup after loading the view.
    [self.bottomView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
    [self.topNavBar setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    self.topNavBarBackgroundImg.alpha = 0;
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.topNavBar];
    
    self.scrollView.delegate = self;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.currentPointY = CGRectGetMaxY(self.carousel.frame);
    
//    [self initializeView];
    
    [self getDataFromServer];
    
}

- (void)initializeLoadingIndicator {
    
    [LoadingManager show];
}

- (void)initializeView {
    
    //nav bar setting
    self.navBarTitle.text = [self.dataDictionary objectForKey:@"place_name"];
    self.navBarMoreButton.hidden = [self.dataDictionary objectForKey:@"uid"] == [Utils getUserID];
    
    [self setupCarousel];
    
    [self initializeContentSection];

    [self updateBottomViewLayout];
    
    [LoadingManager hide];
    
    self.imageArray = [NSMutableArray new];
    
    for (PhotoModel *photo in self.postDetail.arrPhotos) {
        IDMPhoto *idmPhoto = [IDMPhoto photoWithURL:[NSURL URLWithString:photo.imageURL]];
        [self.imageArray addObject:idmPhoto];
    }
    
    
}

- (void)setupCarousel {
    
    self.carousel.type = iCarouselTypeLinear;
    //    self.carousel.contentOffset.width = -20;
    self.carousel.pagingEnabled = YES;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.bounces = NO;
//    self.carousel.bounceDistance = 0.01;
    
    UIImageView *overlayImageView = [[UIImageView alloc]init];
    overlayImageView.image = [UIImage imageNamed:@"PostOverlay"];
    overlayImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.carousel.frame), CGRectGetHeight(self.carousel.frame));
    overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
    overlayImageView.layer.masksToBounds = YES;
    overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [self.carousel addSubview:overlayImageView];
    [self.carousel bringSubviewToFront:self.imageCountLabel];
}

- (void)initializeContentSection {
    
    self.feedContentView = [[FeedContentView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.view.frame), 500) withDataDictionary:self.dataDictionary];
    
    self.feedContentView.delegate = self;
    
//    [self.feedContentView resizeToFitSubviewsHeight];
    
    [self.contentView addSubview:self.feedContentView];
    
    [self reloadLayout];
//    [self.view resizeToFitSubviewsHeight];
//    [self.scrollView.contentSize resizeToFitSubviewsHeight];
//    [self setupCaptionTitle];
//    [self setupLocationPin];
//    [self setupMessageTextView];
}

- (void)reloadLayout {
    [self.contentView resizeToFitSubviewsHeight];
    [self.view resizeToFitSubviewsHeight];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.contentView.frame));
}


//- (CGRect)getViewFrameWithWidth:(CGFloat)width height:(CGFloat)height BesideView:(UIView *)besideView {
//    
//    CGRect rectSize;
//    
//    if (besideView) {
//        rectSize = CGRectMake(kConstantLeftPadding + CGRectGetWidth(besideView.frame), self.currentPointY, width, height);
//    }
//    else {
//        rectSize = CGRectMake(kConstantLeftPadding, self.currentPointY + kConstantTopPadding, width, height);
//        
//        self.currentPointY += height + kConstantTopPadding;
//    }
//    
//    return rectSize;
//}

- (void)updateBottomViewLayout {
    
    self.quickCollectButton.selected = (BOOL)[self.dataDictionary objectForKey:@"collect"];
    [self.quickCollectButton setTitle:self.quickCollectButton.selected ? @"  " : LocalisedString(@"Collect") forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    //[self.bottomView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.bottomAnchor constant:30];
    self.bottomView.hidden = NO;

}

- (void)viewDidAppear:(BOOL)animated {

}

#pragma mark - private method

- (NSString *)getLanguageCode {
    
    //    if (self.postDetail.content_languages.count < 1) { return @""; }
    
    NSString *userLanguageCode = [LanguageManager getDeviceAppLanguageCode];
    
    for (NSString *code in self.postDetail.content_languages) {
        if ([code isEqualToString:userLanguageCode]) {
            return code;
        }
    }
    
    return self.postDetail.content_languages[0]; //default language
}

#pragma mark - routing method

-(void)OpenReport {
    ReportProblemViewController *reportViewController = [[ReportProblemViewController alloc] init];
    [reportViewController initDataReportPost:self.postID];
    [self.navigationController pushViewController:reportViewController animated:YES];
}


#pragma mark - iCarousel Data Source

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.postDetail.arrPhotos.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(carousel.frame), CGRectGetHeight(carousel.frame))];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//        view.autoresizingMask = YES;
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    }
    
    //cancel any previously loading images for this view
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:view];
    
    PhotoModel *photo = [self.postDetail.arrPhotos objectAtIndex:index];
    
    //set image URL. AsyncImageView class will then dynamically load the image
    ((AsyncImageView *)view).imageURL = [[NSURL alloc] initWithString:photo.imageURL];
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return CGRectGetWidth(self.carousel.frame);
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
    self.imageCountLabel.text = [NSString stringWithFormat:@"%d / %ld", carousel.currentItemIndex + 1, (long)carousel.numberOfItems];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"selected %ld", (long)index);
    
    AsyncImageView *view = (AsyncImageView *)[self.carousel currentItemView];
    
    self.photoBrowser = [[IDMPhotoBrowser alloc] initWithPhotos:self.imageArray animatedFromView:view];
    self.photoBrowser.delegate = self;
    [self.photoBrowser setInitialPageIndex:index];
    self.photoBrowser.scaleImage = view.image;
    self.photoBrowser.usePopAnimation = YES;
    
    [self.view.window.rootViewController presentViewController:self.photoBrowser animated:YES completion:nil];

}

#pragma mark - IDMPhotoDelegate

//- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)index {
//    
//    [self.carousel scrollToItemAtIndex:index animated:NO];
//}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index {
    [self.carousel scrollToItemAtIndex:index animated:YES];

}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIView *view = [self.carousel currentItemView];
    
    if ([[view superview] autoresizingMask] != UIViewAutoresizingFlexibleHeight) {
        //code for cater stretching image when scrolling
        //AsyncImageView is wrapped with another view in carousel
        [[view superview] setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat imgWidth = CGRectGetWidth(self.carousel.frame);
    
    if (contentOffset >= 0 && contentOffset <= imgWidth) {
        self.topNavBarBackgroundImg.alpha = contentOffset / imgWidth;
    }
    
//    NSLog(@"carousel x:%f y:%f w:%f h:%f", self.carousel.frame.origin.x, self.carousel.frame.origin.y, self.carousel.frame.size.width,self.carousel.frame.size.height);
//    
//    NSLog(@"view x:%f y:%f w:%f h:%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
//
//    NSLog(@"scrollview y:%f", scrollView.contentOffset.y);

}

#pragma mark - Button Events



#pragma mark - Top Bar Button Events

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)navBarMoreButton:(id)sender {
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reportButton = [UIAlertAction actionWithTitle:LocalisedString(@"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"report user!!");
        [self OpenReport];
        
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:LocalisedString(@"SettingsPage_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    
    [alertViewController addAction:reportButton];
    [alertViewController addAction:cancelButton];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];

}

#pragma mark - Bottom Bar Button Events

- (IBAction)quickCollectionButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) { return; }
   
    [button setSelected:YES];
    [button setUserInteractionEnabled:NO];
    [button setTitle:@"  " forState:UIControlStateNormal];
    
//    AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
//    [self presentViewController:AddCollectionDataView animated:YES completion:nil];
//    [AddCollectionDataView GetPostID:GetPostID GetImageData:[UrlArray objectAtIndex:0]];

}

- (IBAction)allCollectionButtonClicked:(id)sender {
    NSLog(@"all collection pressed!!");
}

#pragma mark - FeedContentDelegate

- (void)alertControllerClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //reset translation text
    [self.dataDictionary removeObjectForKey:@"translated_title"];
    [self.dataDictionary removeObjectForKey:@"translated_message"];
    
    
    [self GetTranslatedData:buttonIndex];

//    if (buttonIndex == TranslateText) {
//        [self GetTranslatedData:buttonIndex];
//    }
//    else if (buttonIndex == ReadOrigin) {
//        [self.feedContentView reloadView];
//        [self reloadLayout];
//    }
}

#pragma mark - API caller

- (void)getDataFromServer {
    
    NSDictionary *dict = @{@"token": [Utils getAppToken] };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPostDetail parameter:dict appendString:self.postID success:^(id object) {
        
        NSLog(@"Success!");
        
        //dictionary for display content
        self.dataDictionary = [NSMutableDictionary new];
        
        self.postDetail = [[ConnectionManager dataManager] postDetailModel];
        
        self.imageCountLabel.text = [NSString stringWithFormat:@"1 / %lu", (unsigned long)self.postDetail.arrPhotos.count];
        
        //content
        NSString *languageCode = [self getLanguageCode];
        
        //title and message
        [self.dataDictionary addEntriesFromDictionary:self.postDetail.contents[languageCode]];
        
        //user id
        [self.dataDictionary setObject:self.postDetail.user_info.uid forKey:@"uid"];
        
        //location name
        [self.dataDictionary setObject:self.postDetail.place_name forKey:@"place_name"];
        
        //collect flag
        [self.dataDictionary setObject:self.postDetail.collect forKey:@"collect"];
        
        //like flag
        
        
        //translatable languages
        [self.dataDictionary setObject:self.postDetail.translatable_languages forKey:@"translatable_languages"];
        
        //Hash Tags
        [self.dataDictionary setObject:self.postDetail.tags forKey:@"tags"];
        
        [self initializeView];
        [self.carousel reloadData];
        
    } failure:^(id object) {
        NSLog(@"Failed!");
        
    }];
    
}

- (void)GetTranslatedData:(NSInteger)buttonIndex {
    
//    NSString *systemLanguageCheck = [LanguageManager getDeviceAppLanguageCode];
    
    [LoadingManager show];
    
    NSArray *translatableLanguage = self.dataDictionary[@"translatable_languages"];
    
    NSDictionary *dict = @{@"token" : [Utils getAppToken],
                           @"translate_language_code" : translatableLanguage[buttonIndex]};
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequeetTypeGetTranslatePost parameter:dict appendString:[NSString stringWithFormat:@"%@/translate", self.postID] success:^(id object) {
        
        TranslationModel *translationModel = [[ConnectionManager dataManager] translationModel];
        
        NSString *currentPostLanguageCode = [self getLanguageCode];
        
        NSDictionary *content = translationModel.translations[currentPostLanguageCode];
        
        if (content) {
            
//            [self.dataDictionary addEntriesFromDictionary:content];
            [self.dataDictionary setObject:content[@"title"] forKey:@"translated_title"];
            [self.dataDictionary setObject:content[@"message"] forKey:@"translated_message"];
            
            [self.feedContentView reloadView];
            [self reloadLayout];
            
            [LoadingManager hide];
        }

    } failure:^(id object) {

    
    }];
    
}




@end

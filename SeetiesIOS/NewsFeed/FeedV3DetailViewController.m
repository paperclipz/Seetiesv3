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
#import "CT3_SearchListingViewController.h"
#import "TLTagsControl.h"
#import "ProfileViewController.h"
#import "CustomItemSource.h"
#import "UIActivityViewController+Extension.h"
#import "FeedCommentView.h"
#import "CommentViewController.h"

//static int kConstantLeftPadding   = 15;
//static int kConstantTopPadding    = 15;

@interface FeedV3DetailViewController () <iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, FeedContentViewDelegate, IDMPhotoBrowserDelegate, FeedCommentViewDelegate>

//bottom view 
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *quickCollectButton;
@property (weak, nonatomic) IBOutlet UIButton *allCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


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
@property (strong, nonatomic) FeedCommentView *feedCommentView;

@property (strong, nonatomic) EmptyStateView *loadingView;

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableDictionary *userLikeDataDictionary;
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
    
    self.scrollView.canCancelContentTouches = NO;
    [self getDataFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    //[self.bottomView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.bottomAnchor constant:30];
    self.bottomView.hidden = NO;

}

#pragma mark - private method

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
    
    [self.contentView addSubview:self.feedContentView];
    
    [self.feedContentView reloadView];
    [self reloadLayout];
    
    self.currentPointY += self.feedContentView.frame.size.height + 3;
}

- (void)initializeCommentSection {
    
    if (self.feedCommentView) { return; }
    
    self.feedCommentView = [[FeedCommentView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.view.frame), 300) withDataDictionary:self.userLikeDataDictionary];
    self.feedCommentView.delegate = self;
    
    [self.feedCommentView reloadView];
    [self.contentView addSubview:self.feedCommentView];
    
    [self reloadLayout];
}

- (void)reloadLayout {
    
    //set this property = "YES" in order to replace contentView frame value calculated by autolayout with user-defined frame value
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self.feedCommentView setFrame:CGRectMake(0, CGRectGetMaxY(self.feedContentView.frame), CGRectGetWidth(self.view.frame), 300)];
    
    [self.feedContentView reloadView];
    [self.feedCommentView reloadView];
    
    
    [self.contentView resizeToFitSubviewsHeight];
    [self.view resizeToFitSubviewsHeight];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.contentView.frame));
    
}

- (void)updateBottomViewLayout {
    
    self.quickCollectButton.selected = (BOOL)[self.dataDictionary objectForKey:@"collect"];
    [self.quickCollectButton setTitle:self.quickCollectButton.selected ? @"  " : LocalisedString(@"Collect") forState:UIControlStateNormal];
    
    self.likeButton.selected = [self.dataDictionary[@"like"] boolValue];
}

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

#pragma mark - Top Bar Button Events

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)navBarMoreButton:(id)sender {
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reportButton = [UIAlertAction actionWithTitle:LocalisedString(@"Report") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"report user!!");
        [self openReportWithPostID:self.postID];
        
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:LocalisedString(@"SettingsPage_Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    
    [alertViewController addAction:reportButton];
    [alertViewController addAction:cancelButton];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
    
}

#pragma mark - Bottom Bar Button Events

- (IBAction)likeButtonClicked:(id)sender {
    
    //    if (self.likeButton.selected) {
    //        [self postLikePostData];
    //
    //    }
    //    else{
    [self postLikePostData];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.likeButton.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1.0);
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             self.likeButton.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
         }
                         completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                  usingSpringWithDamping:0.3
                                   initialSpringVelocity:1.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^
                              {
                                  self.likeButton.layer.transform = CATransform3DIdentity;
                              }
                                              completion:nil];
                         }];
    }];
    
    
    //    }
}

- (IBAction)commentButtonClicked:(id)sender {
    
}

- (IBAction)shareButtonClicked:(id)sender {
    //New Sharing Screen
    
    PhotoModel *imageToShare = self.postDetail.arrPhotos[0];
    
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    
    dataToPost.title = self.dataDictionary[@"translated_title"] ? self.dataDictionary[@"translated_title"] : self.dataDictionary[@"title"];
    dataToPost.shareID = self.postID;
    dataToPost.shareType = ShareTypePost;
    dataToPost.postImageURL = imageToShare.imageURL;
    
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
}

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

#pragma mark - routing method

-(void)openReportWithPostID:(NSString *)postID {
    ReportProblemViewController *reportViewController = [[ReportProblemViewController alloc] init];
    [reportViewController initDataReportPost:postID];
    [self.navigationController pushViewController:reportViewController animated:YES];
}

- (void)openProfileWithUserID:(NSString *)userID {
    ProfileViewController *profileVC = [ProfileViewController new];
    
    [self.navigationController pushViewController:profileVC animated:YES onCompletion:^{
        [profileVC initDataWithUserID:userID];
    }];
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

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index {
    [self.carousel scrollToItemAtIndex:index animated:YES];

}

#pragma mark - Scroll view delegate

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

#pragma mark - FeedContentDelegate

- (void)alertControllerClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //reset translation text
    [self.dataDictionary removeObjectForKey:@"translated_title"];
    [self.dataDictionary removeObjectForKey:@"translated_message"];
    
    
    [self GetTranslatedData:buttonIndex];
}

- (void)tagsLabel:(TLTagsControl *)tagsLabel tappedAtIndex:(NSInteger)index {
    
    CT3_SearchListingViewController *searchTagVC = [CT3_SearchListingViewController new];
    searchTagVC.keyword = [NSString stringWithFormat:@"#%@", [tagsLabel.tags objectAtIndex:index]];
    
    [self.navigationController pushViewController:searchTagVC animated:YES];

}

- (void)profileButtonClicked:(id)sender {
    
    [self openProfileWithUserID:self.dataDictionary[@"uid"]];
}

- (void)FollowingButtonClicked:(id)sender {
    NSString *logonUserID = [Utils getUserID];
    NSString *userID = self.dataDictionary[@"uid"];
    
    if (![userID isEqualToString:logonUserID]) {
        
        BOOL following = [self.dataDictionary[@"following"] boolValue];

        if (following) {
            
            NSString *tempStirng = [[NSString alloc]initWithFormat:@"%@ %@ ?",LocalisedString(@"Are you sure you want to quit following"), self.dataDictionary[@"username"]];
            
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:LocalisedString(@"Unfollow user") message:tempStirng preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *unfollowButton = [UIAlertAction actionWithTitle:LocalisedString(@"Yeah!") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //unfollow user
                [self postFollowingUserData];
            }];
            
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:LocalisedString(@"Maybe not.") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            
            [alertViewController addAction:unfollowButton];
            [alertViewController addAction:cancelButton];
            
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
        }
        else {
            [self postFollowingUserData];
        }
        

    }
    
}

#pragma mark - FeedCommentDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didClickedLink:(NSURL *)url {
    
    if ([url.scheme isEqualToString:@"like"]) {
        
        NSString *userID = url.host;
        
        if (userID && ![userID isEqualToString:@""]) {
            [self openProfileWithUserID:userID];
        }
        else {
            CommentViewController *CommentView = [[CommentViewController alloc]init];

            [self presentViewController:CommentView animated:YES completion:nil];
//            [CommentView GetCommentIDArray:CommentIDArray GetPostIDArray:PostIDArray GetMessageArray:MessageArray GetUser_Comment_uidArray:User_Comment_uidArray GetUser_Comment_nameArray:User_Comment_nameArray GetUser_Comment_usernameArray:User_Comment_usernameArray GetUser_Comment_photoArray:User_Comment_photoArray];
            [CommentView GetRealPostID:self.postID];
            [CommentView GetWhatView:@"Like"];
        }
        
    }
    else if ([url.scheme isEqualToString:@"comment"]) {
        
    }
    
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
        
        //user info
        [self.dataDictionary setObject:self.postDetail.user_info.uid forKey:@"uid"];
        [self.dataDictionary setObject:self.postDetail.user_info.username forKey:@"username"];
        [self.dataDictionary setObject:self.postDetail.user_info.profile_photo_images forKey:@"profile_pic"];

        //location name
        [self.dataDictionary setObject:self.postDetail.place_name forKey:@"place_name"];
        
        //collect flag
        [self.dataDictionary setObject:self.postDetail.collect forKey:@"collect"];
        
        //like flag
        [self.dataDictionary setObject:@(self.postDetail.like) forKey:@"like"];
        
        //translatable languages
        [self.dataDictionary setObject:self.postDetail.translatable_languages forKey:@"translatable_languages"];
        
        //Hash Tags
        [self.dataDictionary setObject:self.postDetail.tags forKey:@"tags"];
        
        //following flag
        [self.dataDictionary setObject:self.postDetail.following forKey:@"following"];
        
        [self getUserLikeDataFromServer];
        [self initializeView];
        [self.carousel reloadData];
        
    } failure:^(id object) {
        NSLog(@"Failed!");
        
    }];
    
}

- (void)getUserLikeDataFromServer {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];

    [paramDict setObject:self.postID forKey:@"post_id"];
    [paramDict setObject:[Utils getAppToken] forKey:@"token"];
    [paramDict setObject:@(30) forKey:@"list_size"];
    [paramDict setObject:@(1) forKey:@"page"];

    
//    NSDictionary *dict = @{@"token": [Utils getAppToken] };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPostLikes parameter:paramDict appendString:[NSString stringWithFormat:@"%@/like", self.postID] success:^(id object) {
        
//        NSDictionary *data = (NSDictionary *)object;
        self.userLikeDataDictionary = [NSMutableDictionary new];

        PostDetailLikeModel *postDetailLikeModel = [[ConnectionManager dataManager] postDetailLikeModel];

        [self.userLikeDataDictionary setObject:@(postDetailLikeModel.like_count) forKey:@"like_count"];
        [self.userLikeDataDictionary setObject:postDetailLikeModel.like_list forKey:@"like_list"];
        
        //total collections
        [self.userLikeDataDictionary setObject:@(self.postDetail.collection_count) forKey:@"collection_count"];
        
        
        [self getAllCommentData];
        

    } failure:^(id object) {
        NSLog(@"ASDF");
    }];
    
    
}

- (void)GetTranslatedData:(NSInteger)buttonIndex {
    
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
            
//            [self.feedContentView reloadView];
            [self reloadLayout];
            
            [LoadingManager hide];
        }

    } failure:^(id object) {

    
    }];
    
}

- (void)postFollowingUserData {
    
    NSDictionary *dict = @{@"token" : [Utils getAppToken],
                           @"uid" : [Utils getUserID]};
    
    BOOL following = [self.dataDictionary[@"following"] boolValue];
    AFNETWORK_TYPE type = following ? AFNETWORK_DELETE : AFNETWORK_POST;
    
    [[ConnectionManager Instance] requestServerWith:type serverRequestType:ServerRequestTypePostFollowUser parameter:dict appendString:[NSString stringWithFormat:@"%@/follow?token=%@", self.dataDictionary[@"uid"], [Utils getAppToken]] success:^(id object) {
        
        NSDictionary *data = (NSDictionary *)object;
        
        [self.dataDictionary removeObjectForKey:@"following"];
        
        [self.dataDictionary setObject:data[@"data"][@"following"] forKey:@"following"];
        
        [self.feedContentView reloadView];
        
    } failure:^(id object) {
        
    }];
}

-(void)postLikePostData
{
    NSString* appendString = [NSString stringWithFormat:@"%@/like", self.postID];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postID };
    
    BOOL isPostLike = [self.dataDictionary[@"like"] boolValue];
    AFNETWORK_TYPE type = isPostLike ? AFNETWORK_DELETE : AFNETWORK_POST;
    
    [[ConnectionManager Instance] requestServerWith:type serverRequestType:ServerRequestTypePostLikeAPost parameter:dict appendString:appendString success:^(id object) {
        
        NSDictionary *data = [[NSDictionary alloc]initWithDictionary:object];
        
        [self.dataDictionary removeObjectForKey:@"like"];
        [self.dataDictionary setObject:data[@"data"][@"like"] forKey:@"like"];
        
        self.likeButton.selected = [self.dataDictionary[@"like"] boolValue];
        
        [self.feedCommentView reloadView];
        
    } failure:^(id object) {
        
    }];
}

- (void)getAllCommentData {
    NSString* appendString = [NSString stringWithFormat:@"%@/comments", self.postID];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postID,
                           @"list_size" : @(30),
                           @"page" : @(1) };
    
//    BOOL isPostLike = [self.dataDictionary[@"like"] boolValue];
    AFNETWORK_TYPE type = AFNETWORK_GET;
    
    [[ConnectionManager Instance] requestServerWith:type serverRequestType:ServerRequestTypeGetPostComments parameter:dict appendString:appendString success:^(id object) {
        
        NSDictionary *data = [[NSDictionary alloc]initWithDictionary:object];
        
//        [self.dataDictionary removeObjectForKey:@"like"];
//        [self.dataDictionary setObject:data[@"data"][@"like"] forKey:@"like"];
//        
//        self.likeButton.selected = [self.dataDictionary[@"like"] boolValue];
        
        [self initializeCommentSection];

        
    } failure:^(id object) {
        
    }];

}

@end

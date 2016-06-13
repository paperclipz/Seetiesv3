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
#import "FeedType_CollectionSuggestedTblCell.h"
#import "FeedShopLocationView.h"
#import "FeedRecommendationView.h"
#import "SeetiesShopViewController.h"
#import "AddCollectionDataViewController.h"
#import "NearByRecommtationViewController.h"

//static int kConstantLeftPadding   = 15;
//static int kConstantTopPadding    = 15;

@interface FeedV3DetailViewController () <iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, FeedContentViewDelegate, IDMPhotoBrowserDelegate, FeedCommentViewDelegate, FeedShopLocationViewDelegate, FeedRecommendationViewDelegate>
{
    BOOL isMiddleOfCallingServer;
}

/*Feed Details All Views*/
@property(nonatomic,strong)FeedType_CollectionSuggestedTblCell* feedType_CollectionSuggestedTblCell;
@property (strong, nonatomic) FeedContentView *feedContentView;
@property (strong, nonatomic) FeedCommentView *feedCommentView;
@property (strong, nonatomic) FeedShopLocationView *feedShopLocationView;
@property (strong, nonatomic) FeedRecommendationView *feedRecommendationView;
/*Feed Details All Views*/

@property (nonatomic,strong)CollectionsModel* postCollectionsModel;
@property (nonatomic,strong)NSMutableArray<CollectionModel>* arrCollections;

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



@property (strong, nonatomic) EmptyStateView *loadingView;

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableDictionary *userLikeDataDictionary;
@property (strong, nonatomic) NSMutableDictionary *userCommentDataDictionary;
@property (strong, nonatomic) DraftModel *postDetail;

@property (assign, nonatomic) BOOL isTranslatedText;
@property (assign, nonatomic) int currentPointY;

@property (strong, nonatomic) IDMPhotoBrowser *photoBrowser;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *allViewSectionArray;

/*Controllers*/
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)CollectionViewController* displayCollectionViewController;

@end

@implementation FeedV3DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLoadingIndicator];
    
    self.allViewSectionArray = [NSMutableArray new];
    
    //initialise all dictionary
    self.dataDictionary = [NSMutableDictionary new];
    self.userLikeDataDictionary = [NSMutableDictionary new];

    
    // Do any additional setup after loading the view.
    [self.bottomView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
    [self.topNavBar setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    self.topNavBarBackgroundImg.alpha = 0;
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.topNavBar];
    
    self.scrollView.delegate = self;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.currentPointY = CGRectGetMaxY(self.carousel.frame);
    
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
    [self.feedType_CollectionSuggestedTblCell reloadData];

}

#pragma mark - Declaration

-(CollectionViewController*)displayCollectionViewController
{
    if (!_displayCollectionViewController) {
        _displayCollectionViewController = [CollectionViewController new];
    }
    
    return _displayCollectionViewController;
}

-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}

-(NSMutableArray<CollectionModel>*)arrCollections
{
    if(!_arrCollections)
    {
        _arrCollections = [NSMutableArray<CollectionModel> new];
    }
    return _arrCollections;
}

#pragma mark - private method

- (void)initializeLoadingIndicator {
    
    [LoadingManager show];
}

- (void)initializeView {
    
    [self updateTopViewLayout];
    
    [self setupCarousel];
    
    [self initializeContentSection];
    
    [self updateBottomViewLayout];
    
    [LoadingManager hide];
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
    
    self.imageArray = [NSMutableArray new];
    
    for (PhotoModel *photo in self.postDetail.arrPhotos) {
        IDMPhoto *idmPhoto = [IDMPhoto photoWithURL:[NSURL URLWithString:photo.imageURL]];
        [self.imageArray addObject:idmPhoto];
    }
}

- (void)initializeContentSection {
    
    self.feedContentView = [[FeedContentView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.view.frame), 500) withDataDictionary:self.dataDictionary];
    
    self.feedContentView.delegate = self;
    [self.contentView addSubview:self.feedContentView];
    [self.allViewSectionArray addObject:self.feedContentView];
//    [self.feedContentView reloadView];
//    [self repositionLayout];
    
//    self.currentPointY += self.feedContentView.frame.size.height + 3;
}

- (void)initializeCommentSection {
    
    if (self.feedCommentView) { return; }
    
    self.feedCommentView = [[FeedCommentView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.view.frame), 300) withDataDictionary:self.userLikeDataDictionary];
    self.feedCommentView.delegate = self;
    
//    [self.feedCommentView reloadView];
    [self.contentView addSubview:self.feedCommentView];
    [self.allViewSectionArray addObject:self.feedCommentView];

//    [self repositionLayout];
    
}

- (void)initializeShopLocationSection {
    //shop location
    self.feedShopLocationView = [[FeedShopLocationView alloc] initWithFrame:CGRectMake(0,self.currentPointY + 5, CGRectGetWidth(self.view.frame), 300) withDataDictionary:self.dataDictionary];
    
    self.feedShopLocationView.delegate = self;
    [self.contentView addSubview:self.feedShopLocationView];
    [self.allViewSectionArray addObject:self.feedShopLocationView];
    
//    [self repositionLayout];
}

- (void)initializeRecommendationSection:(BOOL)isNeedTop {
    
    NearbyRecommendationModel *model = [[ConnectionManager dataManager] nearbyRecommendationModel];
    
    if (model.recommendationPosts.count < 2) {
        return;
    }
    
    self.feedRecommendationView = [[FeedRecommendationView alloc] initWithFrame:CGRectMake(0, self.currentPointY, CGRectGetWidth(self.view.frame), 300) withModel:model isNeedTop:isNeedTop];
    self.feedRecommendationView.delegate = self;
    
    [self.contentView addSubview:self.feedRecommendationView];
    [self.allViewSectionArray addObject:self.feedRecommendationView];
    
}

- (void)repositionLayout {
    
    //set this property = "YES" in order to replace contentView frame value calculated by autolayout with user-defined frame value
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.currentPointY = 300; // carousel height = 300, start below that
    
    for (UIView *view in self.allViewSectionArray) {
        view.frame = CGRectMake(view.frame.origin.x, self.currentPointY, view.frame.size.width, view.frame.size.height);
        
        self.currentPointY += CGRectGetHeight(view.frame);
    }
    
    [self.contentView resizeToFitSubviewsHeight];
    [self.view resizeToFitSubviewsHeight];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.contentView.frame));
    
}

- (void)updateTopViewLayout {
    
    //nav bar setting
    self.navBarTitle.text = [self.dataDictionary objectForKey:@"place_name"];
    self.navBarMoreButton.hidden = [self.dataDictionary objectForKey:@"uid"] == [Utils getUserID];
}

- (void)updateBottomViewLayout {
    
    self.quickCollectButton.selected = [self.dataDictionary[@"collect"] boolValue];

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
    
    [self postCollectData];
    
//    [button setSelected:YES];
//    [button setUserInteractionEnabled:NO];
//    [button setTitle:@"  " forState:UIControlStateNormal];
    
}

- (IBAction)allCollectionButtonClicked:(id)sender {
    NSLog(@"all collection pressed!!");
    
    AddCollectionDataViewController *AddCollectionDataView = [[AddCollectionDataViewController alloc]init];
    
    [self presentViewController:AddCollectionDataView animated:YES completion:nil];
    
    PhotoModel *photo = [self.postDetail.arrPhotos objectAtIndex:0];
    
    [AddCollectionDataView GetPostID:self.postID GetImageData:photo.imageURL];

}

- (void)animateLikeButton {
    
    //    if (self.likeButton.selected) {
    //        [self postLikePostData];
    //
    //    }
    //    else{
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
    
    NSString *userID = url.host;
    
    if ([url.scheme isEqualToString:@"like"]) {
        
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
        
        [self openProfileWithUserID:userID];
    }
}

- (void)allActivitiesButtonDidClicked:(id)sender {
    
    CommentViewController *CommentView = [[CommentViewController alloc]init];

    [self presentViewController:CommentView animated:YES completion:nil];
//    [CommentView GetCommentIDArray:CommentIDArray GetPostIDArray:PostIDArray GetMessageArray:MessageArray GetUser_Comment_uidArray:User_Comment_uidArray GetUser_Comment_nameArray:User_Comment_nameArray GetUser_Comment_usernameArray:User_Comment_usernameArray GetUser_Comment_photoArray:User_Comment_photoArray];
    [CommentView GetRealPostID:self.postID];
    [CommentView GetWhatView:@"Comment"];
}

#pragma mark - FeedShopLocationDelegate

- (void)viewShopDetailButtonDidClicked:(id)sender {
    
    SeetiesShopViewController *shopVC = [[SeetiesShopViewController alloc] init];
    NSString *shopID = self.dataDictionary[@"seetieshop_id"];
    
    if (!shopID || [shopID isEqualToString:@""]) {
        [shopVC initDataPlaceID:self.dataDictionary[@"place_id"] postID:self.postID];
    }
    else {
        [shopVC initDataWithSeetiesID:shopID];
    }
    
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark - FeedRecommendationViewDelegate 

- (void)seeAllButtonClicked:(id)sender {
    
    NearByRecommtationViewController *NearByRecommtationView = [[NearByRecommtationViewController alloc]init];
    [self presentViewController:NearByRecommtationView animated:YES completion:nil];
//    [NearByRecommtationView GetLPhoto:PhotoArray_Nearby GetPostID:PostIDArray_Nearby GetPlaceName:PlaceNameArray_Nearby GetUserInfoUrl:UserInfo_UrlArray_Nearby GetUserInfoName:UserInfo_NameArray_Nearby GetTitle:TitleArray_Nearby GetMessage:MessageArray_Nearby GetDistance:DistanceArray_Nearby GetSearchDisplayName:SearchDisplayNameArray_Nearby GetTotalComment:TotalCommentArray_Nearby GetTotalLike:TotalLikeArray_Nearby GetSelfCheckLike:SelfCheckLikeArray_Nearby GetSelfCheckCollect:SelfCheckCollectArray_Nearby];

}

- (void)openPostDetail:(id)sender withPostID:(NSString *)postID {
    
}

- (void)openUserProfile:(id)sender withUserID:(NSString *)userID {
    [self openProfileWithUserID:userID];
}

#pragma mark - API caller

- (void)getDataFromServer {
    
    NSDictionary *dict = @{@"token": [Utils getAppToken] };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPostDetail parameter:dict appendString:self.postID success:^(id object) {
        
        NSLog(@"Success!");
        
        //dictionary for display content
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
        
        //seeties shop info
        if (self.postDetail.seetishop_info) {
            [self.dataDictionary setObject:self.postDetail.seetishop_info.name forKey:@"shop_name"];
            [self.dataDictionary setObject:self.postDetail.seetishop_info.location.formatted_address forKey:@"shop_address"];
            NSDictionary *imageDict = self.postDetail.seetishop_info.profile_photo;
            
            [self.dataDictionary setObject:imageDict[@"picture"] forKey:@"shop_photo"];
        }
        else {
            [self.dataDictionary setObject:self.postDetail.place_name forKey:@"shop_name"];
            [self.dataDictionary setObject:self.postDetail.place_formatted_address forKey:@"shop_address"];
        }
        
        [self.dataDictionary setObject:self.postDetail.seetishop_id forKey:@"seetieshop_id"];
        
        [self.dataDictionary setObject:self.postDetail.location.place_id forKey:@"place_id"];
        [self.dataDictionary setObject:self.postDetail.location.lat forKey:@"lat"];
        [self.dataDictionary setObject:self.postDetail.location.lng forKey:@"lng"];
        
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

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPostLikes parameter:paramDict appendString:[NSString stringWithFormat:@"%@/like", self.postID] success:^(id object) {

        PostDetailLikeModel *postDetailLikeModel = [[ConnectionManager dataManager] postDetailLikeModel];

        [self.userLikeDataDictionary removeAllObjects];
        
        [self.userLikeDataDictionary setObject:@(postDetailLikeModel.like_count) forKey:@"like_count"];
        [self.userLikeDataDictionary setObject:postDetailLikeModel.like_list forKey:@"like_list"];
        
        //total collections
        [self.userLikeDataDictionary setObject:@(self.postDetail.collection_count) forKey:@"collection_count"];
        
        [self getAllCommentData];
        
    } failure:^(id object) {
        NSLog(@"ASDF");
    }];
}

-(void)requestServerForPostSuggestedCollection
{
    SLog(@"requestServerForSuggestedCollection");
 
    isMiddleOfCallingServer = true;
    
    NSString* postID = self.postDetail.post_id;
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collect_suggestions",postID];
    
    NSDictionary* dict = @{@"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.postCollectionsModel.offset + self.postCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           @"post_id" : postID,
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetPostCollectSuggestion parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.postCollectionsModel = [[ConnectionManager dataManager]postCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.postCollectionsModel.arrSuggestedCollection];
        
        BOOL isNeedTop = NO;
        if (!self.feedType_CollectionSuggestedTblCell) {
            
            if (![Utils isArrayNull:self.arrCollections]) {
                [self getAllCollectionData];
                
                isNeedTop = YES;

            }
        }

        [self getRecommendationData:isNeedTop];
        
        [self repositionLayout];
        
    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        
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
            
            [self.feedContentView reloadView];
            [self repositionLayout];
            
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
        
        [self.feedContentView reloadFollowingButton];
        
    } failure:^(id object) {
        
    }];
}

-(void)postLikePostData
{
    
    if ([Utils isGuestMode]) {
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To Like") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }
    
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
        
        [self animateLikeButton];
        [self getUserLikeDataFromServer];
        
    } failure:^(id object) {
        
    }];
}

- (void)getAllCommentData {
    NSString* appendString = [NSString stringWithFormat:@"%@/comments", self.postID];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postID,
                           @"list_size" : @(30),
                           @"page" : @(1) };
    
    AFNETWORK_TYPE type = AFNETWORK_GET;
    
    [[ConnectionManager Instance] requestServerWith:type serverRequestType:ServerRequestTypeGetPostComments parameter:dict appendString:appendString success:^(id object) {
        
        PostDetailCommentModel *model = [[ConnectionManager dataManager] postDetailCommentModel];
        
        [self.userLikeDataDictionary setObject:model.comments forKey:@"comments"];
        
        if (self.feedCommentView) {
            [self.feedCommentView reloadView];
        }
        else {
            [self initializeCommentSection];
            [self initializeShopLocationSection];
        }
        
        [self repositionLayout];

        [self requestServerForPostSuggestedCollection];
        
    } failure:^(id object) {
        
    }];

}

- (void)getRecommendationData:(BOOL)isNeedTop {
    
    NSString* appendString = [NSString stringWithFormat:@"%@/nearbyposts", self.postID];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"post_id" : self.postID };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetNearbyPost parameter:dict appendString:appendString success:^(id object) {
        
        if (!self.feedRecommendationView) {
            [self initializeRecommendationSection:isNeedTop];
        }
        
        [self repositionLayout];
        
    } failure:^(id object) {
        
    }];
}

- (void)postCollectData {
    
    NSDictionary* dictPost =  @{@"id": self.postID ? self.postID : @""};
    
    NSArray* array = @[dictPost];
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/0/collect", [Utils getUserID]];
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"posts" : array };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_PUT serverRequestType:ServerRequestTypePostCollectState parameter:dict appendString:appendString success:^(id object) {

        [self.quickCollectButton setSelected:YES];
        [self.quickCollectButton setUserInteractionEnabled:NO];
        [self.quickCollectButton setTitle:@"  " forState:UIControlStateNormal];

        [MessageManager showMessage:LocalisedString(@"Successfully collected to default Collection") Type:STAlertSuccess];

//        [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success add to Collections" type:TSMessageNotificationTypeSuccess];

        
    } failure:^(id object) {
        
    }];

}

-(void)getAllCollectionData
{
    self.feedType_CollectionSuggestedTblCell = [[FeedType_CollectionSuggestedTblCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [self.contentView addSubview:self.feedType_CollectionSuggestedTblCell];
    [self.feedType_CollectionSuggestedTblCell adjustToScreenWidth];
    [self.feedType_CollectionSuggestedTblCell setY:self.feedCommentView.frame.size.height + self.feedCommentView.frame.origin.y];
//    [self.contentView resizeToFitSubviewsHeight];
//    [self.view resizeToFitSubviewsHeight];
//    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.contentView.frame));
    
    [self.feedType_CollectionSuggestedTblCell initData:self.arrCollections];
    
    __weak typeof(self)weakSelf = self;
    
    self.feedType_CollectionSuggestedTblCell.btnSeeAllSuggestedCollectionClickBlock = ^(void)
    {
        [weakSelf showCollectionListingView];
    };
    
    self.feedType_CollectionSuggestedTblCell.didSelectCollectionBlock = ^(CollectionModel* model)
    {
        [weakSelf showCollectioPageView:model];
    };
    
    [self.allViewSectionArray addObject:self.feedType_CollectionSuggestedTblCell];
}

-(void)showCollectionListingView
{
    _collectionListingViewController = nil;
    
    [self.collectionListingViewController setTypePostSuggestion:self.postID];
    
    [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
}

-(void)showCollectioPageView:(CollectionModel*)model
{
    
    _displayCollectionViewController = nil;
    [self.navigationController pushViewController:self.displayCollectionViewController animated:YES onCompletion:^{
        [self.displayCollectionViewController GetCollectionID:model.collection_id GetPermision:@"Others" GetUserUid:model.user_info.uid];
    }];
    
}

@end

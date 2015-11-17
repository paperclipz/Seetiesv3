//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIScrollView+APParallaxHeader.h"
//cell
#import "ProfilePageCollectionTableViewCell.h"
#import "ProfilePagePostTableViewCell.h"
#import "ProfilePageCollectionHeaderView.h"
#import "ProfilePageCollectionFooterTableViewCell.h"
#import "ProfileNoItemTableViewCell.h"
#import "JTSImageViewController.h"
#import "UITableView+Extension.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    NSMutableArray* arrayTag;
    NSMutableArray* arrCollection;
    NSMutableArray* arrPost;
    NSMutableArray* arrLikes;
    
    __weak IBOutlet NSLayoutConstraint *followButtonConstraint;
}

// =======  OUTLET   =======
@property (weak, nonatomic) IBOutlet UIImageView *ibImgViewOtherPadding;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet TLTagsControl *ibTagControlView;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
//profile page table view
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) ProfilePageCollectionHeaderView *profilePageCollectionHeaderView1;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIView *ibSettingContentView;
@property (strong, nonatomic) IBOutlet UIView *ibSettingOtherView;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowing;
@property (weak, nonatomic) IBOutlet UIButton *btnFollower;
@property (weak, nonatomic) IBOutlet UIButton *btnLink;

// =======  OUTLET   =======
// =======  MODEL   =======

@property(nonatomic,strong)ProfileModel* userProfileModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)ProfilePostModel* userProfileLikeModel;
@property (nonatomic,strong)UIImageView* loadingImageView;
@property (nonatomic,assign)ProfileViewType profileViewType;
@property (nonatomic,strong)NSString* userID;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

// =======  MODEL   =======

@end

@implementation ProfileViewController

- (IBAction)btnFollowClicked:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    
    [self requestServerToFollowUser:self.userProfileModel.following];
    // [self setFollowButtonSelected:button.selected button:button];
}

-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button
{
    button.selected = selected;
    
    button.backgroundColor = selected?[UIColor whiteColor]:SELECTED_GREEN;
    
}

- (IBAction)btnLinkClicked:(id)sender {
    
    [[[UIActionSheet alloc] initWithTitle:self.btnLink.titleLabel.text delegate:self cancelButtonTitle:LocalisedString(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:LocalisedString(@"Open Link in Safari"), nil] showInView:self.view];
    
}

#pragma mark - IBACTION
- (IBAction)btnFollowingClicked:(id)sender {
    
    _showFollowerAndFollowingViewController = nil;
    [self.navigationController pushViewController:self.showFollowerAndFollowingViewController animated:YES onCompletion:^{
        [self.showFollowerAndFollowingViewController GetToken:[Utils getAppToken] GetUID:self.userID GetType:@"Following"];
        
    }];
    
}
- (IBAction)btnFollowerClicked:(id)sender {
    
    _showFollowerAndFollowingViewController = nil;
    [self.navigationController pushViewController:self.showFollowerAndFollowingViewController animated:YES onCompletion:^{
        [self.showFollowerAndFollowingViewController GetToken:[Utils getAppToken] GetUID:self.userID GetType:@"Follower"];
        
    }];
    
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    
    SLog(@"profileImageTap");
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.ibImgProfilePic.image;
    imageInfo.referenceRect = self.ibImgProfilePic.frame;
    imageInfo.referenceView = self.ibImgProfilePic.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (IBAction)btnSearchClicked:(id)sender {
    
    _searchViewV2Controller = nil;
    [self.navigationController pushViewController:self.searchViewV2Controller animated:NO];
    
}

- (IBAction)btnEditProfileClicked:(id)sender {
    
    
    _editProfileV2ViewController = nil;
    [self.editProfileV2ViewController initData:self.userProfileModel];
    [self.navigationController pushViewController:self.editProfileV2ViewController animated:YES];
    
}
- (IBAction)btnShareClicked:(id)sender {
    
    _shareViewController = nil;
    
    //        [self.shareViewController GetShareProfile:self.userProfileModel.username];
    
    
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self.shareViewController];
    formSheetController.presentationController.contentViewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    
    [self presentViewController:formSheetController animated:YES completion:nil];
    
}

- (IBAction)btnSettingClicked:(id)sender {
    
    [self.navigationController pushViewController:self.settingsViewController animated:YES];
    
}

- (IBAction)btnSegmentedControlClicked:(id)sender {
}


#pragma mark - DEFAULT VIEW LOAD
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSelfView];
    [self registerNotification];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:NOTIFICAION_TYPE_REFRESH_COLLECTION
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:NOTIFICAION_TYPE_REFRESH_POST
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:NOTIFICAION_TYPE_REFRESH_LIKES
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:NOTIFICAION_TYPE_REFRESH_PROFILE
                                               object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    
    self.ibImgViewOtherPadding.alpha = 0;
    if (self.profileViewType == ProfileViewTypeOwn) {
        
        self.btnFollow.hidden = YES;
        
    }
    else{
        self.btnEditProfile.hidden = YES;
        followButtonConstraint.constant = 8.0f;
        
        [self.btnFollow setTitle:LocalisedString(@"Follow") forState:UIControlStateNormal];
        [self.btnFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnFollow setTitle:LocalisedString(@"Following") forState:UIControlStateSelected];
        [self.btnFollow setTitleColor:SELECTED_GREEN forState:UIControlStateSelected];
        
    }
    [self initTagView];
    [self initProfilePageCell];
    
    [Utils setRoundBorder:self.btnEditProfile color:TWO_ZERO_FOUR_COLOR borderRadius:self.btnEditProfile.frame.size.height/2 borderWidth:0.5f];
    [Utils setRoundBorder:self.btnFollow color:SELECTED_GREEN borderRadius:self.btnFollow.frame.size.height/2 borderWidth:0.5f];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupProfileImages];
    
    // add parallax view with top content and content
    
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    float imageFrameHeight = self.ibImgProfilePic.frame.size.height;
    
    self.ibContentView.frame = CGRectMake(self.ibContentView.frame.origin.x, self.ibContentView.frame.origin.y - imageFrameHeight/2, frame.size.width, self.ibContentView.frame.size.height);
    [self setParallaxView];
    self.ibScrollView.contentSize = CGSizeMake(self.ibScrollView.frame.size.width, self.ibContentView.frame.size.height);
    [self.ibScrollView addSubview:self.ibContentView];
    self.ibScrollView.delegate = self;
    
    [self adjustTableView];
    //  [self addSearchView];
    [self changeLanguage];
    
}

-(void)setupProfileImages
{
    [Utils setRoundBorder:self.ibImgProfilePic color:[UIColor whiteColor] borderRadius:self.ibImgProfilePic.frame.size.width/2 borderWidth:6.0f];
    
    //    //set image from url
    //    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://www.ambwallpapers.com/wp-content/uploads/2015/02/scarlett-johansson-wallpapers-2.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];
    //
    //    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //        self.backgroundImageView.image = [image imageCroppedAndScaledToSize:self.backgroundImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
    //
    //    }];
}
//
//-(void)addSettingAndShareView// need to add after
//{
//
//    float buttonYAxis = self.btnSearch.frame.origin.y + self.btnSearch.frame.size.height + 20;
//    UIButton* btnShare = [[UIButton alloc]initWithFrame:CGRectMake(self.ibScrollView.parallaxView.frame.size.width - 40 -10, buttonYAxis, 40, 40)];
//    [btnShare setImage:[UIImage imageNamed:@"ProfileShareIcon.png"] forState:UIControlStateNormal];
//
//    UIButton* btnSetting = [[UIButton alloc]initWithFrame:CGRectMake(btnShare.frame.origin.x - btnShare.frame.size.width , buttonYAxis, 40, 40)];
//    [btnSetting setImage:[UIImage imageNamed:@"ProfileSettingsIcon.png"] forState:UIControlStateNormal];
//
//
//    [btnSetting addTarget:self action:@selector(btnSettingClicked:) forControlEvents: UIControlEventTouchUpInside];
//     [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents: UIControlEventTouchUpInside];
//
//    [self.ibScrollView.parallaxView addSubview:btnSetting];
//    [self.ibScrollView.parallaxView bringSubviewToFront:btnSetting];
//
//    [self.ibScrollView.parallaxView addSubview:btnShare];
//    [self.ibScrollView.parallaxView bringSubviewToFront:btnShare];
//}

-(void)addSearchView
{
    
    if (self.profileViewType == ProfileViewTypeOwn) {
        [self.ibScrollView.parallaxView addSubview:self.ibSettingContentView];
        [self.ibScrollView.parallaxView bringSubviewToFront:self.ibSettingContentView];
        [self.ibSettingContentView adjustToScreenWidth];
    }
    else{
        
        [self.ibScrollView.parallaxView addSubview:self.ibSettingOtherView];
        self.ibImgViewOtherPadding.alpha = 0;
        [self.ibScrollView.parallaxView bringSubviewToFront:self.ibSettingOtherView];
        [self.ibSettingOtherView adjustToScreenWidth];
    }
    
}

#pragma mark - Request all Data
-(void)requestAllDataWithType:(ProfileViewType)type UserID:(NSString*)uID
{
    
    self.profileViewType = type;
    self.userID = uID;
    [self requestServerForUserInfo];
   [self requestServerForUserCollection];
    [self requestServerForUserPost];
    [self requestServerForUserLikes];
}

-(void)adjustTableView
{
    
    int collectionHeight = arrCollection.count>0?(int)([ProfilePageCollectionTableViewCell getHeight]*(arrCollection.count>3?3:arrCollection.count)):[ProfileNoItemTableViewCell getHeight];
    //  int postAndLikesHeight = (int)([ProfilePagePostTableViewCell getHeight]*((arrPost.count>0?1:0) + (arrLikes.count>0?1:0)));
    int postAndLikesHeight = (arrPost.count>0?[ProfilePagePostTableViewCell getHeight]:[ProfileNoItemTableViewCell getHeight]) + (arrLikes.count>0?[ProfilePagePostTableViewCell getHeight]:[ProfileNoItemTableViewCell getHeight]);
    
    int cellHeaderHeight = 3*[ProfilePageCollectionHeaderView getHeight];
    int count = (arrCollection.count>0?1:0) + (arrPost.count>0?1:0) + (arrLikes.count>0?1:0);
    int cellFooterHeight = [ProfilePageCollectionFooterTableViewCell getHeight]*(count);
    
    self.ibTableView.frame = CGRectMake(self.ibTableView.frame.origin.x, self.ibTableView.frame.origin.y, self.ibTableView.frame.size.width, collectionHeight + postAndLikesHeight + cellHeaderHeight + cellFooterHeight + 5);
    
    self.ibContentView.frame = CGRectMake(self.ibContentView.frame.origin.x, self.ibContentView.frame.origin.y, self.ibContentView.frame.size.width, self.ibTableView.frame.origin.y +self.ibTableView.frame.size.height);
    
    self.ibScrollView.contentSize = CGSizeMake(self.ibScrollView.frame.size.width, self.ibContentView.frame.size.height- self.ibImgProfilePic.frame.size.height/2);
    
}


#pragma mark - Cell
-(void)initProfilePageCell
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
}
#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (arrCollection.count>3) {
            return 4;
        }
        else{
            return arrCollection.count+1;
        }
    }
    else if(section == 1)
    {
        
        if (arrPost.count>0) {
            return 1+1;
        }
        return 0+1;
    }
    else if (section == 2)
    {
        if (arrLikes.count>0) {
            return 1+1;
            
        }
        return 0+1;
        
    }
    else
        return 1;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        if (!arrCollection.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == arrCollection.count || indexPath.row == 3) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }
        
        return [ProfilePageCollectionTableViewCell getHeight];
    }
    else if (indexPath.section == 1){
        if (!arrPost.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == 1) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }
        
        return [ProfilePagePostTableViewCell getHeight];
        
    }
    else if (indexPath.section == 2){
        
        if (!arrLikes.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == 1) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }
        
        return [ProfilePagePostTableViewCell getHeight];
        
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return [ProfilePageCollectionHeaderView getHeight];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    ProfilePageCollectionHeaderView* headerView = [ProfilePageCollectionHeaderView initializeCustomView];
    [headerView adjustRoundedEdge:self.ibTableView.frame];
    
    if (section == 0) {
        [headerView setHeaderViewWithCount:self.userCollectionsModel.total_result type:1];
        
    }else if(section == 1)
    {
        [headerView setHeaderViewWithCount:self.userProfilePostModel.userPostData.total_posts type:2];
    }
    else
    {
        
        [headerView setHeaderViewWithCount:self.userProfileLikeModel.userPostData.total_posts type:3];
        
    }
    
    headerView.btnSeeAllClickedBlock = ^(void){
        [self didSelectFooterAtIndex:[NSIndexPath indexPathForRow:0 inSection:section]];
    };
    
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if ( ! arrCollection.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];
            [cell setViewType:0];
            return cell;
        }
        else if (indexPath.row==arrCollection.count || indexPath.row == 3) {
            
            static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
            ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
            
            if (!cell) {
                cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.btnSeeAllClickedBlock = ^(void)
            {
                [self didSelectFooterAtIndex:indexPath];
                
            };
            
            [cell adjustRoundedEdge:self.ibTableView.frame];
            return cell;
        }
        else{
            
            static NSString* cellIndenfier1 = @"ProfilePageCollectionTableViewCell";
            ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier1];
            
            if (!cell) {
                cell = [[ProfilePageCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier1];
            }
            
            CollectionModel* colModel = arrCollection[indexPath.row];
            cell.btnEditClickedBlock = ^(void)
            {
                [self didSelectEditAtIndexPath:indexPath];
            };
            
            cell.btnFollowBlock = ^(void)
            {
                [self requestServerToFollowCollection:colModel];
            };
            
            cell.btnShareClicked = ^(void)
            {
                [self showShareView:colModel];
            };
            [cell initData:colModel profileType:self.profileViewType];
            
            return cell;
        }
        
    }
    
    else if(indexPath.section == 1)
    {
        
        if (!arrPost.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];
            [cell setViewType:1];
            
            return cell;
        }
        else if (indexPath.row == 1) {
            
            static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
            ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
            
            if (!cell) {
                cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];
            
            cell.btnSeeAllClickedBlock = ^(void)
            {
                [self didSelectFooterAtIndex:indexPath];
                
            };
            return cell;
        }
        else{
            static NSString* cellIndenfier2 = @"ProfilePagePostTableViewCell";
            ProfilePagePostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier2];
            
            if (!cell) {
                cell = [[ProfilePagePostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier2];
            }
            [cell initData:arrPost];
            return cell;
            
        }
    }
    
    else if (indexPath.section == 2)
    {
        
        if (!arrLikes.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];
            [cell setViewType:2];
            
            return cell;
        }
        
        else if (indexPath.row== 1) {
            
            static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
            ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
            
            if (!cell) {
                cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];
            
            cell.btnSeeAllClickedBlock = ^(void)
            {
                [self didSelectFooterAtIndex:indexPath];
                
            };
            return cell;
            
        }
        
        else{
            
            static NSString* cellIndenfier2 = @"ProfilePagePostTableViewCell";
            
            ProfilePagePostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier2];
            
            
            if (!cell) {
                
                cell = [[ProfilePagePostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier2];
                
            }
            
            [cell initData:arrLikes];
            
            return cell;
            
        }
    }
    
    
    return nil;
    
    
}

-(void)didSelectFooterAtIndex:(NSIndexPath*)indexPath
{
    
    
    SLog(@"index path section : %ld",(long)indexPath.section);
    switch (indexPath.section) {
            
        default:
        case 0://collection
            
            if ([arrCollection isNull]) {
                return;
            }
            _collectionListingViewController = nil;
            [self.collectionListingViewController setType:self.profileViewType ProfileModel:self.userProfileModel];
            [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
            break;
        case 1://post
        {
            if ([arrPost isNull]) {
                return;
            }
            
            _postListingViewController = nil;
            [self.postListingViewController initData:self.userProfilePostModel UserProfileModel:self.userProfileModel ProfileViewType:self.profileViewType];
            [self.navigationController pushViewController:self.postListingViewController animated:YES];
            
            self.postListingViewController.btnAddMorePostBlock = self.btnAddMorePostClickedBlock;
        }
            
            break;
        case 2://likes
        {
            
            if ([arrLikes isNull]) {
                return;
            }
            
            _likesListingViewController = nil;
            [self.likesListingViewController initData:self.userProfileLikeModel];
            self.likesListingViewController.userID = self.userID;
            [self.navigationController pushViewController:self.likesListingViewController animated:YES];
        }
            break;
    }
}

-(void)didSelectEditAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        
        CollectionModel* collModel = self.userCollectionsModel.arrCollections[indexPath.row];
        [self showEditCollectionViewWithCollectionID:collModel.collection_id];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (![self.userCollectionsModel.arrCollections isNull]) {
            
            if (indexPath.row < self.userCollectionsModel.arrCollections.count) {
                CollectionModel* collModel = self.userCollectionsModel.arrCollections[indexPath.row];
                
                [self showCollectionDisplayViewWithCollectionID:collModel.collection_id];
            }
            
        }
        
    }
    
}

#pragma  mark - Show Collection - Post - Likes

-(void)showCollectionDisplayViewWithCollectionID:(NSString*)collID
{
    _collectionViewController = nil;
    [self.collectionViewController GetCollectionID:collID GetPermision:@"self"];
    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}

-(void)showEditCollectionViewWithCollectionID:(NSString*)collID
{
    _editCollectionViewController = nil;
    [LoadingManager show];
    [self.editCollectionViewController initData:collID ProfileType:self.profileViewType];
    [LoadingManager show];
    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
}

#pragma mark - Tag
-(void)initTagView
{
    //  arrayTag = [[NSMutableArray alloc]initWithArray:@[@"111",@"222",@"333",@"111",@"222",@"333",@"111",@"222",@"333"]];
    // _ibTagControlView.tags = arrayTag;
    _ibTagControlView.mode = TLTagsControlModeList;
    _ibTagControlView.tagPlaceholder = @"Tag";
    [_ibTagControlView setTapDelegate:self];
    _ibTagControlView.tagsTextColor = TEXT_GRAY_COLOR;
    _ibTagControlView.tagsBackgroundColor = [UIColor whiteColor];
    [_ibTagControlView reloadTagSubviewsCustom];
}

- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index
{
    
    _searchDetailViewController = nil;
    [self.navigationController pushViewController:self.searchDetailViewController animated:YES onCompletion:^{
        
        [self.searchDetailViewController GetSearchKeyword:tagsControl.tags[index] Getlat:nil GetLong:nil GetLocationName:nil GetCurrentLat:nil GetCurrentLong:nil];
    }];
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

#pragma mark - Declaration
-(UIImageView*)loadingImageView
{
    if(!_loadingImageView)
    {
        _loadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loadingImageView.animationImages = @[[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"3.png"]];
        _loadingImageView.animationDuration = 1.0f;
        _loadingImageView.animationRepeatCount = 100;
        
        
    }
    return _loadingImageView;
}
-(ShareViewController*)shareViewController
{
    if(!_shareViewController)
    {
        _shareViewController = [ShareViewController new];
    }
    
    return _shareViewController;
}

-(UIImageView*)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 212)];
        [_backgroundImageView adjustToScreenWidth];
    }
    
    return _backgroundImageView;
}
-(SearchDetailViewController*)searchDetailViewController
{
    if (!_searchDetailViewController) {
        _searchDetailViewController = [SearchDetailViewController new];
    }
    
    return _searchDetailViewController;
}

-(ShowFollowerAndFollowingViewController*)showFollowerAndFollowingViewController
{
    
    if (!_showFollowerAndFollowingViewController) {
        _showFollowerAndFollowingViewController = [ShowFollowerAndFollowingViewController new];
    }
    
    return _showFollowerAndFollowingViewController;
}

-(SearchViewV2Controller*)searchViewV2Controller
{
    if (!_searchViewV2Controller) {
        _searchViewV2Controller = [SearchViewV2Controller new];
    }
    
    return _searchViewV2Controller;
}
-(EditProfileV2ViewController*)editProfileV2ViewController
{
    if (!_editProfileV2ViewController) {
        _editProfileV2ViewController = [EditProfileV2ViewController new];
        
        __weak typeof (self)weakSelf = self;
        _editProfileV2ViewController.didCompleteUpdateUserProfileBlock = ^(void)
        {
            [weakSelf requestServerForUserInfo];
        };
    }
    
    return _editProfileV2ViewController;
}
-(LikesListingViewController*)likesListingViewController
{
    if (!_likesListingViewController) {
        _likesListingViewController = [LikesListingViewController new];
        
        //__weak typeof (self)weakSelf = self;
        //        _likesListingViewController.btnBackBlock = ^(id object)
        //        {
        //            [weakSelf requestServerForUserLikes];
        //        };
        
    }
    return _likesListingViewController;
}

-(SettingsViewController*)settingsViewController
{
    if (!_settingsViewController) {
        _settingsViewController = [SettingsViewController new];
    }
    
    return _settingsViewController;
}

-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
        
        __weak typeof (self)weakSelf = self;
        _editCollectionViewController.refreshBlock = ^(void)
        {
            [weakSelf requestServerForUserCollection];
        };
    }
    
    return _editCollectionViewController;
}

-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}
-(PostListingViewController*)postListingViewController
{
    if (!_postListingViewController) {
        _postListingViewController = [PostListingViewController new];
        
        __weak typeof (self)weakSelf = self;
        _postListingViewController.btnBackBlock = ^(id object)
        {
            [weakSelf requestServerForUserPost];
        };
        
    }
    
    return _postListingViewController;
}

-(CollectionViewController*)collectionViewController
{
    if(!_collectionViewController)
    {
        _collectionViewController = [CollectionViewController new];
        
        
    }
    
    return _collectionViewController;
}
-(void)initData
{
    // arrCollection = [[NSMutableArray alloc]initWithArray:@[@"123",@"222"]];
    //arrLikes = [[NSMutableArray alloc]initWithArray:@[@"123",@"222",@"333"]];
    //arrPost = [[NSMutableArray alloc]initWithArray:@[@"123",@"222",@"333"]];
    
}

-(ProfilePageCollectionHeaderView*)profilePageCollectionHeaderView1
{
    if (!_profilePageCollectionHeaderView1) {
        _profilePageCollectionHeaderView1 = [ProfilePageCollectionHeaderView initializeCustomView];
        
    }
    return _profilePageCollectionHeaderView1;
}

#pragma mark - Request Server

-(void)requestServerToFollowCollection:(CollectionModel*)colModel
{
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@/follow",self.userID,colModel.collection_id];
    NSDictionary* dict = @{@"uid":self.userID,
                           @"token":[Utils getAppToken],
                           @"collection_id":colModel.collection_id
                           };
    
    if (!colModel.following) {
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowCollection param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } errorBlock:^(id object) {
            
        }];
    }
    else{
        [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowCollection param:dict appendString:appendString completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } errorBlock:^(id object) {
        }];
    }
    
}

-(void)requestServerToFollowUser:(BOOL)isFollowing
{
    NSString* appendString = [NSString stringWithFormat:@"%@/follow",self.userID];
    NSDictionary* dict = @{@"uid":self.userID,
                           @"token":[Utils getAppToken]
                           };
    
    if (!isFollowing) {
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowUser param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            self.userProfileModel.following = following;
            [self setFollowButtonSelected:following button:self.btnFollow];
            
        } errorBlock:^(id object) {
            
        }];
        
    }
    else{
        
        [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowUser param:dict appendString:appendString completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
            BOOL following = [[returnDict objectForKey:@"data.following"] boolValue];
            self.userProfileModel.following = following;
            [self setFollowButtonSelected:following button:self.btnFollow];
            
        } errorBlock:^(id object) {
        }];
    }
    
}

-(void)requestServerForUserLikes
{
    NSString* appendString = [NSString stringWithFormat:@"%@/likes",self.userID];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@(LIKES_LIST_SIZE),
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserLikes param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userProfileLikeModel = [[ConnectionManager dataManager]userProfileLikeModel];
        [self assignLikesData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserPost
{
    NSString* appendString = [NSString stringWithFormat:@"%@/posts",self.userID];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserPosts param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        [self assignPostData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserCollection
{
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",self.userID];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.userID
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserCollections param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        [self assignCollectionData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserInfo
{
    NSString* appendString = [NSString stringWithFormat:@"%@",self.userID];
    
    NSDictionary* dict = @{@"uid":self.userID,
                           @"token":[Utils getAppToken]
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserInfo param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userProfileModel = [[ConnectionManager dataManager]userProfileModel];
        [self assignData];
        
    } errorBlock:^(id object) {
        
    }];
}


-(void)assignData
{
    
    [self assignUserData];
}

-(void)setParallaxView
{
    [self.ibScrollView addParallaxWithImage:self.backgroundImageView.image andHeight:200 andShadow:NO];
    [self.backgroundImageView adjustToScreenWidth];
    [self.ibScrollView.parallaxView adjustToScreenWidth];
    [self.ibScrollView.parallaxView.imageView adjustToScreenWidth];
    [self.ibScrollView.parallaxView.currentSubView adjustToScreenWidth];
    [self addSearchView];
}

-(void)assignUserData
{
    self.btnLink.hidden = [self.userProfileModel.personal_link isNull]?YES:NO;
    [self setFollowButtonSelected:self.userProfileModel.following button:self.btnFollow];
    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:self.userProfileModel.profile_photo_images] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];
    
    //UIImageView* tempImageView = [[UIImageView alloc]initWithFrame:self.backgroundImageView.frame];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.userProfileModel.wallpaper] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.backgroundImageView.image = [image imageCroppedAndScaledToSize:self.backgroundImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        [self setParallaxView];
        
    }];
    
    self.lblUserName.text = self.userProfileModel.username;
    self.lblName.text = self.userProfileModel.name;
    NSString* strFollower = [NSString stringWithFormat:@"%d %@",self.userProfileModel.follower_count,LocalisedString(@"Followers")];
    NSString* strFollowing = [NSString stringWithFormat:@"%d %@",self.userProfileModel.following_count,LocalisedString(@"Followings")];
    
    [self.btnFollower setTitle:strFollower forState:UIControlStateNormal];
    [self.btnFollowing setTitle:strFollowing forState:UIControlStateNormal];
    
    if (![self.userProfileModel.location isEqualToString:@""]) {
        self.lblLocation.text = self.userProfileModel.location;
        
    }
    else{
        self.lblLocation.text = self.userProfileModel.country;
        
    }
    // ========== url Link  ==========
    
    //self.userProfileModel.personal_link = @"www.youtube.com";
    if (![self.userProfileModel.personal_link isNull]) {
        
        [self.btnLink setTitle:self.userProfileModel.personal_link forState:UIControlStateNormal];
        
    }
    // ========== url Link  ==========
    
    
    self.ibTagControlView.tags = [NSMutableArray arrayWithArray:self.userProfileModel.personal_tags];
    [self.ibTagControlView reloadTagSubviewsCustom];
    
}

-(void)assignCollectionData
{
    arrCollection = [[NSMutableArray alloc]initWithArray:self.userCollectionsModel.arrCollections];
    [self.ibTableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    [self adjustTableView];
}

-(void)assignPostData
{
    arrPost = [[NSMutableArray alloc]initWithArray:self.userProfilePostModel.userPostData.posts];
    [self.ibTableView reloadSectionDU:1 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self adjustTableView];
}

-(void)assignLikesData
{
    arrLikes = [[NSMutableArray alloc]initWithArray:self.userProfileLikeModel.userPostData.posts];
    
    [self.ibTableView reloadData];
    
    [self.ibTableView reloadSectionDU:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self adjustTableView];
    
}

#pragma mark - TTTAttributedLabelDelegate


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[Utils getPrefixedURLFromString:actionSheet.title]];
}

#pragma mark - NSNOTIFICATION CENTER

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:NOTIFICAION_TYPE_REFRESH_COLLECTION])
    {
        [self requestServerForUserCollection];
        
    }
    else if ([[notification name] isEqualToString:NOTIFICAION_TYPE_REFRESH_POST])
    {
        [self requestServerForUserPost];
    }
    else if ([[notification name] isEqualToString:NOTIFICAION_TYPE_REFRESH_LIKES])
    {
        [self requestServerForUserLikes];
        
    }
    else if ([[notification name] isEqualToString:NOTIFICAION_TYPE_REFRESH_PROFILE])
    {
        [self changeLanguage];
    }
    
    //NSLog (@"Successfully received the test notification!");
    
}

-(void)showShareView:(CollectionModel*)colModel
{
    [self.shareViewController GetCollectionID:colModel.collection_id GetCollectionTitle:colModel.name];
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self.shareViewController];
    formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
    [self presentViewController:formSheetController animated:YES completion:nil];
    
}

#pragma mark -ChangeLanguage
-(void)changeLanguage
{
    
    NSString* strFollower = [NSString stringWithFormat:@"%d %@",self.userProfileModel.follower_count,LocalisedString(@"Followers")];
    NSString* strFollowing = [NSString stringWithFormat:@"%d %@",self.userProfileModel.following_count,LocalisedString(@"Followings")];
    [self.btnFollower setTitle:strFollower forState:UIControlStateNormal];
    [self.btnFollowing setTitle:strFollowing forState:UIControlStateNormal];
    [self.btnEditProfile setTitle:LocalisedString(@"Edit Profile") forState:UIControlStateNormal];
    [self.btnSearch setTitle:LocalisedString(@"search") forState:UIControlStateNormal];
    [self.ibTableView reloadData];

}
//#pragma mark - UIScrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int profileBackgroundHeight = 200;
//    if (scrollView.contentOffset.y > -profileBackgroundHeight && scrollView.contentOffset.y <= 0) {
//        NSLog(@"AAA!!%@",NSStringFromCGPoint(scrollView.contentOffset));
//        
//        self.ibImgViewOtherPadding.alpha = (profileBackgroundHeight - fabs(scrollView.contentOffset.y))/profileBackgroundHeight-10;
//
//        
//    }
//
//}
@end

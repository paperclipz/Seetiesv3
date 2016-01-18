//
//  CT3_NewsFeedViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/31/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CT3_NewsFeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedSquareCollectionViewCell.h"
#import "QuickBrowserCollectionTableViewCell.h"

#import "FeedType_FollowingPostTblCell.h"
#import "FeedType_Two_TableViewCell.h"
#import "FeedType_CountryPromotionTblCell.h"
#import "FeedType_InviteFriendTblCell.h"
#import "FeedType_AnnouncementWelcomeTblCell.h"
#import "FeedType_CollectionSuggestedTblCell.h"
#import "FeedType_AbroadQualityPostTblCell.h"
#import "FeedType_SuggestionFetureTblCell.h"

#import "FeedType_FollowingCollectionTblCell.h"

#import "AddCollectionDataViewController.h"
#import "FeedV2DetailViewController.h"
#import "CollectionListingViewController.h"
#import "CollectionViewController.h"
#import "InviteFrenViewController.h"

#define NUMBER_OF_SECTION 2
@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isMiddleOfLoadingServer;
}
/*IBOUTLET*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) IBOutlet UIView *ibHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView *ibIntroCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantQuickBrowseHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *ibQuickBrowseCollectionView;


/* Model */
@property(nonatomic,strong)NSMutableArray* arrayNewsFeed;
@property(nonatomic,strong)NewsFeedModels* newsFeedModels;

/* Model */

/*Controller*/
@property(nonatomic,strong)AddCollectionDataViewController* collectPostToCollectionVC;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@property(nonatomic,strong)FeedV2DetailViewController* feedV2DetailViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)CollectionViewController* displayCollectionViewController;
@property(nonatomic,strong)InviteFrenViewController* inviteFrenViewController;


/*Controller*/


@end

@implementation CT3_NewsFeedViewController
- (IBAction)btnGrabNowClicked:(id)sender {
    VoucherListingViewController *voucherListingController = [[VoucherListingViewController alloc] init];
    [self.navigationController pushViewController:voucherListingController animated:YES];
    
}
- (IBAction)btnLoginClicked:(id)sender {
    
    
    //use this block if feeds api return token session over or app not login
    if (self.btnLoginClickedBlock) {
        self.btnLoginClickedBlock();
    }
    
}
- (IBAction)btnTestCliked:(id)sender {
    
    [self.navigationController pushViewController:self.meViewController animated:YES];
}

-(void)refreshViewAfterLogin
{
    [self requestServerForNewsFeed];
}

#pragma mark - Declaration

-(InviteFrenViewController*)inviteFrenViewController
{
    if (!_inviteFrenViewController) {
        _inviteFrenViewController = [InviteFrenViewController new];
    }
    
    return _inviteFrenViewController;
}
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

-(FeedV2DetailViewController*)feedV2DetailViewController
{
    if (!_feedV2DetailViewController) {
        _feedV2DetailViewController = [FeedV2DetailViewController new];
    }
    
    return _feedV2DetailViewController;
}
-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [ShareV2ViewController new];
    }
    return _shareV2ViewController;
}
-(AddCollectionDataViewController*)collectPostToCollectionVC
{
    if (!_collectPostToCollectionVC) {
        _collectPostToCollectionVC = [AddCollectionDataViewController new];
    }
    return _collectPostToCollectionVC;
}
-(NSMutableArray*)arrayNewsFeed
{
    if (!_arrayNewsFeed) {
        _arrayNewsFeed = [NSMutableArray new];
    }
    
    return _arrayNewsFeed;
}
-(CT3_MeViewController*)meViewController
{
    if (!_meViewController) {
        _meViewController = [CT3_MeViewController new];
    }
    return _meViewController;
}
#pragma mark - DEFAULT
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSelfView];
    [self refreshViewAfterLogin];
  //  [self getDummyData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  [self.ibTableView reloadData];
}

-(void)initSelfView
{
    [self initTableViewDelegate];
    [self initCollectionViewDelegate];
    
    [self adjustView];
    isMiddleOfLoadingServer = NO;
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.ibTableView.estimatedRowHeight = [FeedType_FollowingPostTblCell getHeight];
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)initCollectionViewDelegate
{

    self.ibIntroCollectionView.delegate = self;
    self.ibIntroCollectionView.dataSource = self;
    [self.ibIntroCollectionView registerClass:[FeedSquareCollectionViewCell class] forCellWithReuseIdentifier:@"FeedSquareCollectionViewCell"];
    
    [self.ibQuickBrowseCollectionView registerClass:[QuickBrowserCollectionTableViewCell class] forCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell"];
    self.ibQuickBrowseCollectionView.delegate = self;
    self.ibQuickBrowseCollectionView.dataSource = self;
    self.ibQuickBrowseCollectionView.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ADJUST VIEW

-(void)adjustView
{
    
    self.constantQuickBrowseHeight.constant = 42 + 105*(2);
    [self.ibHeaderView refreshConstraint];
    [self.ibHeaderView setHeight:(self.lastView.frame.size.height + self.lastView.frame.origin.y)];
    [self.ibTableView reloadData];
  // CGSize apple = [self.ibTableView intrinsicContentSize];
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0;
    }
    else{// this is newsfeed row count
        return self.arrayNewsFeed.count;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedTypeModel* typeModel = self.arrayNewsFeed[indexPath.row];

    switch (typeModel.feedType) {
        case FeedType_Collect_Suggestion:
            return [FeedType_CollectionSuggestedTblCell getHeight];
            break;
            
        case FeedType_Abroad_Quality_Post:
            return [FeedType_AbroadQualityPostTblCell getHeight];
            break;
            
        case FeedType_Suggestion_Featured:
        case FeedType_Suggestion_Friend:
        {
            
            
            return 0;
           // CGRect frame = [Utils getDeviceScreenSize];
            //return (frame.size.width/4) + 58 + 60;

        }
            break;
        case FeedType_Country_Promotion:
        {
            int cellheight = [FeedType_CountryPromotionTblCell getHeight];
            return cellheight;
        }
            break;
            
        case FeedType_Following_Post:
        case FeedType_Announcement_Welcome:
        case FeedType_Announcement_Campaign:

            return UITableViewAutomaticDimension;
            break;
        case FeedType_Following_Collection:
            
            return [FeedType_FollowingCollectionTblCell getHeight];
            break;
        case FeedType_Invite_Friend:
            return [FeedType_InviteFriendTblCell getHeight];
            break;
        case FeedType_Deal:
            return 0;
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedTypeModel* typeModel = self.arrayNewsFeed[indexPath.row];

    switch (typeModel.feedType) {
        case FeedType_Following_Post:
        case FeedType_Local_Quality_Post:
        {
            /*Following Post*/
            static NSString *CellIdentifier = @"FeedType_FollowingPostTblCell";
            FeedType_FollowingPostTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_FollowingPostTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel];
            
            DraftModel* feedModel = typeModel.newsFeedData;
            __weak typeof (self)weakSelf = self;
            cell.btnCollectionDidClickedBlock = ^(void)
            {
              
                [weakSelf showCollectToCollectionView:feedModel];
            };
            
            cell.btnCollectionQuickClickedBlock = ^(void)
            {
                [weakSelf requestServerForQuickCollection:feedModel];
            };

            cell.btnPostShareClickedBlock = ^(void)
            {
            
                _shareV2ViewController = nil;
                UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
                [naviVC setNavigationBarHidden:YES animated:NO];
              
                NSString* imageURL;
              
                if ([Utils isArrayNull:feedModel.arrPhotos]) {
                    PhotoModel* pModel = feedModel.arrPhotos[0];
                    imageURL = pModel.imageURL;
                }
                
                [self.shareV2ViewController share:@"" title:feedModel.postDescription imagURL:imageURL shareType:ShareTypePost shareID:feedModel.post_id userID:feedModel.user_info.uid];
                MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
                formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
                formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
                [self presentViewController:formSheetController animated:YES completion:nil];
                
            };
            
            [cell refreshConstraint];
            
            
            //Configure cell
            return cell;

        }
            break;
        case FeedType_Deal:
        {
            /*Following Post*/
            static NSString *CellIdentifier = @"FeedType_Two_TableViewCell";
            FeedType_Two_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_Two_TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            //Configure cell
            return cell;
            
        }
            break;
        default:
        case FeedType_Country_Promotion:
        {
            static NSString *CellIdentifier = @"FeedType_CountryPromotionTblCell";
            FeedType_CountryPromotionTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_CountryPromotionTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            [cell initData:typeModel];
            //Configure cell
            return cell;
            
        }
            break;

        case FeedType_Invite_Friend:
        {
            static NSString *CellIdentifier = @"FeedType_InviteFriendTblCell";
            FeedType_InviteFriendTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_InviteFriendTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel.dictData];
            return cell;
            break;

        }
        case FeedType_Announcement_Welcome:
        case FeedType_Announcement_Campaign:
        case FeedType_Announcement:

        {
            static NSString *CellIdentifier = @"FeedType_AnnouncementWelcomeTblCell";
            FeedType_AnnouncementWelcomeTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_AnnouncementWelcomeTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel];
            [cell refreshConstraint];

            return cell;
            break;
            
        }
            
        case FeedType_Collect_Suggestion:
        {
            static NSString *CellIdentifier = @"FeedType_CollectionSuggestedTblCell";
            FeedType_CollectionSuggestedTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_CollectionSuggestedTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel.arrCollections];
            
            __weak typeof(self) weakSelf = self;
            cell.btnSeeAllSuggestedCollectionClickBlock = ^(void)
            {
                
                
                ProfileModel* model = [ProfileModel new];
                model.uid = [Utils getUserID];
                [weakSelf showCollectionListingView:model];
            };
            
            cell.didSelectCollectionBlock = ^(CollectionModel* model)
            {
                [weakSelf showCollectioPageView:model];
            };
            
            return cell;
            break;
            
        }
        case FeedType_Abroad_Quality_Post:
        {

            static NSString *CellIdentifier = @"FeedType_AbroadQualityPostTblCell";
            FeedType_AbroadQualityPostTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_AbroadQualityPostTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel.arrPosts];
            cell.didSelectPostBlock = ^(DraftModel* model)
            {
                [self showPostDetailView:model];
            };
            return cell;
            break;
            
        }
        case FeedType_Suggestion_Featured:
        case FeedType_Suggestion_Friend:
        {
            static NSString *CellIdentifier = @"FeedType_SuggestionFetureTblCell";
            FeedType_SuggestionFetureTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_SuggestionFetureTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell initData:typeModel.arrSuggestedFeature];
            return cell;
            break;
            
        }
            
        case FeedType_Following_Collection:
        {
            static NSString *CellIdentifier = @"FeedType_FollowingCollectionTblCell";
            FeedType_FollowingCollectionTblCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[FeedType_FollowingCollectionTblCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            
            CollectionModel* collModel = typeModel.followingCollectionData;
            [cell initData:collModel];
            cell.btnShareCollectionClickedBlock = ^(void)
            {
                _shareV2ViewController = nil;
                UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
                [naviVC setNavigationBarHidden:YES animated:NO];
                
                NSString* imageURL;
                if ([Utils isArrayNull:collModel.arrayFollowingCollectionPost]) {
                    
                    DraftModel* postModel = collModel.arrayFollowingCollectionPost[0];
                    
                    if ([Utils isArrayNull:postModel.arrPhotos]) {
                        PhotoModel* pModel = postModel.arrPhotos[0];
                        imageURL = pModel.imageURL;

                    }
                }
                
                [self.shareV2ViewController share:@"" title:typeModel.followingCollectionData.name imagURL:imageURL shareType:ShareTypeCollection shareID:collModel.collection_id userID:collModel.user_info.uid];
                MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
                formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
                formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
                formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
                [self presentViewController:formSheetController animated:YES completion:nil];

            };
            
            return cell;
            break;
            
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.ibHeaderView.frame.size.height;
    }
    else{
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.ibHeaderView;
    }
    else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTION;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
    }
    else
    {
        CTFeedTypeModel* feedTypeModel = self.arrayNewsFeed[indexPath.row];
        
        
        switch (feedTypeModel.feedType) {
            case FeedType_Following_Post:
            {
                [self showPostDetailView:feedTypeModel.newsFeedData];
              
            }
                break;
            case FeedType_Invite_Friend:
                [self showInvitefriendView];
                break;
            default:
                break;
        }
     
        
    }
    
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.ibIntroCollectionView) {
        return 1;

    }
    else{
        return 6;
    
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.ibIntroCollectionView) {
        FeedSquareCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedSquareCollectionViewCell" forIndexPath:indexPath];
        return cell;

    }
    else{
    
        QuickBrowserCollectionTableViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickBrowserCollectionTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
}


-(void)getDummyData
{
    self.arrayNewsFeed = [NSMutableArray new];
    
    CTFeedTypeModel* typeModel13 = [CTFeedTypeModel new];
    typeModel13.tempType = (FeedType)13;
    [self.arrayNewsFeed addObject:typeModel13];
    
    CTFeedTypeModel* typeModel13a = [CTFeedTypeModel new];
    typeModel13a.tempType = (FeedType)13;
    [self.arrayNewsFeed addObject:typeModel13a];
    
    CTFeedTypeModel* typeModel13b = [CTFeedTypeModel new];
    typeModel13b.tempType = (FeedType)13;
    [self.arrayNewsFeed addObject:typeModel13b];
    
    CTFeedTypeModel* typeModel5 = [CTFeedTypeModel new];
    typeModel5.tempType = (FeedType)5;
    [self.arrayNewsFeed addObject:typeModel5];
    
    CTFeedTypeModel* typeModel6 = [CTFeedTypeModel new];
    typeModel6.tempType = (FeedType)6;
    [self.arrayNewsFeed addObject:typeModel6];


    CTFeedTypeModel* typeModel3 = [CTFeedTypeModel new];
    typeModel3.tempType = (FeedType)3;
    [self.arrayNewsFeed addObject:typeModel3];
    
  
    
    CTFeedTypeModel* typeModel8 = [CTFeedTypeModel new];
    typeModel8.tempType = (FeedType)8;
    [self.arrayNewsFeed addObject:typeModel8];
    CTFeedTypeModel* typeModel7 = [CTFeedTypeModel new];
    typeModel7.tempType = (FeedType)7;
    [self.arrayNewsFeed addObject:typeModel7];


    CTFeedTypeModel* typeModel = [CTFeedTypeModel new];
    typeModel.tempType = (FeedType)1;
    [self.arrayNewsFeed addObject:typeModel];
    
    CTFeedTypeModel* typeModel2 = [CTFeedTypeModel new];
    typeModel2.tempType = (FeedType)2;
    [self.arrayNewsFeed addObject:typeModel2];

    CTFeedTypeModel* typeModel12 = [CTFeedTypeModel new];
    typeModel12.tempType = (FeedType)12;
    [self.arrayNewsFeed addObject:typeModel12];
    
    CTFeedTypeModel* aaa = [CTFeedTypeModel new];
    aaa.tempType = (FeedType)3;
    [self.arrayNewsFeed addObject:aaa];
//    CTFeedTypeModel* typeModel3 = [CTFeedTypeModel new];
//    typeModel3.tempType = (FeedType)3;
//    [self.arrayNewsFeed addObject:typeModel3];
}

#pragma mark - SHOW OTHER VIEW

-(void)showInvitefriendView
{
    _inviteFrenViewController  = nil;
    [self.navigationController pushViewController:self.inviteFrenViewController animated:YES];
}

-(void)showPostDetailView:(DraftModel*)draftModel
{
    _feedV2DetailViewController = nil;
    [self.navigationController pushViewController:self.feedV2DetailViewController animated:YES onCompletion:^{
        
        [self.feedV2DetailViewController GetPostID:draftModel.post_id];
    }];
}
-(void)showCollectioPageView:(CollectionModel*)model
{
    _displayCollectionViewController = nil;
    [self.navigationController pushViewController:self.displayCollectionViewController animated:YES onCompletion:^{
        [self.displayCollectionViewController GetCollectionID:model.collection_id GetPermision:@"Others" GetUserUid:model.user_info.uid];
    }];

}

-(void)showCollectionListingView:(ProfileModel*)model
{
    
    _collectionListingViewController = nil;
    
    [self.collectionListingViewController setType:ProfileViewTypeOthers ProfileModel:model NumberOfPage:1 collectionType:CollectionListingTypeSuggestion];

    [self.navigationController pushViewController:self.collectionListingViewController animated:YES onCompletion:^{
        
      
    }];
}
-(void)showCollectToCollectionView:(DraftModel*)model
{
    _collectPostToCollectionVC = nil;
    [self.navigationController presentViewController:self.collectPostToCollectionVC animated:YES completion:^{
        PhotoModel*pModel;
        if (![Utils isArrayNull:model.arrPhotos]) {
            pModel = model.arrPhotos[0];
        }
        [self.collectPostToCollectionVC GetPostID:model.post_id GetImageData:pModel.imageURL];
    }];
    
}
#pragma mark - Request Server

-(void)requestServerForQuickCollection:(DraftModel*)model
{

    NSDictionary* dictPost =  @{@"id": model.post_id};

    
    NSArray* array = @[dictPost];
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/0/collect",[Utils getUserID]];
    NSDictionary* dict = @{@"collection_id" : @"0",
                           @"token" : [Utils getAppToken],
                           @"posts" : array,
                           };
    
    [[ConnectionManager Instance]requestServerWithPut:ServerRequestTypePutCollectPost param:dict appendString:appendString completeHandler:^(id object) {

        model.collect = @"1";
        [TSMessage showNotificationInViewController:self title:LocalisedString(@"System") subtitle:LocalisedString(@"Successfully collected to default Collection") type:TSMessageNotificationTypeSuccess];
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForNewsFeed
{
    
    if (!isMiddleOfLoadingServer) {
        SLog(@"token :%@",[Utils getAppToken]);
        NSDictionary* dict = @{@"token" : [Utils getAppToken],
                               @"offset":@(self.newsFeedModels.offset + self.newsFeedModels.limit),
                               @"limit" : @(ARRAY_LIST_SIZE)
                               };
        
        isMiddleOfLoadingServer = YES;
        [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNewsFeed param:dict appendString:@"" completeHandler:^(id object) {
            isMiddleOfLoadingServer = NO;

            NewsFeedModels* model = [[ConnectionManager dataManager] newsFeedModels];
            self.newsFeedModels = model;
            [self.arrayNewsFeed addObjectsFromArray:model.items];
            [self.ibTableView reloadData];
        } errorBlock:^(id object) {
            isMiddleOfLoadingServer = NO;

        }];

    }
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    float bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width;
//    
//    float reload_distance = 10;
//    if (bottomEdge >= scrollView.contentSize.width -  reload_distance) {
//        
//        if(![Utils isStringNull:self.newsFeedModels.paging.next])
//        {
//            [self requestServerForNewsFeed];
//        }
//      
//    }
//}


- (void)scrollViewDidScroll: (UIScrollView *)scroll {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scroll.contentOffset.y;
    CGFloat maximumOffset = scroll.contentSize.height - scroll.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
        [self requestServerForNewsFeed];
    }
}
@end

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


#define NUMBER_OF_SECTION 2
@interface CT3_NewsFeedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
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
/* Model */

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
   // [self refreshViewAfterLogin];
    [self getDummyData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.ibTableView reloadData];
}

-(void)initSelfView
{
    [self initTableViewDelegate];
    [self initCollectionViewDelegate];
    
    [self adjustView];
}

-(void)initTableViewDelegate
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    self.ibTableView.estimatedRowHeight = [FeedType_Two_TableViewCell getHeight];
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

#pragma mark - Request Server

-(void)requestServerForNewsFeed
{
    SLog(@"token :%@",[Utils getAppToken]);
    NSDictionary* dict = @{@"token" : [Utils getAppToken],
                           @"offset" : @"",
                           @"limit" : @"",
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNewsFeed param:dict appendString:@"" completeHandler:^(id object) {
        
        NewsFeedModels* model = [[ConnectionManager dataManager] newsFeedModels];
        [self.arrayNewsFeed addObjectsFromArray:model.items];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        
    }];
    
}

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

    switch (typeModel.tempType) {
        case FeedType_Collect_Suggestion:
            return 270.0f;
            break;
            
        case FeedType_Abroad_Quality_Post:
            return [FeedType_AbroadQualityPostTblCell getHeight];
            break;
            
        case FeedType_Suggestion_Featured:
        case FeedType_Suggestion_Friend:
        {
            
            CGRect frame = [Utils getDeviceScreenSize];
            return (frame.size.width/4) + 58 + 60;

        }
            break;
            
        case FeedType_Following_Post:
        case FeedType_Announcement_Welcome:
        case FeedType_Announcement_Campaign:
        case FeedType_Country_Promotion:

            return UITableViewAutomaticDimension;
            break;
        case FeedType_Following_Collection:
            
            return [FeedType_FollowingCollectionTblCell getHeight];
            break;
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTFeedTypeModel* typeModel = self.arrayNewsFeed[indexPath.row];

    switch (typeModel.tempType) {
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

@end

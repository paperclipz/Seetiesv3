//
//  SearchLTabViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchLTabViewController.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "ShopTableViewCell.h"
#import "SeetizensTableViewCell.h"
#import "PostsTableViewCell.h"
#import "AddCollectionDataViewController.h"
#import "UITableView+Extension.h"
#import "FeaturedTableViewCell.h"
#import "NSMutableDictionary+Extra.h"

@interface SearchLTabViewController ()
{

    BOOL isMiddleOfCallingServer;


}
@property (weak, nonatomic) IBOutlet UILabel *lblEmytyStateTitle;

@property(nonatomic,strong)NSString* keyword;
@property(nonatomic,strong)NSString* currentLatitude;
@property(nonatomic,strong)NSString* currentLongtitude;

@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIView *FilterView;

@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)UsersModel* usersModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)SeShopsModel* seShopsModel;

@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@property(nonatomic,strong)MZFormSheetPresentationViewController* formSheetController;

@property(nonatomic,strong)HomeLocationModel* homeLocationModel;
@property(nonatomic,strong)NSDictionary *filterDict;

//@property(nonatomic,strong)NSMutableArray* arrPosts;
//@property(nonatomic,strong)NSMutableArray* arrUsers;
//@property(nonatomic,strong)NSMutableArray* arrCollections;
@property(nonatomic,strong)NSMutableArray* arrList;

@end

@implementation SearchLTabViewController
-(void)viewDidAppear:(BOOL)animated
{
   // [self reloadView];
}

-(void)reloadView
{
    [self.ibTableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
    self.lblCount.text = @"";
    

    self.currentLatitude = @"";
    self.currentLongtitude = @"";
    
    [self changeLanguage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{
    
    [self.ibTableView setupFooterView];
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
          //  self.constFilterHeight.constant = 50;
            [self.ibTableView registerClass:[ShopTableViewCell class] forCellReuseIdentifier:@"ShopTableViewCell"];
            self.ibTableView.estimatedRowHeight = [ShopTableViewCell getHeight];
            self.ibTableView.rowHeight = UITableViewAutomaticDimension;
            [self.ibTableView refreshConstraint];

            break;
        case SearchsListingTypeCollections:
           // self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
            break;
        case SearchsListingTypePosts:
           // self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[PostsTableViewCell class] forCellReuseIdentifier:@"PostsTableViewCell"];
            break;
        case SearchsListingTypeSeetizens:
           // self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[SeetizensTableViewCell class] forCellReuseIdentifier:@"SeetizensTableViewCell"];
            break;
    }
    
    
}

#pragma mark - initdata
-(void)refreshRequestWithText:(NSString*)keyword
{
    self.keyword = keyword;
    
    [self requestRefresh];

}

-(void)refreshRequestShop:(NSString*)keyword SeetieshopPlaceID:(NSString*)placeID
{
    _homeLocationModel = nil;
    self.homeLocationModel.place_id = placeID;
    self.keyword = keyword;
    
    [self requestRefresh];

}
-(void)refreshRequestWithGoogleDetail:(NSString*)keyword  googleDetails:(SearchLocationDetailModel*)googleDetailModel
{
    CLLocation* currentLocation = [[SearchManager Instance]getAppLocation];
    
    
    self.keyword = keyword;
    self.homeLocationModel.latitude = googleDetailModel.lat;
    self.homeLocationModel.longtitude = googleDetailModel.lng;
    self.homeLocationModel.address_components.country = googleDetailModel.country;
    self.homeLocationModel.address_components.route = googleDetailModel.route;
    self.homeLocationModel.address_components.locality = googleDetailModel.city;
    self.homeLocationModel.address_components.administrative_area_level_1 = googleDetailModel.state;
    self.homeLocationModel.address_components.political = googleDetailModel.political;
    self.homeLocationModel.dictAddressComponent = googleDetailModel.address_components;
 
    self.currentLatitude = @(currentLocation.coordinate.latitude).stringValue;
    self.currentLongtitude = @(currentLocation.coordinate.longitude).stringValue;
    [self requestRefresh];
}

-(void)refreshRequestWithModel:(HomeLocationModel*)model Keyword:(NSString*)keyword{
    
    
    CLLocation* currentLocation = [[SearchManager Instance]getAppLocation];

    self.homeLocationModel = model;
    self.keyword = keyword;
    
     self.currentLatitude = @(currentLocation.coordinate.latitude).stringValue;
    self.currentLongtitude = @(currentLocation.coordinate.longitude).stringValue;
    
    [self requestRefresh];
}

-(void)refreshRequestWithHomeLocation:(HomeLocationModel*)model filterDictionary:(NSDictionary*)filterDict{

    CLLocation* currentLocation = [[SearchManager Instance]getAppLocation];
    
    self.homeLocationModel = model;
    self.filterDict = filterDict;
    self.keyword = @"";
    
    self.currentLatitude = @(currentLocation.coordinate.latitude).stringValue;
    self.currentLongtitude = @(currentLocation.coordinate.longitude).stringValue;
    
    [self requestRefresh];
}

-(void)requestRefresh
{
    _arrList = nil;
    _userCollectionsModel = nil;
    _userProfilePostModel = nil;
    _usersModel = nil;
    _seShopsModel = nil;
    [self.ibTableView reloadData];

    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            [self requestServerForSearchShop];
            break;
        case SearchsListingTypeCollections:
            [self requestServerForSearchCollection];
            break;
        case SearchsListingTypePosts:
            [self requestServerForSearchPosts];
            break;
        case SearchsListingTypeSeetizens:
            [self requestServerForSearchUser];
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            return UITableViewAutomaticDimension;
            break;
        case SearchsListingTypeCollections:

            return [ProfilePageCollectionTableViewCell getHeight];
            break;
        case SearchsListingTypePosts:

            return [PostsTableViewCell getHeight];
            break;
        case SearchsListingTypeSeetizens:

            return [SeetizensTableViewCell getHeight];
            break;
    }
    
    
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
        {
            ShopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopTableViewCell"];
            
            SeShopDetailModel* model = self.arrList[indexPath.row];
                
            cell.didSelectDealBlock = self.didSelectDealBlock;
            
            NSArray* tempArray;
            if (model.deals.count>3) {
                tempArray = [model.deals subarrayWithRange:NSMakeRange(0, 3)];
                
            }
            else{
                
                tempArray = [[NSMutableArray alloc]initWithArray:model.deals];
            }

            [cell initData:model];
            cell.constBottomHeight.constant = [FeaturedTableViewCell getHeight]*tempArray.count;
            
            
            
            return cell;
        }
            break;
        case SearchsListingTypeCollections:
        {
            ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePageCollectionTableViewCell"];
            
            @try {
                CollectionModel* collModel = self.arrList[indexPath.row];
                
                
                [cell initData:collModel];

                
                cell.btnFollowBlock = ^(void)
                {
                    [self requestServerToFollowFromOthersCollection:collModel];
                };
                
                cell.btnEditClickedBlock = ^(void)
                {
                    
                    if (self.didSelectEditDisplayCollectionRowBlock) {
                        self.didSelectEditDisplayCollectionRowBlock(collModel);
                    }
                };
                
                cell.btnShareClicked = ^(void)
                {
                    _shareV2ViewController = nil;
                    _formSheetController = nil;
                    [self.shareV2ViewController share:@"" title:collModel.postDesc imagURL:@"" shareType:ShareTypeCollection shareID:collModel.collection_id userID:collModel.user_info.uid];
                    [self presentViewController:self.formSheetController animated:YES completion:nil];
                };


            }
            @catch (NSException *exception) {
                SLog(@"cell for row SearchsListingTypeCollections error");
            }
            
            return cell;
        }
            break;
        case SearchsListingTypePosts:
        {
            PostsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostsTableViewCell"];
            
            @try {
                DraftModel* collModel = self.arrList[indexPath.row];
                [cell initData:collModel];
                
                cell.btnFollowBlock = ^(void)
                {
                    SLog(@"btnFollowBlock Click");
                    [self requestServerToFollowFromOthersPosts:collModel];
                };
                cell.btnCollectionBlock = ^(void)
                {
                    SLog(@"btnCollectionBlock Click");
                    [self requestServerForQuickCollection:collModel];
                };
                cell.btnCollectionOpenViewBlock = ^(void)
                {
                    SLog(@"btnCollectionOpenViewBlock Click");
                    if (_didSelectCollectionOpenViewBlock) {
                        self.didSelectCollectionOpenViewBlock(collModel);
                    }
                };
                cell.btnUserProfileBlock = ^(void)
                {
                    SLog(@"btnUserProfileBlock Click");
                    if (_didSelectUserRowBlock) {
                        self.didSelectUserRowBlock(collModel.user_info.uid);
                    }
                };

                
            }
            @catch (NSException *exception) {
                SLog(@"cell for row SearchsListingTypePosts error");
            }
           
            
                        return cell;
        }
            break;
        case SearchsListingTypeSeetizens:
        {
            SeetizensTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeetizensTableViewCell"];
            
            @try {
                UserModel* collModel = self.arrList[indexPath.row];
                
                [cell initData:collModel];
                
                cell.btnFollowBlock = ^(void)
                {
                    NSLog(@"FollowButton Click");
                    [self requestServerToFollowFromOthers:collModel];
                };

            }
            @catch (NSException *exception) {
                SLog(@"cell for row SearchsListingTypeSeetizens error");
            }
           
            return cell;
        }
            
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    @try {
        switch (self.searchListingType) {
            default:
            case SearchListingTypeShop:
            {
                
                SeShopDetailModel* model = self.arrList[indexPath.row];
                if (self.didSelectShopBlock) {
                    self.didSelectShopBlock(model);
                }
            }
                break;
            case SearchsListingTypeCollections:
            {
                CollectionModel* model = self.arrList[indexPath.row];
                if (_didSelectDisplayCollectionRowBlock) {
                    self.didSelectDisplayCollectionRowBlock(model);
                }
            }
                break;
            case SearchsListingTypePosts:
            {
                DraftModel* model = self.arrList[indexPath.row];
                if (_didSelectPostsRowBlock) {
                    self.didSelectPostsRowBlock(model.post_id);
                }
            }
                break;
            case SearchsListingTypeSeetizens:
            {
                UserModel* collModel = self.arrList[indexPath.row];
                
                if (_didSelectUserRowBlock) {
                    self.didSelectUserRowBlock(collModel.userUID);
                }
            }
                
                break;
        }

    }
    @catch (NSException *exception) {
        SLog(@"didSelectRowAtIndexPath error");
    }
    
   
}

#pragma mark - Declarations

-(HomeLocationModel*)homeLocationModel
{
    if (!_homeLocationModel) {
        _homeLocationModel = [HomeLocationModel new];
    }
    
    return _homeLocationModel;
}


-(MZFormSheetPresentationViewController*)formSheetController
{
    
    if (!_formSheetController) {
        UINavigationController* naviVC = [[UINavigationController alloc]initWithRootViewController:self.shareV2ViewController];
        [naviVC setNavigationBarHidden:YES animated:NO];
        _formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:naviVC];
        _formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
        _formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
        _formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        
    }
    return _formSheetController;
    
}
-(ShareV2ViewController*)shareV2ViewController
{
    if (!_shareV2ViewController) {
        _shareV2ViewController = [ShareV2ViewController new];
    }
    
    return _shareV2ViewController;
}

-(NSMutableArray*)arrList
{
    if(!_arrList)
    {
        _arrList = [NSMutableArray new];
    }
    return _arrList;
}
//-(NSMutableArray*)arrPosts
//{
//    if(!_arrPosts)
//    {
//        _arrPosts = [NSMutableArray new];
//    }
//    return _arrPosts;
//}
//-(NSMutableArray*)arrUsers
//{
//    if(!_arrUsers)
//    {
//        _arrUsers = [NSMutableArray new];
//    }
//    return _arrUsers;
//}
//
//-(NSMutableArray*)arrCollections
//{
//    if(!_arrCollections)
//    {
//        _arrCollections = [NSMutableArray new];
//    }
//    return _arrCollections;
//}

#pragma mark - Request Server


-(NSString*)getAddressComponent:(NSString*)strAddress dictionary:(NSDictionary*)dictAddress
{
    if (![Utils isStringNull:strAddress]) {
        return strAddress;
    }
    else{
        if (dictAddress) {
            return [Utils convertToJsonString:dictAddress];
        }
        else{
        return @"";
        }
    }
}

-(void)requestServerForSearchShop
{
    
    if (isMiddleOfCallingServer) {
        return;
    }
    NSDictionary* dict;
    @try {
      
        
        
        dict = @{@"keyword" : self.keyword,
                               @"token" : [Utils getAppToken],
                               @"offset" : @(self.seShopsModel.offset + self.seShopsModel.limit),
                               @"limit" : @(ARRAY_LIST_SIZE),
                               @"address_components" :[self getAddressComponent:self.homeLocationModel.stringAddressComponent dictionary:self.homeLocationModel.dictAddressComponent]
                               };
    }
    @catch (NSException *exception) {
        
        SLog(@"error with dictionary");
    }
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    [finalDict appendDictionarywithKey:@"lat" withValue:self.homeLocationModel.latitude];
    [finalDict appendDictionarywithKey:@"lng" withValue:self.homeLocationModel.longtitude];
    [finalDict appendDictionarywithKey:@"place_id" withValue:self.homeLocationModel.place_id];

    if (self.filterDict) {
        [finalDict addEntriesFromDictionary:self.filterDict];
    }
    
    [self.ibTableView startFooterLoadingView];
    
    isMiddleOfCallingServer = YES;
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeSearchShops param:finalDict appendString:nil completeHandler:^(id object) {
        
        SeShopsModel* model = [[ConnectionManager dataManager]seShopListingModel];
        self.seShopsModel = model;
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",model.total_count,LocalisedString(@"Shops")];
        [self.arrList addObjectsFromArray:model.shops];
        
        isMiddleOfCallingServer = NO;
        [self.ibTableView stopFooterLoadingView];
        [self.ibTableView reloadData];

        if (self.viewDidFinishLoadBlock) {
            self.viewDidFinishLoadBlock();
        }

    } errorBlock:^(id object) {
        isMiddleOfCallingServer = NO;
        [self.ibTableView stopFooterLoadingView];

    }];
}


-(NSString*)convertStringToEmptyIfItsNull:(NSString*)str
{
    if (str) {
        return str;
    }
    else{
        return @"";
    }

}

-(void)requestServerForSearchPosts
{
    
  //  NSDictionary* dict;
    NSString* appendString = @"";
    
    if (isMiddleOfCallingServer) {
        return;
    }
    NSDictionary* dict = @{@"page":self.userProfilePostModel.recommendations.page?@(self.userProfilePostModel.recommendations.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"keyword":[self convertStringToEmptyIfItsNull:self.keyword],
                           @"sort":@"3",
                           @"lat":[self convertStringToEmptyIfItsNull:self.homeLocationModel.latitude],
                           @"lng":[self convertStringToEmptyIfItsNull:self.homeLocationModel.longtitude],
                           @"current_lat":[self convertStringToEmptyIfItsNull:self.currentLatitude],
                           @"current_lng":[self convertStringToEmptyIfItsNull:self.currentLongtitude]
                           };
    isMiddleOfCallingServer = YES;
    //[self.ibTableView startFooterLoadingView];

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchPosts param:dict appendString:appendString completeHandler:^(id object) {
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        [self.arrList addObjectsFromArray:self.userProfilePostModel.recommendations.posts];
        [self.ibTableView reloadData];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userProfilePostModel.recommendations.total_count,LocalisedString(@"Posts")];

        isMiddleOfCallingServer = NO;
     //   [self.ibTableView stopFooterLoadingView];

    } errorBlock:^(id object) {
        isMiddleOfCallingServer = NO;
      //  [self.ibTableView stopFooterLoadingView];

    }];
    
}

-(void)requestServerForSearchUser{

    
    if (isMiddleOfCallingServer) {
        return;
    }
    isMiddleOfCallingServer = YES;
  //  NSDictionary* dict;
  //  NSString* appendString = [[NSString alloc]initWithFormat:@"user?token=%@&keyword=%@",[Utils getAppToken],self.getSearchText];

    NSDictionary* dict = @{@"page":self.usersModel.page?@(self.usersModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"keyword":self.keyword
                           };
    [self.ibTableView startFooterLoadingView];

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchUsers param:dict appendString:nil completeHandler:^(id object) {
        self.usersModel = [[ConnectionManager dataManager]usersModel];
        [self.arrList addObjectsFromArray:self.usersModel.experts];

        [self.ibTableView reloadData];
        isMiddleOfCallingServer = NO;
        [self.ibTableView stopFooterLoadingView];
        
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.usersModel.total_count,LocalisedString(@"Users")];


    } errorBlock:^(id object) {
        
        isMiddleOfCallingServer = NO;
        [self.ibTableView stopFooterLoadingView];

    }];
}

-(void)requestServerForSearchCollection{
    
   // NSDictionary* dict;
    //NSString* appendString = [[NSString alloc]initWithFormat:@"collections?token=%@&keyword=%@",[Utils getAppToken],self.getSearchText];
    
    if (isMiddleOfCallingServer) {
        return;
    }
    isMiddleOfCallingServer = YES;
    
    NSDictionary* dict = @{@"keyword":self.keyword,
                           @"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.userCollectionsModel.offset + self.userCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           @"address_components" :[self getAddressComponent:self.homeLocationModel.stringAddressComponent dictionary:self.homeLocationModel.dictAddressComponent]
                           };
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    [finalDict appendDictionarywithKey:@"lat" withValue:self.homeLocationModel.latitude];
    [finalDict appendDictionarywithKey:@"lng" withValue:self.homeLocationModel.longtitude];
    [finalDict appendDictionarywithKey:@"place_id" withValue:self.homeLocationModel.place_id];
    
    if (self.filterDict) {
        [finalDict addEntriesFromDictionary:self.filterDict];
    }
    
    [self.ibTableView startFooterLoadingView];

    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchCollections param:finalDict appendString:nil completeHandler:^(id object) {
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        [self.arrList addObjectsFromArray:self.userCollectionsModel.arrCollections];
        
        [self.ibTableView reloadData];
        isMiddleOfCallingServer = NO;
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_count,LocalisedString(@"Collections")];

        [self.ibTableView stopFooterLoadingView];

    } errorBlock:^(id object) {
        isMiddleOfCallingServer = NO;

        [self.ibTableView stopFooterLoadingView];

    }];
}
-(void)requestServerToFollowFromOthers:(UserModel*)colModel
{
    
    NSString* appendString = [NSString stringWithFormat:@"%@/follow",colModel.userUID];
    NSDictionary* dict = @{@"uid":colModel.userUID,
                           @"token":[Utils getAppToken]
                           };
    
    if (![DataManager isUserFollowed:colModel.userUID isFollowing:colModel.following]) {
        
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowUser param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [DataManager setCollectionFollowing:colModel.userUID isFollowing:following];
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
            
        }];
        
    }
    else{// TO UNFOLLOW
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                
                [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowUser param:dict appendString:appendString completeHandler:^(id object) {
                    
                    NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
                    BOOL following = [[returnDict objectForKey:@"following"] boolValue];
                    //dont delete the collection instead change the status only
                    colModel.following = following;
                    [DataManager setCollectionFollowing:colModel.userUID isFollowing:following];
                    
                    [self.ibTableView reloadData];
                    
                    
                } errorBlock:^(id object) {
                }];
                
                
            }
        }];
        
    }
}

-(void)requestServerToFollowFromOthersPosts:(DraftModel*)colModel
{
    
    NSString* appendString = [NSString stringWithFormat:@"%@/follow",colModel.user_info.uid];
    NSDictionary* dict = @{@"uid":colModel.user_info.uid,
                           @"token":[Utils getAppToken]
                           };
    
    if (![DataManager isUserFollowed:colModel.user_info.uid isFollowing:colModel.user_info.following]) {
        
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowUser param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.user_info.following = following;
            [DataManager setCollectionFollowing:colModel.user_info.uid isFollowing:following];
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
            
        }];
        
    }
    else{// TO UNFOLLOW
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                
                [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowUser param:dict appendString:appendString completeHandler:^(id object) {
                    
                    NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
                    BOOL following = [[returnDict objectForKey:@"following"] boolValue];
                    //dont delete the collection instead change the status only
                    colModel.user_info.following = following;
                    [DataManager setCollectionFollowing:colModel.user_info.uid isFollowing:following];
                    
                    [self.ibTableView reloadData];
                    
                } errorBlock:^(id object) {
                }];
                
                
            }
        }];
        
    }
}
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
        [MessageManager showMessage:LocalisedString(@"System") SubTitle:LocalisedString(@"Successfully collected to default Collection") Type:TSMessageNotificationTypeSuccess];

        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerToFollowFromOthersCollection:(CollectionModel*)colModel
{
    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@/follow",colModel.user_info.uid,colModel.collection_id];
    NSDictionary* dict = @{@"uid":colModel.user_info.uid,
                           @"token":[Utils getAppToken],
                           @"collection_id":colModel.collection_id
                           };
    
    if (![DataManager isCollectionFollowed:colModel.collection_id isFollowing:colModel.following]) {
        
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowCollection param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [DataManager setCollectionFollowing:colModel.collection_id isFollowing:following];
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            [TSMessage showNotificationWithTitle:LocalisedString(SUCCESSFUL_COLLECTED) type:TSMessageNotificationTypeSuccess];
            
        } errorBlock:^(id object) {
            
        }];
        
    }
    else{// TO UNFOLLOW
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Are You Sure You Want To Unfollow") style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == [alertView cancelButtonIndex]) {
                NSLog(@"Cancelled");
                
            } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                
                
                [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowCollection param:dict appendString:appendString completeHandler:^(id object) {
                    
                    NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
                    BOOL following = [[returnDict objectForKey:@"following"] boolValue];
                    //dont delete the collection instead change the status only
                    colModel.following = following;
                    [DataManager setCollectionFollowing:colModel.collection_id isFollowing:following];
                    
                    [self.ibTableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
                    
                    
                } errorBlock:^(id object) {
                }];
                
                
            }
        }];
        
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y >= h - reload_distance) {
        
        
            if (self.searchListingType == SearchsListingTypeCollections) {
                
                if (!isMiddleOfCallingServer) {
                    if (self.userCollectionsModel.next) {
                        
                        [self requestServerForSearchCollection];
                    }
                }
               
                
            }else if(self.searchListingType == SearchsListingTypeSeetizens){
                
                if (!isMiddleOfCallingServer) {
                    if (self.usersModel.total_page > self.usersModel.page) {
                        
                        [self requestServerForSearchUser];
                    }
                }
                
            }else if(self.searchListingType == SearchsListingTypePosts){
                
                if (!isMiddleOfCallingServer) {
                    if (self.userProfilePostModel.recommendations.total_page > self.userProfilePostModel.recommendations.page) {
                        
                        
                        SLog(@"total page %d",self.userProfilePostModel.recommendations.total_page);
                        SLog(@"total page %d",self.userProfilePostModel.recommendations.page);
                        
                        [self requestServerForSearchPosts];
                    }
                }

                
            }
        
            else if(self.searchListingType == SearchListingTypeShop){
                
                if (!isMiddleOfCallingServer) {
                    if (self.seShopsModel.paging.next) {
                        
                        [self requestServerForSearchShop];
                    }
                }
                
                
            }
    }
}

-(void)changeLanguage
{
    self.lblEmytyStateTitle.text = LocalisedString(@"The keyword you've searched for could not be found.");
}

@end

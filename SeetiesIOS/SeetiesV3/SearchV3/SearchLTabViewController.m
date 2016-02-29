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
@interface SearchLTabViewController ()
{
    BOOL isMiddleOfCallingServer;
}
@property(nonatomic,strong)NSString* locationLatitude;
@property(nonatomic,strong)NSString* locationLongtitude;
@property(nonatomic,strong)NSString* keyword;
@property(nonatomic,strong)NSString* locationName;
@property(nonatomic,strong)SearchLocationDetailModel* googleLocationDetailModel;



@property(nonatomic,strong)NSString* currentLatitude;
@property(nonatomic,strong)NSString* currentLongtitude;


@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFilterHeight;
@property (weak, nonatomic) IBOutlet UIView *FilterView;

@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)UsersModel* usersModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)ProfileViewController* profileViewController;



@property(nonatomic,strong)NSMutableArray* arrPosts;
@property(nonatomic,strong)NSMutableArray* arrUsers;
@property(nonatomic,strong)NSMutableArray* arrCollections;
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
    
    self.locationLatitude = @"";
    self.locationLongtitude = @"";
    self.currentLatitude = @"";
    self.currentLongtitude = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            self.constFilterHeight.constant = 50;
            [self.ibTableView registerClass:[ShopTableViewCell class] forCellReuseIdentifier:@"ShopTableViewCell"];
            break;
        case SearchsListingTypeCollections:
            self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
            break;
        case SearchsListingTypePosts:
            self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[PostsTableViewCell class] forCellReuseIdentifier:@"PostsTableViewCell"];
            break;
        case SearchsListingTypeSeetizens:
            self.constFilterHeight.constant = 0;
            [self.ibTableView registerClass:[SeetizensTableViewCell class] forCellReuseIdentifier:@"SeetizensTableViewCell"];
            break;
    }
    
    
}

#pragma mark - initdata
-(void)refreshRequestWithText:(NSString*)keyword
{
    self.keyword = keyword;
    
    [self refreshRequest:self.keyword Latitude:@"" Longtitude:@"" CurrentLatitude:@"" CurrentLongtitude:@""googleDetails:nil];

}

-(void)refreshRequest:(NSString*)keyword Latitude:(NSString*)latitude Longtitude:(NSString*)longtitude CurrentLatitude:(NSString*)currLatitude CurrentLongtitude:(NSString*)currLongtitude googleDetails:(SearchLocationDetailModel*)googleDetailModel{
    
    self.keyword = keyword;
    self.locationLatitude = latitude;
    self.locationLongtitude = longtitude;
    self.currentLatitude = currLatitude;
    self.currentLongtitude = currLongtitude;
    self.googleLocationDetailModel = googleDetailModel;
    self.arrCollections = nil;
    [self.ibTableView reloadData];
    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            break;
        case SearchsListingTypeCollections:
            [self requestServerForSearchCollection];
            break;
        case SearchsListingTypePosts:
            [self requestServerForSearchPosts];
            break;
        case SearchsListingTypeSeetizens:
          //  [self requestServerForSearchUser];
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            if (indexPath.row == 2) {
                return [ShopTableViewCell getHeightWithoutImage];
                
            }
            else{
                return [ShopTableViewCell getHeight];
                
            }
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
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
            return 5;
            break;
        case SearchsListingTypeCollections:
            
            return self.arrCollections.count;
            break;
        case SearchsListingTypePosts:
            
            return self.arrPosts.count;
            break;
        case SearchsListingTypeSeetizens:
            
            return self.arrUsers.count;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
        {
            ShopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopTableViewCell"];
            
            if (indexPath.row == 2) {
                // [cell setIsOpen:model.location.opening_hours.open_now];
                
                cell.ibDealView.hidden = YES;
                
            }else{
                cell.ibDealView.hidden = NO;
            }
            
            return cell;
        }
            break;
        case SearchsListingTypeCollections:
        {
            ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePageCollectionTableViewCell"];
            
            CollectionModel* collModel = self.arrCollections[indexPath.row];
            [cell initData:collModel profileType:ProfileViewTypeOthers];
            
            
            return cell;
        }
            break;
        case SearchsListingTypePosts:
        {
            PostsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PostsTableViewCell"];
            DraftModel* collModel = self.arrPosts[indexPath.row];
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
            return cell;
        }
            break;
        case SearchsListingTypeSeetizens:
        {
            SeetizensTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeetizensTableViewCell"];
            UserModel* collModel = self.arrUsers[indexPath.row];
            
            [cell initData:collModel];
            
            cell.btnFollowBlock = ^(void)
            {
                NSLog(@"FollowButton Click");
                [self requestServerToFollowFromOthers:collModel];
            };
            return cell;
        }
            
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.searchListingType) {
        default:
        case SearchListingTypeShop:
        {
        }
            break;
        case SearchsListingTypeCollections:
        {
            CollectionModel* model = self.arrCollections[indexPath.row];
            if (_didSelectDisplayCollectionRowBlock) {
                self.didSelectDisplayCollectionRowBlock(model);
            }
        }
            break;
        case SearchsListingTypePosts:
        {
            DraftModel* model = self.arrPosts[indexPath.row];
            if (_didSelectPostsRowBlock) {
                self.didSelectPostsRowBlock(model.post_id);
            }
        }
            break;
        case SearchsListingTypeSeetizens:
        {
            UserModel* collModel = self.arrUsers[indexPath.row];
            
            if (_didSelectUserRowBlock) {
                self.didSelectUserRowBlock(collModel.userUID);
            }
        }
            
            break;
    }
}

#pragma mark - Declarations

-(NSMutableArray*)arrPosts
{
    if(!_arrPosts)
    {
        _arrPosts = [NSMutableArray new];
    }
    return _arrPosts;
}
-(NSMutableArray*)arrUsers
{
    if(!_arrUsers)
    {
        _arrUsers = [NSMutableArray new];
    }
    return _arrUsers;
}

-(NSMutableArray*)arrCollections
{
    if(!_arrCollections)
    {
        _arrCollections = [NSMutableArray new];
    }
    return _arrCollections;
}

#pragma mark - Request Server

-(void)requestServerForSearchShop
{
    NSDictionary* dict = @{};
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeSearchShops param:dict appendString:nil completeHandler:^(id object) {
        
        
    } errorBlock:^(id object) {
        
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
    
    NSDictionary* dict = @{@"page":self.userProfilePostModel.userPostData.page?@(self.userProfilePostModel.userPostData.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"keyword":[self convertStringToEmptyIfItsNull:self.keyword],
                           @"sort":@"3",
                           @"lat":[self convertStringToEmptyIfItsNull:self.locationLatitude],
                           @"lng":[self convertStringToEmptyIfItsNull:self.locationLongtitude],
                           @"current_lat":[self convertStringToEmptyIfItsNull:self.currentLatitude],
                           @"current_lng":[self convertStringToEmptyIfItsNull:self.currentLongtitude]
                           };
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchPosts param:dict appendString:appendString completeHandler:^(id object) {
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        self.arrPosts = nil;
        [self.arrPosts addObjectsFromArray:self.userProfilePostModel.recommendations.posts];
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];
    
}
-(void)requestServerForSearchUser{
    SLog(@"requestServerForSearchUser work ?");
    
  //  NSDictionary* dict;
  //  NSString* appendString = [[NSString alloc]initWithFormat:@"user?token=%@&keyword=%@",[Utils getAppToken],self.getSearchText];
    NSString* appendString = [[NSString alloc]initWithFormat:@"user"];
    NSDictionary* dict = @{@"page":self.usersModel.page?@(self.usersModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"keyword":self.keyword
                           };

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchUsers param:dict appendString:appendString completeHandler:^(id object) {
        self.usersModel = [[ConnectionManager dataManager]usersModel];
        self.arrUsers = nil;
        [self.arrUsers addObjectsFromArray:self.usersModel.experts];

        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];
}

-(void)requestServerForSearchCollection{
    SLog(@"requestServerForSearchCollection work ?");
    
   // NSDictionary* dict;
    //NSString* appendString = [[NSString alloc]initWithFormat:@"collections?token=%@&keyword=%@",[Utils getAppToken],self.getSearchText];
    
    
    NSDictionary* dict = @{@"keyword":self.keyword,
                           @"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.userCollectionsModel.offset + self.userCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           };
    
    NSMutableDictionary* finalDict = [[NSMutableDictionary alloc]initWithDictionary:dict];

    @try {
        NSDictionary* addressComponent = @{@"country" :self.googleLocationDetailModel.country?self.googleLocationDetailModel.country:@"",
                                           @"route" : self.googleLocationDetailModel.route?self.googleLocationDetailModel.route:@"",
                                           @"locality" : self.googleLocationDetailModel.city?self.googleLocationDetailModel.city:@"",
                                           @"administrative_area_level_x" : @"administrative_area_level_1",
                                           };
        
        [finalDict addEntriesFromDictionary:@{@"address_components" : [Utils convertToJsonString:addressComponent]
                                              }];

    }
    @catch (NSException *exception) {
        SLog(@"error initializing dictionary");
    }
    
    
    
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchCollections param:finalDict appendString:nil completeHandler:^(id object) {
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrCollections];
        
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
        
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
-(ProfileViewController*)profileViewController
{
    if(!_profileViewController)
        _profileViewController = [ProfileViewController new];
    
    return _profileViewController;
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


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y >= h - reload_distance) {
        
        if (!isMiddleOfCallingServer) {
            
            if (self.searchListingType == SearchsListingTypeCollections) {
                if (self.userCollectionsModel.next) {
                    
                    [self requestServerForSearchCollection];
                }
                
            }else if(self.searchListingType == SearchsListingTypeSeetizens){
                 if (self.usersModel.total_page > self.usersModel.page) {
                    
                    [self requestServerForSearchUser];
                }
                
            }else if(self.searchListingType == SearchsListingTypePosts){
                if (self.userProfilePostModel.userPostData.total_page > self.userProfilePostModel.userPostData.page) {
                    
                    [self requestServerForSearchPosts];
                }
            }
            
            
            
            
        }
        
        
        
    }
}


@end

//
//  CollectionListingTabViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionListingTabViewController.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"

@interface CollectionListingTabViewController ()
{
    BOOL isMiddleOfCallingServer;
}
@property (weak, nonatomic) IBOutlet CustomEmptyView *ibTableView;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)NSMutableArray* arrCollections;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@end

@implementation CollectionListingTabViewController


-(void)viewDidAppear:(BOOL)animated
{
    [self reloadView];
}

-(void)reloadView
{
    [self.ibTableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    [self refreshRequest];
}

-(void)refreshRequest
{
    [self.arrCollections removeAllObjects];
    [self.ibTableView reloadData];
    _userCollectionsModel = nil;
    
    switch (self.collectionListingType) {
        default:
        case CollectionListingTypeMyOwn:
            [self requestServerForUserCollection];
            
            break;
        case CollectionListingTypeFollowing:
            [self requestServerForOtherUserCollection];
            
            break;
            
        case CollectionListingTypeSuggestion:
            [self requestServerForSuggestedCollection];
            
            break;
            
        case CollectionListingTypeTrending:
            [self requestServerForTrendingCollection];
            break;
        case CollectionListingTypeSeetiesShop:
            [self requestServerForSeetiesCollection];
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    
    [self.ibTableView setupCustomEmptyView];
    [self initTableViewWithDelegate:self];
}

-(void)initTableViewWithDelegate:(id)delegate
{
    self.ibTableView.delegate = delegate;
    self.ibTableView.dataSource = delegate;
    [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProfilePageCollectionTableViewCell getHeight];
    
}

#pragma mark - Declaration

-(NSMutableArray*)arrCollections
{
    if(!_arrCollections)
    {
        _arrCollections = [NSMutableArray new];
    }
    return _arrCollections;
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arrCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePageCollectionTableViewCell"];
    
    CollectionModel* collModel = self.arrCollections[indexPath.row];
    
    [cell initData:collModel];

    __weak CollectionModel* weakModel =collModel;
    
    cell.btnEditClickedBlock = ^(void)
    {
        if (_didSelectEdiCollectionRowBlock) {
            self.didSelectEdiCollectionRowBlock(weakModel);
        }
    };
    
    cell.btnFollowBlock = ^(void)
    {
        [self requestServerToFollowFromOthersCollection:weakModel];
    };
    
    cell.btnShareClicked = ^(void)
    {
        //New Sharing Screen
        CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
        
        dataToPost.title = weakModel.postDesc;
        dataToPost.shareID = weakModel.collection_id;
        dataToPost.userID = weakModel.user_info.uid;
        dataToPost.shareType = ShareTypeCollection;
        
        [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];

    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     CollectionModel* model = self.arrCollections[indexPath.row];
    if (_didSelectDisplayCollectionRowBlock) {
        self.didSelectDisplayCollectionRowBlock(model);
    }
}
#pragma mark - Request Server

-(void)requestServerForUserCollection
{
    
    isMiddleOfCallingServer = true;
 
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",self.userID];
    
    NSDictionary* dict = @{@"page":self.userCollectionsModel.page?@(self.userCollectionsModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.userID?self.userID:@""
                           };
    
    [self.ibTableView showLoading];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserCollections parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrCollections];
        
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
        
        
        if ([Utils isArrayNull:self.arrCollections]) {
            [self.ibTableView showEmptyState];

        }
        else{
            [self.ibTableView hideAll];

        }


    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        [self.ibTableView hideAll];

    }];
}

-(void)requestServerForOtherUserCollection
{
    
    SLog(@"requestServerForOtherUserCollection");
    isMiddleOfCallingServer = true;
    
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/following",self.userID];
    
    NSDictionary* dict = @{@"page":self.userCollectionsModel.page?@(self.userCollectionsModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.userID
                           };
    [self.ibTableView showLoading];

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserFollowingCollections parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userFollowingCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrCollections];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
        
        if ([Utils isArrayNull:self.arrCollections]) {
            [self.ibTableView showEmptyState];
            
        }
        else{
            [self.ibTableView hideAll];
            
        }
    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        [self.ibTableView hideAll];

    }];
}

-(void)requestServerForSuggestedCollection
{
    
    SLog(@"requestServerForSuggestedCollection");
    isMiddleOfCallingServer = true;
    
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/suggestions",self.userID];
    
    NSDictionary* dict = @{@"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.userCollectionsModel.offset + self.userCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           };
    
    [self.ibTableView showLoading];

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserSuggestedCollections parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userSuggestedCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrSuggestedCollection];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
        
        if ([Utils isArrayNull:self.arrCollections]) {
            [self.ibTableView showEmptyState];
            
        }
        else{
            [self.ibTableView hideAll];
            
        }
    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        [self.ibTableView hideAll];

    }];
}

-(void)requestServerForTrendingCollection
{
    SLog(@"requestServerForTrendingCollection");
    isMiddleOfCallingServer = true;
    
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"collections"];
    
    NSDictionary* dict = @{@"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.userCollectionsModel.offset + self.userCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           };
    
    [self.ibTableView showLoading];

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetUserSuggestedCollections parameter:dict appendString:appendString success:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userSuggestedCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrSuggestedCollection];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
        if ([Utils isArrayNull:self.arrCollections]) {
            [self.ibTableView showEmptyState];
            
        }
        else{
            [self.ibTableView hideAll];
            
        }
    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        [self.ibTableView hideAll];

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
                
                
                [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostFollowCollection parameter:dict appendString:appendString success:^(id object) {
                    
                    NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
                    BOOL following = [[returnDict objectForKey:@"following"] boolValue];
                    colModel.following = following;
                    [DataManager setCollectionFollowing:colModel.collection_id isFollowing:following];
                    [self.ibTableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
                    
//                    [TSMessage showNotificationWithTitle:LocalisedString(SUCCESSFUL_COLLECTED) type:TSMessageNotificationTypeSuccess];
                    [MessageManager showMessage:LocalisedString(SUCCESSFUL_COLLECTED) Type:STAlertSuccess];
                    
                } failure:^(id object) {
                    
                }];
                
            }
            else{// TO UNFOLLOW
                
                [UIAlertView showWithTitle:[NSString stringWithFormat:@"%@ %@",LocalisedString(@"Are You Sure You Want To Unfollow"),colModel.name] message:nil style:UIAlertViewStyleDefault cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"YES"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == [alertView cancelButtonIndex]) {
                        NSLog(@"Cancelled");
                        
                    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:LocalisedString(@"YES")]) {
                        
                        [[ConnectionManager Instance] requestServerWith:AFNETWORK_DELETE serverRequestType:ServerRequestTypePostFollowCollection parameter:dict appendString:appendString success:^(id object) {

                            
                            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
                            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
                            //dont delete the collection instead change the status only
                            colModel.following = following;
                            [DataManager setCollectionFollowing:colModel.collection_id isFollowing:following];
                            
                            [self.ibTableView reloadData];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
                            
                            
                        } failure:^(id object) {
                        }];

                        
                    }
                }];

            }
}

-(void)requestServerForShareCollection:(CollectionModel*)colModel
{

    
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/following",self.userID];
    
    NSDictionary* dict = @{@"collection_id":colModel.collection_id,
                           @"token":[Utils getAppToken],
                           @"user_ids":self.userID
                           };
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostShareCollection parameter:dict appendString:appendString success:^(id object) {

        
        
    } failure:^(id object) {
        
    }];

}

-(void)requestServerForSeetiesCollection
{
    SLog(@"requestServerForSeetiesCollection");
    isMiddleOfCallingServer = true;
    
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",self.userID];
    
    NSDictionary* dict = @{@"seetishop_id":self.userID,
                           @"limit":@(ARRAY_LIST_SIZE),
                           @"offset":@(self.userCollectionsModel.offset + self.userCollectionsModel.limit),
                           @"token":[Utils getAppToken],
                           };
    
    [self.ibTableView showLoading];

    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetSeetiShopCollection parameter:dict appendString:appendString success:^(id object) {
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userSuggestedCollectionsModel];
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrSuggestedCollection];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_collections,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
        
        if ([Utils isArrayNull:self.arrCollections]) {
            [self.ibTableView showEmptyState];
            
        }
        else{
            [self.ibTableView hideAll];
            
        }
    } failure:^(id object) {
        isMiddleOfCallingServer = false;
        [self.ibTableView hideAll];

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
            
                if (self.collectionListingType == CollectionListingTypeMyOwn) {
                    if (self.userCollectionsModel.total_page > self.userCollectionsModel.page) {

                        [self requestServerForUserCollection];
                    }

                }
                else if(self.collectionListingType == CollectionListingTypeSuggestion)
                {
                    if(![Utils isStringNull:self.userCollectionsModel.next])
                    {
                        [self requestServerForSuggestedCollection];
                    }
                }
                else if(self.collectionListingType == CollectionListingTypeTrending)
                {
                    if(![Utils isStringNull:self.userCollectionsModel.next])
                    {
                        [self requestServerForTrendingCollection];
                    }
                }
                else if(self.collectionListingType == CollectionListingTypeFollowing)
                {
                    if (self.userCollectionsModel.total_page > self.userCollectionsModel.page) {

                        [self requestServerForOtherUserCollection];
                    }

                }
                else if(self.collectionListingType == CollectionListingTypeSeetiesShop)
                {
                    if(![Utils isStringNull:self.userCollectionsModel.next])
                    {
                        [self requestServerForSeetiesCollection];
                    }
                    
                }
        }
        
        
        
    }
}


@end

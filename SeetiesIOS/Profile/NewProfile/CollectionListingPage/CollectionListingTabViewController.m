//
//  CollectionListingTabViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CollectionListingTabViewController.h"
#import "ProfilePageCollectionTableViewCell.h"

@interface CollectionListingTabViewController ()
{
    BOOL isMiddleOfCallingServer;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)NSMutableArray* arrCollections;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@end

@implementation CollectionListingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    
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
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
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

-(ShareViewController*)shareViewController
{
    if (!_shareViewController) {
        _shareViewController = [ShareViewController new];
    }
    
    return _shareViewController;
}
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
    
    [cell initData:collModel profileType:self.profileType];
    
    
    __weak CollectionModel* weakModel =collModel;
    
    cell.btnEditClickedBlock = ^(void)
    {
        if (_didSelectEdiCollectionRowBlock) {
            self.didSelectEdiCollectionRowBlock(weakModel.collection_id);
        }
    };
    
    cell.btnFollowBlock = ^(void)
    {
        [self requestServerToFollowFromOthersCollection:weakModel];
    };
    
    cell.btnShareClicked = ^(void)
    {
        [self.shareViewController GetCollectionID:collModel.collection_id GetCollectionTitle:collModel.name];
        MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:self.shareViewController];
        formSheetController.presentationController.contentViewSize = [Utils getDeviceScreenSize].size;
        formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromBottom;
        [self presentViewController:formSheetController animated:YES completion:nil];
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     CollectionModel* model = self.arrCollections[indexPath.row];
    if (_didSelectDisplayCollectionRowBlock) {
        self.didSelectDisplayCollectionRowBlock(model.collection_id);
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
                           @"uid":self.userID
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserCollections param:dict appendString:appendString completeHandler:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrCollections];
        
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;

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
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserFollowingCollections param:dict appendString:appendString completeHandler:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userFollowingCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrCollections];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;
        
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
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserSuggestedCollections param:dict appendString:appendString completeHandler:^(id object) {
        
        isMiddleOfCallingServer = false;
        self.userCollectionsModel = [[ConnectionManager dataManager]userSuggestedCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrSuggestedCollection];
        self.lblCount.text = [NSString stringWithFormat:@"%d %@",self.userCollectionsModel.total_result,LocalisedString(@"Collections")];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        isMiddleOfCallingServer = false;
        
    }];
}


-(void)requestServerToFollowFromOthersCollection:(CollectionModel*)colModel
{
    NSString* appendString = [NSString stringWithFormat:@"%@/collections/%@/follow",colModel.user_info.uid,colModel.collection_id];
    NSDictionary* dict = @{@"uid":colModel.user_info.uid,
                           @"token":[Utils getAppToken],
                           @"collection_id":colModel.collection_id
                           };
    
    if (!colModel.following) {
        
        [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostFollowCollection param:dict appendString:appendString meta:nil completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object[@"data"]];
            
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
            
        }];
    }
    else{
        [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowCollection param:dict appendString:appendString completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            
            //delete follow for user if return following false
            if (!following) {
                [self.arrCollections removeObject:colModel];
            }
            
            
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
        }];
    }
    
}


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
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
            
        }];
    }
    else{
        [[ConnectionManager Instance]requestServerWithDelete:ServerRequestTypePostFollowCollection param:dict appendString:appendString completeHandler:^(id object) {
            
            NSDictionary* returnDict = [[NSDictionary alloc]initWithDictionary:object];
            BOOL following = [[returnDict objectForKey:@"following"] boolValue];
            colModel.following = following;
            [self.ibTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICAION_TYPE_REFRESH_COLLECTION object:nil];
            
            
        } errorBlock:^(id object) {
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
    
    [[ConnectionManager Instance]requestServerWithPost:ServerRequestTypePostShareCollection param:dict appendString:appendString meta:nil completeHandler:^(id object) {
        
        
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
                else if(self.collectionListingType == CollectionListingTypeFollowing)
                {
                    if (self.userCollectionsModel.total_page > self.userCollectionsModel.page) {

                        [self requestServerForOtherUserCollection];
                    }

                }
        }
        
        
        
    }
}


@end

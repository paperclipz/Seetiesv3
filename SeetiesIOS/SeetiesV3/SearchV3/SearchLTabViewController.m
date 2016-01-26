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
@interface SearchLTabViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constFilterHeight;
@property (weak, nonatomic) IBOutlet UIView *FilterView;


@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)UsersModel* usersModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;

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
    [self refreshRequest];
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
-(void)refreshRequest{
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
            [self requestServerForSearchUser];
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
            [cell initData:self.arrPosts[indexPath.row]];
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
              //  [self requestServerToFollowFromOthers:collModel];
            };
            return cell;
        }
            
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //    CollectionModel* model = self.arrCollections[indexPath.row];
    //    if (_didSelectDisplayCollectionRowBlock) {
    //        self.didSelectDisplayCollectionRowBlock(model);
    //    }
}

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
//Connection

-(void)requestServerForSearchPosts
{
    SLog(@"requestServerForSearch work ?");
    
    NSDictionary* dict;
    NSString* appendString = [[NSString alloc]initWithFormat:@"?token=%@&keyword=%@&sort=%@",[Utils getAppToken],@"Coffee",@"3"];
    
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
    
    NSDictionary* dict;
    NSString* appendString = [[NSString alloc]initWithFormat:@"user?token=%@&keyword=%@",[Utils getAppToken],@"Coffee"];

    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchUsers param:dict appendString:appendString completeHandler:^(id object) {
        self.usersModel = [[ConnectionManager dataManager]usersModel];
        
        [self.arrUsers addObjectsFromArray:self.usersModel.experts];

        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];
}
-(void)requestServerForSearchCollection{
    SLog(@"requestServerForSearchCollection work ?");
    
    NSDictionary* dict;
    NSString* appendString = [[NSString alloc]initWithFormat:@"collections?token=%@&keyword=%@",[Utils getAppToken],@"Coffee"];
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeSearchCollections param:dict appendString:appendString completeHandler:^(id object) {
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        
        [self.arrCollections addObjectsFromArray:self.userCollectionsModel.arrSuggestedCollection];
        
        [self.ibTableView reloadData];
        
    } errorBlock:^(id object) {
        
        
    }];
}
@end

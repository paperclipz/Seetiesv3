//
//  ConnectionsTabViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ConnectionsTabViewController.h"
#import "SeetizensTableViewCell.h"
@interface ConnectionsTabViewController ()
{
    BOOL isMiddleOfCallingServer;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic,strong)UsersModel* usersModel;
@property(nonatomic,strong)NSMutableArray* arrUsers;
@end

@implementation ConnectionsTabViewController
-(void)viewDidAppear:(BOOL)animated
{
  //  [self reloadView];
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
    
    [self.ibTableView registerClass:[SeetizensTableViewCell class] forCellReuseIdentifier:@"SeetizensTableViewCell"];
    

    
}
-(void)refreshRequest{
    switch (self.usersListingType) {
        default:
        case UsersListingTypeFollower:
            [self requestServerForUserFollower];
            
            break;
        case UsersListingTypeFollowing:
            [self requestServerForUserFollowing];
            
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SeetizensTableViewCell getHeight];
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLog(@"tableview click");
//    if ([self.TabType isEqualToString:@"Follower"]) {
//        SLog(@"Follower inside click");
//        UserModel* collModel = self.arrUsers[indexPath.row];
//        _profileViewController = nil;
//        [self.profileViewController requestAllDataWithType:ProfileViewTypeOthers UserID:collModel.uid];
//        [self.navigationController pushViewController:self.profileViewController animated:YES];
//    }else if ([self.TabType isEqualToString:@"Following"]){
//        
//    }else{
//        
//    }
    UserModel* collModel = self.arrUsers[indexPath.row];

    if (_didSelectUserRowBlock) {
        self.didSelectUserRowBlock(collModel.userUID);
    }

}
-(void)requestServerForUserFollower{
    SLog(@"requestServerForUserFollower work");
    isMiddleOfCallingServer = true;
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/follower",self.userID];
    
    NSDictionary* dict = @{@"page":self.usersModel.page?@(self.usersModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.userID
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeUserFollower param:dict appendString:appendString completeHandler:^(id object) {
        isMiddleOfCallingServer = false;
        self.usersModel = [[ConnectionManager dataManager]usersModel];
        
        [self.arrUsers addObjectsFromArray:self.usersModel.follower];
        SLog(@"UID == %@",[self.arrUsers[0] userUID]);
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
       isMiddleOfCallingServer = false;
        
    }];
}
-(void)requestServerForUserFollowing{
    SLog(@"requestServerForUserFollowing work");
    isMiddleOfCallingServer = true;
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/following",self.userID];
    
    NSDictionary* dict = @{@"page":self.usersModel.page?@(self.usersModel.page + 1):@1,
                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"token":[Utils getAppToken],
                           @"uid":self.userID
                           };
    
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeUserFollower param:dict appendString:appendString completeHandler:^(id object) {
        isMiddleOfCallingServer = false;
        self.usersModel = [[ConnectionManager dataManager]usersModel];
        
        [self.arrUsers addObjectsFromArray:self.usersModel.following];
        [self.ibTableView reloadData];
    } errorBlock:^(id object) {
        
        isMiddleOfCallingServer = false;
    }];
}
-(NSMutableArray*)arrUsers
{
    if(!_arrUsers)
    {
        _arrUsers = [NSMutableArray new];
    }
    return _arrUsers;
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
            
            if(self.usersListingType == UsersListingTypeFollower)
            {
                if (self.usersModel.total_page > self.usersModel.page) {
                    
                    [self requestServerForUserFollower];
                }
                
            }
            else if(self.usersListingType == UsersListingTypeFollowing)
            {
                if (self.usersModel.total_page > self.usersModel.page) {
                    
                    [self requestServerForUserFollowing];
                }
                
            }
        }
        
        
        
    }
}

@end

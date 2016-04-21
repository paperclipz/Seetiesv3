//
//  CollectionListingSinglePageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/23/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionListingSinglePageViewController.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "EditCollectionViewController.h"
#import "CollectionViewController.h"
#import "UIActivityViewController+Extension.h"
#import "CustomItemSource.h"

@interface CollectionListingSinglePageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic)NSMutableArray* arrCollections;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)CollectionViewController* collectionViewController;


@end

@implementation CollectionListingSinglePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
}

-(void)initData:(NSArray*)array
{
    self.arrCollections = [[NSMutableArray alloc]initWithArray:array];
    [self.ibTableView reloadData];
}

-(void)initSelfView
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[ProfilePageCollectionTableViewCell class] forCellReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProfilePageCollectionTableViewCell getHeight];
    
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
        [self showEditCollectionViewWithCollection:weakModel];
    
    };
    
    cell.btnFollowBlock = ^(void)
    {
        [self requestServerToFollowFromOthersCollection:weakModel];
    };
    
    cell.btnShareClicked = ^(void)
    {

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
    [self showCollectionDisplayView:model];
}

#pragma mark - Declaration

-(CollectionViewController*)collectionViewController
{
    if (!_collectionViewController) {
        _collectionViewController  = [CollectionViewController new];
    }
    return _collectionViewController;
}

-(EditCollectionViewController*)editCollectionViewController
{
    if (!_editCollectionViewController) {
        _editCollectionViewController = [EditCollectionViewController new];
        __weak typeof (self)weakSelf = self;
        _editCollectionViewController.refreshBlock = ^(void)
        {
         //   [weakSelf.myCollectionListingViewController refreshRequest];
        };
    }
    
    return _editCollectionViewController;
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


-(void)showEditCollectionViewWithCollection:(CollectionModel*)model
{
    _editCollectionViewController = nil;
    
    [self.editCollectionViewController initData:model.collection_id];

    [self.navigationController pushViewController:self.editCollectionViewController animated:YES];
}

-(void)showCollectionDisplayView:(CollectionModel*)colModel
{
    _collectionViewController = nil;
    if ([colModel.user_info.uid isEqualToString:[Utils getUserID]]) {
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"self" GetUserUid:colModel.user_info.uid];
        
    }
    else{
        
        [self.collectionViewController GetCollectionID:colModel.collection_id GetPermision:@"Others" GetUserUid:colModel.user_info.uid];
    }
    
    [self.navigationController pushViewController:self.collectionViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

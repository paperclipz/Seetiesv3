//
//  FeedType_CollectionSuggestedTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_CollectionSuggestedTblCell.h"
#import "CollectionsCollectionViewCell.h"

@interface FeedType_CollectionSuggestedTblCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibSeeAll;
@property (nonatomic,strong)CTFeedTypeModel* feedTypeModel;
@property (nonatomic,copy)NSArray<CollectionModel>* arrCollections;

@end
@implementation FeedType_CollectionSuggestedTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)reloadData
{
    [self.ibCollectionView reloadData];
}

- (IBAction)btnSeeAllClicked:(id)sender {
    
    if (self.btnSeeAllSuggestedCollectionClickBlock) {
        self.btnSeeAllSuggestedCollectionClickBlock();
    }
    
}

-(void)initData:(NSArray<CollectionModel>*)array
{
    self.ibTitle.text = LocalisedString(@"Suggested Collections");
    self.ibSeeAll.text = LocalisedString(@"See all");
    
    self.arrCollections = array;
    
    [self.ibCollectionView reloadData];
}

-(void)initSelfView
{
    [self initCollectionViewDelegate];
    
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[CollectionsCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionsCollectionViewCell"];
    self.ibCollectionView.backgroundColor = [UIColor clearColor];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrCollections.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionsCollectionViewCell* cell = (CollectionsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionsCollectionViewCell" forIndexPath:indexPath];
    
    CollectionModel* model = self.arrCollections[indexPath.row];
    
    __weak typeof (self)weakSelf = self;
    cell.btnFollowBlock = ^(void)
    {
        [weakSelf requestServerToFollowCollection:model];
    };
    
    [cell initData:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    return CGSizeMake(frame.size.width - (self.arrCollections.count<=1?16:50), 190);
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionModel* model = self.arrCollections[indexPath.row];
    
    if (self.didSelectCollectionBlock) {
        self.didSelectCollectionBlock(model);
    }
}

-(void)requestServerToFollowCollection:(CollectionModel*)colModel
{
    if ([Utils isGuestMode]) {
        
        
        [UIAlertView showWithTitle:LocalisedString(@"system") message:LocalisedString(@"Please Login To Collect") cancelButtonTitle:LocalisedString(@"Cancel") otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [Utils showLogin];
                
            }
        }];
        return;
    }

    
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
            [self.ibCollectionView reloadData];
            
//            [TSMessage showNotificationWithTitle:LocalisedString(SUCCESSFUL_FOLLOWED) type:TSMessageNotificationTypeSuccess];
            [MessageManager showMessage:LocalisedString(SUCCESSFUL_FOLLOWED) Type:STAlertSuccess];
            
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
                    
                    [self.ibCollectionView reloadData];
                    
                    
                } failure:^(id object) {
                }];
                
                
            }
        }];
        
    }
}

@end

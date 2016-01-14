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

-(void)initData:(NSArray<CollectionModel>*)array
{
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
    [cell initData:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    return CGSizeMake(frame.size.width-50, 190);
}


@end

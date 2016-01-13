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


@end
@implementation FeedType_CollectionSuggestedTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    [self initCollectionViewDelegate];
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[CollectionsCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionsCollectionViewCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionsCollectionViewCell* cell = (CollectionsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionsCollectionViewCell" forIndexPath:indexPath];
    
    [cell initData];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    return CGSizeMake(frame.size.width-50, 190);
}


@end

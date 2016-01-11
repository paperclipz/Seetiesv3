//
//  FeedType_CollectionSuggestedTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_CollectionSuggestedTblCell.h"
#import "ProfilePageCollectionTableViewCell.h"

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
    [self.ibCollectionView registerClass:[ProfilePageCollectionTableViewCell class] forCellWithReuseIdentifier:@"ProfilePageCollectionTableViewCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilePageCollectionTableViewCell* cell = (ProfilePageCollectionTableViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePageCollectionTableViewCell" forIndexPath:indexPath];
    
    return cell;
}


@end

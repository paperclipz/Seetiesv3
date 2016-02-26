//
//  DealType_mainTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_mainTblCell.h"
#import "DealMainCollectionViewCell.h"

@interface DealType_mainTblCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (strong, nonatomic)NSArray* arrDealCollections;

@end
@implementation DealType_mainTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initData:(HomeModel*)model
{
    self.arrDealCollections = model.deal_collections;
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
    [self.ibCollectionView registerClass:[DealMainCollectionViewCell class] forCellWithReuseIdentifier:@"DealMainCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrDealCollections.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DealMainCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DealMainCollectionViewCell" forIndexPath:indexPath];
    
    DealCollectionModel* model = self.arrDealCollections[indexPath.row];
    
    [cell initData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    DealCollectionModel* model = self.arrDealCollections[indexPath.row];
    
    if (self.didSelectDealCollectionBlock) {
        self.didSelectDealCollectionBlock(model);
    }
}



@end

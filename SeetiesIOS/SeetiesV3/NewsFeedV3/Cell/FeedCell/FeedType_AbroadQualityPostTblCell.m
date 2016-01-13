//
//  FeedType_AbroadQualityPostTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_AbroadQualityPostTblCell.h"
#import "AbroadQualityPostCVCell.h"

@interface FeedType_AbroadQualityPostTblCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionview;

@end
@implementation FeedType_AbroadQualityPostTblCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)initSelfView
{
    [self initCollectionViewDelegate];
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionview.delegate = self;
    self.ibCollectionview.dataSource = self;
    [self.ibCollectionview registerClass:[AbroadQualityPostCVCell class] forCellWithReuseIdentifier:@"AbroadQualityPostCVCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AbroadQualityPostCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AbroadQualityPostCVCell" forIndexPath:indexPath];
    
    return cell;
}


@end

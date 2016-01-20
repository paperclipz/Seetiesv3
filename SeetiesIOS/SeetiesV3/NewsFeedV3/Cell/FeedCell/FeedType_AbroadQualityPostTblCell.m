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
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImage;
@property (nonatomic,strong)NSArray<DraftModel>* arrPosts;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@end
@implementation FeedType_AbroadQualityPostTblCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)initData:(NSArray<DraftModel>*)array
{
    self.arrPosts = array;
    [self.ibCollectionview reloadData];
    self.lblTitle.text = LocalisedString(@"Suggested foreign recommendation");
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
    return self.arrPosts.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AbroadQualityPostCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AbroadQualityPostCVCell" forIndexPath:indexPath];
    
    DraftModel* model = self.arrPosts[indexPath.row];
    
    cell.btnProfileClickedBlock = self.btnProfileClickedBlock;
    [cell initData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DraftModel* model = self.arrPosts[indexPath.row];
    if (self.didSelectPostBlock) {
        self.didSelectPostBlock(model);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [Utils getDeviceScreenSize];
    
    
    float cellSize = frame.size.width - 20;
    
    return CGSizeMake(cellSize, 404);
}


@end

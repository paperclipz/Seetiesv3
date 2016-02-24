//
//  DealType_QuickBrowseTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_QuickBrowseTblCell.h"
#import "QuickBrowseCVCell.h"

@interface DealType_QuickBrowseTblCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

@property (nonatomic)NSArray* arrQuickBrowse;

@end

@implementation DealType_QuickBrowseTblCell


-(void)initData:(NSArray*)array
{
    self.arrQuickBrowse = array;
    [self.ibCollectionView reloadData];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView{
    [self initCollectionViewDelegate];
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[QuickBrowseCVCell class] forCellWithReuseIdentifier:@"QuickBrowseCVCell"];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrQuickBrowse.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuickBrowseCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickBrowseCVCell" forIndexPath:indexPath];
    QuickBrowseModel* model = self.arrQuickBrowse[indexPath.row];
    cell.lblTitle.text = model.name;
    [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:model.backgroundImage] completed:nil];
    [cell.ibImgLogo sd_setImageWithURL:[NSURL URLWithString:model.logoImage]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect frame = [Utils getDeviceScreenSize];
    
    float width = (frame.size.width/3) - 3;
    
    return CGSizeMake(width, width);
}

@end

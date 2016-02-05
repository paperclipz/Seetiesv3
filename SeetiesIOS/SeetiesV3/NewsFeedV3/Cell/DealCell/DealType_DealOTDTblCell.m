//
//  DealType_DealOTDTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_DealOTDTblCell.h"
#import "PhotoCVCell.h"

@interface DealType_DealOTDTblCell()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int imageIndex;
    NSMutableArray* arrImages;


}
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectNow;
@property (nonatomic, strong) NSTimer *fadeTimer;
@end
@implementation DealType_DealOTDTblCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    imageIndex = 0;
    self.lblCollectNow.textColor = DEVICE_COLOR;
    [self.lblCollectNow setSideCurveBorder];
    arrImages = [NSMutableArray new];
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[PhotoCVCell class] forCellWithReuseIdentifier:@"PhotoCVCell"];
}

-(void)initData:(NSArray*)arrDeals
{
    arrImages = nil;
    arrImages = [NSMutableArray new];
    
    for (int i = 0; i<arrDeals.count; i++) {
        DealModel* model = arrDeals[i];
        
        if (![Utils isArrayNull:model.cover_photo]) {
            PhotoModel* pModel = model.cover_photo[0];
            [arrImages addObject:pModel];
        }
    }
    
    PhotoModel* model = [PhotoModel new];
    model.imageURL = @"http://www.wallpapereast.com/static/images/b807c2282ab0a491bd5c5c1051c6d312_LebkKlA.jpg";
    [arrImages addObject:model];
    
    PhotoModel* model1 = [PhotoModel new];
    model1.imageURL = @"http://www.wallpapereast.com/static/images/HD-Wallpapers1_QlwttNW.jpeg";
    [arrImages addObject:model1];


    
    [self.fadeTimer invalidate];
    self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animateImages) userInfo:nil repeats:YES];
   
   // [self.ibCollectionView reloadData];
}

-(void)stopAnimationScrolling
{
    [self.fadeTimer invalidate];

}
-(void)animateImages
{
    [UIView animateWithDuration:1.0
                     animations: ^{ [self.ibCollectionView reloadData]; }
                     completion:^(BOOL finished) {
                         int counter = imageIndex % arrImages.count;
                         NSIndexPath *iPath = [NSIndexPath indexPathForItem:counter inSection:0];
                         [self.ibCollectionView scrollToItemAtIndexPath:iPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                         imageIndex ++;
                     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width, 150);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrImages.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCVCell" forIndexPath:indexPath];
    
    PhotoModel* pModel = arrImages[indexPath.row];
    if (pModel.image) {
        cell.ibImageView.image = pModel.image;
    }
    else{
        
        [cell.ibImageView sd_setImageCroppedWithURL:[NSURL URLWithString:pModel.imageURL] completed:^(UIImage *image) {
            
            pModel.image = image;
        }];
    }

    
    return cell;
}


@end

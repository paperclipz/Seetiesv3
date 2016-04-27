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
    BOOL isNeedShowCoverPhoto;

}
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblCollectNow;
@property (nonatomic, strong) NSTimer *fadeTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblDealDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@property(nonatomic)NSMutableArray* arrDeals;
@property(nonatomic)HomeModel* homeModel;

@end
@implementation DealType_DealOTDTblCell


-(NSMutableArray*)arrDeals
{
    if (!_arrDeals) {
        _arrDeals = [NSMutableArray new];
    }
    return _arrDeals;
}

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
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[PhotoCVCell class] forCellWithReuseIdentifier:@"PhotoCVCell"];
}

-(void)initData:(HomeModel*)model
{
    
    self.homeModel = model;
    self.arrDeals = model.featured_deals;
    isNeedShowCoverPhoto = YES;

//    if ([Utils isStringNull:model.featured_title]) {
//        isNeedShowCoverPhoto = YES;
//    }
//    PhotoModel* model = [PhotoModel new];
//    model.imageURL = @"http://www.wallpapereast.com/static/images/b807c2282ab0a491bd5c5c1051c6d312_LebkKlA.jpg";
//    [arrImages addObject:model];
//    
//    PhotoModel* model1 = [PhotoModel new];
//    model1.imageURL = @"http://www.wallpapereast.com/static/images/HD-Wallpapers1_QlwttNW.jpeg";
//    [arrImages addObject:model1];
//

    
    [self.fadeTimer invalidate];
   
        if (self.arrDeals.count>1) {
        self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animateImages) userInfo:nil repeats:YES];

    }
   
    [self.ibCollectionView reloadData];
}

-(void)stopAnimationScrolling
{
    [self.fadeTimer invalidate];

}
-(void)animateImages
{
    
        [UIView animateWithDuration:1.0
                         animations: ^{
                         
                             if (self.arrDeals.count>0) {
                                 int counter;
                                 if (isNeedShowCoverPhoto) {
                                     counter = imageIndex % (self.arrDeals.count + 1);
                                     
                                 }
                                 else{
                                     counter = imageIndex % self.arrDeals.count;
                                     
                                 }
                                 
                                 CGRect frame = self.ibCollectionView.frame;
                                 frame.origin.x = frame.size.width * counter;
                                 frame.origin.y = 0;
                                 [self.ibCollectionView scrollRectToVisible:frame animated:YES];
                                 
                                 //                                 NSIndexPath *iPath = [NSIndexPath indexPathForItem:counter inSection:0];
                                 //                                 [self.ibCollectionView scrollToItemAtIndexPath:iPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                                 //
                                 //                                 if (counter == 0) {
                                 //                                     [self.ibCollectionView scrollToItemAtIndexPath:iPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                                 //                                 }
                                 //                                 else{
                                 //                                     [self.ibCollectionView scrollToItemAtIndexPath:iPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                                 //                                     
                                 //                                     
                                 //                                 }
                                 imageIndex ++;
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
   
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width, 160);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isNeedShowCoverPhoto) {
        
        return self.arrDeals.count + 1;

    }
    else
    {
        return self.arrDeals.count;

    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCVCell" forIndexPath:indexPath];
    
    if (isNeedShowCoverPhoto && indexPath.row == 0) {
        
        [cell initCoverTitle:self.homeModel.featured_title CoverImage:self.homeModel.featured_image];
        
    }else{
        DealModel* model = self.arrDeals[indexPath.row - 1];

        [cell initData:model];

    }

    
    return cell;
    


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    if (scrollView == self.ibCollectionView) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        imageIndex = page+1;
    
    }
}


@end


//
//  FeedType_SuggestionFetureTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/12/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FeedType_SuggestionFetureTblCell.h"
#import "SuggestionFeatureCVCell.h"

@interface FeedType_SuggestionFetureTblCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (weak, nonatomic) NSArray<ProfileModel*> *arrSuggestedFeatures;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
@implementation FeedType_SuggestionFetureTblCell

-(void)initData:(NSArray<ProfileModel*>*)array
{
    self.arrSuggestedFeatures = array;
    [self.ibCollectionView reloadData];
    self.lblTitle.text = LocalisedString(@"Your friends are on Seeties");
}
-(void)initSelfView
{
    [self initCollectionViewDelegate];
}

-(void)initCollectionViewDelegate
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[SuggestionFeatureCVCell class] forCellWithReuseIdentifier:@"SuggestionFeatureCVCell"];

}
    
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrSuggestedFeatures.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestionFeatureCVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuggestionFeatureCVCell" forIndexPath:indexPath];
    
    ProfileModel* model = self.arrSuggestedFeatures[indexPath.row];
    [cell initData:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [Utils getDeviceScreenSize];
    float suggestedFrameSize = (frame.size.width);
    return CGSizeMake(suggestedFrameSize - 40, (suggestedFrameSize/4) + 66);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileModel* model = self.arrSuggestedFeatures[indexPath.row];
    if (self.didSelectprofileBlock) {
        self.didSelectprofileBlock(model);
    }
}


@end

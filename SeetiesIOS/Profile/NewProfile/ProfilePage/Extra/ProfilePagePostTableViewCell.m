//
//  ProfilePagePostTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePagePostTableViewCell.h"
#import "ProfilePagePostCollectionViewCell.h"

@interface ProfilePagePostTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

@property (strong, nonatomic) NSArray* arrPost;

@end

@implementation ProfilePagePostTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(int)getHeight
{
    return 100.0f;
}

-(void)initSelfView
{
    [self initCollectionView];
}

-(void)initCollectionView
{
    self.ibCollectionView.delegate = self;
    self.ibCollectionView.dataSource = self;
    [self.ibCollectionView registerClass:[ProfilePagePostCollectionViewCell class] forCellWithReuseIdentifier:@"ProfilePagePostCollectionViewCell"];
}


-(void)initData:(NSArray*)array
{
    self.arrPost = array;
    [self.ibCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPost.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilePagePostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePagePostCollectionViewCell" forIndexPath:indexPath];
    
    DraftModel* draftModel = self.arrPost[indexPath.row];
    
    if (![draftModel.arrPhotos isNull]) {
        PhotoModel* model = draftModel.arrPhotos[0];
        [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            cell.ibImageView.image = [image imageCroppedAndScaledToSize:cell.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
            
        }];
    }
    
    return cell;
}

@end

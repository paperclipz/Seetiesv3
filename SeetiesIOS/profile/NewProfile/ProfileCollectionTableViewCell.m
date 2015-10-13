//
//  ProfileCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileCollectionTableViewCell.h"
#import "ProfileImageCollectionViewCell.h"


@interface ProfileCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;

@end

@implementation ProfileCollectionTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    [self initCollectionViewWithDelegate:self];
}

-(void)initCollectionViewWithDelegate:(id)delegate
{
    self.ibCollectionView.delegate = delegate;
    self.ibCollectionView.dataSource = delegate;
    [self.ibCollectionView registerClass:[ProfileImageCollectionViewCell class] forCellWithReuseIdentifier:@"ProfileImageCollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileImageCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileImageCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}

@end

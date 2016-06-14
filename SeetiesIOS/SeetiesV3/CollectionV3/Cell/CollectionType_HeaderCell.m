//
//  CollectionType_HeaderCell.m
//  Seeties
//
//  Created by ZackTvZ on 6/13/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionType_HeaderCell.h"
#import "CollectionType_Header_TagCell.h"

@interface CollectionType_HeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cover2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDescLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property(weak, nonatomic) CollectionModel *collectionModel;
@end

@implementation CollectionType_HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)process:(CollectionModel *)collectionModel{
    self.collectionModel = collectionModel;
    [self setupLocalize];
    [self styleUI];
    
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:collectionModel.user_info.profile_photo] placeholderImage:[Utils getProfilePlaceHolderImage]];
    self.contentLabel.text = self.collectionModel.name;
    self.contentDetailLabel.text = [[NSString alloc]initWithFormat:@"by %@ • %d %@", self.collectionModel.user_info.name, self.collectionModel.follower_count, LocalisedString(@"Followers")];
    self.contentDescLabel.text = self.collectionModel.postDesc;
    
    
    if(collectionModel.arrayPost.count>0){
        DraftModel *object = collectionModel.arrayPost[0];
        if(object.arrPost.count>0){
            PhotoModel* photoModel = object.arrPhotos[0];
            [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] placeholderImage:[Utils getCoverPlaceHolderImage]];
        }
        
        if(collectionModel.arrayPost.count>1){
            DraftModel *object = collectionModel.arrayPost[1];
            if(object.arrPost.count>0){
                PhotoModel* photoModel = object.arrPhotos[0];
                [self.cover2ImgView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] placeholderImage:[Utils getCoverPlaceHolderImage]];
            }
        }
    }
    
    [self.tagCollectionView reloadData];
}

#pragma mark - CollectionView

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionModel.tagList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CollectionType_Header_TagCell *cell = (CollectionType_Header_TagCell *) [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
//    
//    if (cell == nil) {
//        CollectionType_Header_TagCell *cell = [collectionView
//                                               dequeueReusableCellWithReuseIdentifier:@"cell"
//                                               forIndexPath:indexPath];
//    
//    [cell.tagBtn setTitle:[self.collectionModel.tagList objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
//    }
    
//    CGSize CellSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize withHorizontalFittingPriority:UILayoutPriorityDefaultHigh verticalFittingPriority:UILayoutPriorityDefaultLow];
    
    
    return CGSizeMake(100, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionType_Header_TagCell *cell = [collectionView
                                            dequeueReusableCellWithReuseIdentifier:@"Cell"
                                            forIndexPath:indexPath];
    
    [cell.tagBtn setTitle:[self.collectionModel.tagList objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - Localize

-(void)setupLocalize{
    [self.actionBtn setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
}


#pragma mark - Style

-(void)styleUI{
    [Utils setRoundBorder:self.avatarImgView color:[UIColor whiteColor] borderRadius:self.avatarImgView.frame.size.width/2 borderWidth:2];
    [Utils setRoundBorder:self.actionBtn color:UIColorFromRGB(204, 204, 204, 1) borderRadius:self.actionBtn.frame.size.height/2];
    
}


@end

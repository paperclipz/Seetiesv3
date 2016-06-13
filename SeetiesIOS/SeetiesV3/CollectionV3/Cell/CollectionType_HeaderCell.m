//
//  CollectionType_HeaderCell.m
//  Seeties
//
//  Created by ZackTvZ on 6/13/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionType_HeaderCell.h"

@interface CollectionType_HeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cover2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
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
}



#pragma mark - Localize

-(void)setupLocalize{
    [self.actionBtn setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
}


#pragma mark - Style

-(void)styleUI{
    [Utils setRoundBorder:self.avatarImgView color:[UIColor whiteColor] borderRadius:self.avatarImgView.frame.size.width/2 borderWidth:2];
    [Utils setRoundBorder:self.actionBtn color:UIColorFromRGB(204, 204, 204, 1) borderRadius:self.actionBtn.frame.size.height/2];
    
    [self styleContentLabel];
}

-(void)styleContentLabel{
    NSString *title = self.collectionModel.name;
    NSString *authorName = self.collectionModel.user_info.name;
    int followerCount = self.collectionModel.follower_count;
    NSString *desc = self.collectionModel.postDesc;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if(title && title.length>0){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineSpacing:8];
        [style setAlignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, attributedString.length)];
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:CustomFontNameBold size:17],
                                     NSParagraphStyleAttributeName:style,
                                     };
        [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:title attributes:attributes]];
    }
    
    if(authorName && authorName.length>0){
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:8];
        [style setAlignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, attributedString.length)];
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:CustomFontName size:13],
                                     NSParagraphStyleAttributeName:style,
                                     };
        [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[] attributes:attributes]];
    }
    
}

@end

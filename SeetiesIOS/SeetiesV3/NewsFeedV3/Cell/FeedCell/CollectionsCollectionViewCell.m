//
//  CollectionsCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionsCollectionViewCell.h"

#define NO_LOCK_CONSTRSINT_CONSTANT 10.0f
#define LOCK_CONSTRSINT_CONSTANT 33.0f

@interface CollectionsCollectionViewCell()
{
    
    __weak IBOutlet NSLayoutConstraint *ibCollectionNameLeadingConstraint;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageLock;

@property (assign, nonatomic)ProfileViewType profileType;

@end
@implementation CollectionsCollectionViewCell

-(void)initSelfView
{
    
    [self.ibImageViewA setStandardBorder];
    [self.ibImageViewB setStandardBorder];
    
    [self changeLanguage];
}

-(void)changeLanguage
{
    [self.btnFollow setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
}

+(int)getHeight
{
    return 190.0f;
}

-(void)initData:(CollectionModel*)model profileType:(ProfileViewType)type
{
    
    self.model = model;
    self.profileType = type;
    
    self.lblTitle.text = self.model.name;
    self.lblNoOfCollection.text = [NSString stringWithFormat:@"%d %@",self.model.collection_posts_count,LocalisedString(@"Recommendations")];
    
    self.ibImageViewA.image = [UIImage imageNamed:@"EmptyCollection.png"];
    self.ibImageViewB.image = [UIImage imageNamed:@"EmptyCollection.png"];
    
    if (![self.model.arrayPost isNull])
    {
        DraftModel* draftModel = self.model.arrayPost[0];
        
        if (![draftModel.arrPhotos isNull]) {
            
            
            if (![draftModel.arrPhotos isNull]) {
                PhotoModel* photoModel1 = draftModel.arrPhotos[0];
                
                [self.ibImageViewA sd_setImageWithURL:[NSURL URLWithString:photoModel1.imageURL]];
                
            }
            
        }
        
        if (self.model.arrayPost.count > 1) {
            
            DraftModel* draftModelTwo = self.model.arrayPost[1];
            
            if (![draftModelTwo.arrPhotos isNull]) {
                PhotoModel* photoModel2 = draftModelTwo.arrPhotos[0];
                
                [self.ibImageViewB sd_setImageWithURL:[NSURL URLWithString:photoModel2.imageURL]];
                // SLog(@"Image A: %@",photoModel2.imageURL);
                
            }
        }
    }
    
    if (self.profileType == ProfileViewTypeOwn) {
        [self.btnFollow setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
        [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
        [Utils setRoundBorder:self.btnFollow color:LINE_COLOR borderRadius:self.btnFollow.frame.size.height/2];
        
        [self.btnFollow setImage:nil forState:UIControlStateNormal];
        [self.btnFollow setImage:nil forState:UIControlStateSelected];
        
    }
    else{
        [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
        [Utils setRoundBorder:self.btnFollow color:[UIColor clearColor] borderRadius:0];
        
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
        [self.btnFollow setTitle:@"" forState:UIControlStateNormal];
        [self.btnFollow setTitle:@"" forState:UIControlStateSelected];
        
        [DataManager getCollectionFollowing:self.model.collection_id HasCollected:^(BOOL isCollected) {
            [self setFollowButtonSelected:isCollected button:self.btnFollow];
            
        } completion:^{
            [self setFollowButtonSelected:self.model.following button:self.btnFollow];
        }];
    }
    
    [UIView transitionWithView:self duration:TRANSITION_DURTION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.ibImageLock.hidden = !self.model.isPrivate;
        ibCollectionNameLeadingConstraint.constant =self.model.isPrivate?LOCK_CONSTRSINT_CONSTANT:NO_LOCK_CONSTRSINT_CONSTANT;
        [self.ibImageLock refreshConstraint];
    } completion:nil];
    
    
}

-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button
{
    button.selected = selected;
    // button.backgroundColor = selected?[UIColor whiteColor]:SELECTED_GREEN;
    
}

@end

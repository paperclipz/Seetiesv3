//
//  CollectionsCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionsCollectionViewCell.h"

#define LOCK_CONSTRSINT_CONSTANT 20.0f
#define TITLE_CONSTRSINT_CONSTANT 48.0f

@interface CollectionsCollectionViewCell()
{
    
    __weak IBOutlet NSLayoutConstraint *constTitleWidth;
    __weak IBOutlet NSLayoutConstraint *constLockWidth;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageLock;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfPost;

@property (weak, nonatomic) IBOutlet UIView *ibCBorderView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfFollower;
@end
@implementation CollectionsCollectionViewCell
- (IBAction)btnFollowClicked:(id)sender {
    
//    UIButton* btn = (UIButton*)sender;
//    [btn setSelected:!btn.selected];
    
    if (self.btnFollowBlock) {
        self.btnFollowBlock();
    }
}

-(void)initSelfView
{
    
   
    [Utils setRoundBorder:self.ibImageViewB color:LINE_COLOR borderRadius:0 borderWidth:1.0f];
    [Utils setRoundBorder:self.ibImageViewA color:LINE_COLOR borderRadius:0 borderWidth:1.0f];

    [Utils setRoundBorder:self.ibCBorderView color:LINE_COLOR borderRadius:5.0f borderWidth:1.0f];
    
    
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

-(void)initData:(CollectionModel*)model
{
    
    self.model = model;
    
    self.lblTitle.text = self.model.name;
    self.lblNoOfPost.text = [NSString stringWithFormat:@"%d",self.model.collection_posts_count];
    self.lblNoOfFollower.text = [NSString stringWithFormat:@"%d",self.model.follower_count];

    self.ibImageViewA.image = [UIImage imageNamed:@"EmptyCollection.png"];
    self.ibImageViewB.image = [UIImage imageNamed:@"EmptyCollection.png"];
    
    if (![self.model.arrayPost isNull])
    {
        DraftModel* draftModel = self.model.arrayPost[0];
        
        if (![draftModel.arrPhotos isNull]) {
            
            
            if (![draftModel.arrPhotos isNull]) {
                PhotoModel* photoModel1 = draftModel.arrPhotos[0];
                
                [self.ibImageViewA sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel1.imageURL] completed:nil];

            }
            
        }
        
        if (self.model.arrayPost.count > 1) {
            
            DraftModel* draftModelTwo = self.model.arrayPost[1];
            
            if (![draftModelTwo.arrPhotos isNull]) {
                PhotoModel* photoModel2 = draftModelTwo.arrPhotos[0];
                
                [self.ibImageViewB sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel2.imageURL] completed:nil];

                // SLog(@"Image A: %@",photoModel2.imageURL);
                
            }
        }
    }
    
    
    
        [Utils setRoundBorder:self.btnFollow color:[UIColor clearColor] borderRadius:0];
        
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"CollectionFollowIcon.png")] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"CollectionFollowingIcon.png")] forState:UIControlStateSelected];
        [self.btnFollow setTitle:@"" forState:UIControlStateNormal];
        [self.btnFollow setTitle:@"" forState:UIControlStateSelected];
        
        [DataManager getCollectionFollowing:self.model.collection_id HasCollected:^(BOOL isCollected) {
            
            [self.btnFollow setSelected:isCollected];
        } completion:^{
            
            [self.btnFollow setSelected:self.model.following];

            

        }];
    
    [UIView transitionWithView:self duration:TRANSITION_DURTION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.ibImageLock.hidden = !self.model.isPrivate;
        
        if (self.model.isPrivate) {
            constLockWidth.constant = LOCK_CONSTRSINT_CONSTANT;
            constTitleWidth.constant = TITLE_CONSTRSINT_CONSTANT;
        }
        else
        {
            constLockWidth.constant = 0;
            constTitleWidth.constant = 16;

        }
       
        
        [self refreshConstraint];

    } completion:nil];
    
    
}



@end

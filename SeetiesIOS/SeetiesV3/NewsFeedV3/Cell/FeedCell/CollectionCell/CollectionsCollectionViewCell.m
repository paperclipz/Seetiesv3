//
//  CollectionsCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/11/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CollectionsCollectionViewCell.h"

#define NO_LOCK_CONSTRSINT_CONSTANT 0.0f
#define LOCK_CONSTRSINT_CONSTANT 30.0f

@interface CollectionsCollectionViewCell()
{
    
    __weak IBOutlet NSLayoutConstraint *constLockWidth;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageLock;

@end
@implementation CollectionsCollectionViewCell
- (IBAction)btnFollowClicked:(id)sender {
    
    UIButton* btn = (UIButton*)sender;
    [btn setSelected:!btn.selected];
}

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

-(void)initData
{
    [self.ibImageViewA sd_setImageWithURL:[NSURL URLWithString:@"http://www.planwallpaper.com/static/images/best_modern_city_wallpaper_hd.jpg"]];
    [self.ibImageViewB sd_setImageWithURL:[NSURL URLWithString:@"http://thewallpaperhost.com/wp-content/uploads/0382763769f46da4ff3c6644eeac648c_large.jpeg"]];

}
-(void)initData:(CollectionModel*)model
{
    
    self.model = model;
    
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
    
    
    
        [Utils setRoundBorder:self.btnFollow color:[UIColor clearColor] borderRadius:0];
        
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
        [self.btnFollow setTitle:@"" forState:UIControlStateNormal];
        [self.btnFollow setTitle:@"" forState:UIControlStateSelected];
        
        [DataManager getCollectionFollowing:self.model.collection_id HasCollected:^(BOOL isCollected) {
            
            [self.btnFollow setSelected:isCollected];
        } completion:^{
            
            [self.btnFollow setSelected:self.model.following];

            

        }];
    
    [UIView transitionWithView:self duration:TRANSITION_DURTION options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.ibImageLock.hidden = !self.model.isPrivate;
        constLockWidth.constant =self.model.isPrivate?LOCK_CONSTRSINT_CONSTANT:NO_LOCK_CONSTRSINT_CONSTANT;
        [self.ibImageLock refreshConstraint];
    } completion:nil];
    
    
}


@end

//
//  ProfilePageCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionTableViewCell.h"

#define NO_LOCK_CONSTRSINT_CONSTANT 10.0f
#define LOCK_CONSTRSINT_CONSTANT 33.0f

@interface ProfilePageCollectionTableViewCell()
{

    __weak IBOutlet NSLayoutConstraint *ibCollectionNameLeadingConstraint;

}
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageLock;

@property (assign, nonatomic)ProfileViewType profileType;

@end
@implementation ProfilePageCollectionTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnShareClicked:(id)sender {
    
    if (_btnShareClicked) {
        self.btnShareClicked();
    }
    
}
- (IBAction)btnEditClicked:(id)sender {
    
    if (_btnEditClickedBlock) {
        
        if (self.profileType == ProfileViewTypeOwn) {
            self.btnEditClickedBlock();

        }
        else{
            if (_btnFollowBlock) {
                self.btnFollowBlock();
            }
        }
    }
}

-(void)initSelfView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    [self.ibImageViewA setStandardBorder];
    [self.ibImageViewB setStandardBorder];
    
    [self changeLanguage];
}

-(void)changeLanguage
{
    [self.btnEdit setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
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
    self.lblNoOfCollection.text = [NSString stringWithFormat:@"%d %@",self.model.collection_posts_count,LocalisedString(@"recommendation")];
    
    self.ibImageViewA.image = [UIImage imageNamed:@"EmptyCollection.png"];
    self.ibImageViewB.image = [UIImage imageNamed:@"EmptyCollection.png"];

    if (![self.model.arrayPost isNull])
    {
        DraftModel* draftModel = self.model.arrayPost[0];
    
        if (![draftModel.arrPhotos isNull]) {
            
            
            if (![draftModel.arrPhotos isNull]) {
                PhotoModel* photoModel1 = draftModel.arrPhotos[0];

                [self.ibImageViewA sd_setImageWithURL:[NSURL URLWithString:photoModel1.imageURL]];
                //SLog(@"Image A: %@",photoModel1.imageURL);

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
        [self.btnEdit setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
        [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
        [Utils setRoundBorder:self.btnEdit color:LINE_COLOR borderRadius:self.btnEdit.frame.size.height/2];
        
        [self.btnEdit setImage:nil forState:UIControlStateNormal];
        [self.btnEdit setImage:nil forState:UIControlStateSelected];


    }
    else{
        [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
        [Utils setRoundBorder:self.btnEdit color:[UIColor clearColor] borderRadius:0];

        [self.btnEdit setImage:[UIImage imageNamed:LocalisedString(@"FollowCollectionIcon.png")] forState:UIControlStateNormal];
        [self.btnEdit setImage:[UIImage imageNamed:LocalisedString(@"FollowingCollectionIcon.png")] forState:UIControlStateSelected];
        
//        [self.btnEdit setTitle:LocalisedString(@"Follow") forState:UIControlStateNormal];
//        [self.btnEdit setTitle:LocalisedString(@"Following") forState:UIControlStateSelected];
//        [self.btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.btnEdit setTitleColor:SELECTED_GREEN forState:UIControlStateSelected];

        
        [DataManager getCollectionFollowing:self.model.collection_id HasCollected:^(BOOL isCollected) {
            [self setFollowButtonSelected:isCollected button:self.btnEdit];

        } completion:^{
            [self setFollowButtonSelected:self.model.following button:self.btnEdit];
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

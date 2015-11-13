//
//  ProfilePageCollectionTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfilePageCollectionTableViewCell.h"
@interface ProfilePageCollectionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewA;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageViewB;
@property (strong, nonatomic) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

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
    [Utils setRoundBorder:self.ibInnerContentView color:LINE_COLOR borderRadius:5.0f];
    [Utils setRoundBorder:self.btnEdit color:LINE_COLOR borderRadius:self.btnEdit.frame.size.height/2];
    
    [self.ibImageViewA setStandardBorder];
    [self.ibImageViewB setStandardBorder];
    
   
}

+(int)getHeight
{
    return 170.0f;
}

-(void)initData:(CollectionModel*)model profileType:(ProfileViewType)type
{

    self.model = model;
    self.profileType = type;
    
    self.lblTitle.text = self.model.name;
    self.lblNoOfCollection.text = [NSString stringWithFormat:@"%d %@",self.model.collection_posts_count,LocalisedString(@"recommendation")];
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
                
            }
        }
    }
    
    
    if (self.profileType == ProfileViewTypeOwn) {
        [self.btnEdit setTitle:LocalisedString(@"Edit") forState:UIControlStateNormal];
        
    }
    else{
        [self.btnEdit setTitle:LocalisedString(@"Follow") forState:UIControlStateNormal];
        [self.btnEdit setTitle:LocalisedString(@"Following") forState:UIControlStateSelected];
        [self.btnEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnEdit setTitleColor:SELECTED_GREEN forState:UIControlStateSelected];

        [self setFollowButtonSelected:self.model.following button:self.btnEdit];
    }
   
   
//
//    if (self.model.arrTempFeedsPost>0) {
//        
//        DraftModel* postModel = self.model.arrTempFeedsPost[0];
//        
//        if (postModel.arrPhotos.count>0) {
//            
//        }
//    }
    
}

-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button
{
    button.selected = selected;
    button.backgroundColor = selected?[UIColor whiteColor]:SELECTED_GREEN;
    
}

@end

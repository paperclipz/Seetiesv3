//
//  SeetizensTableViewCell.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeetizensTableViewCell.h"
@interface SeetizensTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageUserProfile;
@property (weak, nonatomic) IBOutlet UILabel *ibLabelUsername;
@property (strong, nonatomic) UserModel *model;
@end

@implementation SeetizensTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnFollowClicked:(id)sender {
    
    if (_btnFollowBlock) {
        self.btnFollowBlock();
    }
}
-(void)setFollowButtonSelected:(BOOL)selected button:(UIButton*)button
{
    button.selected = selected;
    // button.backgroundColor = selected?[UIColor whiteColor]:SELECTED_GREEN;
    
}
-(void)initData:(UserModel*)model{
    
    [self.ibImageUserProfile setSideCurveBorder];
    
    self.ibLabelUsername.text = model.username;
   // [self.ibImageUserProfile sd_setImageWithURL:[NSURL URLWithString:model.profile_photo_images]];
    [self.ibImageUserProfile sd_setImageWithURL:[NSURL URLWithString:model.profile_photo]];
    
    
    if (model.following == YES) {
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
    }else{
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
    }
    
    

}
@end

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
@property (strong, nonatomic) UserModel *model;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@end

@implementation SeetizensTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [Utils setRoundBorder:self.btnFollow color:SELECTED_GREEN borderRadius:self.btnFollow.frame.size.height/2];
    [self.ibImageUserProfile setSideCurveBorder];

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
    
    
    @try {
        self.lblUserName.text = model.username;
        [self.ibImageUserProfile sd_setImageWithURL:[NSURL URLWithString:model.profile_photo]];
        self.lblLocation.text = model.location;
    }
    @catch (NSException *exception) {
        SLog(@"initData error");
    }
   
    
    
    
    if (model.following == YES) {
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateSelected];
    }else{
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowIcon.png"] forState:UIControlStateNormal];
        [self.btnFollow setImage:[UIImage imageNamed:@"FollowingIcon.png"] forState:UIControlStateSelected];
    }
    
    

}
@end

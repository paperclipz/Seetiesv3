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
@property (weak, nonatomic) IBOutlet UIView *ibCBordrView;
@end

@implementation SeetizensTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
  //  [Utils setRoundBorder:self.btnFollow color:SELECTED_GREEN borderRadius:self.btnFollow.frame.size.height/2];
    [self.ibImageUserProfile setSideCurveBorder];
    [self.btnFollow setImage:[UIImage imageNamed:@"AddFriendIcon.png"] forState:UIControlStateNormal];
    [self.btnFollow setImage:[UIImage imageNamed:@"AddedFriendIcon.png"] forState:UIControlStateSelected];
    
    [Utils setRoundBorder:self.ibCBordrView color:OUTLINE_COLOR borderRadius:0 borderWidth:1.0f];
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
        
        
        if (![Utils isStringNull:model.profile_photo]) {
            [self.ibImageUserProfile sd_setImageCroppedWithURL:[NSURL URLWithString:model.profile_photo] withPlaceHolder:[UIImage imageNamed:@"DefaultProfilePic.png"] completed:nil];
        }
        
        self.lblLocation.text = model.location;
    }
    @catch (NSException *exception) {
        SLog(@"initData error");
    }
    
    
    [self setFollowButtonSelected:model.following button:self.btnFollow];
    
    

}
@end

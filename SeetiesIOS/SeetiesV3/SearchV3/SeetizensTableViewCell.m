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
@end

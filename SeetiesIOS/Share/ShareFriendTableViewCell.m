//
//  ShareFriendTableViewCell.m
//  SeetiesIOS
//
//  Created by Lai on 13/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShareFriendTableViewCell.h"

@implementation ShareFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.bounds) / 2;
    
    self.profileImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

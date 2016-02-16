//
//  BranchOutletTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "BranchOutletTblCell.h"
@interface BranchOutletTblCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@end
@implementation BranchOutletTblCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    self.ibImageView.hidden = !self.selected;
    // Configure the view for the selected state
}

@end

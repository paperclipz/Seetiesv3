//
//  SearchSimpleTableViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/9/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SearchSimpleTableViewCell.h"

@implementation SearchSimpleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnSuggestSearchClicked:(id)sender {
    
    if (self.btnSuggestSearchClickedBlock) {
        self.btnSuggestSearchClickedBlock();
    }
}

@end

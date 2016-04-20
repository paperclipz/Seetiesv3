//
//  DealType_ReferFriendTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 20/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_ReferFriendTblCell.h"

@interface DealType_ReferFriendTblCell()

@property (weak, nonatomic) IBOutlet UIView *ibCborderview;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibDesc;

@end

@implementation DealType_ReferFriendTblCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [Utils setRoundBorder:self.ibCborderview color:OUTLINE_COLOR borderRadius:0 borderWidth:1.0f];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

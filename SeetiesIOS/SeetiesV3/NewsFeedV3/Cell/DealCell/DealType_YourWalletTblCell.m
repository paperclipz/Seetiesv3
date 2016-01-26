//
//  DealType_YourWalletTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_YourWalletTblCell.h"

@interface DealType_YourWalletTblCell()
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@end
@implementation DealType_YourWalletTblCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.lblCount color:OUTLINE_COLOR borderRadius:self.lblCount.frame.size.width/2];
}

@end
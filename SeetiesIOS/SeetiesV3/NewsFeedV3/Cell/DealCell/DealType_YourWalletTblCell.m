//
//  DealType_YourWalletTblCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/20/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealType_YourWalletTblCell.h"

@interface DealType_YourWalletTblCell()
@property (weak, nonatomic) IBOutlet UIView *ibCborderview;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibDesc;
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
    
    [Utils setRoundBorder:self.ibCborderview color:OUTLINE_COLOR borderRadius:0 borderWidth:1.0f];
}

-(void)initData:(int)walletCount
{
    self.ibTitle.text = LocalisedString(@"Voucher Wallet");
    self.ibDesc.text = LocalisedString(@"Check out your collected deals");
    NSString *countString = walletCount < 100? [NSString stringWithFormat:@"%d", walletCount] : @"99+";
    self.lblCount.text = countString;
    
}

@end

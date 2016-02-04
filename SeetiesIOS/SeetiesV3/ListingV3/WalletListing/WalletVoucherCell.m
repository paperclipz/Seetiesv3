//
//  WalletVoucherCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 06/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletVoucherCell.h"

@interface WalletVoucherCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImg;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherExpiryLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealUsageLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibRedeemBtn;

@end

@implementation WalletVoucherCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibRedeemBtn setSideCurveBorder];
    [self.ibDealUsageLbl setSideCurveBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

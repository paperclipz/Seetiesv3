//
//  VoucherCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherCell.h"

@interface VoucherCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImage;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTag1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTag2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTag3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTopLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherLeftLbl;

@end

@implementation VoucherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

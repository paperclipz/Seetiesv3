//
//  VoucherFilterCellTableViewCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 06/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherFilterCellTableViewCell.h"

@interface VoucherFilterCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *ibFilterLbl;

@end

@implementation VoucherFilterCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  WalletHeaderCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 05/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletHeaderCell.h"

@interface WalletHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;

@end

@implementation WalletHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setHeaderTitle:(NSString*)title{
    self.ibHeaderTitle.text = title;
}

@end

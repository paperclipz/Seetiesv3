//
//  RedemptionHistoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 05/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "RedemptionHistoryCell.h"

@interface RedemptionHistoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *ibDealImage;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealOutletLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibRedemptionDateLbl;

@end

@implementation RedemptionHistoryCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibRedemptionDateLbl setSideCurveBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

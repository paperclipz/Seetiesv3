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

@property(nonatomic) DealModel *voucher;

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

-(void)setVoucher:(DealModel *)voucher{
    _voucher = voucher;
    
    if ([Utils stringIsNilOrEmpty:self.voucher.cover_title]) {
        self.ibDealTitleLbl.text = self.voucher.title;
    }
    else{
        self.ibDealTitleLbl.text = self.voucher.cover_title;
    }
    
    SeShopDetailModel *shopModel = self.voucher.voucher_info.shop_info;
    self.ibDealOutletLbl.text = shopModel.location.formatted_address;
    
    @try {
        NSString* imageURL = shopModel.profile_photo[@"picture"];
        if (![Utils isStringNull:imageURL]) {
            [self.ibDealImage sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image) {
            }];
        }
        [Utils setRoundBorder:self.ibDealImage color:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1] borderRadius:2.5f];
    }
    @catch (NSException *exception) {
        SLog(@"assign profile image fail");
    }
   
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *redemptionDate = [dateFormatter dateFromString:self.voucher.voucher_info.redeemed_at];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    self.ibRedemptionDateLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"REDEEMED ON"), [dateFormatter stringFromDate:redemptionDate]];
    
}

@end

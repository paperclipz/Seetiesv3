//
//  RedemptionHistoryCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 05/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "RedemptionHistoryCell.h"
#import "TTTAttributedLabel.h"

@interface RedemptionHistoryCell()
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibDealImage;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealOutletLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibRedemptionDateLbl;

@property(nonatomic) DealModel *voucher;

@end

@implementation RedemptionHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = nil;
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
    NSString *shopName = shopModel.name;
    NSString *shopAddress = shopModel.location.display_address;
    if ([Utils isStringNull:shopName]) {
        self.ibDealOutletLbl.text = shopAddress;
    }
    else if ([Utils isStringNull:shopAddress]){
        self.ibDealOutletLbl.text = shopName;
    }
    else if ([Utils isStringNull:shopName] && [Utils isStringNull:shopAddress]){
        self.ibDealOutletLbl.text = @"";
    }
    else{
        self.ibDealOutletLbl.text = [NSString stringWithFormat:@"%@ \u2022 %@", shopName, shopAddress];
    }
    
    @try {
        NSString* imageURL = shopModel.profile_photo[@"picture"];
        if (![Utils isStringNull:imageURL]) {
            [self.ibDealImage sd_setImageCroppedWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image) {
            }];
        }
        else{
            [self.ibDealImage setImage:[UIImage imageNamed:@"SsDefaultDisplayPhoto.png"]];
        }
        [Utils setRoundBorder:self.ibDealImage color:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1] borderRadius:2.5f];
    }
    @catch (NSException *exception) {
        SLog(@"assign profile image fail");
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *historyDate = [dateFormatter dateFromString:self.voucher.voucher_info.status_history_datetime];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *status = self.voucher.voucher_info.status;
    if ([status isEqualToString:VOUCHER_STATUS_REDEEMED]) {
        self.ibRedemptionDateLbl.text = [[NSString stringWithFormat:@"%@ %@", LocalisedString(@"REDEEMED ON"), [dateFormatter stringFromDate:historyDate]] uppercaseString];
    }
    else if ([status isEqualToString:VOUCHER_STATUS_EXPIRED]){
        self.ibRedemptionDateLbl.text = [[NSString stringWithFormat:@"%@ %@", LocalisedString(@"EXPIRED ON"), [dateFormatter stringFromDate:historyDate]] uppercaseString];
    }
    else if ([status isEqualToString:VOUCHER_STATUS_DELETED]){
        self.ibRedemptionDateLbl.text = [[NSString stringWithFormat:@"%@ %@", LocalisedString(@"DELETED ON"), [dateFormatter stringFromDate:historyDate]] uppercaseString];
    }
    else if ([status isEqualToString:VOUCHER_STATUS_CANCELLED]){
        self.ibRedemptionDateLbl.text = [[NSString stringWithFormat:@"%@ %@", LocalisedString(@"CANCELLED ON"), [dateFormatter stringFromDate:historyDate]] uppercaseString];
    }
    else{
        self.ibRedemptionDateLbl.text = [[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:historyDate]] uppercaseString];
    }
    self.ibRedemptionDateLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [Utils setRoundBorder:self.ibRedemptionDateLbl color:[UIColor clearColor] borderRadius:self.ibRedemptionDateLbl.frame.size.height/2];
    
    [Utils setRoundBorder:self.ibInnerContentView color:[UIColor clearColor] borderRadius:10.0f];
}

@end

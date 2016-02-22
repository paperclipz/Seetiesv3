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

@property(nonatomic) DealModel *dealModel;

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

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    
    if ([Utils stringIsNilOrEmpty:self.dealModel.cover_title]) {
        self.ibVoucherTitleLbl.text = self.dealModel.title;
    }
    else{
        self.ibVoucherTitleLbl.text = self.dealModel.cover_title;
    }
    
    SeShopDetailModel *shopModel = [self.dealModel.shops objectAtIndex:0];
    self.ibVoucherShopLbl.text = shopModel.location.formatted_address;
    if (![Utils isStringNull:shopModel.profile_picture]) {
        [self.ibVoucherImg sd_setImageCroppedWithURL:[NSURL URLWithString:shopModel.profile_picture] completed:^(UIImage *image) {
        }];
    }
    
    if (self.dealModel.total_available_vouchers == -1) {
        self.ibDealUsageLbl.text = LocalisedString(@"REUSABLE");
        [self.ibDealUsageLbl setBackgroundColor:[UIColor colorWithRed:122/255.0f green:210/255.0f blue:27/255.0f alpha:1]];
    }
    else{
        self.ibDealUsageLbl.text = LocalisedString(@"1 TIME USE");
        [self.ibDealUsageLbl setBackgroundColor:[UIColor colorWithRed:253/255.0f green:175/255.0f blue:23/255.0f alpha:1]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.expired_at];
    
    NSInteger numberOfDaysLeft = [Utils numberOfDaysLeft:expiryDate];
    
    if (numberOfDaysLeft < 8) {
        self.ibVoucherExpiryLbl.text = [NSString stringWithFormat:@"%@ %ld %@", LocalisedString(@"Expires in "), numberOfDaysLeft, LocalisedString(@"Days")];
        self.ibVoucherExpiryLbl.textColor = [UIColor redColor];
    }
    else{
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        self.ibVoucherExpiryLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expires "), [dateFormatter stringFromDate:expiryDate]];
        self.ibVoucherExpiryLbl.textColor = [UIColor lightGrayColor];
    }
    
    VoucherInfoModel *voucherModel = self.dealModel.voucher_info;
    if (voucherModel.redeem_now) {
        [self.ibRedeemBtn setBackgroundColor:[UIColor colorWithRed:232/255.0f green:86/255.0f blue:99/255.f alpha:1]];
    }
    else{
        [self.ibRedeemBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

- (IBAction)redeemBtnClicked:(id)sender {
    if (self.walletVoucherDelegate) {
        [self.walletVoucherDelegate redeemVoucherClicked:self.dealModel];
    }
}

@end

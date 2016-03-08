//
//  WalletVoucherCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 06/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "WalletVoucherCell.h"
#import "TTTAttributedLabel.h"

@interface WalletVoucherCell()
@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImg;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherExpiryLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibDealUsageLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibRedeemBtn;

@property(nonatomic) DealModel *dealModel;

@end

@implementation WalletVoucherCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibRedeemBtn setSideCurveBorder];
    [Utils setRoundBorder:self.ibInnerContentView color:[UIColor clearColor] borderRadius:10.0f];

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
    
    SeShopDetailModel *shopModel = self.dealModel.voucher_info.shop_info;
    self.ibVoucherShopLbl.text = shopModel.location.formatted_address;
    
    @try {
        
        NSString* imageUrl = shopModel.profile_photo[@"picture"];
        if (![Utils isStringNull:imageUrl]) {
            [self.ibVoucherImg sd_setImageCroppedWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image) {
            }];
        }
        [Utils setRoundBorder:self.ibVoucherImg color:[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1] borderRadius:2.5f];
    }
    @catch (NSException *exception) {
        SLog(@"profile_photo fail");
    }
    
    if (self.dealModel.total_available_vouchers == -1) {
        self.ibDealUsageLbl.text = LocalisedString(@"REUSABLE");
        [self.ibDealUsageLbl setBackgroundColor:[UIColor colorWithRed:122/255.0f green:210/255.0f blue:26/255.0f alpha:1]];
    }
    else{
        self.ibDealUsageLbl.text = LocalisedString(@"1 TIME USE");
        [self.ibDealUsageLbl setBackgroundColor:[UIColor colorWithRed:253/255.0f green:175/255.0f blue:23/255.0f alpha:1]];
    }
    self.ibDealUsageLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [Utils setRoundBorder:self.ibDealUsageLbl color:[UIColor clearColor] borderRadius:self.ibDealUsageLbl.frame.size.height/2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *expiryString = self.dealModel.expired_at;
    NSInteger numberOfDaysLeft = 0;
    
    if ([Utils isValidDateString:expiryString]) {
        NSDate *expiryDate = [dateFormatter dateFromString:expiryString];
        numberOfDaysLeft = [Utils numberOfDaysLeft:expiryDate];
    }
    
    if (numberOfDaysLeft < 8 && numberOfDaysLeft > 0) {
        self.ibVoucherExpiryLbl.text = [NSString stringWithFormat:@"%@ %ld %@", LocalisedString(@"Expires in "), numberOfDaysLeft, LocalisedString(@"Days")];
        self.ibVoucherExpiryLbl.textColor = [UIColor colorWithRed:244/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        self.ibVoucherExpiryLbl.hidden = NO;
    }
    else if(numberOfDaysLeft > 8){
        NSDate *expiryDate = [dateFormatter dateFromString:expiryString];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        self.ibVoucherExpiryLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"Expires "), [dateFormatter stringFromDate:expiryDate]];
        self.ibVoucherExpiryLbl.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        self.ibVoucherExpiryLbl.hidden = NO;
    }
    else{
        self.ibVoucherExpiryLbl.hidden = YES;
    }
    
    VoucherInfoModel *voucherModel = self.dealModel.voucher_info;
    if (voucherModel.redeem_now) {
        [self.ibRedeemBtn setBackgroundColor:[UIColor colorWithRed:232/255.0f green:86/255.0f blue:99/255.f alpha:1]];
    }
    else{
        [self.ibRedeemBtn setBackgroundColor:[UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.f alpha:1]];
    }
    
}

- (IBAction)redeemBtnClicked:(id)sender {
    if (self.walletVoucherDelegate) {
        [self.walletVoucherDelegate redeemVoucherClicked:self.dealModel];
    }
}

@end

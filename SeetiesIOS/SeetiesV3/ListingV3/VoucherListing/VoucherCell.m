//
//  VoucherCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherCell.h"

@interface VoucherCell()
@property (nonatomic) DealModel *dealModel;

@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImage;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDaysLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibTag3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDiscountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibVoucherCollectBtn;
@property (weak, nonatomic) IBOutlet UIView *ibVoucherBlackOverylay;
@property (weak, nonatomic) IBOutlet UIImageView *ibOverlayIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherOverlayTitle;

@end

@implementation VoucherCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibVoucherCollectBtn setSideCurveBorder];
    [self.ibVoucherLeftLbl setSideCurveBorder];
    [self.ibDaysLeftLbl setSideCurveBorder];
    [self.ibTag3Lbl setSideCurveBorder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    
    if (![Utils isStringNull:self.dealModel.cover_title]) {
        self.ibVoucherTitleLbl.text = self.dealModel.cover_title;
    }
    else{
        self.ibVoucherTitleLbl.text = self.dealModel.title;
    }
    
    if (![Utils isArrayNull:self.dealModel.photos]) {
        PhotoModel *photoModel = [self.dealModel.photos objectAtIndex:0];
        [self.ibVoucherImage sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel.imageURL] completed:^(UIImage *image) {
            
        }];
    }
    
    if (![Utils isArrayNull:self.dealModel.shops]) {
        SeShopDetailModel *shopModel = [self.dealModel.shops objectAtIndex:0];
        self.ibVoucherShopLbl.text = shopModel.name;
    }
    
    [self setDealType];
    [self setRedeemCollect];
    [self setVoucherLeft];
    [self setDaysLeft];
    
}

-(void)setDealType{
    if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_FREE]) {
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@", [self.dealModel.deal_type uppercaseString]];
        self.ibDiscountLbl.hidden = YES;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_DISCOUNT]){
        self.ibDiscountLbl.hidden = NO;
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"RM"), self.dealModel.discounted_item_price];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", LocalisedString(@"RM"), self.dealModel.original_item_price] attributes:attributes];
        self.ibDiscountLbl.attributedText = attrText;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_PACKAGE]){
        self.ibDiscountLbl.hidden = NO;
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@ %@", LocalisedString(@"RM"), self.dealModel.discounted_item_price];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", LocalisedString(@"RM"), self.dealModel.original_item_price] attributes:attributes];
        self.ibDiscountLbl.attributedText = attrText;
    }
    else{
        self.ibDiscountLbl.hidden = YES;
        self.ibDealTypeLbl.hidden = YES;
    }
}

-(void)setVoucherLeft{
    if (self.dealModel.total_available_vouchers > 0 && self.dealModel.total_available_vouchers <= 10) {
        self.ibVoucherLeftLbl.hidden = NO;
        self.ibVoucherBlackOverylay.hidden = YES;
        self.ibVoucherLeftLbl.text = [NSString stringWithFormat:@"   %ld %@   ", self.dealModel.total_available_vouchers, LocalisedString(@"Vouchers Left")];
    }
    else if (self.dealModel.total_available_vouchers == 0){
        self.ibVoucherLeftLbl.hidden = YES;
        self.ibVoucherBlackOverylay.hidden = NO;
    }
    else{
        self.ibVoucherLeftLbl.hidden = YES;
        self.ibVoucherBlackOverylay.hidden = YES;
    }
}

-(void)setRedeemCollect{
    if ([Utils isStringNull:self.dealModel.voucherID]) {
        [self.ibVoucherCollectBtn setTitle:@"Collect" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:DEVICE_COLOR];
    }
    else{
        [self.ibVoucherCollectBtn setTitle:@"Redeem" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:[UIColor colorWithRed:239/255.0 green:83/255.0 blue:105/255.0 alpha:1]];
    }
}

-(void)setCollectBtnSelectedState:(BOOL)isSelected{
    if (isSelected) {
        [self.ibVoucherCollectBtn setTitle:@"Redeem" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:[UIColor colorWithRed:239.0f green:83.0f blue:105.0f alpha:1]];
    }
    else{
        [self.ibVoucherCollectBtn setTitle:@"Collect" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:DEVICE_COLOR];
    }
}

-(void)setDaysLeft{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.expired_at];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:[NSDate new] toDate:expiryDate options:NSCalendarWrapComponents];
//    SLog(@"Days left: %ld", [components day]);
    
    if ([components day] < 8) {
        self.ibDaysLeftLbl.hidden = NO;
        self.ibDaysLeftLbl.text = [NSString stringWithFormat:@"%ld %@", [components day], LocalisedString(@"Days Left")];
    }
    else{
        self.ibDaysLeftLbl.hidden = YES;
    }
}

- (IBAction)collectRedeemBtnClicked:(id)sender {
    if (self.voucherCellDelegate) {
        [self.voucherCellDelegate voucherCollectRedeemClicked:self.dealModel];
    }
}

@end

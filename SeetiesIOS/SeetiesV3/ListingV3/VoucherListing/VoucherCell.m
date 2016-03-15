//
//  VoucherCell.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherCell.h"
#import "TTTAttributedLabel.h"

@interface VoucherCell()
@property (nonatomic) DealModel *dealModel;

@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImage;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibVoucherLeftLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibDaysLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibTag3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDiscountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UIButton *ibVoucherCollectBtn;
@property (weak, nonatomic) IBOutlet UIView *ibVoucherBlackOverylay;
@property (weak, nonatomic) IBOutlet UIImageView *ibOverlayIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherOverlayTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibDaysLeftTopConstraint;

@end

@implementation VoucherCell

- (void)awakeFromNib {
    // Initialization code
    [self.ibVoucherCollectBtn setSideCurveBorder];
    
//    [self.ibInnerContentView prefix_addLowerBorder:OUTLINE_COLOR];
//    [self.ibInnerContentView prefix_addUpperBorder:OUTLINE_COLOR];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
//    [self.ibInnerContentView prefix_addLowerBorder:OUTLINE_COLOR];
//    [self.ibInnerContentView prefix_addUpperBorder:OUTLINE_COLOR];
    
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
        self.ibVoucherLeftLbl.text = [NSString stringWithFormat:@"%ld %@", self.dealModel.total_available_vouchers, LocalisedString(@"Vouchers Left")];
        self.ibVoucherLeftLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [Utils setRoundBorder:self.ibVoucherLeftLbl color:[UIColor clearColor] borderRadius:self.ibVoucherLeftLbl.frame.size.height/2-2];
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
    if ([Utils isStringNull:self.dealModel.voucher_info.voucher_id]) {
        [self.ibVoucherCollectBtn setTitle:@"Collect" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:DEVICE_COLOR];
        [self.ibVoucherCollectBtn setImage:[UIImage imageNamed:@"CollectIcon.png"] forState:UIControlStateNormal];
    }
    else{
        if (self.dealModel.voucher_info.redeem_now) {
            [self.ibVoucherCollectBtn setTitle:@"Redeem" forState:UIControlStateNormal];
            [self.ibVoucherCollectBtn setBackgroundColor:[UIColor colorWithRed:242/255.0 green:109/255.0 blue:125/255.0 alpha:1]];
            [self.ibVoucherCollectBtn setImage:[UIImage imageNamed:@"RedeemIcon.png"] forState:UIControlStateNormal];
        }
        else{
            [self.ibVoucherCollectBtn setTitle:@"Redeem" forState:UIControlStateNormal];
            [self.ibVoucherCollectBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
            [self.ibVoucherCollectBtn setImage:[UIImage imageNamed:@"RedeemIcon.png"] forState:UIControlStateNormal];
        }
        
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
    NSInteger numberOfDaysLeft = 0;
    
    if ([Utils isValidDateString:self.dealModel.expired_at]) {
        NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.expired_at];
        
        numberOfDaysLeft = [Utils numberOfDaysLeft:expiryDate];
    }
    
    if (numberOfDaysLeft < 8 && numberOfDaysLeft > 0) {
        self.ibDaysLeftLbl.hidden = NO;
        self.ibDaysLeftLbl.text = [NSString stringWithFormat:@"%ld %@", numberOfDaysLeft, LocalisedString(@"Days Left")];
        self.ibDaysLeftLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [Utils setRoundBorder:self.ibDaysLeftLbl color:[UIColor clearColor] borderRadius:self.ibDaysLeftLbl.frame.size.height/2];
        
        if (self.ibVoucherLeftLbl.hidden) {
            self.ibDaysLeftTopConstraint.constant = 10;
        }
        else{
            self.ibDaysLeftTopConstraint.constant = self.ibVoucherLeftLbl.frame.size.height + 10 + 5;
        }
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

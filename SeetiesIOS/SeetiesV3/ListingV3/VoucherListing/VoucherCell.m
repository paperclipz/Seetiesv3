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
@property (nonatomic) DealCollectionModel *dealCollectionModel;

@property (weak, nonatomic) IBOutlet UIView *ibInnerContentView;
@property (weak, nonatomic) IBOutlet UIImageView *ibVoucherImage;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibVoucherLeftLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibDaysLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibTag3Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDealTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibDiscountLbl;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherTitleLbl;

@property (weak, nonatomic) IBOutlet UIView *ibNormalShopView;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherShopLbl;
@property (weak, nonatomic) IBOutlet UIView *ibReferralShopView;
@property (weak, nonatomic) IBOutlet UILabel *ibVoucherReferralShopLbl;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ibVoucherReferralCityLbl;

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

    self.selectedBackgroundView = nil;
    // Configure the view for the selected state
}

-(void)initDealModel:(DealModel *)dealModel{
    _dealModel = dealModel;
    _dealCollectionModel = nil;
    [self initView];
}

-(void)initDealModel:(DealModel *)dealModel dealCollectionModel:(DealCollectionModel *)dealCollectionModel{
    _dealModel = dealModel;
    _dealCollectionModel = dealCollectionModel;
    [self initView];
}

-(void)initView{
    if (![Utils isStringNull:self.dealModel.cover_title]) {
        self.ibVoucherTitleLbl.text = self.dealModel.cover_title;
    }
    else{
        self.ibVoucherTitleLbl.text = self.dealModel.title;
    }
    
    if (![Utils isArrayNull:self.dealModel.photos]) {
        PhotoModel *photoModel = [self.dealModel.photos objectAtIndex:0];
        [self.ibVoucherImage sd_setImageCroppedWithURL:[NSURL URLWithString:photoModel.imageURL] withPlaceHolder:[Utils getCoverPlaceHolderImage] completed:nil];
    }
    else{
        [self.ibVoucherImage setImage:[Utils getCoverPlaceHolderImage]];
    }
    
    SeShopDetailModel *shopModel = self.dealModel.shops[0];
    NSString *shopName = shopModel.name;
    NSString *shopAddress = shopModel.location.display_address;
//    if ([self.dealModel.voucher_type isEqualToString:VOUCHER_TYPE_REFERRAL]) {
//        self.ibReferralShopView.hidden = NO;
//        self.ibNormalShopView.hidden = YES;
//        
//        self.ibVoucherReferralShopLbl.text = shopName;
//        self.ibVoucherReferralCityLbl.text = [shopAddress uppercaseString];   //To be changed to city
//        self.ibVoucherReferralCityLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
//        [Utils setRoundBorder:self.ibVoucherReferralCityLbl color:[UIColor clearColor] borderRadius:self.ibVoucherReferralCityLbl.frame.size.height/2];
//    }
//    else{
        self.ibReferralShopView.hidden = YES;
        self.ibNormalShopView.hidden = NO;
        
        if ([Utils isStringNull:shopName]) {
            self.ibVoucherShopLbl.text = shopAddress;
        }
        else if ([Utils isStringNull:shopAddress]){
            self.ibVoucherShopLbl.text = shopName;
        }
        else if ([Utils isStringNull:shopName] && [Utils isStringNull:shopAddress]){
            self.ibVoucherShopLbl.text = @"";
        }
        else{
            self.ibVoucherShopLbl.text = [NSString stringWithFormat:@"%@ \u2022 %@", shopName, shopAddress];
        }
//    }
    
    [self setDealType];
    [self setRedeemCollect];
    [self setVoucherLeft];
    [self setDaysLeft];
    [self setHeaderOverlay];
}

-(void)setDealType{
    
    self.ibDealTypeLbl.hidden = NO;
    self.ibDiscountLbl.hidden = NO;
    [self.ibDealTypeLbl setFont:[UIFont boldSystemFontOfSize:20]];
    
    if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_FREE]) {
        [self.ibDealTypeLbl setFont:[UIFont boldSystemFontOfSize:23]];
        self.ibDealTypeLbl.text = LocalisedString(@"FREE");
        self.ibDiscountLbl.hidden = YES;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_DISCOUNT]){
        self.ibDiscountLbl.hidden = NO;
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@ %@", self.dealModel.currency_symbol, self.dealModel.discounted_item_price];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@ ", self.dealModel.currency_symbol, self.dealModel.original_item_price] attributes:attributes];
        self.ibDiscountLbl.attributedText = attrText;
    }
    else if ([self.dealModel.deal_type isEqualToString:DEAL_TYPE_PACKAGE]){
        self.ibDiscountLbl.hidden = NO;
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@ %@", self.dealModel.currency_symbol, self.dealModel.discounted_item_price];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@ ", self.dealModel.currency_symbol, self.dealModel.original_item_price] attributes:attributes];
        self.ibDiscountLbl.attributedText = attrText;
    }
    else{
        self.ibDiscountLbl.hidden = YES;
        self.ibDealTypeLbl.hidden = YES;
    }
}

-(void)setVoucherLeft{
    if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE] && (self.dealModel.total_available_vouchers > 0 && self.dealModel.total_available_vouchers <= 10)) {
        self.ibVoucherLeftLbl.hidden = NO;
        self.ibVoucherBlackOverylay.hidden = YES;
        self.ibVoucherLeftLbl.text = [LanguageManager stringForKey:@"{!number} voucher(s) left" withPlaceHolder:@{@"{!number}": @(self.dealModel.total_available_vouchers)}];
        self.ibVoucherLeftLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [Utils setRoundBorder:self.ibVoucherLeftLbl color:[UIColor clearColor] borderRadius:self.ibVoucherLeftLbl.frame.size.height/2];
    }
    else{
        self.ibVoucherLeftLbl.hidden = YES;
        self.ibVoucherBlackOverylay.hidden = YES;
    }
}

-(void)setRedeemCollect{
    SWITCH (self.dealModel.voucher_info.status) {
        CASE (VOUCHER_STATUS_NONE)
        {
            if ([self.dealModel.voucher_type isEqualToString:VOUCHER_TYPE_REFERRAL]) {
                if (self.dealCollectionModel && ([self.dealCollectionModel isCampaignExpired] || [self.dealCollectionModel isExceedNumberOfCollectable])) {
                    [self setCollectBtnEnabled:NO];
                    return;
                }
            }
            
            if ([self.dealModel isCollectable]) {
                [self setCollectBtnEnabled:YES];
            }
            else{
                [self setCollectBtnEnabled:NO];
            }
            break;
        }
            
        CASE (VOUCHER_STATUS_COLLECTED)
        {
            if ([self.dealModel isRedeemable]) {
                [self setRedeemBtnEnabled:YES];
            }
            else{
                [self setRedeemBtnEnabled:NO];
            }
            break;
        }
            
        CASE (VOUCHER_STATUS_REDEEMED)
        {
            [self setRedeemBtnEnabled:NO];
            break;
        }
        
        CASE (VOUCHER_STATUS_EXPIRED)
        {
            [self setRedeemBtnEnabled:NO];
            break;
        }
        
        DEFAULT
        {
            [self setCollectBtnEnabled:NO];
            break;
        }
        
    }
    
}

-(void)setDaysLeft{    
    NSInteger numberOfDaysLeft = self.dealModel.collectionDaysLeft;
    
    if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE] && (numberOfDaysLeft < 8 && numberOfDaysLeft > 0)) {
        self.ibDaysLeftLbl.hidden = NO;
        self.ibDaysLeftLbl.text = [LanguageManager stringForKey:@"{!number} day(s) left" withPlaceHolder:@{@"{!number}": @(numberOfDaysLeft)}];
        self.ibDaysLeftLbl.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [Utils setRoundBorder:self.ibDaysLeftLbl color:[UIColor clearColor] borderRadius:self.ibDaysLeftLbl.frame.size.height/2];
        
        if (self.ibVoucherLeftLbl.hidden) {
            self.ibDaysLeftTopConstraint.constant = 16;
        }
        else{
            self.ibDaysLeftTopConstraint.constant = self.ibVoucherLeftLbl.frame.size.height + 16 + 5;
        }
    }
    else{
        self.ibDaysLeftLbl.hidden = YES;
    }
}

-(void)setHeaderOverlay{
    
    self.ibVoucherBlackOverylay.hidden = NO;
    if (self.dealCollectionModel && [self.dealCollectionModel isCampaignExpired]) {
        [self.ibOverlayIcon setImage:[UIImage imageNamed:@"DealsListingCampaignEnd.png"]];
        self.ibVoucherOverlayTitle.text = LocalisedString(@"Campaign End");
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_EXPIRED]){
        [self.ibOverlayIcon setImage:[UIImage imageNamed:@"DealsExpiredIcon.png"]];
        self.ibVoucherOverlayTitle.text = LocalisedString(@"Expired");
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_REDEEMED]){
        [self.ibOverlayIcon setImage:[UIImage imageNamed:@"DealsRedeemedIcon.png"]];
        self.ibVoucherOverlayTitle.text = LocalisedString(@"Redeemed");
        
    }
    else if ([self.dealModel.voucher_info.status isEqualToString:VOUCHER_STATUS_NONE]){
        if ([Utils isValidDateString:self.dealModel.collection_expired_at] && self.dealModel.collectionDaysLeft <= 0) {
            [self.ibOverlayIcon setImage:[UIImage imageNamed:@"DealsExpiredIcon.png"]];
            self.ibVoucherOverlayTitle.text = LocalisedString(@"Expired");
        }
        else if (self.dealModel.total_available_vouchers == 0){
            [self.ibOverlayIcon setImage:[UIImage imageNamed:@"DealsListingSoldOutIcon.png"]];
            self.ibVoucherOverlayTitle.text = LocalisedString(@"Sold Out");
        }
        else{
            self.ibVoucherBlackOverylay.hidden = YES;
        }
    }
    else{
        self.ibVoucherBlackOverylay.hidden = YES;
    }
}

-(void)setCollectBtnEnabled:(BOOL)enabled{
    [self.ibVoucherCollectBtn setTitle:LocalisedString(@"Collect") forState:UIControlStateNormal];
    UIColor *btnColour = enabled? DEVICE_COLOR : BUTTON_DISABLED_COLOR;
    [self.ibVoucherCollectBtn setBackgroundColor:btnColour];
    [self.ibVoucherCollectBtn setImage:[UIImage imageNamed:@"CollectIcon.png"] forState:UIControlStateNormal];
}

-(void)setRedeemBtnEnabled:(BOOL)enabled{
    [self.ibVoucherCollectBtn setTitle:LocalisedString(@"Next") forState:UIControlStateNormal];
    UIColor *btnColour = enabled? BUTTON_REDEEM_ACTIVE_COLOR : BUTTON_DISABLED_COLOR;
    [self.ibVoucherCollectBtn setBackgroundColor:btnColour];
    [self.ibVoucherCollectBtn setImage:[UIImage imageNamed:@"DealsNextIcon.png"] forState:UIControlStateNormal];
}

- (IBAction)collectRedeemBtnClicked:(id)sender {
    if (self.voucherCellDelegate) {
        [self.voucherCellDelegate voucherCollectRedeemClicked:self.dealModel];
    }
}

@end

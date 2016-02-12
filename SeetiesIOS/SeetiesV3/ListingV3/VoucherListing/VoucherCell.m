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
    
    self.ibVoucherTitleLbl.text = self.dealModel.title;
    PhotoModel *photoModel = [self.dealModel.photos objectAtIndex:0];
    [self.ibVoucherImage setImageURL:[NSURL URLWithString:photoModel.imageURL]];
    [self setDealType];
    [self setRedeemCollect];
    [self setVoucherLeft];
//    [self setDaysLeft];
    
}

-(void)setDealType{
    if ([self.dealModel.deal_type isEqualToString:@"free"]) {
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"%@!", [self.dealModel.deal_type uppercaseString]];
        self.ibDiscountLbl.hidden = YES;
    }
    else if ([self.dealModel.deal_type isEqualToString:@"discount"]){
        self.ibDiscountLbl.hidden = NO;
        self.ibDealTypeLbl.text = [NSString stringWithFormat:@"RM%.2f", self.dealModel.discounted_item_price];
        NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"RM%.2f", self.dealModel.original_item_price] attributes:attributes];
        self.ibDiscountLbl.attributedText = attrText;
    }
    else{
        self.ibDealTypeLbl.text = self.dealModel.deal_type;
        self.ibDiscountLbl.hidden = YES;
    }
}

-(void)setVoucherLeft{
    if (self.dealModel.total_available_vouchers > 0 && self.dealModel.total_available_vouchers <= 10) {
        self.ibVoucherLeftLbl.hidden = NO;
        self.ibVoucherLeftLbl.text = [NSString stringWithFormat:@"   %ld Vouchers Left   ", self.dealModel.total_available_vouchers];
    }
    else if (self.dealModel.total_available_vouchers < 1){
        self.ibVoucherLeftLbl.hidden = YES;
        self.ibVoucherBlackOverylay.hidden = NO;
    }
    else{
        self.ibVoucherLeftLbl.hidden = YES;
    }
}

-(void)setRedeemCollect{
    if ([Utils isStringNull:self.dealModel.voucherID]) {
        [self.ibVoucherCollectBtn setTitle:@"Collect" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:DEVICE_COLOR];
    }
    else{
        [self.ibVoucherCollectBtn setTitle:@"Redeem" forState:UIControlStateNormal];
        [self.ibVoucherCollectBtn setBackgroundColor:[UIColor colorWithRed:239.0f green:83.0f blue:105.0f alpha:1]];
    }
}

-(void)setDaysLeft{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expiryDate = [dateFormatter dateFromString:self.dealModel.expired_at];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:[NSDate new] toDate:expiryDate options:NSCalendarWrapComponents];
    SLog(@"Days left: %ld", [components day]);
    
    if ([components day] < 8) {
        self.ibDaysLeftLbl.hidden = NO;
        self.ibDaysLeftLbl.text = [NSString stringWithFormat:@"%ld Days Left", [components day]];
    }
    else{
        self.ibDaysLeftLbl.hidden = YES;
    }
}

@end

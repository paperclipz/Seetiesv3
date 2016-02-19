//
//  DealModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#define DEAL_TYPE_DISCOUNT @"discount"
#define DEAL_TYPE_FREE @"free"
#define DEAL_TYPE_PACKAGE @"package"
#define DEAL_TYPE_OTHERS @"others"

#define REDEMPTION_TYPE_DINE_IN @"dine_in"
#define REDEMPTION_TYPE_TAKE_AWAY @"take_away"

#define VOUCHER_STATUS_NONE @"none"
#define VOUCHER_STATUS_CANCELLED @"cancelled"
#define VOUCHER_STATUS_COLLECTED @"collected"
#define VOUCHER_STATUS_EXPIRED @"expired"
#define VOUCHER_STATUS_REDEEMED @"redeemed"

@protocol SeShopDetailModel

@end

@class PhotoModel;

@interface DealModel : JSONModel

@property(nonatomic,strong) NSString * dID;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *cover_title;
@property(nonatomic,strong) NSString *expired_at;
@property(nonatomic,strong) NSString *deal_desc;
@property(nonatomic,assign) NSInteger total_available_vouchers;
@property(nonatomic,strong) NSString *deal_type;
@property(nonatomic,strong) NSString *original_item_price;
@property(nonatomic,strong) NSString *discounted_item_price;
@property(nonatomic,strong) NSString *discount_percentage;
@property(nonatomic,strong) NSArray *redemption_type;
@property(nonatomic,strong) NSArray<PhotoModel> *photos;
@property(nonatomic,strong) PhotoModel *cover_photo;
@property(nonatomic, strong) NSString *voucherID;
@property(nonatomic, strong) NSString *voucher_status;
@property(nonatomic,strong)NSArray<SeShopDetailModel> *shops;
@property(nonatomic,assign) BOOL is_feature;
@property(nonatomic, strong) NSDictionary *redemption_period_in_hour_text;
@property(nonatomic, strong) NSArray *terms;

@property(nonatomic, strong) NSString *seetishop_id;
@property(nonatomic, strong) NSString *seetishop_name;

@end

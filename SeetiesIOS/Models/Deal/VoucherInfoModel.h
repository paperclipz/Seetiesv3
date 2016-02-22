//
//  VoucherInfoModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#define VOUCHER_STATUS_NONE @"none"
#define VOUCHER_STATUS_CANCELLED @"cancelled"
#define VOUCHER_STATUS_COLLECTED @"collected"
#define VOUCHER_STATUS_EXPIRED @"expired"
#define VOUCHER_STATUS_REDEEMED @"redeemed"

@interface VoucherInfoModel : JSONModel
@property(nonatomic, strong) NSString *voucher_id;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *expired_at;
@property(nonatomic, strong) NSString *redeemed_at;
@property(nonatomic, assign) BOOL is_new;
@property(nonatomic, assign) BOOL redeem_now;
@property(nonatomic, strong) NSString *shop_id;
@property(nonatomic, strong) SeShopDetailModel *shop_info;
@end

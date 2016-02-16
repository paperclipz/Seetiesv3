//
//  DealModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class PhotoModel;
@interface DealModel : JSONModel

@property(nonatomic,strong) NSString * dID;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) NSString *expired_at;
@property(nonatomic,assign) NSInteger total_available_vouchers;
@property(nonatomic,strong) NSString *deal_type;
@property(nonatomic,assign) float original_item_price;
@property(nonatomic,assign) float discounted_item_price;
@property(nonatomic,strong) NSArray<PhotoModel> *photos;
@property(nonatomic,strong) PhotoModel *cover_photo;
@property(nonatomic, strong) NSString *voucherID;
@property(nonatomic, strong) NSString *voucher_status;

@property(nonatomic, strong) NSString *seetishop_id;
@property(nonatomic, strong) NSString *seetiesshop_name;

@end

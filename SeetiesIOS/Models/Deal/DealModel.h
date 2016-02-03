//
//  DealModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PhotoModel.h"

@interface DealModel : JSONModel
@property(nonatomic) NSString *id;
@property(nonatomic) NSString *title;
@property(nonatomic) NSInteger expired_in_days;
@property(nonatomic) NSInteger total_available_vouchers;
@property(nonatomic) NSString *deal_type;
@property(nonatomic) float original_item_price;
@property(nonatomic) float discounted_item_price;
@property(nonatomic) NSArray<PhotoModel> *photos;
@end

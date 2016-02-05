//
//  DealModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DealModel : JSONModel

@property(nonatomic,strong) NSString * dID;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) NSInteger expired_in_days;
@property(nonatomic,assign) NSInteger total_available_vouchers;
@property(nonatomic,strong) NSString *deal_type;
@property(nonatomic,assign) float original_item_price;
@property(nonatomic,assign) float discounted_item_price;
@property(nonatomic,strong) NSArray<PhotoModel> *photos;
@property(nonatomic,strong) NSArray<PhotoModel> *cover_photo;

@end

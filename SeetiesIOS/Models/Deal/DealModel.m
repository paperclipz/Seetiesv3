//
//  DealModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealModel.h"

@implementation DealModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"deal_type_info.name": @"deal_type",
                                                       @"deal_type_info.original_item_price": @"original_item_price",
                                                       @"deal_type_info.discounted_item_price": @"discounted_item_price",
                                                       @"id" : @"dID",
                                                       @"voucher_info.id": @"voucherID",
                                                       @"voucher_info.status": @"voucher_status",
                                                       @"shop.id": @"seetishop_id",
                                                       @"shop.name": @"seetishop_name",

                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

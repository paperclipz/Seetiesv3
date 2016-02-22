//
//  VoucherInfoModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "VoucherInfoModel.h"

@implementation VoucherInfoModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"voucher_id"
                                                       }];
}

@end

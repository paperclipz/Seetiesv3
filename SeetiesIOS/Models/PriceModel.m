//
//  PriceModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "PriceModel.h"

@implementation PriceModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"expense.value": @"value",
                                                       @"expense.code": @"code",
                                                       }];
}

@end

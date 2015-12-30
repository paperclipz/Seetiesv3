//
//  SeShopCategoryModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/15/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopCategoryModel.h"

@implementation SeShopCategoryModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"main.title" :@"title",
                                                       @"main.images" :@"images"

                                                       }];
}

@end

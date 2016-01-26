//
//  LanguageModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "LanguageModel.h"

@implementation LanguageModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"langID",
                                                       }];
}

@end

@implementation LanguageModels

@end
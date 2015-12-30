//
//  TagModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/6/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"simple": @"arrayTag"
                                                       }];
}

@end

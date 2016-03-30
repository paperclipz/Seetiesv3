//
//  HomeModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/3/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"featured_deals_cover.title": @"featured_title",
                                                       @"featured_deals_cover.image": @"featured_image",
                                                       }];
}
@end

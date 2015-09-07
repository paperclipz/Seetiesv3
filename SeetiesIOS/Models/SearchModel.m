//
//  SearchModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

@end

@implementation SearchLocationModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"longDescription"
                                                       }];
}

@end



@implementation SearchLocationDetailModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"geometry.location.lat": @"lat",
                                                       @"geometry.location.lng": @"lng"

                                                       }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

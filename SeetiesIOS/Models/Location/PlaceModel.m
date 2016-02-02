//
//  PlaceModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"lng" :@"longtitude",
                                                       @"lat" :@"latitude",

                                                       }];
}

@end

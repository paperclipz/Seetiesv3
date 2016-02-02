//
//  AreaModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"featured_places.result" :@"result",
                                                       
                                                       }];
}
@end

//
//  Location.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Location.h"


@implementation Location

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"address_components.administrative_area_level_1" : @"administrative_area_level_1",
                                                       @"address_components.country" : @"country",
                                                       @"address_components.locality" : @"locality",
                                                       @"address_components.political" : @"political",
                                                       @"address_components.postal_code" : @"postal_code",
                                                       @"address_components.route" : @"route",
                                                       @"address_components.sublocality" : @"sublocality"
                                                       
                                                       }];
}

@end

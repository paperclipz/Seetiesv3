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

-(void)process
{
    
    for (NSDictionary* dict in _address_components) {
        NSString* value = dict[@"types"][0];
        if ([value isEqualToString:@"administrative_area_level_1"])
        {
            _state = dict[@"long_name"];
            
        }
        
        if ([value isEqualToString:@"locality"])
        {
            _city = dict[@"long_name"];
            
        }
        
        if ([value isEqualToString:@"route"])
        {
            _route = dict[@"long_name"];
            
        }
        
        if ([value isEqualToString:@"country"])
        {
            _country = dict[@"long_name"];
            
        }
        
        if ([value isEqualToString:@"postal_code"])
        {
            _postal_code = dict[@"long_name"];
            
        }

        
//        if (tempDict allKeys]containsObject:@"administrative_area_level_1"]) {
//            SLog(@"YES!!");
//        }
    }
}
@end

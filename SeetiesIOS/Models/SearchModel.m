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


-(NSString*)locationName
{
    for (NSDictionary* dict in _address_components) {
        
            NSString* value = dict[@"types"][0];
            
            if ([value isEqualToString:@"sublocality_level_1"]) {
                return dict[@"long_name"];
            }
            else if ([value isEqualToString:@"sublocality"]) {
                
                return dict[@"long_name"];

            }
//            else if ([value isEqualToString:@"administrative_area_level_3"]) {
//                
//                return dict[@"long_name"];
//
//            }

            else if ([value isEqualToString:@"administrative_area_level_2"]) {
                return dict[@"long_name"];

            }
            else if ([value isEqualToString:@"administrative_area_level_1"]) {
                return dict[@"long_name"];

            }
            else if ([value isEqualToString:@"country"]) {
                return dict[@"long_name"];

            }
        
    }
    return nil;
}

-(NSString*)locationNameWithCustomKey:(NSArray*)arrayKey
{

    for(int i = 0; i< arrayKey.count ; i++)
    {
        
        
        NSString* tempLocationName = arrayKey[i];
        
       
        for (NSDictionary* dict in _address_components) {
            
            NSString* value = dict[@"types"][0];
            
            //SLog(@" value : %@ || tempLocation : %@",value,tempLocationName);

            if ([value isEqualToString:tempLocationName]) {
                
                return dict[@"long_name"];
                
            }
        }
        
      
        
    }

    
   
    
    
        return self.locationName;
}

-(void)process
{
    
    for (NSDictionary* dict in _address_components) {
        
        NSArray* array = dict[@"types"];
        for (int i = 0; i< array.count; i++) {
            NSString* value = dict[@"types"][i];
            
            
            if ([value isEqualToString:@"administrative_area_level_1"])
            {
                _state = dict[@"long_name"];
                break;
                
            }
            
            if ([value isEqualToString:@"political"])
            {
                _political = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"locality"])
            {
                _city = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"route"])
            {
                _route = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"country"])
            {
                _country = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"postal_code"])
            {
                _postal_code = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"sublocality"])
            {
                _subLocality = dict[@"long_name"];
                break;

            }
            
            if ([value isEqualToString:@"sublocality_level_1"])
            {
                _subLocality_lvl_1 = dict[@"long_name"];
                break;

            }
        }

        
//        if (tempDict allKeys]containsObject:@"administrative_area_level_1"]) {
//            SLog(@"YES!!");
//        }
    }
}
@end

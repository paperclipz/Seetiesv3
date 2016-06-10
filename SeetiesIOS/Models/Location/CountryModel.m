//
//  CountryModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CountryModel.h"

@interface  CountryModel()

@end

@implementation CountryModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSMutableArray*)arrArea
{
    if (!_arrArea) {
        
      _arrArea  = [NSMutableArray new];
        
    }
    return _arrArea;
}

-(NSString*)formattedCountryDisplay
{
    
    NSString *formattedCountryCode = [NSString stringWithFormat:@"%@ (%@)", self.name, self.phone_country_code];

    return formattedCountryCode;
}

-(NSString*)shortCountryCode
{
    return [self.country_code substringFromIndex:1];

}
@end

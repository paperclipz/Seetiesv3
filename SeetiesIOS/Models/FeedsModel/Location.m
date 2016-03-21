//
//  Location.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Location.h"


@implementation Location

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    
    return copy;
    
}

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

-(OpeningPeriodModels*)opening_hours
{
    if (!_opening_hours) {
        _opening_hours = [OpeningPeriodModels new];
    }
    
    return _opening_hours;
}


-(void)processLocationFromGoogleDetails:(SearchLocationDetailModel*)model
{
    _lat = model.lat;
    _lng = model.lng;
    _name = model.name;
    _place_id = model.place_id;
    _contact_no = model.formatted_phone_number;
    _link = model.website;
    _reference = model.reference;
    _formatted_address = model.formatted_address;
    _administrative_area_level_1 = model.state;
    _country = model.country;
    _locality = model.city;
    _postal_code = model.postal_code;
    _route = model.route;
}

-(void)processLocationFrom:(RecommendationVenueModel*)model
{
    _lat = model.lat;
    _lng = model.lng;
    _name = model.name;
    _place_id = model.place_id;
    _contact_no = model.formattedPhone;
    _link = model.url;
//    _distance = model.distance;
    _reference = model.reference;
    _formatted_address = model.formattedAddress;
    _administrative_area_level_1 = model.state;
    _country = model.country;
    _locality = model.city;
    _postal_code = model.postalCode;
    _route = model.route;
    _price = model.price;
    _currency = model.currency;
}

-(void)processLocationFromVenue:(VenueModel*)model
{
    _lng = model.lng;
    _lat = model.lat;
    _name = model.name;
   // _place_id = model.place_id;
    _contact_no = model.formattedPhone;
    _link = model.url;
   
   // _distance = model.distance;
    
    if (model.address) {
        _formatted_address = model.address;

    }
    else{
        _formatted_address = model.formattedAddress;
    }
    _administrative_area_level_1 = model.state;
    _country = model.country;
    _locality = model.city;
    _postal_code = model.postalCode;
    _currency = model.currency;

}

-(NSString*)price
{
    if (!_price) {
        _price = _expense[@"value"];
    }
    return _price;
}

-(NSString*)currency
{
    if (!_currency) {
        _currency = _expense[@"code"];
    }
    return _currency;
}
@end

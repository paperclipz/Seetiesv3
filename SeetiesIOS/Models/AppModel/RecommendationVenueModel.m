//
//  RecommendationVenueModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "RecommendationVenueModel.h"

@implementation RecommendationVenueModel


-(void)processFourSquareModel:(VenueModel*)model
{
    _route = nil;
    _address = model.address;
    _formattedAddress = model.address;
    _place_id = nil;
    _lat = model.lat;
    _lng = model.lng;
    _city = model.city;
    _country = model.country;
    _state = model.state;
    _postalCode = model.postalCode;
    _distance = model.distance;
    _formattedPhone = model.formattedPhone;
    _facebookName = model.facebookName;
    _isOpenHour = model.isOpenHour;
    _statusHour = model.statusHour;
   // _currency = model.currency;
    _currency = nil;

    _priceMessage = model.priceMessage;
    _tier = model.tier;
    _name = model.name;
    _url = model.url;
    _vicinity = nil;
    _reference = nil;

}

-(void)processGoogleModel:(SearchLocationDetailModel*)model
{
    _route = model.route;
    _address = nil;
    _formattedAddress = model.formatted_address;
    _place_id = model.place_id;
    _lat = model.lat;
    _lng = model.lng;
    _city = model.city;
    _country = model.country;
    _state =  model.state;
    _postalCode = model.postal_code;
    _distance =  nil;
    _formattedPhone = model.formatted_phone_number;
    _facebookName = nil;
    _isOpenHour = nil;
    _statusHour = nil;
    _currency = nil;
    _priceMessage = nil;
    _tier = nil;
    _name = model.name;
    _url = model.website;
    _vicinity = model.vicinity;
    _reference = model.reference;


}

-(void)processDraftModel:(DraftModel*)model
{
    _expense = model.location.expense;
    _route = model.location.route;
    _formattedAddress = model.location.formatted_address;
    _place_id = model.location.place_id;
    _lat = model.location.lat;
    _lng = model.location.lng;
    _city = model.location.locality;
    _country = model.location.country;
    _state =  model.location.administrative_area_level_1;
    _postalCode = model.location.postal_code;
    _distance =  model.location.distance;
    _formattedPhone = model.location.contact_no;
    _facebookName = nil;
    _isOpenHour = nil;
    _statusHour = nil;
    _currency = _expense[@"code"];
    _priceMessage = nil;
    _tier = nil;
    _name = model.location.name;
    _url = model.location.link;
    _reference = model.location.reference;
    _price = _expense[@"value"];
    
    if (model.location.opening_hours.periods) {
        [self processOperatingHours:model.location.opening_hours.periods];
    }
}

-(NSDictionary*)expense
{
    if (_price && _currency) {
        
        NSDictionary* model = @{[Utils currencyCode:_currency]:_price};
        
        return model;
    }
    
    return nil;
}

-(NSString*)processCurrency
{
    if (_expense) {

        NSArray* key = [_expense allKeys];
        
        if (key.count > 0) {
            
            NSString* value = key[0];
            return value;
        }
        
    }
    
    return _currency;
}

-(NSString*)processPrice
{
    if (_expense) {
        
        NSArray* key = [_expense allKeys];
        
        if (key.count > 0) {
            
            NSDictionary* tempCurrency = _expense[key[0]];
            
            NSArray* currencyCodeKey = [tempCurrency allKeys];

            NSString* value = tempCurrency[currencyCodeKey[0]];
            return value;
        }
    }
    
    return _price;
}

-(void)processOperatingHours:(NSArray<OperatingHoursModel>*)array
{
    
    for (int i = 0; i<array.count; i++) {
        OperatingHoursModel* model = array[i];
        int day = model.open.day;
        model.isOpen =YES;
        [self.arrOperatingHours replaceObjectAtIndex:day withObject:model];
    }
}

-(NSMutableArray*)arrOperatingHours
{
    if (!_arrOperatingHours) {
        
        _arrOperatingHours = [NSMutableArray new];
        
        for (int i = 0; i< 7; i++) {
            OperatingHoursModel* model = [OperatingHoursModel new];
            model.open = [self getDayTimeModel:i];
            model.close = [self getDayTimeModel:i];
            model.isOpen = NO;
            [_arrOperatingHours addObject:model];
        }
        
    }
    return _arrOperatingHours;
}

-(DayTimeModel*)getDayTimeModel:(int)day
{
    DayTimeModel* model = [DayTimeModel new];
    model.day = day;
    model.time = 1200;
    
    return model;
}
@end

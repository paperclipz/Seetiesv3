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
    _formattedAddress = model.formattedAddress;
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
    _currency = model.currency;
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



@end

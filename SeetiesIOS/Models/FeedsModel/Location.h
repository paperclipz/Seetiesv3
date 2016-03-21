//
//  Location.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class OpeningPeriodModels;
@class RecommendationVenueModel;

@interface Location : JSONModel

@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)OpeningPeriodModels* opening_hours;
@property(nonatomic,strong)NSString* contact_no;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,assign)float distance;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSDictionary* expense;
@property(nonatomic,strong)NSString* search_display_name;
@property(nonatomic,strong)NSString<Ignore>* price;
@property(nonatomic,strong)NSString<Ignore>* currency;
@property(nonatomic, strong)NSString *display_address;

//below here is all inside address_components
@property(nonatomic,strong)NSString* administrative_area_level_1;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* locality;
@property(nonatomic,strong)NSString* political;
@property(nonatomic,strong)NSString* postal_code;
@property(nonatomic,strong)NSString* route;
@property(nonatomic,strong)NSString* sublocality;
@property(nonatomic,strong)NSString* location_id;
@property(nonatomic,assign)int type;//for google type forusquare or seeties



-(void)processLocationFrom:(RecommendationVenueModel*)model;
-(void)processLocationFromVenue:(VenueModel*)model;
-(void)processLocationFromGoogleDetails:(SearchLocationDetailModel*)model;

@end

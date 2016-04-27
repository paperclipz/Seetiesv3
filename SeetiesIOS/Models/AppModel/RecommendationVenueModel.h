//
//  RecommendationVenueModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpeningPeriodModel.h"

// this model will combine four square and google search api model into one
@interface RecommendationVenueModel : NSObject


@property(nonatomic,assign)SearchType searchType;
@property(nonatomic,strong)NSString* address;
@property(nonatomic,strong)NSString<Optional>* formattedAddress;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* route;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,strong)NSString* postalCode;
@property(nonatomic,strong)NSString* distance;
@property(nonatomic,strong)NSString* formattedPhone;
//@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* facebookName;
@property(nonatomic,assign)BOOL isOpenHour;
@property(nonatomic,strong)NSString* statusHour;
@property(nonatomic,strong)NSString* priceMessage;
@property(nonatomic,strong)NSString* tier;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* url;
//@property(nonatomic,strong)NSString* website;
@property(nonatomic,strong)NSString* vicinity;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString* price;
@property(nonatomic,strong)NSString* currency;
@property(nonatomic,strong)NSDictionary* expense;

@property(nonatomic,strong)NSMutableArray* arrOperatingHours;//OpeningPeriodModel
@property(nonatomic,strong)Location* location;//for seeties location

-(void)processFourSquareModel:(VenueModel*)model;
-(void)processGoogleModel:(SearchLocationDetailModel*)model;
-(void)processDraftModel:(DraftModel*)model;


@end

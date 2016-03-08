//
//  SearchModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/19/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@protocol SearchModel


@end

@protocol SearchLocationModel


@end

@interface SearchModel : Model

@property(nonatomic,strong)NSArray<SearchLocationModel>* predictions;
@end


@interface SearchLocationModel : JSONModel
@property(nonatomic,strong)NSString* longDescription;
@property(nonatomic,strong)NSArray* terms;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSNumber<Optional>* latitude;
@property(nonatomic,strong)NSNumber<Optional>* longitude;
@property(nonatomic,strong)NSString<Optional>* name;

@end

@interface SearchLocationDetailModel : JSONModel
@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSString<Optional>* name;
@property(nonatomic,strong)NSString* formatted_phone_number;
@property(nonatomic,strong)NSString* website;
@property(nonatomic,strong)NSString* vicinity;
@property(nonatomic,strong)NSString* reference;
@property(nonatomic,strong)NSString* place_id;
//@property(nonatomic,strong)NSString* long_name;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;

@property(nonatomic,strong)NSString<Optional>* state;
@property(nonatomic,strong)NSString<Optional>* city;//locality
@property(nonatomic,strong)NSString<Optional>* route;
@property(nonatomic,strong)NSString<Optional>* country;
@property(nonatomic,strong)NSString<Optional>* postal_code;
@property(nonatomic,strong)NSString<Optional>* political;
@property(nonatomic,strong)NSString<Ignore>* subLocality;
@property(nonatomic,strong)NSString<Ignore>* subLocality_lvl_1;

@property(nonatomic,strong)NSDictionary<Optional>* address_components;

-(void)process;

@end


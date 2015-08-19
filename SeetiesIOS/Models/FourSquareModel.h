//
//  FourSquareModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "JSONModel.h"


@protocol Venue

@end
@protocol Location
@end

@protocol Contact
@end
@protocol OperateHour
@end
@protocol Price
@end
@interface FourSquareModel : JSONModel

@property(nonatomic,strong)NSArray<Venue>* items;
-(id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err;

@end

@interface Location : JSONModel

@property(nonatomic,strong)NSString* address;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* state;
@property(nonatomic,strong)NSString* formattedAddress;
@property(nonatomic,strong)NSString* postalCode;
@property(nonatomic,strong)NSString* distance;
-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface Contact : JSONModel
@property(nonatomic,strong)NSString* formattedPhone;
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* facebookName;
-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface OperateHour : JSONModel


@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)NSString* status;
-(id)initWithDictionary:(NSDictionary *)dict;

@end

@interface Price : JSONModel
@property(nonatomic,strong)NSString* currency;
@property(nonatomic,strong)NSString* message;
@property(nonatomic,strong)NSString* tier;
-(id)initWithDictionary:(NSDictionary *)dict;

@end




@interface Venue : JSONModel
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)Contact* contact;
@property(nonatomic,strong)OperateHour* hours;
@property(nonatomic,strong)Price* price;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)Price* url;

-(id)initWithDictionary:(NSDictionary *)dict;

@end


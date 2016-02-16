//
//  SeShopDetailModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/4/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailModel.h"
@interface SeShopDetailModel()
@property(nonatomic,strong)NSMutableArray* arrayInfo;
@property(nonatomic,strong)NSArray* languages;

@end
@implementation SeShopDetailModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"url.facebook": @"urlFacebook",
                                                       @"url.website": @"urlWebsite",
                                                       @"features.available" : @"arrFeatureAvaiable",
                                                       @"features.unavailable" : @"arrFeatureUnavaiable",
                                                       @"id": @"shopId"
                                                       }];
}


#define BestKnowFor @"Best known for"
#define Price @"Price"
#define Hours @"Hours"
#define Phone_Number @"Phone Number"
#define URL_Link @"URL/Link"
#define FACEBOOK @"Facebook"

-(void)process
{
    self.arrayInfo = [NSMutableArray new];
    if (![Utils isStringNull:_recommended_information]) {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_recommended_information forKey:BestKnowFor];
        [self.arrayInfo addObject:temp];
    }
    if(_price)//check price
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        
        if (![Utils isStringNull:_price.value]) {
            NSString* tempPrice = [NSString stringWithFormat:@"%@ %@",_price.code,_price.value];
            [temp setObject:tempPrice forKey:Price];
            [self.arrayInfo addObject:temp];
        }
       

    }
    
    if(_location && _location.opening_hours && _location.opening_hours.period_text)//check Hours
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        
        NSDateFormatter* day = [[NSDateFormatter alloc] init];
        [day setDateFormat: @"EEEE"];
        NSString* dayOfWeek = [day stringFromDate:[NSDate date]];
        
        if ([[_location.opening_hours.period_text allKeys]containsObject:dayOfWeek]) {
            NSString* operatingHourText = [_location.opening_hours.period_text objectForKey:dayOfWeek];
            [temp setObject:operatingHourText forKey:Hours];

        }
        else{
            [temp setObject:@"Closed" forKey:Hours];

        }
        [self.arrayInfo addObject:temp];

    }
    
    if(![Utils isArrayNull:_contact_number])//check Phone Number
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        NSString* phoneNumber = _contact_number[0];
        
        if (![Utils isStringNull:phoneNumber]) {
            [temp setObject:_contact_number[0] forKey:Phone_Number];
            [self.arrayInfo addObject:temp];
        }
    }
    
    if(![Utils isStringNull:_urlWebsite])//check URL/Link
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_urlWebsite forKey:URL_Link];
        [self.arrayInfo addObject:temp];

    }

    if(![Utils isStringNull:_urlFacebook])//check Facebook
    {
        NSMutableDictionary* temp = [NSMutableDictionary new];
        [temp setObject:_urlFacebook forKey:FACEBOOK];
        [self.arrayInfo addObject:temp];

    }

}

-(NSArray*)arrayInformation// for information after process
{
    return [NSArray arrayWithArray:_arrayInfo];
}

-(NSString*)language
{
    if (_languages.count >0) {
        
        _language = _languages[0];
    }
    return _language;
}
@end

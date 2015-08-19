//
//  FourSquareModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/17/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "FourSquareModel.h"

@implementation FourSquareModel

-(id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{

    //get all the venue from four square json
    NSArray* arrayVenues = [[dict valueForKeyPath:@"response.groups.items.venue"] objectAtIndex:0];
   
    if(self = [super initWithDictionary:dict error:err])
    {
        NSMutableArray* array;
        array = [NSMutableArray new];
        for (NSDictionary * tempDict in arrayVenues){
            VenueModel* obj = [[VenueModel alloc] initWithDictionary:tempDict error:nil];
            [array addObject:obj];

        }
        
        self.items = [array mutableCopy];
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation VenueModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"location.address" :@"address",
                                                       @"location.city": @"city",
                                                       @"location.country": @"country",
                                                       @"location.lat": @"lat",
                                                       @"location.lng": @"lng",
                                                       @"location.state": @"state",
                                                       @"location.postalCode": @"postalCode",
                                                       @"location.distance": @"distance",
                                                       
                                                       @"contact.formattedPhone": @"formattedPhone",
                                                       @"contact.phone": @"phone",
                                                       @"contact.facebookName": @"facebookName",
                                                       
                                                       @"hours.isOpen": @"isOpenHour",
                                                       @"hours.status": @"statusHour",
                                                       
                                                       @"price.currency": @"currency",
                                                       @"price.message": @"message",
                                                       @"price.tier": @"tier"
                                                       
                                                       }];
}
@end

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
            Venue* obj = [[Venue alloc] initWithDictionary:tempDict];
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

@implementation Venue

-(id)initWithDictionary:(NSDictionary *)dict{
    
    if(self  = [super init])
    {
    
        self.location = [[Location alloc]initWithDictionary:dict[@"location"]];
        self.contact = [[Contact alloc]initWithDictionary:dict[@"contact"]];
        self.hours = [[OperateHour alloc]initWithDictionary:dict[@"hours"]];
        self.price = [[Price alloc]initWithDictionary:dict[@"price"]];
        self.name = dict[@"name"];
        self.url =  dict[@"url"];

    }
    
    return self;
}

@end

@implementation Location

-(id)initWithDictionary:(NSDictionary *)dict{
    
    if(self  = [super init])
    {
        
        self.address = dict[@"address"];
        self.city = dict[@"city"];
        self.country = dict[@"country"];
        self.lat = dict[@"lat"];
        self.lng = dict[@"lng"];
        self.state = dict[@"state"];
        self.formattedAddress = dict[@"formattedAddress"];
        self.postalCode = dict[@"postalCode"];
        self.distance = dict[@"distance"];


    }
    
    return self;
}

@end
@implementation Contact

-(id)initWithDictionary:(NSDictionary *)dict{
    
    if(self  = [super init])
    {
        self.formattedPhone = dict[@"formattedPhone"];
        self.phone = dict[@"phone"];
        self.facebookName = dict[@"facebookName"];

        
    }
    
    return self;
}

@end
@implementation OperateHour
-(id)initWithDictionary:(NSDictionary *)dict{
    
    if(self  = [super init])
    {
       
        
        self.isOpen = dict[@"isOpen"];
        self.status = dict[@"status"];
        
    }
    
    return self;
}

@end
@implementation Price
-(id)initWithDictionary:(NSDictionary *)dict{
    
    if(self  = [super init])
    {
        self.currency = dict[@"currency"];
        self.message = dict[@"message"];
        self.tier = dict[@"tier"];


    }
    
    return self;
}

@end
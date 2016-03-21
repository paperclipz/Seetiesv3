//
//  OpeningPeriodModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/18/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "OpeningPeriodModel.h"

@implementation DayTimeModel

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
@end

@implementation OperatingHoursModel

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

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{

    if ([propertyName isEqualToString:@"isOpen"]) {
        return YES;
    }
    return NO;

}


@end

@implementation OpeningPeriodModels

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    
    OpeningPeriodModels* model = copy;
    model.periods = [[NSMutableArray<OperatingHoursModel> alloc]initWithArray:_periods];
    
    return copy;
    
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSArray<OperatingHoursModel>*)periods
{
    if (!_periods) {
        
        NSMutableArray<OperatingHoursModel>* array = [NSMutableArray<OperatingHoursModel> new];
        
        for (int i = 0; i< 7; i++) {
            OperatingHoursModel* model = [OperatingHoursModel new];
            model.open = [self getDayTimeModel:i];
            model.close = [self getDayTimeModel:i];
            model.isOpen = NO;
            [array addObject:model];
        }
        _periods = array;
        
    }
    return _periods;
}

-(DayTimeModel*)getDayTimeModel:(int)day
{
    DayTimeModel* model = [DayTimeModel new];
    model.day = day;
    model.time = 1200;
    
    return model;
}
@end

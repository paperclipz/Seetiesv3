//
//  OpeningPeriodModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/18/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "OpeningPeriodModel.h"

@implementation DayTimeModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation OperatingHoursModel
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
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

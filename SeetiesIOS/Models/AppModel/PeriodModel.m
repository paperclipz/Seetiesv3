//
//  PeriodModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PeriodModel.h"

@implementation PeriodModel
-(NSString *)formatted12HourOpen{
    if ([Utils isStringNull:self.open]) {
        return @"";
    }
    
    NSDateFormatter *utcFormatter = [[NSDateFormatter alloc] init];
    [utcFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcFormatter setDateFormat:@"HHmm"];
    
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localFormatter setDateFormat:@"hh:mm aa"];
    
    NSDate *utcDate = [utcFormatter dateFromString:self.open];
    return [localFormatter stringFromDate:utcDate];
}

-(NSString *)formatted12HourClose{
    if ([Utils isStringNull:self.close]) {
        return @"";
    }
    
    NSDateFormatter *utcFormatter = [[NSDateFormatter alloc] init];
    [utcFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcFormatter setDateFormat:@"HHmm"];
    
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localFormatter setDateFormat:@"hh:mm aa"];
    
    NSDate *utcDate = [utcFormatter dateFromString:self.close];
    return [localFormatter stringFromDate:utcDate];
}
@end

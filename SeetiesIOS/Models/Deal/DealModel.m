//
//  DealModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealModel.h"

@implementation DealModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"deal_type_info.name": @"deal_type",
                                                       @"deal_type_info.original_item_price": @"original_item_price",
                                                       @"deal_type_info.discounted_item_price": @"discounted_item_price",
                                                       @"deal_type_info.percentage": @"discount_percentage",
                                                       @"deal_id" : @"dID",
                                                       @"description": @"deal_desc",
                                                       @"redemption_periods.periods_in_hours.period_text": @"redemption_period_in_hour_text",
                                                       @"redemption_periods.periods_in_hours.period": @"period",
                                                       @"redemption_periods.periods_in_date": @"periods_in_date",
                                                       @"type": @"voucher_type"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(BOOL)isEqual:(id)object{
    if (object == nil) {
        return NO;
    }
    if (![object isKindOfClass:DealModel.class]) {
        return NO;
    }
    
    DealModel *otherDealModel = (DealModel*)object;
    return [otherDealModel.dID isEqualToString:self.dID]? YES : NO;
}

-(NSUInteger)hash{
    return self.dID.hash;
}

-(NSMutableArray<DailyPeriodModel>*)getFormattedAvailablePeriods{
    NSMutableArray<DailyPeriodModel> *formattedDailyPeriods = [[NSMutableArray<DailyPeriodModel> alloc] init];
    
    for (int dayNumber = 0; dayNumber < self.period.count; dayNumber++) {
        NSArray *dayPeriod = self.period[dayNumber];
        if ([Utils isArrayNull:dayPeriod]) {
            continue;
        }
        
        DailyPeriodModel *dailyPeriodModel = [[DailyPeriodModel alloc] init];
        dailyPeriodModel.periods = [[NSMutableArray<PeriodModel> alloc] init];
        dailyPeriodModel.dayNumber = dayNumber;
        
        for (NSDictionary *period in dayPeriod) {
            PeriodModel *periodModel = [[PeriodModel alloc] init];
            periodModel.open = period[@"open"];
            periodModel.close = period[@"close"];
            [dailyPeriodModel.periods addObject:periodModel];
        }
        
        [formattedDailyPeriods addObject:dailyPeriodModel];
    }
    
    return formattedDailyPeriods;
}

-(NSString*)getNextAvailableRedemptionDateString{
    //Current date time in UTC
    NSDate *currentDateTime = [[NSDate alloc] init];
    //Calendar needs to set to UTC
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    unsigned int dateFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* dateComponents = [calendar components:dateFlags fromDate:currentDateTime];
    NSDate *currentDateOnly = [calendar dateFromComponents:dateComponents];
    
    unsigned int timeFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* timeComponents = [calendar components:timeFlags fromDate:currentDateTime];
    NSDate *currentTimeOnly = [calendar dateFromComponents:timeComponents];
    
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localDateFormatter setDateFormat:@"dd MMM yyyy (EEEE)"];
    
    NSDateFormatter *utcTimeFormatter = [[NSDateFormatter alloc] init];
    [utcTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcTimeFormatter setDateFormat:@"HHmm"];
    
    NSDateFormatter *localTimeFormatter = [[NSDateFormatter alloc] init];
    [localTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localTimeFormatter setDateFormat:@"hh:mmaa"];
    
    NSDateFormatter *utcDateTimeFormatter = [[NSDateFormatter alloc] init];
    [utcDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateTimeFormatter setDateFormat:@"yyyy-MM-dd HHmm"];
    
    //Loop to check through redemption period date
    for (NSDictionary *periodDate in self.periods_in_date) {
        NSDate *fromDate = [utcDateFormatter dateFromString:periodDate[@"from"]];
        NSDate *toDate = [utcDateFormatter dateFromString:periodDate[@"to"]];
        
        //Check if current date falls in between "from" and "to" date
        if ([Utils isDate:currentDateOnly betweenFirstDate:fromDate andLastDate:toDate]) {
            int count = 0;
            NSDate *nextDate = currentDateOnly;
            
            //Loop and check for the next 7 days (1 week)
            while (count < 7) {
                NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);      //NSDateComponents Sunday=1 //Seeties Sunday=0
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    //Loop through available periods for the current day
                    for (NSDictionary *period in periodArray) {
                        NSDate *openTime = [utcTimeFormatter dateFromString:period[@"open"]];
                        NSDate *closeTime = [utcTimeFormatter dateFromString:period[@"close"]];
                        
                        //Combine both date and opening time
                        NSString *dateString = [utcDateFormatter stringFromDate:nextDate];
                        NSString *displayDateTimeString = [NSString stringWithFormat:@"%@ %@", dateString, period[@"open"]];
                        
                        //Check whether it is available later today
                        if (count == 0) {
                            NSComparisonResult timeResult = [currentTimeOnly compare:openTime];
                            if (timeResult == NSOrderedAscending) {
                                NSString *displayDateString = [localDateFormatter stringFromDate:[utcDateTimeFormatter dateFromString:displayDateTimeString]];
                                NSString *openString = [localTimeFormatter stringFromDate:openTime];
                                NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                                
                                return [NSString stringWithFormat:@"%@\n%@ - %@", displayDateString, openString, closeString];
                            }
                        }
                        
                        NSString *displayDateString = [localDateFormatter stringFromDate:[utcDateTimeFormatter dateFromString:displayDateTimeString]];
                        NSString *openString = [localTimeFormatter stringFromDate:openTime];
                        NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                        
                        return [NSString stringWithFormat:@"%@\n%@ - %@", displayDateString, openString, closeString];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:currentDateOnly options:NSCalendarMatchNextTime];
            }
        }
        //Else check whether it's available in the future
        else if ([currentDateOnly compare:fromDate] == NSOrderedAscending){
            int count = 0;
            NSDate *nextDate = fromDate;
            
            while (count < 7) {
                NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    for (NSDictionary *period in periodArray) {
                        NSDate *openTime = [utcTimeFormatter dateFromString:period[@"open"]];
                        NSDate *closeTime = [utcTimeFormatter dateFromString:period[@"close"]];
                        
                        NSString *dateString = [utcDateFormatter stringFromDate:nextDate];
                        NSString *displayDateTimeString = [NSString stringWithFormat:@"%@ %@", dateString, period[@"open"]];
                        
                        NSString *displayDateString = [localDateFormatter stringFromDate:[utcDateTimeFormatter dateFromString:displayDateTimeString]];
                        NSString *openString = [localTimeFormatter stringFromDate:openTime];
                        NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                        
                        return [NSString stringWithFormat:@"%@\n%@ - %@", displayDateString, openString, closeString];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:fromDate options:NSCalendarMatchNextTime];
            }
        }
    }
    
    return @"";
}

@end

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
    NSDate *currentDateTime = [[NSDate alloc] init];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
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
    
    for (NSDictionary *periodDate in self.periods_in_date) {
        NSDate *fromDate = [utcDateFormatter dateFromString:periodDate[@"from"]];
        NSDate *toDate = [utcDateFormatter dateFromString:periodDate[@"to"]];
        
        if ([Utils isDate:currentDateOnly betweenFirstDate:fromDate andLastDate:toDate]) {
            int count = 0;
            NSDate *nextDate = [[NSDate alloc] init];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            while (count < 7) {
                NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    for (NSDictionary *period in periodArray) {
                        NSDate *openTime = [utcTimeFormatter dateFromString:period[@"open"]];
                        NSDate *closeTime = [utcTimeFormatter dateFromString:period[@"close"]];
                        
                        NSDateComponents *displayDateComponent = [gregorian components:dateFlags|NSCalendarUnitWeekday fromDate:nextDate];
                        NSDateComponents *displayTimeComponent = [gregorian components:timeFlags fromDate:openTime];
                        NSDate *displayDate = [gregorian dateFromComponents:displayDateComponent];
                        displayDate = [gregorian dateBySettingHour:[displayTimeComponent hour] minute:[displayTimeComponent minute] second:[displayTimeComponent second] ofDate:displayDate options:NSCalendarWrapComponents];
                        
                        if (count == 0) {
                            NSComparisonResult timeResult = [currentTimeOnly compare:openTime];
                            if (timeResult == NSOrderedAscending) {
                                NSString *dateString = [localDateFormatter stringFromDate:displayDate];
                                NSString *openString = [localTimeFormatter stringFromDate:openTime];
                                NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                                
                                return [NSString stringWithFormat:@"%@\n%@ - %@", dateString, openString, closeString];
                            }
                        }
                        
                        NSString *dateString = [localDateFormatter stringFromDate:displayDate];
                        NSString *openString = [localTimeFormatter stringFromDate:openTime];
                        NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                        
                        return [NSString stringWithFormat:@"%@\n%@ - %@", dateString, openString, closeString];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:currentDateOnly options:NSCalendarMatchNextTime];
                
            }
        }
        else if ([currentDateOnly compare:fromDate] == NSOrderedAscending){
            int count = 0;
            NSDate *nextDate = fromDate;
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            while (count < 7) {
                NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    for (NSDictionary *period in periodArray) {
                        NSDate *openTime = [utcTimeFormatter dateFromString:period[@"open"]];
                        NSDate *closeTime = [utcTimeFormatter dateFromString:period[@"close"]];
                        
                        NSDateComponents *displayDateComponent = [gregorian components:dateFlags|NSCalendarUnitWeekday fromDate:nextDate];
                        NSDateComponents *displayTimeComponent = [gregorian components:timeFlags fromDate:openTime];
                        NSDate *displayDate = [gregorian dateFromComponents:displayDateComponent];
                        displayDate = [gregorian dateBySettingHour:[displayTimeComponent hour] minute:[displayTimeComponent minute] second:[displayTimeComponent second] ofDate:displayDate options:NSCalendarWrapComponents];
                        
                        NSString *dateString = [localDateFormatter stringFromDate:displayDate];
                        NSString *openString = [localTimeFormatter stringFromDate:openTime];
                        NSString *closeString = [localTimeFormatter stringFromDate:closeTime];
                        
                        return [NSString stringWithFormat:@"%@\n%@ - %@", dateString, openString, closeString];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:fromDate options:NSCalendarWrapComponents];
            }
        }
    }
    
    return @"";
}

@end

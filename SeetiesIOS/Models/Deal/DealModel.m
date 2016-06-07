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
                                                       @"deal_type_info.currency.code": @"currency_code",
                                                       @"deal_type_info.currency.symbol": @"currency_symbol",
                                                       @"deal_id" : @"dID",
                                                       @"description": @"deal_desc",
                                                       @"redemption_periods.periods_in_hours.period_text": @"redemption_period_in_hour_text",
                                                       @"redemption_periods.periods_in_hours.period": @"period",
                                                       @"redemption_periods.periods_in_date": @"periods_in_date",
                                                       @"type": @"voucher_type",
                                                       @"collection_periods.periods_in_date": @"collection_periods_in_date",
                                                       @"collection_periods.expired_at": @"collection_expired_at"
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
    //Compare voucher id first else compare deal id
    if (![Utils isStringNull:otherDealModel.voucher_info.voucher_id] && ![Utils isStringNull:self.voucher_info.voucher_id]) {
        return [otherDealModel.voucher_info.voucher_id isEqualToString:self.voucher_info.voucher_id]? YES : NO;
    }
    else{
        return [otherDealModel.dID isEqualToString:self.dID]? YES : NO;
    }
}

-(NSUInteger)hash{
    if (![Utils isStringNull:self.voucher_info.voucher_id]) {
        return self.voucher_info.voucher_id.hash;
    }
    else{
        return self.dID.hash;
    }
}

-(NSMutableArray<SeShopDetailModel> *)available_shops{
    if (!_available_shops) {
        _available_shops = [[NSMutableArray<SeShopDetailModel> alloc] initWithArray:[self.shops mutableCopy]];
        
        NSMutableArray<SeShopDetailModel> *toBeDeletedArr = [[NSMutableArray<SeShopDetailModel> alloc] init];
        for (SeShopDetailModel *shopModel in _available_shops) {
            if (shopModel.total_available_vouchers == 0) {
                [toBeDeletedArr addObject:shopModel];
            }
        }
        
        if (![Utils isArrayNull:toBeDeletedArr]) {
            [_available_shops removeObjectsInArray:toBeDeletedArr];
        }
    }
    
    return _available_shops;
}

-(NSInteger)collectionDaysLeft{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger numberOfDaysLeft = 0;
    
    if ([Utils isValidDateString:self.collection_expired_at]) {
        NSDate *expiryDate = [dateFormatter dateFromString:self.collection_expired_at];
        
        numberOfDaysLeft = [Utils numberOfDaysLeft:expiryDate];
    }
    
    return numberOfDaysLeft;
}

-(NSInteger)redemptionDaysLeft{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger numberOfDaysLeft = 0;
    
    if ([Utils isValidDateString:self.voucher_info.expired_at]) {
        NSDate *expiryDate = [dateFormatter dateFromString:self.voucher_info.expired_at];
        
        numberOfDaysLeft = [Utils numberOfDaysLeft:expiryDate];
    }
    
    return numberOfDaysLeft;
}

-(NSString*)getNextAvailableRedemptionDateString{
    //Current date time in UTC
    NSDate *currentDateTime = [[NSDate alloc] init];
    //Calendar needs to set to UTC
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    unsigned int dateFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localDateFormatter setDateFormat:@"dd MMM yyyy (EEEE)"];
    
    NSDateFormatter *localTimeFormatter = [[NSDateFormatter alloc] init];
    [localTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localTimeFormatter setDateFormat:@"hh:mmaa"];
    
    //Loop to check through redemption period date
    for (NSDictionary *periodDate in self.periods_in_date) {
        NSDate *fromDate = [utcDateFormatter dateFromString:periodDate[@"from"]];
        NSDate *toDate = [utcDateFormatter dateFromString:periodDate[@"to"]];
        
        //Check if current date falls in between "from" and "to" date
        if ([Utils isDate:currentDateTime betweenFirstDate:fromDate andLastDate:toDate]) {
            int count = 0;
            NSDate *nextDate = currentDateTime;
            
            //Loop and check for the next 7 days (1 week)
            while (count < 7) {
                NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);      //NSDateComponents Sunday=1 //Seeties Sunday=0
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    //Loop through available periods for the current day
                    for (NSDictionary *period in periodArray) {

                        //Combine both date and opening time
                        NSString *open = period[@"open"];
                        NSDateComponents *combineOpenDateComp = [calendar components:dateFlags fromDate:nextDate];
                        [combineOpenDateComp setHour:[open integerValue]/100];
                        [combineOpenDateComp setMinute:[open integerValue]%100];
                        NSDate *combinedOpenDateTime = [calendar dateFromComponents:combineOpenDateComp];
                        
                        //Check whether it is available later today
                        if (count == 0) {
                            NSComparisonResult timeResult = [nextDate compare:combinedOpenDateTime];
                            if (timeResult == NSOrderedAscending) {
                                return [NSString stringWithFormat:@"%@\n%@", [localDateFormatter stringFromDate:combinedOpenDateTime], [localTimeFormatter stringFromDate:combinedOpenDateTime]];
                            }
                            else{
                                continue;
                            }
                        }
                        
                        return [NSString stringWithFormat:@"%@\n%@", [localDateFormatter stringFromDate:combinedOpenDateTime], [localTimeFormatter stringFromDate:combinedOpenDateTime]];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:currentDateTime options:NSCalendarMatchNextTime];
            }
        }
        //Else check whether it's available in the future
        else if ([currentDateTime compare:fromDate] == NSOrderedAscending){
            int count = 0;
            NSDate *nextDate = fromDate;
            
            while (count < 7) {
                NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nextDate];
                NSInteger weekday = ([comps weekday] - 1);
                NSArray *periodArray = self.period[weekday];
                
                if (![Utils isArrayNull:periodArray]) {
                    for (NSDictionary *period in periodArray) {
                        //Combine both date and opening time
                        NSString *open = period[@"open"];
                        NSDateComponents *combineOpenDateComp = [calendar components:dateFlags fromDate:nextDate];
                        [combineOpenDateComp setHour:[open integerValue]/100];
                        [combineOpenDateComp setMinute:[open integerValue]%100];
                        NSDate *combinedOpenDateTime = [calendar dateFromComponents:combineOpenDateComp];
                        
                        return [NSString stringWithFormat:@"%@\n%@", [localDateFormatter stringFromDate:combinedOpenDateTime], [localTimeFormatter stringFromDate:combinedOpenDateTime]];
                    }
                }
                
                count++;
                nextDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:count toDate:fromDate options:NSCalendarMatchNextTime];
            }
        }
    }
    
    return @"";
}

-(NSString*)getNextAvailableCollectionDateString{
    //Current date time in UTC
    NSDate *currentDateTime = [[NSDate alloc] init];
    
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localDateFormatter setDateFormat:@"dd MMM yyyy (EEEE)"];
    
    NSDateFormatter *localTimeFormatter = [[NSDateFormatter alloc] init];
    [localTimeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [localTimeFormatter setDateFormat:@"hh:mmaa"];
    
    //Loop to check through collection period date
    for (NSDictionary *periodDate in self.collection_periods_in_date) {
        NSDate *fromDate = [utcDateFormatter dateFromString:periodDate[@"from"]];
        
        NSComparisonResult compareResult = [currentDateTime compare:fromDate];
        if (compareResult == NSOrderedAscending) {
            NSString *dateString = [localDateFormatter stringFromDate:fromDate];
            NSString *timeString = [localTimeFormatter stringFromDate:fromDate];
            
            return [NSString stringWithFormat:@"%@\n%@", dateString, timeString];
        }
    }
    
    return @"";
}

-(BOOL)isRedeemable{
    if ([self isWithinOperatingDate:self.periods_in_date]) {
        if ([self isWithinOperationHour:self.period]) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    
    return NO;
}

-(BOOL)isCollectable{
    if ([self isWithinCollectionPeriod:self.collection_periods_in_date]) {
        if (self.total_available_vouchers == 0) {
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        return NO;
    }
}

-(BOOL)isWithinCollectionPeriod:(NSArray*)arrayPeriods{
    NSDateFormatter *utcDateTimeFormatter = [[NSDateFormatter alloc] init];
    [utcDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [[NSDate alloc] init];
    
    for (NSDictionary *dateDict in arrayPeriods) {
        NSDate* fromDate = [Utils isValidDateString:dateDict[@"from"]]? [utcDateTimeFormatter dateFromString:dateDict[@"from"]] : nil;
        NSDate* toDate = [Utils isValidDateString:dateDict[@"to"]]? [utcDateTimeFormatter dateFromString:dateDict[@"to"]] : nil;
        
        if (!fromDate && !toDate) {
            return YES;
        }
        else if (!fromDate && toDate){
            NSComparisonResult result = [currentDate compare:toDate];
            return (result == NSOrderedSame || result == NSOrderedAscending)? YES : NO;
        }
        else if (fromDate && !toDate){
            NSComparisonResult result = [currentDate compare:fromDate];
            return (result == NSOrderedSame || result == NSOrderedDescending)? YES : NO;
        }
        else if (fromDate && toDate){
            NSComparisonResult firstDateResult = [currentDate compare:fromDate];
            NSComparisonResult lastDateResult = [currentDate compare:toDate];
            
            if (firstDateResult == NSOrderedSame || lastDateResult == NSOrderedSame) {
                return YES;
            }
            else if (firstDateResult == NSOrderedDescending && lastDateResult == NSOrderedAscending){
                return YES;
            }
        }
    }
    
    return NO;
}

-(BOOL)isWithinOperatingDate:(NSArray*)arrayDates{
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (NSDictionary *dateDict in arrayDates) {
        NSDate* fromDate = [Utils isValidDateString:dateDict[@"from"]]? [utcDateFormatter dateFromString:dateDict[@"from"]] : nil;
        NSDate* toDate = [Utils isValidDateString:dateDict[@"to"]]? [utcDateFormatter dateFromString:dateDict[@"to"]] : nil;
        
        if([Utils isDate:[NSDate date] betweenFirstDate:fromDate andLastDate:toDate]){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isWithinOperationHour:(NSArray*)arrayDays
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = ([comps weekday] - 1);      //NSDateComponents Sunday=1 //Seeties Sunday=0
    NSArray *arrHours = arrayDays[weekday];
    
    // loop through period date time to check available in operating hours
    for (int i = 0; i<arrHours.count; i++) {
        
        NSDictionary* dictHour = arrHours[i];
        
        int strFrom = [dictHour[@"open"] intValue];
        int hourFrom = strFrom/100;
        int minuteFrom = strFrom%100;
        NSDate *now = [NSDate date];
        NSCalendar *calendarFrom = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *componentsFrom = [calendarFrom components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        [componentsFrom setHour:hourFrom];
        [componentsFrom setMinute:minuteFrom];
        NSDate *fromDateTime = [calendar dateFromComponents:componentsFrom];
        
        int strTo = [dictHour[@"close"] intValue];
        int hourTo = strTo/100;
        int minuteTo = strTo%100;
        NSCalendar *calendarTo = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        NSDateComponents *componentsTo = [calendarTo components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        [componentsTo setHour:hourTo];
        [componentsTo setMinute:minuteTo];
        NSDate *toDateTime = [calendar dateFromComponents:componentsTo];
        
        if ([Utils date:now isBetweenDate:fromDateTime andDate:toDateTime]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];

    }


}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];

        }
    }
    
    return self;
}


@end

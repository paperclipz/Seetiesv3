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

-(BOOL)isRedeemable{
    if ([Utils isWithinOperatingDate:self.periods_in_date]) {
        if ([Utils isWithinOperationHour:self.period]) {
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

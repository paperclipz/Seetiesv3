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
                                                       @"redemption_periods.periods_in_date": @"periods_in_date"
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
    NSMutableString *nextDateString = [[NSMutableString alloc] init];
    return nextDateString;
}

@end

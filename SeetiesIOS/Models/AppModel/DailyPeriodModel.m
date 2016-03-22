//
//  DailyPeriodModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DailyPeriodModel.h"

@implementation DailyPeriodModel
-(NSString *)earliestOpening{
    if ([Utils isArrayNull:self.periods]) {
        return @"";
    }
    
    PeriodModel *firstPeriod = self.periods[0];
    return firstPeriod.formatted12HourOpen;
}

-(NSString *)latestClosing{
    if ([Utils isArrayNull:self.periods]) {
        return @"";
    }
    
    NSInteger lastIndex = self.periods.count - 1;
    PeriodModel *lastPeriod = self.periods[lastIndex];
    return lastPeriod.formatted12HourClose;
}

-(NSString *)day{
    switch (self.dayNumber) {
        case 0:
            return LocalisedString(@"Sunday");
        
        case 1:
            return LocalisedString(@"Monday");
            
        case 2:
            return LocalisedString(@"Tuesday");
            
        case 3:
            return LocalisedString(@"Wednesday");
            
        case 4:
            return LocalisedString(@"Thursday");
            
        case 5:
            return LocalisedString(@"Friday");
            
        case 6:
            return LocalisedString(@"Saturday");
            
        default:
            return @"";
    }
}
@end

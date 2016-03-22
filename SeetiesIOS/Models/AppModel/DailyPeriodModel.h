//
//  DailyPeriodModel.h
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 22/03/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeriodModel.h"

@protocol PeriodModel
@end

@interface DailyPeriodModel : NSObject
@property(nonatomic) NSString *day;
@property(nonatomic) int dayNumber;     //0 - Sunday, 1 - Monday ... 
@property(nonatomic) NSMutableArray<PeriodModel> *periods;
@property(nonatomic) NSString *earliestOpening;     //return formatted opening hour
@property(nonatomic) NSString *latestClosing;       //return formatted closing hour
@end

//
//  OpeningPeriodModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 9/18/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "JSONModel.h"



@protocol DayTimeModel
@end
@protocol OperatingHoursModel
@end





@interface DayTimeModel : JSONModel
@property(nonatomic,assign)int day;
@property(nonatomic,assign)int time;
@end




@interface OperatingHoursModel : JSONModel
@property(nonatomic,strong)DayTimeModel* close;
@property(nonatomic,strong)DayTimeModel* open;
@property(nonatomic,assign)BOOL isOpen;

@end




@interface OpeningPeriodModels : JSONModel

@property(nonatomic,assign)BOOL open_now;
@property(nonatomic,strong)NSArray<OperatingHoursModel>* periods;
@property(nonatomic,strong)NSDictionary* period_text;



@end

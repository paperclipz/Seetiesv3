//
//  NotificationModels.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NotificationModels.h"

@interface NotificationModels()
@property(nonatomic,strong)NSArray<NotificationModel>* activities;
@property(nonatomic,strong)NSArray<NotificationModel>* result;

@end
@implementation NotificationModels
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       }];
}

-(NSArray<NotificationModel>*)arrNotifications
{
    if (!_arrNotifications) {
        if (![Utils isArrayNull:_activities]) {
            _arrNotifications = _activities;
        }
        else
        {
            _arrNotifications = _result;

        }
    }
    
    return _arrNotifications;
}
@end


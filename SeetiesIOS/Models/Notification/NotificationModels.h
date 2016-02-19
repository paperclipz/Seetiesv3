
//
//  NotificationModels.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "NotificationModel.h"

@protocol NotificationModel

@end


@interface NotificationModels : PaginationModel
@property(nonatomic,strong)NSString* latest_timestamp;
@property(nonatomic,strong)NSString* total_activities;
@property(nonatomic,strong)NSArray<NotificationModel>* arrNotifications;

@end

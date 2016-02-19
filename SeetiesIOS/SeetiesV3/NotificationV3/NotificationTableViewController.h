//
//  NotificationTableViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^NotificationBlock)(NotificationModel* model);
@interface NotificationTableViewController : UITableViewController
-(void)requestServer:(int)viewType;
@property(nonatomic,copy)NotificationBlock didSelectNotificationBlock;
@end

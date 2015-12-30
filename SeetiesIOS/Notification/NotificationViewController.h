//
//  NotificationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
@class ProfileViewController;
@interface NotificationViewController : BaseViewController<UIScrollViewDelegate>@property(nonatomic,strong)ProfileViewController* profileViewController;
-(void)GetNotification;
@end

//
//  NotificationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"

@interface NotificationViewController : BaseViewController<UIScrollViewDelegate>{
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIView *ShowNoDataView;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    
    NSMutableArray *PostIDArray;
    NSMutableArray *TypeArray;
    NSMutableArray *UserThumbnailArray;
    NSMutableArray *PostThumbnailArray;
    NSMutableArray *UserNameArray;
    NSMutableArray *uidArray;
    NSMutableArray *MessageArray;
    NSMutableArray *ActionArray;
    NSMutableArray *DateArray;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UIImageView *NoDataImg;
    
    IBOutlet UILabel *ShowNoDataText_1;
    IBOutlet UILabel *ShowNoDataText_2;
    
    UIView *FollowingView;
    UIView *NotificationsView;
    
    int GetHeight;
    
    NSURLConnection *theConnection_GetNotification;
    NSURLConnection *theConnection_GetFollowing;
    
    //following data
    NSMutableArray *Following_PostIDArray;
    NSMutableArray *Following_TypeArray;
    NSMutableArray *Following_UserThumbnailArray;
    NSMutableArray *Following_PostThumbnailArray;
    NSMutableArray *Following_UserNameArray;
    NSMutableArray *Following_uidArray;
    NSMutableArray *Following_MessageArray;
    NSMutableArray *Following_ActionArray;
    NSMutableArray *Following_DateArray;
    
    UIRefreshControl *refreshControl;
    
     int CheckClick_Following;
    
    UILabel *UpdateNotificationLabel;
}
-(void)GetNotification;
@end

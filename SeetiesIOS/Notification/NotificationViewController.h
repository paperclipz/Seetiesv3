//
//  NotificationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "DoImagePickerController.h"
@interface NotificationViewController : BaseViewController<UIScrollViewDelegate,DoImagePickerControllerDelegate>{
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
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UIImageView *NoDataImg;
    
    IBOutlet UILabel *ShowNoDataText_1;
    IBOutlet UILabel *ShowNoDataText_2;
}
-(void)GetNotification;
@end

//
//  ExploreViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
#import "DoImagePickerController.h"
@interface ExploreViewController : GAITrackedViewController<UIScrollViewDelegate,DoImagePickerControllerDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *IconImage;
    IBOutlet UIButton *SearchBox;
    IBOutlet UIButton *SearchButton;

    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *CountryIDArray;
    NSMutableArray *NameArray;
    NSMutableArray *SeqNoArray;
    NSMutableArray *ThumbnailArray;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_CheckNotification;
    
    NSTimer *GetNotifactionCountTimer;
    UILabel *ShowBadgeText;
    IBOutlet UITextField *SearchLocation;
    
    BOOL CheckLoadDone;

    IBOutlet UIButton *FindPPLButton;
    
    //LLARingSpinnerView *spinnerView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(void)GetExploreDataFromServer;
-(void)InitView;

-(IBAction)SearchButton:(id)sender;
-(IBAction)NotificationButton:(id)sender;
-(IBAction)FindPPlButton:(id)sender;
@end

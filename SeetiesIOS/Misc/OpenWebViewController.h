//
//  OpenWebViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/1/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface OpenWebViewController : GAITrackedViewController<UIActionSheetDelegate>{

    IBOutlet UIWebView *web;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    NSTimer *timer;
    
    NSString *url;
    NSString *GetStringText;
    
    UrlDataClass *DataUrl;
    
}
-(void)GetTitleString:(NSString *)String;
-(void)GetTitleString:(NSString *)StringTitle GetFestivalUrl:(NSString *)StringUrl;
-(void)GetFullUrlString:(NSString *)String;

-(IBAction)WebBackButton:(id)sender;
-(IBAction)WebForwardButton:(id)sender;
-(IBAction)RefreshButton:(id)sender;
-(IBAction)StopButton:(id)sender;
@end

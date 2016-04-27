//
//  LocationFeedDetailViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <MapKit/MapKit.h>
//#import "GAITrackedViewController.h"
@interface LocationFeedDetailViewController : UIViewController<MKMapViewDelegate,UIScrollViewDelegate>

-(void)GetLat:(NSString *)Lat GetLong:(NSString *)Long GetFirstImage:(NSString *)FirstImage GetTitle:(NSString *)Title GetLocation:(NSString *)Location;
-(void)GetLink:(NSString *)Link GetContact:(NSString *)Contact GetOpeningHour:(NSString *)OpeningHour GetPrice:(NSString *)Price GetPeriods:(NSString *)Periods;
-(IBAction)DirectionsButton:(id)sender;
@end

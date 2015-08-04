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
#import "GAITrackedViewController.h"
@interface LocationFeedDetailViewController : GAITrackedViewController<MKMapViewDelegate,UIScrollViewDelegate>{
    
    IBOutlet UILabel *ShowMainTitle;
    IBOutlet UIButton *DirectionsButton;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIScrollView *MainScroll;

    NSString *GetLat;
    NSString *GetLong;
    NSString *GetFirstImage;
    NSString *GetTitle;
    NSString *GetLocation;
    
    IBOutlet MKMapView *MapView;
    CLLocationCoordinate2D coordinate;
    
    NSString *GetPlaceLink;
    NSString *GetContact;
    NSString *GetOpeningHour;
    NSString *GetPrice;
}
-(IBAction)BackButton:(id)sender;
-(void)GetLat:(NSString *)Lat GetLong:(NSString *)Long GetFirstImage:(NSString *)FirstImage GetTitle:(NSString *)Title GetLocation:(NSString *)Location;
-(void)GetLink:(NSString *)Link GetContact:(NSString *)Contact GetOpeningHour:(NSString *)OpeningHour GetPrice:(NSString *)Price;
-(IBAction)DirectionsButton:(id)sender;
@end

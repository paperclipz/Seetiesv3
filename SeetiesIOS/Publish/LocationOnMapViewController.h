//
//  LocationOnMapViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
@interface LocationOnMapViewController : GAITrackedViewController<MKMapViewDelegate>{

    IBOutlet MKMapView *MapView;
    CLLocationCoordinate2D coordinate;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *LocationOnMap;
    IBOutlet UIButton *DoneButton;
    
    NSString *TempGetlat;
    NSString *TempGetlng;
    
    IBOutlet UIImageView *BarImage;
    
    IBOutlet UIButton *BlackButtonDown;
    
    NSString *GetAddress;
    
    NSMutableData *webData;
    NSURLConnection *theConnection_GooglePlaceDetail;
    
    NSString *GetCheckString;
    
    IBOutlet UIButton *LoadingButton;
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(void)CheckAddNewPlace:(NSString *)CheckString;
-(void)GetAddress:(NSString *)TempAddress;
-(IBAction)BackButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
@end

//
//  EditLocationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
@interface EditLocationViewController : GAITrackedViewController<MKMapViewDelegate,UIScrollViewDelegate>{

    IBOutlet MKMapView *ShowmapView;
    IBOutlet UITextField *ShowPlaceName;
    IBOutlet UITextView *ShowAddress;
    IBOutlet UIScrollView *MainScroll;
    NSString *GetName;
    NSString *GetAddress;
    CLLocationCoordinate2D coordinate;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowPlaceText;
    IBOutlet UILabel *ShowAddressText;
    IBOutlet UIButton *DoneButton;
    IBOutlet UILabel *TapHereLabel;
    
    NSString *JsonAddress;
    NSString *JsonState;
    NSString *JsonCountry;
    NSString *JsonTempAddress;
    NSString *Jsonlat;
    NSString *Jsonlng;
    NSString *JsonID;
}
-(IBAction)BackButton:(id)sender;
-(void)GetName:(NSString *)Name GetAddress:(NSString *)Address GetLat:(CLLocationCoordinate2D)coordinate_;
-(IBAction)MoveMapButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
-(void)JsonAddress:(NSString *)Address JsonState:(NSString *)State JsonCountry:(NSString *)Country JsonTempAddress:(NSString *)TempAddress JsonLat:(NSString *)lat JsonLng:(NSString *)lng JsonID:(NSString *)ID;

@end

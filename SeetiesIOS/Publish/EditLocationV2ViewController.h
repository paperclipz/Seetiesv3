//
//  EditLocationV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/21/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
@class TPKeyboardAvoidingScrollView;
@interface EditLocationV2ViewController : GAITrackedViewController<MKMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet MKMapView *MapView;
    CLLocationCoordinate2D coordinate;
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    
    IBOutlet UITextField *EditPlaceNameField;
    IBOutlet UITextView *ShowAddress;
    
     IBOutlet UIImageView *BarImage;
    
    IBOutlet UIButton *DoneButton;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIButton *ChangePinButton;
    IBOutlet UILabel *ArrowRight;
    

}

-(IBAction)BackButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
-(IBAction)ChangePinButton:(id)sender;
@end

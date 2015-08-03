//
//  ConfirmPlaceViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/24/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "GAITrackedViewController.h"
@class TPKeyboardAvoidingScrollView;
@interface ConfirmPlaceViewController : GAITrackedViewController<MKMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet MKMapView *MapView;
    CLLocationCoordinate2D coordinate;
    
    IBOutlet UIView *ShowDownView;
    IBOutlet UIView *ShowEditMapView;
    
    IBOutlet UITextField *ShowName;
    IBOutlet UITextView *ShowAddress;
    IBOutlet UILabel *ShowPhone;
    IBOutlet UILabel *ShowPrice;
    IBOutlet UILabel *ShowHours;
    IBOutlet UILabel *ShowWebsite;
    
    IBOutlet UIImageView *ShowWebsiteIcon;
    IBOutlet UIImageView *ShowPhoneIcon;
    IBOutlet UIImageView *ShowPriceIcon;
    IBOutlet UIImageView *ShowHourIcon;
    
    IBOutlet UIButton *LineButton;
    IBOutlet UIButton *EditAddressButton;
    
    NSString *GetLat;
    NSString *GetLng;
    NSString *GetPlaceID;
    
    NSMutableData *webData;
    NSURLConnection *theConnection_GooglePlaceDetail;
    
    //google data
    NSString *Get_FormattedAddress;
    NSString *Get_PhoneNumber;
    NSString *Get_Lat;
    NSString *Get_Lng;
    NSString *Get_Name;
    NSString *Get_OpeningHours;
    NSString *Get_Website;
    
    NSString *dayName;
    
    IBOutlet UIButton *AddPriceButton;
    IBOutlet UIButton *AddWebsiteButton;
    IBOutlet UIButton *AddContactButton;
    
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIImageView *BarImage;
    
    IBOutlet UIButton *SearchAgainButton;
    
    IBOutlet UIButton *DoneButton;
    
    IBOutlet UILabel *ShowWrongPlaceText;
    
    NSString *GetCheckString;
    
    IBOutlet UIButton *ChangePinButton;
    IBOutlet UILabel *ArrowRight;
    
    int GetFinalHeight;
    
    UIImageView *EditInfoIcon_1;
    UIImageView *EditInfoIcon_2;
    UIImageView *EditInfoIcon_3;
    
    IBOutlet UIButton *OpenMapButton;
    IBOutlet UILabel *ShowTaptheMapPin;
}
-(void)CheckAddNewPlace:(NSString *)CheckString;
-(IBAction)BackButton:(id)sender;
-(IBAction)DoneButton:(id)sender;

-(IBAction)AddWebsiteButton:(id)sender;
-(IBAction)AddPriceButton:(id)sender;
-(IBAction)AddContactButton:(id)sender;
-(IBAction)EditLocationbutton:(id)sender;
-(IBAction)ChangePlaceButton:(id)sender;

-(IBAction)ChangePinButton:(id)sender;
@end

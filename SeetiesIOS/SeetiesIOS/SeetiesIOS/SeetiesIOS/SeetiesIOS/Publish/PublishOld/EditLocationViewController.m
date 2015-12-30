//
//  EditLocationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "EditLocationViewController.h"
#import "LocationOnMapViewController.h"
#import "PublishViewController.h"
#import "LanguageManager.h"
#import "Locale.h"

@interface EditLocationViewController ()
@property (strong, nonatomic) NSArray *nearbyVenues;
@end

@implementation EditLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64);
    
    [DoneButton setTitle:CustomLocalisedString(@"Done", nil) forState:UIControlStateNormal];
    ShowTitle.text = CustomLocalisedString(@"EditLocation", nil);
    ShowPlaceText.text = CustomLocalisedString(@"PLACENAME", nil);
    ShowAddressText.text = CustomLocalisedString(@"LOCATIONADDRESS", nil);
    TapHereLabel.text = CustomLocalisedString(@"Tapheretopin", nil);
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Edit Location Page";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)GetName:(NSString *)Name GetAddress:(NSString *)Address GetLat:(CLLocationCoordinate2D)coordinate_{

    GetName = Name;
    GetAddress = Address;
    coordinate = coordinate_;
    ShowAddress.text = GetAddress;
    ShowPlaceName.text = GetName;
    
    [self proccessAnnotations];
}
- (void)removeAllAnnotationExceptOfCurrentUser {
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:ShowmapView.annotations];
    if ([ShowmapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:ShowmapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in ShowmapView.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [ShowmapView removeAnnotations:annForRemove];
}

- (void)proccessAnnotations {
//    [self removeAllAnnotationExceptOfCurrentUser];
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    [annotation setCoordinate:coordinate];
//    [annotation setTitle:@"We at here"];
//    NSLog(@"annotation is %@",annotation);
//    [ShowmapView addAnnotation:annotation];
    
    ShowmapView.delegate = self;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = coordinate.latitude;
    newRegion.center.longitude = coordinate.longitude;
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    [ShowmapView setRegion:newRegion animated:YES];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:@"We at Here"]; //You can set the subtitle too
    [ShowmapView addAnnotation:annotation];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"MapPin.png"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [button addTarget:self
//                   action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}
-(void)JsonAddress:(NSString *)Address JsonState:(NSString *)State JsonCountry:(NSString *)Country JsonTempAddress:(NSString *)TempAddress JsonLat:(NSString *)lat JsonLng:(NSString *)lng JsonID:(NSString *)ID{

    JsonAddress = Address;
    JsonState = State;
    JsonCountry = Country;
    JsonTempAddress = TempAddress;
    Jsonlat = lat;
    Jsonlng = lng;
    JsonID = ID;
}
-(IBAction)MoveMapButton:(id)sender{
    LocationOnMapViewController *LocationOnMapView = [[LocationOnMapViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:LocationOnMapView animated:NO completion:nil];
   // [LocationOnMapView GetLocation:coordinate];
   //[LocationOnMapView JsonAddress:JsonAddress JsonState:JsonState JsonCountry:JsonCountry JsonTempAddress:JsonTempAddress JsonLat:Jsonlat JsonLng:Jsonlng JsonID:JsonID];
}
-(IBAction)DoneButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ShowAddress.text forKey:@"Location_Address"];
    [defaults setObject:ShowPlaceName.text forKey:@"Location_PlaceName"];
    [defaults synchronize];
    
    PublishViewController *PublishView = [[PublishViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PublishView animated:NO completion:nil];
}
@end

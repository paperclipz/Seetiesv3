//
//  LocationOnMapViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "LocationOnMapViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface LocationOnMapViewController ()

@end

@implementation LocationOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ShowTitle.text = CustomLocalisedString(@"LocationOnMap", nil);
    [DoneButton setTitle:CustomLocalisedString(@"Done", nil) forState:UIControlStateNormal];
    LocationOnMap.text = CustomLocalisedString(@"Dragthemap", nil);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    LoadingButton.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    LoadingButton.hidden = YES;

    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    [DoneButton setTitle:CustomLocalisedString(@"DoneButton", nil) forState:UIControlStateNormal];
    DoneButton.frame = CGRectMake(screenWidth - 80 - 15, 20, 80, 44);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    MapView.frame = CGRectMake(0,64, screenWidth, screenHeight - 64);
    
    BlackButtonDown.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    LocationOnMap.frame = CGRectMake(15, screenHeight - 50, screenWidth - 30, 50);
}
-(void)CheckAddNewPlace:(NSString *)CheckString{
    
    GetCheckString = CheckString;
    if ([GetCheckString isEqualToString:@"AddNewPlace"]) {
        
    }else{
    }
}
-(void)GetAddress:(NSString *)TempAddress{

    GetAddress = TempAddress;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Location On Map Page";
    
    MapView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    TempGetlat = [defaults objectForKey:@"PublishV2_Lat"];
    TempGetlng = [defaults objectForKey:@"PublishV2_Lng"];
    NSLog(@"LocationOnMap GetLatData is %@",TempGetlat);
    NSLog(@"LocationOnMap GetLngData is %@",TempGetlng);
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [TempGetlat doubleValue];
    newRegion.center.longitude = [TempGetlng doubleValue];
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
    [MapView setRegion:newRegion animated:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSString *tamplatitude = [[NSString alloc]initWithFormat:@"%@",TempGetlat];
    NSString *tampLongitude = [[NSString alloc]initWithFormat:@"%@",TempGetlng];
    
    region.center.latitude = [tamplatitude doubleValue];
    region.center.longitude = [tampLongitude doubleValue];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:region.center];
    //[annotation setTitle:@"We at Here"]; //You can set the subtitle too
    [MapView addAnnotation:annotation];
    
    // Create a gesture recognizer for long presses (for example in viewDidLoad)
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3; //user needs to press for half a second.
    [MapView addGestureRecognizer:lpgr];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:MapView];
    CLLocationCoordinate2D touchMapCoordinate = [MapView convertPoint:touchPoint toCoordinateFromView:MapView];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    for (id annotation in MapView.annotations) {
        [MapView removeAnnotation:annotation];
        NSLog(@"lon: %f, lat %f", ((MKPointAnnotation*)annotation).coordinate.longitude,((MKPointAnnotation*)annotation).coordinate.latitude);
        TempGetlat = [[NSString alloc]initWithFormat:@"%f",touchMapCoordinate.latitude];
        TempGetlng = [[NSString alloc]initWithFormat:@"%f",touchMapCoordinate.longitude];
        
        NSLog(@"1st get TempGetlat is %@",TempGetlat);
        NSLog(@"1st get TempGetlng is %@",TempGetlng);
    }
    //[point setTitle:@"We at Here"];
    [MapView addAnnotation:point];
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
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}

-(IBAction)DoneButton:(id)sender{
    NSLog(@"before save TempGetlat is %@",TempGetlat);
    NSLog(@"before save TempGetlng is %@",TempGetlng);

//    [self dismissViewControllerAnimated:YES completion:nil];
    if ([GetCheckString isEqualToString:@"AddNewPlace"]) {
         [self GetGooglePlaceDetail];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:TempGetlat forKey:@"PublishV2_Lat"];
        [defaults setObject:TempGetlng forKey:@"PublishV2_Lng"];
        [defaults synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}
-(void)GetGooglePlaceDetail{
    LoadingButton.hidden = NO;
    [ShowActivity startAnimating];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%@,%@",TempGetlat,TempGetlng];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GooglePlaceDetail = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GooglePlaceDetail start];
    
    
    if( theConnection_GooglePlaceDetail ){
        webData = [NSMutableData data];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    LoadingButton.hidden = YES;
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"get data to server   ==== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
    NSLog(@"StatusString is %@",StatusString);
    
    if ([StatusString isEqualToString:@"OK"]) {
        NSArray *GetresultsData = (NSArray *)[res valueForKey:@"results"];
        NSLog(@"GetresultsData is %@",GetresultsData);
        
        NSMutableArray *GetFormattedArray = [[NSMutableArray alloc]init];
        NSMutableArray *GetPlaceIDArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in GetresultsData) {
            NSString *Get_FormattedAddress = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"formatted_address"]];
            [GetFormattedArray addObject:Get_FormattedAddress];
            NSString *place_id = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"place_id"]];
            [GetPlaceIDArray addObject:place_id];
        }
        NSLog(@"GetFormattedArray === %@",GetFormattedArray);
        
        NSMutableArray *GetLatArray = [[NSMutableArray alloc]init];
        NSMutableArray *GetLngArray = [[NSMutableArray alloc]init];
        NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
        for (NSDictionary *dict in geometryData ) {
            NSDictionary *locationData = [dict  valueForKey:@"location"];
            NSString *Get_Lat = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
            NSString *Get_Lng = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
            [GetLatArray addObject:Get_Lat];
            [GetLngArray addObject:Get_Lng];
        }

        NSLog(@"GetLatArray === %@",GetLatArray);
        NSLog(@"GetLngArray === %@",GetLngArray);
        NSMutableArray *countryArray = [[NSMutableArray alloc]init];
         NSMutableArray *routeArray = [[NSMutableArray alloc]init];
         NSMutableArray *administrative_area_level_1Array = [[NSMutableArray alloc]init];
         NSMutableArray *localityArray = [[NSMutableArray alloc]init];
        NSMutableArray *PostalCodeArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in GetresultsData){
            
            NSDictionary *address_componentsData = [dict valueForKey:@"address_components"];
            NSLog(@"address_componentsData is %@",address_componentsData);
           // NSMutableArray *testarray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in address_componentsData) {
                if([[dict objectForKey:@"types"] containsObject:@"country"])
                {
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                    [countryArray addObject:FullString];
                }
                if([[dict objectForKey:@"types"] containsObject:@"route"])
                {
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                    [routeArray addObject:FullString];
                }
                if([[dict objectForKey:@"types"] containsObject:@"administrative_area_level_1"])
                {
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                    [administrative_area_level_1Array addObject:FullString];
                }
                if([[dict objectForKey:@"types"] containsObject:@"locality"])
                {
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                    [localityArray addObject:FullString];
                }
                if([[dict objectForKey:@"types"] containsObject:@"postal_code"])
                {
                    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                    [PostalCodeArray addObject:FullString];
                }
                
            }
        

        }
        
        NSString *GetRoute;
        NSString *GetCountry;
        NSString *Getadministrative_area_level_1;
        NSString *Getlocality;
        NSString *GetPostalCode;
        NSString *Getformatted_address;
        NSString *GetLat;
        NSString *GetLng;
        NSString *GetPlaceID;
        
        if ([GetFormattedArray count] >= 1) {
            Getformatted_address = [[NSString alloc]initWithFormat:@"%@",[GetFormattedArray objectAtIndex:0]];
            NSLog(@"Getformatted_address is %@",Getformatted_address);
        }else{
            Getformatted_address = @"";
        }
        if ([GetPlaceIDArray count] >= 1) {
            GetPlaceID = [[NSString alloc]initWithFormat:@"%@",[GetPlaceIDArray objectAtIndex:0]];
            NSLog(@"GetPlaceID is %@",GetPlaceID);
        }else{
            GetPlaceID = @"";
        }
        
        if ([GetLatArray count] >= 1) {
            GetLat = [[NSString alloc]initWithFormat:@"%@",[GetLatArray objectAtIndex:0]];
            NSLog(@"GetLat is %@",GetLat);
        }else{
            GetLat = @"";
        }
        
        if ([GetLngArray count] >= 1) {
            GetLng = [[NSString alloc]initWithFormat:@"%@",[GetLngArray objectAtIndex:0]];
            NSLog(@"GetLng is %@",GetLng);
        }else{
            GetLng = @"";
        }
        if ([PostalCodeArray count] >= 1) {
            GetPostalCode = [[NSString alloc]initWithFormat:@"%@",[PostalCodeArray objectAtIndex:0]];
            NSLog(@"GetPostalCode is %@",GetPostalCode);
        }else{
            GetPostalCode = @"";
        }
        
        if ([routeArray count] >= 1) {
            GetRoute = [[NSString alloc]initWithFormat:@"%@",[routeArray objectAtIndex:0]];
            NSLog(@"GetRoute is %@",GetRoute);
        }else{
        GetRoute = @"";
        }
        if ([countryArray count] >= 1) {
            GetCountry = [[NSString alloc]initWithFormat:@"%@",[countryArray objectAtIndex:0]];
            NSLog(@"GetCountry is %@",GetCountry);
        }else{
            GetCountry = @"";
        }
        if ([administrative_area_level_1Array count] >= 1) {
            Getadministrative_area_level_1 = [[NSString alloc]initWithFormat:@"%@",[administrative_area_level_1Array objectAtIndex:0]];
            NSLog(@"Getadministrative_area_level_1 is %@",Getadministrative_area_level_1);
        }else{
            Getadministrative_area_level_1 = @"";
        }
        if ([localityArray count] >= 1) {
            Getlocality = [[NSString alloc]initWithFormat:@"%@",[localityArray objectAtIndex:0]];
            NSLog(@"Getlocality is %@",Getlocality);
        }else{
            Getlocality = @"";
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:GetLat forKey:@"PublishV2_Lat"];
        [defaults setObject:GetLng forKey:@"PublishV2_Lng"];
        
        if ([GetAddress isEqualToString:@"Add address"] || [GetAddress length] == 0) {
            [defaults setObject:Getformatted_address forKey:@"PublishV2_Address"];
        }else{
            [defaults setObject:GetAddress forKey:@"PublishV2_Address"];
        }
        
        [defaults setObject:Getadministrative_area_level_1 forKey:@"PublishV2_Location_Address"];
        [defaults setObject:Getlocality forKey:@"PublishV2_Location_City"];
        [defaults setObject:GetCountry forKey:@"PublishV2_Location_Country"];
        [defaults setObject:GetRoute forKey:@"PublishV2_Location_State"];
        [defaults setObject:GetPostalCode forKey:@"PublishV2_Location_PostalCode"];
        [defaults setObject:GetPlaceID forKey:@"PublishV2_Location_PlaceId"];
        [defaults setObject:@"4" forKey:@"PublishV2_type"];
        [defaults synchronize];
        

        LoadingButton.hidden = YES;
        [ShowActivity stopAnimating];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
    
    }
    
    
}
@end

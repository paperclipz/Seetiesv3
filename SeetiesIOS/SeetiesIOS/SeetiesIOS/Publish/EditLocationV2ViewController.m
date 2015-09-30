//
//  EditLocationV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/21/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "EditLocationV2ViewController.h"
#import "LocationOnMapViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface EditLocationV2ViewController ()

@end

@implementation EditLocationV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MapView.delegate = self;
    EditPlaceNameField.delegate = self;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    DoneButton.frame = CGRectMake(screenWidth - 60 - 15, 20, 60, 44);
    ArrowRight.frame = CGRectMake(screenWidth - 42 - 15, 217, 42, 21);
    ChangePinButton.frame = CGRectMake(0, 214, screenWidth, 30);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    MapView.frame = CGRectMake(0, 64, screenWidth, 180);
    ShowAddress.frame = CGRectMake(51, 346, screenWidth - 51 - 15, 126);
    EditPlaceNameField.frame = CGRectMake(56, 259, screenWidth - 56 - 15, 50);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"IOS Edit Location View V2";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
    NSString *GetNameData = [defaults objectForKey:@"PublishV2_Name"];
    NSString *GetLatData = [defaults objectForKey:@"PublishV2_Lat"];
    NSString *GetLngData = [defaults objectForKey:@"PublishV2_Lng"];
    
    NSLog(@"Edit Location GetLatData is %@",GetLatData);
    NSLog(@"Edit Location GetLngData is %@",GetLngData);
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [GetLatData doubleValue];
    newRegion.center.longitude = [GetLngData doubleValue];
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
    [MapView setRegion:newRegion animated:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSString *tamplatitude = [[NSString alloc]initWithFormat:@"%@",GetLatData];
    NSString *tampLongitude = [[NSString alloc]initWithFormat:@"%@",GetLngData];
    
    region.center.latitude = [tamplatitude doubleValue];
    region.center.longitude = [tampLongitude doubleValue];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:region.center];
    [annotation setTitle:@"We at Here"]; //You can set the subtitle too
    [MapView addAnnotation:annotation];
    
    if ([GetNameData length] == 0) {
        EditPlaceNameField.placeholder = @"Add place name";
    }else{
        EditPlaceNameField.text = GetNameData;
    }
    
    if ([GetAddressData length] == 0) {
        ShowAddress.text = @"Add address";
    }else{
        ShowAddress.text = GetAddressData;
    }
    
   // ShowAddress.text = GetAddressData;
    //EditPlaceNameField.text = GetNameData;
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
        if ([ShowAddress.text isEqualToString:@"Add address"]) {
            ShowAddress.text = @"";
        }else{
            
        }
        ShowAddress.textColor = [UIColor blackColor];

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [EditPlaceNameField resignFirstResponder];
    [ShowAddress resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [EditPlaceNameField resignFirstResponder];
    [ShowAddress resignFirstResponder];
    return YES;
}
-(IBAction)DoneButton:(id)sender{
    if ([EditPlaceNameField.text length] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:EditPlaceNameField.text forKey:@"PublishV2_Name"];
        [defaults setObject:ShowAddress.text forKey:@"PublishV2_Address"];
        [defaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
    

}
-(IBAction)ChangePinButton:(id)sender{
    [MapView removeAnnotations:MapView.annotations];
    
    LocationOnMapViewController *LocationOnMap = [[LocationOnMapViewController alloc]init];
    [self presentViewController:LocationOnMap animated:YES completion:nil];
}
@end
